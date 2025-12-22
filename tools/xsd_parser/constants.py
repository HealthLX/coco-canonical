"""Shared constants for XSD parsing."""
import logging

# Configure logging
logging.basicConfig(level=logging.WARNING, format='%(levelname)s: %(message)s')
logger = logging.getLogger(__name__)

# XML Schema namespace
ns = {"xs": "http://www.w3.org/2001/XMLSchema"}

