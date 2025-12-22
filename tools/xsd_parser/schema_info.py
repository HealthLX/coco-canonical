"""Schema information extraction and utilities."""
from lxml import etree
from pathlib import Path
from dataclasses import dataclass
import re
from .constants import ns, logger
from .exceptions import SchemaValidationError


def extract_schema_name_from_filename(xsd_path: str) -> str:
    """
    Extract the schema name from an XSD filename.
    
    Args:
        xsd_path: Path to the XSD file (e.g., "schemas/Clinical.xsd")
        
    Returns:
        The filename without extension (e.g., "Clinical")
    """
    return Path(xsd_path).stem


def format_schema_name(filename_stem: str) -> str:
    """
    Format filename stem into human-readable schema name.
    
    Examples:
        "Roster" → "Roster"
        "ProviderDirectory" → "Provider Directory"
    """
    formatted = re.sub(r'(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])', ' ', filename_stem)
    return formatted


def get_root_element_name(xsd_path: str, schema_name: str) -> str:
    """
    Get the root element name for parsing the XSD structure.
    
    Args:
        xsd_path: Path to the XSD file
        schema_name: The schema name from filename
        
    Returns:
        The root element name to use for parsing
    """
    try:
        tree = etree.parse(xsd_path)
        root = tree.getroot()
        
        # Find the first top-level element definition
        root_element = root.find("./xs:element[@name]", ns)
        if root_element is not None:
            name = root_element.get("name")
            if name:
                return name
        
        # Fallback to lowercase schema name
        logger.warning(f"No root element found in {xsd_path}. Using filename as schema name.")
        return schema_name.lower()
    except Exception as e:
        logger.warning(f"Error finding root element in {xsd_path}: {e}. Using filename as schema name.")
        return schema_name.lower()


@dataclass
class SchemaInfo:
    """Container for schema metadata"""
    root_element: str      # e.g., "roster", "clinicals" (for XML parsing)
    display_name: str      # e.g., "Roster", "Clinical" (for documentation)
    file_path: str         # e.g., "schemas/Roster.xsd"
    version: str           # e.g., "6.1"
    
    @classmethod
    def from_xsd(cls, xsd_path: str) -> 'SchemaInfo':
        """
        Factory method to create SchemaInfo from XSD file.
        
        Args:
            xsd_path: Path to the XSD file
            
        Returns:
            SchemaInfo instance with extracted metadata
            
        Raises:
            SchemaValidationError: If schema cannot be parsed or required information is missing
        """
        try:
            tree = etree.parse(xsd_path)
            root = tree.getroot()
        except Exception as e:
            raise SchemaValidationError(f"Failed to parse XSD file {xsd_path}: {e}")
        
        # Extract schema name from filename
        schema_name = extract_schema_name_from_filename(xsd_path)
        
        # Format display name (e.g., "ProviderDirectory" → "Provider Directory")
        display_name = format_schema_name(schema_name)
        
        # Get actual root element name for parsing
        root_elem_name = get_root_element_name(xsd_path, schema_name)
        
        # Extract version
        version = root.get("version", "1.0")
        
        return cls(
            root_element=root_elem_name,
            display_name=display_name,
            file_path=xsd_path,
            version=version
        )

