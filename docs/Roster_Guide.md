![HLX Logo](assets/hlx_logo.png)

# Roster Implementation Guide

**HLX0123 HLX Roster IG (XSD_V2.0)**

**Version 2.0**

**December 8, 2025**

**Table of Contents**

1. [Overview](#overview)
2. [Encoding](#encoding)
3. [Interoperability](#interoperability)
4. [Change Log](#change-log)
5. [Simple Types](#simple-types)
6. [Complex Types](#complex-types)
7. [Required Elements of Roster XSD](#required-elements-of-roster-xsd)
8. [All Elements of Roster XSD](#all-elements-of-roster-xsd)
9. [Practical Guidance](#practical-guidance)

## Disclaimer

This document is provided by HealthLX for informational purposes only. Information within this document is believed to be correct as of the noted date of publication. Although HealthLX makes every reasonable effort to present information in a timely and accurate manner, HealthLX does not warrant this information for accuracy, completeness or fitness for any purpose, express or implied. The information provided herein does not constitute the rendering of legal, financial or other professional advice or recommendations by HealthLX.

## Overview

This implementation guide provides field mappings and requirements for HealthLX Roster data submissions in XML format based on FHIR R4 standards. XML format enables structured data exchange with built-in validation against the provided XSD schema.

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
| 2.0 | December 8, 2025 |

## Simple Types

| Name | Base Type | Description | Pattern |
| --- | --- | --- | --- |
| string | xs:string | – |  |
| positiveInt | xs:positiveInteger | – | \+?[1-9][0-9]* |
| unsignedInt | xs:unsignedInt | – | 0|([1-9][0-9]*) |
| integer | xs:integer | – | [0]|[-+]?[1-9][0-9]* |
| date | xs:date | – | ([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])) |
| dateTime | xs:string | – | ([12]\d{3})-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])(T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\.\d{1,6})?((Z|(\+|-)((0[0-9]|1[0-3]):(00|15|30|45)|14:00))?))? |


## Complex Types

### period

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| start | xs:dateTime | 0 | 1 | – |
| end | xs:dateTime | 0 | 1 | – |


### period_date

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| start | xs:date | 0 | 1 | – |
| end | xs:date | 0 | 1 | – |


### identifier

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | xs:string | 1 | 1 | – |
| type | xs:string | 1 | 1 | – |


### organization

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| tax | identifier | 0 | unbounded | Tax Id Number |
| naic_code | identifier | 0 | unbounded | – |
| payer_id | identifier | 0 | unbounded | – |
| is_active | xs:boolean | 1 | 1 | – |
| name | xs:string | 1 | 1 | – |
| alias | xs:string | 0 | unbounded | – |
| telecoms | – | 0 | 1 | – |
| telecom | telecom | 0 | unbounded | – |
| addresses | – | 0 | 1 | – |
| address | address | 0 | unbounded | – |


### telecom

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| system | – | 1 | 1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html |
| value | string | 1 | 1 | The actual value of the contact point |
| use | – | 0 | 1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html |
| rank | positiveInt | 0 | 1 | Specify preferred order of use (1 = highest) |
| period | period | 0 | 1 | Time period when the contact point was/is in use |


### address

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| use | – | 0 | 1 | The use of this address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-use.html |
| type | – | 0 | 1 | The type of address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-type.html |
| text | string | 0 | 1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) |
| line | string | 1 | unbounded | – |
| city | string | 0 | 1 | Name of city, town etc. |
| district | string | 0 | 1 | Use this element to list the District name (aka county) |
| state | string | 0 | 1 | Sub-unit of country (abbreviations ok) |
| postal_code | string | 0 | 1 | The postal code or post code of the address. The postal code supports an unlimited amount of numbers and letters. |
| country | – | 0 | 1 | Country (e.g. can be ISO 3166 2 or 3 letter code) |
| period | period | 0 | 1 | – |


### codeableConcept

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| coding | – | 1 | 1 | – |
| code | xs:string | 1 | 1 | – |
| system | xs:anyURI | 1 | 1 | – |
| display | xs:string | 1 | 1 | – |
| text | xs:string | 1 | 1 | – |


## Required Elements of Roster XSD

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| roster |  | 1..1 | – | – | – |
| schema_version | roster | 1..1 | This element defines what version of the roster schema you will be validating against (e.g. 1.0) | – | – |
| sender_id | roster | 1..1 | This element is used to the unique identifier assigned to your organization | – | string |
| date_time_reported | roster | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | – |
| member | roster | 1..unbounded | – | – | – |
| text | us_core_race | 1..1 | Use this element for adding a text description | – | string |
| text | member | 1..1 | Use this element for adding a text description | – | string |
| text | us_core_ethnicity | 1..1 | Use this element for adding a text description | – | string |
| text | member | 1..1 | Use this element for adding a text description | – | string |
| is_subscriber | member | 1..1 | This element is used to identify if this person is the subscriber (True / False). (e.g. The main policy holder of the plan) | – | xs:boolean |
| relationship | member | 1..1 | Relationship to the Subscriber. The full list can be found here: http://hl7.org/fhir/R4/valueset-subscriber-relationship.html | – | – |
| birth_date | member | 1..1 | Birth date (1900-01-01) | – | date |
| gender | member | 1..1 | Use this element for Sex/Administrative Gender (male, female, other or unknown) | – | – |
| tribal_affiliation | tribal_affiliations | 1..unbounded | – | – | – |
| codeable_concept | tribal_affiliation | 1..1 | – | – | codeableConcept |
| is_enrolled | tribal_affiliation | 1..1 | – | – | xs:boolean |
| codeable_concept | tribal_affiliations | 1..1 | – | – | codeableConcept |
| is_enrolled | tribal_affiliations | 1..1 | – | – | xs:boolean |
| tribal_affiliation | member | 1..unbounded | – | – | – |
| codeable_concept | tribal_affiliation | 1..1 | – | – | codeableConcept |
| is_enrolled | tribal_affiliation | 1..1 | – | – | xs:boolean |
| codeable_concept | member | 1..1 | – | – | codeableConcept |
| is_enrolled | member | 1..1 | – | – | xs:boolean |
| sexual_orientation | sexual_orientations | 1..unbounded | – | – | – |
| codeable_concept | sexual_orientation | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | sexual_orientation | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| codeable_concept | sexual_orientations | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | sexual_orientations | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| sexual_orientation | member | 1..unbounded | – | – | – |
| codeable_concept | sexual_orientation | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | sexual_orientation | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| codeable_concept | member | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | member | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| gender_identity | gender_identities | 1..unbounded | – | – | – |
| codeable_concept | gender_identity | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | gender_identity | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| codeable_concept | gender_identities | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | gender_identities | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| gender_identity | member | 1..unbounded | – | – | – |
| codeable_concept | gender_identity | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | gender_identity | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| codeable_concept | member | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | member | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| relatedPerson | relatedPersons | 1..unbounded | – | – | – |
| active | relatedPerson | 1..1 | – | – | xs:boolean |
| names | relatedPerson | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| use | names | 1..1 | – | – | xs:string |
| text | names | 1..1 | – | – | xs:string |
| family | names | 1..1 | – | – | xs:string |
| given | names | 1..unbounded | – | – | xs:string |
| name | relatedPerson | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| use | relatedPerson | 1..1 | – | – | xs:string |
| text | relatedPerson | 1..1 | – | – | xs:string |
| family | relatedPerson | 1..1 | – | – | xs:string |
| given | relatedPerson | 1..unbounded | – | – | xs:string |
| telecoms | relatedPerson | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| system | telecoms | 1..1 | – | – | xs:string |
| value | telecoms | 1..1 | – | – | xs:string |
| use | telecoms | 1..1 | – | – | xs:string |
| telecom | relatedPerson | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| system | relatedPerson | 1..1 | – | – | xs:string |
| value | relatedPerson | 1..1 | – | – | xs:string |
| use | relatedPerson | 1..1 | – | – | xs:string |
| gender | relatedPerson | 1..1 | – | – | xs:string |
| birth_date | relatedPerson | 1..1 | – | – | xs:date |
| addresses | relatedPerson | 1..1 | – | – | – |
| address | addresses | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| use | addresses | 1..1 | – | – | xs:string |
| type | addresses | 1..1 | – | – | xs:string |
| text | addresses | 1..1 | – | – | xs:string |
| line | addresses | 1..unbounded | – | – | xs:string |
| city | addresses | 1..1 | – | – | xs:string |
| state | addresses | 1..1 | – | – | xs:string |
| postal_code | addresses | 1..1 | – | – | xs:string |
| country | addresses | 1..1 | – | – | xs:string |
| address | relatedPerson | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| use | relatedPerson | 1..1 | – | – | xs:string |
| type | relatedPerson | 1..1 | – | – | xs:string |
| text | relatedPerson | 1..1 | – | – | xs:string |
| line | relatedPerson | 1..unbounded | – | – | xs:string |
| city | relatedPerson | 1..1 | – | – | xs:string |
| state | relatedPerson | 1..1 | – | – | xs:string |
| postal_code | relatedPerson | 1..1 | – | – | xs:string |
| country | relatedPerson | 1..1 | – | – | xs:string |
| communication_language | relatedPerson | 1..1 | – | – | xs:string |
| relationship | relatedPerson | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| codeable_concept | relatedPerson | 1..1 | – | – | codeableConcept |
| active | relatedPersons | 1..1 | – | – | xs:boolean |
| names | relatedPersons | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| use | names | 1..1 | – | – | xs:string |
| text | names | 1..1 | – | – | xs:string |
| family | names | 1..1 | – | – | xs:string |
| given | names | 1..unbounded | – | – | xs:string |
| name | relatedPersons | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| use | relatedPersons | 1..1 | – | – | xs:string |
| text | relatedPersons | 1..1 | – | – | xs:string |
| family | relatedPersons | 1..1 | – | – | xs:string |
| given | relatedPersons | 1..unbounded | – | – | xs:string |
| telecoms | relatedPersons | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| system | telecoms | 1..1 | – | – | xs:string |
| value | telecoms | 1..1 | – | – | xs:string |
| use | telecoms | 1..1 | – | – | xs:string |
| telecom | relatedPersons | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| system | relatedPersons | 1..1 | – | – | xs:string |
| value | relatedPersons | 1..1 | – | – | xs:string |
| use | relatedPersons | 1..1 | – | – | xs:string |
| gender | relatedPersons | 1..1 | – | – | xs:string |
| birth_date | relatedPersons | 1..1 | – | – | xs:date |
| addresses | relatedPersons | 1..1 | – | – | – |
| address | addresses | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| use | addresses | 1..1 | – | – | xs:string |
| type | addresses | 1..1 | – | – | xs:string |
| text | addresses | 1..1 | – | – | xs:string |
| line | addresses | 1..unbounded | – | – | xs:string |
| city | addresses | 1..1 | – | – | xs:string |
| state | addresses | 1..1 | – | – | xs:string |
| postal_code | addresses | 1..1 | – | – | xs:string |
| country | addresses | 1..1 | – | – | xs:string |
| address | relatedPersons | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| use | relatedPersons | 1..1 | – | – | xs:string |
| type | relatedPersons | 1..1 | – | – | xs:string |
| text | relatedPersons | 1..1 | – | – | xs:string |
| line | relatedPersons | 1..unbounded | – | – | xs:string |
| city | relatedPersons | 1..1 | – | – | xs:string |
| state | relatedPersons | 1..1 | – | – | xs:string |
| postal_code | relatedPersons | 1..1 | – | – | xs:string |
| country | relatedPersons | 1..1 | – | – | xs:string |
| communication_language | relatedPersons | 1..1 | – | – | xs:string |
| relationship | relatedPersons | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| codeable_concept | relatedPersons | 1..1 | – | – | codeableConcept |
| relatedPerson | member | 1..unbounded | – | – | – |
| active | relatedPerson | 1..1 | – | – | xs:boolean |
| names | relatedPerson | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| use | names | 1..1 | – | – | xs:string |
| text | names | 1..1 | – | – | xs:string |
| family | names | 1..1 | – | – | xs:string |
| given | names | 1..unbounded | – | – | xs:string |
| name | relatedPerson | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| use | relatedPerson | 1..1 | – | – | xs:string |
| text | relatedPerson | 1..1 | – | – | xs:string |
| family | relatedPerson | 1..1 | – | – | xs:string |
| given | relatedPerson | 1..unbounded | – | – | xs:string |
| telecoms | relatedPerson | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| system | telecoms | 1..1 | – | – | xs:string |
| value | telecoms | 1..1 | – | – | xs:string |
| use | telecoms | 1..1 | – | – | xs:string |
| telecom | relatedPerson | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| system | relatedPerson | 1..1 | – | – | xs:string |
| value | relatedPerson | 1..1 | – | – | xs:string |
| use | relatedPerson | 1..1 | – | – | xs:string |
| gender | relatedPerson | 1..1 | – | – | xs:string |
| birth_date | relatedPerson | 1..1 | – | – | xs:date |
| addresses | relatedPerson | 1..1 | – | – | – |
| address | addresses | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| use | addresses | 1..1 | – | – | xs:string |
| type | addresses | 1..1 | – | – | xs:string |
| text | addresses | 1..1 | – | – | xs:string |
| line | addresses | 1..unbounded | – | – | xs:string |
| city | addresses | 1..1 | – | – | xs:string |
| state | addresses | 1..1 | – | – | xs:string |
| postal_code | addresses | 1..1 | – | – | xs:string |
| country | addresses | 1..1 | – | – | xs:string |
| address | relatedPerson | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| use | relatedPerson | 1..1 | – | – | xs:string |
| type | relatedPerson | 1..1 | – | – | xs:string |
| text | relatedPerson | 1..1 | – | – | xs:string |
| line | relatedPerson | 1..unbounded | – | – | xs:string |
| city | relatedPerson | 1..1 | – | – | xs:string |
| state | relatedPerson | 1..1 | – | – | xs:string |
| postal_code | relatedPerson | 1..1 | – | – | xs:string |
| country | relatedPerson | 1..1 | – | – | xs:string |
| communication_language | relatedPerson | 1..1 | – | – | xs:string |
| relationship | relatedPerson | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| codeable_concept | relatedPerson | 1..1 | – | – | codeableConcept |
| active | member | 1..1 | – | – | xs:boolean |
| names | member | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| use | names | 1..1 | – | – | xs:string |
| text | names | 1..1 | – | – | xs:string |
| family | names | 1..1 | – | – | xs:string |
| given | names | 1..unbounded | – | – | xs:string |
| name | member | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| use | member | 1..1 | – | – | xs:string |
| text | member | 1..1 | – | – | xs:string |
| family | member | 1..1 | – | – | xs:string |
| given | member | 1..unbounded | – | – | xs:string |
| telecoms | member | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| system | telecoms | 1..1 | – | – | xs:string |
| value | telecoms | 1..1 | – | – | xs:string |
| use | telecoms | 1..1 | – | – | xs:string |
| telecom | member | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| system | member | 1..1 | – | – | xs:string |
| value | member | 1..1 | – | – | xs:string |
| use | member | 1..1 | – | – | xs:string |
| gender | member | 1..1 | – | – | xs:string |
| birth_date | member | 1..1 | – | – | xs:date |
| addresses | member | 1..1 | – | – | – |
| address | addresses | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| use | addresses | 1..1 | – | – | xs:string |
| type | addresses | 1..1 | – | – | xs:string |
| text | addresses | 1..1 | – | – | xs:string |
| line | addresses | 1..unbounded | – | – | xs:string |
| city | addresses | 1..1 | – | – | xs:string |
| state | addresses | 1..1 | – | – | xs:string |
| postal_code | addresses | 1..1 | – | – | xs:string |
| country | addresses | 1..1 | – | – | xs:string |
| address | member | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| use | member | 1..1 | – | – | xs:string |
| type | member | 1..1 | – | – | xs:string |
| text | member | 1..1 | – | – | xs:string |
| line | member | 1..unbounded | – | – | xs:string |
| city | member | 1..1 | – | – | xs:string |
| state | member | 1..1 | – | – | xs:string |
| postal_code | member | 1..1 | – | – | xs:string |
| country | member | 1..1 | – | – | xs:string |
| communication_language | member | 1..1 | – | – | xs:string |
| relationship | member | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| codeable_concept | member | 1..1 | – | – | codeableConcept |
| occupation_item | occupations | 1..unbounded | – | – | – |
| status | occupation_item | 1..1 | – | – | – |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| industry | occupation_item | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| status | occupations | 1..1 | – | – | – |
| codeable_concept | occupations | 1..1 | – | – | codeableConcept |
| industry | occupations | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| codeable_concept | occupations | 1..1 | – | – | codeableConcept |
| occupation_item | member | 1..unbounded | – | – | – |
| status | occupation_item | 1..1 | – | – | – |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| industry | occupation_item | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| status | member | 1..1 | – | – | – |
| codeable_concept | member | 1..1 | – | – | codeableConcept |
| industry | member | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| codeable_concept | member | 1..1 | – | – | codeableConcept |
| unique_person_ids | member | 1..1 | – | – | – |
| unique_person_id | unique_person_ids | 1..1 | This is the person's unique member number in the Payer system across plans. This number is not reused for anyone else. | – | string |
| unique_person_id_assigner | unique_person_ids | 1..1 | Organization that issued id | – | – |
| unique_person_id | member | 1..1 | This is the person's unique member number in the Payer system across plans. This number is not reused for anyone else. | – | string |
| unique_person_id_assigner | member | 1..1 | Organization that issued id | – | – |
| member_id | member | 1..1 | Use this element to list the Member Number. | – | string |
| subscriber_id | member | 1..1 | Use this element to list the Subscriber Number. An identifier for a subscriber of an insurance policy which is unique for, and usually assigned by, the insurance carrier. Use Case: A person is the subscriber of an insurance policy. The person’s family may be plan members, but are not the subscriber. | – | string |
| names | member | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| text | name | 1..1 | Use this element to enter the entire name of the member | – | string |
| family | name | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | name | 1..unbounded | Given names (not always 'first'). Includes middle names | – | string |
| text | names | 1..1 | Use this element to enter the entire name of the member | – | string |
| family | names | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | names | 1..unbounded | Given names (not always 'first'). Includes middle names | – | string |
| name | member | 1..unbounded | – | – | – |
| text | name | 1..1 | Use this element to enter the entire name of the member | – | string |
| family | name | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | name | 1..unbounded | Given names (not always 'first'). Includes middle names | – | string |
| text | member | 1..1 | Use this element to enter the entire name of the member | – | string |
| family | member | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | member | 1..unbounded | Given names (not always 'first'). Includes middle names | – | string |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. Please provide at least one form of contact (e.g. phone, email, etc.) | – | – |
| system | telecom | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | telecom | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| system | telecoms | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | telecoms | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| telecom | member | 1..unbounded | Contact points of telecommunications. Please provide at least one form of contact (e.g. phone, email, etc.) | – | – |
| system | telecom | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | telecom | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| system | member | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | member | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| address | addresses | 1..unbounded | Use this element to list all the addresses the member is associated with. It is recommended that at least one address be supplied for identification purposes. | – | – |
| text | address | 1..1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) | – | string |
| line | address | 1..unbounded | – | – | string |
| city | address | 1..1 | – | – | string |
| state | address | 1..1 | – | – | string |
| postal_code | address | 1..1 | – | – | string |
| country | address | 1..1 | Country (e.g. can be ISO 3166 2 or 3 letter code) | – | string |
| text | addresses | 1..1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) | – | string |
| line | addresses | 1..unbounded | – | – | string |
| city | addresses | 1..1 | – | – | string |
| state | addresses | 1..1 | – | – | string |
| postal_code | addresses | 1..1 | – | – | string |
| country | addresses | 1..1 | Country (e.g. can be ISO 3166 2 or 3 letter code) | – | string |
| address | member | 1..unbounded | Use this element to list all the addresses the member is associated with. It is recommended that at least one address be supplied for identification purposes. | – | – |
| text | address | 1..1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) | – | string |
| line | address | 1..unbounded | – | – | string |
| city | address | 1..1 | – | – | string |
| state | address | 1..1 | – | – | string |
| postal_code | address | 1..1 | – | – | string |
| country | address | 1..1 | Country (e.g. can be ISO 3166 2 or 3 letter code) | – | string |
| text | member | 1..1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) | – | string |
| line | member | 1..unbounded | – | – | string |
| city | member | 1..1 | – | – | string |
| state | member | 1..1 | – | – | string |
| postal_code | member | 1..1 | – | – | string |
| country | member | 1..1 | Country (e.g. can be ISO 3166 2 or 3 letter code) | – | string |
| health_coverage | member | 1..1 | – | – | – |
| plan_id | health_coverage | 1..1 | The Identifier of the plan associated with the Plan Name | – | string |
| plan_name | health_coverage | 1..1 | – | – | string |
| coverage_status | health_coverage | 1..1 | Indicates the current status of coverage for the member. Must be one of: active, cancelled, draft, entered-in-error | – | string |
| codeable_concept | coverage_type | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| codeable_concept | health_coverage | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| coverage_period | health_coverage | 1..1 | Use this element to provide dates of coverage for this member. If the coverage is still active, do not provide an End date. Format is YYYY-MM-DD. | – | period |
| plan_id | member | 1..1 | The Identifier of the plan associated with the Plan Name | – | string |
| plan_name | member | 1..1 | – | – | string |
| coverage_status | member | 1..1 | Indicates the current status of coverage for the member. Must be one of: active, cancelled, draft, entered-in-error | – | string |
| codeable_concept | coverage_type | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| codeable_concept | member | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| coverage_period | member | 1..1 | Use this element to provide dates of coverage for this member. If the coverage is still active, do not provide an End date. Format is YYYY-MM-DD. | – | period |
| communication | communications | 1..unbounded | Use this element to provide the languages the member communicates in | – | – |
| language_code | communication | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| language_code | communications | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| communication | member | 1..unbounded | Use this element to provide the languages the member communicates in | – | – |
| language_code | communication | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| language_code | member | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| unique_record_identifier | member | 1..1 | – | – | string |
| delegate | delegates | 1..unbounded | – | – | – |
| family | delegate | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | delegate | 1..1 | Given names (not always 'first'). Includes middle names | – | string |
| telecoms | delegate | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | telecoms | 1..1 | – | – | – |
| value | telecoms | 1..1 | – | – | string |
| telecom | delegate | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | delegate | 1..1 | – | – | – |
| value | delegate | 1..1 | – | – | string |
| email_address | delegate | 1..1 | – | – | – |
| is_member | delegate | 1..1 | Fixed to false | – | – |
| family | delegates | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | delegates | 1..1 | Given names (not always 'first'). Includes middle names | – | string |
| telecoms | delegates | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | telecoms | 1..1 | – | – | – |
| value | telecoms | 1..1 | – | – | string |
| telecom | delegates | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | delegates | 1..1 | – | – | – |
| value | delegates | 1..1 | – | – | string |
| email_address | delegates | 1..1 | – | – | – |
| is_member | delegates | 1..1 | Fixed to false | – | – |
| delegate | member | 1..unbounded | – | – | – |
| family | delegate | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | delegate | 1..1 | Given names (not always 'first'). Includes middle names | – | string |
| telecoms | delegate | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | telecoms | 1..1 | – | – | – |
| value | telecoms | 1..1 | – | – | string |
| telecom | delegate | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | delegate | 1..1 | – | – | – |
| value | delegate | 1..1 | – | – | string |
| email_address | delegate | 1..1 | – | – | – |
| is_member | delegate | 1..1 | Fixed to false | – | – |
| family | member | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | member | 1..1 | Given names (not always 'first'). Includes middle names | – | string |
| telecoms | member | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | telecoms | 1..1 | – | – | – |
| value | telecoms | 1..1 | – | – | string |
| telecom | member | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | member | 1..1 | – | – | – |
| value | member | 1..1 | – | – | string |
| email_address | member | 1..1 | – | – | – |
| is_member | member | 1..1 | Fixed to false | – | – |
| text | us_core_race | 1..1 | Use this element for adding a text description | – | string |
| text | roster | 1..1 | Use this element for adding a text description | – | string |
| text | us_core_ethnicity | 1..1 | Use this element for adding a text description | – | string |
| text | roster | 1..1 | Use this element for adding a text description | – | string |
| is_subscriber | roster | 1..1 | This element is used to identify if this person is the subscriber (True / False). (e.g. The main policy holder of the plan) | – | xs:boolean |
| relationship | roster | 1..1 | Relationship to the Subscriber. The full list can be found here: http://hl7.org/fhir/R4/valueset-subscriber-relationship.html | – | – |
| birth_date | roster | 1..1 | Birth date (1900-01-01) | – | date |
| gender | roster | 1..1 | Use this element for Sex/Administrative Gender (male, female, other or unknown) | – | – |
| tribal_affiliation | tribal_affiliations | 1..unbounded | – | – | – |
| codeable_concept | tribal_affiliation | 1..1 | – | – | codeableConcept |
| is_enrolled | tribal_affiliation | 1..1 | – | – | xs:boolean |
| codeable_concept | tribal_affiliations | 1..1 | – | – | codeableConcept |
| is_enrolled | tribal_affiliations | 1..1 | – | – | xs:boolean |
| tribal_affiliation | roster | 1..unbounded | – | – | – |
| codeable_concept | tribal_affiliation | 1..1 | – | – | codeableConcept |
| is_enrolled | tribal_affiliation | 1..1 | – | – | xs:boolean |
| codeable_concept | roster | 1..1 | – | – | codeableConcept |
| is_enrolled | roster | 1..1 | – | – | xs:boolean |
| sexual_orientation | sexual_orientations | 1..unbounded | – | – | – |
| codeable_concept | sexual_orientation | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | sexual_orientation | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| codeable_concept | sexual_orientations | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | sexual_orientations | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| sexual_orientation | roster | 1..unbounded | – | – | – |
| codeable_concept | sexual_orientation | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | sexual_orientation | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| codeable_concept | roster | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | roster | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| gender_identity | gender_identities | 1..unbounded | – | – | – |
| codeable_concept | gender_identity | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | gender_identity | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| codeable_concept | gender_identities | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | gender_identities | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| gender_identity | roster | 1..unbounded | – | – | – |
| codeable_concept | gender_identity | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | gender_identity | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| codeable_concept | roster | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | roster | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| relatedPerson | relatedPersons | 1..unbounded | – | – | – |
| active | relatedPerson | 1..1 | – | – | xs:boolean |
| names | relatedPerson | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| use | names | 1..1 | – | – | xs:string |
| text | names | 1..1 | – | – | xs:string |
| family | names | 1..1 | – | – | xs:string |
| given | names | 1..unbounded | – | – | xs:string |
| name | relatedPerson | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| use | relatedPerson | 1..1 | – | – | xs:string |
| text | relatedPerson | 1..1 | – | – | xs:string |
| family | relatedPerson | 1..1 | – | – | xs:string |
| given | relatedPerson | 1..unbounded | – | – | xs:string |
| telecoms | relatedPerson | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| system | telecoms | 1..1 | – | – | xs:string |
| value | telecoms | 1..1 | – | – | xs:string |
| use | telecoms | 1..1 | – | – | xs:string |
| telecom | relatedPerson | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| system | relatedPerson | 1..1 | – | – | xs:string |
| value | relatedPerson | 1..1 | – | – | xs:string |
| use | relatedPerson | 1..1 | – | – | xs:string |
| gender | relatedPerson | 1..1 | – | – | xs:string |
| birth_date | relatedPerson | 1..1 | – | – | xs:date |
| addresses | relatedPerson | 1..1 | – | – | – |
| address | addresses | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| use | addresses | 1..1 | – | – | xs:string |
| type | addresses | 1..1 | – | – | xs:string |
| text | addresses | 1..1 | – | – | xs:string |
| line | addresses | 1..unbounded | – | – | xs:string |
| city | addresses | 1..1 | – | – | xs:string |
| state | addresses | 1..1 | – | – | xs:string |
| postal_code | addresses | 1..1 | – | – | xs:string |
| country | addresses | 1..1 | – | – | xs:string |
| address | relatedPerson | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| use | relatedPerson | 1..1 | – | – | xs:string |
| type | relatedPerson | 1..1 | – | – | xs:string |
| text | relatedPerson | 1..1 | – | – | xs:string |
| line | relatedPerson | 1..unbounded | – | – | xs:string |
| city | relatedPerson | 1..1 | – | – | xs:string |
| state | relatedPerson | 1..1 | – | – | xs:string |
| postal_code | relatedPerson | 1..1 | – | – | xs:string |
| country | relatedPerson | 1..1 | – | – | xs:string |
| communication_language | relatedPerson | 1..1 | – | – | xs:string |
| relationship | relatedPerson | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| codeable_concept | relatedPerson | 1..1 | – | – | codeableConcept |
| active | relatedPersons | 1..1 | – | – | xs:boolean |
| names | relatedPersons | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| use | names | 1..1 | – | – | xs:string |
| text | names | 1..1 | – | – | xs:string |
| family | names | 1..1 | – | – | xs:string |
| given | names | 1..unbounded | – | – | xs:string |
| name | relatedPersons | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| use | relatedPersons | 1..1 | – | – | xs:string |
| text | relatedPersons | 1..1 | – | – | xs:string |
| family | relatedPersons | 1..1 | – | – | xs:string |
| given | relatedPersons | 1..unbounded | – | – | xs:string |
| telecoms | relatedPersons | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| system | telecoms | 1..1 | – | – | xs:string |
| value | telecoms | 1..1 | – | – | xs:string |
| use | telecoms | 1..1 | – | – | xs:string |
| telecom | relatedPersons | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| system | relatedPersons | 1..1 | – | – | xs:string |
| value | relatedPersons | 1..1 | – | – | xs:string |
| use | relatedPersons | 1..1 | – | – | xs:string |
| gender | relatedPersons | 1..1 | – | – | xs:string |
| birth_date | relatedPersons | 1..1 | – | – | xs:date |
| addresses | relatedPersons | 1..1 | – | – | – |
| address | addresses | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| use | addresses | 1..1 | – | – | xs:string |
| type | addresses | 1..1 | – | – | xs:string |
| text | addresses | 1..1 | – | – | xs:string |
| line | addresses | 1..unbounded | – | – | xs:string |
| city | addresses | 1..1 | – | – | xs:string |
| state | addresses | 1..1 | – | – | xs:string |
| postal_code | addresses | 1..1 | – | – | xs:string |
| country | addresses | 1..1 | – | – | xs:string |
| address | relatedPersons | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| use | relatedPersons | 1..1 | – | – | xs:string |
| type | relatedPersons | 1..1 | – | – | xs:string |
| text | relatedPersons | 1..1 | – | – | xs:string |
| line | relatedPersons | 1..unbounded | – | – | xs:string |
| city | relatedPersons | 1..1 | – | – | xs:string |
| state | relatedPersons | 1..1 | – | – | xs:string |
| postal_code | relatedPersons | 1..1 | – | – | xs:string |
| country | relatedPersons | 1..1 | – | – | xs:string |
| communication_language | relatedPersons | 1..1 | – | – | xs:string |
| relationship | relatedPersons | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| codeable_concept | relatedPersons | 1..1 | – | – | codeableConcept |
| relatedPerson | roster | 1..unbounded | – | – | – |
| active | relatedPerson | 1..1 | – | – | xs:boolean |
| names | relatedPerson | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| use | names | 1..1 | – | – | xs:string |
| text | names | 1..1 | – | – | xs:string |
| family | names | 1..1 | – | – | xs:string |
| given | names | 1..unbounded | – | – | xs:string |
| name | relatedPerson | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| use | relatedPerson | 1..1 | – | – | xs:string |
| text | relatedPerson | 1..1 | – | – | xs:string |
| family | relatedPerson | 1..1 | – | – | xs:string |
| given | relatedPerson | 1..unbounded | – | – | xs:string |
| telecoms | relatedPerson | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| system | telecoms | 1..1 | – | – | xs:string |
| value | telecoms | 1..1 | – | – | xs:string |
| use | telecoms | 1..1 | – | – | xs:string |
| telecom | relatedPerson | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| system | relatedPerson | 1..1 | – | – | xs:string |
| value | relatedPerson | 1..1 | – | – | xs:string |
| use | relatedPerson | 1..1 | – | – | xs:string |
| gender | relatedPerson | 1..1 | – | – | xs:string |
| birth_date | relatedPerson | 1..1 | – | – | xs:date |
| addresses | relatedPerson | 1..1 | – | – | – |
| address | addresses | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| use | addresses | 1..1 | – | – | xs:string |
| type | addresses | 1..1 | – | – | xs:string |
| text | addresses | 1..1 | – | – | xs:string |
| line | addresses | 1..unbounded | – | – | xs:string |
| city | addresses | 1..1 | – | – | xs:string |
| state | addresses | 1..1 | – | – | xs:string |
| postal_code | addresses | 1..1 | – | – | xs:string |
| country | addresses | 1..1 | – | – | xs:string |
| address | relatedPerson | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| use | relatedPerson | 1..1 | – | – | xs:string |
| type | relatedPerson | 1..1 | – | – | xs:string |
| text | relatedPerson | 1..1 | – | – | xs:string |
| line | relatedPerson | 1..unbounded | – | – | xs:string |
| city | relatedPerson | 1..1 | – | – | xs:string |
| state | relatedPerson | 1..1 | – | – | xs:string |
| postal_code | relatedPerson | 1..1 | – | – | xs:string |
| country | relatedPerson | 1..1 | – | – | xs:string |
| communication_language | relatedPerson | 1..1 | – | – | xs:string |
| relationship | relatedPerson | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| codeable_concept | relatedPerson | 1..1 | – | – | codeableConcept |
| active | roster | 1..1 | – | – | xs:boolean |
| names | roster | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| use | names | 1..1 | – | – | xs:string |
| text | names | 1..1 | – | – | xs:string |
| family | names | 1..1 | – | – | xs:string |
| given | names | 1..unbounded | – | – | xs:string |
| name | roster | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| use | roster | 1..1 | – | – | xs:string |
| text | roster | 1..1 | – | – | xs:string |
| family | roster | 1..1 | – | – | xs:string |
| given | roster | 1..unbounded | – | – | xs:string |
| telecoms | roster | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| system | telecoms | 1..1 | – | – | xs:string |
| value | telecoms | 1..1 | – | – | xs:string |
| use | telecoms | 1..1 | – | – | xs:string |
| telecom | roster | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| system | roster | 1..1 | – | – | xs:string |
| value | roster | 1..1 | – | – | xs:string |
| use | roster | 1..1 | – | – | xs:string |
| gender | roster | 1..1 | – | – | xs:string |
| birth_date | roster | 1..1 | – | – | xs:date |
| addresses | roster | 1..1 | – | – | – |
| address | addresses | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| use | addresses | 1..1 | – | – | xs:string |
| type | addresses | 1..1 | – | – | xs:string |
| text | addresses | 1..1 | – | – | xs:string |
| line | addresses | 1..unbounded | – | – | xs:string |
| city | addresses | 1..1 | – | – | xs:string |
| state | addresses | 1..1 | – | – | xs:string |
| postal_code | addresses | 1..1 | – | – | xs:string |
| country | addresses | 1..1 | – | – | xs:string |
| address | roster | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| use | roster | 1..1 | – | – | xs:string |
| type | roster | 1..1 | – | – | xs:string |
| text | roster | 1..1 | – | – | xs:string |
| line | roster | 1..unbounded | – | – | xs:string |
| city | roster | 1..1 | – | – | xs:string |
| state | roster | 1..1 | – | – | xs:string |
| postal_code | roster | 1..1 | – | – | xs:string |
| country | roster | 1..1 | – | – | xs:string |
| communication_language | roster | 1..1 | – | – | xs:string |
| relationship | roster | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| codeable_concept | roster | 1..1 | – | – | codeableConcept |
| occupation_item | occupations | 1..unbounded | – | – | – |
| status | occupation_item | 1..1 | – | – | – |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| industry | occupation_item | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| status | occupations | 1..1 | – | – | – |
| codeable_concept | occupations | 1..1 | – | – | codeableConcept |
| industry | occupations | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| codeable_concept | occupations | 1..1 | – | – | codeableConcept |
| occupation_item | roster | 1..unbounded | – | – | – |
| status | occupation_item | 1..1 | – | – | – |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| industry | occupation_item | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| status | roster | 1..1 | – | – | – |
| codeable_concept | roster | 1..1 | – | – | codeableConcept |
| industry | roster | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| codeable_concept | roster | 1..1 | – | – | codeableConcept |
| unique_person_ids | roster | 1..1 | – | – | – |
| unique_person_id | unique_person_ids | 1..1 | This is the person's unique member number in the Payer system across plans. This number is not reused for anyone else. | – | string |
| unique_person_id_assigner | unique_person_ids | 1..1 | Organization that issued id | – | – |
| unique_person_id | roster | 1..1 | This is the person's unique member number in the Payer system across plans. This number is not reused for anyone else. | – | string |
| unique_person_id_assigner | roster | 1..1 | Organization that issued id | – | – |
| member_id | roster | 1..1 | Use this element to list the Member Number. | – | string |
| subscriber_id | roster | 1..1 | Use this element to list the Subscriber Number. An identifier for a subscriber of an insurance policy which is unique for, and usually assigned by, the insurance carrier. Use Case: A person is the subscriber of an insurance policy. The person’s family may be plan members, but are not the subscriber. | – | string |
| names | roster | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| text | name | 1..1 | Use this element to enter the entire name of the member | – | string |
| family | name | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | name | 1..unbounded | Given names (not always 'first'). Includes middle names | – | string |
| text | names | 1..1 | Use this element to enter the entire name of the member | – | string |
| family | names | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | names | 1..unbounded | Given names (not always 'first'). Includes middle names | – | string |
| name | roster | 1..unbounded | – | – | – |
| text | name | 1..1 | Use this element to enter the entire name of the member | – | string |
| family | name | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | name | 1..unbounded | Given names (not always 'first'). Includes middle names | – | string |
| text | roster | 1..1 | Use this element to enter the entire name of the member | – | string |
| family | roster | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | roster | 1..unbounded | Given names (not always 'first'). Includes middle names | – | string |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. Please provide at least one form of contact (e.g. phone, email, etc.) | – | – |
| system | telecom | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | telecom | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| system | telecoms | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | telecoms | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| telecom | roster | 1..unbounded | Contact points of telecommunications. Please provide at least one form of contact (e.g. phone, email, etc.) | – | – |
| system | telecom | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | telecom | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| system | roster | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | roster | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| address | addresses | 1..unbounded | Use this element to list all the addresses the member is associated with. It is recommended that at least one address be supplied for identification purposes. | – | – |
| text | address | 1..1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) | – | string |
| line | address | 1..unbounded | – | – | string |
| city | address | 1..1 | – | – | string |
| state | address | 1..1 | – | – | string |
| postal_code | address | 1..1 | – | – | string |
| country | address | 1..1 | Country (e.g. can be ISO 3166 2 or 3 letter code) | – | string |
| text | addresses | 1..1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) | – | string |
| line | addresses | 1..unbounded | – | – | string |
| city | addresses | 1..1 | – | – | string |
| state | addresses | 1..1 | – | – | string |
| postal_code | addresses | 1..1 | – | – | string |
| country | addresses | 1..1 | Country (e.g. can be ISO 3166 2 or 3 letter code) | – | string |
| address | roster | 1..unbounded | Use this element to list all the addresses the member is associated with. It is recommended that at least one address be supplied for identification purposes. | – | – |
| text | address | 1..1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) | – | string |
| line | address | 1..unbounded | – | – | string |
| city | address | 1..1 | – | – | string |
| state | address | 1..1 | – | – | string |
| postal_code | address | 1..1 | – | – | string |
| country | address | 1..1 | Country (e.g. can be ISO 3166 2 or 3 letter code) | – | string |
| text | roster | 1..1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) | – | string |
| line | roster | 1..unbounded | – | – | string |
| city | roster | 1..1 | – | – | string |
| state | roster | 1..1 | – | – | string |
| postal_code | roster | 1..1 | – | – | string |
| country | roster | 1..1 | Country (e.g. can be ISO 3166 2 or 3 letter code) | – | string |
| health_coverage | roster | 1..1 | – | – | – |
| plan_id | health_coverage | 1..1 | The Identifier of the plan associated with the Plan Name | – | string |
| plan_name | health_coverage | 1..1 | – | – | string |
| coverage_status | health_coverage | 1..1 | Indicates the current status of coverage for the member. Must be one of: active, cancelled, draft, entered-in-error | – | string |
| codeable_concept | coverage_type | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| codeable_concept | health_coverage | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| coverage_period | health_coverage | 1..1 | Use this element to provide dates of coverage for this member. If the coverage is still active, do not provide an End date. Format is YYYY-MM-DD. | – | period |
| plan_id | roster | 1..1 | The Identifier of the plan associated with the Plan Name | – | string |
| plan_name | roster | 1..1 | – | – | string |
| coverage_status | roster | 1..1 | Indicates the current status of coverage for the member. Must be one of: active, cancelled, draft, entered-in-error | – | string |
| codeable_concept | coverage_type | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| codeable_concept | roster | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| coverage_period | roster | 1..1 | Use this element to provide dates of coverage for this member. If the coverage is still active, do not provide an End date. Format is YYYY-MM-DD. | – | period |
| communication | communications | 1..unbounded | Use this element to provide the languages the member communicates in | – | – |
| language_code | communication | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| language_code | communications | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| communication | roster | 1..unbounded | Use this element to provide the languages the member communicates in | – | – |
| language_code | communication | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| language_code | roster | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| unique_record_identifier | roster | 1..1 | – | – | string |
| delegate | delegates | 1..unbounded | – | – | – |
| family | delegate | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | delegate | 1..1 | Given names (not always 'first'). Includes middle names | – | string |
| telecoms | delegate | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | telecoms | 1..1 | – | – | – |
| value | telecoms | 1..1 | – | – | string |
| telecom | delegate | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | delegate | 1..1 | – | – | – |
| value | delegate | 1..1 | – | – | string |
| email_address | delegate | 1..1 | – | – | – |
| is_member | delegate | 1..1 | Fixed to false | – | – |
| family | delegates | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | delegates | 1..1 | Given names (not always 'first'). Includes middle names | – | string |
| telecoms | delegates | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | telecoms | 1..1 | – | – | – |
| value | telecoms | 1..1 | – | – | string |
| telecom | delegates | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | delegates | 1..1 | – | – | – |
| value | delegates | 1..1 | – | – | string |
| email_address | delegates | 1..1 | – | – | – |
| is_member | delegates | 1..1 | Fixed to false | – | – |
| delegate | roster | 1..unbounded | – | – | – |
| family | delegate | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | delegate | 1..1 | Given names (not always 'first'). Includes middle names | – | string |
| telecoms | delegate | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | telecoms | 1..1 | – | – | – |
| value | telecoms | 1..1 | – | – | string |
| telecom | delegate | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | delegate | 1..1 | – | – | – |
| value | delegate | 1..1 | – | – | string |
| email_address | delegate | 1..1 | – | – | – |
| is_member | delegate | 1..1 | Fixed to false | – | – |
| family | roster | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | roster | 1..1 | Given names (not always 'first'). Includes middle names | – | string |
| telecoms | roster | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | telecoms | 1..1 | – | – | – |
| value | telecoms | 1..1 | – | – | string |
| telecom | roster | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | roster | 1..1 | – | – | – |
| value | roster | 1..1 | – | – | string |
| email_address | roster | 1..1 | – | – | – |
| is_member | roster | 1..1 | Fixed to false | – | – |


