"""Unit tests for tools.xml_to_json — the engine behind POST /convert/xml-to-json
and the format=json branches of /samples and /transform."""
from pathlib import Path

import pytest
from lxml import etree

from tools.xml_to_json import xml_to_json

PROJECT_ROOT = Path(__file__).resolve().parents[2]
SAMPLES_DIR = PROJECT_ROOT / "tests" / "data" / "valid" / "v10.0"


def test_simple_element_becomes_leaf_string():
    assert xml_to_json("<a>text</a>") == {"a": "text"}


def test_attributes_become_at_prefixed_keys():
    assert xml_to_json('<a id="1">text</a>') == {"a": {"@id": "1", "#text": "text"}}


def test_attributes_on_empty_leaf_have_no_text_key():
    assert xml_to_json('<a id="1"/>') == {"a": {"@id": "1"}}


def test_repeated_siblings_become_array():
    result = xml_to_json("<roster><member>1</member><member>2</member></roster>")
    assert result == {"roster": {"member": ["1", "2"]}}


def test_namespaced_elements_use_local_name():
    xml = '<roster xmlns="http://cocodata.org"><member>1</member></roster>'
    assert xml_to_json(xml) == {"roster": {"member": "1"}}


def test_namespaced_attribute_keeps_prefix():
    xml = (
        '<roster xmlns="http://cocodata.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
        'xsi:schemaLocation="http://cocodata.org Roster.xsd"/>'
    )
    assert xml_to_json(xml) == {"roster": {"@xsi:schemaLocation": "http://cocodata.org Roster.xsd"}}


def test_malformed_xml_raises():
    with pytest.raises(etree.XMLSyntaxError):
        xml_to_json("<a><b></a>")


def test_real_roster_sample_round_trips():
    xml_text = (SAMPLES_DIR / "roster-sample.xml").read_text(encoding="utf-8")
    result = xml_to_json(xml_text)
    assert list(result.keys()) == ["roster"]
    assert isinstance(result["roster"], dict)
    assert result["roster"]
