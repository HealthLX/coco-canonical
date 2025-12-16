from lxml import etree
from pathlib import Path
from datetime import datetime
from dataclasses import dataclass
import sys
import re

ns = {"xs": "http://www.w3.org/2001/XMLSchema"}


def extract_schema_name_from_filename(xsd_path: str) -> str:
    """
    Extract the schema name from an XSD filename.
    
    Args:
        xsd_path: Path to the XSD file (e.g., "schemas/Clinical.xsd")
        
    Returns:
        The filename without extension (e.g., "Clinical")
        
    Examples:
        "schemas/Roster.xsd" → "Roster"
        "Clinical.xsd" → "Clinical"
        "/path/to/EOB.xsd" → "EOB"
    """
    return Path(xsd_path).stem


def format_schema_name(filename_stem: str) -> str:
    """
    Format filename stem into human-readable schema name.
    
    Examples:
        "Roster" → "Roster"
        "Clinical" → "Clinical"
        "EOB" → "EOB"
        "Formulary" → "Formulary"
        "ProviderDirectory" → "Provider Directory"
        
    Args:
        filename_stem: The filename without extension
        
    Returns:
        Formatted schema name for documentation
    """
    # Insert space before capital letters that are followed by lowercase letters
    # This preserves acronyms like "EOB" while splitting "ProviderDirectory"
    # Pattern: Insert space before uppercase letter that is either:
    # 1. Preceded by a lowercase letter, OR
    # 2. Followed by a lowercase letter (and not at start)
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
        
    Examples:
        ("schemas/Roster.xsd", "Roster") → "roster"
        ("schemas/Clinical.xsd", "Clinical") → "clinicals"
    """
    try:
        tree = etree.parse(xsd_path)
        root = tree.getroot()
        
        # Find the first top-level element definition
        root_element = root.find("./xs:element[@name]", ns)
        if root_element is not None:
            return root_element.get("name")
        
        # Fallback to lowercase schema name
        return schema_name.lower()
    except Exception as e:
        print(f"Warning: No root element found in {xsd_path}. Using filename as schema name.")
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
        """
        tree = etree.parse(xsd_path)
        root = tree.getroot()
        
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

def get_documentation(elem):
    annotation = elem.find("xs:annotation/xs:documentation", ns)
    return ' '.join(annotation.text.strip().split()) if annotation is not None and annotation.text else "–"

def detect_core_model_import(root, xsd_path):
    """
    Detect if the schema imports the core model and return the path to Core-model.xsd.
    
    Args:
        root: The root element of the parsed XSD schema
        xsd_path: Path to the current XSD file
        
    Returns:
        Path to Core-model.xsd if found, None otherwise
    """
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
    
    return None

def parse_core_model_types(core_model_path):
    """
    Parse the Core-model.xsd file and extract its simple types.
    
    Args:
        core_model_path: Path to Core-model.xsd
        
    Returns:
        Dictionary mapping type names to their definitions [name, base, doc, pattern]
    """
    try:
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
    except Exception as e:
        print(f"Warning: Could not parse Core-model.xsd at {core_model_path}: {e}")
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
    output += to_md_table(["Name", "Base Type", "Description", "Pattern"], used_core_types)
    output += "\n\n"
    
    return output

def parse_simple_types(root):
    simple_types = []
    for st in root.findall("./xs:simpleType", ns):
        name = st.get("name", "–")
        restriction = st.find("xs:restriction", ns)
        base = restriction.get("base", "–") if restriction is not None else "–"
        doc = get_documentation(st)
        pattern = restriction.find("xs:pattern", ns)
        pattern_value = pattern.get("value", "") if pattern is not None else ""

        # simple_types.append([name, base, doc, pattern])

        pattern_value = pattern.get("value", "") if pattern is not None else ""
        simple_types.append([name, base, doc, pattern_value])
 
 
    return simple_types

