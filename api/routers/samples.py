"""Sample building and listing: generate canonical samples, list/download canonical and FHIR samples."""
import logging
from pathlib import Path

from fastapi import APIRouter, HTTPException, Query
from fastapi.responses import FileResponse, PlainTextResponse

from api.config import PROJECT_ROOT, get_builds

logger = logging.getLogger(__name__)

router = APIRouter()

CANONICAL_SAMPLES_DIR = PROJECT_ROOT / "canonical-samples" / "v10.0"
FHIR_SAMPLES_DIR = PROJECT_ROOT / "fhir-samples" / "v10.0"


def _safe_filename(name: str) -> bool:
    """Ensure filename is a single segment with no path traversal."""
    return name and "/" not in name and "\\" not in name and ".." not in name


def _run_build_for_target(target: str) -> list[dict]:
    """Run sample builder for one canonical target (may be multiple builds, e.g. providerdirectory)."""
    from tools.build_all_sample_files import build_sample_file

    builds = get_builds()
    matching = [b for b in builds if b.get("canonical_name") == target]
    if not matching:
        raise ValueError(f"Unknown target: {target}")

    results = []
    for b in matching:
        try:
            build_sample_file(
                canonical_name=b["canonical_name"],
                root_element_name=b["root_element_name"],
                schema_file_name=b["schema_file_name"],
                output_file_name=b["output_file_name"],
                provider_directory_child=b.get("provider_directory_child"),
            )
            out_path = CANONICAL_SAMPLES_DIR / b["output_file_name"]
            results.append({"file": b["output_file_name"], "path": str(out_path), "success": True})
        except Exception as e:
            logger.exception("Build failed for %s", b.get("output_file_name"))
            results.append({"file": b["output_file_name"], "success": False, "detail": str(e)})
    return results


def _run_build_all() -> list[dict]:
    """Run sample builder for all builds."""
    from tools.build_all_sample_files import build_sample_file

    builds = get_builds()
    results = []
    for b in builds:
        try:
            build_sample_file(
                canonical_name=b["canonical_name"],
                root_element_name=b["root_element_name"],
                schema_file_name=b["schema_file_name"],
                output_file_name=b["output_file_name"],
                provider_directory_child=b.get("provider_directory_child"),
            )
            out_path = CANONICAL_SAMPLES_DIR / b["output_file_name"]
            results.append({"file": b["output_file_name"], "path": str(out_path), "success": True})
        except Exception as e:
            logger.exception("Build failed for %s", b.get("output_file_name"))
            results.append({"file": b["output_file_name"], "success": False, "detail": str(e)})
    return results


@router.post("/generate")
def post_generate(body: dict):
    """Generate sample(s): body {\"target\": \"roster\"} or {\"all\": true}. Returns which files were written."""
    try:
        if body.get("all"):
            results = _run_build_all()
        elif body.get("target"):
            results = _run_build_for_target(str(body["target"]).strip().lower())
        else:
            raise HTTPException(status_code=400, detail="Provide 'target' or 'all': true in body")
        return {"results": results, "success": all(r.get("success") for r in results)}
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e)) from e
    except FileNotFoundError as e:
        raise HTTPException(status_code=503, detail=str(e)) from e


@router.post("/generate/{target}/content")
def post_generate_target_content(
    target: str,
    format: str = Query("xml", description="Response format: xml or json"),
):
    """Generate sample for target, then return the generated XML in the response body."""
    target = target.strip().lower()
    try:
        results = _run_build_for_target(target)
        if not results or not results[0].get("success"):
            raise HTTPException(status_code=500, detail=results[0].get("detail", "Build failed") if results else "No builds")
        # Return first generated file content (for multi-build targets we return first)
        first = results[0]
        path = Path(first["path"])
        if not path.exists():
            raise HTTPException(status_code=500, detail="Generated file not found")
        if format == "json":
            import base64
            text = path.read_text(encoding="utf-8")
            return {"file": first["file"], "content_base64": base64.b64encode(text.encode("utf-8")).decode("ascii"), "format": "xml"}
        return PlainTextResponse(path.read_text(encoding="utf-8"), media_type="application/xml")
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e)) from e
    except FileNotFoundError as e:
        raise HTTPException(status_code=503, detail=str(e)) from e


