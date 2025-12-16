![HLX Logo](../assets/hlx_logo.png)

# Core-Model Implementation Guide

**HLX0123 HLX Core-Model IG (XSD_V10.0)**

**Version 10.0**

**December 16, 2025**

**Table of Contents**

1. [Overview](#overview)
2. [Encoding](#encoding)
3. [Interoperability](#interoperability)
4. [Change Log](#change-log)
5. [Simple Types](#simple-types)
6. [Complex Types](#complex-types)
7. [Required Elements of Core-Model XSD](#required-elements-of-core-model-xsd)
8. [All Elements of Core-Model XSD](#all-elements-of-core-model-xsd)
9. [Practical Guidance](#practical-guidance)

## Disclaimer

This document is provided by HealthLX for informational purposes only. Information within this document is believed to be correct as of the noted date of publication. Although HealthLX makes every reasonable effort to present information in a timely and accurate manner, HealthLX does not warrant this information for accuracy, completeness or fitness for any purpose, express or implied. The information provided herein does not constitute the rendering of legal, financial or other professional advice or recommendations by HealthLX.

## Overview

This implementation guide provides field mappings and requirements for HealthLX Core-Model data submissions in XML format based on FHIR R4 standards. XML format enables structured data exchange with built-in validation against the provided XSD schema.

## Encoding

Payers need to send their files with utf-8 encoding as shown below:

```xml
<?xml version="1.0" encoding="utf-8"?>
```

## Interoperability

This implementation guide is based on FHIR R4 (Fast Healthcare Interoperability Resources Release 4) standards. For more information about FHIR R4, visit: https://www.hl7.org/fhir/R4/

## Change Log

| Version | Date |
|---------|------|
| 10.0 | December 16, 2025 |

## Simple Types

| Name | Base Type | Description | Pattern |
| --- | --- | --- | --- |
| string | xs:string | – | [ \r\n\t\S]+ |
| NPI | xs:string | – | [0-9]{10} |
| positiveInt | xs:positiveInteger | – | \+?[1-9][0-9]* |
| unsignedInt | xs:unsignedInt | – | 0|([1-9][0-9]*) |


## Required Elements of Core-Model XSD

No elements found.

## All Elements of Core-Model XSD

No elements found.

## Practical Guidance

### Submission Frequency

Core-Model files should be submitted according to the schedule agreed upon with HealthLX. Typical submission frequencies include daily, weekly, or monthly updates.

### Adds, Updates, and Deletes

- **Adds**: Include new member records with all required fields populated
- **Updates**: Submit complete member records with updated information
- **Deletes**: Follow the agreed-upon process for member terminations or removals

### Member Identification

Each member must be uniquely identified using the appropriate identifier fields. Ensure consistency in member identifiers across all submissions to maintain data integrity.

