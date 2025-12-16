"""
Generate markdown documentation for all XSD schemas.
Processes all .xsd files in the schemas/ directory and generates corresponding markdown files.
"""
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
    """Main function that processes all schemas in the schemas/v10.0/ directory."""
    print("="*80)
    print("XSD to Markdown - Generate All Schemas")
    print("="*80)
    
    # Get optional release tag from command line
    release_tag = sys.argv[1] if len(sys.argv) > 1 else None
    if release_tag:
        print(f"\nUsing release tag: {release_tag}")
    
    # Create docs directory
    docs_dir = Path("docs")
    docs_dir.mkdir(exist_ok=True)
    print(f"Output directory: {docs_dir}\n")
    
    # Discover all .xsd files in schemas/v10.0/ directory
    schemas_dir = Path("schemas") / "v10.0"
    if not schemas_dir.exists():
        print(f"Failed: Error: schemas directory not found: {schemas_dir}")
        sys.exit(1)
    
    xsd_files = sorted(schemas_dir.glob("*.xsd"))
    
    if not xsd_files:
        print(f"Failed: No XSD files found in {schemas_dir}")
        sys.exit(1)
    
    print(f"Found {len(xsd_files)} schema(s) to process:\n")
    
    # Process each schema
    results = []
    for xsd_path in xsd_files:
        success, output_path = process_schema(xsd_path, release_tag)
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