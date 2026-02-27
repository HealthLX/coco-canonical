# main.py
import xmlschema
from pathlib import Path
from lxml import etree
from tools.build_sample_file import build_element
import yaml
import argparse

def build_sample_file(canonical_name, root_element_name, schema_file_name, output_file_name, provider_directory_child=None, output_dir=None):
    #Get path and load schema
    base_dir = Path(__file__).resolve().parent.parent
    schema_path = base_dir / "schemas" / "v10.0" / f"{schema_file_name}"
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
        child_choice=provider_directory_child
    )


    # Write to file - use provided output_dir or default to project canonical-samples
    if output_dir is None:
        output_dir = base_dir / "canonical-samples" / "v10.0"
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

    parser = argparse.ArgumentParser(description="Generate sample files from YAML config")
    parser.add_argument(
        "--config",
        type=Path,
        default=project_root / "config" / "sample_builds.yaml",
        help="Path to YAML config listing sample builds",
    )
    args = parser.parse_args()

    if not args.config.exists():
        raise FileNotFoundError(f"Config file not found: {args.config}")

    with open(args.config, "r", encoding="utf-8") as f:
        cfg = yaml.safe_load(f) or {}

    builds = cfg.get("builds", [])
    if not builds:
        raise ValueError("No 'builds' entries found in config YAML")

    print(f"Using config: {args.config}")
    for idx, b in enumerate(builds, start=1):
        canonical_name = b.get("canonical_name")
        root_element_name = b.get("root_element_name")
        schema_file_name = b.get("schema_file_name")
        output_file_name = b.get("output_file_name")
        provider_directory_child = b.get("provider_directory_child")

        if not all([canonical_name, root_element_name, schema_file_name, output_file_name]):
            raise ValueError(f"Missing required keys in build #{idx}: {b}")

        print(f"[{idx}/{len(builds)}] Building {output_file_name} from {schema_file_name} ...")
        build_sample_file(
            canonical_name,
            root_element_name,
            schema_file_name,
            output_file_name,
            provider_directory_child=provider_directory_child,
        )

if __name__ == "__main__":
    main()