import pathlib
import pytest
import xmlschema
from lxml import etree

# Validates that all files checked into the schema folder are well-formed XML Schema (.xsd) files.
# Robust: resolve the file path first, then walk up to repo root
HERE = pathlib.Path(__file__).resolve()
SCHEMAS_ROOT = HERE.parents[2] / "schemas"  # <repo>/schemas

def find_xsds(root: pathlib.Path):
    return sorted(root.rglob("*.xsd"))

XSD_FILES = find_xsds(SCHEMAS_ROOT)

def test_found_xsds():
    assert XSD_FILES, f"No .xsd files found under {SCHEMAS_ROOT} (resolved from {HERE})"

@pytest.mark.parametrize("xsd_path", XSD_FILES, ids=lambda p: str(p.relative_to(SCHEMAS_ROOT)))
def test_xsd_is_valid_schema(xsd_path: pathlib.Path):
    # 1) Well-formed XML
    etree.parse(str(xsd_path))  # will raise XMLSyntaxError on failure

    # 2) Valid XML Schema (includes/imports resolved relative to file)
    xmlschema.XMLSchema(str(xsd_path), base_url=str(xsd_path.parent))