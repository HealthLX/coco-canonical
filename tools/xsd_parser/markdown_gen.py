"""Markdown generation functions."""
from datetime import datetime
import re
from .schema_info import SchemaInfo


def escape_markdown_table_cell(text):
    """Escape special characters in markdown table cells."""
    if not isinstance(text, str):
        text = str(text)
    # Replace pipe characters and newlines
    text = text.replace("|", "\\|")
    text = text.replace("\n", " ")
    return text


def to_md_table(headers, rows):
    """Generate markdown table with proper escaping."""
    if not headers:
        return ""
    
    # Escape headers
    escaped_headers = [escape_markdown_table_cell(h) for h in headers]
    out = "| " + " | ".join(escaped_headers) + " |\n"
    out += "| " + " | ".join(['---'] * len(headers)) + " |\n"
    
    # Escape and format rows
    for row in rows:
        # Ensure row has same number of columns as headers
        while len(row) < len(headers):
            row.append("–")
        if len(row) > len(headers):
            row = row[:len(headers)]
        
        escaped_row = [escape_markdown_table_cell(cell) for cell in row]
        out += "| " + " | ".join(escaped_row) + " |\n"
    
    return out


def generate_header(root, schema_info: SchemaInfo):
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


def generate_toc(schema_info: SchemaInfo, has_core_types=False):
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


def generate_overview(schema_info: SchemaInfo):
    """Generate overview section explaining the guide's purpose and XML format matching PDF style."""
    output = "## Overview\n\n"
    output += f"This implementation guide provides field mappings and requirements for HealthLX {schema_info.display_name} data submissions in XML format based on FHIR R4 standards. "
    output += "XML format enables structured data exchange with built-in validation against the provided XSD schema.\n\n"
    
    return output


def generate_encoding(schema_info: SchemaInfo):
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


def generate_change_log(schema_info: SchemaInfo, release_tag=None):
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


def generate_practical_guidance(schema_info: SchemaInfo):
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


def generate_element_table(title, elements, schema_info: SchemaInfo):
    """Generate element table with 6 columns: Name, Parent, Cardinality, Description, Examples, Data Type."""
    output = f"## {title}\n\n"
    
    if not elements:
        output += "No elements found.\n\n"
        return output
    
    headers = ["Name", "Parent", "Cardinality", "Description", "Examples", "Data Type"]
    output += to_md_table(headers, elements)
    output += "\n\n"
    
    return output


def generate_data_type_definitions(root, schema_info: SchemaInfo):
    """Generate Data Type Definition section for complex types (Period, Identifier, etc.)."""
    from .complex_types import parse_complex_types
    output = "## Data Type Definition\n\n"
    output += f"This section defines the structure of reusable complex data types used throughout the {schema_info.display_name.lower()} schema.\n\n"
    
    complex_types = parse_complex_types(root)
    
    for name, elements in complex_types.items():
        output += f"### {name}\n\n"
        headers = ["Field Name", "Type", "MinOccurs", "MaxOccurs", "Description"]
        output += to_md_table(headers, elements)
        output += "\n\n"
    
    return output

