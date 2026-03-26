#!/usr/bin/env python3
"""
Smart pipeline runner for CoCo canonical models.

Orchestrates the complete pipeline:
1. Build sample XML from schema
2. Validate against XSD
3. Transform to FHIR (if transform exists)
4. Validate FHIR (if transform exists)
"""

import argparse
import subprocess
import sys
import time
from pathlib import Path
import yaml
import requests

# Add project root to Python path so we can import tools modules
script_dir = Path(__file__).resolve().parent
project_root = script_dir.parent
if str(project_root) not in sys.path:
    sys.path.insert(0, str(project_root))

# Import project modules
from tools.build_all_sample_files import build_sample_file
from tools.validate_xml import validate_xml
from tools.transform_schema import apply_xslt, fhir_output_name, transform_specs_from_build


VALIDATOR_URL = "http://localhost:4567/validate"
VALIDATOR_HEALTH_URL = "http://localhost:4567/health"
IGS_URL = "http://localhost:4567/igs"


def find_build_config(config_path, target_name):
    """
    Find build configuration for a target canonical name (case-insensitive).
    
    Args:
        config_path: Path to sample_builds.yaml
        target_name: Canonical name to find (case-insensitive)
        
    Returns:
        dict: Build configuration entry
        
    Raises:
        ValueError: If target not found or config invalid
    """
    with open(config_path, 'r', encoding='utf-8') as f:
        cfg = yaml.safe_load(f) or {}
    
    builds = cfg.get("builds", [])
    if not builds:
        raise ValueError("No 'builds' entries found in config YAML")
    
    # Case-insensitive search
    target_lower = target_name.lower()
    for build in builds:
        canonical_name = build.get("canonical_name", "").lower()
        if canonical_name == target_lower:
            return build
    
    available = [b.get("canonical_name") for b in builds]
    raise ValueError(
        f"Target '{target_name}' not found in config. "
        f"Available targets: {', '.join(available)}"
    )


def check_docker_running():
    """Check if Docker is running and accessible."""
    try:
        result = subprocess.run(
            ["docker", "info"],
            capture_output=True,
            text=True,
            timeout=5
        )
        return result.returncode == 0
    except (subprocess.TimeoutExpired, FileNotFoundError):
        return False


def check_container_running(container_name="coco-canonical-validator-1"):
    """Check if the validator container is running."""
    try:
        result = subprocess.run(
            ["docker", "ps", "--filter", f"name={container_name}", "--format", "{{.Names}}"],
            capture_output=True,
            text=True,
            timeout=5
        )
        return container_name in result.stdout
    except (subprocess.TimeoutExpired, FileNotFoundError):
        return False


def start_docker_container():
    """Start the Docker Compose validator service."""
    print("Starting Docker Compose validator service...")
    try:
        result = subprocess.run(
            ["docker", "compose", "up", "-d"],
            capture_output=True,
            text=True,
            timeout=30
        )
        if result.returncode != 0:
            print(f"Error starting Docker container: {result.stderr}")
            return False
        print("Docker container started. Waiting for service to be ready...")
        return True
    except (subprocess.TimeoutExpired, FileNotFoundError) as e:
        print(f"Error starting Docker: {e}")
        return False


def wait_for_validator(timeout=60):
    """Wait for validator service to be ready."""
    start_time = time.time()
    while time.time() - start_time < timeout:
        try:
            response = requests.get(VALIDATOR_HEALTH_URL, timeout=2)
            if response.status_code == 200:
                print("Validator service is ready.")
                return True
        except requests.exceptions.RequestException:
            pass
        time.sleep(2)
    return False


def load_fhir_package(base_dir):
    """Load FHIR package into validator if not already loaded."""
    package_path = base_dir / "assets" / "fhir-packages" / "package.tgz"
    if not package_path.exists():
        print(f"Warning: FHIR package not found at {package_path}")
        return False
    
    print("Loading FHIR package into validator...")
    try:
        with open(package_path, 'rb') as f:
            response = requests.post(
                IGS_URL,
                headers={
                    'Content-Type': 'application/gzip',
                    'Content-Encoding': 'gzip'
                },
                data=f.read(),
                timeout=60
            )
            if response.status_code in (200, 201):
                print("FHIR package loaded successfully.")
                return True
            else:
                print(f"Warning: Failed to load package (status {response.status_code})")
                return False
    except Exception as e:
        print(f"Warning: Error loading FHIR package: {e}")
        return False


