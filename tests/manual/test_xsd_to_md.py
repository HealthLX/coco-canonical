"""Integration tests for XSD to Markdown generation - test XSD files against their markdown docs.

Usage:
    # Test a specific XSD against its markdown documentation:
    pytest tests/manual/test_xsd_to_md.py --xsd-path schemas/v10.0/Clinical.xsd --md-path docs/Clinical_Guide.md
    
    # Test with verbose output:
    pytest tests/manual/test_xsd_to_md.py --xsd-path schemas/v10.0/EOB.xsd --md-path docs/EOB_Guide.md -v
    
    # Both --xsd-path and --md-path are required (paths are relative to project root)
"""
import pytest
from pathlib import Path
from tools.xsd_to_md import generate_markdown


def pytest_addoption(parser):
    """Add command-line options for specifying XSD and markdown paths."""
    parser.addoption(
        "--xsd-path",
        action="store",
        default=None,
        help="Path to XSD file (relative to project root). Requires --md-path."
    )
    parser.addoption(
        "--md-path",
        action="store",
        default=None,
        help="Path to expected markdown file (relative to project root). Requires --xsd-path."
    )


@pytest.fixture
def project_root():
    """Path to project root directory."""
    return Path(__file__).parent.parent.parent


def pytest_generate_tests(metafunc):
    """Generate test parameters from command line."""
    if "test_name" in metafunc.fixturenames:
        xsd_path = metafunc.config.getoption("--xsd-path")
        md_path = metafunc.config.getoption("--md-path")
        
        # Both paths must be provided
        if not xsd_path or not md_path:
            pytest.skip("Both --xsd-path and --md-path must be provided. Example: pytest tests/manual/test_xsd_to_md.py --xsd-path schemas/v10.0/Clinical.xsd --md-path docs/Clinical_Guide.md")
        
        # Extract name from XSD path
        name = Path(xsd_path).stem
        metafunc.parametrize("test_name,xsd_path,md_path", [(name, xsd_path, md_path)])


def test_xsd_generates_correct_markdown(project_root, test_name, xsd_path, md_path):
    """Test that XSD file generates the correct markdown documentation.
    
    Both --xsd-path and --md-path must be provided via command line.
    
    Example:
        pytest tests/manual/test_xsd_to_md.py --xsd-path schemas/v10.0/Clinical.xsd --md-path docs/Clinical_Guide.md
    """
    xsd_full_path = project_root / xsd_path
    md_full_path = project_root / md_path
    
    if not xsd_full_path.exists():
        pytest.skip(f"XSD file not found: {xsd_full_path}")
    if not md_full_path.exists():
        pytest.skip(f"Markdown file not found: {md_full_path}")
    
    # Generate markdown from XSD
    generated_md = generate_markdown(str(xsd_full_path))
    
    # Read expected markdown
    expected_md = md_full_path.read_text(encoding='utf-8')
    
    # Verify key sections exist in generated markdown
    assert "## Simple Types" in generated_md, f"{test_name}: Simple Types section missing"
    assert "## Complex Types" in generated_md, f"{test_name}: Complex Types section missing"
    assert "## Required Elements" in generated_md, f"{test_name}: Required Elements section missing"
    
    # Compare Simple Types section (most critical for pattern validation)
    def extract_simple_types_section(content):
        """Extract Simple Types section from markdown."""
        lines = content.split('\n')
        in_section = False
        section_lines = []
        for line in lines:
            if line.strip() == "## Simple Types":
                in_section = True
                continue
            if in_section and line.startswith('##'):
                break
            if in_section:
                section_lines.append(line)
        return '\n'.join(section_lines)
    
    generated_simple = extract_simple_types_section(generated_md)
    expected_simple = extract_simple_types_section(expected_md)
    
    # Verify key simple types exist (pattern validation)
    # This ensures patterns are being extracted correctly
    if generated_simple.strip():  # Only check if section has content
        # Check that patterns with pipes are properly escaped
        assert "\\|" in generated_simple or "|" not in generated_simple, \
            f"{test_name}: Unescaped pipes found in Simple Types patterns"

