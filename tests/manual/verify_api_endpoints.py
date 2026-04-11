"""
Verify all CoCo API endpoints. Run from repo root:
  python tests/manual/verify_api_endpoints.py
"""
import sys
from pathlib import Path

# Ensure project root on path
repo_root = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(repo_root))

from fastapi.testclient import TestClient

from api.main import app

client = TestClient(app)
failures = []


def ok(name: str, r, expect_status=200):
    if r.status_code != expect_status:
        failures.append(f"{name}: expected {expect_status}, got {r.status_code} - {r.text[:200]}")
        return False
    return True


def run():
    print("=== Config ===")
    r = client.get("/")
    ok("GET /", r) and print("  GET /", r.status_code)
    r = client.get("/builds")
    ok("GET /builds", r) and print("  GET /builds", r.status_code, len(r.json()), "builds")
    r = client.get("/canonicals")
    ok("GET /canonicals", r) and print("  GET /canonicals", r.status_code, r.json())
    r = client.get("/config")
    ok("GET /config", r) and print("  GET /config", r.status_code, "builds" in str(r.json()))

    print("\n=== Artifacts (list + one download) ===")
    r = client.get("/schemas")
    ok("GET /schemas", r) and print("  GET /schemas", r.status_code, r.json())
    schemas = r.json() if r.status_code == 200 else []
    if schemas:
        r = client.get(f"/schemas/{schemas[0]}")
        ok("GET /schemas/{filename}", r) and print("  GET /schemas/", schemas[0], r.status_code, len(r.content), "bytes")
    r = client.get("/transforms")
    ok("GET /transforms", r) and print("  GET /transforms", r.status_code, r.json())
    transforms = r.json() if r.status_code == 200 else []
    if transforms:
        r = client.get(f"/transforms/{transforms[0]}")
        ok("GET /transforms/{filename}", r) and print("  GET /transforms/", transforms[0], r.status_code, len(r.content), "bytes")

    print("\n=== Samples (list) ===")
    r = client.get("/samples")
    ok("GET /samples", r) and print("  GET /samples", r.status_code)
    r = client.get("/samples/canonical")
    ok("GET /samples/canonical", r) and print("  GET /samples/canonical", r.status_code, len(r.json()), "files")
    r = client.get("/samples/fhir")
    ok("GET /samples/fhir", r) and print("  GET /samples/fhir", r.status_code, len(r.json()), "files")

    print("\n=== Generate (single target: roster) ===")
    r = client.post("/samples/generate", json={"target": "roster"})
    ok("POST /samples/generate {target: roster}", r) and print("  POST /samples/generate roster", r.status_code, r.json().get("success"))
    r = client.post("/samples/generate/roster")
    ok("POST /samples/generate/roster", r) and print("  POST /samples/generate/roster", r.status_code)
    r = client.post("/samples/generate/roster/content")
    ok("POST /samples/generate/roster/content", r) and print("  POST /samples/generate/roster/content", r.status_code, "xml" in (r.headers.get("content-type") or ""))

    print("\n=== Download canonical sample ===")
    r = client.get("/samples/canonical/roster-sample.xml")
    ok("GET /samples/canonical/roster-sample.xml", r) and print("  GET /samples/canonical/roster-sample.xml", r.status_code, len(r.content), "bytes")

    print("\n=== Regenerate then serve ===")
    r = client.get("/samples/canonical/roster-sample.xml/regenerate")
    ok("GET /samples/canonical/roster-sample.xml/regenerate", r) and print("  GET .../regenerate", r.status_code, len(r.content), "bytes")

    print("\n=== Transform (roster has transform) ===")
    r = client.post("/transform/roster")
    ok("POST /transform/roster", r) and print("  POST /transform/roster", r.status_code, r.json() if r.status_code == 200 else r.text[:100])
    r = client.post("/transform/roster", params={"content": 1})
    ok("POST /transform/roster?content=1", r) and print("  POST /transform/roster?content=1", r.status_code, "xml" in (r.headers.get("content-type") or ""))
    r = client.post("/transform/roster/content")
    ok("POST /transform/roster/content", r) and print("  POST /transform/roster/content", r.status_code, len(r.content) if r.status_code == 200 else 0, "bytes")
    r = client.post("/transform", json={"target": "roster"})
    ok("POST /transform {target: roster}", r) and print("  POST /transform body target=roster", r.status_code)

    print("\n=== Provider Directory (single canonical, no variant selector) ===")
    r = client.post("/samples/generate", json={"target": "providerdirectory"})
    ok("POST /samples/generate {target: providerdirectory}", r) and print(
        "  POST /samples/generate providerdirectory", r.status_code, r.json().get("success")
    )
    r = client.post("/transform/providerdirectory/content")
    ok("POST /transform/providerdirectory/content (no provider_directory_child)", r) and print(
        "  POST /transform/providerdirectory/content",
        r.status_code,
        "multipart/xml" in (r.headers.get("content-type") or ""),
    )

    print("\n=== Download FHIR sample ===")
    r = client.get("/samples/fhir/roster-patient-fhir.xml")
    ok("GET /samples/fhir/roster-patient-fhir.xml", r) and print("  GET /samples/fhir/roster-patient-fhir.xml", r.status_code, len(r.content), "bytes")

    print("\n=== Error cases ===")
    r = client.post("/samples/generate", json={})
    if r.status_code in (400, 422):
        print("  POST /samples/generate (no body)", r.status_code)
    else:
        failures.append(f"POST /samples/generate no body: expected 400/422, got {r.status_code}")
    r = client.post("/samples/generate", json={"target": "nonexistent"})
    ok("POST /samples/generate bad target", r, 400) and print("  POST /samples/generate bad target", r.status_code)
    r = client.get("/samples/canonical/nonexistent.xml")
    ok("GET /samples/canonical/nonexistent", r, 404) and print("  GET canonical nonexistent 404", r.status_code)
    r = client.post("/transform/nonexistent")
    ok("POST /transform bad target", r, 400) and print("  POST /transform bad target", r.status_code)
    r = client.post("/transform/providerdirectory")
    ok("POST /transform providerdirectory (single build)", r) and print(
        "  POST /transform providerdirectory", r.status_code, r.json().get("success") if r.status_code == 200 else r.text[:120]
    )
    r = client.get("/schemas/nonexistent.xsd")
    ok("GET /schemas/nonexistent", r, 404) and print("  GET /schemas/nonexistent 404", r.status_code)

    if failures:
        print("\nFAILURES:")
        for f in failures:
            print("  -", f)
        return 1
    print("\nAll endpoints OK.")
    return 0


if __name__ == "__main__":
    sys.exit(run())
