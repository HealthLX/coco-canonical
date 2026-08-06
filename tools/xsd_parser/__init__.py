"""XSD to Markdown parser package."""
from .exceptions import (
    XSDProcessingError,
    SchemaValidationError,
    SchemaFileNotFoundError
)
from .schema_info import SchemaInfo
from .simple_types import parse_simple_types
from .complex_types import parse_complex_types, generate_complex_type_table
from .elements import (
    parse_root_element,
    parse_required_elements,
    parse_all_elements
)
from .core_model import (
    detect_core_model_import,
    parse_core_model_types,
    find_used_core_types,
    generate_core_types_section
)
from .markdown_gen import (
    to_md_table,
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
    generate_data_type_definitions
)
from .validation import (
    validate_xsd_file,
    validate_schema_structure,
    verify_schema_coverage
)

__all__ = [
    # Exceptions
    'XSDProcessingError',
    'SchemaValidationError',
    'SchemaFileNotFoundError',
    # Schema Info
    'SchemaInfo',
    # Parsing
    'parse_simple_types',
    'parse_complex_types',
    'generate_complex_type_table',
    'parse_root_element',
    'parse_required_elements',
    'parse_all_elements',
    # Core Model
    'detect_core_model_import',
    'parse_core_model_types',
    'find_used_core_types',
    'generate_core_types_section',
    # Markdown Generation
    'to_md_table',
    'generate_front_matter',
    'generate_hlx_tbl_format',
    'generate_header',
    'generate_toc',
    'generate_disclaimer',
    'generate_overview',
    'generate_encoding',
    'generate_interoperability',
    'generate_change_log',
    'generate_practical_guidance',
    'generate_element_table',
    'generate_element_table_with_sections',
    'generate_data_type_definitions',
    # Validation
    'validate_xsd_file',
    'validate_schema_structure',
    'verify_schema_coverage',
]

