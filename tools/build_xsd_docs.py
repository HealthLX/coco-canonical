"""
Generate markdown documentation for all XSD schemas in a specified schemas/ subfolder.
Processes all .xsd files in the specified schemas/ subdirectory and generates corresponding markdown files.
"""
import argparse
import subprocess
import sys
from pathlib import Path

def process_schema(xsd_path, release_tag=None, continue_on_error=True):
    """
    Process a single schema and generate markdown documentation.
    
    Args:
        xsd_path: Path to the XSD file
        release_tag: Optional release tag for versioning
        continue_on_error: If False, raise exception on error; if True, return (False, path)
        
    Returns:
        Tuple of (success: bool, output_path: str, error_message: str or None)
        
    Raises:
        Exception: If continue_on_error is False and processing fails
    """
    schema_name = xsd_path.stem
    output_path = Path("docs") / f"{schema_name}_Guide.md"
    
    # Validate xsd_to_md.py script exists
    script_path = Path("tools/xsd_to_md.py")
    if not script_path.exists():
        error_msg = f"Error: xsd_to_md.py script not found at {script_path.absolute()}"
        if continue_on_error:
            print(error_msg, file=sys.stderr)
            return False, output_path, error_msg
        else:
            raise FileNotFoundError(error_msg)
    
    # Build command
    cmd = [sys.executable, str(script_path), str(xsd_path), str(output_path)]
    if release_tag:
        cmd.append(release_tag)
    
    print(f"Generating {schema_name} Markdown from XSD...")
    print(f"  Input: {xsd_path}")
    print(f"  Output: {output_path}")
    
    # Generate markdown
    try:
        result = subprocess.run(cmd, capture_output=True, text=True)
    except Exception as e:
        error_msg = f"Error running xsd_to_md.py: {e}"
        if continue_on_error:
            print(error_msg, file=sys.stderr)
            return False, output_path, error_msg
        else:
            raise
    
    if result.stdout:
        print(result.stdout)
    if result.stderr:
        print(result.stderr, file=sys.stderr)
    
    if result.returncode != 0:
        error_msg = f"Failed to generate markdown for {schema_name} (exit code {result.returncode})"
        print(error_msg, file=sys.stderr)
        if result.stderr:
            error_msg += f"\nDetails: {result.stderr}"
        if continue_on_error:
            return False, output_path, error_msg
        else:
            raise RuntimeError(error_msg)
    else:
        print(f"Successfully generated: {output_path}\n")
        return True, output_path, None

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
    parser.add_argument(
        '--stop-on-error', '-s',
        action='store_true',
        help='Stop processing on first error instead of continuing'
    )
    
    args = parser.parse_args()
    
    # Validate subfolder is not fhir-schemas
    if args.subfolder == 'fhir-schemas' or args.subfolder.startswith('fhir-schemas/'):
        print(f"Error: fhir-schemas directory is excluded from processing", file=sys.stderr)
        sys.exit(1)
    
    print("="*80)
    print("XSD to Markdown - Generate All Schemas")
    print("="*80)
    
    if args.release_tag:
        print(f"\nUsing release tag: {args.release_tag}")
    
    # Create docs directory
    docs_dir = Path("docs")
    try:
        docs_dir.mkdir(exist_ok=True)
        print(f"Output directory: {docs_dir}\n")
    except Exception as e:
        print(f"Error: Cannot create output directory {docs_dir}: {e}", file=sys.stderr)
        sys.exit(1)
    
    # Discover all .xsd files in schemas/<subfolder>/ directory
    schemas_dir = Path("schemas") / args.subfolder
    
    # Validate directory exists
    if not schemas_dir.exists():
        print(f"Error: Directory not found: {schemas_dir}", file=sys.stderr)
        sys.exit(1)
    
    if not schemas_dir.is_dir():
        print(f"Error: Path is not a directory: {schemas_dir}", file=sys.stderr)
        sys.exit(1)
    
    xsd_files = sorted(schemas_dir.glob("*.xsd"))
    
    if not xsd_files:
        print(f"Failed: No XSD files found in {schemas_dir}", file=sys.stderr)
        sys.exit(1)
    
    print(f"Found {len(xsd_files)} schema(s) to process:\n")
    
    # Process each schema
    results = []
    errors = []
    continue_on_error = not args.stop_on_error
    
    for xsd_path in xsd_files:
        try:
            success, output_path, error_msg = process_schema(xsd_path, args.release_tag, continue_on_error)
            results.append((xsd_path.stem, success, output_path))
            if error_msg:
                errors.append((xsd_path.stem, error_msg))
        except Exception as e:
            error_msg = f"Unexpected error processing {xsd_path.stem}: {e}"
            print(error_msg, file=sys.stderr)
            results.append((xsd_path.stem, False, Path("docs") / f"{xsd_path.stem}_Guide.md"))
            errors.append((xsd_path.stem, error_msg))
            if args.stop_on_error:
                break
    
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
    
    # Print error details if any
    if errors:
        print("\n" + "="*80)
        print("Error Details")
        print("="*80)
        for schema_name, error_msg in errors:
            print(f"\n{schema_name}:")
            print(f"  {error_msg}")
    
    print("="*80)
    
    # Exit with error code if any failed
    sys.exit(0 if failed == 0 else 1)

if __name__ == "__main__":
    main()