@router.post("/generate/{target}")
def post_generate_target(target: str):
    """Generate sample for target (e.g. roster). Same as POST /generate with body {\"target\": \"roster\"}."""
    target = target.strip().lower()
    try:
        results = _run_build_for_target(target)
        return {"results": results, "success": all(r.get("success") for r in results)}
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e)) from e
    except FileNotFoundError as e:
        raise HTTPException(status_code=503, detail=str(e)) from e


def _list_dir_entries(dir_path: Path) -> list[dict]:
    if not dir_path.is_dir():
        return []
    entries = []
    for p in sorted(dir_path.iterdir()):
        if p.is_file():
            stat = p.stat()
            entries.append({"name": p.name, "path": str(p), "size": stat.st_size})
    return entries


@router.get("")
def list_samples():
    """List all sample files (canonical + FHIR): names and paths (optional metadata)."""
    canonical = _list_dir_entries(CANONICAL_SAMPLES_DIR)
    fhir = _list_dir_entries(FHIR_SAMPLES_DIR)
    return {"canonical": canonical, "fhir": fhir}


@router.get("/canonical")
def list_canonical():
    """List canonical sample filenames only."""
    if not CANONICAL_SAMPLES_DIR.is_dir():
        return []
    return sorted(p.name for p in CANONICAL_SAMPLES_DIR.iterdir() if p.is_file())


@router.get("/fhir")
def list_fhir():
    """List FHIR sample filenames only."""
    if not FHIR_SAMPLES_DIR.is_dir():
        return []
    return sorted(p.name for p in FHIR_SAMPLES_DIR.iterdir() if p.is_file())


@router.get("/canonical/{filename}/regenerate")
def get_canonical_regenerate(filename: str):
    """Regenerate this sample (by matching output_file_name in config), then serve the file."""
    if not _safe_filename(filename):
        raise HTTPException(status_code=400, detail="Invalid filename")
    builds = get_builds()
    match = next((b for b in builds if b.get("output_file_name") == filename), None)
    if not match:
        raise HTTPException(status_code=404, detail=f"No build with output_file_name: {filename}")
    try:
        from tools.build_all_sample_files import build_sample_file
        build_sample_file(
            canonical_name=match["canonical_name"],
            root_element_name=match["root_element_name"],
            schema_file_name=match["schema_file_name"],
            output_file_name=match["output_file_name"],
            provider_directory_child=match.get("provider_directory_child"),
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) from e
    path = CANONICAL_SAMPLES_DIR / filename
    if not path.is_file():
        raise HTTPException(status_code=500, detail="Generated file not found")
    return FileResponse(path, media_type="application/xml", filename=filename)


@router.get("/canonical/{filename}")
def get_canonical_file(filename: str):
    """Serve one canonical sample XML file."""
    if not _safe_filename(filename):
        raise HTTPException(status_code=400, detail="Invalid filename")
    path = CANONICAL_SAMPLES_DIR / filename
    if not path.is_file():
        raise HTTPException(status_code=404, detail=f"File not found: {filename}")
    return FileResponse(path, media_type="application/xml", filename=filename)


@router.get("/fhir/{filename}")
def get_fhir_file(filename: str):
    """Serve one FHIR sample XML file."""
    if not _safe_filename(filename):
        raise HTTPException(status_code=400, detail="Invalid filename")
    path = FHIR_SAMPLES_DIR / filename
    if not path.is_file():
        raise HTTPException(status_code=404, detail=f"File not found: {filename}")
    return FileResponse(path, media_type="application/xml", filename=filename)
