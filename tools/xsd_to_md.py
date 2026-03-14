"""Main entry point for XSD to Markdown conversion."""
import sys
from pathlib import Path
from lxml import etree

# Add tools directory to path for imports
import os
tools_dir = Path(__file__).parent
if str(tools_dir) not in sys.path:
    sys.path.insert(0, str(tools_dir))

from xsd_parser import (
    XSDProcessingError,
    SchemaValidationError,
    SchemaFileNotFoundError,
    SchemaInfo,
    validate_xsd_file,
    validate_schema_structure,
    parse_simple_types,
    parse_complex_types,
    generate_complex_type_table,
    parse_required_elements,
    parse_all_elements,
    detect_core_model_import,
    parse_core_model_types,
    find_used_core_types,
    generate_core_types_section,
    generate_front_matter,
    generate_header,
    generate_hlx_tbl_format,
    generate_toc,
    generate_disclaimer,
    generate_overview,
    generate_encoding,
    generate_interoperability,
    generate_change_log,
    generate_practical_guidance,
    generate_element_table,
    generate_element_table_with_sections,
    to_md_table,
    verify_schema_coverage,
)
from xsd_parser.constants import logger


def generate_markdown(xsd_path, release_tag=None):
    """Generate markdown documentation from XSD file with comprehensive error handling."""
    try:
        # Validate file exists
        validate_xsd_file(xsd_path)
        
        # Parse XSD
        try:
            tree = etree.parse(xsd_path)
            root = tree.getroot()
        except etree.XMLSyntaxError as e:
            raise SchemaValidationError(f"Invalid XML syntax in XSD file: {e}")
        except Exception as e:
            raise SchemaValidationError(f"Failed to parse XSD file: {e}")
        
        # Validate schema structure
        try:
            validate_schema_structure(root)
        except SchemaValidationError:
            raise
        except Exception as e:
            logger.warning(f"Schema structure validation warning: {e}")
        
        # Create SchemaInfo object from XSD file
        try:
            schema_info = SchemaInfo.from_xsd(xsd_path)
        except Exception as e:
            raise SchemaValidationError(f"Failed to extract schema info: {e}")

        # Detect core model import and parse core types if present
        core_model_path = None
        core_types_dict = {}
        used_core_types = set()
        has_core_types = False
        
        try:
            core_model_path = detect_core_model_import(root, xsd_path)
            if core_model_path:
                core_types_dict = parse_core_model_types(core_model_path)
                used_core_types = find_used_core_types(root)
                has_core_types = len(used_core_types) > 0
        except Exception as e:
            logger.warning(f"Error processing core model types: {e}")

        output = ""
        
        try:
            # Jekyll front matter — must be the very first bytes of the file
            output += generate_front_matter(schema_info)

            # Table Format Template
            output += generate_hlx_tbl_format()

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
                output += "<h2 id=\"simple-types\" style=\"color:#E60073\"> Simple Types</h2>\n\n"
                output += to_md_table(["Name", "Base Type", "Description", "Pattern"], simple_types) + "\n\n"
            
            # Core Model Types (if imported and used)
            if has_core_types:
                output += generate_core_types_section(core_types_dict, used_core_types)
            
            # Complex types - generate individual tables for each
            complex_types = parse_complex_types(root)
            if complex_types:
                output += "<h2 id=\"complex-types\" style=\"color:#E60073\"> Complex Types</h2>\n\n"
                for name, elements in complex_types.items():
                    output += generate_complex_type_table(name, elements)
            
            # Required Elements table
            required_elements = parse_required_elements(root, schema_info)
            output += generate_element_table(f"Required Elements of {schema_info.display_name} XSD", required_elements, schema_info)
            
            # All Elements table (with section headers)
            all_elements = parse_all_elements(root, schema_info)
            output += generate_element_table_with_sections(f"All Elements of {schema_info.display_name} XSD", all_elements, schema_info)
            
            # Practical Guidance
            output += generate_practical_guidance(schema_info)
        except Exception as e:
            logger.error(f"Error generating markdown content: {e}")
            raise SchemaValidationError(f"Failed to generate markdown: {e}")

        return output
    except (SchemaFileNotFoundError, SchemaValidationError):
        raise
    except Exception as e:
        raise XSDProcessingError(f"Unexpected error processing XSD: {e}")


def generate_markdown_file(xsd_path, output_path, release_tag=None):
    """Generate markdown file with validation and error handling."""
    try:
        # Validate output directory
        output_file = Path(output_path)
        output_dir = output_file.parent
        if not output_dir.exists():
            try:
                output_dir.mkdir(parents=True, exist_ok=True)
                logger.info(f"Created output directory: {output_dir}")
            except Exception as e:
                raise SchemaValidationError(f"Cannot create output directory {output_dir}: {e}")
        
        # Generate markdown
        md = generate_markdown(xsd_path, release_tag)
        
        # Write to file
        try:
            output_file.write_text(md, encoding='utf-8')
            print(f"[OK] Wrote markdown to: {output_path}")
        except Exception as e:
            raise SchemaValidationError(f"Failed to write output file {output_path}: {e}")
        
        # Verify coverage (optional, logs warnings)
        try:
            tree = etree.parse(xsd_path)
            root = tree.getroot()
            schema_info = SchemaInfo.from_xsd(xsd_path)
            simple_types = parse_simple_types(root)
            complex_types = parse_complex_types(root)
            all_elements = parse_all_elements(root, schema_info)
            warnings = verify_schema_coverage(root, schema_info, simple_types, complex_types, all_elements)
            if warnings:
                for warning in warnings:
                    logger.warning(warning)
        except Exception as e:
            logger.warning(f"Coverage verification skipped: {e}")
            
    except (SchemaFileNotFoundError, SchemaValidationError, XSDProcessingError):
        raise
    except Exception as e:
        raise XSDProcessingError(f"Unexpected error in generate_markdown_file: {e}")


if __name__ == "__main__":
    if len(sys.argv) < 3 or len(sys.argv) > 4:
        print("Usage: python xsd_to_md.py <input_xsd_path> <output_md_path> [release_tag]")
        sys.exit(1)

    xsd_path = sys.argv[1]
    output_path = sys.argv[2]
    release_tag = sys.argv[3] if len(sys.argv) == 4 else None
    
    try:
        generate_markdown_file(xsd_path, output_path, release_tag)
    except SchemaFileNotFoundError as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
    except SchemaValidationError as e:
        print(f"Validation Error: {e}", file=sys.stderr)
        sys.exit(1)
    except XSDProcessingError as e:
        print(f"Processing Error: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected Error: {e}", file=sys.stderr)
        sys.exit(1)
