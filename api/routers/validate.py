"""Validate canonical XML against an XSD: POST /validate/{schema_name}, POST /validate/upload."""
import logging
import tempfile
from pathlib import Path

from fastapi import APIRouter, File, HTTPException, Request, UploadFile

from api.routers.artifacts import SCHEMAS_DIR, _safe_filename

logger = logging.getLogger(__name__)

router = APIRouter()

MAX_ERRORS = 50


def _validate_bytes(xml_bytes: bytes, xsd_path: Path) -> dict:
    from lxml import etree
    from tools.validate_xml import validate_xml

    with tempfile.TemporaryDirectory() as tmp_dir:
        xml_path = Path(tmp_dir) / "input.xml"
        xml_path.write_bytes(xml_bytes)
        try:
            is_valid, error_log = validate_xml(xml_path, xsd_path)
        except etree.XMLSyntaxError as e:
            return {
                "valid": False,
                "schema": xsd_path.name,
                "error_count": 1,
                "errors": [{"message": f"XML is not well-formed: {e.msg}", "path": None, "line": e.lineno}],
            }

    errors = [
        {"message": entry.message, "path": entry.path, "line": entry.line}
        for entry in list(error_log)[:MAX_ERRORS]
    ]
    return {
        "valid": bool(is_valid),
        "schema": xsd_path.name,
        "error_count": len(error_log),
        "errors": errors,
    }


# /upload must be declared before /{schema_name} so Starlette matches the literal route first.
@router.post("/upload")
async def validate_upload(
    xml_file: UploadFile = File(..., description="Canonical XML file to validate"),
    xsd_file: UploadFile = File(..., description="XSD schema to validate against"),
):
    """Validate a user-uploaded canonical XML against a user-uploaded XSD."""
    xml_bytes = await xml_file.read()
    xsd_bytes = await xsd_file.read()

    with tempfile.TemporaryDirectory() as tmp_dir:
        xsd_path = Path(tmp_dir) / (xsd_file.filename or "schema.xsd")
        xsd_path.write_bytes(xsd_bytes)
        try:
            return _validate_bytes(xml_bytes, xsd_path)
        except Exception as e:
            logger.exception("Upload validation failed")
            raise HTTPException(status_code=500, detail=str(e)) from e


@router.post("/{schema_name}")
async def validate_against_schema(schema_name: str, request: Request):
    """Validate raw canonical XML (request body) against schemas/v10.0/{schema_name}."""
    if not _safe_filename(schema_name):
        raise HTTPException(status_code=400, detail="Invalid schema name")
    xsd_path = SCHEMAS_DIR / schema_name
    if not xsd_path.is_file():
        raise HTTPException(status_code=404, detail=f"Schema not found: {schema_name}")

    xml_bytes = await request.body()
    if not xml_bytes.strip():
        raise HTTPException(status_code=400, detail="Request body is empty; send the XML to validate.")

    try:
        return _validate_bytes(xml_bytes, xsd_path)
    except Exception as e:
        logger.exception("Validation failed")
        raise HTTPException(status_code=500, detail=str(e)) from e
