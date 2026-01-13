"""Custom exception classes for XSD processing."""


class XSDProcessingError(Exception):
    """Base exception for XSD processing errors"""
    pass


class SchemaValidationError(XSDProcessingError):
    """Raised when schema validation fails"""
    pass


class SchemaFileNotFoundError(XSDProcessingError):
    """Raised when required schema files are not found"""
    pass

