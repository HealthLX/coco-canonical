![HLX Logo](../assets/hlx_logo.png)

# Clinical Implementation Guide

**HLX0123 HLX Clinical IG (XSD_V10.0)**

**Version 10.0**

**December 26, 2025**

**Table of Contents**

1. [Overview](#overview)
2. [Encoding](#encoding)
3. [Interoperability](#interoperability)
4. [Change Log](#change-log)
5. [Simple Types](#simple-types)
6. [Core Model Types](#core-model-types)
7. [Complex Types](#complex-types)
8. [Required Elements of Clinical XSD](#required-elements-of-clinical-xsd)
9. [All Elements of Clinical XSD](#all-elements-of-clinical-xsd)
10. [Practical Guidance](#practical-guidance)

## Disclaimer

This document is provided by HealthLX for informational purposes only. Information within this document is believed to be correct as of the noted date of publication. Although HealthLX makes every reasonable effort to present information in a timely and accurate manner, HealthLX does not warrant this information for accuracy, completeness or fitness for any purpose, express or implied. The information provided herein does not constitute the rendering of legal, financial or other professional advice or recommendations by HealthLX.

## Overview

This implementation guide provides field mappings and requirements for HealthLX Clinical data submissions in XML format based on FHIR R4 standards. XML format enables structured data exchange with built-in validation against the provided XSD schema.

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
| 10.0 | December 26, 2025 |

## Simple Types

| Name | Base Type | Description | Pattern |
| --- | --- | --- | --- |
| integer | xs:integer | – | [0]\|[-+]?[1-9][0-9]* |
| time | xs:time | – | ([01][0-9]\|2[0-3]):[0-5][0-9]:[0-5][0-9](\.\d{1,9})? |
| dateTime | xs:string | – | ([12]\d{3})-(0[1-9]\|1[0-2])-(0[1-9]\|[1-2][0-9]\|3[0-1])(T([01][0-9]\|2[0-3]):[0-5][0-9]:[0-5][0-9](\.\d{1,6})?((Z\|(\+\|-)((0[0-9]\|1[0-3]):(00\|15\|30\|45)\|14:00))?))? |
| base64Binary | xs:base64Binary | – |  |
| instant | xs:dateTime | – | ([0-9]([0-9]([0-9][1-9]\|[1-9]0)\|[1-9]00)\|[1-9]000)-(0[1-9]\|1[0-2])-(0[1-9]\|[1-2][0-9]\|3[0-1])T([01][0-9]\|2[0-3]):[0-5][0-9]:([0-5][0-9]\|60)(\.[0-9]+)?(Z\|(\+\|-)((0[0-9]\|1[0-3]):[0-5][0-9]\|14:00)) |
| code | xs:string | – | [^\s]+(\s[^\s]+)* |
| id | xs:string | – | [A-Za-z0-9\-\.]{1,64} |
| date | xs:date | – | ([12]\d{3}-(0[1-9]\|1[0-2])-(0[1-9]\|[12]\d\|3[01])) |
| decimal | xs:decimal | – | -?(0\|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)? |
| language | core:string | – |  |
| currency | core:string | – |  |
| reference | xs:string | – |  |


## Core Model Types

The following types are imported from the Core-model. See [Core-model Guide](Core-model_Guide.md) for complete documentation.

| Name | Base Type | Description | Pattern |
| --- | --- | --- | --- |
| NPI | xs:string | – | [0-9]{10} |
| positiveInt | xs:positiveInteger | – | \+?[1-9][0-9]* |
| string | xs:string | – | [ \r\n\t\S]+ |
| unsignedInt | xs:unsignedInt | – | 0\|([1-9][0-9]*) |


## Complex Types

### human_name

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| use | – | 0 | 1 | Use this element to describe the name. More information can be found here: http://hl7.org/fhir/R4/valueset-name-use.html |
| text | core:string | 0 | 1 | Use this element to enter the entire name |
| family | core:string | 1 | 1 | Family name (often called 'Surname') |
| given | core:string | 1 | unbounded | Given names (not always 'first'). Includes middle names |
| prefix | core:string | 0 | unbounded | – |
| suffix | core:string | 0 | unbounded | – |
| period | period | 0 | 1 | Time period when name was/is in use. If the name is still in use, do not supply an End date |


### address

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| use | – | 0 | 1 | The use of this address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-use.html |
| type | – | 0 | 1 | The type of address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-type.html |
| text | core:string | 0 | 1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) |
| line | core:string | 1 | unbounded | – |
| city | core:string | 1 | 1 | Name of city, town etc. |
| district | core:string | 0 | 1 | Use this element to list the District name (aka county) |
| state | core:string | 1 | 1 | Sub-unit of country (abbreviations ok) |
| postal_code | core:string | 1 | 1 | The postal code or post code of the address. The postal code supports an unlimited amount of numbers and letters. |
| country | xs:string | 0 | 1 | Country (e.g. can be ISO 3166 2 or 3 letter code) |
| period | period | 0 | 1 | – |


### telecom

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| system | – | 1 | 1 | Use this element to describe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html |
| value | core:string | 1 | 1 | The actual value of the contact point |
| use | – | 0 | 1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html |
| rank | core:positiveInt | 0 | 1 | Specify preferred order of use (1 = highest) |
| period | period | 0 | 1 | Time period when the contact point was/is in use |


### period

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| start | dateTime | 1 | 1 | – |
| end | dateTime | 0 | 1 | – |


### range

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| low | simple_quantity | 0 | 1 | – |
| high | simple_quantity | 0 | 1 | – |


### codeable_concept

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| coding | – | 0 | 1 | – |
| system | core:string | 0 | 1 | – |
| version | core:string | 0 | 1 | – |
| code | core:string | 0 | 1 | – |
| display | core:string | 0 | 1 | – |
| text | core:string | 0 | 1 | – |


### result_value

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value_quantity | quantity | 0 | 1 | – |
| value_codeable_concept | codeable_concept | 0 | 1 | – |
| value_boolean | xs:boolean | 0 | 1 | – |
| value_string | core:string | 0 | 1 | – |
| value_integer | integer | 0 | 1 | – |
| value_range | range | 0 | 1 | – |
| value_ratio | – | 0 | 1 | – |
| numerator | quantity | 0 | 1 | – |
| denominator | quantity | 0 | 1 | – |
| value_sampled_data | – | 0 | 1 | – |
| origin | simple_quantity | 1 | 1 | – |
| period | decimal | 1 | 1 | – |
| factor | decimal | 0 | 1 | – |
| lower_limit | decimal | 0 | 1 | – |
| upper_limit | decimal | 0 | 1 | – |
| dimensions | core:positiveInt | 1 | 1 | – |
| data | core:string | 0 | 1 | – |
| value_time | time | 0 | 1 | – |
| value_date_time | dateTime | 0 | 1 | – |
| value_period | period | 0 | 1 | – |


### result_value_vital_sign_profile

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value_quantity_respiratory_rate | quantity_respiratory_rate | 0 | 1 | – |
| value_quantity_heart_rate | quantity_heart_rate | 0 | 1 | – |
| value_quantity_oxygen_saturation | quantity_oxygen_saturation | 0 | 1 | – |
| value_quantity_body_temperature | quantity_body_temperature | 0 | 1 | – |
| value_quantity_body_height | quantity_body_height | 0 | 1 | – |
| value_quantity_head_circumference | quantity_head_circumference | 0 | 1 | – |
| value_quantity_body_weight | quantity_body_weight | 0 | 1 | – |
| value_quantity_body_mass_index | quantity_body_mass_index | 0 | 1 | – |
| value_quantity_bp_systolic_diastolic | – | 0 | 1 | – |
| value_quantity_bp_systolic | quantity_bp_systolic | 0 | 1 | – |
| value_quantity_bp_diastolic | quantity_bp_diastolic | 0 | 1 | – |
| value_codeable_concept | codeable_concept | 0 | 1 | – |
| value_boolean | xs:boolean | 0 | 1 | – |
| value_string | core:string | 0 | 1 | – |
| value_integer | integer | 0 | 1 | – |
| value_range | range | 0 | 1 | – |
| value_ratio | – | 0 | 1 | – |
| numerator | quantity | 0 | 1 | – |
| denominator | quantity | 0 | 1 | – |
| value_sampled_data | – | 0 | 1 | – |
| origin | simple_quantity | 1 | 1 | – |
| period | period | 1 | 1 | – |
| factor | decimal | 0 | 1 | – |
| lower_limit | decimal | 0 | 1 | – |
| upper_limit | decimal | 0 | 1 | – |
| dimensions | core:positiveInt | 1 | 1 | – |
| data | core:string | 0 | 1 | – |
| value_time | time | 0 | 1 | – |
| value_date_time | dateTime | 0 | 1 | – |
| value_period | period | 0 | 1 | – |


### quantity_respiratory_rate

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | – | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | – | 1 | 1 | The URI of the system that defines the coded unit form |
| code | – | 1 | 1 | Coded form of the unit |


### quantity_heart_rate

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | – | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | – | 1 | 1 | The URI of the system that defines the coded unit form |
| code | – | 1 | 1 | Coded form of the unit |


### quantity_oxygen_saturation

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | – | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | – | 1 | 1 | The URI of the system that defines the coded unit form |
| code | – | 1 | 1 | Coded form of the unit |


### quantity_body_temperature

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | – | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | – | 1 | 1 | The URI of the system that defines the coded unit form |
| code | – | 1 | 1 | Coded form of the unit |


### quantity_body_height

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | – | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | – | 1 | 1 | The URI of the system that defines the coded unit form |
| code | – | 1 | 1 | Coded form of the unit |


### quantity_head_circumference

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | – | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | – | 1 | 1 | The URI of the system that defines the coded unit form |
| code | – | 1 | 1 | Coded form of the unit |


### quantity_body_weight

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | – | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | – | 1 | 1 | The URI of the system that defines the coded unit form |
| code | – | 1 | 1 | Coded form of the unit |


### quantity_body_mass_index

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | – | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | – | 1 | 1 | The URI of the system that defines the coded unit form |
| code | – | 1 | 1 | Coded form of the unit |


### quantity_bp_systolic

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | – | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | – | 1 | 1 | The URI of the system that defines the coded unit form |
| code | – | 1 | 1 | Coded form of the unit |


### quantity_bp_diastolic

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | – | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | – | 1 | 1 | The URI of the system that defines the coded unit form |
| code | – | 1 | 1 | Coded form of the unit |


### simple_quantity

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 0 | 1 | – |
| unit | core:string | 0 | 1 | Unit representation (e.g. mcg) |
| system | core:string | 0 | 1 | The URI of the system that defines the coded unit form |
| code | core:string | 0 | 1 | Coded form of the unit |


### quantity

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 0 | 1 | – |
| comparator | – | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 0 | 1 | Unit representation (e.g. mcg) |
| system | core:string | 0 | 1 | The URI of the system that defines the coded unit form |
| code | core:string | 0 | 1 | Coded form of the unit |


### onset

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| onset_date_time | dateTime | 0 | 1 | – |
| onset_age | age | 0 | 1 | – |
| onset_period | period | 0 | 1 | – |
| onset_range | range | 0 | 1 | – |
| onset_string | core:string | 0 | 1 | – |


### abatement

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| abatement_date_time | dateTime | 0 | 1 | – |
| abatement_age | age | 0 | 1 | – |
| abatement_period | period | 0 | 1 | – |
| abatement_range | range | 0 | 1 | – |
| abatement_string | core:string | 0 | 1 | – |


### age

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 0 | 1 | – |
| system | – | 0 | 1 | – |
| code | – | 0 | 1 | These codes represents year, month, week, day, hour, and minute . ‘a’- year,'mo' - month,'wk' - week,'d' - day, 'h' - hour and 'min' - minute. |


### attachment

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| content_type | code | 0 | 1 | – |
| language | code | 0 | 1 | – |
| data | base64Binary | 0 | 1 | – |
| url | core:string | 0 | 1 | – |
| size | core:unsignedInt | 0 | 1 | – |
| hash | base64Binary | 0 | 1 | – |
| title | core:string | 0 | 1 | – |
| creation | dateTime | 0 | 1 | – |


### practitioner

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| npi | core:NPI | 0 | 1 | National Provider Identifier (NPI) |
| names | – | 1 | 1 | – |
| name | human_name | 1 | unbounded | – |
| is_active | xs:boolean | 0 | 1 | Whether this practitioner's record is in active use |
| telecoms | – | 0 | 1 | – |
| telecom | telecom | 0 | unbounded | – |
| addresses | – | 0 | 1 | – |
| address | address | 0 | unbounded | – |


### organization

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| npi | core:NPI | 0 | 1 | National Provider Identifier (NPI) |
| clia | core:string | 0 | 1 | Clinical Laboratory Improvement Amendments (CLIA) Number for laboratories |
| name | core:string | 1 | unbounded | – |
| is_active | xs:boolean | 1 | 1 | – |
| alias | core:string | 0 | unbounded | – |
| telecoms | – | 0 | 1 | – |
| telecom | telecom | 0 | unbounded | – |
| addresses | – | 0 | 1 | – |
| address | address | 0 | unbounded | – |


### encounter

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| identifier | core:string | 0 | unbounded | Identifier(s) by which this encounter is known |
| status | – | 1 | 1 | planned \| arrived \| triaged \| in-progress \| onleave \| finished \| cancelled + |
| class | core:string | 1 | 1 | Classification of patient encounter |
| type | – | 1 | unbounded | Specific type of encounter |
| code | core:string | 1 | 1 | – |
| system | – | 1 | 1 | – |
| participants | – | 0 | 1 | – |
| participant | – | 0 | unbounded | – |
| type | – | 0 | unbounded | – |
| code | core:string | 0 | 1 | – |
| system | – | 0 | 1 | – |
| period | period | 0 | 1 | – |
| individual | practitioner | 0 | 1 | – |
| period | period | 0 | 1 | The start and end time of the encounter |
| reason_code | core:string | 0 | unbounded | The start and end time of the encounter |
| hospitalization | – | 0 | 1 | – |
| discharge_disposition | core:string | 0 | 1 | – |
| location | – | 1 | 1 | – |
| location | location | 0 | unbounded | – |


### location

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| identifier | identifier | 0 | unbounded | Unique code or number identifying the location to its users |
| status | – | 0 | 1 | active \| suspended \| inactive |
| name | core:string | 1 | 1 | Name of the location as used by humans |
| telecoms | – | 0 | 1 | – |
| telecom | telecom | 0 | unbounded | – |
| address | address | 0 | 1 | – |
| managing_organization | organization | 0 | 1 | – |


### identifier

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | core:string | 1 | 1 | – |
| type | core:string | 1 | 1 | – |


### member_person

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| medical_record_number | core:string | 0 | unbounded | – |
| member_id | core:string | 0 | 1 | Use this element to list the Member ID . |
| member_id_system | core:string | 0 | 1 | Use this element to identify the system that issues the Member ID . |
| unique_person_id | core:string | 0 | 1 | This is the person's unique member number in the Payer system across plans. This number is not reused for anyone else. |
| unique_person_id_assigner | core:string | 0 | 1 | Organization that issued id |
| unique_person_id_assigner_type | core:string | 0 | 1 | Type of organization that issued id |
| names | – | 1 | 1 | – |
| name | human_name | 1 | unbounded | – |
| gender | – | 1 | 1 | Use this element for Gender (male, female, other or unknown) |
| birth_date | xs:date | 1 | 1 | Birth date (1900-01-01) |
| marital_status | – | 0 | 1 | Marital Status, more information can be found here: http://hl7.org/fhir/R4/valueset-marital-status.html |
| deceased | – | 0 | 1 | – |
| is_deceased | xs:boolean | 0 | 1 | – |
| deceased_date_time | dateTime | 0 | 1 | – |
| telecoms | – | 0 | 1 | – |
| telecom | telecom | 0 | unbounded | – |
| addresses | – | 1 | 1 | – |
| address | address | 1 | unbounded | – |
| communications | – | 0 | 1 | – |
| communication | – | 0 | unbounded | – |
| language_code | language | 1 | 1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html |
| is_preferred | xs:boolean | 0 | 1 | Is this language the preferred language (true/false) |
| us_core_race | – | 0 | 1 | – |
| omb_category_code | – | 0 | 5 | This element is for selecting 1 of the 5 OMB race category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html |
| detailed_code | – | 0 | unbounded | This element is for selecting 1 of the additional expansion codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html |
| text | core:string | 1 | 1 | Use this element for adding a text description |
| us_core_ethnicity | – | 0 | 1 | – |
| omb_category_code | – | 0 | 1 | This element is for selecting 1 of the OMB ethnicity category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-omb-ethnicity-category.html |
| detailed_code | – | 0 | unbounded | This element is for selecting 1 of the additional ethnicity codes from the CDC that can be found here: https://www.hl7.org/fhir/us/core/ValueSet-detailed-ethnicity.html |
| text | core:string | 1 | 1 | Use this element for adding a text description if the ethnicity is not listed within the enumeration |
| us_core_birth_sex | – | 0 | 1 | This element is used for selecting birth sex (M = Male, F = Female, UNK = Unknown) |


### vital_signs

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| unique_identifier | core:string | 1 | 1 | – |
| status | – | 1 | 1 | – |
| category_vs_cat | – | 1 | 1 | – |
| coding | – | 1 | unbounded | – |
| code | – | 1 | 1 | – |
| system | – | 1 | 1 | – |
| code | – | 1 | 1 | – |
| code | – | 1 | 1 | – |
| display | – | 0 | 1 | – |
| system | – | 0 | 1 | – |
| effective | – | 1 | 1 | – |
| effective_date_time | dateTime | 1 | 1 | – |
| effective_period | period | 1 | 1 | – |
| value | result_value_vital_sign_profile | 0 | 1 | Vital Signs value are recorded using the Quantity data type |
| data_absent_reason | – | 0 | 1 | – |
| code | core:string | 0 | 1 | – |
| system | core:string | 0 | 1 | – |
| component | – | 0 | unbounded | Used when reporting systolic and diastolic blood pressure. |
| component_systolic_bp | – | 1 | 1 | – |
| code | – | 1 | 1 | – |
| coding_sbp_code | – | 1 | 1 | – |
| code | – | 1 | 1 | – |
| system | – | 1 | 1 | – |
| value | quantity_bp_systolic | 0 | 1 | – |
| data_absent_reason | – | 0 | 1 | Why the component result is missing |
| coding | – | 0 | 1 | – |
| code | core:string | 0 | 1 | – |
| system | core:string | 0 | 1 | – |
| component_diastolic_bp | – | 1 | 1 | – |
| code | – | 1 | 1 | – |
| coding_dbp_code | – | 1 | 1 | – |
| code | – | 1 | 1 | – |
| system | – | 1 | 1 | – |
| value | quantity_bp_diastolic | 0 | 1 | – |
| data_absent_reason | – | 0 | 1 | – |
| coding | – | 0 | 1 | – |
| code | core:string | 0 | 1 | – |
| system | core:string | 0 | 1 | – |


### endpoint

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| identifier | identifier | 0 | unbounded | Identifies this endpoint across multiple systems |
| status | – | 1 | 1 | – |
| connectionType | – | 1 | 1 | Protocol/Profile/Standard to be used with this endpoint connection |
| code | – | 1 | 1 | – |
| system | – | 0 | 1 | – |
| name | core:string | 0 | 1 | A name that this endpoint can be identified by |
| managing_organization | organization | 0 | 1 | Organization that manages this endpoint (might not be the organization that exposes the endpoint) |
| contacts | – | 0 | 1 | – |
| contact | telecom | 0 | unbounded | – |
| period | period | 0 | 1 | Interval the endpoint is expected to be operational |
| payload_type | – | 1 | unbounded | IThe type of content that may be used at this endpoint (e.g. XDS Discharge summaries) |
| code | core:string | 1 | 1 | – |
| system | – | 0 | 1 | – |
| payload_mime_type | – | 0 | unbounded | Mimetype to send. If not specified, the content could be anything (including no payload, if the connectionType defined this) |
| code | core:string | 0 | 1 | – |
| system | – | 0 | 1 | – |
| address | core:string | 1 | 1 | The technical base address for connecting to this endpoint |
| header | core:string | 0 | unbounded | Usage depends on the channel type |


### lab_observation_result

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| status | – | 1 | 1 | Status of the observation |
| observation_code | codeable_concept | 1 | 1 | Laboratory Test Name [LOINC COdes] |
| observation_effective | – | 0 | 1 | – |
| effective_date_time | dateTime | 0 | 1 | Clinically relevant time/time-period for observation |
| effective_period | period | 0 | 1 | – |
| observation_value | result_value | 0 | 1 | Result of the observation |
| data_absent_reason | – | 0 | 1 | Reason for missing data. Inputs can be found here: http://hl7.org/fhir/R4/valueset-data-absent-reason.html |
| interpretation | core:string | 0 | unbounded | A categorical assessment of an observation value. For example, high, low, normal. |
| reference_range | – | 0 | unbounded | Guidance on how to interpret the value by comparison to a normal or recommended range. Multiple reference ranges are interpreted as an "OR". In other words, to represent two distinct target populations, two referenceRange elements would be used. |
| low | simple_quantity | 0 | 1 | – |
| high | simple_quantity | 0 | 1 | – |
| type | – | 0 | 1 | – |
| applies_to | codeable_concept | 0 | 1 | – |
| age | range | 0 | 1 | – |
| text | core:string | 0 | 1 | – |


## Required Elements of Clinical XSD

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| clinicals |  | 1..1 | – | – | – |
| schema_version | clinicals | 1..1 | This element defines what version of the clinical schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | clinicals | 1..1 | This element is used to the unique identifier assigned to your organization | – | core:string |
| date_time_reported | clinicals | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |
| clinical | clinicals | 1..unbounded | – | – | – |
| patient | clinical | 1..1 | – | – | – |
| – | patient | – | One of: reference | – | choice |
| reference | patient | 1..1 | – | – | reference |
| lab_observation | lab_observations | 1..unbounded | – | – | – |
| unique_identifier | lab_observation | 1..1 | – | – | core:string |
| status | lab_observation | 1..1 | Status of the observation | – | – |
| observation_code | lab_observation | 1..1 | Laboratory Test Name [LOINC COdes] | – | codeable_concept |
| – | observation_effective | – | One of: effective_date_time, effective_period | – | choice |
| – | lab_observation | – | One of: observation_value, data_absent_reason | – | choice |
| allergy_intolerance | allergy_intolerances | 1..unbounded | – | – | – |
| unique_identifier | allergy_intolerance | 1..1 | – | – | core:string |
| allergy_code | allergy_intolerance | 1..1 | Code for an allergy or intolerance statement (either a positive or a negated/excluded statement). This may be a code for a substance or pharmaceutical product that is considered to be responsible for the adverse reaction risk (e.g., "Latex"), an allergy or intolerance condition (e.g., "Latex allergy"), or a negated/excluded code for a specific substance or class (e.g., "No latex allergy") or a general or categorical negated statement (e.g., "No known allergy", "No known drug allergies"). | – | – |
| code | allergy_code | 1..1 | – | – | core:string |
| system | allergy_code | 1..1 | – | – | – |
| manifestation | reaction | 1..unbounded | Clinical symptoms and/or signs that are observed or associated with the adverse reaction event. | – | core:string |
| condition | conditions | 1..unbounded | – | – | – |
| unique_identifier | condition | 1..1 | – | – | core:string |
| condition_code | condition | 1..1 | Identification of the condition, problem or diagnosis. A detailed list of codes can be found here http://hl7.org/fhir/us/core/ValueSet-us-core-condition-code.html | – | – |
| code | condition_code | 1..1 | – | – | core:string |
| system | condition_code | 1..1 | – | – | – |
| category | condition | 1..unbounded | Identification of the condition, problem or diagnosis | – | – |
| procedure | procedures | 1..unbounded | – | – | – |
| unique_identifier | procedure | 1..1 | – | – | core:string |
| procedure_code | procedure | 1..1 | - Procedure codes from SNOMED CT, CPT, HCPCS II, ICD-10-PCS, or CDT. - HCPCS Level II Alphanumeric Codes are maintained by CMS and are available for public use. - Refer to urn:oid:2.16.840.1.113883.6.285 for HCPCS Level II codes. | – | – |
| – | procedure_code | – | All of (any order): code, system | – | sequence |
| code | procedure_code | 1..1 | – | – | xs:string |
| system | procedure_code | 1..1 | – | – | – |
| – | procedure_code | – | All of (any order): text, extension | – | sequence |
| text | procedure_code | 1..1 | – | – | xs:string |
| extension | procedure_code | 1..unbounded | – | – | – |
| url | extension | 1..1 | – | – | xs:anyURI |
| valueCode | extension | 1..1 | – | – | xs:string |
| status | procedure | 1..1 | A code specifying the state of the procedure. Generally, this will be the in-progress or completed state. | – | – |
| performed | procedure | 1..1 | Estimated or actual date, date-time, period, or age when the procedure was performed. Allows a period to support complex procedures that span more than one date, and also allows for the length of the procedure to be captured. | – | – |
| – | performed | – | One of: performed_date_time, performed_period | – | choice |
| medication_request | medication_requests | 1..unbounded | – | – | – |
| unique_identifier | medication_request | 1..1 | – | – | core:string |
| status | medication_request | 1..1 | Status of the request | – | – |
| intent | medication_request | 1..1 | Intent of the request | – | – |
| – | reported | – | One of: reported_boolean, reported_reference | – | choice |
| – | reported_reference | – | One of: reported_patient, reported_practitioner, reported_organization | – | choice |
| medication | medication_request | 1..1 | – | – | – |
| medication_code | medication | 1..1 | A code (or set of codes) that specify this medication, or a textual description if no code is available. An example list can be found here https://build.fhir.org/ig/HL7/US-Core-R4/ValueSet-us-core-medication-codes.html. Due to the size of this list, no enumeration is provided. | – | – |
| code | medication_code | 1..1 | – | – | core:string |
| system | medication_code | 1..1 | – | – | – |
| code | form | 1..1 | – | – | core:string |
| system | form | 1..1 | – | – | – |
| authored_on | medication_request | 1..1 | – | – | dateTime |
| – | requester | – | One of: patient, practitioner, organization | – | choice |
| patient | requester | 1..1 | – | – | member_person |
| practitioner | requester | 1..1 | – | – | practitioner |
| organization | requester | 1..1 | – | – | organization |
| care_team | care_teams | 1..unbounded | – | – | – |
| unique_identifier | care_team | 1..1 | – | – | core:string |
| participant | care_team | 1..unbounded | – | – | – |
| role | participant | 1..unbounded | Type of involvement Include all codes defined in http://nucc.org/provider-taxonomy Include codes from http://snomed.info/sct where concept is-a 223366009 (Healthcare professional) Include codes from http://snomed.info/sct where concept is-a 224930009 (Services) | – | – |
| code | role | 1..1 | – | – | core:string |
| system | role | 1..1 | – | – | – |
| member | participant | 1..1 | – | – | – |
| – | member | – | One of: member_person, reference | – | choice |
| member_person | member | 1..1 | – | – | xs:string |
| reference | member | 1..1 | – | – | reference |
| observation_vital_sign | observation_vital_signs | 1..unbounded | – | – | – |
| unique_identifier | observation_vital_sign | 1..1 | – | – | core:string |
| status | observation_vital_sign | 1..1 | – | – | – |
| category_vs_cat | observation_vital_sign | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| code | observation_vital_sign | 1..1 | – | – | – |
| code | code | 1..1 | – | – | – |
| effective | observation_vital_sign | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| – | observation_vital_sign | – | One of: value, data_absent_reason | – | choice |
| component_systolic_bp | component | 1..1 | – | – | – |
| code | component_systolic_bp | 1..1 | – | – | – |
| coding_sbp_code | code | 1..1 | – | – | – |
| code | coding_sbp_code | 1..1 | – | – | – |
| system | coding_sbp_code | 1..1 | – | – | – |
| component_diastolic_bp | component | 1..1 | – | – | – |
| code | component_diastolic_bp | 1..1 | – | – | – |
| coding_dbp_code | code | 1..1 | – | – | – |
| code | coding_dbp_code | 1..1 | – | – | – |
| system | coding_dbp_code | 1..1 | – | – | – |
| practitioner | practitioners | 1..unbounded | – | – | – |
| unique_identifier | practitioner | 1..1 | – | – | core:string |
| practitioner_details | practitioner | 1..1 | – | – | practitioner |
| organization | organizations | 1..unbounded | – | – | – |
| unique_identifier | organization | 1..1 | – | – | core:string |
| organization_details | organization | 1..1 | – | – | organization |
| location | locations | 1..unbounded | – | – | – |
| unique_identifier | location | 1..1 | – | – | core:string |
| location_details | location | 1..1 | – | – | location |
| encounter | encounters | 1..unbounded | – | – | – |
| unique_identifier | encounter | 1..1 | – | – | core:string |
| encounter_details | encounter | 1..1 | – | – | encounter |
| care_plan | care_plans | 1..unbounded | – | – | – |
| unique_identifier | care_plan | 1..1 | – | – | core:string |
| text | care_plan | 1..1 | – | – | – |
| status | text | 1..1 | – | – | – |
| div | text | 1..1 | The actual narrative content, a stripped down version of XHTML.The contents of the html element are an XHTML fragment containing only the basic html formatting elements described in chapters 7-11 and 15 of the HTML 4.0 standard, elements (either name or href), images and internally contained stylesheets. The XHTML content SHALL NOT contain a head, a body, external stylesheet references, scripts, forms, base/link/xlink, frames, iframes and objects. Example: | – | core:string |
| status | care_plan | 1..1 | – | – | – |
| intent | care_plan | 1..1 | – | – | – |
| category | care_plan | 1..unbounded | Type of plan | – | – |
| category_assess_plan | category | 1..1 | – | – | – |
| coding | category_assess_plan | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| goal | goals | 1..unbounded | – | – | – |
| unique_identifier | goal | 1..1 | – | – | core:string |
| lifecycle_status | goal | 1..1 | – | – | – |
| description | goal | 1..1 | – | – | – |
| code | description | 1..1 | – | – | core:string |
| immunization | immunizations | 1..unbounded | – | – | – |
| unique_identifier | immunization | 1..1 | – | – | core:string |
| status | immunization | 1..1 | – | – | – |
| vaccine_code | immunization | 1..1 | – | – | – |
| code | vaccine_code | 1..1 | – | – | core:string |
| system | vaccine_code | 1..1 | – | – | – |
| occurrence | immunization | 1..1 | – | – | – |
| – | occurrence | – | One of: occurrence_date_time, occurrence_string | – | choice |
| occurrence_date_time | occurrence | 1..1 | – | – | dateTime |
| occurrence_string | occurrence | 1..1 | – | – | core:string |
| primary_source | immunization | 1..1 | – | – | xs:boolean |
| pediatric_bmi_for_age_observation | pediatric_bmi_for_age_observations | 1..unbounded | – | – | – |
| unique_identifier | pediatric_bmi_for_age_observation | 1..1 | – | – | core:string |
| status | pediatric_bmi_for_age_observation | 1..1 | – | – | – |
| category | pediatric_bmi_for_age_observation | 1..unbounded | – | – | – |
| category_vs_cat | category | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| code | pediatric_bmi_for_age_observation | 1..1 | BMI percentile per age and sex for youth 2-20 | – | – |
| coding | code | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| effective | pediatric_bmi_for_age_observation | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| code | component | 1..1 | – | – | – |
| code | code | 1..1 | – | – | – |
| pediatric_head_occipital_frontal_circumference_observation | pediatric_head_occipital_frontal_circumference_observations | 1..unbounded | – | – | – |
| unique_identifier | pediatric_head_occipital_frontal_circumference_observation | 1..1 | – | – | core:string |
| status | pediatric_head_occipital_frontal_circumference_observation | 1..1 | – | – | – |
| category | pediatric_head_occipital_frontal_circumference_observation | 1..unbounded | – | – | – |
| category_vs_cat | category | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| code | pediatric_head_occipital_frontal_circumference_observation | 1..1 | Head Occipital-frontal circumference Percentile | – | – |
| coding | code | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| effective | pediatric_head_occipital_frontal_circumference_observation | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| code | component | 1..1 | – | – | – |
| code | code | 1..1 | – | – | – |
| pediatric_weight_for_height_observation | pediatric_weight_for_height_observations | 1..unbounded | – | – | – |
| unique_identifier | pediatric_weight_for_height_observation | 1..1 | – | – | core:string |
| status | pediatric_weight_for_height_observation | 1..1 | – | – | – |
| category | pediatric_weight_for_height_observation | 1..unbounded | – | – | – |
| category_vs_cat | category | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| code | pediatric_weight_for_height_observation | 1..1 | Weight-for-length per age and gender | – | – |
| code | coding | 1..unbounded | – | – | – |
| system | coding | 1..1 | – | – | – |
| effective | pediatric_weight_for_height_observation | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| code | component | 1..1 | – | – | – |
| code | code | 1..1 | – | – | – |
| practitioner_role | practitioners_roles | 1..unbounded | – | – | – |
| unique_identifier | practitioner_role | 1..1 | – | – | core:string |
| practitioner | practitioner_role | 1..1 | – | – | practitioner |
| organization | practitioner_role | 1..1 | – | – | organization |
| smoking_status_observation | smoking_status_observations | 1..unbounded | – | – | – |
| unique_identifier | smoking_status_observation | 1..1 | – | – | core:string |
| status | smoking_status_observation | 1..1 | – | – | – |
| code | smoking_status_observation | 1..1 | – | – | – |
| code | code | 1..1 | – | – | – |
| system | code | 1..1 | – | – | – |
| issued | smoking_status_observation | 1..1 | – | – | instant |
| value_codeable_concept | smoking_status_observation | 1..1 | – | – | – |
| code | value_codeable_concept | 1..1 | – | – | – |
| provenance | provenances | 1..unbounded | – | – | – |
| unique_identifier | provenance | 1..1 | – | – | core:string |
| target | provenance | 1..unbounded | – | – | – |
| resource_type | target | 1..1 | – | – | – |
| unique_identifier | target | 1..1 | – | – | core:string |
| recorded | provenance | 1..1 | – | – | instant |
| agent | provenance | 1..unbounded | – | – | – |
| who | agent_provenance_general | 1..1 | – | – | – |
| – | who | – | One of: patient, practitioner, organization | – | choice |
| patient | who | 1..1 | – | – | member_person |
| practitioner | who | 1..1 | – | – | practitioner |
| organization | who | 1..1 | – | – | organization |
| type | agent_provenance_author | 1..1 | – | – | – |
| coding | type | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| who | agent_provenance_author | 1..1 | – | – | – |
| – | who | – | One of: patient, practitioner, organization | – | choice |
| patient | who | 1..1 | – | – | member_person |
| practitioner | who | 1..1 | – | – | practitioner |
| organization | who | 1..1 | – | – | organization |
| – | on_behalf_of | – | One of: patient, practitioner, organization | – | choice |
| type | agent_provenance_transmitter | 1..1 | – | – | – |
| coding | type | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| who | agent_provenance_transmitter | 1..1 | – | – | – |
| – | who | – | One of: patient, practitioner, organization | – | choice |
| patient | who | 1..1 | – | – | member_person |
| practitioner | who | 1..1 | – | – | practitioner |
| organization | who | 1..1 | – | – | organization |
| – | on_behalf_of | – | One of: patient, practitioner, organization | – | choice |
| pulse_oximetry_observation | pulse_oximetry_observations | 1..unbounded | – | – | – |
| unique_identifier | pulse_oximetry_observation | 1..1 | – | – | core:string |
| status | pulse_oximetry_observation | 1..1 | – | – | – |
| category | pulse_oximetry_observation | 1..unbounded | – | – | – |
| category_vs_cat | category | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| code | pulse_oximetry_observation | 1..1 | Oxygen Saturation by Pulse Oximetry | – | – |
| coding_oxygen_sat_code | coding | 1..1 | – | – | – |
| code | coding_oxygen_sat_code | 1..1 | – | – | – |
| system | coding_oxygen_sat_code | 1..1 | – | – | – |
| coding_pulse_ox | coding | 1..1 | – | – | – |
| code | coding_pulse_ox | 1..1 | – | – | – |
| system | coding_pulse_ox | 1..1 | – | – | – |
| effective | pulse_oximetry_observation | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| code | component_flow_rate | 1..1 | – | – | – |
| coding | code | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| code | component_concentration | 1..1 | – | – | – |
| coding | code | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| implantable_device | implantable_devices | 1..unbounded | – | – | – |
| unique_identifier | implantable_device | 1..1 | – | – | core:string |
| udi_carrier | implantable_device | 1..1 | – | – | – |
| device_identifier | udi_carrier | 1..1 | – | – | core:string |
| type | implantable_device | 1..1 | – | – | – |
| code | type | 1..1 | – | – | core:string |
| document_reference | document_references | 1..unbounded | – | – | – |
| unique_identifier | document_reference | 1..1 | – | – | core:string |
| status | document_reference | 1..1 | Status of the request | – | – |
| type | document_reference | 1..1 | – | – | – |
| code | type | 1..1 | – | – | core:string |
| system | type | 1..1 | – | – | – |
| category | document_reference | 1..unbounded | – | – | – |
| code | category | 1..1 | – | – | core:string |
| – | author | – | One of: patient, practitioner, organization | – | choice |
| content | document_reference | 1..unbounded | – | – | – |
| attachment | content | 1..1 | – | – | – |
| content_type | attachment | 1..1 | – | – | code |
| diagnostic_report_lab | diagnostic_report_labs | 1..unbounded | – | – | – |
| unique_identifier | diagnostic_report_lab | 1..1 | – | – | core:string |
| status | diagnostic_report_lab | 1..1 | – | – | – |
| category | diagnostic_report_lab | 1..unbounded | – | – | – |
| category_laboratory_slice | category | 1..1 | – | – | – |
| coding | category_laboratory_slice | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| code | diagnostic_report_lab | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| system | code | 1..1 | – | – | – |
| issued | diagnostic_report_lab | 1..1 | – | – | instant |
| effective | diagnostic_report_lab | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| – | performer | – | One of: reported_practitioner, reported_organization | – | choice |
| diagnostic_report_note | diagnostic_report_notes | 1..unbounded | – | – | – |
| unique_identifier | diagnostic_report_note | 1..1 | – | – | core:string |
| status | diagnostic_report_note | 1..1 | – | – | – |
| category | diagnostic_report_note | 1..unbounded | – | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | diagnostic_report_note | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| system | code | 1..1 | – | – | – |
| effective | diagnostic_report_note | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| – | performer | – | One of: reported_practitioner, reported_organization | – | choice |


## All Elements of Clinical XSD

### Root Elements

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| clinicals |  | 1..1 | – | – | – |
| schema_version | clinicals | 1..1 | This element defines what version of the clinical schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | clinicals | 1..1 | This element is used to the unique identifier assigned to your organization | – | core:string |
| date_time_reported | clinicals | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |


### Clinical Data

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| clinical | clinicals | 1..unbounded | – | – | – |


### Patient Information

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| patient | clinical | 1..1 | – | – | – |
| – | patient | – | One of: reference | – | choice |
| reference | patient | 1..1 | – | – | reference |


### Laboratory Result Observations

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| lab_observations | clinical | 0..1 | – | – | – |
| lab_observation | lab_observations | 1..unbounded | – | – | – |
| unique_identifier | lab_observation | 1..1 | – | – | core:string |
| status | lab_observation | 1..1 | Status of the observation | – | – |
| observation_code | lab_observation | 1..1 | Laboratory Test Name [LOINC COdes] | – | codeable_concept |
| observation_effective | lab_observation | 0..1 | – | – | – |
| – | observation_effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | observation_effective | 0..1 | Clinically relevant time/time-period for observation | – | dateTime |
| effective_period | observation_effective | 0..1 | – | – | period |
| – | lab_observation | – | One of: observation_value, data_absent_reason | – | choice |
| observation_value | lab_observation | 0..1 | Result of the observation | – | result_value |
| data_absent_reason | lab_observation | 0..1 | Reason for missing data. Inputs can be found here: http://hl7.org/fhir/R4/valueset-data-absent-reason.html | – | – |
| interpretation | lab_observation | 0..unbounded | A categorical assessment of an observation value. For example, high, low, normal. | – | core:string |
| reference_range | lab_observation | 0..unbounded | Guidance on how to interpret the value by comparison to a normal or recommended range. Multiple reference ranges are interpreted as an "OR". In other words, to represent two distinct target populations, two referenceRange elements would be used. | – | – |
| low | reference_range | 0..1 | – | – | simple_quantity |
| high | reference_range | 0..1 | – | – | simple_quantity |
| type | reference_range | 0..1 | – | – | – |
| applies_to | reference_range | 0..1 | – | – | codeable_concept |
| age | reference_range | 0..1 | – | – | range |
| text | reference_range | 0..1 | – | – | core:string |
| record_type | lab_observation | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | – |


### Allergy Intolerance

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| allergy_intolerances | clinical | 0..1 | – | – | – |
| allergy_intolerance | allergy_intolerances | 1..unbounded | – | – | – |
| unique_identifier | allergy_intolerance | 1..1 | – | – | core:string |
| clinical_status | allergy_intolerance | 0..1 | The clinical status of the allergy or intolerance. | – | – |
| verification_status | allergy_intolerance | 0..1 | Assertion about certainty associated with the propensity, or potential risk, of a reaction to the identified substance (including pharmaceutical product). | – | – |
| type | allergy_intolerance | 0..1 | Identification of the underlying physiological mechanism for the reaction risk. | – | – |
| category | allergy_intolerance | 0..unbounded | The category of the allergy from the type of allergen item. | – | – |
| allergy_code | allergy_intolerance | 1..1 | Code for an allergy or intolerance statement (either a positive or a negated/excluded statement). This may be a code for a substance or pharmaceutical product that is considered to be responsible for the adverse reaction risk (e.g., "Latex"), an allergy or intolerance condition (e.g., "Latex allergy"), or a negated/excluded code for a specific substance or class (e.g., "No latex allergy") or a general or categorical negated statement (e.g., "No known allergy", "No known drug allergies"). | – | – |
| code | allergy_code | 1..1 | – | – | core:string |
| system | allergy_code | 1..1 | – | – | – |
| reactions | allergy_intolerance | 0..1 | – | – | – |
| reaction | reactions | 0..unbounded | Details about each adverse reaction event linked to exposure to the identified substance. | – | – |
| manifestation | reaction | 1..unbounded | Clinical symptoms and/or signs that are observed or associated with the adverse reaction event. | – | core:string |
| onset | allergy_intolerance | 0..1 | When allergy or intolerance was identified | – | onset |
| criticality | allergy_intolerance | 0..1 | Estimate of the potential clinical harm, or seriousness, of the reaction to the identified substance. | – | – |
| recorded_date | allergy_intolerance | 0..1 | The recordedDate represents when this particular AllergyIntolerance record was created in the system, which is often a system-generated date. | – | dateTime |
| record_type | allergy_intolerance | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | – |


### Conditions

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| conditions | clinical | 0..1 | – | – | – |
| condition | conditions | 1..unbounded | – | – | – |
| unique_identifier | condition | 1..1 | – | – | core:string |
| condition_code | condition | 1..1 | Identification of the condition, problem or diagnosis. A detailed list of codes can be found here http://hl7.org/fhir/us/core/ValueSet-us-core-condition-code.html | – | – |
| code | condition_code | 1..1 | – | – | core:string |
| system | condition_code | 1..1 | – | – | – |
| category | condition | 1..unbounded | Identification of the condition, problem or diagnosis | – | – |
| clinical_status | condition | 0..1 | Preferred value set for Condition Clinical Status | – | – |
| verification_status | condition | 0..1 | The verification status to support or decline the clinical status of the condition or diagnosis. | – | – |
| severity | condition | 0..1 | Subjective severity of condition | – | – |
| onset | condition | 0..1 | Estimated or actual date, date-time, or age | – | onset |
| recorded_date | condition | 0..1 | Date of when condition was first recorded,The recordedDate represents when this particular Condition record was created in the system, which is often a system-generated date. | – | dateTime |
| abatement | condition | 0..1 | The date or estimated date that the condition resolved or went into remission. This is called "abatement" because of the many overloaded connotations associated with "remission" or "resolution" - Conditions are never really resolved, but they can abate. | – | abatement |
| record_type | condition | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | – |


### Procedures

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| procedures | clinical | 0..1 | – | – | – |
| procedure | procedures | 1..unbounded | – | – | – |
| unique_identifier | procedure | 1..1 | – | – | core:string |
| procedure_code | procedure | 1..1 | - Procedure codes from SNOMED CT, CPT, HCPCS II, ICD-10-PCS, or CDT. - HCPCS Level II Alphanumeric Codes are maintained by CMS and are available for public use. - Refer to urn:oid:2.16.840.1.113883.6.285 for HCPCS Level II codes. | – | – |
| – | procedure_code | – | All of (any order): code, system | – | sequence |
| code | procedure_code | 1..1 | – | – | xs:string |
| system | procedure_code | 1..1 | – | – | – |
| – | procedure_code | – | All of (any order): text, extension | – | sequence |
| text | procedure_code | 1..1 | – | – | xs:string |
| extension | procedure_code | 1..unbounded | – | – | – |
| url | extension | 1..1 | – | – | xs:anyURI |
| valueCode | extension | 1..1 | – | – | xs:string |
| status | procedure | 1..1 | A code specifying the state of the procedure. Generally, this will be the in-progress or completed state. | – | – |
| performed | procedure | 1..1 | Estimated or actual date, date-time, period, or age when the procedure was performed. Allows a period to support complex procedures that span more than one date, and also allows for the length of the procedure to be captured. | – | – |
| – | performed | – | One of: performed_date_time, performed_period | – | choice |
| performed_date_time | performed | 0..1 | – | – | dateTime |
| performed_period | performed | 0..1 | – | – | period |
| record_type | procedure | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | – |


### Medication Requests

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| medication_requests | clinical | 0..1 | – | – | – |
| medication_request | medication_requests | 1..unbounded | – | – | – |
| unique_identifier | medication_request | 1..1 | – | – | core:string |
| status | medication_request | 1..1 | Status of the request | – | – |
| intent | medication_request | 1..1 | Intent of the request | – | – |
| reported | medication_request | 0..1 | Was medication reported by patient or not | – | – |
| – | reported | – | One of: reported_boolean, reported_reference | – | choice |
| reported_boolean | reported | 0..1 | – | – | xs:boolean |
| reported_reference | reported | 0..1 | – | – | – |
| – | reported_reference | – | One of: reported_patient, reported_practitioner, reported_organization | – | choice |
| reported_patient | reported_reference | 0..1 | – | – | member_person |
| reported_practitioner | reported_reference | 0..1 | – | – | practitioner |
| reported_organization | reported_reference | 0..1 | – | – | organization |
| medication | medication_request | 1..1 | – | – | – |
| medication_code | medication | 1..1 | A code (or set of codes) that specify this medication, or a textual description if no code is available. An example list can be found here https://build.fhir.org/ig/HL7/US-Core-R4/ValueSet-us-core-medication-codes.html. Due to the size of this list, no enumeration is provided. | – | – |
| code | medication_code | 1..1 | – | – | core:string |
| system | medication_code | 1..1 | – | – | – |
| status | medication | 0..1 | Status of the request | – | – |
| form | medication | 0..1 | – | – | – |
| code | form | 1..1 | – | – | core:string |
| system | form | 1..1 | – | – | – |
| encounter | medication_request | 0..1 | – | – | encounter |
| authored_on | medication_request | 1..1 | – | – | dateTime |
| requester | medication_request | 0..1 | – | – | – |
| – | requester | – | One of: patient, practitioner, organization | – | choice |


### Patient Information

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| patient | requester | 1..1 | – | – | member_person |
| practitioner | requester | 1..1 | – | – | practitioner |
| organization | requester | 1..1 | – | – | organization |


### Medication Requests

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| dosage_instruction | medication_request | 0..unbounded | – | – | – |
| text | dosage_instruction | 0..1 | – | – | core:string |
| record_type | medication_request | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | – |


### Care Teams

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| care_teams | clinical | 0..1 | – | – | – |
| care_team | care_teams | 1..unbounded | – | – | – |
| unique_identifier | care_team | 1..1 | – | – | core:string |
| status | care_team | 0..1 | – | – | – |
| participant | care_team | 1..unbounded | – | – | – |
| role | participant | 1..unbounded | Type of involvement Include all codes defined in http://nucc.org/provider-taxonomy Include codes from http://snomed.info/sct where concept is-a 223366009 (Healthcare professional) Include codes from http://snomed.info/sct where concept is-a 224930009 (Services) | – | – |
| code | role | 1..1 | – | – | core:string |
| system | role | 1..1 | – | – | – |
| member | participant | 1..1 | – | – | – |
| – | member | – | One of: member_person, reference | – | choice |
| member_person | member | 1..1 | – | – | xs:string |
| reference | member | 1..1 | – | – | reference |
| record_type | care_team | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | – |


### Vital Signs

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| observation_vital_signs | clinical | 0..1 | – | – | – |
| observation_vital_sign | observation_vital_signs | 1..unbounded | – | – | – |
| unique_identifier | observation_vital_sign | 1..1 | – | – | core:string |
| status | observation_vital_sign | 1..1 | – | – | – |
| category_vs_cat | observation_vital_sign | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| code | observation_vital_sign | 1..1 | – | – | – |
| code | code | 1..1 | – | – | – |
| display | code | 0..1 | – | – | – |
| system | code | 0..1 | – | – | – |
| effective | observation_vital_sign | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| – | observation_vital_sign | – | One of: value, data_absent_reason | – | choice |
| value | observation_vital_sign | 0..1 | Vital Signs value are recorded using the Quantity data type | – | result_value_vital_sign_profile |
| data_absent_reason | observation_vital_sign | 0..1 | – | – | – |
| code | data_absent_reason | 0..1 | – | – | core:string |
| system | data_absent_reason | 0..1 | – | – | core:string |
| has_member | observation_vital_sign | 0..unbounded | – | – | vital_signs |
| component | observation_vital_sign | 0..unbounded | Used when reporting systolic and diastolic blood pressure. | – | – |
| component_systolic_bp | component | 1..1 | – | – | – |
| code | component_systolic_bp | 1..1 | – | – | – |
| coding_sbp_code | code | 1..1 | – | – | – |
| code | coding_sbp_code | 1..1 | – | – | – |
| system | coding_sbp_code | 1..1 | – | – | – |
| value | component_systolic_bp | 0..1 | – | – | quantity_bp_systolic |
| data_absent_reason | component_systolic_bp | 0..1 | Why the component result is missing | – | – |
| coding | data_absent_reason | 0..1 | – | – | – |
| code | coding | 0..1 | – | – | core:string |
| system | coding | 0..1 | – | – | core:string |
| component_diastolic_bp | component | 1..1 | – | – | – |
| code | component_diastolic_bp | 1..1 | – | – | – |
| coding_dbp_code | code | 1..1 | – | – | – |
| code | coding_dbp_code | 1..1 | – | – | – |
| system | coding_dbp_code | 1..1 | – | – | – |
| value | component_diastolic_bp | 0..1 | – | – | quantity_bp_diastolic |
| data_absent_reason | component_diastolic_bp | 0..1 | – | – | – |
| coding | data_absent_reason | 0..1 | – | – | – |
| code | coding | 0..1 | – | – | core:string |
| system | coding | 0..1 | – | – | core:string |
| record_type | observation_vital_sign | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | – |


### Practitioners

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| practitioners | clinical | 0..1 | – | – | – |
| practitioner | practitioners | 1..unbounded | – | – | – |
| unique_identifier | practitioner | 1..1 | – | – | core:string |
| practitioner_details | practitioner | 1..1 | – | – | practitioner |
| record_type | practitioner | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | – |


### Organizations

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| organizations | clinical | 0..1 | – | – | – |
| organization | organizations | 1..unbounded | – | – | – |
| unique_identifier | organization | 1..1 | – | – | core:string |
| organization_details | organization | 1..1 | – | – | organization |
| record_type | organization | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | – |


### Locations

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| locations | clinical | 0..1 | – | – | – |
| location | locations | 1..unbounded | – | – | – |
| unique_identifier | location | 1..1 | – | – | core:string |
| location_details | location | 1..1 | – | – | location |
| record_type | location | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | – |


### Encounters

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| encounters | clinical | 0..1 | – | – | – |
| encounter | encounters | 1..unbounded | – | – | – |
| unique_identifier | encounter | 1..1 | – | – | core:string |
| encounter_details | encounter | 1..1 | – | – | encounter |
| record_type | encounter | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | – |


### Care Plans

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| care_plans | clinical | 0..1 | – | – | – |
| care_plan | care_plans | 1..unbounded | – | – | – |
| unique_identifier | care_plan | 1..1 | – | – | core:string |
| text | care_plan | 1..1 | – | – | – |
| status | text | 1..1 | – | – | – |
| div | text | 1..1 | The actual narrative content, a stripped down version of XHTML.The contents of the html element are an XHTML fragment containing only the basic html formatting elements described in chapters 7-11 and 15 of the HTML 4.0 standard, elements (either name or href), images and internally contained stylesheets. The XHTML content SHALL NOT contain a head, a body, external stylesheet references, scripts, forms, base/link/xlink, frames, iframes and objects. Example: | – | core:string |
| status | care_plan | 1..1 | – | – | – |
| intent | care_plan | 1..1 | – | – | – |
| category | care_plan | 1..unbounded | Type of plan | – | – |
| category_assess_plan | category | 1..1 | – | – | – |
| coding | category_assess_plan | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| record_type | care_plan | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | – |


### Goals

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| goals | clinical | 0..1 | – | – | – |
| goal | goals | 1..unbounded | – | – | – |
| unique_identifier | goal | 1..1 | – | – | core:string |
| lifecycle_status | goal | 1..1 | – | – | – |
| description | goal | 1..1 | – | – | – |
| code | description | 1..1 | – | – | core:string |
| system | description | 0..1 | – | – | – |
| target | goal | 0..unbounded | – | – | – |
| due_date | target | 0..1 | – | – | date |
| record_type | goal | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | – |


### Immunizations

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| immunizations | clinical | 0..1 | – | – | – |
| immunization | immunizations | 1..unbounded | – | – | – |
| unique_identifier | immunization | 1..1 | – | – | core:string |
| status | immunization | 1..1 | – | – | – |
| status_reason | immunization | 0..1 | – | – | – |
| code | status_reason | 0..1 | – | – | core:string |
| system | status_reason | 0..1 | – | – | – |
| vaccine_code | immunization | 1..1 | – | – | – |
| code | vaccine_code | 1..1 | – | – | core:string |
| system | vaccine_code | 1..1 | – | – | – |
| occurrence | immunization | 1..1 | – | – | – |
| – | occurrence | – | One of: occurrence_date_time, occurrence_string | – | choice |
| occurrence_date_time | occurrence | 1..1 | – | – | dateTime |
| occurrence_string | occurrence | 1..1 | – | – | core:string |
| primary_source | immunization | 1..1 | – | – | xs:boolean |
| record_type | immunization | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | – |


### Pediatric BMI for Age Observations

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| pediatric_bmi_for_age_observations | clinical | 0..1 | – | – | – |
| pediatric_bmi_for_age_observation | pediatric_bmi_for_age_observations | 1..unbounded | – | – | – |
| unique_identifier | pediatric_bmi_for_age_observation | 1..1 | – | – | core:string |
| status | pediatric_bmi_for_age_observation | 1..1 | – | – | – |
| category | pediatric_bmi_for_age_observation | 1..unbounded | – | – | – |
| category_vs_cat | category | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| code | pediatric_bmi_for_age_observation | 1..1 | BMI percentile per age and sex for youth 2-20 | – | – |
| coding | code | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| effective | pediatric_bmi_for_age_observation | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| value_quantity | pediatric_bmi_for_age_observation | 0..1 | Vital Signs value are recorded using the Quantity data type. For supporting observations such as Cuff size could use other datatypes such as CodeableConcept. | – | – |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| comparator | value_quantity | 0..1 | – | – | code |
| data_absent_reason | pediatric_bmi_for_age_observation | 0..1 | – | – | – |
| code | data_absent_reason | 0..1 | – | – | – |
| system | data_absent_reason | 0..1 | – | – | core:string |
| component | pediatric_bmi_for_age_observation | 0..unbounded | – | – | – |
| code | component | 1..1 | – | – | – |
| code | code | 1..1 | – | – | – |
| system | code | 0..1 | – | – | – |
| value | component | 0..1 | – | – | result_value |
| data_absent_reason | component | 0..1 | – | – | – |
| code | data_absent_reason | 0..1 | – | – | – |
| system | data_absent_reason | 0..1 | – | – | core:string |
| record_type | pediatric_bmi_for_age_observation | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | – |


### Pediatric Head Occipital Frontal Circumference Observations

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| pediatric_head_occipital_frontal_circumference_observations | clinical | 0..1 | – | – | – |
| pediatric_head_occipital_frontal_circumference_observation | pediatric_head_occipital_frontal_circumference_observations | 1..unbounded | – | – | – |
| unique_identifier | pediatric_head_occipital_frontal_circumference_observation | 1..1 | – | – | core:string |
| status | pediatric_head_occipital_frontal_circumference_observation | 1..1 | – | – | – |
| category | pediatric_head_occipital_frontal_circumference_observation | 1..unbounded | – | – | – |
| category_vs_cat | category | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| code | pediatric_head_occipital_frontal_circumference_observation | 1..1 | Head Occipital-frontal circumference Percentile | – | – |
| coding | code | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| effective | pediatric_head_occipital_frontal_circumference_observation | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| value_quantity | pediatric_head_occipital_frontal_circumference_observation | 0..1 | Vital Signs value are recorded using the Quantity data type. For supporting observations such as Cuff size could use other datatypes such as CodeableConcept. | – | – |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| comparator | value_quantity | 0..1 | – | – | code |
| data_absent_reason | pediatric_head_occipital_frontal_circumference_observation | 0..1 | – | – | – |
| code | data_absent_reason | 0..1 | – | – | – |
| system | data_absent_reason | 0..1 | – | – | core:string |
| component | pediatric_head_occipital_frontal_circumference_observation | 0..unbounded | – | – | – |
| code | component | 1..1 | – | – | – |
| code | code | 1..1 | – | – | – |
| system | code | 0..1 | – | – | – |
| value | component | 0..1 | – | – | result_value |
| data_absent_reason | component | 0..1 | – | – | – |
| code | data_absent_reason | 0..1 | – | – | – |
| system | data_absent_reason | 0..1 | – | – | core:string |
| record_type | pediatric_head_occipital_frontal_circumference_observation | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | – |


### Pediatric Weight for Height Observations

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| pediatric_weight_for_height_observations | clinical | 0..1 | – | – | – |
| pediatric_weight_for_height_observation | pediatric_weight_for_height_observations | 1..unbounded | – | – | – |
| unique_identifier | pediatric_weight_for_height_observation | 1..1 | – | – | core:string |
| status | pediatric_weight_for_height_observation | 1..1 | – | – | – |
| category | pediatric_weight_for_height_observation | 1..unbounded | – | – | – |
| category_vs_cat | category | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| code | pediatric_weight_for_height_observation | 1..1 | Weight-for-length per age and gender | – | – |
| coding | code | 0..unbounded | – | – | – |
| code | coding | 1..unbounded | – | – | – |
| system | coding | 1..1 | – | – | – |
| effective | pediatric_weight_for_height_observation | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| value_quantity | pediatric_weight_for_height_observation | 0..1 | Vital Signs value are recorded using the Quantity data type. For supporting observations such as Cuff size could use other datatypes such as CodeableConcept. | – | – |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| comparator | value_quantity | 0..1 | – | – | code |
| data_absent_reason | pediatric_weight_for_height_observation | 0..1 | – | – | – |
| code | data_absent_reason | 0..1 | – | – | – |
| system | data_absent_reason | 0..1 | – | – | core:string |
| component | pediatric_weight_for_height_observation | 0..unbounded | – | – | – |
| code | component | 1..1 | – | – | – |
| code | code | 1..1 | – | – | – |
| system | code | 0..1 | – | – | – |
| value | component | 0..1 | – | – | result_value |
| data_absent_reason | component | 0..1 | – | – | – |
| code | data_absent_reason | 0..1 | – | – | – |
| system | data_absent_reason | 0..1 | – | – | core:string |
| record_type | pediatric_weight_for_height_observation | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | – |


### Clinical Data

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| practitioners_roles | clinical | 0..1 | – | – | – |
| practitioner_role | practitioners_roles | 1..unbounded | – | – | – |


### Practitioner Roles

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| unique_identifier | practitioner_role | 1..1 | – | – | core:string |
| practitioner | practitioner_role | 1..1 | – | – | practitioner |
| organization | practitioner_role | 1..1 | – | – | organization |
| code | practitioner_role | 0..unbounded | – | – | – |
| code | code | 0..1 | – | – | core:string |
| system | code | 0..1 | – | – | – |
| specialty | practitioner_role | 0..unbounded | – | – | – |
| code | specialty | 0..1 | – | – | core:string |
| system | specialty | 0..1 | – | – | – |
| location | practitioner_role | 0..unbounded | – | – | location |
| telecom | practitioner_role | 0..unbounded | – | – | telecom |
| endpoints | practitioner_role | 0..unbounded | – | – | endpoint |
| record_type | practitioner_role | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | – |


### Smoking Status Observations

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| smoking_status_observations | clinical | 0..1 | – | – | – |
| smoking_status_observation | smoking_status_observations | 1..unbounded | – | – | – |
| unique_identifier | smoking_status_observation | 1..1 | – | – | core:string |
| status | smoking_status_observation | 1..1 | – | – | – |
| code | smoking_status_observation | 1..1 | – | – | – |
| code | code | 1..1 | – | – | – |
| system | code | 1..1 | – | – | – |
| issued | smoking_status_observation | 1..1 | – | – | instant |
| value_codeable_concept | smoking_status_observation | 1..1 | – | – | – |
| code | value_codeable_concept | 1..1 | – | – | – |
| system | value_codeable_concept | 0..1 | – | – | – |
| record_type | smoking_status_observation | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | – |


### Provenances

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| provenances | clinical | 0..1 | – | – | – |
| provenance | provenances | 1..unbounded | – | – | – |
| unique_identifier | provenance | 1..1 | – | – | core:string |
| target | provenance | 1..unbounded | – | – | – |
| resource_type | target | 1..1 | – | – | – |
| unique_identifier | target | 1..1 | – | – | core:string |
| recorded | provenance | 1..1 | – | – | instant |
| agent | provenance | 1..unbounded | – | – | – |
| agent_provenance_general | agent | 0..unbounded | – | – | – |
| type | agent_provenance_general | 0..1 | – | – | – |
| code | type | 0..1 | – | – | – |
| system | type | 0..1 | – | – | – |
| who | agent_provenance_general | 1..1 | – | – | – |
| – | who | – | One of: patient, practitioner, organization | – | choice |


### Patient Information

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| patient | who | 1..1 | – | – | member_person |
| practitioner | who | 1..1 | – | – | practitioner |
| organization | who | 1..1 | – | – | organization |
| on_behalf_of | agent_provenance_general | 0..1 | – | – | organization |
| agent_provenance_author | agent | 0..unbounded | – | – | – |
| type | agent_provenance_author | 1..1 | – | – | – |
| coding | type | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| who | agent_provenance_author | 1..1 | – | – | – |
| – | who | – | One of: patient, practitioner, organization | – | choice |
| patient | who | 1..1 | – | – | member_person |
| practitioner | who | 1..1 | – | – | practitioner |
| organization | who | 1..1 | – | – | organization |
| on_behalf_of | agent_provenance_author | 0..1 | – | – | – |
| – | on_behalf_of | – | One of: patient, practitioner, organization | – | choice |
| patient | on_behalf_of | 0..1 | – | – | member_person |
| practitioner | on_behalf_of | 0..1 | – | – | practitioner |
| organization | on_behalf_of | 0..1 | – | – | organization |
| agent_provenance_transmitter | agent | 0..1 | – | – | – |
| type | agent_provenance_transmitter | 1..1 | – | – | – |
| coding | type | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| who | agent_provenance_transmitter | 1..1 | – | – | – |
| – | who | – | One of: patient, practitioner, organization | – | choice |
| patient | who | 1..1 | – | – | member_person |
| practitioner | who | 1..1 | – | – | practitioner |
| organization | who | 1..1 | – | – | organization |
| on_behalf_of | agent_provenance_transmitter | 0..1 | – | – | – |
| – | on_behalf_of | – | One of: patient, practitioner, organization | – | choice |
| patient | on_behalf_of | 0..1 | – | – | member_person |
| practitioner | on_behalf_of | 0..1 | – | – | practitioner |
| organization | on_behalf_of | 0..1 | – | – | organization |


### Provenances

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| record_type | provenance | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | – |


### Clinical Data

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| pulse_oximetry_observations | clinical | 0..1 | – | – | – |
| pulse_oximetry_observation | pulse_oximetry_observations | 1..unbounded | – | – | – |
| unique_identifier | pulse_oximetry_observation | 1..1 | – | – | core:string |
| status | pulse_oximetry_observation | 1..1 | – | – | – |
| category | pulse_oximetry_observation | 1..unbounded | – | – | – |
| category_vs_cat | category | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| code | pulse_oximetry_observation | 1..1 | Oxygen Saturation by Pulse Oximetry | – | – |
| coding | code | 0..unbounded | – | – | – |
| coding_oxygen_sat_code | coding | 1..1 | – | – | – |
| code | coding_oxygen_sat_code | 1..1 | – | – | – |
| system | coding_oxygen_sat_code | 1..1 | – | – | – |
| coding_pulse_ox | coding | 1..1 | – | – | – |
| code | coding_pulse_ox | 1..1 | – | – | – |
| system | coding_pulse_ox | 1..1 | – | – | – |
| effective | pulse_oximetry_observation | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| value_quantity | pulse_oximetry_observation | 0..1 | Vital Signs value are recorded using the Quantity data type. For supporting observations such as Cuff size could use other datatypes such as CodeableConcept. | – | – |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| comparator | value_quantity | 0..1 | – | – | code |
| data_absent_reason | pulse_oximetry_observation | 0..1 | – | – | – |
| code | data_absent_reason | 0..1 | – | – | – |
| system | data_absent_reason | 0..1 | – | – | core:string |
| component | pulse_oximetry_observation | 0..unbounded | Used when reporting systolic and diastolic blood pressure. | – | – |
| component_flow_rate | component | 0..1 | – | – | – |
| code | component_flow_rate | 1..1 | – | – | – |
| coding | code | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| value_quantity | component_flow_rate | 0..1 | Vital Sign Value recorded with UCUM | – | – |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| comparator | value_quantity | 0..1 | – | – | code |
| data_absent_reason | component_flow_rate | 0..1 | – | – | – |
| code | data_absent_reason | 0..1 | – | – | – |
| system | data_absent_reason | 0..1 | – | – | core:string |
| component_concentration | component | 0..1 | – | – | – |
| code | component_concentration | 1..1 | – | – | – |
| coding | code | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| value_quantity | component_concentration | 0..1 | Vital Sign Value recorded with UCUM | – | – |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| comparator | value_quantity | 0..1 | – | – | code |
| data_absent_reason | component_concentration | 0..1 | – | – | – |
| code | data_absent_reason | 0..1 | – | – | – |
| system | data_absent_reason | 0..1 | – | – | core:string |
| record_type | pulse_oximetry_observation | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | – |
| implantable_devices | clinical | 0..1 | – | – | – |
| implantable_device | implantable_devices | 1..unbounded | – | – | – |
| unique_identifier | implantable_device | 1..1 | – | – | core:string |
| udi_carrier | implantable_device | 1..1 | – | – | – |
| device_identifier | udi_carrier | 1..1 | – | – | core:string |
| carrier_aidc | udi_carrier | 0..1 | – | – | base64Binary |
| carrier_hrf | udi_carrier | 0..1 | – | – | core:string |
| distinct_identifier | implantable_device | 0..1 | – | – | core:string |
| manufacture_date | implantable_device | 0..1 | – | – | dateTime |
| expiration_date | implantable_device | 0..1 | – | – | dateTime |
| lot_number | implantable_device | 0..1 | – | – | core:string |
| serial_number | implantable_device | 0..1 | – | – | core:string |
| type | implantable_device | 1..1 | – | – | – |
| code | type | 1..1 | – | – | core:string |
| system | type | 0..1 | – | – | – |
| record_type | implantable_device | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | – |
| document_references | clinical | 0..1 | – | – | – |
| document_reference | document_references | 1..unbounded | – | – | – |
| unique_identifier | document_reference | 1..1 | – | – | core:string |
| status | document_reference | 1..1 | Status of the request | – | – |
| type | document_reference | 1..1 | – | – | – |
| code | type | 1..1 | – | – | core:string |
| system | type | 1..1 | – | – | – |
| category | document_reference | 1..unbounded | – | – | – |
| code | category | 1..1 | – | – | core:string |
| system | category | 0..1 | – | – | – |
| author | document_reference | 0..unbounded | – | – | – |
| – | author | – | One of: patient, practitioner, organization | – | choice |


### Patient Information

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| patient | author | 0..1 | – | – | member_person |
| practitioner | author | 0..1 | – | – | practitioner |
| organization | author | 0..1 | – | – | organization |
| custodian | document_reference | 0..1 | – | – | organization |
| date | document_reference | 0..1 | – | – | instant |
| content | document_reference | 1..unbounded | – | – | – |
| attachment | content | 1..1 | – | – | – |
| content_type | attachment | 1..1 | – | – | code |
| data | attachment | 0..1 | – | – | base64Binary |
| url | attachment | 0..1 | – | – | core:string |
| format | content | 0..1 | – | – | – |
| code | format | 0..1 | – | – | core:string |
| system | format | 0..1 | – | – | – |
| context | document_reference | 0..1 | – | – | – |
| encounter | context | 0..1 | – | – | encounter |
| period | context | 0..1 | – | – | period |
| record_type | document_reference | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | – |


### Clinical Data

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| diagnostic_report_labs | clinical | 0..1 | – | – | – |
| diagnostic_report_lab | diagnostic_report_labs | 1..unbounded | – | – | – |
| unique_identifier | diagnostic_report_lab | 1..1 | – | – | core:string |
| status | diagnostic_report_lab | 1..1 | – | – | – |
| category | diagnostic_report_lab | 1..unbounded | – | – | – |
| category_laboratory_slice | category | 1..1 | – | – | – |
| coding | category_laboratory_slice | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | – |
| system | coding | 1..1 | – | – | – |
| code | diagnostic_report_lab | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| system | code | 1..1 | – | – | – |
| issued | diagnostic_report_lab | 1..1 | – | – | instant |
| effective | diagnostic_report_lab | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| performer | diagnostic_report_lab | 0..unbounded | – | – | – |
| – | performer | – | One of: reported_practitioner, reported_organization | – | choice |
| reported_practitioner | performer | 0..1 | – | – | practitioner |
| reported_organization | performer | 0..1 | – | – | organization |
| result | diagnostic_report_lab | 0..unbounded | – | – | lab_observation_result |
| record_type | diagnostic_report_lab | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | – |
| diagnostic_report_notes | clinical | 0..1 | – | – | – |
| diagnostic_report_note | diagnostic_report_notes | 1..unbounded | – | – | – |
| unique_identifier | diagnostic_report_note | 1..1 | – | – | core:string |
| status | diagnostic_report_note | 1..1 | – | – | – |
| category | diagnostic_report_note | 1..unbounded | – | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | diagnostic_report_note | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| system | code | 1..1 | – | – | – |
| issued | diagnostic_report_note | 0..1 | – | – | instant |
| effective | diagnostic_report_note | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| performer | diagnostic_report_note | 0..unbounded | – | – | – |
| – | performer | – | One of: reported_practitioner, reported_organization | – | choice |
| reported_practitioner | performer | 0..1 | – | – | practitioner |
| reported_organization | performer | 0..1 | – | – | organization |
| presented_form | diagnostic_report_note | 0..unbounded | – | – | attachment |
| encounter | diagnostic_report_note | 0..1 | – | – | encounter |
| record_type | diagnostic_report_note | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | – |


## Practical Guidance

### Submission Frequency

Clinical files should be submitted according to the schedule agreed upon with HealthLX. Typical submission frequencies include daily, weekly, or monthly updates.

### Adds, Updates, and Deletes

- **Adds**: Include new member records with all required fields populated
- **Updates**: Submit complete member records with updated information
- **Deletes**: Follow the agreed-upon process for member terminations or removals

### Member Identification

Each member must be uniquely identified using the appropriate identifier fields. Ensure consistency in member identifiers across all submissions to maintain data integrity.

