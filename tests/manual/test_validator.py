import requests
import os
import json
from pathlib import Path
from tools.transform_roster import apply_xslt

# The URL of your local sidecar service
VALIDATOR_URL = "http://localhost:4567/validate"

# The specific US Core Patient profile we want to check against
US_CORE_PATIENT_PROFILE = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"


def test_patient_validation():
    """
    Transform roster XML to FHIR Patient XML and validate it against US Core Patient profile.
    """
    # Setup paths - get project root (go up 3 levels from tests/manual/)
    project_root = Path(__file__).parent.parent.parent
    base_dir = str(project_root)
    roster_xml = os.path.join(base_dir, "canonical-samples/v10.0/roster-sample.xml")
    xslt_file = os.path.join(base_dir, "transforms/v10.0/roster-patient.xsl")
    
    print("=" * 60)
    print("FHIR Validator Test - Roster to Patient Transform")
    print("=" * 60)
    print(f"\n1. Loading roster XML from: {roster_xml}")
    
    # Check if files exist
    if not os.path.exists(roster_xml):
        print(f"ERROR: Roster XML file not found: {roster_xml}")
        return
    
    if not os.path.exists(xslt_file):
        print(f"ERROR: XSLT file not found: {xslt_file}")
        return
    
    print(f"2. Applying XSLT transform: {xslt_file}")
    
    # Transform roster XML to FHIR Patient XML (returns as string)
    try:
        patient_xml = apply_xslt(base_dir, roster_xml, xslt_file, output_file=None)
        print("   [OK] Transformation successful")
    except Exception as e:
        print(f"   [ERROR] Transformation failed: {e}")
        return
    
    print(f"3. Sending Patient XML to validator at {VALIDATOR_URL}")
    print(f"   Profile: {US_CORE_PATIENT_PROFILE}")
    
    # Send the request to the sidecar
    try:
        params = {'profile': US_CORE_PATIENT_PROFILE}
        response = requests.post(
            VALIDATOR_URL,
            params=params,
            data=patient_xml,
            headers={'Content-Type': 'application/fhir+xml'},
            timeout=30
        )
        response.raise_for_status()
    except requests.exceptions.ConnectionError:
        print("   [ERROR] Could not connect to validator service.")
        print("   Make sure the validator service is running:")
        print("   - Run: docker compose up -d")
        print("   - Wait ~30 seconds for initialization")
        print("   - Load the package: curl -X POST -H 'Content-Type: application/gzip' -H 'Content-Encoding: gzip' --data-binary '@assets/fhir-packages/package.tgz' 'http://localhost:4567/igs'")
        return
    except requests.exceptions.RequestException as e:
        print(f"   [ERROR] Request failed: {e}")
        return
    
    # Parse and display results
    print("\n4. Validation Results:")
    print("-" * 60)
    
    try:
        result = response.json()
        
        # Debug: Optionally print full response (uncomment if needed)
        # print("\n[DEBUG] Full JSON Response:")
        # print(json.dumps(result, indent=2))
        
        # Check if validation was successful
        if result.get('resourceType') == 'OperationOutcome':
            issues = result.get('issue', [])
            
            if not issues:
                print("[OK] No validation issues found!")
            else:
                # Group issues by severity
                errors = [i for i in issues if i.get('severity') == 'error']
                warnings = [i for i in issues if i.get('severity') == 'warning']
                informations = [i for i in issues if i.get('severity') == 'information']
                
                print(f"\nFound {len(issues)} validation issue(s):")
                print(f"  - Errors: {len(errors)}")
                print(f"  - Warnings: {len(warnings)}")
                print(f"  - Informations: {len(informations)}")
                
                def print_issue(issue, index=None):
                    """Helper to print issue details"""
                    prefix = f"  [{index}] " if index is not None else "  "
                    
                    # Get all possible fields
                    severity = issue.get('severity', 'unknown')
                    code = issue.get('code', {})
                    if isinstance(code, dict):
                        code_str = code.get('code', 'N/A')
                        code_system = code.get('system', '')
                        code_display = code.get('display', '')
                        code_text = f"{code_str}" + (f" ({code_display})" if code_display else "")
                    else:
                        code_text = str(code)
                    
                    details = issue.get('details', {})
                    if isinstance(details, dict):
                        details_text = details.get('text', details.get('display', 'No details'))
                    else:
                        details_text = str(details) if details else 'No details'
                    
                    diagnostics = issue.get('diagnostics', '')
                    expression = issue.get('expression', [])
                    location = issue.get('location', [])
                    
                    print(f"{prefix}Severity: {severity.upper()}")
                    if code_text and code_text != 'N/A':
                        print(f"       Code: {code_text}")
                    if details_text and details_text != 'No details':
                        print(f"       Details: {details_text}")
                    if diagnostics:
                        print(f"       Diagnostics: {diagnostics}")
                    if expression:
                        print(f"       Expression: {', '.join(expression) if isinstance(expression, list) else expression}")
                    if location:
                        loc_str = ', '.join(location) if isinstance(location, list) else str(location)
                        print(f"       Location: {loc_str}")
                    print()
                
                if errors:
                    print("\n[ERRORS]")
                    for idx, issue in enumerate(errors, 1):
                        print_issue(issue, idx)
                
                if warnings:
                    print("\n[WARNINGS]")
                    for idx, issue in enumerate(warnings, 1):
                        print_issue(issue, idx)
                
                if informations:
                    print("\n[INFORMATION]")
                    for idx, issue in enumerate(informations[:10], 1):  # Show first 10
                        print_issue(issue, idx)
                    if len(informations) > 10:
                        print(f"  ... and {len(informations) - 10} more information messages\n")
        else:
            print("Unexpected response format. Full response:")
            print(json.dumps(result, indent=2))
            
    except ValueError as e:
        print(f"[ERROR] Failed to parse JSON response: {e}")
        print(f"Response text (first 500 chars): {response.text[:500]}")
    except Exception as e:
        print(f"[ERROR] Error processing response: {e}")
        print(f"Response status: {response.status_code}")
        print(f"Response text (first 500 chars): {response.text[:500]}")
    
    print("=" * 60)


if __name__ == "__main__":
    test_patient_validation()
