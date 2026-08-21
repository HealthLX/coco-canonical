"""Unit tests for POST /convert/xml-to-json."""
from fastapi.testclient import TestClient

from api.main import app

client = TestClient(app)


def test_convert_valid_xml_returns_json():
    res = client.post(
        "/convert/xml-to-json",
        content="<a><b>1</b><b>2</b></a>",
        headers={"Content-Type": "application/xml"},
    )
    assert res.status_code == 200
    assert res.headers["content-type"].startswith("application/json")
    assert res.json() == {"a": {"b": ["1", "2"]}}


def test_convert_empty_body_is_400():
    res = client.post("/convert/xml-to-json", content="", headers={"Content-Type": "application/xml"})
    assert res.status_code == 400


def test_convert_malformed_xml_is_400():
    res = client.post(
        "/convert/xml-to-json",
        content="<a><b></a>",
        headers={"Content-Type": "application/xml"},
    )
    assert res.status_code == 400
    assert "not well-formed" in res.json()["detail"]
