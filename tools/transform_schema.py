"""
Apply XSLT transforms: canonical XML to FHIR (Saxon).

Batch mode walks ``config/sample_builds.yaml`` and applies each build's transforms to that
build's canonical sample (aligned with ``schema_file_name``). Single-shot mode takes
explicit ``--canonical-xml``, ``--xslt``, and optional ``--schema`` (XSD pre-check).
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

import yaml
from saxonche import PySaxonProcessor
from xml.dom import minidom


def fhir_output_name(xslt_path: str, provider_variant: str | None = None) -> str:
    """
    Derive FHIR sample filename from XSLT path, e.g. roster-patient.xsl -> roster-patient-fhir.xml.
    When provider_variant is set (provider_directory_child), avoid clobbering outputs across
    practitioner vs providing_organization samples, e.g. Provider_Location-practitioner-fhir.xml.
    """
    name = Path(xslt_path).name
    stem = name[:-4] if name.endswith(".xsl") else name
    mid = f"-{provider_variant}" if provider_variant else ""
    return f"{stem}{mid}-fhir.xml"


def transform_specs_from_build(build: dict) -> list[str]:
    """Collect XSLT paths from a sample_builds.yaml build entry (transform_file + transform_files)."""
    paths: list[str] = []
    tf = build.get("transform_file")
    if tf and str(tf).lower() != "null":
        paths.append(str(tf))
    for item in build.get("transform_files") or []:
        t = item.get("transform_file")
        if t:
            paths.append(str(t))
    return paths


def run_all_transforms_from_config(
    base_dir: str | Path,
    config_path: str | Path | None = None,
) -> None:
    """
    For each build in sample_builds.yaml that defines transforms, apply them to that build's
    canonical sample (output_file_name under canonical-samples/v10.0). Ensures each XSLT runs
    against the XML generated from that build's schema_file_name (e.g. Provider-Directory.xsd).
    """
    base_dir = Path(base_dir).resolve()
    if config_path is None:
        config_path = base_dir / "config" / "sample_builds.yaml"
    else:
        config_path = Path(config_path)

    with open(config_path, "r", encoding="utf-8") as f:
        cfg = yaml.safe_load(f) or {}

    builds = cfg.get("builds", [])
    fhir_dir = base_dir / "fhir-samples" / "v10.0"
    fhir_dir.mkdir(parents=True, exist_ok=True)
    canonical_dir = base_dir / "canonical-samples" / "v10.0"

    for build in builds:
        specs = transform_specs_from_build(build)
        if not specs:
            continue

        out_name = build.get("output_file_name")
        schema_name = build.get("schema_file_name")
        canonical_path = canonical_dir / out_name
        if not canonical_path.is_file():
            print(
                f"Skip transforms for {out_name}: canonical sample missing "
                "(generate with python -m tools.build_all_sample_files)"
            )
            continue

        print(
            f"Canonical: {canonical_path.name} (schema: {schema_name}) -> {len(specs)} transform(s)"
        )
        for xslt_rel in specs:
            xslt_path = base_dir / xslt_rel
            if not xslt_path.is_file():
                print(f"  XSLT not found: {xslt_rel}")
                continue
            dest = fhir_dir / fhir_output_name(
                xslt_rel, provider_variant=build.get("provider_directory_child")
            )
            print(f"  Applying {xslt_rel} -> {dest.name}")
            apply_xslt(str(base_dir), str(canonical_path), str(xslt_path), str(dest))
        print()


def run_transforms_for_schema(
    base_dir: str | Path,
    schema_name: str,
    config_path: str | Path | None = None,
    only_xslt: str | None = None,
) -> None:
    """
    Run transforms for builds that use a specific schema_file_name.

    Default behavior runs all mapped transforms per matching build.
    Use only_xslt to run a single transform per matching build.
    """
    base_dir = Path(base_dir).resolve()
    if config_path is None:
        config_path = base_dir / "config" / "sample_builds.yaml"
    else:
        config_path = Path(config_path)

    with open(config_path, "r", encoding="utf-8") as f:
        cfg = yaml.safe_load(f) or {}

    builds = cfg.get("builds", [])
    matching = [b for b in builds if (b.get("schema_file_name") or "").strip().lower() == schema_name.strip().lower()]
    if not matching:
        print(f"No builds found for schema: {schema_name}")
        return

    canonical_dir = base_dir / "canonical-samples" / "v10.0"
    fhir_dir = base_dir / "fhir-samples" / "v10.0"
    fhir_dir.mkdir(parents=True, exist_ok=True)

    for build in matching:
        all_specs = transform_specs_from_build(build)
        if only_xslt:
            wanted = Path(only_xslt).name.lower()
            specs = [s for s in all_specs if Path(s).name.lower() == wanted]
        else:
            specs = all_specs
        if not specs:
            print(f"Skip {build.get('output_file_name')}: no matching transforms")
            continue

        canonical_path = canonical_dir / build.get("output_file_name")
        if not canonical_path.is_file():
            print(
                f"Skip transforms for {build.get('output_file_name')}: canonical sample missing "
                "(generate with python -m tools.build_all_sample_files)"
            )
            continue

        print(
            f"Canonical: {canonical_path.name} (schema: {build.get('schema_file_name')}) -> {len(specs)} transform(s)"
        )
        for xslt_rel in specs:
            xslt_path = base_dir / xslt_rel
            if not xslt_path.is_file():
                print(f"  XSLT not found: {xslt_rel}")
                continue
            dest = fhir_dir / fhir_output_name(
                xslt_rel, provider_variant=build.get("provider_directory_child")
            )
            print(f"  Applying {xslt_rel} -> {dest.name}")
            apply_xslt(str(base_dir), str(canonical_path), str(xslt_path), str(dest))
        print()


def apply_xslt(base_dir, xml_file, xslt_file, output_file=None):
    """
    Apply an XSLT transformation to an XML file using Saxon.

    Args:
        xml_file: Path to the input XML file
        xslt_file: Path to the XSLT stylesheet file
        output_file: Optional path to save the output (if None, returns as string)

    Returns:
        Transformed XML as a string if output_file is None
    """
    with PySaxonProcessor(license=False) as proc:
        xslt_proc = proc.new_xslt30_processor()
        executable = xslt_proc.compile_stylesheet(stylesheet_file=xslt_file)
        result = executable.transform_to_string(source_file=xml_file)

        try:
            dom = minidom.parseString(result)
            pretty_xml = dom.toprettyxml(indent="  ", encoding="utf-8").decode("utf-8")
            pretty_xml = "\n".join([line for line in pretty_xml.split("\n") if line.strip()])
        except Exception as e:
            # Do not write invalid XML to disk; fail fast so we fix the transform/tools instead.
            snippet = result[:400].replace("\r", "\\r").replace("\n", "\\n")
            raise ValueError(
                f"XSLT output is not well-formed XML for xslt={xslt_file} input={xml_file}. "
                f"Parse error: {type(e).__name__}: {e}. Output starts with: {snippet!r}"
            ) from e

        if output_file:
            with open(output_file, "w", encoding="utf-8") as f:
                f.write(pretty_xml)
            print(f"Transformation complete. Output saved to {output_file}")
        else:
            return pretty_xml


def apply_xslt_with_params(xml_file, xslt_file, params=None, output_file=None):
    """
    Apply an XSLT transformation with parameters.
    """
    with PySaxonProcessor(license=False) as proc:
        xslt_proc = proc.new_xslt30_processor()

        if params:
            for key, value in params.items():
                xslt_proc.set_parameter(key, proc.make_string_value(value))

        executable = xslt_proc.compile_stylesheet(stylesheet_file=xslt_file)
        result = executable.transform_to_string(source_file=xml_file)

        if output_file:
            with open(output_file, "w", encoding="utf-8") as f:
                f.write(result)
            print(f"Transformation complete. Output saved to {output_file}")
        else:
            return result


def main(argv: list[str] | None = None) -> int:
    repo_root = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser(
        description=(
            "Apply XSLT (canonical XML to FHIR). "
            "With no single-transform options, runs all transforms from sample_builds.yaml "
            "(same behavior as the former transform_roster entry point)."
        )
    )
    parser.add_argument(
        "--config",
        type=Path,
        default=None,
        help="Path to sample_builds.yaml for batch mode (default: config/sample_builds.yaml)",
    )
    parser.add_argument(
        "--schema-name",
        type=str,
        default=None,
        metavar="NAME",
        help=(
            "Run transforms for builds mapped to this schema_file_name "
            "(e.g. Provider-Directory.xsd). Default for this mode is all transforms."
        ),
    )
    parser.add_argument(
        "--only-xslt",
        type=str,
        default=None,
        metavar="FILE",
        help="With --schema-name, run only this XSLT filename/path (e.g. Provider_Location.xsl).",
    )
    parser.add_argument(
        "--canonical-xml",
        type=Path,
        metavar="PATH",
        help="Canonical XML input file (single transform). Requires --xslt.",
    )
    parser.add_argument(
        "--xslt",
        type=Path,
        metavar="PATH",
        help="XSLT stylesheet path (single transform). Requires --canonical-xml.",
    )
    parser.add_argument(
        "--schema",
        type=Path,
        metavar="PATH",
        help="Optional XSD: validate canonical XML before transform (single transform only).",
    )
    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        default=None,
        help=(
            "Output XML path for single transform. "
            "Default: fhir-samples/v10.0/<xslt-stem>-fhir.xml (use --provider-variant to disambiguate)"
        ),
    )
    parser.add_argument(
        "--provider-variant",
        type=str,
        default=None,
        metavar="NAME",
        help="Optional filename suffix when using default output path (e.g. practitioner)",
    )

    args = parser.parse_args(argv)
    if args.only_xslt and not args.schema_name:
        parser.error("--only-xslt requires --schema-name.")

    single_mode = (
        args.canonical_xml is not None
        or args.xslt is not None
        or args.schema is not None
        or args.output is not None
        or args.provider_variant is not None
    )

    if single_mode:
        if args.canonical_xml is None or args.xslt is None:
            parser.error(
                "Single transform requires both --canonical-xml and --xslt "
                "(or omit all single-transform options for batch mode from YAML)."
            )
        cx = args.canonical_xml.resolve()
        xs = args.xslt.resolve()
        if not cx.is_file():
            parser.error(f"canonical XML not found: {cx}")
        if not xs.is_file():
            parser.error(f"XSLT not found: {xs}")

        if args.schema is not None:
            from tools.validate_xml import validate_xml

            sp = args.schema.resolve()
            if not sp.is_file():
                parser.error(f"schema (XSD) not found: {sp}")
            ok, log = validate_xml(cx, sp)
            if not ok:
                print("XSD validation failed:", file=sys.stderr)
                for err in log:
                    print(f"  {err}", file=sys.stderr)
                return 1
            print("XSD validation passed.")

        out_path = args.output
        if out_path is None:
            fhir_dir = repo_root / "fhir-samples" / "v10.0"
            fhir_dir.mkdir(parents=True, exist_ok=True)
            out_path = fhir_dir / fhir_output_name(str(xs), provider_variant=args.provider_variant)
        else:
            out_path = Path(out_path)
            out_path.parent.mkdir(parents=True, exist_ok=True)

        apply_xslt(str(repo_root), str(cx), str(xs), str(out_path))
        return 0

    if args.schema_name:
        print(f"Running transforms for schema {args.schema_name} ...\n")
        run_transforms_for_schema(
            repo_root,
            schema_name=args.schema_name,
            config_path=args.config,
            only_xslt=args.only_xslt,
        )
        print("Schema transforms complete!")
        return 0

    print("Running all transforms from sample_builds.yaml ...\n")
    run_all_transforms_from_config(repo_root, config_path=args.config)
    print("All transformations complete!")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
