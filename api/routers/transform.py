"""Apply XSLT (canonical to FHIR): POST /transform, /transform/{target}, /transform/{target}/content."""
import logging
import tempfile
from pathlib import Path

from fastapi import APIRouter, File, HTTPException, Query, UploadFile
from fastapi.responses import PlainTextResponse

from api.config import PROJECT_ROOT, get_builds, get_canonical_samples_dir, get_fhir_samples_dir

logger = logging.getLogger(__name__)

router = APIRouter()


def _fhir_output_name(xslt_path: str) -> str:
    """Derive FHIR output filename from XSLT path, e.g. roster-patient.xsl -> roster-patient-fhir.xml."""
    name = Path(xslt_path).name
    if name.endswith(".xsl"):
        return name[:-4] + "-fhir.xml"
    return name + "-fhir.xml"


def _run_transform(canonical_path: Path, xslt_path: Path, output_path: Path, return_content: bool = False):
    from tools.transform_roster import apply_xslt

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
def post_transform_target_content(target: str):
    """Run transform for target, return FHIR XML directly in response body."""
    target = target.strip().lower()
    builds = get_builds()
    matching = [b for b in builds if b.get("canonical_name") == target and b.get("transform_file")]
    if not matching:
        raise HTTPException(status_code=400, detail=f"No transform configured for target: {target}")
    b = matching[0]
    canonical_path = get_canonical_samples_dir() / b["output_file_name"]
    if not canonical_path.is_file():
        raise HTTPException(status_code=404, detail=f"Canonical sample not found: {b['output_file_name']}. Generate it first.")
    xslt_path = PROJECT_ROOT / b["transform_file"]
    if not xslt_path.is_file():
        raise HTTPException(status_code=503, detail=f"XSLT file not found: {b['transform_file']}")
    out_name = _fhir_output_name(b["transform_file"])
    output_path = get_fhir_samples_dir() / out_name
    try:
        content = _run_transform(canonical_path, xslt_path, output_path, return_content=True)
        return PlainTextResponse(content, media_type="application/xml")
    except Exception as e:
        logger.exception("Transform failed")
        raise HTTPException(status_code=500, detail=str(e)) from e


@router.post("/{target}")
def post_transform_target(
    target: str,
    content: int = Query(0, description="If 1, return FHIR XML in response body"),
):
    """Run transform for target. Uses build config for canonical sample and XSLT. Optional ?content=1 for XML in body."""
    target = target.strip().lower()
    builds = get_builds()
    matching = [b for b in builds if b.get("canonical_name") == target and b.get("transform_file")]
    if not matching:
        raise HTTPException(status_code=400, detail=f"No transform configured for target: {target}")
    b = matching[0]
    canonical_path = get_canonical_samples_dir() / b["output_file_name"]
    if not canonical_path.is_file():
        raise HTTPException(status_code=404, detail=f"Canonical sample not found: {b['output_file_name']}. Generate it first.")
    xslt_path = PROJECT_ROOT / b["transform_file"]
    if not xslt_path.is_file():
        raise HTTPException(status_code=503, detail=f"XSLT file not found: {b['transform_file']}")
    out_name = _fhir_output_name(b["transform_file"])
    output_path = get_fhir_samples_dir() / out_name
    try:
        body_content = _run_transform(canonical_path, xslt_path, output_path, return_content=(content == 1))
        if content == 1 and body_content:
            return PlainTextResponse(body_content, media_type="application/xml")
        return {"success": True, "output_file": out_name, "path": str(output_path)}
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
    fhir_dir = get_fhir_samples_dir()
    if body.get("target"):
        target = str(body["target"]).strip().lower()
        builds = get_builds()
        matching = [b for b in builds if b.get("canonical_name") == target and b.get("transform_file")]
        if not matching:
            raise HTTPException(status_code=400, detail=f"No transform configured for target: {target}")
        b = matching[0]
        canonical_path = canonical_dir / b["output_file_name"]
        xslt_path = PROJECT_ROOT / b["transform_file"]
        out_name = _fhir_output_name(b["transform_file"])
    elif body.get("canonical_file") and body.get("xslt_file"):
        canonical_path = canonical_dir / body["canonical_file"]
        xslt_path = PROJECT_ROOT / "transforms" / "v10.0" / body["xslt_file"]
        out_name = _fhir_output_name(str(xslt_path))
    else:
        raise HTTPException(status_code=400, detail="Provide 'target' or both 'canonical_file' and 'xslt_file'")

    if not canonical_path.is_file():
        raise HTTPException(status_code=404, detail=f"Canonical file not found: {canonical_path.name}")
    if not xslt_path.is_file():
        raise HTTPException(status_code=404, detail=f"XSLT file not found: {xslt_path.name}")
    output_path = fhir_dir / out_name
    try:
        body_content = _run_transform(canonical_path, xslt_path, output_path, return_content=(content == 1))
        if content == 1 and body_content:
            return PlainTextResponse(body_content, media_type="application/xml")
        return {"success": True, "output_file": out_name, "path": str(output_path)}
    except Exception as e:
        logger.exception("Transform failed")
        raise HTTPException(status_code=500, detail=str(e)) from e
