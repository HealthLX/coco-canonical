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
            # Check if this is a Core-Model file (library schema without root elements)
            is_core_model = (
                "core" in schema_info.display_name.lower() and "model" in schema_info.display_name.lower()
            ) or "core-model" in schema_info.file_path.lower()
            
            if is_core_model:
                logger.info(f"Core-Model file detected: {schema_info.display_name}. This is a library schema without root elements (expected).")
            else:
                warnings.append(f"Root element '{schema_info.root_element}' not found in schema")
        
        # Check for groups and verify their elements are documented
        groups = root.findall("./xs:group", ns)
        if groups:
            logger.info(f"Found {len(groups)} group definition(s) in schema")
            # Extract all element names from groups
            from .elements import parse_group_reference
            group_element_names = set()
            for group in groups:
                group_name = group.get("name")
                if group_name:
                    # Parse group to get its elements
                    group_elements = parse_group_reference(root, group_name)
                    for elem_row in group_elements:
                        if len(elem_row) > 0 and elem_row[0] and elem_row[0] != "–":
                            group_element_names.add(elem_row[0])
            
            # Check if group elements are documented (either in all_elements or as complex type fields)
            if group_element_names:
                # Get all documented element names from root elements
                documented_element_names = {elem[0] for elem in all_elements if len(elem) > 0 and elem[0] and elem[0] != "–"}
                # Also check complex type field names
                documented_complex_field_names = set()
                for ct_name, ct_elements in complex_types.items():
                    for field_row in ct_elements:
                        if len(field_row) > 0 and field_row[0] and field_row[0] != "–":
                            documented_complex_field_names.add(field_row[0])
                
                # Combine all documented names
                all_documented_names = documented_element_names.union(documented_complex_field_names)
                missing_group_elements = group_element_names - all_documented_names
                if missing_group_elements:
                    warnings.append(f"Undocumented group elements: {', '.join(sorted(missing_group_elements))}")
        
    except Exception as e:
        logger.warning(f"Error during coverage verification: {e}")
    
    return warnings