def validate_fhir(fhir_xml, profile_url):
    """
    Validate FHIR XML against a profile.
    
    Args:
        fhir_xml: FHIR XML as string
        profile_url: Profile URL to validate against
        
    Returns:
        tuple: (has_errors: bool, result: dict)
    """
    try:
        response = requests.post(
            VALIDATOR_URL,
            params={'profile': profile_url},
            data=fhir_xml,
            headers={'Content-Type': 'application/fhir+xml'},
            timeout=30
        )
        response.raise_for_status()
        result = response.json()
        
        if result.get('resourceType') == 'OperationOutcome':
            issues = result.get('issue', [])
            errors = [i for i in issues if i.get('severity') == 'error']
            warnings = [i for i in issues if i.get('severity') == 'warning']
            
            print(f"\nFHIR Validation Results:")
            print(f"  Errors: {len(errors)}")
            print(f"  Warnings: {len(warnings)}")
            
            if errors:
                print("\n  [ERRORS]")
                for idx, err in enumerate(errors[:5], 1):  # Show first 5
                    details = err.get('details', {})
                    if isinstance(details, dict):
                        text = details.get('text', details.get('display', 'No details'))
                    else:
                        text = str(details)
                    print(f"    [{idx}] {text}")
                if len(errors) > 5:
                    print(f"    ... and {len(errors) - 5} more errors")
            
            if warnings:
                print("\n  [WARNINGS]")
                for idx, warn in enumerate(warnings[:5], 1):  # Show first 5
                    details = warn.get('details', {})
                    if isinstance(details, dict):
                        text = details.get('text', details.get('display', 'No details'))
                    else:
                        text = str(details)
                    print(f"    [{idx}] {text}")
                if len(warnings) > 5:
                    print(f"    ... and {len(warnings) - 5} more warnings")
            
            return len(errors) > 0, result
        else:
            print("Unexpected response format from validator.")
            return False, result
            
    except requests.exceptions.ConnectionError:
        print("Warning: Could not connect to validator service.")
        print("  Skipping FHIR validation.")
        return False, None
    except requests.exceptions.RequestException as e:
        print(f"Warning: FHIR validation request failed: {e}")
        return False, None


