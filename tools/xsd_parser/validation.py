"""Validation and coverage verification functions."""
from pathlib import Path
from .constants import ns, logger
from .exceptions import SchemaFileNotFoundError, SchemaValidationError


def validate_xsd_file(xsd_path: str) -> None:
    """Validate that XSD file exists and is readable."""
    xsd_file = Path(xsd_path)
    if not xsd_file.exists():
        raise SchemaFileNotFoundError(f"XSD file not found: {xsd_path}")
    if not xsd_file.is_file():
        raise SchemaValidationError(f"Path is not a file: {xsd_path}")
    if not xsd_file.suffix.lower() == '.xsd':
        logger.warning(f"File does not have .xsd extension: {xsd_path}")


def validate_schema_structure(root) -> None:
    """Validate basic schema structure."""
    if root.tag != f"{{{ns['xs']}}}schema":
        raise SchemaValidationError(f"Root element is not xs:schema, got {root.tag}")
    
    # Check for namespace
    target_namespace = root.get("targetNamespace")
    if not target_namespace:
        logger.warning("Schema does not have targetNamespace attribute")


def verify_schema_coverage(root, schema_info, simple_types, complex_types, all_elements):
    """Verify that all schema elements are covered in documentation."""
    warnings = []
    
    try:
        # Check all top-level simple types are documented
        all_simple_type_names = {st.get("name") for st in root.findall("./xs:simpleType", ns) if st.get("name")}
        documented_simple_names = {st[0] for st in simple_types if st[0] != "–"}
        missing_simple = all_simple_type_names - documented_simple_names
        if missing_simple:
            warnings.append(f"Undocumented simple types: {', '.join(sorted(missing_simple))}")
        
        # Check all top-level complex types are documented
        all_complex_type_names = {ct.get("name") for ct in root.findall("./xs:complexType", ns) if ct.get("name")}
        documented_complex_names = set(complex_types.keys())
        missing_complex = all_complex_type_names - documented_complex_names
        if missing_complex:
            warnings.append(f"Undocumented complex types: {', '.join(sorted(missing_complex))}")
        
        # Check root element exists
        root_elem = root.find(f"./xs:element[@name='{schema_info.root_element}']", ns)
        if root_elem is None:
            warnings.append(f"Root element '{schema_info.root_element}' not found in schema")
        
        # Check for groups
        groups = root.findall("./xs:group", ns)
        if groups:
            logger.info(f"Found {len(groups)} group definition(s) in schema")
        
    except Exception as e:
        logger.warning(f"Error during coverage verification: {e}")
    
    return warnings

