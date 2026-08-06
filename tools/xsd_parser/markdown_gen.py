"""Markdown generation functions."""
from datetime import datetime
import re
from .schema_info import SchemaInfo


def escape_markdown_table_cell(text):
    """Escape special characters in markdown table cells.
    
    In markdown tables, only pipe characters (|) need escaping to prevent
    breaking table structure. Other regex special characters ([, ], (, ), etc.)
    render correctly without escaping. Newlines are replaced with spaces to
    keep table rows on single lines.
    
    Args:
        text: String to escape for markdown table cell
        
    Returns:
        Escaped string safe for use in markdown table cells
    """
    if not isinstance(text, str):
        text = str(text)
    # Only escape unescaped pipes to avoid double-escaping
    text = re.sub(r'(?<!\\)\|', r'\\|', text)
    # Replace newlines with spaces
    text = text.replace("\n", " ")
    return text

def generate_front_matter(schema_info: SchemaInfo):
    """Generate Jekyll front matter so GitHub Pages applies the default layout."""
    title = f"{schema_info.display_name} Implementation Guide"
    return f"---\nlayout: default\ntitle: \"{title}\"\n---\n\n"


def generate_hlx_tbl_format():
    """Generate HLX style for markdown tables."""
    return ""


def to_md_table(headers, rows):
    """Generate markdown table with proper escaping.

    Uses a kramdown IAL ({: .heatMap}) instead of a wrapping <div> so that
    GitHub Pages / kramdown actually processes the pipe-table syntax rather
    than treating it as raw HTML content.
    """
    if not headers:
        return ""

    # Escape headers
    escaped_headers = [escape_markdown_table_cell(h) for h in headers]
    out = "| " + " | ".join(escaped_headers) + " |\n"
    out += "| " + " | ".join(['---'] * len(headers)) + " |\n"

    if not rows:
        return out + "{: .heatMap}\n\n"

    # Escape and format rows
    for row in rows:
        # Ensure row has same number of columns as headers
        while len(row) < len(headers):
            row.append("–")
        if len(row) > len(headers):
            row = row[:len(headers)]

        escaped_row = [escape_markdown_table_cell(cell) for cell in row]
        out += "| " + " | ".join(escaped_row) + " |\n"

    # IAL must be on the line immediately following the last table row (no blank line)
    return out + "{: .heatMap}\n\n"


def generate_header(root, schema_info: SchemaInfo):
    """Generate header section with logo, title, version, and date matching PDF format."""
    # Extract version from schema
    version = root.get("version", "1.0")
    
    # Format date with proper month name and no leading zeros
    date_str = datetime.today().strftime('%B %d, %Y').replace(' 0', ' ')
    
    output = "![HLX Logo](assets/css/hlx_logo.png)\n\n"
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
    output = "<h2 style=\"color:#E60073\">Disclaimer</h2>\n\n"
    output += "This document is provided by HealthLX for informational purposes only. Information within this document is believed to be correct as of the noted date of publication. Although HealthLX makes every reasonable effort to present information in a timely and accurate manner, HealthLX does not warrant this information for accuracy, completeness or fitness for any purpose, express or implied. The information provided herein does not constitute the rendering of legal, financial or other professional advice or recommendations by HealthLX.\n\n"
    
    return output


def generate_overview(schema_info: SchemaInfo):
    """Generate overview section explaining the guide's purpose and XML format matching PDF style."""
    output = "<h2 id=\"overview\" style=\"color:#E60073\">Overview</h2>\n\n"
    output += f"This implementation guide provides field mappings and requirements for HealthLX {schema_info.display_name} data submissions in XML format based on FHIR R4 standards. "
    output += "XML format enables structured data exchange with built-in validation against the provided XSD schema.\n\n"
    
    return output


