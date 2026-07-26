#!/usr/bin/env python3
"""
Determine which pipeline targets to run based on config and git diff.

Single source of truth: config/sample_builds.yaml.
- Schema paths are derived from builds (schemas/{version}/{schema_file_name}).
- Targets with a transform are those with non-null transform_file and fhir_profile.
- core_schema_paths in config: when one changes, run every target of that same version.

Outputs (for eval in shell or GITHUB_OUTPUT):
  TARGETS="roster@v10.0 eob@v11.0 ..."   (space-separated, run_pipeline.py --target values)
  NEEDS_DOCKER=true|false
"""

import argparse
import subprocess
import sys
from pathlib import Path

import yaml

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent
SAMPLE_BUILDS_PATH = PROJECT_ROOT / "config" / "sample_builds.yaml"


def load_sample_builds():
    """Load config/sample_builds.yaml."""
    if not SAMPLE_BUILDS_PATH.exists():
        return None
    with open(SAMPLE_BUILDS_PATH, "r", encoding="utf-8") as f:
        return yaml.safe_load(f) or {}


# Schemas/ subfolder a build reads from when its config entry omits "version".
# Mirrors tools.build_sample_file.DEFAULT_VERSION_DIR; kept local so this module stays a
# lightweight CI helper (yaml only) rather than pulling in the sample-builder dependencies.
DEFAULT_VERSION_DIR = "v10.0"


def build_version(b):
    """Schema version folder for a build entry."""
    return b.get("version") or DEFAULT_VERSION_DIR


def build_token(b):
    """Unique pipeline token for a build, e.g. 'roster@v11.0' (matches run_pipeline --target)."""
    return f"{b.get('canonical_name', '').lower()}@{build_version(b)}"


def get_path_to_target_and_core(cfg):
    """
    From builds, map schema path -> pipeline token, and core schema path -> version.

    Returns (path_to_target dict, core_paths dict of path -> version, targets_by_version dict).
    """
    builds = cfg.get("builds", [])
    if not builds:
        return {}, {}, {}

    path_to_target = {}
    targets_by_version = {}
    for b in builds:
        schema_file = b.get("schema_file_name")
        if not schema_file:
            continue
        version = build_version(b)
        path = f"schemas/{version}/{schema_file}"
        path_to_target[path] = build_token(b)
        targets_by_version.setdefault(version, set()).add(build_token(b))

    # core_schema_paths (list) is the current form; core_schema_path (scalar) still accepted.
    raw_core = cfg.get("core_schema_paths") or cfg.get("core_schema_path") or []
    if isinstance(raw_core, str):
        raw_core = [raw_core]

    core_paths = {}
    for p in raw_core:
        if not isinstance(p, str) or not p.strip():
            continue
        p = p.strip().replace("\\", "/")
        # schemas/<version>/Core-Model.xsd -> <version>
        parts = p.split("/")
        core_paths[p] = parts[1] if len(parts) > 2 else DEFAULT_VERSION_DIR

    return path_to_target, core_paths, targets_by_version


def _build_has_transform(b):
    """True if a build configures any transform (transform_dir, transform_file, or transform_files)."""
    tf = b.get("transform_file")
    if tf and str(tf) != "null":
        return True
    if b.get("transform_files"):
        return True
    td = b.get("transform_dir")
    if td and str(td) != "null":
        return True
    return False


def get_targets_with_transform(cfg):
    """Set of pipeline tokens that configure a transform and a fhir_profile.

    Recognizes all transform shapes (transform_dir / transform_file / transform_files); the
    fhir_profile gate is what makes the pipeline run Saxon + FHIR validation in Docker.
    """
    builds = cfg.get("builds", [])
    out = set()
    for b in builds:
        fp = b.get("fhir_profile")
        if _build_has_transform(b) and fp and str(fp) != "null":
            out.add(build_token(b))
    return out


def get_changed_files(base_ref: str) -> list[str]:
    """Return list of file paths changed between base_ref and HEAD."""
    try:
        out = subprocess.run(
            ["git", "diff", "--name-only", base_ref, "HEAD"],
            capture_output=True,
            text=True,
            timeout=10,
            cwd=PROJECT_ROOT,
        )
        if out.returncode != 0:
            return []
        return [p.strip().replace("\\", "/") for p in out.stdout.strip().splitlines() if p.strip()]
    except (subprocess.TimeoutExpired, FileNotFoundError):
        return []


def main():
    parser = argparse.ArgumentParser(
        description="Get changed pipeline targets from config/sample_builds.yaml and git diff."
    )
    parser.add_argument("--base", required=True, help="Base ref for git diff (e.g. PR base SHA)")
    args = parser.parse_args()

    cfg = load_sample_builds()
    if not cfg or not cfg.get("builds"):
        print('TARGETS=""')
        print("NEEDS_DOCKER=false")
        sys.exit(0)

    path_to_target, core_paths, targets_by_version = get_path_to_target_and_core(cfg)
    targets_with_transform = get_targets_with_transform(cfg)
    changed = get_changed_files(args.base)

    targets_to_run: set[str] = set()
    for filepath in changed:
        if filepath in path_to_target:
            targets_to_run.add(path_to_target[filepath])
        # A shared Core-Model change reruns every target of that same schema version.
        if filepath in core_paths:
            targets_to_run.update(targets_by_version.get(core_paths[filepath], set()))

    run_names = sorted(targets_to_run)
    needs_docker = any(t in targets_with_transform for t in targets_to_run)

    targets_str = " ".join(run_names)
    print(f'TARGETS="{targets_str}"')
    print(f"NEEDS_DOCKER={'true' if needs_docker else 'false'}")


if __name__ == "__main__":
    main()
