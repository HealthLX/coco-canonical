"""
Dependency-free, server-side XML -> JSON conversion for a *structural* export.

NOTE: This is a generic structural mapping (elements -> keys, repeated siblings -> arrays,
attributes -> "@name"). It is intentionally NOT spec-canonical FHIR JSON -- FHIR has specific
JSON rules (value[x] typing, primitive extensions, choice elements) that a generic converter
cannot honor. Conformant FHIR JSON comes from the commercial HealthLX mappings. This is an
export convenience, not a replacement for those mappings.

Mirrors coco-flow's src/lib/xmlToJson.ts rule-for-rule so the browser preview and this
server-side export never visibly disagree.
"""
from lxml import etree

JsonValue = str | dict | list


def _local_attr_key(elem: etree._Element, clark_name: str) -> str:
    """Clark-notation attribute name -> "@prefix:local" (or "@local"), matching el.attributes'
    unstripped attr.name in the JS version."""
    if clark_name.startswith("{"):
        uri, local = clark_name[1:].split("}", 1)
        prefix = next((p for p, ns in elem.nsmap.items() if ns == uri and p), None)
        return f"@{prefix}:{local}" if prefix else f"@{local}"
    return f"@{clark_name}"


def element_to_value(elem: etree._Element) -> JsonValue:
    obj: dict[str, JsonValue] = {}

    for clark_name, value in elem.attrib.items():
        obj[_local_attr_key(elem, clark_name)] = value

    child_els = [c for c in elem if isinstance(c.tag, str)]

    if not child_els:
        text = (elem.text or "").strip()
        if not obj:
            return text
        if text:
            obj["#text"] = text
        return obj

    for child in child_els:
        key = etree.QName(child).localname
        value = element_to_value(child)
        existing = obj.get(key)
        if key not in obj:
            obj[key] = value
        elif isinstance(existing, list):
            existing.append(value)
        else:
            obj[key] = [existing, value]

    return obj


def xml_to_json(xml_input: str | bytes) -> dict:
    """Parse XML and return {root_localname: element_to_value(root)}.

    Raises lxml.etree.XMLSyntaxError on malformed input.
    """
    xml_bytes = xml_input.encode("utf-8") if isinstance(xml_input, str) else xml_input
    root = etree.fromstring(xml_bytes)
    return {etree.QName(root).localname: element_to_value(root)}


def xml_to_json_string(xml_input: str | bytes, indent: int = 2) -> str:
    import json

    return json.dumps(xml_to_json(xml_input), indent=indent, ensure_ascii=False)
