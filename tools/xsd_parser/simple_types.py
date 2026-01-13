"""Simple type parsing with enumerations and facets."""
from typing import List
from .constants import ns, logger
from .exceptions import SchemaValidationError
from .utils import get_documentation


def extract_enumerations(restriction_elem) -> str:
    """Extract enumeration values from a restriction element."""
    if restriction_elem is None:
        return "–"
    
    enum_values = []
    for enum in restriction_elem.findall("xs:enumeration", ns):
        value = enum.get("value", "")
        if value:
            enum_values.append(value)
    
    if enum_values:
        return ", ".join(enum_values)
    return "–"


def extract_facets(restriction_elem) -> str:
    """Extract all facets (minLength, maxLength, minInclusive, maxInclusive, etc.) from a restriction.
    
    NOTE: This function is not currently used but is kept for future use.
    It can be used to display constraint information (length limits, value ranges, etc.)
    in the Simple Types table documentation.
    """
    if restriction_elem is None:
        return "–"
    
    facets = []
    
    # Length facets
    min_length = restriction_elem.find("xs:minLength", ns)
    max_length = restriction_elem.find("xs:maxLength", ns)
    if min_length is not None or max_length is not None:
        min_val = min_length.get("value", "") if min_length is not None else ""
        max_val = max_length.get("value", "") if max_length is not None else ""
        if min_val and max_val:
            facets.append(f"Length: {min_val}-{max_val}")
        elif min_val:
            facets.append(f"MinLength: {min_val}")
        elif max_val:
            facets.append(f"MaxLength: {max_val}")
    
    # Inclusive facets
    min_inclusive = restriction_elem.find("xs:minInclusive", ns)
    max_inclusive = restriction_elem.find("xs:maxInclusive", ns)
    if min_inclusive is not None or max_inclusive is not None:
        min_val = min_inclusive.get("value", "") if min_inclusive is not None else ""
        max_val = max_inclusive.get("value", "") if max_inclusive is not None else ""
        if min_val and max_val:
            facets.append(f"Range: {min_val}-{max_val}")
        elif min_val:
            facets.append(f"MinInclusive: {min_val}")
        elif max_val:
            facets.append(f"MaxInclusive: {max_val}")
    
    # Exclusive facets
    min_exclusive = restriction_elem.find("xs:minExclusive", ns)
    max_exclusive = restriction_elem.find("xs:maxExclusive", ns)
    if min_exclusive is not None or max_exclusive is not None:
        min_val = min_exclusive.get("value", "") if min_exclusive is not None else ""
        max_val = max_exclusive.get("value", "") if max_exclusive is not None else ""
        if min_val:
            facets.append(f"MinExclusive: {min_val}")
        if max_val:
            facets.append(f"MaxExclusive: {max_val}")
    
    if facets:
        return "; ".join(facets)
    return "–"


def parse_simple_types(root):
    """Parse simple types and return 4 columns: Name, Base Type, Description, Pattern."""
    simple_types = []
    try:
        for st in root.findall("./xs:simpleType", ns):
            try:
                name = st.get("name", "–")
                if not name or name == "–":
                    logger.warning(f"Skipping simple type without name attribute")
                    continue
                
                restriction = st.find("xs:restriction", ns)
                base = restriction.get("base", "–") if restriction is not None else "–"
                doc = get_documentation(st)
                
                # Extract pattern (show directly without prefix)
                pattern_value = ""
                if restriction is not None:
                    pattern = restriction.find("xs:pattern", ns)
                    if pattern is not None:
                        pattern_value = pattern.get("value", "")
                
                # Return 4 columns: Name, Base Type, Description, Pattern
                simple_types.append([name, base, doc, pattern_value])
            except Exception as e:
                logger.warning(f"Error parsing simple type: {e}")
                continue
    except Exception as e:
        logger.error(f"Error parsing simple types: {e}")
        raise SchemaValidationError(f"Failed to parse simple types: {e}")
    
    return simple_types

