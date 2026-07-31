"""Apply XSLT (canonical to FHIR): POST /transform, /transform/{target}, /transform/{target}/content."""
import logging
import tempfile
import uuid
from pathlib import Path

from fastapi import APIRouter, File, HTTPException, Query, UploadFile
from fastapi.responses import PlainTextResponse, Response

from api.config import (
    PROJECT_ROOT,
    get_builds,
    get_canonical_samples_dir,
    get_fhir_samples_dir,
    get_transforms_dir,
)

logger = logging.getLogger(__name__)

router = APIRouter()


def _fhir_output_name(xslt_path: str, build: dict | None = None) -> str:
    """Derive FHIR output filename; matches tools.transform_schema.fhir_output_name."""
    from tools.transform_schema import fhir_output_name

    variant = (build or {}).get("provider_directory_child")
    return fhir_output_name(xslt_path, provider_variant=variant)


def _run_transform(canonical_path: Path, xslt_path: Path, output_path: Path, return_content: bool = False):
    from tools.transform_schema import apply_xslt

    base_dir = str(PROJECT_ROOT)
    canonical_str = str(canonical_path)
    xslt_str = str(xslt_path)
    output_str = str(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    if return_content:
        content = apply_xslt(base_dir, canonical_str, xslt_str, output_file=None)
        if output_path:
            output_path.write_text(content, encoding="utf-8")
        return content
    apply_xslt(base_dir, canonical_str, xslt_str, output_file=output_str)
    return None


def _get_transform_specs(build: dict) -> list[dict]:
    """Resolve a build's transforms (transform_dir + transform_file + transform_files).

    Delegates to tools.transform_schema so the HTTP API and CLI stay in lockstep, including
    folder-driven (``transform_dir``) configs resolved relative to the repo root.
    """
    from tools.transform_schema import collect_transform_specs

    return collect_transform_specs(build, PROJECT_ROOT)


def _select_build(target: str, provider_directory_child: str | None = None, canonical_file: str | None = None) -> dict:
    builds = get_builds()
    matching = [b for b in builds if b.get("canonical_name") == target and _get_transform_specs(b)]
    if provider_directory_child:
        child = provider_directory_child.strip().lower()
        matching = [b for b in matching if (b.get("provider_directory_child") or "").strip().lower() == child]
    if canonical_file:
        wanted = canonical_file.strip()
        matching = [b for b in matching if (b.get("output_file_name") or "").strip() == wanted]

    if not matching:
        raise HTTPException(status_code=400, detail=f"No transform configured for target: {target}")

    if len(matching) > 1:
        raise HTTPException(
            status_code=400,
            detail=(
                "Multiple transforms are configured for this target. "
                "Provide provider_directory_child or canonical_file to select one variant."
            ),
        )
    return matching[0]


def _multipart_xml_response(parts: list[dict]) -> Response:
    boundary = f"coco-{uuid.uuid4().hex}"
    chunks: list[bytes] = []
    for part in parts:
        filename = part["filename"]
        resource_type = part["resource_type"]
        content = part["content"]
        chunks.append(f"--{boundary}\r\n".encode("utf-8"))
        chunks.append(b"Content-Type: application/xml; charset=utf-8\r\n")
        chunks.append(
            (
                f"Content-Disposition: attachment; filename=\"{filename}\"; "
                f"name=\"{resource_type}\"\r\n\r\n"
            ).encode("utf-8")
        )
        chunks.append(content.encode("utf-8"))
        chunks.append(b"\r\n")
    chunks.append(f"--{boundary}--\r\n".encode("utf-8"))
    body = b"".join(chunks)
    return Response(content=body, media_type=f"multipart/xml; boundary={boundary}")


def _run_build_transforms(canonical_path: Path, build: dict, content: int = 0):
    transform_specs = _get_transform_specs(build)
    if not transform_specs:
        raise HTTPException(status_code=400, detail="No transforms configured for selected build")

    fhir_dir = get_fhir_samples_dir()
    if len(transform_specs) == 1:
        spec = transform_specs[0]
        xslt_path = PROJECT_ROOT / spec["transform_file"]
        if not xslt_path.is_file():
            raise HTTPException(status_code=503, detail=f"XSLT file not found: {spec['transform_file']}")
        out_name = _fhir_output_name(spec["transform_file"], build)
        output_path = fhir_dir / out_name
        body_content = _run_transform(canonical_path, xslt_path, output_path, return_content=(content == 1))
        if content == 1 and body_content:
            return PlainTextResponse(body_content, media_type="application/xml")
        return {"success": True, "output_file": out_name, "path": str(output_path)}

    parts = []
    output_files = []
    for spec in transform_specs:
        xslt_path = PROJECT_ROOT / spec["transform_file"]
        if not xslt_path.is_file():
            raise HTTPException(status_code=503, detail=f"XSLT file not found: {spec['transform_file']}")
        out_name = _fhir_output_name(spec["transform_file"], build)
        output_path = fhir_dir / out_name
        xml_content = _run_transform(canonical_path, xslt_path, output_path, return_content=True)
        parts.append({"filename": out_name, "resource_type": spec["resource_type"], "content": xml_content})
        output_files.append({"resource_type": spec["resource_type"], "output_file": out_name, "path": str(output_path)})

    if content == 1:
        return _multipart_xml_response(parts)
    return {"success": True, "output_files": output_files}


@router.post("/upload")
async def post_transform_upload(
    canonical_xml: UploadFile = File(..., description="Canonical XML file to transform"),
    xslt_file: UploadFile = File(..., description="XSLT stylesheet to apply"),
):
    """Transform a user-uploaded canonical XML using a user-uploaded XSLT. Returns FHIR XML."""
    canonical_content = await canonical_xml.read()
    xslt_content = await xslt_file.read()

    with tempfile.TemporaryDirectory() as tmp_dir:
        tmp_path = Path(tmp_dir)
        c_path = tmp_path / (canonical_xml.filename or "canonical.xml")
        x_path = tmp_path / (xslt_file.filename or "transform.xsl")
        out_path = tmp_path / "fhir-output.xml"

        c_path.write_bytes(canonical_content)
        x_path.write_bytes(xslt_content)

        try:
            content = _run_transform(c_path, x_path, out_path, return_content=True)
            return PlainTextResponse(content, media_type="application/xml")
        except Exception as e:
            logger.exception("Upload transform failed")
            raise HTTPException(status_code=500, detail=str(e)) from e
@router.post("/{target}/content")
def post_transform_target_content(
    target: str,
    provider_directory_child: str | None = Query(
        None, description="Optional. Use when multiple providerdirectory builds exist in config."
    ),
):
    """Run transform for target, return FHIR XML directly in response body."""
    target = target.strip().lower()
    b = _select_build(target, provider_directory_child=provider_directory_child)
    canonical_path = get_canonical_samples_dir() / b["output_file_name"]
    if not canonical_path.is_file():
        raise HTTPException(status_code=404, detail=f"Canonical sample not found: {b['output_file_name']}. Generate it first.")
    try:
        return _run_build_transforms(canonical_path, b, content=1)
    except HTTPException:
        raise
    except Exception as e:
        logger.exception("Transform failed")
        raise HTTPException(status_code=500, detail=str(e)) from e


@router.post("/{target}")
def post_transform_target(
    target: str,
    content: int = Query(0, description="If 1, return FHIR XML in response body"),
    provider_directory_child: str | None = Query(
        None, description="Optional. Use when multiple providerdirectory builds exist in config."
    ),
):
    """Run transform for target. Uses build config for canonical sample and XSLT. Optional ?content=1 for XML in body."""
    target = target.strip().lower()
    b = _select_build(target, provider_directory_child=provider_directory_child)
    canonical_path = get_canonical_samples_dir() / b["output_file_name"]
    if not canonical_path.is_file():
        raise HTTPException(status_code=404, detail=f"Canonical sample not found: {b['output_file_name']}. Generate it first.")
    try:
        return _run_build_transforms(canonical_path, b, content=content)
    except HTTPException:
        raise
    except Exception as e:
        logger.exception("Transform failed")
        raise HTTPException(status_code=500, detail=str(e)) from e


@router.post("")
def post_transform(
    body: dict,
    content: int = Query(0, description="If 1, return FHIR XML in response body"),
):
    """Run apply_xslt. Body: {\"target\": \"roster\"} or {\"canonical_file\": \"...\", \"xslt_file\": \"...\"}. Optional ?content=1 for FHIR in body."""
    canonical_dir = get_canonical_samples_dir()
    if body.get("target"):
        target = str(body["target"]).strip().lower()
        b = _select_build(
            target,
            provider_directory_child=body.get("provider_directory_child"),
            canonical_file=body.get("canonical_file"),
        )
        canonical_path = canonical_dir / b["output_file_name"]
    elif body.get("canonical_file") and body.get("xslt_file"):
        canonical_path = canonical_dir / body["canonical_file"]
        xslt_path = get_transforms_dir() / body["xslt_file"]
        out_name = _fhir_output_name(str(xslt_path))
        b = None
    else:
        raise HTTPException(status_code=400, detail="Provide 'target' or both 'canonical_file' and 'xslt_file'")

    if not canonical_path.is_file():
        raise HTTPException(status_code=404, detail=f"Canonical file not found: {canonical_path.name}")

    try:
        if b:
            return _run_build_transforms(canonical_path, b, content=content)
        if not xslt_path.is_file():
            raise HTTPException(status_code=404, detail=f"XSLT file not found: {xslt_path.name}")
        output_path = get_fhir_samples_dir() / out_name
        body_content = _run_transform(canonical_path, xslt_path, output_path, return_content=(content == 1))
        if content == 1 and body_content:
            return PlainTextResponse(body_content, media_type="application/xml")
        return {"success": True, "output_file": out_name, "path": str(output_path)}
    except HTTPException:
        raise
    except Exception as e:
        logger.exception("Transform failed")
        raise HTTPException(status_code=500, detail=str(e)) from e
