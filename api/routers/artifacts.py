"""List and download schemas and transforms for the API's configured schema version."""
from pathlib import Path

from fastapi import APIRouter, HTTPException
from fastapi.responses import FileResponse

from api.config import get_schema_version, get_schemas_dir, get_transforms_dir

router = APIRouter()


def _safe_filename(name: str) -> bool:
    return name and "/" not in name and "\\" not in name and ".." not in name


@router.get("/schemas")
def list_schemas():
    """List every schema filename in schemas/<version>/."""
    schemas_dir = get_schemas_dir()
    if not schemas_dir.is_dir():
        return []
    return sorted(p.name for p in schemas_dir.iterdir() if p.is_file())


@router.get("/schemas/{filename}")
def get_schema_file(filename: str):
    """Serve one schema file for the configured version (e.g. Roster.xsd, Core-Model.xsd)."""
    if not _safe_filename(filename):
        raise HTTPException(status_code=400, detail="Invalid filename")
    path = get_schemas_dir() / filename
    if not path.is_file():
        raise HTTPException(
            status_code=404,
            detail=f"Schema not found in {get_schema_version()}: {filename}",
        )
    return FileResponse(path, media_type="application/xml", filename=filename)


@router.get("/transforms")
def list_transforms():
    """List every XSLT under transforms/<version>/, recursively.

    Transforms are organized into schema subfolders (Clinical/, EOB/, Formulary/,
    Provider-Directory/, Roster/, Core-Model/), so paths are returned relative to
    transforms/<version>/ using forward slashes (e.g. "Clinical/Clinical_Patient.xsl").

    Returns [] when the configured version has no transforms folder yet.
    """
    transforms_dir = get_transforms_dir()
    if not transforms_dir.is_dir():
        return []
    return sorted(
        p.relative_to(transforms_dir).as_posix()
        for p in transforms_dir.rglob("*")
        if p.is_file()
    )


@router.get("/transforms/{filename:path}")
def get_transform_file(filename: str):
    """Serve one XSLT file by its relative path (e.g. Clinical/Clinical_Patient.xsl)."""
    if not filename or ".." in filename or filename.startswith(("/", "\\")):
        raise HTTPException(status_code=400, detail="Invalid filename")
    transforms_dir = get_transforms_dir()
    path = (transforms_dir / filename).resolve()
    # Guard against path traversal: resolved path must stay within transforms_dir.
    if transforms_dir.resolve() not in path.parents or not path.is_file():
        raise HTTPException(
            status_code=404,
            detail=f"Transform not found in {get_schema_version()}: {filename}",
        )
    return FileResponse(path, media_type="application/xml", filename=path.name)
