# main.py
import xmlschema
from pathlib import Path
from lxml import etree
from tools.build_sample_file import build_element, DEFAULT_VERSION_DIR
import yaml
import argparse

def build_sample_file(canonical_name, root_element_name, schema_file_name, output_file_name, provider_directory_child=None, output_dir=None, version=DEFAULT_VERSION_DIR):
    #Get path and load schema
    base_dir = Path(__file__).resolve().parent.parent
    schema_path = base_dir / "schemas" / version / f"{schema_file_name}"
    schema = xmlschema.XMLSchema(str(schema_path))

    # call builder function and pass in schema, along with root name to get the process started (recursion takes over once in function)
    # built_xml = build_element(canonical_name, root_element_name, schema)

    # if provider_directory_child is not "None":
    #     built_xml = build_element(root_element_name, schema, canonical_name=canonical_name, child_choice=provider_directory_child)
    # else:
    #     built_xml = build_element(root_element_name, schema, canonical_name=canonical_name)


    # Build with optional child_choice parameter
    built_xml = build_element(
        root_element_name,
        schema,
        canonical_name=canonical_name,
        child_choice=provider_directory_child,
        version_dir=version
    )


    # Write to file - use provided output_dir or default to project canonical-samples
    if output_dir is None:
        output_dir = base_dir / "canonical-samples" / version
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    output_path = output_dir / output_file_name
    
    with open(output_path, "wb") as f:
        f.write(etree.tostring(built_xml, pretty_print=True, xml_declaration=True, encoding='UTF-8'))
    print(f"Sample XML generated as {output_path}")

def main():
    """Build sample files driven by a YAML configuration."""
    here = Path(__file__).resolve()
    project_root = here.parents[1]

    parser = argparse.ArgumentParser(
        description="Generate sample files from YAML config",
        epilog=(
            "Examples:\n"
            "  python -m tools.build_all_sample_files                    # every build in the config\n"
            f"  python -m tools.build_all_sample_files --version {DEFAULT_VERSION_DIR}     # only the current default\n"
            "  python -m tools.build_all_sample_files --version v10.0    # only the v10.0 line"
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "--config",
        type=Path,
        default=project_root / "config" / "sample_builds.yaml",
        help="Path to YAML config listing sample builds",
    )
    parser.add_argument(
        "--version",
        metavar="FOLDER",
        default=None,
        help=(
            "Build only the entries for this schemas/ subfolder (e.g. v11.0, v10.0). "
            "Builds that omit 'version' in the config count as "
            f"{DEFAULT_VERSION_DIR}. Default: build every entry."
        ),
    )
    args = parser.parse_args()

    if not args.config.exists():
        raise FileNotFoundError(f"Config file not found: {args.config}")

    with open(args.config, "r", encoding="utf-8") as f:
        cfg = yaml.safe_load(f) or {}

    builds = cfg.get("builds", [])
    if not builds:
        raise ValueError("No 'builds' entries found in config YAML")

    if args.version:
        schemas_dir = project_root / "schemas" / args.version
        if not schemas_dir.is_dir():
            available = sorted(p.name for p in (project_root / "schemas").iterdir()
                               if p.is_dir() and p.name != "fhir-schemas")
            raise SystemExit(
                f"No such schemas folder: schemas/{args.version}. "
                f"Available: {', '.join(available)}"
            )
        selected = [b for b in builds
                    if (b.get("version") or DEFAULT_VERSION_DIR) == args.version]
        if not selected:
            raise SystemExit(
                f"No builds configured for version {args.version} in {args.config}"
            )
        builds = selected

    print(f"Using config: {args.config}")
    if args.version:
        print(f"Filtering to version: {args.version}")
    for idx, b in enumerate(builds, start=1):
        canonical_name = b.get("canonical_name")
        root_element_name = b.get("root_element_name")
        schema_file_name = b.get("schema_file_name")
        output_file_name = b.get("output_file_name")
        provider_directory_child = b.get("provider_directory_child")
        version = b.get("version") or DEFAULT_VERSION_DIR

        if not all([canonical_name, root_element_name, schema_file_name, output_file_name]):
            raise ValueError(f"Missing required keys in build #{idx}: {b}")

        print(f"[{idx}/{len(builds)}] Building {version}/{output_file_name} from {schema_file_name} ...")
        build_sample_file(
            canonical_name,
            root_element_name,
            schema_file_name,
            output_file_name,
            provider_directory_child=provider_directory_child,
            version=version,
        )

if __name__ == "__main__":
    main()