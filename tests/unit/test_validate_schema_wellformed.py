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
    """Dynamically generate test parameters for XSD files"""
    if "xsd_path" in metafunc.fixturenames:
        # Use the fixture to get schemas directory
        import pathlib
        here = pathlib.Path(__file__).resolve()
        project_root = here.parents[2]
        schemas_dir = project_root / "schemas"
        xsd_files = find_xsds(schemas_dir)
        
        metafunc.parametrize(
            "xsd_path", 
            xsd_files, 
            ids=lambda p: str(p.relative_to(schemas_dir))
        )

def test_xsd_is_valid_schema(xsd_path):
    """Test that each XSD file is well-formed XML and valid XML Schema"""
    assert xsd_path.exists(), f"XSD file not found: {xsd_path}"
    
    try:
        etree.parse(str(xsd_path))
    except etree.XMLSyntaxError as e:
        pytest.fail(f"XML syntax error in {xsd_path}: {e}")

    try:
        xmlschema.XMLSchema(str(xsd_path), base_url=str(xsd_path.parent))
    except Exception as e:
        pytest.fail(f"Schema validation error in {xsd_path}: {e}")