"""
Backward-compatible import path for :mod:`tools.transform_schema`.

Prefer ``from tools.transform_schema import apply_xslt`` (or ``python -m tools.transform_schema``).
"""
from tools.transform_schema import (  # noqa: F401
    apply_xslt,
    apply_xslt_with_params,
    fhir_output_name,
    main,
    run_all_transforms_from_config,
    transform_specs_from_build,
)

__all__ = [
    "apply_xslt",
    "apply_xslt_with_params",
    "fhir_output_name",
    "main",
    "run_all_transforms_from_config",
    "transform_specs_from_build",
]

if __name__ == "__main__":
    raise SystemExit(main())