def parse_complex_types(root):
    """Parse complex types and extract their elements with full details."""
    complex_types = {}
    
    for ct in root.findall("./xs:complexType", ns):
        name = ct.get("name", "–")
        if not name or name == "–":
            continue
            
        elements = []
        # Find all elements within the complex type
        for elem in ct.findall(".//xs:element", ns):
            field_name = elem.get("name", "–")
            elem_type = elem.get("type", "–")
            min_occurs = elem.get("minOccurs", "1")
            max_occurs = elem.get("maxOccurs", "1")
            doc = get_documentation(elem)
            
            elements.append([field_name, elem_type, min_occurs, max_occurs, doc])
        
        if elements:
            complex_types[name] = elements
    
    return complex_types

def generate_complex_type_table(name, elements):
    """Generate a markdown table for a single complex type."""
    output = f"### {name}\n\n"
    output += to_md_table(["Field Name", "Type", "MinOccurs", "MaxOccurs", "Description"], elements)
    output += "\n\n"
    return output

def generate_encoding(schema_info):
    """Generate encoding section for UTF-8 requirement."""
    output = "## Encoding\n\n"
    output += "Payers need to send their files with utf-8 encoding as shown below:\n\n"
    output += "```xml\n"
    output += "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    output += "```\n\n"
    
    return output

def generate_interoperability():
    """Generate interoperability section with FHIR reference."""
    output = "## Interoperability\n\n"
    output += "This implementation guide is based on FHIR R4 (Fast Healthcare Interoperability Resources Release 4) standards. "
    output += "For more information about FHIR R4, visit: https://www.hl7.org/fhir/R4/\n\n"
    
    return output

def generate_change_log(schema_info, release_tag=None):
    """Generate change log section with table format."""
    # Use release_tag version if available, otherwise use XSD version
    if release_tag:
        # Extract version from release tag (e.g., "roster-v10.1" -> "10.1")
        # Try to extract version after "v" or use the full tag
        version_match = re.search(r'v?(\d+\.\d+)', release_tag)
        version = version_match.group(1) if version_match else release_tag
    else:
        version = schema_info.version
    
    # Format date with proper month name and no leading zeros
    date_str = datetime.today().strftime('%B %d, %Y').replace(' 0', ' ')
    
    output = "## Change Log\n\n"
    output += "| Version | Date |\n"
    output += "|---------|------|\n"
    output += f"| {version} | {date_str} |\n\n"
    
    return output

def generate_practical_guidance(schema_info):
    """Generate practical guidance section for submission frequency, adds/updates/deletes, member identification."""
    output = "## Practical Guidance\n\n"
    output += "### Submission Frequency\n\n"
    output += f"{schema_info.display_name} files should be submitted according to the schedule agreed upon with HealthLX. "
    output += "Typical submission frequencies include daily, weekly, or monthly updates.\n\n"
    
    output += "### Adds, Updates, and Deletes\n\n"
    output += "- **Adds**: Include new member records with all required fields populated\n"
    output += "- **Updates**: Submit complete member records with updated information\n"
    output += "- **Deletes**: Follow the agreed-upon process for member terminations or removals\n\n"
    
    output += "### Member Identification\n\n"
    output += "Each member must be uniquely identified using the appropriate identifier fields. "
    output += "Ensure consistency in member identifiers across all submissions to maintain data integrity.\n\n"
    
    return output

def parse_element_recursive(elem, depth=0, parent_name=""):
    """Parse elements recursively with parent tracking for PDF-style tables."""
    rows = []
    name = elem.get("name", "–")
    elem_type = elem.get("type", "–")
    min_occurs = elem.get("minOccurs", "1")
    max_occurs = elem.get("maxOccurs", "1")
    doc = get_documentation(elem)
    
    # Build cardinality string
    cardinality = f"{min_occurs}..{max_occurs}"
    
    # For PDF-style table: Name, Parent, Cardinality, Description, Examples, Data Type
    rows.append([name, parent_name, cardinality, doc, "–", elem_type])

    # Recurse into anonymous complexTypes
    complex_type = elem.find("xs:complexType", ns)
    if complex_type is not None:
        for child in complex_type.findall(".//xs:element", ns):
            rows.extend(parse_element_recursive(child, depth + 1, name))
    return rows

def parse_root_element(root, schema_info):
    root_elem = root.find(f".//xs:element[@name='{schema_info.root_element}']", ns)
    if root_elem is None:
        return []

    return parse_element_recursive(root_elem)

def parse_required_elements(root, schema_info):
    """Extract only required elements (minOccurs >= 1) for PDF-style table."""
    all_elements = parse_root_element(root, schema_info)
    required = []
    
    for elem in all_elements:
        # elem format: [name, parent, cardinality, description, examples, data_type]
        cardinality = elem[2]
        min_occurs = cardinality.split("..")[0]
        
        # Include if minOccurs >= 1
        if min_occurs != "0":
            required.append(elem)
    
    return required

def parse_all_elements(root, schema_info):
    """Extract all elements for PDF-style table."""
    return parse_root_element(root, schema_info)

def generate_element_table(title, elements, schema_info):
    """Generate element table with 6 columns: Name, Parent, Cardinality, Description, Examples, Data Type."""
    output = f"## {title}\n\n"
    
    if not elements:
        output += "No elements found.\n\n"
        return output
    
    headers = ["Name", "Parent", "Cardinality", "Description", "Examples", "Data Type"]
    output += to_md_table(headers, elements)
    output += "\n\n"
    
    return output

def generate_data_type_definitions(root, schema_info):
    """Generate Data Type Definition section for complex types (Period, Identifier, etc.)."""
    output = "## Data Type Definition\n\n"
    output += f"This section defines the structure of reusable complex data types used throughout the {schema_info.display_name.lower()} schema.\n\n"
    
    complex_types = parse_complex_types(root)
    
    for name, elements in complex_types.items():
        output += f"### {name}\n\n"
        headers = ["Field Name", "Type", "MinOccurs", "MaxOccurs", "Description"]
        output += to_md_table(headers, elements)
        output += "\n\n"
    
    return output



def to_md_table(headers, rows):
    out = "| " + " | ".join(headers) + " |\n"
    out += "| " + " | ".join(['---'] * len(headers)) + " |\n"
    for row in rows:
        out += "| " + " | ".join(row) + " |\n"
    return out

def generate_header(root, schema_info):
    """Generate header section with logo, title, version, and date matching PDF format."""
    # Extract version from schema
    version = root.get("version", "1.0")
    
    # Format date with proper month name and no leading zeros
    date_str = datetime.today().strftime('%B %d, %Y').replace(' 0', ' ')
    
    output = "![HLX Logo](../assets/hlx_logo.png)\n\n"
    output += f"# {schema_info.display_name} Implementation Guide\n\n"
    output += f"**HLX0123 HLX {schema_info.display_name} IG (XSD_V{version})**\n\n"
    output += f"**Version {version}**\n\n"
    output += f"**{date_str}**\n\n"
    
    return output

def generate_toc(schema_info, has_core_types=False):
    """Generate table of contents with section links matching PDF format."""
    # Create URL-safe anchor from schema name
    schema_anchor = schema_info.display_name.lower().replace(' ', '-')
    
    output = "**Table of Contents**\n\n"
    output += "1. [Overview](#overview)\n"
    output += "2. [Encoding](#encoding)\n"
    output += "3. [Interoperability](#interoperability)\n"
    output += "4. [Change Log](#change-log)\n"
    output += "5. [Simple Types](#simple-types)\n"
    
    section_num = 6
    if has_core_types:
        output += f"{section_num}. [Core Model Types](#core-model-types)\n"
        section_num += 1
    
    output += f"{section_num}. [Complex Types](#complex-types)\n"
    section_num += 1
    output += f"{section_num}. [Required Elements of {schema_info.display_name} XSD](#required-elements-of-{schema_anchor}-xsd)\n"
    section_num += 1
    output += f"{section_num}. [All Elements of {schema_info.display_name} XSD](#all-elements-of-{schema_anchor}-xsd)\n"
    section_num += 1
    output += f"{section_num}. [Practical Guidance](#practical-guidance)\n\n"
    
    return output

def generate_disclaimer():
    """Generate disclaimer section with standard legal text."""
    output = "## Disclaimer\n\n"
    output += "This document is provided by HealthLX for informational purposes only. Information within this document is believed to be correct as of the noted date of publication. Although HealthLX makes every reasonable effort to present information in a timely and accurate manner, HealthLX does not warrant this information for accuracy, completeness or fitness for any purpose, express or implied. The information provided herein does not constitute the rendering of legal, financial or other professional advice or recommendations by HealthLX.\n\n"
    
    return output

def generate_overview(schema_info):
    """Generate overview section explaining the guide's purpose and XML format matching PDF style."""
    output = "## Overview\n\n"
    output += f"This implementation guide provides field mappings and requirements for HealthLX {schema_info.display_name} data submissions in XML format based on FHIR R4 standards. "
    output += "XML format enables structured data exchange with built-in validation against the provided XSD schema.\n\n"
    
    return output

def generate_markdown(xsd_path, release_tag=None):
    tree = etree.parse(xsd_path)
    root = tree.getroot()
    
    # Create SchemaInfo object from XSD file
    schema_info = SchemaInfo.from_xsd(xsd_path)

    # Detect core model import and parse core types if present
    core_model_path = detect_core_model_import(root, xsd_path)
    core_types_dict = {}
    used_core_types = set()
    has_core_types = False
    
    if core_model_path:
        core_types_dict = parse_core_model_types(core_model_path)
        used_core_types = find_used_core_types(root)
        has_core_types = len(used_core_types) > 0

    output = ""
    
    # Header with logo, title, version, and date
    output += generate_header(root, schema_info)
    
    # Table of contents (include core types section if present)
    output += generate_toc(schema_info, has_core_types)
    
    # Disclaimer
    output += generate_disclaimer()
    
    # Overview
    output += generate_overview(schema_info)
    
    # Encoding
    output += generate_encoding(schema_info)
    
    # Interoperability
    output += generate_interoperability()
    
    # Change Log
    output += generate_change_log(schema_info, release_tag)
    
    # Simple types
    simple_types = parse_simple_types(root)
    if simple_types:
        output += "## Simple Types\n\n"
        output += to_md_table(["Name", "Base Type", "Description", "Pattern"], simple_types) + "\n\n"
    
    # Core Model Types (if imported and used)
    if has_core_types:
        output += generate_core_types_section(core_types_dict, used_core_types)
    
    # Complex types - generate individual tables for each
    complex_types = parse_complex_types(root)
    if complex_types:
        output += "## Complex Types\n\n"
        for name, elements in complex_types.items():
            output += generate_complex_type_table(name, elements)
    
    # Required Elements table
    required_elements = parse_required_elements(root, schema_info)
    output += generate_element_table(f"Required Elements of {schema_info.display_name} XSD", required_elements, schema_info)
    
    # All Elements table
    all_elements = parse_all_elements(root, schema_info)
    output += generate_element_table(f"All Elements of {schema_info.display_name} XSD", all_elements, schema_info)
    
    # Practical Guidance
    output += generate_practical_guidance(schema_info)

    return output

def generate_markdown_file(xsd_path, output_path, release_tag=None):
    md = generate_markdown(xsd_path, release_tag)
    Path(output_path).write_text(md, encoding='utf-8')
    print(f"[OK] Wrote markdown to: {output_path}")

if __name__ == "__main__":
    if len(sys.argv) < 3 or len(sys.argv) > 4:
        print("Usage: python xsd_to_md.py <input_xsd_path> <output_md_path> [release_tag]")
        sys.exit(1)

    xsd_path = sys.argv[1]
    output_path = sys.argv[2]
    release_tag = sys.argv[3] if len(sys.argv) == 4 else None
    generate_markdown_file(xsd_path, output_path, release_tag)