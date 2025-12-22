"""Utility functions for XSD parsing."""
from .constants import ns, logger


def get_documentation(elem):
    """Extract documentation from element annotation."""
    try:
        annotation = elem.find("xs:annotation/xs:documentation", ns)
        if annotation is not None and annotation.text:
            return ' '.join(annotation.text.strip().split())
    except Exception as e:
        logger.debug(f"Error extracting documentation: {e}")
    return "–"

