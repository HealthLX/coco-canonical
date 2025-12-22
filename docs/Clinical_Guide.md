![HLX Logo](../assets/hlx_logo.png)

# Clinical Implementation Guide

**HLX0123 HLX Clinical IG (XSD_V10.0)**

**Version 10.0**

**December 22, 2025**

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
| 10.0 | December 22, 2025 |

## Simple Types

| Name | Base Type | Description | Enumerations | Constraints |
| --- | --- | --- | --- | --- |
| integer | xs:integer | – | – | Pattern: [0]\|[-+]?[1-9][0-9]* |
| time | xs:time | – | – | Pattern: ([01][0-9]\|2[0-3]):[0-5][0-9]:[0-5][0-9](\.\d{1,9})? |
| dateTime | xs:string | – | – | Pattern: ([12]\d{3})-(0[1-9]\|1[0-2])-(0[1-9]\|[1-2][0-9]\|3[0-1])(T([01][0-9]\|2[0-3]):[0-5][0-9]:[0-5][0-9](\.\d{1,6})?((Z\|(\+\|-)((0[0-9]\|1[0-3]):(00\|15\|30\|45)\|14:00))?))? |
| base64Binary | xs:base64Binary | – | – | – |
| instant | xs:dateTime | – | – | Pattern: ([0-9]([0-9]([0-9][1-9]\|[1-9]0)\|[1-9]00)\|[1-9]000)-(0[1-9]\|1[0-2])-(0[1-9]\|[1-2][0-9]\|3[0-1])T([01][0-9]\|2[0-3]):[0-5][0-9]:([0-5][0-9]\|60)(\.[0-9]+)?(Z\|(\+\|-)((0[0-9]\|1[0-3]):[0-5][0-9]\|14:00)) |
| code | xs:string | – | – | Pattern: [^\s]+(\s[^\s]+)* |
| id | xs:string | – | – | Pattern: [A-Za-z0-9\-\.]{1,64} |
| date | xs:date | – | – | Pattern: ([12]\d{3}-(0[1-9]\|1[0-2])-(0[1-9]\|[12]\d\|3[01])) |
| decimal | xs:decimal | – | – | Pattern: -?(0\|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)? |
| language | core:string | – | ar, bn, cs, da, de, de-AT, de-CH, de-DE, el, en, en-AU, en-CA, en-GB, en-IN, en-NZ, en-SG, en-US, es, es-AR, es-ES, es-UY, fi, fr, fr-BE, fr-CH, fr-FR, fy, fy-NL, hi, hr, it, it-CH, it-IT, ja, ko, nl, nl-BE, nl-NL, no, no-NO, pa, pl, pt, pt-BR, ru, ru-RU, sr, sr-RS, sv, sv-SE, te, zh, zh-CN, zh-HK, zh-SG, zh-TW | – |
| currency | core:string | – | AED, AFN, ALL, AMD, ANG, AOA, ARS, AUD, AWG, AZN, BAM, BBD, BDT, BGN, BHD, BIF, BMD, BND, BOB, BOV, BRL, BSD, BTN, BWP, BYN, BZD, CAD, CDF, CHE, CHF, CHW, CLF, CLP, CNY, COP, COU, CRC, CUC, CUP, CVE, CZK, DJF, DKK, DOP, DZD, EGP, ERN, ETB, EUR, FJD, FKP, GBP, GEL, GGP, GHS, GIP, GMD, GNF, GTQ, GYD, HKD, HNL, HRK, HTG, HUF, IDR, ILS, IMP, INR, IQD, IRR, ISK, JEP, JMD, JOD, JPY, KES, KGS, KHR, KMF, KPW, KRW, KWD, KYD, KZT, LAK, LBP, LKR, LRD, LSL, LYD, MAD, MDL, MGA, MKD, MMK, MNT, MOP, MRU, MUR, MVR, MWK, MXN, MXV, MYR, MZN, NAD, NGN, NIO, NOK, NPR, NZD, OMR, PAB, PEN, PGK, PHP, PKR, PLN, PYG, QAR, RON, RSD, RUB, RWF, SAR, SBD, SCR, SDG, SEK, SGD, SHP, SLL, SOS, SRD, SSP, STN, SVC, SYP, SZL, THB, TJS, TMT, TND, TOP, TRY, TTD, TVD, TWD, TZS, UAH, UGX, USD, USN, UYI, UYU, UZS, VEF, VND, VUV, WST, XAF, XAG, XAU, XBA, XBB, XBC, XBD, XCD, XDR, XOF, XPD, XPF, XPT, XSU, XTS, XUA, XXX, YER, ZAR, ZMW, ZWL | – |
| reference | xs:string | – | – | – |


## Core Model Types

The following types are imported from the Core-model. See [Core-model Guide](Core-model_Guide.md) for complete documentation.

| Name | Base Type | Description | Enumerations | Constraints |
| --- | --- | --- | --- | --- |
| NPI | xs:string | – | – | Pattern: [0-9]{10} |
| positiveInt | xs:positiveInteger | – | – | Pattern: \+?[1-9][0-9]* |
| string | xs:string | – | – | Pattern: [ \r\n\t\S]+ |
| unsignedInt | xs:unsignedInt | – | – | Pattern: 0\|([1-9][0-9]*) |


## Complex Types

### human_name

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| use | core:string (enum: usual, official, temp, nickname, anonymous, old, maiden) | 0 | 1 | Use this element to describe the name. More information can be found here: http://hl7.org/fhir/R4/valueset-name-use.html |
| text | core:string | 0 | 1 | Use this element to enter the entire name |
| family | core:string | 1 | 1 | Family name (often called 'Surname') |
| given | core:string | 1 | unbounded | Given names (not always 'first'). Includes middle names |
| prefix | core:string | 0 | unbounded | – |
| suffix | core:string | 0 | unbounded | – |
| period | period | 0 | 1 | Time period when name was/is in use. If the name is still in use, do not supply an End date |


