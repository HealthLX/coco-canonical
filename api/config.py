"""API configuration: project root, config path, and loaded build config."""
import os
from pathlib import Path
from typing import Any

import yaml

# Project root: directory containing api/, tools/, config/, schemas/, etc.
API_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = API_DIR.parent

# Config path: override via env COCO_CONFIG_PATH if needed
_CONFIG_PATH_ENV = "COCO_CONFIG_PATH"
DEFAULT_CONFIG_PATH = PROJECT_ROOT / "config" / "sample_builds.yaml"


def get_canonical_samples_dir() -> Path:
    """Return the directory where canonical sample XML files are written/read.
    Override with env var COCO_CANONICAL_SAMPLES_DIR to redirect output (e.g. into coco-flow/data/).
    """
    env = os.environ.get("COCO_CANONICAL_SAMPLES_DIR")
    p = Path(env) if env else PROJECT_ROOT / "canonical-samples" / "v10.0"
    p.mkdir(parents=True, exist_ok=True)
    return p


def get_fhir_samples_dir() -> Path:
    """Return the directory where FHIR sample XML files are written/read.
    Override with env var COCO_FHIR_SAMPLES_DIR to redirect output (e.g. into coco-flow/data/).
    """
    env = os.environ.get("COCO_FHIR_SAMPLES_DIR")
    p = Path(env) if env else PROJECT_ROOT / "fhir-samples" / "v10.0"
    p.mkdir(parents=True, exist_ok=True)
    return p


def get_config_path() -> Path:
    raw = os.environ.get(_CONFIG_PATH_ENV)
    if raw:
        return Path(raw)
    return DEFAULT_CONFIG_PATH


def load_config() -> dict[str, Any]:
    path = get_config_path()
    if not path.exists():
        raise FileNotFoundError(f"Config file not found: {path}")
    with open(path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f) or {}


def get_builds() -> list[dict[str, Any]]:
    cfg = load_config()
    return cfg.get("builds", [])


def get_canonicals() -> list[str]:
    builds = get_builds()
    seen: set[str] = set()
    out: list[str] = []
    for b in builds:
        name = b.get("canonical_name")
        if name and name not in seen:
            seen.add(name)
            out.append(name)
    return out
