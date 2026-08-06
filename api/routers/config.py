"""Discovery and config: GET /builds, /canonicals, /config."""
from fastapi import APIRouter, HTTPException

from api.config import get_builds, get_canonicals, load_config

router = APIRouter()


@router.get("/builds")
def list_builds():
    """List all sample builds from config (for 'select canonical')."""
    try:
        return get_builds()
    except FileNotFoundError as e:
        raise HTTPException(status_code=503, detail=str(e)) from e


@router.get("/canonicals")
def list_canonicals():
    """List unique canonical names only (roster, eob, formulary, etc.)."""
    try:
        return get_canonicals()
    except FileNotFoundError as e:
        raise HTTPException(status_code=503, detail=str(e)) from e


@router.get("/config")
def get_config():
    """Return full sample_builds.yaml (builds + core_schema_path)."""
    try:
        return load_config()
    except FileNotFoundError as e:
        raise HTTPException(status_code=503, detail=str(e)) from e
