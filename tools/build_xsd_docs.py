"""
Generate markdown documentation for all XSD schemas in a specified schemas/ subfolder.
Processes all .xsd files in the specified schemas/ subdirectory and generates corresponding markdown files.
"""
import argparse
import subprocess
import sys
from pathlib import Path

def process_schema(xsd_path, release_tag=None):
    """
    Process a single schema and generate markdown documentation.
    
    Args:
        xsd_path: Path to the XSD file
        release_tag: Optional release tag for versioning
        
    Returns:
        Tuple of (success: bool, output_path: str)
    """
    schema_name = xsd_path.stem
    output_path = Path("docs") / f"{schema_name}_Guide.md"
    
    # Build command
    cmd = [sys.executable, "tools/xsd_to_md.py", str(xsd_path), str(output_path)]
    if release_tag:
        cmd.append(release_tag)
    
    print(f"Generating {schema_name} Markdown from XSD...")
    print(f"  Input: {xsd_path}")
    print(f"  Output: {output_path}")
    
    # Generate markdown
    result = subprocess.run(cmd, capture_output=True, text=True)
    
    if result.stdout:
        print(result.stdout)
    if result.stderr:
        print(result.stderr, file=sys.stderr)
    
    if result.returncode != 0:
        print(f"Failed to generate markdown for {schema_name}")
        return False, output_path
    else:
        print(f"Successfully generated: {output_path}\n")
        return True, output_path

def main():
    """
    Main function that processes all schemas in a specified schemas/ subfolder.
    Uses argparse to accept the subfolder name as a required argument and optional release tag.
    """
    parser = argparse.ArgumentParser(
        description='Generate markdown documentation for XSD schemas in a schemas/ subfolder'
    )
    parser.add_argument(
        'subfolder',
        help='Subfolder name within schemas/ (e.g., v10.0)'
    )
    parser.add_argument(
        '--release-tag', '-r',
        help='Optional release tag for versioning'
    )
    
    args = parser.parse_args()
    
    # Validate subfolder is not fhir-schemas
    if args.subfolder == 'fhir-schemas' or args.subfolder.startswith('fhir-schemas/'):
        print(f"Error: fhir-schemas directory is excluded from processing")
        sys.exit(1)
    
    print("="*80)
    print("XSD to Markdown - Generate All Schemas")
    print("="*80)
    
    if args.release_tag:
        print(f"\nUsing release tag: {args.release_tag}")
    
    # Create docs directory
    docs_dir = Path("docs")
    docs_dir.mkdir(exist_ok=True)
    print(f"Output directory: {docs_dir}\n")
    
    # Discover all .xsd files in schemas/<subfolder>/ directory
    schemas_dir = Path("schemas") / args.subfolder
    
    # Validate directory exists
    if not schemas_dir.exists():
        print(f"Error: Directory not found: {schemas_dir}")
        sys.exit(1)
    
    xsd_files = sorted(schemas_dir.glob("*.xsd"))
    
    if not xsd_files:
        print(f"Failed: No XSD files found in {schemas_dir}")
        sys.exit(1)
    
    print(f"Found {len(xsd_files)} schema(s) to process:\n")
    
    # Process each schema
    results = []
    for xsd_path in xsd_files:
        success, output_path = process_schema(xsd_path, args.release_tag)
        results.append((xsd_path.stem, success, output_path))
    
    # Print summary
    print("="*80)
    print("Summary")
    print("="*80)
    
    successful = sum(1 for _, success, _ in results if success)
    failed = len(results) - successful
    
    for schema_name, success, output_path in results:
        status = "Success" if success else "Failed"
        print(f"{status} {schema_name}.xsd → {output_path}")
    
    print(f"\nTotal: {successful} successful, {failed} failed (out of {len(results)})")
    print("="*80)
    
    # Exit with error code if any failed
    sys.exit(0 if failed == 0 else 1)

if __name__ == "__main__":
    main()
