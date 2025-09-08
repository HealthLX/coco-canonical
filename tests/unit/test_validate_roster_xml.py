import sys, os
from pathlib import Path
import pytest

# Add the project root to sys.path
project_root = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(project_root))

from tools.validate_xml import validate_xml
from tools.generate_roster_sample_xml import generate_sample

def test_generate_then_validate_roster(tmp_path: Path):
    xsd = project_root / "schemas" / "v2.0" / "Roster.xsd"
    assert xsd.exists(), f"Missing schema: {xsd}"

    out_xml = tmp_path / "roster-sample.xml"

    # 1) Generate a sample file from the XSD
    generated = generate_sample(xsd, out_xml)
    assert generated.exists(), "Generator did not create the sample XML"

    # 2) Validate the generated sample against the schema
    is_valid, errors = validate_xml(generated, xsd)
    assert is_valid, "\n".join(str(e) for e in errors)