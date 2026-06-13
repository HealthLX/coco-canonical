"""List and download schemas (v10.0) and transforms (v10.0)."""
from pathlib import Path

from fastapi import APIRouter, HTTPException
from fastapi.responses import FileResponse

from api.config import PROJECT_ROOT

router = APIRouter()

SCHEMAS_DIR = PROJECT_ROOT / "schemas" / "v10.0"
TRANSFORMS_DIR = PROJECT_ROOT / "transforms" / "v10.0"


def _safe_filename(name: str) -> bool:
    return name and "/" not in name and "\\" not in name and ".." not in name


@router.get("/schemas")
def list_schemas():
    """List every schema filename in schemas/v10.0/."""
    if not SCHEMAS_DIR.is_dir():
        return []
    return sorted(p.name for p in SCHEMAS_DIR.iterdir() if p.is_file())


@router.get("/schemas/{filename}")
def get_schema_file(filename: str):
    """Serve one v10.0 schema file (e.g. Roster.xsd, Core-Model.xsd)."""
    if not _safe_filename(filename):
        raise HTTPException(status_code=400, detail="Invalid filename")
    path = SCHEMAS_DIR / filename
    if not path.is_file():
        raise HTTPException(status_code=404, detail=f"Schema not found: {filename}")
    return FileResponse(path, media_type="application/xml", filename=filename)


@router.get("/transforms")
def list_transforms():
    """List every XSLT under transforms/v10.0/, recursively.

    Transforms are organized into schema subfolders (Clinical/, EOB/, Formulary/,
    Provider-Directory/, Roster/, Core-Model/), so paths are returned relative to
    transforms/v10.0/ using forward slashes (e.g. "Clinical/Clinical_Patient.xsl").
    """
    if not TRANSFORMS_DIR.is_dir():
        return []
    return sorted(
        p.relative_to(TRANSFORMS_DIR).as_posix()
        for p in TRANSFORMS_DIR.rglob("*")
        if p.is_file()
    )


@router.get("/transforms/{filename:path}")
def get_transform_file(filename: str):
    """Serve one v10.0 XSLT file by its relative path (e.g. Clinical/Clinical_Patient.xsl)."""
    if not filename or ".." in filename or filename.startswith(("/", "\\")):
        raise HTTPException(status_code=400, detail="Invalid filename")
    path = (TRANSFORMS_DIR / filename).resolve()
    # Guard against path traversal: resolved path must stay within TRANSFORMS_DIR.
    if TRANSFORMS_DIR.resolve() not in path.parents or not path.is_file():
        raise HTTPException(status_code=404, detail=f"Transform not found: {filename}")
    return FileResponse(path, media_type="application/xml", filename=path.name)
