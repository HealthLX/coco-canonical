"""Unit tests for tools.validate_xml.validate_xml — the engine behind POST /validate."""
from pathlib import Path

import pytest

from tools.validate_xml import validate_xml

PROJECT_ROOT = Path(__file__).resolve().parents[2]
SCHEMAS_DIR = PROJECT_ROOT / "schemas" / "v10.0"
SAMPLES_DIR = PROJECT_ROOT / "tests" / "data" / "valid" / "v10.0"


def test_valid_roster_sample_passes():
    xsd = SCHEMAS_DIR / "Roster.xsd"
    xml = SAMPLES_DIR / "roster-sample.xml"
    assert xsd.exists() and xml.exists()

    is_valid, errors = validate_xml(xml, xsd)
    assert is_valid, "\n".join(str(e) for e in errors)


def test_malformed_document_is_invalid(tmp_path: Path):
    xsd = SCHEMAS_DIR / "Roster.xsd"
    bad = tmp_path / "bad.xml"
    # Well-formed XML, but the root element is not defined by the Roster schema.
    bad.write_text('<?xml version="1.0"?><NotARosterElement/>', encoding="utf-8")

    is_valid, errors = validate_xml(bad, xsd)
    assert not is_valid
    assert len(errors) > 0
