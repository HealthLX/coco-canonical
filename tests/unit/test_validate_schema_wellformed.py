import pathlib
import pytest
import xmlschema
from lxml import etree

# Validates that all files checked into the schema folder are well-formed XML Schema (.xsd) files.
HERE = pathlib.Path(__file__).resolve()
SCHEMAS_ROOT = HERE.parents[2] / "schemas"  # <repo>/schemas

def find_xsds(root: pathlib.Path):
    return sorted(root.rglob("*.xsd"))

def test_found_xsds(schemas_dir):
    """Ensure we can find XSD files and provide helpful error message if not"""
    xsd_files = find_xsds(schemas_dir)
    assert xsd_files, f"No .xsd files found under {schemas_dir}"
    print(f"Found {len(xsd_files)} XSD files")

def test_schema_root_exists(schemas_dir):
    """Verify the schemas directory exists"""
    assert schemas_dir.exists(), f"Schemas directory not found: {schemas_dir}"
    assert schemas_dir.is_dir(), f"Schemas path is not a directory: {schemas_dir}"


def pytest_generate_tests(metafunc):
    if "xsd_path" in metafunc.fixturenames:
        here = pathlib.Path(__file__).resolve()
        schemas_dir = here.parents[2] / "schemas"
        xsd_files = [
            p for p in find_xsds(schemas_dir)
            if "fhir-schemas" not in p.relative_to(schemas_dir).parts
        ]
        metafunc.parametrize("xsd_path", xsd_files,
                             ids=lambda p: str(p.relative_to(schemas_dir)))

def test_xsd_is_valid_schema(xsd_path):
    """Test that each XSD file is well-formed XML and valid XML Schema"""
    assert xsd_path.exists(), f"XSD file not found: {xsd_path}"
    
    try:
        etree.parse(str(xsd_path))
    except etree.XMLSyntaxError as e:
        pytest.fail(f"XML syntax error in {xsd_path}: {e}")

    try:
        # In xmlschema 4.2.0+, when source is a file path, base_url can be omitted
        # xmlschema automatically infers the base URL from the file path
        xmlschema.XMLSchema(str(xsd_path.resolve()))
    except Exception as e:
        pytest.fail(f"Schema validation error in {xsd_path}: {e}")