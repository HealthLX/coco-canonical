import os
import sys
from pathlib import Path
from lxml import etree

def validate_xml(xml_path, xsd_path):
    """
    Validate an XML file against an XSD schema using lxml.
    
    Args:
        xml_path: Path to the XML file to validate
        xsd_path: Path to the XSD schema file
        
    Returns:
        tuple: (is_valid: bool, error_log: list)
    """
    # Convert to Path objects if strings
    xml_path = Path(xml_path)
    xsd_path = Path(xsd_path)
    
    # Check if files exist
    if not xsd_path.exists():
        raise FileNotFoundError(f"XSD schema file not found: {xsd_path}")
    if not xml_path.exists():
        raise FileNotFoundError(f"XML file not found: {xml_path}")
    
    # Parse and validate
    with open(xsd_path, 'rb') as f:
        schema_doc = etree.parse(f)
    schema = etree.XMLSchema(schema_doc)

    with open(xml_path, 'rb') as f:
        xml_doc = etree.parse(f)

    is_valid = schema.validate(xml_doc)
    return is_valid, schema.error_log


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
        description="Validate XML file against an XSD schema.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python validate_xml.py sample.xml schema.xsd
  python -m tools.validate_xml sample.xml schema.xsd
        """
    )
    parser.add_argument("xml", type=Path, help="Path to the XML file")
    parser.add_argument("xsd", type=Path, help="Path to the XSD schema file")

    args = parser.parse_args()
    
    try:
        is_valid, errors = validate_xml(args.xml, args.xsd)

        if is_valid:
            print("✅ XML is valid")
            sys.exit(0)
        else:
            print("❌ XML is NOT valid")
            print(f"\nFound {len(errors)} validation error(s):\n")
            for idx, err in enumerate(errors, 1):
                print(f"  [{idx}] {err}")
            sys.exit(1)
    except FileNotFoundError as e:
        print(f"❌ Error: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"❌ Unexpected error: {e}", file=sys.stderr)
        sys.exit(1)