### address

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| use | core:string (enum: home, work, temp, old, billing) | 0 | 1 | The use of this address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-use.html |
| type | core:string (enum: postal, physical, both) | 0 | 1 | The type of address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-type.html |
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
| system | core:string (enum: phone, fax, email, pager, url, sms, other) | 1 | 1 | Use this element to describe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html |
| value | core:string | 1 | 1 | The actual value of the contact point |
| use | core:string (enum: home, work, temp, old, mobile) | 0 | 1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html |
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
| comparator | xs:string (enum: <, <=, >=, >) | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | xs:string (enum: http://unitsofmeasure.org) | 1 | 1 | The URI of the system that defines the coded unit form |
| code | xs:string (enum: /min) | 1 | 1 | Coded form of the unit |


### quantity_heart_rate

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | xs:string (enum: <, <=, >=, >) | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | xs:string (enum: http://unitsofmeasure.org) | 1 | 1 | The URI of the system that defines the coded unit form |
| code | xs:string (enum: /min) | 1 | 1 | Coded form of the unit |


### quantity_oxygen_saturation

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | xs:string (enum: <, <=, >=, >) | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | xs:string (enum: http://unitsofmeasure.org) | 1 | 1 | The URI of the system that defines the coded unit form |
| code | xs:string (enum: %) | 1 | 1 | Coded form of the unit |


### quantity_body_temperature

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | xs:string (enum: <, <=, >=, >) | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | xs:string (enum: http://unitsofmeasure.org) | 1 | 1 | The URI of the system that defines the coded unit form |
| code | xs:string (enum: Cel, [degF]) | 1 | 1 | Coded form of the unit |


### quantity_body_height

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | xs:string (enum: <, <=, >=, >) | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | xs:string (enum: http://unitsofmeasure.org) | 1 | 1 | The URI of the system that defines the coded unit form |
| code | xs:string (enum: cm, [in_i]) | 1 | 1 | Coded form of the unit |


### quantity_head_circumference

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | xs:string (enum: <, <=, >=, >) | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | xs:string (enum: http://unitsofmeasure.org) | 1 | 1 | The URI of the system that defines the coded unit form |
| code | xs:string (enum: cm, [in_i]) | 1 | 1 | Coded form of the unit |


### quantity_body_weight

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | xs:string (enum: <, <=, >=, >) | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | xs:string (enum: http://unitsofmeasure.org) | 1 | 1 | The URI of the system that defines the coded unit form |
| code | xs:string (enum: g, kg, [lb_av]) | 1 | 1 | Coded form of the unit |


### quantity_body_mass_index

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | xs:string (enum: <, <=, >=, >) | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | xs:string (enum: http://unitsofmeasure.org) | 1 | 1 | The URI of the system that defines the coded unit form |
| code | xs:string (enum: kg/m2) | 1 | 1 | Coded form of the unit |


### quantity_bp_systolic

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | xs:string (enum: <, <=, >=, >) | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | xs:string (enum: http://unitsofmeasure.org) | 1 | 1 | The URI of the system that defines the coded unit form |
| code | xs:string (enum: mm[Hg]) | 1 | 1 | Coded form of the unit |


### quantity_bp_diastolic

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 1 | 1 | – |
| comparator | xs:string (enum: <, <=, >=, >) | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | core:string | 1 | 1 | Unit representation (e.g. mcg) |
| system | xs:string (enum: http://unitsofmeasure.org) | 1 | 1 | The URI of the system that defines the coded unit form |
| code | xs:string (enum: mm[Hg]) | 1 | 1 | Coded form of the unit |


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
| comparator | xs:string (enum: <, <=, >=, >) | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
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
| system | core:string (enum: http://ucum.org) | 0 | 1 | – |
| code | core:string (enum: a, mo, wk, d, h, min) | 0 | 1 | These codes represents year, month, week, day, hour, and minute . ‘a’- year,'mo' - month,'wk' - week,'d' - day, 'h' - hour and 'min' - minute. |


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
| status | core:string (enum: planned, arrived, triaged, in-progress, onleave, finished, cancelled) | 1 | 1 | planned \| arrived \| triaged \| in-progress \| onleave \| finished \| cancelled + |
| class | core:string | 1 | 1 | Classification of patient encounter |
| type | – | 1 | unbounded | Specific type of encounter |
| code | core:string | 1 | 1 | – |
| system | core:string (enum: http://snomed.info/sct, http://www.ama-assn.org/go/cpt) | 1 | 1 | – |
| participants | – | 0 | 1 | – |
| participant | – | 0 | unbounded | – |
| type | – | 0 | unbounded | – |
| code | core:string | 0 | 1 | – |
| system | core:string (enum: http://terminology.hl7.org/CodeSystem/v3-ParticipationType, http://terminology.hl7.org/CodeSystem/participant-type) | 0 | 1 | – |
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
| status | core:string (enum: active, suspended, inactive) | 0 | 1 | active \| suspended \| inactive |
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
| gender | core:string (enum: male, female, other, unknown) | 1 | 1 | Use this element for Gender (male, female, other or unknown) |
| birth_date | xs:date | 1 | 1 | Birth date (1900-01-01) |
| marital_status | core:string (enum: A, D, I, L, M, P, S, T, U, W, UNK) | 0 | 1 | Marital Status, more information can be found here: http://hl7.org/fhir/R4/valueset-marital-status.html |
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
| omb_category_code | core:string (enum: 1002-5, 2028-9, 2054-5, 2076-8, 2106-3) | 0 | 5 | This element is for selecting 1 of the 5 OMB race category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html |
| detailed_code | xs:string (enum: 1000-9, 1004-1, 1735-0, 1006-6, 1008-2, 1010-8, 1021-5, 1026-4, 1028-0, 1030-6, 1033-0, 1035-5, 1037-1, 1039-7, 1041-3, 1044-7, 1053-8, 1068-6, 1076-9, 1078-5, 1080-1, 1082-7, 1086-8, 1088-4, 1100-7, 1102-3, 1106-4, 1108-0, 1112-2, 1114-8, 1123-9, 1150-2, 1153-6, 1155-1, 1162-7, 1165-0, 1167-6, 1169-2, 1171-8, 1173-4, 1175-9, 1178-3, 1180-9, 1182-5, 1184-1, 1186-6, 1189-0, 1191-6, 1193-2, 1207-0, 1209-6, 1211-2, 1214-6, 1222-9, 1233-6, 1250-0, 1252-6, 1254-2, 1256-7, 1258-3, 1260-9, 1262-5, 1264-1, 1267-4, 1269-0, 1271-6, 1275-7, 1277-3, 1279-9, 1281-5, 1285-6, 1297-1, 1299-7, 1301-1, 1303-7, 1305-2, 1309-4, 1312-8, 1317-7, 1319-3, 1321-9, 1323-5, 1325-0, 1331-8, 1340-9, 1342-5, 1344-1, 1348-2, 1350-8, 1352-4, 1354-0, 1356-5, 1358-1, 1363-1, 1365-6, 1368-0, 1370-6, 1372-2, 1374-8, 1376-3, 1378-9, 1380-5, 1382-1, 1387-0, 1389-6, 1391-2, 1403-5, 1405-0, 1407-6, 1409-2, 1411-8, 1416-7, 1439-9, 1441-5, 1445-6, 1448-0, 1450-6, 1453-0, 1456-3, 1460-5, 1462-1, 1464-7, 1474-6, 1478-7, 1487-8, 1489-4, 1518-0, 1541-2, 1543-8, 1545-3, 1547-9, 1549-5, 1551-1, 1556-0, 1558-6, 1560-2, 1562-8, 1564-4, 1566-9, 1573-5, 1576-8, 1578-4, 1582-6, 1584-2, 1586-7, 1602-2, 1607-1, 1609-7, 1643-6, 1645-1, 1647-7, 1649-3, 1651-9, 1653-5, 1659-2, 1661-8, 1663-4, 1665-9, 1667-5, 1670-9, 1675-8, 1677-4, 1679-0, 1683-2, 1685-7, 1687-3, 1692-3, 1694-9, 1696-4, 1700-4, 1702-0, 1704-6, 1707-9, 1709-5, 1711-1, 1715-2, 1717-8, 1722-8, 1724-4, 1732-7, 1011-6, 1012-4, 1013-2, 1014-0, 1015-7, 1016-5, 1017-3, 1018-1, 1019-9, 1022-3, 1023-1, 1024-9, 1031-4, 1042-1, 1045-4, 1046-2, 1047-0, 1048-8, 1049-6, 1050-4, 1051-2, 1054-6, 1055-3, 1056-1, 1057-9, 1058-7, 1059-5, 1060-3, 1061-1, 1062-9, 1063-7, 1064-5, 1065-2, 1066-0, 1069-4, 1070-2, 1071-0, 1072-8, 1073-6, 1074-4, 1083-5, 1084-3, 1089-2, 1090-0, 1091-8, 1092-6, 1093-4, 1094-2, 1095-9, 1096-7, 1097-5, 1098-3, 1103-1, 1104-9, 1109-8, 1110-6, 1115-5, 1116-3, 1117-1, 1118-9, 1119-7, 1120-5, 1121-3, 1124-7, 1125-4, 1126-2, 1127-0, 1128-8, 1129-6, 1130-4, 1131-2, 1132-0, 1133-8, 1134-6, 1135-3, 1136-1, 1137-9, 1138-7, 1139-5, 1140-3, 1141-1, 1142-9, 1143-7, 1144-5, 1145-2, 1146-0, 1147-8, 1148-6, 1151-0, 1156-9, 1157-7, 1158-5, 1159-3, 1160-1, 1163-5, 1176-7, 1187-4, 1194-0, 1195-7, 1196-5, 1197-3, 1198-1, 1199-9, 1200-5, 1201-3, 1202-1, 1203-9, 1204-7, 1205-4, 1212-0, 1215-3, 1216-1, 1217-9, 1218-7, 1219-5, 1220-3, 1223-7, 1224-5, 1225-2, 1226-0, 1227-8, 1228-6, 1229-4, 1230-2, 1231-0, 1234-4, 1235-1, 1236-9, 1237-7, 1238-5, 1239-3, 1240-1, 1241-9, 1242-7, 1243-5, 1244-3, 1245-0, 1246-8, 1247-6, 1248-4, 1265-8, 1272-4, 1273-2, 1282-3, 1283-1, 1286-4, 1287-2, 1288-0, 1289-8, 1290-6, 1291-4, 1292-2, 1293-0, 1294-8, 1295-5, 1306-0, 1307-8, 1310-2, 1313-6, 1314-4, 1315-1, 1326-8, 1327-6, 1328-4, 1329-2, 1332-6, 1333-4, 1334-2, 1335-9, 1336-7, 1337-5, 1338-3, 1345-8, 1346-6, 1359-9, 1360-7, 1361-5, 1366-4, 1383-9, 1384-7, 1385-4, 1392-0, 1393-8, 1394-6, 1395-3, 1396-1, 1397-9, 1398-7, 1399-5, 1400-1, 1401-9, 1412-6, 1413-4, 1414-2, 1417-5, 1418-3, 1419-1, 1420-9, 1421-7, 1422-5, 1423-3, 1424-1, 1425-8, 1426-6, 1427-4, 1428-2, 1429-0, 1430-8, 1431-6, 1432-4, 1433-2, 1434-0, 1435-7, 1436-5, 1437-3, 1442-3, 1443-1, 1446-4, 1451-4, 1454-8, 1457-1, 1458-9, 1465-4, 1466-2, 1467-0, 1468-8, 1469-6, 1470-4, 1471-2, 1472-0, 1475-3, 1476-1, 1479-5, 1480-3, 1481-1, 1482-9, 1483-7, 1484-5, 1485-2, 1490-2, 1491-0, 1492-8, 1493-6, 1494-4, 1495-1, 1496-9, 1497-7, 1498-5, 1499-3, 1500-8, 1501-6, 1502-4, 1503-2, 1504-0, 1505-7, 1506-5, 1507-3, 1508-1, 1509-9, 1510-7, 1511-5, 1512-3, 1513-1, 1514-9, 1515-6, 1516-4, 1519-8, 1520-6, 1521-4, 1522-2, 1523-0, 1524-8, 1525-5, 1526-3, 1527-1, 1528-9, 1529-7, 1530-5, 1531-3, 1532-1, 1533-9, 1534-7, 1535-4, 1536-2, 1537-0, 1538-8, 1539-6, 1552-9, 1553-7, 1554-5, 1567-7, 1568-5, 1569-3, 1570-1, 1571-9, 1574-3, 1579-2, 1580-0, 1587-5, 1588-3, 1589-1, 1590-9, 1591-7, 1592-5, 1593-3, 1594-1, 1595-8, 1596-6, 1597-4, 1598-2, 1599-0, 1600-6, 1603-0, 1604-8, 1605-5, 1610-5, 1611-3, 1612-1, 1613-9, 1614-7, 1615-4, 1616-2, 1617-0, 1618-8, 1619-6, 1620-4, 1621-2, 1622-0, 1623-8, 1624-6, 1625-3, 1626-1, 1627-9, 1628-7, 1629-5, 1630-3, 1631-1, 1632-9, 1633-7, 1634-5, 1635-2, 1636-0, 1637-8, 1638-6, 1639-4, 1640-2, 1641-0, 1654-3, 1655-0, 1656-8, 1657-6, 1668-3, 1671-7, 1672-5, 1673-3, 1680-8, 1681-6, 1688-1, 1689-9, 1690-7, 1697-2, 1698-0, 1705-3, 1712-9, 1713-7, 1718-6, 1719-4, 1720-2, 1725-1, 1726-9, 1727-7, 1728-5, 1729-3, 1730-1, 1731-9, 1733-5, 1737-6, 1840-8, 1966-1, 1739-2, 1811-9, 1740-0, 1741-8, 1742-6, 1743-4, 1744-2, 1745-9, 1746-7, 1747-5, 1748-3, 1749-1, 1750-9, 1751-7, 1752-5, 1753-3, 1754-1, 1755-8, 1756-6, 1757-4, 1758-2, 1759-0, 1760-8, 1761-6, 1762-4, 1763-2, 1764-0, 1765-7, 1766-5, 1767-3, 1768-1, 1769-9, 1770-7, 1771-5, 1772-3, 1773-1, 1774-9, 1775-6, 1776-4, 1777-2, 1778-0, 1779-8, 1780-6, 1781-4, 1782-2, 1783-0, 1784-8, 1785-5, 1786-3, 1787-1, 1788-9, 1789-7, 1790-5, 1791-3, 1792-1, 1793-9, 1794-7, 1795-4, 1796-2, 1797-0, 1798-8, 1799-6, 1800-2, 1801-0, 1802-8, 1803-6, 1804-4, 1805-1, 1806-9, 1807-7, 1808-5, 1809-3, 1813-5, 1837-4, 1814-3, 1815-0, 1816-8, 1817-6, 1818-4, 1819-2, 1820-0, 1821-8, 1822-6, 1823-4, 1824-2, 1825-9, 1826-7, 1827-5, 1828-3, 1829-1, 1830-9, 1831-7, 1832-5, 1833-3, 1834-1, 1835-8, 1838-2, 1842-4, 1844-0, 1891-1, 1896-0, 1845-7, 1846-5, 1847-3, 1848-1, 1849-9, 1850-7, 1851-5, 1852-3, 1853-1, 1854-9, 1855-6, 1856-4, 1857-2, 1858-0, 1859-8, 1860-6, 1861-4, 1862-2, 1863-0, 1864-8, 1865-5, 1866-3, 1867-1, 1868-9, 1869-7, 1870-5, 1871-3, 1872-1, 1873-9, 1874-7, 1875-4, 1876-2, 1877-0, 1878-8, 1879-6, 1880-4, 1881-2, 1882-0, 1883-8, 1884-6, 1885-3, 1886-1, 1887-9, 1888-7, 1889-5, 1892-9, 1893-7, 1894-5, 1897-8, 1898-6, 1899-4, 1900-0, 1901-8, 1902-6, 1903-4, 1904-2, 1905-9, 1906-7, 1907-5, 1908-3, 1909-1, 1910-9, 1911-7, 1912-5, 1913-3, 1914-1, 1915-8, 1916-6, 1917-4, 1918-2, 1919-0, 1920-8, 1921-6, 1922-4, 1923-2, 1924-0, 1925-7, 1926-5, 1927-3, 1928-1, 1929-9, 1930-7, 1931-5, 1932-3, 1933-1, 1934-9, 1935-6, 1936-4, 1937-2, 1938-0, 1939-8, 1940-6, 1941-4, 1942-2, 1943-0, 1944-8, 1945-5, 1946-3, 1947-1, 1948-9, 1949-7, 1950-5, 1951-3, 1952-1, 1953-9, 1954-7, 1955-4, 1956-2, 1957-0, 1958-8, 1959-6, 1960-4, 1961-2, 1962-0, 1963-8, 1964-6, 1968-7, 1972-9, 1984-4, 1990-1, 1992-7, 2002-4, 2004-0, 2006-5, 1969-5, 1970-3, 1973-7, 1974-5, 1975-2, 1976-0, 1977-8, 1978-6, 1979-4, 1980-2, 1981-0, 1982-8, 1985-1, 1986-9, 1987-7, 1988-5, 1993-5, 1994-3, 1995-0, 1996-8, 1997-6, 1998-4, 1999-2, 2000-8, 2007-3, 2008-1, 2009-9, 2010-7, 2011-5, 2012-3, 2013-1, 2014-9, 2015-6, 2016-4, 2017-2, 2018-0, 2019-8, 2020-6, 2021-4, 2022-2, 2023-0, 2024-8, 2025-5, 2026-3, 2029-7, 2030-5, 2031-3, 2032-1, 2033-9, 2034-7, 2035-4, 2036-2, 2037-0, 2038-8, 2039-6, 2040-4, 2041-2, 2042-0, 2043-8, 2044-6, 2045-3, 2046-1, 2047-9, 2048-7, 2049-5, 2050-3, 2051-1, 2052-9, 2056-0, 2058-6, 2060-2, 2067-7, 2068-5, 2069-3, 2070-1, 2071-9, 2072-7, 2073-5, 2074-3, 2075-0, 2061-0, 2062-8, 2063-6, 2064-4, 2065-1, 2066-9, 2078-4, 2085-9, 2100-6, 2500-7, 2079-2, 2080-0, 2081-8, 2082-6, 2083-4, 2086-7, 2087-5, 2088-3, 2089-1, 2090-9, 2091-7, 2092-5, 2093-3, 2094-1, 2095-8, 2096-6, 2097-4, 2098-2, 2101-4, 2102-2, 2103-0, 2104-8, 2108-9, 2118-8, 2129-5, 2109-7, 2110-5, 2111-3, 2112-1, 2113-9, 2114-7, 2115-4, 2116-2, 2119-6, 2120-4, 2121-2, 2122-0, 2123-8, 2124-6, 2125-3, 2126-1, 2127-9, 2131-1) | 0 | unbounded | This element is for selecting 1 of the additional expansion codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html |
| text | core:string | 1 | 1 | Use this element for adding a text description |
| us_core_ethnicity | – | 0 | 1 | – |
| omb_category_code | core:string (enum: 2135-2, 2186-5) | 0 | 1 | This element is for selecting 1 of the OMB ethnicity category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-omb-ethnicity-category.html |
| detailed_code | xs:string (enum: 2133-7, 2137-8, 2148-5, 2155-0, 2165-9, 2178-2, 2180-8, 2182-4, 2184-0, 2138-6, 2139-4, 2140-2, 2141-0, 2142-8, 2143-6, 2144-4, 2145-1, 2146-9, 2149-3, 2150-1, 2151-9, 2152-7, 2153-5, 2156-8, 2157-6, 2158-4, 2159-2, 2160-0, 2161-8, 2162-6, 2163-4, 2166-7, 2167-5, 2168-3, 2169-1, 2170-9, 2171-7, 2172-5, 2173-3, 2174-1, 2175-8, 2176-6) | 0 | unbounded | This element is for selecting 1 of the additional ethnicity codes from the CDC that can be found here: https://www.hl7.org/fhir/us/core/ValueSet-detailed-ethnicity.html |
| text | core:string | 1 | 1 | Use this element for adding a text description if the ethnicity is not listed within the enumeration |
| us_core_birth_sex | core:string (enum: M, F, UNK) | 0 | 1 | This element is used for selecting birth sex (M = Male, F = Female, UNK = Unknown) |


### vital_signs

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| unique_identifier | core:string | 1 | 1 | – |
| status | core:string (enum: registered, preliminary, final, amended, corrected, cancelled, entered-in-error, unknown) | 1 | 1 | – |
| category_vs_cat | – | 1 | 1 | – |
| coding | – | 1 | unbounded | – |
| code | core:string (enum: vital-signs) | 1 | 1 | – |
| system | core:string (enum: http://terminology.hl7.org/CodeSystem/observation-category) | 1 | 1 | – |
| code | – | 1 | 1 | – |
| code | core:string (enum: 85353-1, 9279-1, 8867-4, 2708-6, 8310-5, 8302-2, 9843-4, 29463-7, 39156-5, 85354-9, 8480-6, 8462-4, 8478-0) | 1 | 1 | – |
| display | core:string (enum: Vital signs,weight,height,head circumference,oxygen saturation and BMI panel, Respiratory rate, Heart rate, Oxygen saturation in Arterial blood, Body temperature, Body height, Head Occipital-frontal circumference, Body weight, Body mass index (BMI) [Ratio], Blood pressure panel with all children optional, Systolic blood pressure, Diastolic blood pressure, Mean blood pressure) | 0 | 1 | – |
| system | core:string (enum: http://loinc.org) | 0 | 1 | – |
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
| code | core:string (enum: 8480-6) | 1 | 1 | – |
| system | core:string (enum: http://loinc.org) | 1 | 1 | – |
| value | quantity_bp_systolic | 0 | 1 | – |
| data_absent_reason | – | 0 | 1 | Why the component result is missing |
| coding | – | 0 | 1 | – |
| code | core:string | 0 | 1 | – |
| system | core:string | 0 | 1 | – |
| component_diastolic_bp | – | 1 | 1 | – |
| code | – | 1 | 1 | – |
| coding_dbp_code | – | 1 | 1 | – |
| code | core:string (enum: 8462-4) | 1 | 1 | – |
| system | core:string (enum: http://loinc.org) | 1 | 1 | – |
| value | quantity_bp_diastolic | 0 | 1 | – |
| data_absent_reason | – | 0 | 1 | – |
| coding | – | 0 | 1 | – |
| code | core:string | 0 | 1 | – |
| system | core:string | 0 | 1 | – |


### endpoint

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| identifier | identifier | 0 | unbounded | Identifies this endpoint across multiple systems |
| status | core:string (enum: active, suspended, error, off, entered-in-error, test) | 1 | 1 | – |
| connectionType | – | 1 | 1 | Protocol/Profile/Standard to be used with this endpoint connection |
| code | core:string (enum: ihe-xcpd, ihe-xca, ihe-xdr, ihe-xds, ihe-iid, dicom-wado-rs, dicom-qido-rs, dicom-stow-rs, dicom-wado-uri, hl7-fhir-rest, hl7-fhir-msg, hl7v2-mllp, secure-email, direct-project) | 1 | 1 | – |
| system | core:string (enum: http://terminology.hl7.org/CodeSystem/endpoint-connection-type) | 0 | 1 | – |
| name | core:string | 0 | 1 | A name that this endpoint can be identified by |
| managing_organization | organization | 0 | 1 | Organization that manages this endpoint (might not be the organization that exposes the endpoint) |
| contacts | – | 0 | 1 | – |
| contact | telecom | 0 | unbounded | – |
| period | period | 0 | 1 | Interval the endpoint is expected to be operational |
| payload_type | – | 1 | unbounded | IThe type of content that may be used at this endpoint (e.g. XDS Discharge summaries) |
| code | core:string | 1 | 1 | – |
| system | core:string (enum: http://terminology.hl7.org/CodeSystem/endpoint-payload-type, urn:oid:1.3.6.1.4.1.19376.1.2.3) | 0 | 1 | – |
| payload_mime_type | – | 0 | unbounded | Mimetype to send. If not specified, the content could be anything (including no payload, if the connectionType defined this) |
| code | core:string | 0 | 1 | – |
| system | core:string (enum: urn:ietf:bcp:13) | 0 | 1 | – |
| address | core:string | 1 | 1 | The technical base address for connecting to this endpoint |
| header | core:string | 0 | unbounded | Usage depends on the channel type |


### lab_observation_result

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| status | core:string (enum: registered, preliminary, final, amended, corrected, cancelled, entered-in-error, unknown) | 1 | 1 | Status of the observation |
| observation_code | codeable_concept | 1 | 1 | Laboratory Test Name [LOINC COdes] |
| observation_effective | – | 0 | 1 | – |
| effective_date_time | dateTime | 0 | 1 | Clinically relevant time/time-period for observation |
| effective_period | period | 0 | 1 | – |
| observation_value | result_value | 0 | 1 | Result of the observation |
| data_absent_reason | core:string (enum: unknown, asked-unknown, temp-unknown, not-asked, asked-declined, masked, not-applicable, unsupported, as-text, error, not-a-number, negative-infinity, positive-infinity, not-performed, not-permitted) | 0 | 1 | Reason for missing data. Inputs can be found here: http://hl7.org/fhir/R4/valueset-data-absent-reason.html |
| interpretation | core:string | 0 | unbounded | A categorical assessment of an observation value. For example, high, low, normal. |
| reference_range | – | 0 | unbounded | Guidance on how to interpret the value by comparison to a normal or recommended range. Multiple reference ranges are interpreted as an "OR". In other words, to represent two distinct target populations, two referenceRange elements would be used. |
| low | simple_quantity | 0 | 1 | – |
| high | simple_quantity | 0 | 1 | – |
| type | core:string (enum: normal, recommended, treatment, therapeutic, pre_therapeutic, post_therapeutic, endocrine, pre-puberty, follicular, midcycle, luteal, postmenopausal) | 0 | 1 | – |
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
| status | lab_observation | 1..1 | Status of the observation | – | core:string (enum: registered, preliminary, final, amended, corrected, cancelled, entered-in-error, unknown) |
| observation_code | lab_observation | 1..1 | Laboratory Test Name [LOINC COdes] | – | codeable_concept |
| – | observation_effective | – | One of: effective_date_time, effective_period | – | choice |
| – | lab_observation | – | One of: observation_value, data_absent_reason | – | choice |
| allergy_intolerance | allergy_intolerances | 1..unbounded | – | – | – |
| unique_identifier | allergy_intolerance | 1..1 | – | – | core:string |
| allergy_code | allergy_intolerance | 1..1 | Code for an allergy or intolerance statement (either a positive or a negated/excluded statement). This may be a code for a substance or pharmaceutical product that is considered to be responsible for the adverse reaction risk (e.g., "Latex"), an allergy or intolerance condition (e.g., "Latex allergy"), or a negated/excluded code for a specific substance or class (e.g., "No latex allergy") or a general or categorical negated statement (e.g., "No known allergy", "No known drug allergies"). | – | – |
| code | allergy_code | 1..1 | – | – | core:string |
| system | allergy_code | 1..1 | – | – | core:string (enum: http://snomed.info/sct, http://www.nlm.nih.gov/research/umls/rxnorm) |
| manifestation | reaction | 1..unbounded | Clinical symptoms and/or signs that are observed or associated with the adverse reaction event. | – | core:string |
| condition | conditions | 1..unbounded | – | – | – |
| unique_identifier | condition | 1..1 | – | – | core:string |
| condition_code | condition | 1..1 | Identification of the condition, problem or diagnosis. A detailed list of codes can be found here http://hl7.org/fhir/us/core/ValueSet-us-core-condition-code.html | – | – |
| code | condition_code | 1..1 | – | – | core:string |
| system | condition_code | 1..1 | – | – | core:string (enum: http://snomed.info/sct, http://hl7.org/fhir/sid/icd-10-cm, http://hl7.org/fhir/sid/icd-9-cm) |
| category | condition | 1..unbounded | Identification of the condition, problem or diagnosis | – | core:string (enum: problem-list-item, encounter-diagnosis, health-concern) |
| procedure | procedures | 1..unbounded | – | – | – |
| unique_identifier | procedure | 1..1 | – | – | core:string |
| procedure_code | procedure | 1..1 | - Procedure codes from SNOMED CT, CPT, HCPCS II, ICD-10-PCS, or CDT. - HCPCS Level II Alphanumeric Codes are maintained by CMS and are available for public use. - Refer to urn:oid:2.16.840.1.113883.6.285 for HCPCS Level II codes. | – | – |
| – | procedure_code | – | All of (any order): code, system | – | sequence |
| code | procedure_code | 1..1 | – | – | xs:string |
| system | procedure_code | 1..1 | – | – | xs:string (enum: http://www.ama-assn.org/go/cpt, http://snomed.info/sct, http://www.cms.gov/Medicare/Coding/ICD10, http://terminology.hl7.org/CodeSystem/CD2, urn:oid:2.16.840.1.113883.6.285) |
| – | procedure_code | – | All of (any order): text, extension | – | sequence |
| text | procedure_code | 1..1 | – | – | xs:string |
| extension | procedure_code | 1..unbounded | – | – | – |
| url | extension | 1..1 | – | – | xs:anyURI |
| valueCode | extension | 1..1 | – | – | xs:string |
| status | procedure | 1..1 | A code specifying the state of the procedure. Generally, this will be the in-progress or completed state. | – | core:string (enum: preparation, in-progress, not-done, on-hold, stopped, completed, entered-in-error, unknown) |
| performed | procedure | 1..1 | Estimated or actual date, date-time, period, or age when the procedure was performed. Allows a period to support complex procedures that span more than one date, and also allows for the length of the procedure to be captured. | – | – |
| – | performed | – | One of: performed_date_time, performed_period | – | choice |
| medication_request | medication_requests | 1..unbounded | – | – | – |
| unique_identifier | medication_request | 1..1 | – | – | core:string |
| status | medication_request | 1..1 | Status of the request | – | core:string (enum: active, on-hold, cancelled, completed, entered-in-error, stopped, draft, unknown) |
| intent | medication_request | 1..1 | Intent of the request | – | core:string (enum: proposal, plan, order, original-order, reflex-order, filler-order, instance-order, option) |
| – | reported | – | One of: reported_boolean, reported_reference | – | choice |
| – | reported_reference | – | One of: reported_patient, reported_practitioner, reported_organization | – | choice |
| medication | medication_request | 1..1 | – | – | – |
| medication_code | medication | 1..1 | A code (or set of codes) that specify this medication, or a textual description if no code is available. An example list can be found here https://build.fhir.org/ig/HL7/US-Core-R4/ValueSet-us-core-medication-codes.html. Due to the size of this list, no enumeration is provided. | – | – |
| code | medication_code | 1..1 | – | – | core:string |
| system | medication_code | 1..1 | – | – | core:string (enum: http://www.nlm.nih.gov/research/umls/rxnorm) |
| code | form | 1..1 | – | – | core:string |
| system | form | 1..1 | – | – | core:string (enum: http://snomed.info/sct) |
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
| system | role | 1..1 | – | – | core:string (enum: http://nucc.org/provider-taxonomy, http://snomed.info/sct) |
| member | participant | 1..1 | – | – | – |
| – | member | – | One of: member_person, reference | – | choice |
| member_person | member | 1..1 | – | – | xs:string |
| reference | member | 1..1 | – | – | reference |
| observation_vital_sign | observation_vital_signs | 1..unbounded | – | – | – |
| unique_identifier | observation_vital_sign | 1..1 | – | – | core:string |
| status | observation_vital_sign | 1..1 | – | – | core:string (enum: registered, preliminary, final, amended, corrected, cancelled, entered-in-error, unknown) |
| category_vs_cat | observation_vital_sign | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: vital-signs) |
| system | coding | 1..1 | – | – | core:string (enum: http://terminology.hl7.org/CodeSystem/observation-category) |
| code | observation_vital_sign | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string (enum: 85353-1, 9279-1, 8867-4, 2708-6, 8310-5, 8302-2, 9843-4, 29463-7, 39156-5, 85354-9, 8480-6, 8462-4, 8478-0) |
| effective | observation_vital_sign | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| – | observation_vital_sign | – | One of: value, data_absent_reason | – | choice |
| component_systolic_bp | component | 1..1 | – | – | – |
| code | component_systolic_bp | 1..1 | – | – | – |
| coding_sbp_code | code | 1..1 | – | – | – |
| code | coding_sbp_code | 1..1 | – | – | core:string (enum: 8480-6) |
| system | coding_sbp_code | 1..1 | – | – | core:string (enum: http://loinc.org) |
| component_diastolic_bp | component | 1..1 | – | – | – |
| code | component_diastolic_bp | 1..1 | – | – | – |
| coding_dbp_code | code | 1..1 | – | – | – |
| code | coding_dbp_code | 1..1 | – | – | core:string (enum: 8462-4) |
| system | coding_dbp_code | 1..1 | – | – | core:string (enum: http://loinc.org) |
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
| status | text | 1..1 | – | – | core:string (enum: additional, generated) |
| div | text | 1..1 | The actual narrative content, a stripped down version of XHTML.The contents of the html element are an XHTML fragment containing only the basic html formatting elements described in chapters 7-11 and 15 of the HTML 4.0 standard, elements (either name or href), images and internally contained stylesheets. The XHTML content SHALL NOT contain a head, a body, external stylesheet references, scripts, forms, base/link/xlink, frames, iframes and objects. Example: | – | core:string |
| status | care_plan | 1..1 | – | – | core:string (enum: draft, active, on-hold, revoked, completed, entered-in-error, unknown) |
| intent | care_plan | 1..1 | – | – | core:string (enum: proposal, plan, order, option) |
| category | care_plan | 1..unbounded | Type of plan | – | – |
| category_assess_plan | category | 1..1 | – | – | – |
| coding | category_assess_plan | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: assess-plan) |
| system | coding | 1..1 | – | – | core:string (enum: http://hl7.org/fhir/us/core/CodeSystem/careplan-category) |
| goal | goals | 1..unbounded | – | – | – |
| unique_identifier | goal | 1..1 | – | – | core:string |
| lifecycle_status | goal | 1..1 | – | – | core:string (enum: proposed, planned, accepted, active, on-hold, completed, cancelled, entered-in-error, rejected) |
| description | goal | 1..1 | – | – | – |
| code | description | 1..1 | – | – | core:string |
| immunization | immunizations | 1..unbounded | – | – | – |
| unique_identifier | immunization | 1..1 | – | – | core:string |
| status | immunization | 1..1 | – | – | core:string (enum: completed, entered-in-error, not-done) |
| vaccine_code | immunization | 1..1 | – | – | – |
| code | vaccine_code | 1..1 | – | – | core:string |
| system | vaccine_code | 1..1 | – | – | core:string (enum: http://hl7.org/fhir/sid/cvx) |
| occurrence | immunization | 1..1 | – | – | – |
| – | occurrence | – | One of: occurrence_date_time, occurrence_string | – | choice |
| occurrence_date_time | occurrence | 1..1 | – | – | dateTime |
| occurrence_string | occurrence | 1..1 | – | – | core:string |
| primary_source | immunization | 1..1 | – | – | xs:boolean |
| pediatric_bmi_for_age_observation | pediatric_bmi_for_age_observations | 1..unbounded | – | – | – |
| unique_identifier | pediatric_bmi_for_age_observation | 1..1 | – | – | core:string |
| status | pediatric_bmi_for_age_observation | 1..1 | – | – | core:string (enum: registered, preliminary, final, amended, corrected, cancelled, entered-in-error, unknown) |
| category | pediatric_bmi_for_age_observation | 1..unbounded | – | – | – |
| category_vs_cat | category | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: vital-signs) |
| system | coding | 1..1 | – | – | core:string (enum: http://terminology.hl7.org/CodeSystem/observation-category) |
| code | pediatric_bmi_for_age_observation | 1..1 | BMI percentile per age and sex for youth 2-20 | – | – |
| coding | code | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: 59576-9) |
| system | coding | 1..1 | – | – | core:string (enum: http://loinc.org) |
| effective | pediatric_bmi_for_age_observation | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| code | component | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string (enum: 85353-1, 9279-1, 8867-4, 2708-6, 8310-5, 8302-2, 9843-4, 29463-7, 39156-5, 85354-9, 8480-6, 8462-4, 8478-0) |
| pediatric_head_occipital_frontal_circumference_observation | pediatric_head_occipital_frontal_circumference_observations | 1..unbounded | – | – | – |
| unique_identifier | pediatric_head_occipital_frontal_circumference_observation | 1..1 | – | – | core:string |
| status | pediatric_head_occipital_frontal_circumference_observation | 1..1 | – | – | core:string (enum: registered, preliminary, final, amended, corrected, cancelled, entered-in-error, unknown) |
| category | pediatric_head_occipital_frontal_circumference_observation | 1..unbounded | – | – | – |
| category_vs_cat | category | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: vital-signs) |
| system | coding | 1..1 | – | – | core:string (enum: http://terminology.hl7.org/CodeSystem/observation-category) |
| code | pediatric_head_occipital_frontal_circumference_observation | 1..1 | Head Occipital-frontal circumference Percentile | – | – |
| coding | code | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: 8289-1) |
| system | coding | 1..1 | – | – | core:string (enum: http://loinc.org) |
| effective | pediatric_head_occipital_frontal_circumference_observation | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| code | component | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string (enum: 85353-1, 9279-1, 8867-4, 2708-6, 8310-5, 8302-2, 9843-4, 29463-7, 39156-5, 85354-9, 8480-6, 8462-4, 8478-0) |
| pediatric_weight_for_height_observation | pediatric_weight_for_height_observations | 1..unbounded | – | – | – |
| unique_identifier | pediatric_weight_for_height_observation | 1..1 | – | – | core:string |
| status | pediatric_weight_for_height_observation | 1..1 | – | – | core:string (enum: registered, preliminary, final, amended, corrected, cancelled, entered-in-error, unknown) |
| category | pediatric_weight_for_height_observation | 1..unbounded | – | – | – |
| category_vs_cat | category | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: vital-signs) |
| system | coding | 1..1 | – | – | core:string (enum: http://terminology.hl7.org/CodeSystem/observation-category) |
| code | pediatric_weight_for_height_observation | 1..1 | Weight-for-length per age and gender | – | – |
| code | coding | 1..unbounded | – | – | core:string (enum: 77606-2) |
| system | coding | 1..1 | – | – | core:string (enum: http://loinc.org) |
| effective | pediatric_weight_for_height_observation | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| code | component | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string (enum: 85353-1, 9279-1, 8867-4, 2708-6, 8310-5, 8302-2, 9843-4, 29463-7, 39156-5, 85354-9, 8480-6, 8462-4, 8478-0) |
| practitioner_role | practitioners_roles | 1..unbounded | – | – | – |
| unique_identifier | practitioner_role | 1..1 | – | – | core:string |
| practitioner | practitioner_role | 1..1 | – | – | practitioner |
| organization | practitioner_role | 1..1 | – | – | organization |
| smoking_status_observation | smoking_status_observations | 1..unbounded | – | – | – |
| unique_identifier | smoking_status_observation | 1..1 | – | – | core:string |
| status | smoking_status_observation | 1..1 | – | – | core:string (enum: final, entered-in-error) |
| code | smoking_status_observation | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string (enum: 72166-2) |
| system | code | 1..1 | – | – | core:string (enum: http://loinc.org) |
| issued | smoking_status_observation | 1..1 | – | – | instant |
| value_codeable_concept | smoking_status_observation | 1..1 | – | – | – |
| code | value_codeable_concept | 1..1 | – | – | – |
| provenance | provenances | 1..unbounded | – | – | – |
| unique_identifier | provenance | 1..1 | – | – | core:string |
| target | provenance | 1..unbounded | – | – | – |
| resource_type | target | 1..1 | – | – | core:string (enum: allergy_intolerance, care_plan, care_team, condition, diagnostic_report_lab, diagnostic_report_note, document_reference, encounter, goal, immunization, implantable_device, lab_observation, medication_request, patient, pediatric_bmi_for_age_observation, pediatric_weight_for_height_observation, procedure, pulse_oximetry_observation, smoking_status_observation, observation_vital_sign) |
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
| code | coding | 1..1 | – | – | core:string (enum: author) |
| system | coding | 1..1 | – | – | core:string (enum: http://terminology.hl7.org/CodeSystem/provenance-participant-type) |
| who | agent_provenance_author | 1..1 | – | – | – |
| – | who | – | One of: patient, practitioner, organization | – | choice |
| patient | who | 1..1 | – | – | member_person |
| practitioner | who | 1..1 | – | – | practitioner |
| organization | who | 1..1 | – | – | organization |
| – | on_behalf_of | – | One of: patient, practitioner, organization | – | choice |
| type | agent_provenance_transmitter | 1..1 | – | – | – |
| coding | type | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: transmitter) |
| system | coding | 1..1 | – | – | core:string (enum: http://hl7.org/fhir/us/core/CodeSystem/us-core-provenance-participant-type) |
| who | agent_provenance_transmitter | 1..1 | – | – | – |
| – | who | – | One of: patient, practitioner, organization | – | choice |
| patient | who | 1..1 | – | – | member_person |
| practitioner | who | 1..1 | – | – | practitioner |
| organization | who | 1..1 | – | – | organization |
| – | on_behalf_of | – | One of: patient, practitioner, organization | – | choice |
| pulse_oximetry_observation | pulse_oximetry_observations | 1..unbounded | – | – | – |
| unique_identifier | pulse_oximetry_observation | 1..1 | – | – | core:string |
| status | pulse_oximetry_observation | 1..1 | – | – | core:string (enum: registered, preliminary, final, amended, corrected, cancelled, entered-in-error, unknown) |
| category | pulse_oximetry_observation | 1..unbounded | – | – | – |
| category_vs_cat | category | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: vital-signs) |
| system | coding | 1..1 | – | – | core:string (enum: http://terminology.hl7.org/CodeSystem/observation-category) |
| code | pulse_oximetry_observation | 1..1 | Oxygen Saturation by Pulse Oximetry | – | – |
| coding_oxygen_sat_code | coding | 1..1 | – | – | – |
| code | coding_oxygen_sat_code | 1..1 | – | – | core:string (enum: 2708-6) |
| system | coding_oxygen_sat_code | 1..1 | – | – | core:string (enum: http://loinc.org) |
| coding_pulse_ox | coding | 1..1 | – | – | – |
| code | coding_pulse_ox | 1..1 | – | – | core:string (enum: 59408-5) |
| system | coding_pulse_ox | 1..1 | – | – | core:string (enum: http://loinc.org) |
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
| code | coding | 1..1 | – | – | core:string (enum: 3151-8) |
| system | coding | 1..1 | – | – | core:string (enum: http://loinc.org) |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| code | component_concentration | 1..1 | – | – | – |
| coding | code | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: 3150-0) |
| system | coding | 1..1 | – | – | core:string (enum: http://loinc.org) |
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
| status | document_reference | 1..1 | Status of the request | – | core:string (enum: current , superseded, entered-in-error) |
| type | document_reference | 1..1 | – | – | – |
| code | type | 1..1 | – | – | core:string |
| system | type | 1..1 | – | – | core:string (enum: http://terminology.hl7.org/CodeSystem/v3-NullFlavor, http://loinc.org) |
| category | document_reference | 1..unbounded | – | – | – |
| code | category | 1..1 | – | – | core:string |
| – | author | – | One of: patient, practitioner, organization | – | choice |
| content | document_reference | 1..unbounded | – | – | – |
| attachment | content | 1..1 | – | – | – |
| content_type | attachment | 1..1 | – | – | code |
| diagnostic_report_lab | diagnostic_report_labs | 1..unbounded | – | – | – |
| unique_identifier | diagnostic_report_lab | 1..1 | – | – | core:string |
| status | diagnostic_report_lab | 1..1 | – | – | core:string (enum: registered, partial, preliminary, final, amended, corrected, appended, cancelled, entered-in-error, unknown) |
| category | diagnostic_report_lab | 1..unbounded | – | – | – |
| category_laboratory_slice | category | 1..1 | – | – | – |
| coding | category_laboratory_slice | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: LAB) |
| system | coding | 1..1 | – | – | core:string (enum: http://terminology.hl7.org/CodeSystem/v2-0074) |
| code | diagnostic_report_lab | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| system | code | 1..1 | – | – | core:string (enum: http://loinc.org) |
| issued | diagnostic_report_lab | 1..1 | – | – | instant |
| effective | diagnostic_report_lab | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| – | performer | – | One of: reported_practitioner, reported_organization | – | choice |
| diagnostic_report_note | diagnostic_report_notes | 1..unbounded | – | – | – |
| unique_identifier | diagnostic_report_note | 1..1 | – | – | core:string |
| status | diagnostic_report_note | 1..1 | – | – | core:string (enum: registered, partial, preliminary, final, amended, corrected, appended, cancelled, entered-in-error, unknown) |
| category | diagnostic_report_note | 1..unbounded | – | – | – |
| code | category | 1..1 | – | – | core:string (enum: LP29684-5, LP29708-2, LALP7839-6B) |
| system | category | 1..1 | – | – | core:string (enum: http://loinc.org) |
| code | diagnostic_report_note | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| system | code | 1..1 | – | – | core:string (enum: http://loinc.org) |
| effective | diagnostic_report_note | 1..1 | – | – | – |
| – | effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | effective | 1..1 | – | – | dateTime |
| effective_period | effective | 1..1 | – | – | period |
| – | performer | – | One of: reported_practitioner, reported_organization | – | choice |


## All Elements of Clinical XSD

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
| lab_observations | clinical | 0..1 | – | – | – |
| lab_observation | lab_observations | 1..unbounded | – | – | – |
| unique_identifier | lab_observation | 1..1 | – | – | core:string |
| status | lab_observation | 1..1 | Status of the observation | – | core:string (enum: registered, preliminary, final, amended, corrected, cancelled, entered-in-error, unknown) |
| observation_code | lab_observation | 1..1 | Laboratory Test Name [LOINC COdes] | – | codeable_concept |
| observation_effective | lab_observation | 0..1 | – | – | – |
| – | observation_effective | – | One of: effective_date_time, effective_period | – | choice |
| effective_date_time | observation_effective | 0..1 | Clinically relevant time/time-period for observation | – | dateTime |
| effective_period | observation_effective | 0..1 | – | – | period |
| – | lab_observation | – | One of: observation_value, data_absent_reason | – | choice |
| observation_value | lab_observation | 0..1 | Result of the observation | – | result_value |
| data_absent_reason | lab_observation | 0..1 | Reason for missing data. Inputs can be found here: http://hl7.org/fhir/R4/valueset-data-absent-reason.html | – | core:string (enum: unknown, asked-unknown, temp-unknown, not-asked, asked-declined, masked, not-applicable, unsupported, as-text, error, not-a-number, negative-infinity, positive-infinity, not-performed, not-permitted) |
| interpretation | lab_observation | 0..unbounded | A categorical assessment of an observation value. For example, high, low, normal. | – | core:string |
| reference_range | lab_observation | 0..unbounded | Guidance on how to interpret the value by comparison to a normal or recommended range. Multiple reference ranges are interpreted as an "OR". In other words, to represent two distinct target populations, two referenceRange elements would be used. | – | – |
| low | reference_range | 0..1 | – | – | simple_quantity |
| high | reference_range | 0..1 | – | – | simple_quantity |
| type | reference_range | 0..1 | – | – | core:string (enum: normal, recommended, treatment, therapeutic, pre_therapeutic, post_therapeutic, endocrine, pre-puberty, follicular, midcycle, luteal, postmenopausal) |
| applies_to | reference_range | 0..1 | – | – | codeable_concept |
| age | reference_range | 0..1 | – | – | range |
| text | reference_range | 0..1 | – | – | core:string |
| record_type | lab_observation | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| allergy_intolerances | clinical | 0..1 | – | – | – |
| allergy_intolerance | allergy_intolerances | 1..unbounded | – | – | – |
| unique_identifier | allergy_intolerance | 1..1 | – | – | core:string |
| clinical_status | allergy_intolerance | 0..1 | The clinical status of the allergy or intolerance. | – | core:string (enum: active, inactive, resolved) |
| verification_status | allergy_intolerance | 0..1 | Assertion about certainty associated with the propensity, or potential risk, of a reaction to the identified substance (including pharmaceutical product). | – | core:string (enum: unconfirmed, confirmed, refuted, entered-in-error) |
| type | allergy_intolerance | 0..1 | Identification of the underlying physiological mechanism for the reaction risk. | – | core:string (enum: allergy, intolerance) |
| category | allergy_intolerance | 0..unbounded | The category of the allergy from the type of allergen item. | – | core:string (enum: food, medication, environment, biologic) |
| allergy_code | allergy_intolerance | 1..1 | Code for an allergy or intolerance statement (either a positive or a negated/excluded statement). This may be a code for a substance or pharmaceutical product that is considered to be responsible for the adverse reaction risk (e.g., "Latex"), an allergy or intolerance condition (e.g., "Latex allergy"), or a negated/excluded code for a specific substance or class (e.g., "No latex allergy") or a general or categorical negated statement (e.g., "No known allergy", "No known drug allergies"). | – | – |
| code | allergy_code | 1..1 | – | – | core:string |
| system | allergy_code | 1..1 | – | – | core:string (enum: http://snomed.info/sct, http://www.nlm.nih.gov/research/umls/rxnorm) |
| reactions | allergy_intolerance | 0..1 | – | – | – |
| reaction | reactions | 0..unbounded | Details about each adverse reaction event linked to exposure to the identified substance. | – | – |
| manifestation | reaction | 1..unbounded | Clinical symptoms and/or signs that are observed or associated with the adverse reaction event. | – | core:string |
| onset | allergy_intolerance | 0..1 | When allergy or intolerance was identified | – | onset |
| criticality | allergy_intolerance | 0..1 | Estimate of the potential clinical harm, or seriousness, of the reaction to the identified substance. | – | core:string (enum: low, high, unable-to-assess) |
| recorded_date | allergy_intolerance | 0..1 | The recordedDate represents when this particular AllergyIntolerance record was created in the system, which is often a system-generated date. | – | dateTime |
| record_type | allergy_intolerance | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| conditions | clinical | 0..1 | – | – | – |
| condition | conditions | 1..unbounded | – | – | – |
| unique_identifier | condition | 1..1 | – | – | core:string |
| condition_code | condition | 1..1 | Identification of the condition, problem or diagnosis. A detailed list of codes can be found here http://hl7.org/fhir/us/core/ValueSet-us-core-condition-code.html | – | – |
| code | condition_code | 1..1 | – | – | core:string |
| system | condition_code | 1..1 | – | – | core:string (enum: http://snomed.info/sct, http://hl7.org/fhir/sid/icd-10-cm, http://hl7.org/fhir/sid/icd-9-cm) |
| category | condition | 1..unbounded | Identification of the condition, problem or diagnosis | – | core:string (enum: problem-list-item, encounter-diagnosis, health-concern) |
| clinical_status | condition | 0..1 | Preferred value set for Condition Clinical Status | – | core:string (enum: active, recurrence, relapse, inactive, remission, resolved) |
| verification_status | condition | 0..1 | The verification status to support or decline the clinical status of the condition or diagnosis. | – | core:string (enum: unconfirmed, provisional, differential, confirmed, refuted, entered-in-error) |
| severity | condition | 0..1 | Subjective severity of condition | – | core:string (enum: severe, moderate, mild) |
| onset | condition | 0..1 | Estimated or actual date, date-time, or age | – | onset |
| recorded_date | condition | 0..1 | Date of when condition was first recorded,The recordedDate represents when this particular Condition record was created in the system, which is often a system-generated date. | – | dateTime |
| abatement | condition | 0..1 | The date or estimated date that the condition resolved or went into remission. This is called "abatement" because of the many overloaded connotations associated with "remission" or "resolution" - Conditions are never really resolved, but they can abate. | – | abatement |
| record_type | condition | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| procedures | clinical | 0..1 | – | – | – |
| procedure | procedures | 1..unbounded | – | – | – |
| unique_identifier | procedure | 1..1 | – | – | core:string |
| procedure_code | procedure | 1..1 | - Procedure codes from SNOMED CT, CPT, HCPCS II, ICD-10-PCS, or CDT. - HCPCS Level II Alphanumeric Codes are maintained by CMS and are available for public use. - Refer to urn:oid:2.16.840.1.113883.6.285 for HCPCS Level II codes. | – | – |
| – | procedure_code | – | All of (any order): code, system | – | sequence |
| code | procedure_code | 1..1 | – | – | xs:string |
| system | procedure_code | 1..1 | – | – | xs:string (enum: http://www.ama-assn.org/go/cpt, http://snomed.info/sct, http://www.cms.gov/Medicare/Coding/ICD10, http://terminology.hl7.org/CodeSystem/CD2, urn:oid:2.16.840.1.113883.6.285) |
| – | procedure_code | – | All of (any order): text, extension | – | sequence |
| text | procedure_code | 1..1 | – | – | xs:string |
| extension | procedure_code | 1..unbounded | – | – | – |
| url | extension | 1..1 | – | – | xs:anyURI |
| valueCode | extension | 1..1 | – | – | xs:string |
| status | procedure | 1..1 | A code specifying the state of the procedure. Generally, this will be the in-progress or completed state. | – | core:string (enum: preparation, in-progress, not-done, on-hold, stopped, completed, entered-in-error, unknown) |
| performed | procedure | 1..1 | Estimated or actual date, date-time, period, or age when the procedure was performed. Allows a period to support complex procedures that span more than one date, and also allows for the length of the procedure to be captured. | – | – |
| – | performed | – | One of: performed_date_time, performed_period | – | choice |
| performed_date_time | performed | 0..1 | – | – | dateTime |
| performed_period | performed | 0..1 | – | – | period |
| record_type | procedure | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| medication_requests | clinical | 0..1 | – | – | – |
| medication_request | medication_requests | 1..unbounded | – | – | – |
| unique_identifier | medication_request | 1..1 | – | – | core:string |
| status | medication_request | 1..1 | Status of the request | – | core:string (enum: active, on-hold, cancelled, completed, entered-in-error, stopped, draft, unknown) |
| intent | medication_request | 1..1 | Intent of the request | – | core:string (enum: proposal, plan, order, original-order, reflex-order, filler-order, instance-order, option) |
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
| system | medication_code | 1..1 | – | – | core:string (enum: http://www.nlm.nih.gov/research/umls/rxnorm) |
| status | medication | 0..1 | Status of the request | – | core:string (enum: active, inactive, entered-in-error) |
| form | medication | 0..1 | – | – | – |
| code | form | 1..1 | – | – | core:string |
| system | form | 1..1 | – | – | core:string (enum: http://snomed.info/sct) |
| encounter | medication_request | 0..1 | – | – | encounter |
| authored_on | medication_request | 1..1 | – | – | dateTime |
| requester | medication_request | 0..1 | – | – | – |
| – | requester | – | One of: patient, practitioner, organization | – | choice |
| patient | requester | 1..1 | – | – | member_person |
| practitioner | requester | 1..1 | – | – | practitioner |
| organization | requester | 1..1 | – | – | organization |
| dosage_instruction | medication_request | 0..unbounded | – | – | – |
| text | dosage_instruction | 0..1 | – | – | core:string |
| record_type | medication_request | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| care_teams | clinical | 0..1 | – | – | – |
| care_team | care_teams | 1..unbounded | – | – | – |
| unique_identifier | care_team | 1..1 | – | – | core:string |
| status | care_team | 0..1 | – | – | core:string (enum: proposed, active, suspended, inactive, entered-in-error) |
| participant | care_team | 1..unbounded | – | – | – |
| role | participant | 1..unbounded | Type of involvement Include all codes defined in http://nucc.org/provider-taxonomy Include codes from http://snomed.info/sct where concept is-a 223366009 (Healthcare professional) Include codes from http://snomed.info/sct where concept is-a 224930009 (Services) | – | – |
| code | role | 1..1 | – | – | core:string |
| system | role | 1..1 | – | – | core:string (enum: http://nucc.org/provider-taxonomy, http://snomed.info/sct) |
| member | participant | 1..1 | – | – | – |
| – | member | – | One of: member_person, reference | – | choice |
| member_person | member | 1..1 | – | – | xs:string |
| reference | member | 1..1 | – | – | reference |
| record_type | care_team | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| observation_vital_signs | clinical | 0..1 | – | – | – |
| observation_vital_sign | observation_vital_signs | 1..unbounded | – | – | – |
| unique_identifier | observation_vital_sign | 1..1 | – | – | core:string |
| status | observation_vital_sign | 1..1 | – | – | core:string (enum: registered, preliminary, final, amended, corrected, cancelled, entered-in-error, unknown) |
| category_vs_cat | observation_vital_sign | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: vital-signs) |
| system | coding | 1..1 | – | – | core:string (enum: http://terminology.hl7.org/CodeSystem/observation-category) |
| code | observation_vital_sign | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string (enum: 85353-1, 9279-1, 8867-4, 2708-6, 8310-5, 8302-2, 9843-4, 29463-7, 39156-5, 85354-9, 8480-6, 8462-4, 8478-0) |
| display | code | 0..1 | – | – | core:string (enum: Vital signs,weight,height,head circumference,oxygen saturation and BMI panel, Respiratory rate, Heart rate, Oxygen saturation in Arterial blood, Body temperature, Body height, Head Occipital-frontal circumference, Body weight, Body mass index (BMI) [Ratio], Blood pressure panel with all children optional, Systolic blood pressure, Diastolic blood pressure, Mean blood pressure) |
| system | code | 0..1 | – | – | core:string (enum: http://loinc.org) |
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
| code | coding_sbp_code | 1..1 | – | – | core:string (enum: 8480-6) |
| system | coding_sbp_code | 1..1 | – | – | core:string (enum: http://loinc.org) |
| value | component_systolic_bp | 0..1 | – | – | quantity_bp_systolic |
| data_absent_reason | component_systolic_bp | 0..1 | Why the component result is missing | – | – |
| coding | data_absent_reason | 0..1 | – | – | – |
| code | coding | 0..1 | – | – | core:string |
| system | coding | 0..1 | – | – | core:string |
| component_diastolic_bp | component | 1..1 | – | – | – |
| code | component_diastolic_bp | 1..1 | – | – | – |
| coding_dbp_code | code | 1..1 | – | – | – |
| code | coding_dbp_code | 1..1 | – | – | core:string (enum: 8462-4) |
| system | coding_dbp_code | 1..1 | – | – | core:string (enum: http://loinc.org) |
| value | component_diastolic_bp | 0..1 | – | – | quantity_bp_diastolic |
| data_absent_reason | component_diastolic_bp | 0..1 | – | – | – |
| coding | data_absent_reason | 0..1 | – | – | – |
| code | coding | 0..1 | – | – | core:string |
| system | coding | 0..1 | – | – | core:string |
| record_type | observation_vital_sign | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| practitioners | clinical | 0..1 | – | – | – |
| practitioner | practitioners | 1..unbounded | – | – | – |
| unique_identifier | practitioner | 1..1 | – | – | core:string |
| practitioner_details | practitioner | 1..1 | – | – | practitioner |
| record_type | practitioner | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| organizations | clinical | 0..1 | – | – | – |
| organization | organizations | 1..unbounded | – | – | – |
| unique_identifier | organization | 1..1 | – | – | core:string |
| organization_details | organization | 1..1 | – | – | organization |
| record_type | organization | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| locations | clinical | 0..1 | – | – | – |
| location | locations | 1..unbounded | – | – | – |
| unique_identifier | location | 1..1 | – | – | core:string |
| location_details | location | 1..1 | – | – | location |
| record_type | location | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| encounters | clinical | 0..1 | – | – | – |
| encounter | encounters | 1..unbounded | – | – | – |
| unique_identifier | encounter | 1..1 | – | – | core:string |
| encounter_details | encounter | 1..1 | – | – | encounter |
| record_type | encounter | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| care_plans | clinical | 0..1 | – | – | – |
| care_plan | care_plans | 1..unbounded | – | – | – |
| unique_identifier | care_plan | 1..1 | – | – | core:string |
| text | care_plan | 1..1 | – | – | – |
| status | text | 1..1 | – | – | core:string (enum: additional, generated) |
| div | text | 1..1 | The actual narrative content, a stripped down version of XHTML.The contents of the html element are an XHTML fragment containing only the basic html formatting elements described in chapters 7-11 and 15 of the HTML 4.0 standard, elements (either name or href), images and internally contained stylesheets. The XHTML content SHALL NOT contain a head, a body, external stylesheet references, scripts, forms, base/link/xlink, frames, iframes and objects. Example: | – | core:string |
| status | care_plan | 1..1 | – | – | core:string (enum: draft, active, on-hold, revoked, completed, entered-in-error, unknown) |
| intent | care_plan | 1..1 | – | – | core:string (enum: proposal, plan, order, option) |
| category | care_plan | 1..unbounded | Type of plan | – | – |
| category_assess_plan | category | 1..1 | – | – | – |
| coding | category_assess_plan | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: assess-plan) |
| system | coding | 1..1 | – | – | core:string (enum: http://hl7.org/fhir/us/core/CodeSystem/careplan-category) |
| record_type | care_plan | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| goals | clinical | 0..1 | – | – | – |
| goal | goals | 1..unbounded | – | – | – |
| unique_identifier | goal | 1..1 | – | – | core:string |
| lifecycle_status | goal | 1..1 | – | – | core:string (enum: proposed, planned, accepted, active, on-hold, completed, cancelled, entered-in-error, rejected) |
| description | goal | 1..1 | – | – | – |
| code | description | 1..1 | – | – | core:string |
| system | description | 0..1 | – | – | – |
| target | goal | 0..unbounded | – | – | – |
| due_date | target | 0..1 | – | – | date |
| record_type | goal | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| immunizations | clinical | 0..1 | – | – | – |
| immunization | immunizations | 1..unbounded | – | – | – |
| unique_identifier | immunization | 1..1 | – | – | core:string |
| status | immunization | 1..1 | – | – | core:string (enum: completed, entered-in-error, not-done) |
| status_reason | immunization | 0..1 | – | – | – |
| code | status_reason | 0..1 | – | – | core:string |
| system | status_reason | 0..1 | – | – | – |
| vaccine_code | immunization | 1..1 | – | – | – |
| code | vaccine_code | 1..1 | – | – | core:string |
| system | vaccine_code | 1..1 | – | – | core:string (enum: http://hl7.org/fhir/sid/cvx) |
| occurrence | immunization | 1..1 | – | – | – |
| – | occurrence | – | One of: occurrence_date_time, occurrence_string | – | choice |
| occurrence_date_time | occurrence | 1..1 | – | – | dateTime |
| occurrence_string | occurrence | 1..1 | – | – | core:string |
| primary_source | immunization | 1..1 | – | – | xs:boolean |
| record_type | immunization | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| pediatric_bmi_for_age_observations | clinical | 0..1 | – | – | – |
| pediatric_bmi_for_age_observation | pediatric_bmi_for_age_observations | 1..unbounded | – | – | – |
| unique_identifier | pediatric_bmi_for_age_observation | 1..1 | – | – | core:string |
| status | pediatric_bmi_for_age_observation | 1..1 | – | – | core:string (enum: registered, preliminary, final, amended, corrected, cancelled, entered-in-error, unknown) |
| category | pediatric_bmi_for_age_observation | 1..unbounded | – | – | – |
| category_vs_cat | category | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: vital-signs) |
| system | coding | 1..1 | – | – | core:string (enum: http://terminology.hl7.org/CodeSystem/observation-category) |
| code | pediatric_bmi_for_age_observation | 1..1 | BMI percentile per age and sex for youth 2-20 | – | – |
| coding | code | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: 59576-9) |
| system | coding | 1..1 | – | – | core:string (enum: http://loinc.org) |
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
| code | data_absent_reason | 0..1 | – | – | core:string (enum: unknown, asked-unknown, temp-unknown, not-asked, asked-declined, masked, not-applicable, unsupported, as-text, error, not-a-number, negative-infinity, positive-infinity, not-performed, not-permitted) |
| system | data_absent_reason | 0..1 | – | – | core:string |
| component | pediatric_bmi_for_age_observation | 0..unbounded | – | – | – |
| code | component | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string (enum: 85353-1, 9279-1, 8867-4, 2708-6, 8310-5, 8302-2, 9843-4, 29463-7, 39156-5, 85354-9, 8480-6, 8462-4, 8478-0) |
| system | code | 0..1 | – | – | core:string (enum: http://loinc.org) |
| value | component | 0..1 | – | – | result_value |
| data_absent_reason | component | 0..1 | – | – | – |
| code | data_absent_reason | 0..1 | – | – | core:string (enum: unknown, asked-unknown, temp-unknown, not-asked, asked-declined, masked, not-applicable, unsupported, as-text, error, not-a-number, negative-infinity, positive-infinity, not-performed, not-permitted) |
| system | data_absent_reason | 0..1 | – | – | core:string |
| record_type | pediatric_bmi_for_age_observation | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| pediatric_head_occipital_frontal_circumference_observations | clinical | 0..1 | – | – | – |
| pediatric_head_occipital_frontal_circumference_observation | pediatric_head_occipital_frontal_circumference_observations | 1..unbounded | – | – | – |
| unique_identifier | pediatric_head_occipital_frontal_circumference_observation | 1..1 | – | – | core:string |
| status | pediatric_head_occipital_frontal_circumference_observation | 1..1 | – | – | core:string (enum: registered, preliminary, final, amended, corrected, cancelled, entered-in-error, unknown) |
| category | pediatric_head_occipital_frontal_circumference_observation | 1..unbounded | – | – | – |
| category_vs_cat | category | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: vital-signs) |
| system | coding | 1..1 | – | – | core:string (enum: http://terminology.hl7.org/CodeSystem/observation-category) |
| code | pediatric_head_occipital_frontal_circumference_observation | 1..1 | Head Occipital-frontal circumference Percentile | – | – |
| coding | code | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: 8289-1) |
| system | coding | 1..1 | – | – | core:string (enum: http://loinc.org) |
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
| code | data_absent_reason | 0..1 | – | – | core:string (enum: unknown, asked-unknown, temp-unknown, not-asked, asked-declined, masked, not-applicable, unsupported, as-text, error, not-a-number, negative-infinity, positive-infinity, not-performed, not-permitted) |
| system | data_absent_reason | 0..1 | – | – | core:string |
| component | pediatric_head_occipital_frontal_circumference_observation | 0..unbounded | – | – | – |
| code | component | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string (enum: 85353-1, 9279-1, 8867-4, 2708-6, 8310-5, 8302-2, 9843-4, 29463-7, 39156-5, 85354-9, 8480-6, 8462-4, 8478-0) |
| system | code | 0..1 | – | – | core:string (enum: http://loinc.org) |
| value | component | 0..1 | – | – | result_value |
| data_absent_reason | component | 0..1 | – | – | – |
| code | data_absent_reason | 0..1 | – | – | core:string (enum: unknown, asked-unknown, temp-unknown, not-asked, asked-declined, masked, not-applicable, unsupported, as-text, error, not-a-number, negative-infinity, positive-infinity, not-performed, not-permitted) |
| system | data_absent_reason | 0..1 | – | – | core:string |
| record_type | pediatric_head_occipital_frontal_circumference_observation | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| pediatric_weight_for_height_observations | clinical | 0..1 | – | – | – |
| pediatric_weight_for_height_observation | pediatric_weight_for_height_observations | 1..unbounded | – | – | – |
| unique_identifier | pediatric_weight_for_height_observation | 1..1 | – | – | core:string |
| status | pediatric_weight_for_height_observation | 1..1 | – | – | core:string (enum: registered, preliminary, final, amended, corrected, cancelled, entered-in-error, unknown) |
| category | pediatric_weight_for_height_observation | 1..unbounded | – | – | – |
| category_vs_cat | category | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: vital-signs) |
| system | coding | 1..1 | – | – | core:string (enum: http://terminology.hl7.org/CodeSystem/observation-category) |
| code | pediatric_weight_for_height_observation | 1..1 | Weight-for-length per age and gender | – | – |
| coding | code | 0..unbounded | – | – | – |
| code | coding | 1..unbounded | – | – | core:string (enum: 77606-2) |
| system | coding | 1..1 | – | – | core:string (enum: http://loinc.org) |
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
| code | data_absent_reason | 0..1 | – | – | core:string (enum: unknown, asked-unknown, temp-unknown, not-asked, asked-declined, masked, not-applicable, unsupported, as-text, error, not-a-number, negative-infinity, positive-infinity, not-performed, not-permitted) |
| system | data_absent_reason | 0..1 | – | – | core:string |
| component | pediatric_weight_for_height_observation | 0..unbounded | – | – | – |
| code | component | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string (enum: 85353-1, 9279-1, 8867-4, 2708-6, 8310-5, 8302-2, 9843-4, 29463-7, 39156-5, 85354-9, 8480-6, 8462-4, 8478-0) |
| system | code | 0..1 | – | – | core:string (enum: http://loinc.org) |
| value | component | 0..1 | – | – | result_value |
| data_absent_reason | component | 0..1 | – | – | – |
| code | data_absent_reason | 0..1 | – | – | core:string (enum: unknown, asked-unknown, temp-unknown, not-asked, asked-declined, masked, not-applicable, unsupported, as-text, error, not-a-number, negative-infinity, positive-infinity, not-performed, not-permitted) |
| system | data_absent_reason | 0..1 | – | – | core:string |
| record_type | pediatric_weight_for_height_observation | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| practitioners_roles | clinical | 0..1 | – | – | – |
| practitioner_role | practitioners_roles | 1..unbounded | – | – | – |
| unique_identifier | practitioner_role | 1..1 | – | – | core:string |
| practitioner | practitioner_role | 1..1 | – | – | practitioner |
| organization | practitioner_role | 1..1 | – | – | organization |
| code | practitioner_role | 0..unbounded | – | – | – |
| code | code | 0..1 | – | – | core:string |
| system | code | 0..1 | – | – | core:string (enum: http://nucc.org/provider-taxonomy) |
| specialty | practitioner_role | 0..unbounded | – | – | – |
| code | specialty | 0..1 | – | – | core:string |
| system | specialty | 0..1 | – | – | core:string (enum: http://nucc.org/provider-taxonomy) |
| location | practitioner_role | 0..unbounded | – | – | location |
| telecom | practitioner_role | 0..unbounded | – | – | telecom |
| endpoints | practitioner_role | 0..unbounded | – | – | endpoint |
| record_type | practitioner_role | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| smoking_status_observations | clinical | 0..1 | – | – | – |
| smoking_status_observation | smoking_status_observations | 1..unbounded | – | – | – |
| unique_identifier | smoking_status_observation | 1..1 | – | – | core:string |
| status | smoking_status_observation | 1..1 | – | – | core:string (enum: final, entered-in-error) |
| code | smoking_status_observation | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string (enum: 72166-2) |
| system | code | 1..1 | – | – | core:string (enum: http://loinc.org) |
| issued | smoking_status_observation | 1..1 | – | – | instant |
| value_codeable_concept | smoking_status_observation | 1..1 | – | – | – |
| code | value_codeable_concept | 1..1 | – | – | – |
| system | value_codeable_concept | 0..1 | – | – | core:string (enum: http://snomed.info/sct) |
| record_type | smoking_status_observation | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| provenances | clinical | 0..1 | – | – | – |
| provenance | provenances | 1..unbounded | – | – | – |
| unique_identifier | provenance | 1..1 | – | – | core:string |
| target | provenance | 1..unbounded | – | – | – |
| resource_type | target | 1..1 | – | – | core:string (enum: allergy_intolerance, care_plan, care_team, condition, diagnostic_report_lab, diagnostic_report_note, document_reference, encounter, goal, immunization, implantable_device, lab_observation, medication_request, patient, pediatric_bmi_for_age_observation, pediatric_weight_for_height_observation, procedure, pulse_oximetry_observation, smoking_status_observation, observation_vital_sign) |
| unique_identifier | target | 1..1 | – | – | core:string |
| recorded | provenance | 1..1 | – | – | instant |
| agent | provenance | 1..unbounded | – | – | – |
| agent_provenance_general | agent | 0..unbounded | – | – | – |
| type | agent_provenance_general | 0..1 | – | – | – |
| code | type | 0..1 | – | – | core:string (enum: transmitter, enterer, performer, author, verifier, legal, attester, informant, custodian, assembler, composer) |
| system | type | 0..1 | – | – | core:string (enum: http://hl7.org/fhir/us/core/CodeSystem/us-core-provenance-participant-type, http://terminology.hl7.org/CodeSystem/provenance-participant-type) |
| who | agent_provenance_general | 1..1 | – | – | – |
| – | who | – | One of: patient, practitioner, organization | – | choice |
| patient | who | 1..1 | – | – | member_person |
| practitioner | who | 1..1 | – | – | practitioner |
| organization | who | 1..1 | – | – | organization |
| on_behalf_of | agent_provenance_general | 0..1 | – | – | organization |
| agent_provenance_author | agent | 0..unbounded | – | – | – |
| type | agent_provenance_author | 1..1 | – | – | – |
| coding | type | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: author) |
| system | coding | 1..1 | – | – | core:string (enum: http://terminology.hl7.org/CodeSystem/provenance-participant-type) |
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
| code | coding | 1..1 | – | – | core:string (enum: transmitter) |
| system | coding | 1..1 | – | – | core:string (enum: http://hl7.org/fhir/us/core/CodeSystem/us-core-provenance-participant-type) |
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
| record_type | provenance | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| pulse_oximetry_observations | clinical | 0..1 | – | – | – |
| pulse_oximetry_observation | pulse_oximetry_observations | 1..unbounded | – | – | – |
| unique_identifier | pulse_oximetry_observation | 1..1 | – | – | core:string |
| status | pulse_oximetry_observation | 1..1 | – | – | core:string (enum: registered, preliminary, final, amended, corrected, cancelled, entered-in-error, unknown) |
| category | pulse_oximetry_observation | 1..unbounded | – | – | – |
| category_vs_cat | category | 1..1 | – | – | – |
| coding | category_vs_cat | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: vital-signs) |
| system | coding | 1..1 | – | – | core:string (enum: http://terminology.hl7.org/CodeSystem/observation-category) |
| code | pulse_oximetry_observation | 1..1 | Oxygen Saturation by Pulse Oximetry | – | – |
| coding | code | 0..unbounded | – | – | – |
| coding_oxygen_sat_code | coding | 1..1 | – | – | – |
| code | coding_oxygen_sat_code | 1..1 | – | – | core:string (enum: 2708-6) |
| system | coding_oxygen_sat_code | 1..1 | – | – | core:string (enum: http://loinc.org) |
| coding_pulse_ox | coding | 1..1 | – | – | – |
| code | coding_pulse_ox | 1..1 | – | – | core:string (enum: 59408-5) |
| system | coding_pulse_ox | 1..1 | – | – | core:string (enum: http://loinc.org) |
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
| code | data_absent_reason | 0..1 | – | – | core:string (enum: unknown, asked-unknown, temp-unknown, not-asked, asked-declined, masked, not-applicable, unsupported, as-text, error, not-a-number, negative-infinity, positive-infinity, not-performed, not-permitted) |
| system | data_absent_reason | 0..1 | – | – | core:string |
| component | pulse_oximetry_observation | 0..unbounded | Used when reporting systolic and diastolic blood pressure. | – | – |
| component_flow_rate | component | 0..1 | – | – | – |
| code | component_flow_rate | 1..1 | – | – | – |
| coding | code | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: 3151-8) |
| system | coding | 1..1 | – | – | core:string (enum: http://loinc.org) |
| value_quantity | component_flow_rate | 0..1 | Vital Sign Value recorded with UCUM | – | – |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| comparator | value_quantity | 0..1 | – | – | code |
| data_absent_reason | component_flow_rate | 0..1 | – | – | – |
| code | data_absent_reason | 0..1 | – | – | core:string (enum: unknown, asked-unknown, temp-unknown, not-asked, asked-declined, masked, not-applicable, unsupported, as-text, error, not-a-number, negative-infinity, positive-infinity, not-performed, not-permitted) |
| system | data_absent_reason | 0..1 | – | – | core:string |
| component_concentration | component | 0..1 | – | – | – |
| code | component_concentration | 1..1 | – | – | – |
| coding | code | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: 3150-0) |
| system | coding | 1..1 | – | – | core:string (enum: http://loinc.org) |
| value_quantity | component_concentration | 0..1 | Vital Sign Value recorded with UCUM | – | – |
| value | value_quantity | 1..1 | – | – | decimal |
| unit | value_quantity | 1..1 | – | – | core:string |
| system | value_quantity | 1..1 | – | – | core:string |
| code | value_quantity | 1..1 | – | – | core:string |
| comparator | value_quantity | 0..1 | – | – | code |
| data_absent_reason | component_concentration | 0..1 | – | – | – |
| code | data_absent_reason | 0..1 | – | – | core:string (enum: unknown, asked-unknown, temp-unknown, not-asked, asked-declined, masked, not-applicable, unsupported, as-text, error, not-a-number, negative-infinity, positive-infinity, not-performed, not-permitted) |
| system | data_absent_reason | 0..1 | – | – | core:string |
| record_type | pulse_oximetry_observation | 0..1 | This element describes the action for this profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
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
| system | type | 0..1 | – | – | core:string (enum: http://snomed.info/sct) |
| record_type | implantable_device | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| document_references | clinical | 0..1 | – | – | – |
| document_reference | document_references | 1..unbounded | – | – | – |
| unique_identifier | document_reference | 1..1 | – | – | core:string |
| status | document_reference | 1..1 | Status of the request | – | core:string (enum: current , superseded, entered-in-error) |
| type | document_reference | 1..1 | – | – | – |
| code | type | 1..1 | – | – | core:string |
| system | type | 1..1 | – | – | core:string (enum: http://terminology.hl7.org/CodeSystem/v3-NullFlavor, http://loinc.org) |
| category | document_reference | 1..unbounded | – | – | – |
| code | category | 1..1 | – | – | core:string |
| system | category | 0..1 | – | – | core:string (enum: http://hl7.org/fhir/us/core/CodeSystem/us-core-documentreference-category) |
| author | document_reference | 0..unbounded | – | – | – |
| – | author | – | One of: patient, practitioner, organization | – | choice |
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
| system | format | 0..1 | – | – | core:string (enum: http://ihe.net/fhir/ValueSet/IHE.FormatCode.codesystem) |
| context | document_reference | 0..1 | – | – | – |
| encounter | context | 0..1 | – | – | encounter |
| period | context | 0..1 | – | – | period |
| record_type | document_reference | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| diagnostic_report_labs | clinical | 0..1 | – | – | – |
| diagnostic_report_lab | diagnostic_report_labs | 1..unbounded | – | – | – |
| unique_identifier | diagnostic_report_lab | 1..1 | – | – | core:string |
| status | diagnostic_report_lab | 1..1 | – | – | core:string (enum: registered, partial, preliminary, final, amended, corrected, appended, cancelled, entered-in-error, unknown) |
| category | diagnostic_report_lab | 1..unbounded | – | – | – |
| category_laboratory_slice | category | 1..1 | – | – | – |
| coding | category_laboratory_slice | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string (enum: LAB) |
| system | coding | 1..1 | – | – | core:string (enum: http://terminology.hl7.org/CodeSystem/v2-0074) |
| code | diagnostic_report_lab | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| system | code | 1..1 | – | – | core:string (enum: http://loinc.org) |
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
| record_type | diagnostic_report_lab | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |
| diagnostic_report_notes | clinical | 0..1 | – | – | – |
| diagnostic_report_note | diagnostic_report_notes | 1..unbounded | – | – | – |
| unique_identifier | diagnostic_report_note | 1..1 | – | – | core:string |
| status | diagnostic_report_note | 1..1 | – | – | core:string (enum: registered, partial, preliminary, final, amended, corrected, appended, cancelled, entered-in-error, unknown) |
| category | diagnostic_report_note | 1..unbounded | – | – | – |
| code | category | 1..1 | – | – | core:string (enum: LP29684-5, LP29708-2, LALP7839-6B) |
| system | category | 1..1 | – | – | core:string (enum: http://loinc.org) |
| code | diagnostic_report_note | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| system | code | 1..1 | – | – | core:string (enum: http://loinc.org) |
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
| record_type | diagnostic_report_note | 0..1 | This element describes the action for this Profile (A = Add, U = Update, D = Delete) | – | core:string (enum: A, U, D) |


## Practical Guidance

### Submission Frequency

Clinical files should be submitted according to the schedule agreed upon with HealthLX. Typical submission frequencies include daily, weekly, or monthly updates.

### Adds, Updates, and Deletes

- **Adds**: Include new member records with all required fields populated
- **Updates**: Submit complete member records with updated information
- **Deletes**: Follow the agreed-upon process for member terminations or removals

### Member Identification

Each member must be uniquely identified using the appropriate identifier fields. Ensure consistency in member identifiers across all submissions to maintain data integrity.

