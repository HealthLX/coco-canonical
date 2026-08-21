"""Generic structural XML -> JSON conversion: POST /convert/xml-to-json."""
import logging

from fastapi import APIRouter, HTTPException, Request
from fastapi.responses import Response
from lxml import etree

from tools.xml_to_json import xml_to_json_string

logger = logging.getLogger(__name__)

router = APIRouter()


@router.post("/xml-to-json")
async def post_convert_xml_to_json(request: Request):
    """Convert the posted XML body to structural JSON (not spec-canonical FHIR JSON).

    Works on canonical sample XML or FHIR transform output alike -- it converts exactly the
    XML it's handed, so callers with edited/in-memory XML get JSON for that content, not a
    server-side regeneration.
    """
    xml_bytes = await request.body()
    if not xml_bytes.strip():
        raise HTTPException(status_code=400, detail="Request body is empty; send the XML to convert.")
    try:
        json_text = xml_to_json_string(xml_bytes)
    except etree.XMLSyntaxError as e:
        raise HTTPException(status_code=400, detail=f"Input is not well-formed XML: {e.msg}") from e
    return Response(content=json_text, media_type="application/json")