def main():
    parser = argparse.ArgumentParser(
        description="Run complete pipeline for a canonical model target.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python tools/run_pipeline.py --target roster
  python tools/run_pipeline.py --target eob
        """
    )
    parser.add_argument(
        "--target",
        required=True,
        help="Canonical name of the target model (case-insensitive, e.g., 'roster', 'eob')"
    )
    parser.add_argument(
        "--config",
        type=Path,
        default=None,
        help="Path to sample_builds.yaml (default: config/sample_builds.yaml)"
    )
    
    args = parser.parse_args()
    
    # Determine project root and config path (project_root already set at module level)
    config_path = args.config or (project_root / "config" / "sample_builds.yaml")
    
    if not config_path.exists():
        print(f"Error: Config file not found: {config_path}", file=sys.stderr)
        sys.exit(1)
    
    # Find build configuration
    try:
        build_config = find_build_config(config_path, args.target)
    except ValueError as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
    
    print("=" * 70)
    print(f"CoCo Pipeline: {build_config['canonical_name']}")
    print("=" * 70)
    
    # Verify XSD file exists before building
    xsd_path = project_root / "schemas" / "v10.0" / build_config["schema_file_name"]
    if not xsd_path.exists():
        print(f"✗ Error: XSD schema file not found: {xsd_path}", file=sys.stderr)
        print(f"   Resolved from: schemas/v10.0/{build_config['schema_file_name']}", file=sys.stderr)
        sys.exit(1)
    
    # Step A: Build sample file
    print("\n[Step A] Building sample XML...")
    try:
        build_sample_file(
            canonical_name=build_config["canonical_name"],
            root_element_name=build_config["root_element_name"],
            schema_file_name=build_config["schema_file_name"],
            output_file_name=build_config["output_file_name"],
            provider_directory_child=build_config.get("provider_directory_child")
        )
        print("✓ Sample XML generated successfully")
    except Exception as e:
        print(f"✗ Error building sample: {e}", file=sys.stderr)
        sys.exit(1)
    
    # Step B: Validate XSD
    print("\n[Step B] Validating XML against XSD schema...")
    xml_path = project_root / "canonical-samples" / "v10.0" / build_config["output_file_name"]
    
    if not xml_path.exists():
        print(f"✗ Error: Generated XML file not found: {xml_path}", file=sys.stderr)
        sys.exit(1)
    
    try:
        is_valid, errors = validate_xml(xml_path, xsd_path)
        if is_valid:
            print("✓ XSD validation passed")
        else:
            print(f"✗ XSD validation failed: {len(errors)} error(s)", file=sys.stderr)
            for err in errors[:5]:  # Show first 5 errors
                print(f"  - {err}", file=sys.stderr)
            if len(errors) > 5:
                print(f"  ... and {len(errors) - 5} more errors", file=sys.stderr)
            sys.exit(1)
    except FileNotFoundError as e:
        print(f"✗ Error: File not found during XSD validation: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"✗ Error during XSD validation: {e}", file=sys.stderr)
        sys.exit(1)
    
    # Step C: Transform to FHIR (and validate when fhir_profile is set)
    transform_specs = transform_specs_from_build(build_config)
    fhir_profile = build_config.get("fhir_profile")

    if transform_specs:
        print("\n[Step C] XSLT -> FHIR samples...")
        fhir_dir = project_root / "fhir-samples" / "v10.0"
        fhir_dir.mkdir(parents=True, exist_ok=True)

        for tf in transform_specs:
            transform_path = project_root / tf
            if not transform_path.exists():
                print(f"✗ Transform file not found: {transform_path}", file=sys.stderr)
                sys.exit(1)
            out_name = fhir_output_name(tf, provider_variant=build_config.get("provider_directory_child"))
            fhir_out = fhir_dir / out_name
            print(f"\n  Applying {tf} -> {out_name}")
            try:
                apply_xslt(
                    str(project_root),
                    str(xml_path),
                    str(transform_path),
                    str(fhir_out),
                )
                print("  ✓ Transformation successful")
            except Exception as e:
                print(f"  ✗ Transformation failed: {e}", file=sys.stderr)
                sys.exit(1)

        if fhir_profile and fhir_profile != "null" and len(transform_specs) == 1:
            print("\n[Step C continued] FHIR validation (single transform + profile)...")
            if not check_docker_running():
                print("Error: Docker is not running. Please start Docker and try again.", file=sys.stderr)
                sys.exit(1)

            if not check_container_running():
                if not start_docker_container():
                    print("Warning: Could not start Docker container. Continuing anyway...")
                elif not wait_for_validator():
                    print("Warning: Validator service did not become ready. Continuing anyway...")

            load_fhir_package(project_root)
            fhir_xml_path = fhir_dir / fhir_output_name(
                transform_specs[0], provider_variant=build_config.get("provider_directory_child")
            )
            fhir_xml = fhir_xml_path.read_text(encoding="utf-8")
            print(f"\n  Validating FHIR against profile: {fhir_profile}")
            has_errors, _ = validate_fhir(fhir_xml, fhir_profile)

            if has_errors:
                print("  ⚠ FHIR validation found errors (see above)")
            else:
                print("  ✓ FHIR validation passed (no errors)")
        elif fhir_profile and fhir_profile != "null" and len(transform_specs) > 1:
            print("\n  (Skipping automated FHIR validation: multiple transforms; no single profile.)")
    else:
        print("\n[Step C] Skipping transform (no transform_file / transform_files configured)")
    
    print("\n" + "=" * 70)
    print("Pipeline completed successfully!")
    print("=" * 70)


if __name__ == "__main__":
    main()
