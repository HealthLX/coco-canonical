"""
Apply XSLT transforms: canonical XML to FHIR (Saxon).

Batch mode walks ``config/sample_builds.yaml`` and applies each build's transforms to that
build's canonical sample (aligned with ``schema_file_name``). Single-shot mode takes
explicit ``--canonical-xml``, ``--xslt``, and optional ``--schema`` (XSD pre-check).
"""
from __future__ import annotations

import argparse
import fnmatch
import sys
from pathlib import Path

# Folder-driven runs skip these by default: "flat" transforms are preprocessing/flattening
# helpers (not canonical->FHIR resource transforms) and shouldn't be auto-run. Override or
# extend per build with an "exclude" list of glob patterns in sample_builds.yaml.
DEFAULT_TRANSFORM_EXCLUDES = ["*_flat.xsl"]

import yaml
from saxonche import PySaxonProcessor
from xml.dom import minidom

# Schemas/ subfolder a build reads from when its config entry omits "version".
# Mirrors tools.build_sample_file.DEFAULT_VERSION_DIR; kept local so this module stays
# runnable as a plain script (python tools/transform_schema.py) without the package on sys.path.
DEFAULT_VERSION_DIR = "v10.0"


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


def collect_transform_specs(build: dict, base_dir: str | Path | None = None) -> list[dict]:
    """Resolve a build's transforms into ordered ``{transform_file, resource_type}`` specs.

    Three optional, combinable config keys (deduped, first occurrence wins ordering):
      - ``transform_dir``: a folder relative to the repo root; every ``*.xsl`` in it
        (sorted by filename) is run. This is the folder-driven default.
      - ``transform_file``: a single XSLT path.
      - ``transform_files``: an explicit list of ``{transform_file, resource_type}`` (or bare
        path strings). Useful to add a transform outside the folder, or to pin ``resource_type``.

    ``resource_type`` defaults to the XSLT filename stem. ``transform_dir`` needs ``base_dir`` to
    glob; without it (or if the folder is absent) the directory contributes nothing.
    """
    # Explicit entries first, so a transform_files resource_type overrides the folder-derived stem.
    explicit: list[str] = []
    overrides: dict[str, str] = {}
    for item in build.get("transform_files") or []:
        if isinstance(item, dict):
            path, rt = item.get("transform_file"), item.get("resource_type")
        else:
            path, rt = item, None
        if path:
            norm = str(path).replace("\\", "/")
            explicit.append(norm)
            if rt:
                overrides[norm] = rt

    specs: list[dict] = []
    seen: set[str] = set()

    def add(path):
        if not path:
            return
        norm = str(path).replace("\\", "/")
        if not norm or norm.lower() == "null" or norm in seen:
            return
        seen.add(norm)
        specs.append({"transform_file": norm, "resource_type": overrides.get(norm) or Path(norm).stem})

    tdir = build.get("transform_dir")
    if tdir and str(tdir).lower() != "null" and base_dir is not None:
        base = Path(base_dir).resolve()
        folder = base / str(tdir)
        if folder.is_dir():
            excludes = DEFAULT_TRANSFORM_EXCLUDES + list(build.get("exclude") or [])
            for xsl in sorted(folder.glob("*.xsl"), key=lambda p: p.name.lower()):
                if any(fnmatch.fnmatch(xsl.name.lower(), pat.lower()) for pat in excludes):
                    continue
                add(xsl.relative_to(base).as_posix())

    add(build.get("transform_file"))
    for norm in explicit:
        add(norm)

    return specs


def transform_specs_from_build(build: dict, base_dir: str | Path | None = None) -> list[str]:
    """Collect XSLT paths from a build entry (transform_dir + transform_file + transform_files)."""
    return [s["transform_file"] for s in collect_transform_specs(build, base_dir)]


def _apply_one_spec(base_dir, canonical_path, xslt_rel, fhir_dir, build) -> bool:
    """Apply one XSLT, writing FHIR output. Returns False (without raising) on any failure so a
    folder-driven run keeps going past transforms that aren't adapted to the canonical yet."""
    xslt_path = Path(base_dir) / xslt_rel
    if not xslt_path.is_file():
        print(f"  XSLT not found: {xslt_rel}")
        return False
    dest = fhir_dir / fhir_output_name(xslt_rel, provider_variant=build.get("provider_directory_child"))
    print(f"  Applying {xslt_rel} -> {dest.name}")
    try:
        apply_xslt(str(base_dir), str(canonical_path), str(xslt_path), str(dest))
        return True
    except Exception as e:
        print(f"  SKIPPED {xslt_rel}: {type(e).__name__}: {str(e).splitlines()[0][:140]}")
        return False


def _print_transform_summary(failures: list[str]) -> None:
    if failures:
        print(f"Completed with {len(failures)} transform(s) skipped (not adapted to the canonical):")
        for f in failures:
            print(f"  - {f}")


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

    failures: list[str] = []
    for build in builds:
        specs = transform_specs_from_build(build, base_dir)
        if not specs:
            continue

        version = build.get("version") or DEFAULT_VERSION_DIR
        fhir_dir = base_dir / "fhir-samples" / version
        fhir_dir.mkdir(parents=True, exist_ok=True)

        out_name = build.get("output_file_name")
        schema_name = build.get("schema_file_name")
        canonical_path = base_dir / "canonical-samples" / version / out_name
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
            ok = _apply_one_spec(base_dir, canonical_path, xslt_rel, fhir_dir, build)
            if not ok:
                failures.append(xslt_rel)
        print()

    _print_transform_summary(failures)


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

    failures: list[str] = []
    for build in matching:
        version = build.get("version") or DEFAULT_VERSION_DIR
        canonical_dir = base_dir / "canonical-samples" / version
        fhir_dir = base_dir / "fhir-samples" / version
        fhir_dir.mkdir(parents=True, exist_ok=True)

        all_specs = transform_specs_from_build(build, base_dir)
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
            ok = _apply_one_spec(base_dir, canonical_path, xslt_rel, fhir_dir, build)
            if not ok:
                failures.append(xslt_rel)
        print()

    _print_transform_summary(failures)


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
            f"Default: fhir-samples/{DEFAULT_VERSION_DIR}/<xslt-stem>-fhir.xml "
            "(use --version to target another schema version, --provider-variant to disambiguate)"
        ),
    )
    parser.add_argument(
        "--version",
        type=str,
        default=DEFAULT_VERSION_DIR,
        metavar="VER",
        help=f"Schema version folder for the default output path (default: {DEFAULT_VERSION_DIR})",
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
            fhir_dir = repo_root / "fhir-samples" / args.version
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