## All Elements of Roster XSD

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| roster |  | 1..1 | – | – | – |
| schema_version | roster | 1..1 | This element defines what version of the roster schema you will be validating against (e.g. 1.0) | – | – |
| sender_id | roster | 1..1 | This element is used to the unique identifier assigned to your organization | – | string |
| date_time_reported | roster | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | – |
| member | roster | 1..unbounded | – | – | – |
| us_core_race | member | 0..1 | – | – | – |
| code | us_core_race | 0..5 | This element is for selecting 1 of the 5 OMB race category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html | – | – |
| detailed_code | us_core_race | 0..unbounded | This element is for selecting 1 of the additional expansion codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html | – | – |
| text | us_core_race | 1..1 | Use this element for adding a text description | – | string |
| code | member | 0..5 | This element is for selecting 1 of the 5 OMB race category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html | – | – |
| detailed_code | member | 0..unbounded | This element is for selecting 1 of the additional expansion codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html | – | – |
| text | member | 1..1 | Use this element for adding a text description | – | string |
| us_core_ethnicity | member | 0..1 | – | – | – |
| code | us_core_ethnicity | 0..1 | This element is for selecting 1 of the OMB ethnicity category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-omb-ethnicity-category.html | – | – |
| detailed_code | us_core_ethnicity | 0..unbounded | This element is for selecting 1 of the additional ethnicity codes from the CDC that can be found here: https://www.hl7.org/fhir/us/core/ValueSet-detailed-ethnicity.html | – | – |
| text | us_core_ethnicity | 1..1 | Use this element for adding a text description | – | string |
| code | member | 0..1 | This element is for selecting 1 of the OMB ethnicity category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-omb-ethnicity-category.html | – | – |
| detailed_code | member | 0..unbounded | This element is for selecting 1 of the additional ethnicity codes from the CDC that can be found here: https://www.hl7.org/fhir/us/core/ValueSet-detailed-ethnicity.html | – | – |
| text | member | 1..1 | Use this element for adding a text description | – | string |
| us_core_birth_sex | member | 0..1 | This element is used for selecting birth sex (M = Male, F = Female, UNK = Unknown) | – | – |
| is_subscriber | member | 1..1 | This element is used to identify if this person is the subscriber (True / False). (e.g. The main policy holder of the plan) | – | xs:boolean |
| relationship | member | 1..1 | Relationship to the Subscriber. The full list can be found here: http://hl7.org/fhir/R4/valueset-subscriber-relationship.html | – | – |
| birth_date | member | 1..1 | Birth date (1900-01-01) | – | date |
| deceased_date_time | member | 0..1 | DateTime of death (2001-10-26T21:32:52+02:00) | – | dateTime |
| gender | member | 1..1 | Use this element for Sex/Administrative Gender (male, female, other or unknown) | – | – |
| tribal_affiliations | member | 0..1 | – | – | – |
| tribal_affiliation | tribal_affiliations | 1..unbounded | – | – | – |
| codeable_concept | tribal_affiliation | 1..1 | – | – | codeableConcept |
| is_enrolled | tribal_affiliation | 1..1 | – | – | xs:boolean |
| codeable_concept | tribal_affiliations | 1..1 | – | – | codeableConcept |
| is_enrolled | tribal_affiliations | 1..1 | – | – | xs:boolean |
| tribal_affiliation | member | 1..unbounded | – | – | – |
| codeable_concept | tribal_affiliation | 1..1 | – | – | codeableConcept |
| is_enrolled | tribal_affiliation | 1..1 | – | – | xs:boolean |
| codeable_concept | member | 1..1 | – | – | codeableConcept |
| is_enrolled | member | 1..1 | – | – | xs:boolean |
| sexual_orientations | member | 0..1 | – | – | – |
| sexual_orientation | sexual_orientations | 1..unbounded | – | – | – |
| codeable_concept | sexual_orientation | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | sexual_orientation | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| codeable_concept | sexual_orientations | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | sexual_orientations | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| sexual_orientation | member | 1..unbounded | – | – | – |
| codeable_concept | sexual_orientation | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | sexual_orientation | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| codeable_concept | member | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | member | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| gender_identities | member | 0..1 | – | – | – |
| gender_identity | gender_identities | 1..unbounded | – | – | – |
| codeable_concept | gender_identity | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | gender_identity | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| codeable_concept | gender_identities | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | gender_identities | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| gender_identity | member | 1..unbounded | – | – | – |
| codeable_concept | gender_identity | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | gender_identity | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| codeable_concept | member | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | member | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| relatedPersons | member | 0..1 | – | – | – |
| relatedPerson | relatedPersons | 1..unbounded | – | – | – |
| active | relatedPerson | 1..1 | – | – | xs:boolean |
| names | relatedPerson | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| prefix | name | 0..1 | – | – | xs:string |
| period | name | 0..1 | – | – | period |
| use | names | 1..1 | – | – | xs:string |
| text | names | 1..1 | – | – | xs:string |
| family | names | 1..1 | – | – | xs:string |
| given | names | 1..unbounded | – | – | xs:string |
| prefix | names | 0..1 | – | – | xs:string |
| period | names | 0..1 | – | – | period |
| name | relatedPerson | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| prefix | name | 0..1 | – | – | xs:string |
| period | name | 0..1 | – | – | period |
| use | relatedPerson | 1..1 | – | – | xs:string |
| text | relatedPerson | 1..1 | – | – | xs:string |
| family | relatedPerson | 1..1 | – | – | xs:string |
| given | relatedPerson | 1..unbounded | – | – | xs:string |
| prefix | relatedPerson | 0..1 | – | – | xs:string |
| period | relatedPerson | 0..1 | – | – | period |
| telecoms | relatedPerson | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| rank | telecom | 0..1 | – | – | xs:integer |
| period | telecom | 0..1 | – | – | period_date |
| system | telecoms | 1..1 | – | – | xs:string |
| value | telecoms | 1..1 | – | – | xs:string |
| use | telecoms | 1..1 | – | – | xs:string |
| rank | telecoms | 0..1 | – | – | xs:integer |
| period | telecoms | 0..1 | – | – | period_date |
| telecom | relatedPerson | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| rank | telecom | 0..1 | – | – | xs:integer |
| period | telecom | 0..1 | – | – | period_date |
| system | relatedPerson | 1..1 | – | – | xs:string |
| value | relatedPerson | 1..1 | – | – | xs:string |
| use | relatedPerson | 1..1 | – | – | xs:string |
| rank | relatedPerson | 0..1 | – | – | xs:integer |
| period | relatedPerson | 0..1 | – | – | period_date |
| gender | relatedPerson | 1..1 | – | – | xs:string |
| birth_date | relatedPerson | 1..1 | – | – | xs:date |
| addresses | relatedPerson | 1..1 | – | – | – |
| address | addresses | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| district | address | 0..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| period | address | 0..1 | – | – | period_date |
| use | addresses | 1..1 | – | – | xs:string |
| type | addresses | 1..1 | – | – | xs:string |
| text | addresses | 1..1 | – | – | xs:string |
| line | addresses | 1..unbounded | – | – | xs:string |
| city | addresses | 1..1 | – | – | xs:string |
| district | addresses | 0..1 | – | – | xs:string |
| state | addresses | 1..1 | – | – | xs:string |
| postal_code | addresses | 1..1 | – | – | xs:string |
| country | addresses | 1..1 | – | – | xs:string |
| period | addresses | 0..1 | – | – | period_date |
| address | relatedPerson | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| district | address | 0..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| period | address | 0..1 | – | – | period_date |
| use | relatedPerson | 1..1 | – | – | xs:string |
| type | relatedPerson | 1..1 | – | – | xs:string |
| text | relatedPerson | 1..1 | – | – | xs:string |
| line | relatedPerson | 1..unbounded | – | – | xs:string |
| city | relatedPerson | 1..1 | – | – | xs:string |
| district | relatedPerson | 0..1 | – | – | xs:string |
| state | relatedPerson | 1..1 | – | – | xs:string |
| postal_code | relatedPerson | 1..1 | – | – | xs:string |
| country | relatedPerson | 1..1 | – | – | xs:string |
| period | relatedPerson | 0..1 | – | – | period_date |
| communication_language | relatedPerson | 1..1 | – | – | xs:string |
| relationship | relatedPerson | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| codeable_concept | relatedPerson | 1..1 | – | – | codeableConcept |
| active | relatedPersons | 1..1 | – | – | xs:boolean |
| names | relatedPersons | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| prefix | name | 0..1 | – | – | xs:string |
| period | name | 0..1 | – | – | period |
| use | names | 1..1 | – | – | xs:string |
| text | names | 1..1 | – | – | xs:string |
| family | names | 1..1 | – | – | xs:string |
| given | names | 1..unbounded | – | – | xs:string |
| prefix | names | 0..1 | – | – | xs:string |
| period | names | 0..1 | – | – | period |
| name | relatedPersons | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| prefix | name | 0..1 | – | – | xs:string |
| period | name | 0..1 | – | – | period |
| use | relatedPersons | 1..1 | – | – | xs:string |
| text | relatedPersons | 1..1 | – | – | xs:string |
| family | relatedPersons | 1..1 | – | – | xs:string |
| given | relatedPersons | 1..unbounded | – | – | xs:string |
| prefix | relatedPersons | 0..1 | – | – | xs:string |
| period | relatedPersons | 0..1 | – | – | period |
| telecoms | relatedPersons | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| rank | telecom | 0..1 | – | – | xs:integer |
| period | telecom | 0..1 | – | – | period_date |
| system | telecoms | 1..1 | – | – | xs:string |
| value | telecoms | 1..1 | – | – | xs:string |
| use | telecoms | 1..1 | – | – | xs:string |
| rank | telecoms | 0..1 | – | – | xs:integer |
| period | telecoms | 0..1 | – | – | period_date |
| telecom | relatedPersons | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| rank | telecom | 0..1 | – | – | xs:integer |
| period | telecom | 0..1 | – | – | period_date |
| system | relatedPersons | 1..1 | – | – | xs:string |
| value | relatedPersons | 1..1 | – | – | xs:string |
| use | relatedPersons | 1..1 | – | – | xs:string |
| rank | relatedPersons | 0..1 | – | – | xs:integer |
| period | relatedPersons | 0..1 | – | – | period_date |
| gender | relatedPersons | 1..1 | – | – | xs:string |
| birth_date | relatedPersons | 1..1 | – | – | xs:date |
| addresses | relatedPersons | 1..1 | – | – | – |
| address | addresses | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| district | address | 0..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| period | address | 0..1 | – | – | period_date |
| use | addresses | 1..1 | – | – | xs:string |
| type | addresses | 1..1 | – | – | xs:string |
| text | addresses | 1..1 | – | – | xs:string |
| line | addresses | 1..unbounded | – | – | xs:string |
| city | addresses | 1..1 | – | – | xs:string |
| district | addresses | 0..1 | – | – | xs:string |
| state | addresses | 1..1 | – | – | xs:string |
| postal_code | addresses | 1..1 | – | – | xs:string |
| country | addresses | 1..1 | – | – | xs:string |
| period | addresses | 0..1 | – | – | period_date |
| address | relatedPersons | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| district | address | 0..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| period | address | 0..1 | – | – | period_date |
| use | relatedPersons | 1..1 | – | – | xs:string |
| type | relatedPersons | 1..1 | – | – | xs:string |
| text | relatedPersons | 1..1 | – | – | xs:string |
| line | relatedPersons | 1..unbounded | – | – | xs:string |
| city | relatedPersons | 1..1 | – | – | xs:string |
| district | relatedPersons | 0..1 | – | – | xs:string |
| state | relatedPersons | 1..1 | – | – | xs:string |
| postal_code | relatedPersons | 1..1 | – | – | xs:string |
| country | relatedPersons | 1..1 | – | – | xs:string |
| period | relatedPersons | 0..1 | – | – | period_date |
| communication_language | relatedPersons | 1..1 | – | – | xs:string |
| relationship | relatedPersons | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| codeable_concept | relatedPersons | 1..1 | – | – | codeableConcept |
| relatedPerson | member | 1..unbounded | – | – | – |
| active | relatedPerson | 1..1 | – | – | xs:boolean |
| names | relatedPerson | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| prefix | name | 0..1 | – | – | xs:string |
| period | name | 0..1 | – | – | period |
| use | names | 1..1 | – | – | xs:string |
| text | names | 1..1 | – | – | xs:string |
| family | names | 1..1 | – | – | xs:string |
| given | names | 1..unbounded | – | – | xs:string |
| prefix | names | 0..1 | – | – | xs:string |
| period | names | 0..1 | – | – | period |
| name | relatedPerson | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| prefix | name | 0..1 | – | – | xs:string |
| period | name | 0..1 | – | – | period |
| use | relatedPerson | 1..1 | – | – | xs:string |
| text | relatedPerson | 1..1 | – | – | xs:string |
| family | relatedPerson | 1..1 | – | – | xs:string |
| given | relatedPerson | 1..unbounded | – | – | xs:string |
| prefix | relatedPerson | 0..1 | – | – | xs:string |
| period | relatedPerson | 0..1 | – | – | period |
| telecoms | relatedPerson | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| rank | telecom | 0..1 | – | – | xs:integer |
| period | telecom | 0..1 | – | – | period_date |
| system | telecoms | 1..1 | – | – | xs:string |
| value | telecoms | 1..1 | – | – | xs:string |
| use | telecoms | 1..1 | – | – | xs:string |
| rank | telecoms | 0..1 | – | – | xs:integer |
| period | telecoms | 0..1 | – | – | period_date |
| telecom | relatedPerson | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| rank | telecom | 0..1 | – | – | xs:integer |
| period | telecom | 0..1 | – | – | period_date |
| system | relatedPerson | 1..1 | – | – | xs:string |
| value | relatedPerson | 1..1 | – | – | xs:string |
| use | relatedPerson | 1..1 | – | – | xs:string |
| rank | relatedPerson | 0..1 | – | – | xs:integer |
| period | relatedPerson | 0..1 | – | – | period_date |
| gender | relatedPerson | 1..1 | – | – | xs:string |
| birth_date | relatedPerson | 1..1 | – | – | xs:date |
| addresses | relatedPerson | 1..1 | – | – | – |
| address | addresses | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| district | address | 0..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| period | address | 0..1 | – | – | period_date |
| use | addresses | 1..1 | – | – | xs:string |
| type | addresses | 1..1 | – | – | xs:string |
| text | addresses | 1..1 | – | – | xs:string |
| line | addresses | 1..unbounded | – | – | xs:string |
| city | addresses | 1..1 | – | – | xs:string |
| district | addresses | 0..1 | – | – | xs:string |
| state | addresses | 1..1 | – | – | xs:string |
| postal_code | addresses | 1..1 | – | – | xs:string |
| country | addresses | 1..1 | – | – | xs:string |
| period | addresses | 0..1 | – | – | period_date |
| address | relatedPerson | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| district | address | 0..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| period | address | 0..1 | – | – | period_date |
| use | relatedPerson | 1..1 | – | – | xs:string |
| type | relatedPerson | 1..1 | – | – | xs:string |
| text | relatedPerson | 1..1 | – | – | xs:string |
| line | relatedPerson | 1..unbounded | – | – | xs:string |
| city | relatedPerson | 1..1 | – | – | xs:string |
| district | relatedPerson | 0..1 | – | – | xs:string |
| state | relatedPerson | 1..1 | – | – | xs:string |
| postal_code | relatedPerson | 1..1 | – | – | xs:string |
| country | relatedPerson | 1..1 | – | – | xs:string |
| period | relatedPerson | 0..1 | – | – | period_date |
| communication_language | relatedPerson | 1..1 | – | – | xs:string |
| relationship | relatedPerson | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| codeable_concept | relatedPerson | 1..1 | – | – | codeableConcept |
| active | member | 1..1 | – | – | xs:boolean |
| names | member | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| prefix | name | 0..1 | – | – | xs:string |
| period | name | 0..1 | – | – | period |
| use | names | 1..1 | – | – | xs:string |
| text | names | 1..1 | – | – | xs:string |
| family | names | 1..1 | – | – | xs:string |
| given | names | 1..unbounded | – | – | xs:string |
| prefix | names | 0..1 | – | – | xs:string |
| period | names | 0..1 | – | – | period |
| name | member | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| prefix | name | 0..1 | – | – | xs:string |
| period | name | 0..1 | – | – | period |
| use | member | 1..1 | – | – | xs:string |
| text | member | 1..1 | – | – | xs:string |
| family | member | 1..1 | – | – | xs:string |
| given | member | 1..unbounded | – | – | xs:string |
| prefix | member | 0..1 | – | – | xs:string |
| period | member | 0..1 | – | – | period |
| telecoms | member | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| rank | telecom | 0..1 | – | – | xs:integer |
| period | telecom | 0..1 | – | – | period_date |
| system | telecoms | 1..1 | – | – | xs:string |
| value | telecoms | 1..1 | – | – | xs:string |
| use | telecoms | 1..1 | – | – | xs:string |
| rank | telecoms | 0..1 | – | – | xs:integer |
| period | telecoms | 0..1 | – | – | period_date |
| telecom | member | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| rank | telecom | 0..1 | – | – | xs:integer |
| period | telecom | 0..1 | – | – | period_date |
| system | member | 1..1 | – | – | xs:string |
| value | member | 1..1 | – | – | xs:string |
| use | member | 1..1 | – | – | xs:string |
| rank | member | 0..1 | – | – | xs:integer |
| period | member | 0..1 | – | – | period_date |
| gender | member | 1..1 | – | – | xs:string |
| birth_date | member | 1..1 | – | – | xs:date |
| addresses | member | 1..1 | – | – | – |
| address | addresses | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| district | address | 0..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| period | address | 0..1 | – | – | period_date |
| use | addresses | 1..1 | – | – | xs:string |
| type | addresses | 1..1 | – | – | xs:string |
| text | addresses | 1..1 | – | – | xs:string |
| line | addresses | 1..unbounded | – | – | xs:string |
| city | addresses | 1..1 | – | – | xs:string |
| district | addresses | 0..1 | – | – | xs:string |
| state | addresses | 1..1 | – | – | xs:string |
| postal_code | addresses | 1..1 | – | – | xs:string |
| country | addresses | 1..1 | – | – | xs:string |
| period | addresses | 0..1 | – | – | period_date |
| address | member | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| district | address | 0..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| period | address | 0..1 | – | – | period_date |
| use | member | 1..1 | – | – | xs:string |
| type | member | 1..1 | – | – | xs:string |
| text | member | 1..1 | – | – | xs:string |
| line | member | 1..unbounded | – | – | xs:string |
| city | member | 1..1 | – | – | xs:string |
| district | member | 0..1 | – | – | xs:string |
| state | member | 1..1 | – | – | xs:string |
| postal_code | member | 1..1 | – | – | xs:string |
| country | member | 1..1 | – | – | xs:string |
| period | member | 0..1 | – | – | period_date |
| communication_language | member | 1..1 | – | – | xs:string |
| relationship | member | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| codeable_concept | member | 1..1 | – | – | codeableConcept |
| occupations | member | 0..1 | – | – | – |
| occupation_item | occupations | 1..unbounded | – | – | – |
| status | occupation_item | 1..1 | – | – | – |
| effectivePeriod | occupation_item | 0..1 | – | – | period_date |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| industry | occupation_item | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| status | occupations | 1..1 | – | – | – |
| effectivePeriod | occupations | 0..1 | – | – | period_date |
| codeable_concept | occupations | 1..1 | – | – | codeableConcept |
| industry | occupations | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| codeable_concept | occupations | 1..1 | – | – | codeableConcept |
| occupation_item | member | 1..unbounded | – | – | – |
| status | occupation_item | 1..1 | – | – | – |
| effectivePeriod | occupation_item | 0..1 | – | – | period_date |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| industry | occupation_item | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| status | member | 1..1 | – | – | – |
| effectivePeriod | member | 0..1 | – | – | period_date |
| codeable_concept | member | 1..1 | – | – | codeableConcept |
| industry | member | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| codeable_concept | member | 1..1 | – | – | codeableConcept |
| unique_person_ids | member | 1..1 | – | – | – |
| unique_person_id | unique_person_ids | 1..1 | This is the person's unique member number in the Payer system across plans. This number is not reused for anyone else. | – | string |
| unique_person_id_assigner | unique_person_ids | 1..1 | Organization that issued id | – | – |
| unique_person_id_assigner_type | unique_person_ids | 0..1 | Type of organization that issued id | – | string |
| unique_person_id | member | 1..1 | This is the person's unique member number in the Payer system across plans. This number is not reused for anyone else. | – | string |
| unique_person_id_assigner | member | 1..1 | Organization that issued id | – | – |
| unique_person_id_assigner_type | member | 0..1 | Type of organization that issued id | – | string |
| member_identity | member | 0..1 | – | – | – |
| member_last_4_ssn | member_identity | 0..1 | Use this element for last 4 digit of member SSN (0000) | – | – |
| secret_display_name | member_identity | 0..1 | Use this element for the secret display name when SSN is not available | – | string |
| secret_value | member_identity | 0..1 | Use this element for the secret value when SSN is not available | – | string |
| secret_length | member_identity | 0..1 | Use this element for the secret length when SSN is not available | – | unsignedInt |
| member_last_4_ssn | member | 0..1 | Use this element for last 4 digit of member SSN (0000) | – | – |
| secret_display_name | member | 0..1 | Use this element for the secret display name when SSN is not available | – | string |
| secret_value | member | 0..1 | Use this element for the secret value when SSN is not available | – | string |
| secret_length | member | 0..1 | Use this element for the secret length when SSN is not available | – | unsignedInt |
| member_id | member | 1..1 | Use this element to list the Member Number. | – | string |
| member_id_system | member | 0..1 | Use this element to identify the UM system that issues the Member Identifier. This is NOT the organization that assigns the identifier. | – | string |
| subscriber_id | member | 1..1 | Use this element to list the Subscriber Number. An identifier for a subscriber of an insurance policy which is unique for, and usually assigned by, the insurance carrier. Use Case: A person is the subscriber of an insurance policy. The person’s family may be plan members, but are not the subscriber. | – | string |
| names | member | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 0..1 | Use this element to describe the name. More information can be found here: http://hl7.org/fhir/R4/valueset-name-use.html | – | – |
| text | name | 1..1 | Use this element to enter the entire name of the member | – | string |
| family | name | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | name | 1..unbounded | Given names (not always 'first'). Includes middle names | – | string |
| prefix | name | 0..1 | – | – | string |
| suffix | name | 0..1 | – | – | string |
| period | name | 0..1 | Time period when name was/is in use. If the name is still in use, do not supply an End date | – | period |
| use | names | 0..1 | Use this element to describe the name. More information can be found here: http://hl7.org/fhir/R4/valueset-name-use.html | – | – |
| text | names | 1..1 | Use this element to enter the entire name of the member | – | string |
| family | names | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | names | 1..unbounded | Given names (not always 'first'). Includes middle names | – | string |
| prefix | names | 0..1 | – | – | string |
| suffix | names | 0..1 | – | – | string |
| period | names | 0..1 | Time period when name was/is in use. If the name is still in use, do not supply an End date | – | period |
| name | member | 1..unbounded | – | – | – |
| use | name | 0..1 | Use this element to describe the name. More information can be found here: http://hl7.org/fhir/R4/valueset-name-use.html | – | – |
| text | name | 1..1 | Use this element to enter the entire name of the member | – | string |
| family | name | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | name | 1..unbounded | Given names (not always 'first'). Includes middle names | – | string |
| prefix | name | 0..1 | – | – | string |
| suffix | name | 0..1 | – | – | string |
| period | name | 0..1 | Time period when name was/is in use. If the name is still in use, do not supply an End date | – | period |
| use | member | 0..1 | Use this element to describe the name. More information can be found here: http://hl7.org/fhir/R4/valueset-name-use.html | – | – |
| text | member | 1..1 | Use this element to enter the entire name of the member | – | string |
| family | member | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | member | 1..unbounded | Given names (not always 'first'). Includes middle names | – | string |
| prefix | member | 0..1 | – | – | string |
| suffix | member | 0..1 | – | – | string |
| period | member | 0..1 | Time period when name was/is in use. If the name is still in use, do not supply an End date | – | period |
| telecoms | member | 0..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. Please provide at least one form of contact (e.g. phone, email, etc.) | – | – |
| system | telecom | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | telecom | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| use | telecom | 0..1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html | – | – |
| rank | telecom | 0..1 | Specify preferred order of use (1 = highest) | – | positiveInt |
| period | telecom | 0..1 | Time period when the contact point was/is in use | – | period |
| system | telecoms | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | telecoms | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| use | telecoms | 0..1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html | – | – |
| rank | telecoms | 0..1 | Specify preferred order of use (1 = highest) | – | positiveInt |
| period | telecoms | 0..1 | Time period when the contact point was/is in use | – | period |
| telecom | member | 1..unbounded | Contact points of telecommunications. Please provide at least one form of contact (e.g. phone, email, etc.) | – | – |
| system | telecom | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | telecom | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| use | telecom | 0..1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html | – | – |
| rank | telecom | 0..1 | Specify preferred order of use (1 = highest) | – | positiveInt |
| period | telecom | 0..1 | Time period when the contact point was/is in use | – | period |
| system | member | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | member | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| use | member | 0..1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html | – | – |
| rank | member | 0..1 | Specify preferred order of use (1 = highest) | – | positiveInt |
| period | member | 0..1 | Time period when the contact point was/is in use | – | period |
| addresses | member | 0..1 | – | – | – |
| address | addresses | 1..unbounded | Use this element to list all the addresses the member is associated with. It is recommended that at least one address be supplied for identification purposes. | – | – |
| use | address | 0..1 | The use of this address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-use.html | – | – |
| type | address | 0..1 | The type of address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-type.html | – | – |
| text | address | 1..1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) | – | string |
| line | address | 1..unbounded | – | – | string |
| city | address | 1..1 | – | – | string |
| district | address | 0..1 | Use this element to list the District name (aka county) | – | string |
| state | address | 1..1 | – | – | string |
| postal_code | address | 1..1 | – | – | string |
| country | address | 1..1 | Country (e.g. can be ISO 3166 2 or 3 letter code) | – | string |
| period | address | 0..1 | Time period when this address was/is in use. If the address is still in use, do not supply an End date. Format is YYYY-MM-DD. | – | period |
| use | addresses | 0..1 | The use of this address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-use.html | – | – |
| type | addresses | 0..1 | The type of address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-type.html | – | – |
| text | addresses | 1..1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) | – | string |
| line | addresses | 1..unbounded | – | – | string |
| city | addresses | 1..1 | – | – | string |
| district | addresses | 0..1 | Use this element to list the District name (aka county) | – | string |
| state | addresses | 1..1 | – | – | string |
| postal_code | addresses | 1..1 | – | – | string |
| country | addresses | 1..1 | Country (e.g. can be ISO 3166 2 or 3 letter code) | – | string |
| period | addresses | 0..1 | Time period when this address was/is in use. If the address is still in use, do not supply an End date. Format is YYYY-MM-DD. | – | period |
| address | member | 1..unbounded | Use this element to list all the addresses the member is associated with. It is recommended that at least one address be supplied for identification purposes. | – | – |
| use | address | 0..1 | The use of this address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-use.html | – | – |
| type | address | 0..1 | The type of address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-type.html | – | – |
| text | address | 1..1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) | – | string |
| line | address | 1..unbounded | – | – | string |
| city | address | 1..1 | – | – | string |
| district | address | 0..1 | Use this element to list the District name (aka county) | – | string |
| state | address | 1..1 | – | – | string |
| postal_code | address | 1..1 | – | – | string |
| country | address | 1..1 | Country (e.g. can be ISO 3166 2 or 3 letter code) | – | string |
| period | address | 0..1 | Time period when this address was/is in use. If the address is still in use, do not supply an End date. Format is YYYY-MM-DD. | – | period |
| use | member | 0..1 | The use of this address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-use.html | – | – |
| type | member | 0..1 | The type of address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-type.html | – | – |
| text | member | 1..1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) | – | string |
| line | member | 1..unbounded | – | – | string |
| city | member | 1..1 | – | – | string |
| district | member | 0..1 | Use this element to list the District name (aka county) | – | string |
| state | member | 1..1 | – | – | string |
| postal_code | member | 1..1 | – | – | string |
| country | member | 1..1 | Country (e.g. can be ISO 3166 2 or 3 letter code) | – | string |
| period | member | 0..1 | Time period when this address was/is in use. If the address is still in use, do not supply an End date. Format is YYYY-MM-DD. | – | period |
| health_coverage | member | 1..1 | – | – | – |
| group_number | health_coverage | 0..1 | – | – | string |
| policy_number | health_coverage | 0..1 | Each person covered by a health insurance plan has a unique ID number that allows healthcare providers and their staff to verify coverage and arrange payment for services. This is also known as member number and/or card-id and or member-id. | – | string |
| plan_id | health_coverage | 1..1 | The Identifier of the plan associated with the Plan Name | – | string |
| plan_name | health_coverage | 1..1 | – | – | string |
| coverage_status | health_coverage | 1..1 | Indicates the current status of coverage for the member. Must be one of: active, cancelled, draft, entered-in-error | – | string |
| coverage_type | health_coverage | 0..1 | – | – | – |
| codeable_concept | coverage_type | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| codeable_concept | health_coverage | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| coverage_period | health_coverage | 1..1 | Use this element to provide dates of coverage for this member. If the coverage is still active, do not provide an End date. Format is YYYY-MM-DD. | – | period |
| network_id | health_coverage | 0..1 | Network associated with the plan | – | string |
| payor | health_coverage | 0..1 | Payer Identifier-Issuer of the Policy | – | organization |
| group_number | member | 0..1 | – | – | string |
| policy_number | member | 0..1 | Each person covered by a health insurance plan has a unique ID number that allows healthcare providers and their staff to verify coverage and arrange payment for services. This is also known as member number and/or card-id and or member-id. | – | string |
| plan_id | member | 1..1 | The Identifier of the plan associated with the Plan Name | – | string |
| plan_name | member | 1..1 | – | – | string |
| coverage_status | member | 1..1 | Indicates the current status of coverage for the member. Must be one of: active, cancelled, draft, entered-in-error | – | string |
| coverage_type | member | 0..1 | – | – | – |
| codeable_concept | coverage_type | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| codeable_concept | member | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| coverage_period | member | 1..1 | Use this element to provide dates of coverage for this member. If the coverage is still active, do not provide an End date. Format is YYYY-MM-DD. | – | period |
| network_id | member | 0..1 | Network associated with the plan | – | string |
| payor | member | 0..1 | Payer Identifier-Issuer of the Policy | – | organization |
| communications | member | 0..1 | – | – | – |
| communication | communications | 1..unbounded | Use this element to provide the languages the member communicates in | – | – |
| language_code | communication | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| display | communication | 0..1 | Type the name of the language if not found here (http://hl7.org/fhir/R4/datatypes.html#CodeableConcept) | – | string |
| is_preferred | communication | 0..1 | Is this language the preferred language (true/false) | – | xs:boolean |
| language_code | communications | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| display | communications | 0..1 | Type the name of the language if not found here (http://hl7.org/fhir/R4/datatypes.html#CodeableConcept) | – | string |
| is_preferred | communications | 0..1 | Is this language the preferred language (true/false) | – | xs:boolean |
| communication | member | 1..unbounded | Use this element to provide the languages the member communicates in | – | – |
| language_code | communication | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| display | communication | 0..1 | Type the name of the language if not found here (http://hl7.org/fhir/R4/datatypes.html#CodeableConcept) | – | string |
| is_preferred | communication | 0..1 | Is this language the preferred language (true/false) | – | xs:boolean |
| language_code | member | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| display | member | 0..1 | Type the name of the language if not found here (http://hl7.org/fhir/R4/datatypes.html#CodeableConcept) | – | string |
| is_preferred | member | 0..1 | Is this language the preferred language (true/false) | – | xs:boolean |
| smoking_status | member | 0..1 | This element is for selecting the current smoking status of the member (449868002 = Current every day smoker, 428041000124106 = Current some day smoker, 8517006 = Former smoker, 266919005 = Never smoker, 77176002 = Smoker - current status unknown, 266927001 = Unknown if ever smoked, 428071000124103 = Current Heavy tobacco smoker, 428061000124105 = Current Light tobacco smoker). More information can be found here: http://hl7.org/fhir/us/core/ValueSet-us-core-observation-smokingstatus.html | – | – |
| record_type | member | 0..1 | This element describes the action for this member (A = Add, U = Update, D = Delete) | – | – |
| unique_record_identifier | member | 1..1 | – | – | string |
| delegates | member | 0..1 | – | – | – |
| delegate | delegates | 1..unbounded | – | – | – |
| family | delegate | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | delegate | 1..1 | Given names (not always 'first'). Includes middle names | – | string |
| telecoms | delegate | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | telecoms | 1..1 | – | – | – |
| value | telecoms | 1..1 | – | – | string |
| telecom | delegate | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | delegate | 1..1 | – | – | – |
| value | delegate | 1..1 | – | – | string |
| email_address | delegate | 1..1 | – | – | – |
| start | delegate | 0..1 | – | – | dateTime |
| end | delegate | 0..1 | – | – | dateTime |
| is_member | delegate | 1..1 | Fixed to false | – | – |
| family | delegates | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | delegates | 1..1 | Given names (not always 'first'). Includes middle names | – | string |
| telecoms | delegates | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | telecoms | 1..1 | – | – | – |
| value | telecoms | 1..1 | – | – | string |
| telecom | delegates | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | delegates | 1..1 | – | – | – |
| value | delegates | 1..1 | – | – | string |
| email_address | delegates | 1..1 | – | – | – |
| start | delegates | 0..1 | – | – | dateTime |
| end | delegates | 0..1 | – | – | dateTime |
| is_member | delegates | 1..1 | Fixed to false | – | – |
| delegate | member | 1..unbounded | – | – | – |
| family | delegate | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | delegate | 1..1 | Given names (not always 'first'). Includes middle names | – | string |
| telecoms | delegate | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | telecoms | 1..1 | – | – | – |
| value | telecoms | 1..1 | – | – | string |
| telecom | delegate | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | delegate | 1..1 | – | – | – |
| value | delegate | 1..1 | – | – | string |
| email_address | delegate | 1..1 | – | – | – |
| start | delegate | 0..1 | – | – | dateTime |
| end | delegate | 0..1 | – | – | dateTime |
| is_member | delegate | 1..1 | Fixed to false | – | – |
| family | member | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | member | 1..1 | Given names (not always 'first'). Includes middle names | – | string |
| telecoms | member | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | telecoms | 1..1 | – | – | – |
| value | telecoms | 1..1 | – | – | string |
| telecom | member | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | member | 1..1 | – | – | – |
| value | member | 1..1 | – | – | string |
| email_address | member | 1..1 | – | – | – |
| start | member | 0..1 | – | – | dateTime |
| end | member | 0..1 | – | – | dateTime |
| is_member | member | 1..1 | Fixed to false | – | – |
| us_core_race | roster | 0..1 | – | – | – |
| code | us_core_race | 0..5 | This element is for selecting 1 of the 5 OMB race category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html | – | – |
| detailed_code | us_core_race | 0..unbounded | This element is for selecting 1 of the additional expansion codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html | – | – |
| text | us_core_race | 1..1 | Use this element for adding a text description | – | string |
| code | roster | 0..5 | This element is for selecting 1 of the 5 OMB race category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html | – | – |
| detailed_code | roster | 0..unbounded | This element is for selecting 1 of the additional expansion codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html | – | – |
| text | roster | 1..1 | Use this element for adding a text description | – | string |
| us_core_ethnicity | roster | 0..1 | – | – | – |
| code | us_core_ethnicity | 0..1 | This element is for selecting 1 of the OMB ethnicity category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-omb-ethnicity-category.html | – | – |
| detailed_code | us_core_ethnicity | 0..unbounded | This element is for selecting 1 of the additional ethnicity codes from the CDC that can be found here: https://www.hl7.org/fhir/us/core/ValueSet-detailed-ethnicity.html | – | – |
| text | us_core_ethnicity | 1..1 | Use this element for adding a text description | – | string |
| code | roster | 0..1 | This element is for selecting 1 of the OMB ethnicity category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-omb-ethnicity-category.html | – | – |
| detailed_code | roster | 0..unbounded | This element is for selecting 1 of the additional ethnicity codes from the CDC that can be found here: https://www.hl7.org/fhir/us/core/ValueSet-detailed-ethnicity.html | – | – |
| text | roster | 1..1 | Use this element for adding a text description | – | string |
| us_core_birth_sex | roster | 0..1 | This element is used for selecting birth sex (M = Male, F = Female, UNK = Unknown) | – | – |
| is_subscriber | roster | 1..1 | This element is used to identify if this person is the subscriber (True / False). (e.g. The main policy holder of the plan) | – | xs:boolean |
| relationship | roster | 1..1 | Relationship to the Subscriber. The full list can be found here: http://hl7.org/fhir/R4/valueset-subscriber-relationship.html | – | – |
| birth_date | roster | 1..1 | Birth date (1900-01-01) | – | date |
| deceased_date_time | roster | 0..1 | DateTime of death (2001-10-26T21:32:52+02:00) | – | dateTime |
| gender | roster | 1..1 | Use this element for Sex/Administrative Gender (male, female, other or unknown) | – | – |
| tribal_affiliations | roster | 0..1 | – | – | – |
| tribal_affiliation | tribal_affiliations | 1..unbounded | – | – | – |
| codeable_concept | tribal_affiliation | 1..1 | – | – | codeableConcept |
| is_enrolled | tribal_affiliation | 1..1 | – | – | xs:boolean |
| codeable_concept | tribal_affiliations | 1..1 | – | – | codeableConcept |
| is_enrolled | tribal_affiliations | 1..1 | – | – | xs:boolean |
| tribal_affiliation | roster | 1..unbounded | – | – | – |
| codeable_concept | tribal_affiliation | 1..1 | – | – | codeableConcept |
| is_enrolled | tribal_affiliation | 1..1 | – | – | xs:boolean |
| codeable_concept | roster | 1..1 | – | – | codeableConcept |
| is_enrolled | roster | 1..1 | – | – | xs:boolean |
| sexual_orientations | roster | 0..1 | – | – | – |
| sexual_orientation | sexual_orientations | 1..unbounded | – | – | – |
| codeable_concept | sexual_orientation | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | sexual_orientation | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| codeable_concept | sexual_orientations | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | sexual_orientations | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| sexual_orientation | roster | 1..unbounded | – | – | – |
| codeable_concept | sexual_orientation | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | sexual_orientation | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| codeable_concept | roster | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | roster | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| gender_identities | roster | 0..1 | – | – | – |
| gender_identity | gender_identities | 1..unbounded | – | – | – |
| codeable_concept | gender_identity | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | gender_identity | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| codeable_concept | gender_identities | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | gender_identities | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| gender_identity | roster | 1..unbounded | – | – | – |
| codeable_concept | gender_identity | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | gender_identity | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| codeable_concept | roster | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | roster | 1..1 | MUST be one of: registered | preliminary | final | amended | – | – |
| relatedPersons | roster | 0..1 | – | – | – |
| relatedPerson | relatedPersons | 1..unbounded | – | – | – |
| active | relatedPerson | 1..1 | – | – | xs:boolean |
| names | relatedPerson | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| prefix | name | 0..1 | – | – | xs:string |
| period | name | 0..1 | – | – | period |
| use | names | 1..1 | – | – | xs:string |
| text | names | 1..1 | – | – | xs:string |
| family | names | 1..1 | – | – | xs:string |
| given | names | 1..unbounded | – | – | xs:string |
| prefix | names | 0..1 | – | – | xs:string |
| period | names | 0..1 | – | – | period |
| name | relatedPerson | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| prefix | name | 0..1 | – | – | xs:string |
| period | name | 0..1 | – | – | period |
| use | relatedPerson | 1..1 | – | – | xs:string |
| text | relatedPerson | 1..1 | – | – | xs:string |
| family | relatedPerson | 1..1 | – | – | xs:string |
| given | relatedPerson | 1..unbounded | – | – | xs:string |
| prefix | relatedPerson | 0..1 | – | – | xs:string |
| period | relatedPerson | 0..1 | – | – | period |
| telecoms | relatedPerson | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| rank | telecom | 0..1 | – | – | xs:integer |
| period | telecom | 0..1 | – | – | period_date |
| system | telecoms | 1..1 | – | – | xs:string |
| value | telecoms | 1..1 | – | – | xs:string |
| use | telecoms | 1..1 | – | – | xs:string |
| rank | telecoms | 0..1 | – | – | xs:integer |
| period | telecoms | 0..1 | – | – | period_date |
| telecom | relatedPerson | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| rank | telecom | 0..1 | – | – | xs:integer |
| period | telecom | 0..1 | – | – | period_date |
| system | relatedPerson | 1..1 | – | – | xs:string |
| value | relatedPerson | 1..1 | – | – | xs:string |
| use | relatedPerson | 1..1 | – | – | xs:string |
| rank | relatedPerson | 0..1 | – | – | xs:integer |
| period | relatedPerson | 0..1 | – | – | period_date |
| gender | relatedPerson | 1..1 | – | – | xs:string |
| birth_date | relatedPerson | 1..1 | – | – | xs:date |
| addresses | relatedPerson | 1..1 | – | – | – |
| address | addresses | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| district | address | 0..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| period | address | 0..1 | – | – | period_date |
| use | addresses | 1..1 | – | – | xs:string |
| type | addresses | 1..1 | – | – | xs:string |
| text | addresses | 1..1 | – | – | xs:string |
| line | addresses | 1..unbounded | – | – | xs:string |
| city | addresses | 1..1 | – | – | xs:string |
| district | addresses | 0..1 | – | – | xs:string |
| state | addresses | 1..1 | – | – | xs:string |
| postal_code | addresses | 1..1 | – | – | xs:string |
| country | addresses | 1..1 | – | – | xs:string |
| period | addresses | 0..1 | – | – | period_date |
| address | relatedPerson | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| district | address | 0..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| period | address | 0..1 | – | – | period_date |
| use | relatedPerson | 1..1 | – | – | xs:string |
| type | relatedPerson | 1..1 | – | – | xs:string |
| text | relatedPerson | 1..1 | – | – | xs:string |
| line | relatedPerson | 1..unbounded | – | – | xs:string |
| city | relatedPerson | 1..1 | – | – | xs:string |
| district | relatedPerson | 0..1 | – | – | xs:string |
| state | relatedPerson | 1..1 | – | – | xs:string |
| postal_code | relatedPerson | 1..1 | – | – | xs:string |
| country | relatedPerson | 1..1 | – | – | xs:string |
| period | relatedPerson | 0..1 | – | – | period_date |
| communication_language | relatedPerson | 1..1 | – | – | xs:string |
| relationship | relatedPerson | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| codeable_concept | relatedPerson | 1..1 | – | – | codeableConcept |
| active | relatedPersons | 1..1 | – | – | xs:boolean |
| names | relatedPersons | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| prefix | name | 0..1 | – | – | xs:string |
| period | name | 0..1 | – | – | period |
| use | names | 1..1 | – | – | xs:string |
| text | names | 1..1 | – | – | xs:string |
| family | names | 1..1 | – | – | xs:string |
| given | names | 1..unbounded | – | – | xs:string |
| prefix | names | 0..1 | – | – | xs:string |
| period | names | 0..1 | – | – | period |
| name | relatedPersons | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| prefix | name | 0..1 | – | – | xs:string |
| period | name | 0..1 | – | – | period |
| use | relatedPersons | 1..1 | – | – | xs:string |
| text | relatedPersons | 1..1 | – | – | xs:string |
| family | relatedPersons | 1..1 | – | – | xs:string |
| given | relatedPersons | 1..unbounded | – | – | xs:string |
| prefix | relatedPersons | 0..1 | – | – | xs:string |
| period | relatedPersons | 0..1 | – | – | period |
| telecoms | relatedPersons | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| rank | telecom | 0..1 | – | – | xs:integer |
| period | telecom | 0..1 | – | – | period_date |
| system | telecoms | 1..1 | – | – | xs:string |
| value | telecoms | 1..1 | – | – | xs:string |
| use | telecoms | 1..1 | – | – | xs:string |
| rank | telecoms | 0..1 | – | – | xs:integer |
| period | telecoms | 0..1 | – | – | period_date |
| telecom | relatedPersons | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| rank | telecom | 0..1 | – | – | xs:integer |
| period | telecom | 0..1 | – | – | period_date |
| system | relatedPersons | 1..1 | – | – | xs:string |
| value | relatedPersons | 1..1 | – | – | xs:string |
| use | relatedPersons | 1..1 | – | – | xs:string |
| rank | relatedPersons | 0..1 | – | – | xs:integer |
| period | relatedPersons | 0..1 | – | – | period_date |
| gender | relatedPersons | 1..1 | – | – | xs:string |
| birth_date | relatedPersons | 1..1 | – | – | xs:date |
| addresses | relatedPersons | 1..1 | – | – | – |
| address | addresses | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| district | address | 0..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| period | address | 0..1 | – | – | period_date |
| use | addresses | 1..1 | – | – | xs:string |
| type | addresses | 1..1 | – | – | xs:string |
| text | addresses | 1..1 | – | – | xs:string |
| line | addresses | 1..unbounded | – | – | xs:string |
| city | addresses | 1..1 | – | – | xs:string |
| district | addresses | 0..1 | – | – | xs:string |
| state | addresses | 1..1 | – | – | xs:string |
| postal_code | addresses | 1..1 | – | – | xs:string |
| country | addresses | 1..1 | – | – | xs:string |
| period | addresses | 0..1 | – | – | period_date |
| address | relatedPersons | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| district | address | 0..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| period | address | 0..1 | – | – | period_date |
| use | relatedPersons | 1..1 | – | – | xs:string |
| type | relatedPersons | 1..1 | – | – | xs:string |
| text | relatedPersons | 1..1 | – | – | xs:string |
| line | relatedPersons | 1..unbounded | – | – | xs:string |
| city | relatedPersons | 1..1 | – | – | xs:string |
| district | relatedPersons | 0..1 | – | – | xs:string |
| state | relatedPersons | 1..1 | – | – | xs:string |
| postal_code | relatedPersons | 1..1 | – | – | xs:string |
| country | relatedPersons | 1..1 | – | – | xs:string |
| period | relatedPersons | 0..1 | – | – | period_date |
| communication_language | relatedPersons | 1..1 | – | – | xs:string |
| relationship | relatedPersons | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| codeable_concept | relatedPersons | 1..1 | – | – | codeableConcept |
| relatedPerson | roster | 1..unbounded | – | – | – |
| active | relatedPerson | 1..1 | – | – | xs:boolean |
| names | relatedPerson | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| prefix | name | 0..1 | – | – | xs:string |
| period | name | 0..1 | – | – | period |
| use | names | 1..1 | – | – | xs:string |
| text | names | 1..1 | – | – | xs:string |
| family | names | 1..1 | – | – | xs:string |
| given | names | 1..unbounded | – | – | xs:string |
| prefix | names | 0..1 | – | – | xs:string |
| period | names | 0..1 | – | – | period |
| name | relatedPerson | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| prefix | name | 0..1 | – | – | xs:string |
| period | name | 0..1 | – | – | period |
| use | relatedPerson | 1..1 | – | – | xs:string |
| text | relatedPerson | 1..1 | – | – | xs:string |
| family | relatedPerson | 1..1 | – | – | xs:string |
| given | relatedPerson | 1..unbounded | – | – | xs:string |
| prefix | relatedPerson | 0..1 | – | – | xs:string |
| period | relatedPerson | 0..1 | – | – | period |
| telecoms | relatedPerson | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| rank | telecom | 0..1 | – | – | xs:integer |
| period | telecom | 0..1 | – | – | period_date |
| system | telecoms | 1..1 | – | – | xs:string |
| value | telecoms | 1..1 | – | – | xs:string |
| use | telecoms | 1..1 | – | – | xs:string |
| rank | telecoms | 0..1 | – | – | xs:integer |
| period | telecoms | 0..1 | – | – | period_date |
| telecom | relatedPerson | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| rank | telecom | 0..1 | – | – | xs:integer |
| period | telecom | 0..1 | – | – | period_date |
| system | relatedPerson | 1..1 | – | – | xs:string |
| value | relatedPerson | 1..1 | – | – | xs:string |
| use | relatedPerson | 1..1 | – | – | xs:string |
| rank | relatedPerson | 0..1 | – | – | xs:integer |
| period | relatedPerson | 0..1 | – | – | period_date |
| gender | relatedPerson | 1..1 | – | – | xs:string |
| birth_date | relatedPerson | 1..1 | – | – | xs:date |
| addresses | relatedPerson | 1..1 | – | – | – |
| address | addresses | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| district | address | 0..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| period | address | 0..1 | – | – | period_date |
| use | addresses | 1..1 | – | – | xs:string |
| type | addresses | 1..1 | – | – | xs:string |
| text | addresses | 1..1 | – | – | xs:string |
| line | addresses | 1..unbounded | – | – | xs:string |
| city | addresses | 1..1 | – | – | xs:string |
| district | addresses | 0..1 | – | – | xs:string |
| state | addresses | 1..1 | – | – | xs:string |
| postal_code | addresses | 1..1 | – | – | xs:string |
| country | addresses | 1..1 | – | – | xs:string |
| period | addresses | 0..1 | – | – | period_date |
| address | relatedPerson | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| district | address | 0..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| period | address | 0..1 | – | – | period_date |
| use | relatedPerson | 1..1 | – | – | xs:string |
| type | relatedPerson | 1..1 | – | – | xs:string |
| text | relatedPerson | 1..1 | – | – | xs:string |
| line | relatedPerson | 1..unbounded | – | – | xs:string |
| city | relatedPerson | 1..1 | – | – | xs:string |
| district | relatedPerson | 0..1 | – | – | xs:string |
| state | relatedPerson | 1..1 | – | – | xs:string |
| postal_code | relatedPerson | 1..1 | – | – | xs:string |
| country | relatedPerson | 1..1 | – | – | xs:string |
| period | relatedPerson | 0..1 | – | – | period_date |
| communication_language | relatedPerson | 1..1 | – | – | xs:string |
| relationship | relatedPerson | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| codeable_concept | relatedPerson | 1..1 | – | – | codeableConcept |
| active | roster | 1..1 | – | – | xs:boolean |
| names | roster | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| prefix | name | 0..1 | – | – | xs:string |
| period | name | 0..1 | – | – | period |
| use | names | 1..1 | – | – | xs:string |
| text | names | 1..1 | – | – | xs:string |
| family | names | 1..1 | – | – | xs:string |
| given | names | 1..unbounded | – | – | xs:string |
| prefix | names | 0..1 | – | – | xs:string |
| period | names | 0..1 | – | – | period |
| name | roster | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| prefix | name | 0..1 | – | – | xs:string |
| period | name | 0..1 | – | – | period |
| use | roster | 1..1 | – | – | xs:string |
| text | roster | 1..1 | – | – | xs:string |
| family | roster | 1..1 | – | – | xs:string |
| given | roster | 1..unbounded | – | – | xs:string |
| prefix | roster | 0..1 | – | – | xs:string |
| period | roster | 0..1 | – | – | period |
| telecoms | roster | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| rank | telecom | 0..1 | – | – | xs:integer |
| period | telecom | 0..1 | – | – | period_date |
| system | telecoms | 1..1 | – | – | xs:string |
| value | telecoms | 1..1 | – | – | xs:string |
| use | telecoms | 1..1 | – | – | xs:string |
| rank | telecoms | 0..1 | – | – | xs:integer |
| period | telecoms | 0..1 | – | – | period_date |
| telecom | roster | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| rank | telecom | 0..1 | – | – | xs:integer |
| period | telecom | 0..1 | – | – | period_date |
| system | roster | 1..1 | – | – | xs:string |
| value | roster | 1..1 | – | – | xs:string |
| use | roster | 1..1 | – | – | xs:string |
| rank | roster | 0..1 | – | – | xs:integer |
| period | roster | 0..1 | – | – | period_date |
| gender | roster | 1..1 | – | – | xs:string |
| birth_date | roster | 1..1 | – | – | xs:date |
| addresses | roster | 1..1 | – | – | – |
| address | addresses | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| district | address | 0..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| period | address | 0..1 | – | – | period_date |
| use | addresses | 1..1 | – | – | xs:string |
| type | addresses | 1..1 | – | – | xs:string |
| text | addresses | 1..1 | – | – | xs:string |
| line | addresses | 1..unbounded | – | – | xs:string |
| city | addresses | 1..1 | – | – | xs:string |
| district | addresses | 0..1 | – | – | xs:string |
| state | addresses | 1..1 | – | – | xs:string |
| postal_code | addresses | 1..1 | – | – | xs:string |
| country | addresses | 1..1 | – | – | xs:string |
| period | addresses | 0..1 | – | – | period_date |
| address | roster | 1..unbounded | – | – | – |
| use | address | 1..1 | – | – | xs:string |
| type | address | 1..1 | – | – | xs:string |
| text | address | 1..1 | – | – | xs:string |
| line | address | 1..unbounded | – | – | xs:string |
| city | address | 1..1 | – | – | xs:string |
| district | address | 0..1 | – | – | xs:string |
| state | address | 1..1 | – | – | xs:string |
| postal_code | address | 1..1 | – | – | xs:string |
| country | address | 1..1 | – | – | xs:string |
| period | address | 0..1 | – | – | period_date |
| use | roster | 1..1 | – | – | xs:string |
| type | roster | 1..1 | – | – | xs:string |
| text | roster | 1..1 | – | – | xs:string |
| line | roster | 1..unbounded | – | – | xs:string |
| city | roster | 1..1 | – | – | xs:string |
| district | roster | 0..1 | – | – | xs:string |
| state | roster | 1..1 | – | – | xs:string |
| postal_code | roster | 1..1 | – | – | xs:string |
| country | roster | 1..1 | – | – | xs:string |
| period | roster | 0..1 | – | – | period_date |
| communication_language | roster | 1..1 | – | – | xs:string |
| relationship | roster | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| codeable_concept | roster | 1..1 | – | – | codeableConcept |
| occupations | roster | 0..1 | – | – | – |
| occupation_item | occupations | 1..unbounded | – | – | – |
| status | occupation_item | 1..1 | – | – | – |
| effectivePeriod | occupation_item | 0..1 | – | – | period_date |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| industry | occupation_item | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| status | occupations | 1..1 | – | – | – |
| effectivePeriod | occupations | 0..1 | – | – | period_date |
| codeable_concept | occupations | 1..1 | – | – | codeableConcept |
| industry | occupations | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| codeable_concept | occupations | 1..1 | – | – | codeableConcept |
| occupation_item | roster | 1..unbounded | – | – | – |
| status | occupation_item | 1..1 | – | – | – |
| effectivePeriod | occupation_item | 0..1 | – | – | period_date |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| industry | occupation_item | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| status | roster | 1..1 | – | – | – |
| effectivePeriod | roster | 0..1 | – | – | period_date |
| codeable_concept | roster | 1..1 | – | – | codeableConcept |
| industry | roster | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| codeable_concept | roster | 1..1 | – | – | codeableConcept |
| unique_person_ids | roster | 1..1 | – | – | – |
| unique_person_id | unique_person_ids | 1..1 | This is the person's unique member number in the Payer system across plans. This number is not reused for anyone else. | – | string |
| unique_person_id_assigner | unique_person_ids | 1..1 | Organization that issued id | – | – |
| unique_person_id_assigner_type | unique_person_ids | 0..1 | Type of organization that issued id | – | string |
| unique_person_id | roster | 1..1 | This is the person's unique member number in the Payer system across plans. This number is not reused for anyone else. | – | string |
| unique_person_id_assigner | roster | 1..1 | Organization that issued id | – | – |
| unique_person_id_assigner_type | roster | 0..1 | Type of organization that issued id | – | string |
| member_identity | roster | 0..1 | – | – | – |
| member_last_4_ssn | member_identity | 0..1 | Use this element for last 4 digit of member SSN (0000) | – | – |
| secret_display_name | member_identity | 0..1 | Use this element for the secret display name when SSN is not available | – | string |
| secret_value | member_identity | 0..1 | Use this element for the secret value when SSN is not available | – | string |
| secret_length | member_identity | 0..1 | Use this element for the secret length when SSN is not available | – | unsignedInt |
| member_last_4_ssn | roster | 0..1 | Use this element for last 4 digit of member SSN (0000) | – | – |
| secret_display_name | roster | 0..1 | Use this element for the secret display name when SSN is not available | – | string |
| secret_value | roster | 0..1 | Use this element for the secret value when SSN is not available | – | string |
| secret_length | roster | 0..1 | Use this element for the secret length when SSN is not available | – | unsignedInt |
| member_id | roster | 1..1 | Use this element to list the Member Number. | – | string |
| member_id_system | roster | 0..1 | Use this element to identify the UM system that issues the Member Identifier. This is NOT the organization that assigns the identifier. | – | string |
| subscriber_id | roster | 1..1 | Use this element to list the Subscriber Number. An identifier for a subscriber of an insurance policy which is unique for, and usually assigned by, the insurance carrier. Use Case: A person is the subscriber of an insurance policy. The person’s family may be plan members, but are not the subscriber. | – | string |
| names | roster | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 0..1 | Use this element to describe the name. More information can be found here: http://hl7.org/fhir/R4/valueset-name-use.html | – | – |
| text | name | 1..1 | Use this element to enter the entire name of the member | – | string |
| family | name | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | name | 1..unbounded | Given names (not always 'first'). Includes middle names | – | string |
| prefix | name | 0..1 | – | – | string |
| suffix | name | 0..1 | – | – | string |
| period | name | 0..1 | Time period when name was/is in use. If the name is still in use, do not supply an End date | – | period |
| use | names | 0..1 | Use this element to describe the name. More information can be found here: http://hl7.org/fhir/R4/valueset-name-use.html | – | – |
| text | names | 1..1 | Use this element to enter the entire name of the member | – | string |
| family | names | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | names | 1..unbounded | Given names (not always 'first'). Includes middle names | – | string |
| prefix | names | 0..1 | – | – | string |
| suffix | names | 0..1 | – | – | string |
| period | names | 0..1 | Time period when name was/is in use. If the name is still in use, do not supply an End date | – | period |
| name | roster | 1..unbounded | – | – | – |
| use | name | 0..1 | Use this element to describe the name. More information can be found here: http://hl7.org/fhir/R4/valueset-name-use.html | – | – |
| text | name | 1..1 | Use this element to enter the entire name of the member | – | string |
| family | name | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | name | 1..unbounded | Given names (not always 'first'). Includes middle names | – | string |
| prefix | name | 0..1 | – | – | string |
| suffix | name | 0..1 | – | – | string |
| period | name | 0..1 | Time period when name was/is in use. If the name is still in use, do not supply an End date | – | period |
| use | roster | 0..1 | Use this element to describe the name. More information can be found here: http://hl7.org/fhir/R4/valueset-name-use.html | – | – |
| text | roster | 1..1 | Use this element to enter the entire name of the member | – | string |
| family | roster | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | roster | 1..unbounded | Given names (not always 'first'). Includes middle names | – | string |
| prefix | roster | 0..1 | – | – | string |
| suffix | roster | 0..1 | – | – | string |
| period | roster | 0..1 | Time period when name was/is in use. If the name is still in use, do not supply an End date | – | period |
| telecoms | roster | 0..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. Please provide at least one form of contact (e.g. phone, email, etc.) | – | – |
| system | telecom | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | telecom | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| use | telecom | 0..1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html | – | – |
| rank | telecom | 0..1 | Specify preferred order of use (1 = highest) | – | positiveInt |
| period | telecom | 0..1 | Time period when the contact point was/is in use | – | period |
| system | telecoms | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | telecoms | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| use | telecoms | 0..1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html | – | – |
| rank | telecoms | 0..1 | Specify preferred order of use (1 = highest) | – | positiveInt |
| period | telecoms | 0..1 | Time period when the contact point was/is in use | – | period |
| telecom | roster | 1..unbounded | Contact points of telecommunications. Please provide at least one form of contact (e.g. phone, email, etc.) | – | – |
| system | telecom | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | telecom | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| use | telecom | 0..1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html | – | – |
| rank | telecom | 0..1 | Specify preferred order of use (1 = highest) | – | positiveInt |
| period | telecom | 0..1 | Time period when the contact point was/is in use | – | period |
| system | roster | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | roster | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| use | roster | 0..1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html | – | – |
| rank | roster | 0..1 | Specify preferred order of use (1 = highest) | – | positiveInt |
| period | roster | 0..1 | Time period when the contact point was/is in use | – | period |
| addresses | roster | 0..1 | – | – | – |
| address | addresses | 1..unbounded | Use this element to list all the addresses the member is associated with. It is recommended that at least one address be supplied for identification purposes. | – | – |
| use | address | 0..1 | The use of this address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-use.html | – | – |
| type | address | 0..1 | The type of address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-type.html | – | – |
| text | address | 1..1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) | – | string |
| line | address | 1..unbounded | – | – | string |
| city | address | 1..1 | – | – | string |
| district | address | 0..1 | Use this element to list the District name (aka county) | – | string |
| state | address | 1..1 | – | – | string |
| postal_code | address | 1..1 | – | – | string |
| country | address | 1..1 | Country (e.g. can be ISO 3166 2 or 3 letter code) | – | string |
| period | address | 0..1 | Time period when this address was/is in use. If the address is still in use, do not supply an End date. Format is YYYY-MM-DD. | – | period |
| use | addresses | 0..1 | The use of this address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-use.html | – | – |
| type | addresses | 0..1 | The type of address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-type.html | – | – |
| text | addresses | 1..1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) | – | string |
| line | addresses | 1..unbounded | – | – | string |
| city | addresses | 1..1 | – | – | string |
| district | addresses | 0..1 | Use this element to list the District name (aka county) | – | string |
| state | addresses | 1..1 | – | – | string |
| postal_code | addresses | 1..1 | – | – | string |
| country | addresses | 1..1 | Country (e.g. can be ISO 3166 2 or 3 letter code) | – | string |
| period | addresses | 0..1 | Time period when this address was/is in use. If the address is still in use, do not supply an End date. Format is YYYY-MM-DD. | – | period |
| address | roster | 1..unbounded | Use this element to list all the addresses the member is associated with. It is recommended that at least one address be supplied for identification purposes. | – | – |
| use | address | 0..1 | The use of this address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-use.html | – | – |
| type | address | 0..1 | The type of address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-type.html | – | – |
| text | address | 1..1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) | – | string |
| line | address | 1..unbounded | – | – | string |
| city | address | 1..1 | – | – | string |
| district | address | 0..1 | Use this element to list the District name (aka county) | – | string |
| state | address | 1..1 | – | – | string |
| postal_code | address | 1..1 | – | – | string |
| country | address | 1..1 | Country (e.g. can be ISO 3166 2 or 3 letter code) | – | string |
| period | address | 0..1 | Time period when this address was/is in use. If the address is still in use, do not supply an End date. Format is YYYY-MM-DD. | – | period |
| use | roster | 0..1 | The use of this address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-use.html | – | – |
| type | roster | 0..1 | The type of address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-type.html | – | – |
| text | roster | 1..1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) | – | string |
| line | roster | 1..unbounded | – | – | string |
| city | roster | 1..1 | – | – | string |
| district | roster | 0..1 | Use this element to list the District name (aka county) | – | string |
| state | roster | 1..1 | – | – | string |
| postal_code | roster | 1..1 | – | – | string |
| country | roster | 1..1 | Country (e.g. can be ISO 3166 2 or 3 letter code) | – | string |
| period | roster | 0..1 | Time period when this address was/is in use. If the address is still in use, do not supply an End date. Format is YYYY-MM-DD. | – | period |
| health_coverage | roster | 1..1 | – | – | – |
| group_number | health_coverage | 0..1 | – | – | string |
| policy_number | health_coverage | 0..1 | Each person covered by a health insurance plan has a unique ID number that allows healthcare providers and their staff to verify coverage and arrange payment for services. This is also known as member number and/or card-id and or member-id. | – | string |
| plan_id | health_coverage | 1..1 | The Identifier of the plan associated with the Plan Name | – | string |
| plan_name | health_coverage | 1..1 | – | – | string |
| coverage_status | health_coverage | 1..1 | Indicates the current status of coverage for the member. Must be one of: active, cancelled, draft, entered-in-error | – | string |
| coverage_type | health_coverage | 0..1 | – | – | – |
| codeable_concept | coverage_type | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| codeable_concept | health_coverage | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| coverage_period | health_coverage | 1..1 | Use this element to provide dates of coverage for this member. If the coverage is still active, do not provide an End date. Format is YYYY-MM-DD. | – | period |
| network_id | health_coverage | 0..1 | Network associated with the plan | – | string |
| payor | health_coverage | 0..1 | Payer Identifier-Issuer of the Policy | – | organization |
| group_number | roster | 0..1 | – | – | string |
| policy_number | roster | 0..1 | Each person covered by a health insurance plan has a unique ID number that allows healthcare providers and their staff to verify coverage and arrange payment for services. This is also known as member number and/or card-id and or member-id. | – | string |
| plan_id | roster | 1..1 | The Identifier of the plan associated with the Plan Name | – | string |
| plan_name | roster | 1..1 | – | – | string |
| coverage_status | roster | 1..1 | Indicates the current status of coverage for the member. Must be one of: active, cancelled, draft, entered-in-error | – | string |
| coverage_type | roster | 0..1 | – | – | – |
| codeable_concept | coverage_type | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| codeable_concept | roster | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| coverage_period | roster | 1..1 | Use this element to provide dates of coverage for this member. If the coverage is still active, do not provide an End date. Format is YYYY-MM-DD. | – | period |
| network_id | roster | 0..1 | Network associated with the plan | – | string |
| payor | roster | 0..1 | Payer Identifier-Issuer of the Policy | – | organization |
| communications | roster | 0..1 | – | – | – |
| communication | communications | 1..unbounded | Use this element to provide the languages the member communicates in | – | – |
| language_code | communication | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| display | communication | 0..1 | Type the name of the language if not found here (http://hl7.org/fhir/R4/datatypes.html#CodeableConcept) | – | string |
| is_preferred | communication | 0..1 | Is this language the preferred language (true/false) | – | xs:boolean |
| language_code | communications | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| display | communications | 0..1 | Type the name of the language if not found here (http://hl7.org/fhir/R4/datatypes.html#CodeableConcept) | – | string |
| is_preferred | communications | 0..1 | Is this language the preferred language (true/false) | – | xs:boolean |
| communication | roster | 1..unbounded | Use this element to provide the languages the member communicates in | – | – |
| language_code | communication | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| display | communication | 0..1 | Type the name of the language if not found here (http://hl7.org/fhir/R4/datatypes.html#CodeableConcept) | – | string |
| is_preferred | communication | 0..1 | Is this language the preferred language (true/false) | – | xs:boolean |
| language_code | roster | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| display | roster | 0..1 | Type the name of the language if not found here (http://hl7.org/fhir/R4/datatypes.html#CodeableConcept) | – | string |
| is_preferred | roster | 0..1 | Is this language the preferred language (true/false) | – | xs:boolean |
| smoking_status | roster | 0..1 | This element is for selecting the current smoking status of the member (449868002 = Current every day smoker, 428041000124106 = Current some day smoker, 8517006 = Former smoker, 266919005 = Never smoker, 77176002 = Smoker - current status unknown, 266927001 = Unknown if ever smoked, 428071000124103 = Current Heavy tobacco smoker, 428061000124105 = Current Light tobacco smoker). More information can be found here: http://hl7.org/fhir/us/core/ValueSet-us-core-observation-smokingstatus.html | – | – |
| record_type | roster | 0..1 | This element describes the action for this member (A = Add, U = Update, D = Delete) | – | – |
| unique_record_identifier | roster | 1..1 | – | – | string |
| delegates | roster | 0..1 | – | – | – |
| delegate | delegates | 1..unbounded | – | – | – |
| family | delegate | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | delegate | 1..1 | Given names (not always 'first'). Includes middle names | – | string |
| telecoms | delegate | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | telecoms | 1..1 | – | – | – |
| value | telecoms | 1..1 | – | – | string |
| telecom | delegate | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | delegate | 1..1 | – | – | – |
| value | delegate | 1..1 | – | – | string |
| email_address | delegate | 1..1 | – | – | – |
| start | delegate | 0..1 | – | – | dateTime |
| end | delegate | 0..1 | – | – | dateTime |
| is_member | delegate | 1..1 | Fixed to false | – | – |
| family | delegates | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | delegates | 1..1 | Given names (not always 'first'). Includes middle names | – | string |
| telecoms | delegates | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | telecoms | 1..1 | – | – | – |
| value | telecoms | 1..1 | – | – | string |
| telecom | delegates | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | delegates | 1..1 | – | – | – |
| value | delegates | 1..1 | – | – | string |
| email_address | delegates | 1..1 | – | – | – |
| start | delegates | 0..1 | – | – | dateTime |
| end | delegates | 0..1 | – | – | dateTime |
| is_member | delegates | 1..1 | Fixed to false | – | – |
| delegate | roster | 1..unbounded | – | – | – |
| family | delegate | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | delegate | 1..1 | Given names (not always 'first'). Includes middle names | – | string |
| telecoms | delegate | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | telecoms | 1..1 | – | – | – |
| value | telecoms | 1..1 | – | – | string |
| telecom | delegate | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | delegate | 1..1 | – | – | – |
| value | delegate | 1..1 | – | – | string |
| email_address | delegate | 1..1 | – | – | – |
| start | delegate | 0..1 | – | – | dateTime |
| end | delegate | 0..1 | – | – | dateTime |
| is_member | delegate | 1..1 | Fixed to false | – | – |
| family | roster | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | roster | 1..1 | Given names (not always 'first'). Includes middle names | – | string |
| telecoms | roster | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | telecoms | 1..1 | – | – | – |
| value | telecoms | 1..1 | – | – | string |
| telecom | roster | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| system | roster | 1..1 | – | – | – |
| value | roster | 1..1 | – | – | string |
| email_address | roster | 1..1 | – | – | – |
| start | roster | 0..1 | – | – | dateTime |
| end | roster | 0..1 | – | – | dateTime |
| is_member | roster | 1..1 | Fixed to false | – | – |


## Practical Guidance

### Submission Frequency

Roster files should be submitted according to the schedule agreed upon with HealthLX. Typical submission frequencies include daily, weekly, or monthly updates.

### Adds, Updates, and Deletes

- **Adds**: Include new member records with all required fields populated
- **Updates**: Submit complete member records with updated information
- **Deletes**: Follow the agreed-upon process for member terminations or removals

### Member Identification

Each member must be uniquely identified using the appropriate identifier fields. Ensure consistency in member identifiers across all submissions to maintain data integrity.