def generate_encoding(schema_info: SchemaInfo):
    """Generate encoding section for UTF-8 requirement."""
    output = "<h2 id=\"encoding\" style=\"color:#E60073\">Encoding</h2>\n\n"
    output += "Payers need to send their files with utf-8 encoding as shown below:\n\n"
    output += "```xml\n"
    output += "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    output += "```\n\n"
    
    return output


def generate_interoperability():
    """Generate interoperability section with FHIR reference."""
    output = "<h2 id=\"interoperability\" style=\"color:#E60073\">Interoperability</h2>\n\n"
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

    output = "<h2 id=\"change-log\" style=\"color:#E60073\">Change Log</h2>\n\n"
    output += "| Version | Date |\n"
    output += "|---------|------|\n"
    output += f"| {version} | {date_str} |\n"
    output += "{: .heatMap}\n\n"
    
    return output


def generate_practical_guidance(schema_info: SchemaInfo):
    """Generate practical guidance section for submission frequency, adds/updates/deletes, member identification."""
    output = "<h2 id=\"practical-guidance\" style=\"color:#E60073\">Practical Guidance</h2>\n\n"
    output += "<h3 style=\"color:#E60073\">Submission Frequency</h3>\n\n"
    output += f"{schema_info.display_name} files should be submitted according to the schedule agreed upon with HealthLX. "
    output += "Typical submission frequencies include daily, weekly, or monthly updates.\n\n"

    output += "<h3 style=\"color:#E60073\">Adds, Updates, and Deletes</h3>\n\n"
    output += "- **Adds**: Include new member records with all required fields populated\n"
    output += "- **Updates**: Submit complete member records with updated information\n"
    output += "- **Deletes**: Follow the agreed-upon process for member terminations or removals\n\n"

    output += "<h3 style=\"color:#E60073\">Member Identification</h3>\n\n"
    output += "Each member must be uniquely identified using the appropriate identifier fields. "
    output += "Ensure consistency in member identifiers across all submissions to maintain data integrity.\n\n"
    
    return output


def get_section_title(parent_name: str) -> str:
    """Map parent element names to section titles for grouping."""
    section_mapping = {
        "": "Root Elements",
        "clinicals": "Root Elements",
        "clinical": "Clinical Data",
        "patient": "Patient Information",
        "lab_observations": "Laboratory Result Observations",
        "lab_observation": "Laboratory Result Observations",
        "allergy_intolerances": "Allergy Intolerance",
        "allergy_intolerance": "Allergy Intolerance",
        "conditions": "Conditions",
        "condition": "Conditions",
        "procedures": "Procedures",
        "procedure": "Procedures",
        "medication_requests": "Medication Requests",
        "medication_request": "Medication Requests",
        "care_teams": "Care Teams",
        "care_team": "Care Teams",
        "observation_vital_signs": "Vital Signs",
        "observation_vital_sign": "Vital Signs",
        "practitioners": "Practitioners",
        "practitioner": "Practitioners",
        "organizations": "Organizations",
        "organization": "Organizations",
        "locations": "Locations",
        "location": "Locations",
        "encounters": "Encounters",
        "encounter": "Encounters",
        "care_plans": "Care Plans",
        "care_plan": "Care Plans",
        "goals": "Goals",
        "goal": "Goals",
        "immunizations": "Immunizations",
        "immunization": "Immunizations",
        "pediatric_bmi_for_age_observations": "Pediatric BMI for Age Observations",
        "pediatric_bmi_for_age_observation": "Pediatric BMI for Age Observations",
        "pediatric_head_occipital_frontal_circumference_observations": "Pediatric Head Occipital Frontal Circumference Observations",
        "pediatric_head_occipital_frontal_circumference_observation": "Pediatric Head Occipital Frontal Circumference Observations",
        "pediatric_weight_for_height_observations": "Pediatric Weight for Height Observations",
        "pediatric_weight_for_height_observation": "Pediatric Weight for Height Observations",
        "practitioner_roles": "Practitioner Roles",
        "practitioner_role": "Practitioner Roles",
        "smoking_status_observations": "Smoking Status Observations",
        "smoking_status_observation": "Smoking Status Observations",
        "provenances": "Provenances",
        "provenance": "Provenances",
    }
    return section_mapping.get(parent_name, None)


def generate_element_table(title, elements, schema_info: SchemaInfo):
    """Generate element table with 6 columns: Name, Parent, Cardinality, Description, Examples, Data Type."""
    schema_anchor = schema_info.display_name.lower().replace(' ', '-')
    section_id = f"required-elements-of-{schema_anchor}-xsd"
    output = f"<h2 id=\"{section_id}\" style=\"color:#E60073\">{title}</h2>\n\n"
    
    if not elements:
        output += "No elements found.\n\n"
        return output
    
    headers = ["Name", "Parent", "Cardinality", "Description", "Examples", "Data Type"]
    output += to_md_table(headers, elements)
    output += "\n\n"
    
    return output


def is_top_level_section_element(element_name: str) -> bool:
    """Check if an element name represents a top-level section marker."""
    top_level_sections = [
        "clinicals", "clinical", "patient", "lab_observations", "allergy_intolerances",
        "conditions", "procedures", "medication_requests", "care_teams",
        "observation_vital_signs", "practitioners", "organizations", "locations",
        "encounters", "care_plans", "goals", "immunizations",
        "pediatric_bmi_for_age_observations", "pediatric_head_occipital_frontal_circumference_observations",
        "pediatric_weight_for_height_observations", "practitioner_roles",
        "smoking_status_observations", "provenances"
    ]
    return element_name in top_level_sections


def get_top_level_section(element_name: str, parent_name: str, current_section: str = None) -> str:
    """Determine the top-level section for an element based on its name and parent."""
    # If this element is itself a top-level section marker, use it
    if is_top_level_section_element(element_name):
        section_title = get_section_title(element_name)
        if section_title:
            return section_title
    
    # Check parent for section mapping
    section_title = get_section_title(parent_name)
    if section_title:
        return section_title
    
    # Special handling for root elements
    if not parent_name or parent_name == "":
        return "Root Elements"
    
    # For nested elements, inherit from current section if we have one
    if current_section:
        return current_section
    
    return "Other Elements"


def generate_element_table_with_sections(title, elements, schema_info: SchemaInfo):
    """Generate element table with section headers grouping elements by clinical purpose."""
    schema_anchor = schema_info.display_name.lower().replace(' ', '-')
    section_id = f"all-elements-of-{schema_anchor}-xsd"
    output = f"<h2 id=\"{section_id}\" style=\"color:#E60073\">{title}</h2>\n\n"
    
    if not elements:
        output += "No elements found.\n\n"
        return output
    
    # Group elements by section
    current_section = None
    section_elements = []
    all_sections = []
    
    for element in elements:
        # element format: [name, parent, cardinality, description, examples, data_type]
        if len(element) < 2:
            continue
            
        element_name = element[0] if element[0] else ""
        parent_name = element[1] if element[1] else ""
        
        # Determine which section this element belongs to
        section_title = get_top_level_section(element_name, parent_name, current_section)
        
        # If we're starting a new section, save the previous one
        if section_title != current_section:
            if current_section and section_elements:
                all_sections.append((current_section, section_elements))
            current_section = section_title
            section_elements = []
        
        section_elements.append(element)
    
    # Add the last section
    if current_section and section_elements:
        all_sections.append((current_section, section_elements))
    
    # Generate output with section headers
    headers = ["Name", "Parent", "Cardinality", "Description", "Examples", "Data Type"]
    
    for section_title, section_elements_list in all_sections:
        # Add section header
        output += f"<h3 style=\"color:#E60073\">{section_title}</h3>\n\n"
        # Add table for this section
        output += to_md_table(headers, section_elements_list)
        output += "\n\n"
    
    return output


def generate_data_type_definitions(root, schema_info: SchemaInfo):
    """Generate Data Type Definition section for complex types (Period, Identifier, etc.)."""
    from .complex_types import parse_complex_types
    output = "<h2 style=\"color:#E60073\">Data Type Definition</h2>\n\n"
    output += f"This section defines the structure of reusable complex data types used throughout the {schema_info.display_name.lower()} schema.\n\n"
    
    complex_types = parse_complex_types(root)
    
    for name, elements in complex_types.items():
        output += f"<h3 style=\"color:#E60073\">{name}</h3>\n\n"
        headers = ["Field Name", "Type", "MinOccurs", "MaxOccurs", "Description"]
        output += to_md_table(headers, elements)
        output += "\n\n"
    
    return output

