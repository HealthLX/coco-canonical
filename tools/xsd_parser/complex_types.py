"""Complex type parsing with extensions and restrictions."""
from typing import Dict, List
from .constants import ns, logger
from .exceptions import SchemaValidationError
from .utils import get_documentation
from .elements import extract_element_type_info


def parse_complex_types(root):
    """Parse complex types and extract their elements with full details, including extensions."""
    complex_types = {}
    
    try:
        for ct in root.findall("./xs:complexType", ns):
            try:
                name = ct.get("name", "–")
                if not name or name == "–":
                    continue
                
                elements = []
                base_type = None
                
                # Check for extension
                extension = ct.find("xs:extension", ns)
                if extension is not None:
                    base_type = extension.get("base", "")
                    # Parse elements from extension base
                    ct = extension  # Continue parsing from extension
                
                # Check for restriction
                restriction = ct.find("xs:restriction", ns)
                if restriction is not None:
                    base_type = restriction.get("base", "")
                    ct = restriction  # Continue parsing from restriction
                
                # Find all elements within the complex type
                for elem in ct.findall(".//xs:element", ns):
                    try:
                        field_name = elem.get("name", "–")
                        if not field_name or field_name == "–":
                            continue
                        
                        # Use enhanced type extraction
                        elem_type = extract_element_type_info(elem)
                        min_occurs = elem.get("minOccurs", "1")
                        max_occurs = elem.get("maxOccurs", "1")
                        doc = get_documentation(elem)
                        
                        # Include base type info if present
                        type_display = elem_type
                        if base_type and field_name:
                            type_display = f"{elem_type} (extends {base_type})" if base_type else elem_type
                        
                        elements.append([field_name, type_display, min_occurs, max_occurs, doc])
                    except Exception as e:
                        logger.warning(f"Error parsing element in complex type '{name}': {e}")
                        continue
                
                if elements or base_type:
                    # Include base type in first element or as metadata
                    if base_type and not elements:
                        # Complex type with only base, no additional elements
                        elements.append(["–", f"Extends {base_type}", "–", "–", "–"])
                    complex_types[name] = elements
            except Exception as e:
                logger.warning(f"Error parsing complex type: {e}")
                continue
    except Exception as e:
        logger.error(f"Error parsing complex types: {e}")
        raise SchemaValidationError(f"Failed to parse complex types: {e}")
    
    return complex_types


def generate_complex_type_table(name, elements):
    """Generate a markdown table for a single complex type."""
    from .markdown_gen import to_md_table
    output = f"<h3 style=\"color:#E60073\">{name}</h3>\n\n"
    output += to_md_table(["Field Name", "Type", "MinOccurs", "MaxOccurs", "Description"], elements)
    output += "\n\n"
    return output

