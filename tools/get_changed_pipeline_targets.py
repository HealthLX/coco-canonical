#!/usr/bin/env python3
"""
Determine which pipeline targets to run based on config and git diff.

Single source of truth: config/sample_builds.yaml.
- Schema paths are derived from builds (schemas/v10.0/{schema_file_name}).
- Targets with a transform are those with non-null transform_file and fhir_profile.
- core_schema_path in config: when that file changes, run all targets.

Outputs (for eval in shell or GITHUB_OUTPUT):
  TARGETS="roster eob ..."   (space-separated, run_pipeline.py --target names)
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


def get_path_to_target_and_core(cfg):
    """
    From builds, build path -> canonical_name (lowercase).
    Returns (path_to_target dict, core_schema_path str or None, model_targets list).
    """
    builds = cfg.get("builds", [])
    if not builds:
        return {}, None, []

    path_to_target = {}
    for b in builds:
        schema_file = b.get("schema_file_name")
        if not schema_file:
            continue
        path = f"schemas/v10.0/{schema_file}"
        path_to_target[path] = b.get("canonical_name", "").lower()

    core_path = cfg.get("core_schema_path")
    if isinstance(core_path, str) and core_path.strip():
        core_path = core_path.strip()
    else:
        core_path = None

    model_targets = sorted(set(path_to_target.values()))
    return path_to_target, core_path, model_targets


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
    """Set of canonical_name (lowercase) that configure a transform and a fhir_profile.

    Recognizes all transform shapes (transform_dir / transform_file / transform_files); the
    fhir_profile gate is what makes the pipeline run Saxon + FHIR validation in Docker.
    """
    builds = cfg.get("builds", [])
    out = set()
    for b in builds:
        fp = b.get("fhir_profile")
        if _build_has_transform(b) and fp and str(fp) != "null":
            out.add(b.get("canonical_name", "").lower())
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

    path_to_target, core_path, model_targets = get_path_to_target_and_core(cfg)
    targets_with_transform = get_targets_with_transform(cfg)
    changed = get_changed_files(args.base)

    targets_to_run: set[str] = set()
    for filepath in changed:
        if filepath in path_to_target:
            t = path_to_target[filepath]
            targets_to_run.add(t)
        if core_path and filepath == core_path:
            targets_to_run.update(model_targets)

    run_names = sorted(targets_to_run)
    needs_docker = any(t in targets_with_transform for t in targets_to_run)

    targets_str = " ".join(run_names)
    print(f'TARGETS="{targets_str}"')
    print(f"NEEDS_DOCKER={'true' if needs_docker else 'false'}")


if __name__ == "__main__":
    main()
