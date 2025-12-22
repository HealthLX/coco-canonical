"""Core model import detection and type parsing."""
from pathlib import Path
from .constants import ns, logger
from .validation import validate_xsd_file
from .exceptions import SchemaFileNotFoundError
from .simple_types import parse_simple_types
from .markdown_gen import to_md_table


def detect_core_model_import(root, xsd_path):
    """
    Detect if the schema imports the core model and return the path to Core-model.xsd.
    
    Args:
        root: The root element of the parsed XSD schema
        xsd_path: Path to the current XSD file
        
    Returns:
        Path to Core-model.xsd if found, None otherwise
    """
    try:
        core_namespace = "http://cocodata.org/core"
        
        # Find all import elements
        for import_elem in root.findall("./xs:import", ns):
            namespace = import_elem.get("namespace")
            schema_location = import_elem.get("schemaLocation")
            
            if namespace == core_namespace and schema_location:
                # Resolve relative path
                xsd_dir = Path(xsd_path).parent
                core_model_path = (xsd_dir / schema_location).resolve()
                
                # Check if file exists
                if core_model_path.exists():
                    return str(core_model_path)
                else:
                    logger.warning(f"Core model import found but file does not exist: {core_model_path}")
    except Exception as e:
        logger.warning(f"Error detecting core model import: {e}")
    
    return None


def parse_core_model_types(core_model_path):
    """
    Parse the Core-model.xsd file and extract its simple types.
    
    Args:
        core_model_path: Path to Core-model.xsd
        
    Returns:
        Dictionary mapping type names to their definitions
    """
    try:
        validate_xsd_file(core_model_path)
        from lxml import etree
        tree = etree.parse(core_model_path)
        root = tree.getroot()
        
        # Use existing parse_simple_types function
        simple_types = parse_simple_types(root)
        
        # Convert to dictionary for easy lookup
        core_types_dict = {}
        for st in simple_types:
            name = st[0]
            if name != "–":
                core_types_dict[name] = st
        
        return core_types_dict
    except SchemaFileNotFoundError:
        logger.warning(f"Core-model.xsd not found at {core_model_path}")
        return {}
    except Exception as e:
        logger.warning(f"Could not parse Core-model.xsd at {core_model_path}: {e}")
        return {}


def find_used_core_types(root):
    """
    Find which core model types are actually used in the schema.
    
    Args:
        root: The root element of the parsed XSD schema
        
    Returns:
        Set of core type names (without the 'core:' prefix) that are used
    """
    used_types = set()
    
    # Find all elements with type attributes starting with "core:"
    for elem in root.findall(".//xs:element", ns):
        elem_type = elem.get("type", "")
        if elem_type.startswith("core:"):
            type_name = elem_type.replace("core:", "")
            used_types.add(type_name)
    
    # Find all restrictions with base attributes starting with "core:"
    for restriction in root.findall(".//xs:restriction", ns):
        base = restriction.get("base", "")
        if base.startswith("core:"):
            type_name = base.replace("core:", "")
            used_types.add(type_name)
    
    return used_types


def generate_core_types_section(core_types_dict, used_types):
    """
    Generate the Core Model Types section for the documentation.
    
    Args:
        core_types_dict: Dictionary of all core model types
        used_types: Set of core type names that are actually used
        
    Returns:
        Markdown string for the Core Model Types section, or empty string if no types used
    """
    if not used_types:
        return ""
    
    # Filter to only include used types
    used_core_types = []
    for type_name in sorted(used_types):
        if type_name in core_types_dict:
            used_core_types.append(core_types_dict[type_name])
    
    if not used_core_types:
        return ""
    
    output = "## Core Model Types\n\n"
    output += "The following types are imported from the Core-model. "
    output += "See [Core-model Guide](Core-model_Guide.md) for complete documentation.\n\n"
    
    # Use 4-column format: Name, Base Type, Description, Pattern
    output += to_md_table(["Name", "Base Type", "Description", "Pattern"], used_core_types)
    
    output += "\n\n"
    
    return output

