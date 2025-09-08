import os
from lxml import etree

def validate_xml(xml_path, xsd_path):
    """Validate an XML file against an XSD schema using lxml."""
    with open(xsd_path, 'rb') as f:
        schema_doc = etree.parse(f)
    schema = etree.XMLSchema(schema_doc)

    with open(xml_path, 'rb') as f:
        xml_doc = etree.parse(f)

    is_valid = schema.validate(xml_doc)
    return is_valid, schema.error_log


if __name__ == "__main__":
    import argparse
    from pathlib import Path

    parser = argparse.ArgumentParser(description="Validate XML file against an XSD schema.")
    parser.add_argument("xml", type=Path, help="Path to the XML file")
    parser.add_argument("xsd", type=Path, help="Path to the XSD schema file")

    args = parser.parse_args()
    is_valid, errors = validate_xml(args.xml, args.xsd)

    if is_valid:
        print("✅ XML is valid")
    else:
        print("❌ XML is NOT valid")
        for err in errors:
            print("-", err)