![HLX Logo](../assets/hlx_logo.png)

# Formulary Implementation Guide

**HLX0123 HLX Formulary IG (XSD_V10.0)**

**Version 10.0**

**December 22, 2025**

**Table of Contents**

1. [Overview](#overview)
2. [Encoding](#encoding)
3. [Interoperability](#interoperability)
4. [Change Log](#change-log)
5. [Simple Types](#simple-types)
6. [Complex Types](#complex-types)
7. [Required Elements of Formulary XSD](#required-elements-of-formulary-xsd)
8. [All Elements of Formulary XSD](#all-elements-of-formulary-xsd)
9. [Practical Guidance](#practical-guidance)

## Disclaimer

This document is provided by HealthLX for informational purposes only. Information within this document is believed to be correct as of the noted date of publication. Although HealthLX makes every reasonable effort to present information in a timely and accurate manner, HealthLX does not warrant this information for accuracy, completeness or fitness for any purpose, express or implied. The information provided herein does not constitute the rendering of legal, financial or other professional advice or recommendations by HealthLX.

## Overview

This implementation guide provides field mappings and requirements for HealthLX Formulary data submissions in XML format based on FHIR R4 standards. XML format enables structured data exchange with built-in validation against the provided XSD schema.

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
| string | xs:string | – | – | Pattern: [ \r\n\t\S]+ |
| decimal | xs:decimal | – | – | Pattern: -?(0\|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)? |
| boolean | xs:boolean | – | – | Pattern: true\|false |
| date | xs:date | – | – | Pattern: ([12]\d{3}-(0[1-9]\|1[0-2])-(0[1-9]\|[12]\d\|3[01])) |
| dateTime | xs:string | – | – | Pattern: ([12]\d{3})-(0[1-9]\|1[0-2])-(0[1-9]\|[1-2][0-9]\|3[0-1])(T([01][0-9]\|2[0-3]):[0-5][0-9]:[0-5][0-9](\.\d{1,6})?((Z\|(\+\|-)((0[0-9]\|1[0-3]):(00\|15\|30\|45)\|14:00))?))? |
| currency | string | – | AED, AFN, ALL, AMD, ANG, AOA, ARS, AUD, AWG, AZN, BAM, BBD, BDT, BGN, BHD, BIF, BMD, BND, BOB, BOV, BRL, BSD, BTN, BWP, BYN, BZD, CAD, CDF, CHE, CHF, CHW, CLF, CLP, CNY, COP, COU, CRC, CUC, CUP, CVE, CZK, DJF, DKK, DOP, DZD, EGP, ERN, ETB, EUR, FJD, FKP, GBP, GEL, GGP, GHS, GIP, GMD, GNF, GTQ, GYD, HKD, HNL, HRK, HTG, HUF, IDR, ILS, IMP, INR, IQD, IRR, ISK, JEP, JMD, JOD, JPY, KES, KGS, KHR, KMF, KPW, KRW, KWD, KYD, KZT, LAK, LBP, LKR, LRD, LSL, LYD, MAD, MDL, MGA, MKD, MMK, MNT, MOP, MRU, MUR, MVR, MWK, MXN, MXV, MYR, MZN, NAD, NGN, NIO, NOK, NPR, NZD, OMR, PAB, PEN, PGK, PHP, PKR, PLN, PYG, QAR, RON, RSD, RUB, RWF, SAR, SBD, SCR, SDG, SEK, SGD, SHP, SLL, SOS, SRD, SSP, STN, SVC, SYP, SZL, THB, TJS, TMT, TND, TOP, TRY, TTD, TVD, TWD, TZS, UAH, UGX, USD, USN, UYI, UYU, UZS, VEF, VND, VUV, WST, XAF, XAG, XAU, XBA, XBB, XBC, XBD, XCD, XDR, XOF, XPD, XPF, XPT, XSU, XTS, XUA, XXX, YER, ZAR, ZMW, ZWL | – |


## Complex Types

### quantity

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 0 | 1 | – |
| comparator | xs:string (enum: <, <=, >=, >) | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | string | 0 | 1 | Unit representation (e.g. mcg) |
| system | string | 0 | 1 | The URI of the system that defines the coded unit form |
| code | string | 0 | 1 | Coded form of the unit |


### formulary_drugs

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| formulary_drug | – | 1 | unbounded | – |
| rx_norm_code | – | 1 | 1 | A list of RxNorm Codes can be found here: http://hl7.org/fhir/us/core/STU3/ValueSet-us-core-medication-codes.html |
| code | string | 1 | 1 | – |
| display | string | 1 | 1 | – |
| system | string (enum: http://www.nlm.nih.gov/research/umls/rxnorm) | 1 | 1 | – |
| status | string (enum: active, inactive, entered-in-error) | 0 | 1 | Status of medication. Status options can be found here: http://hl7.org/fhir/R4/valueset-medicationknowledge-status.html |
| manufacturer | – | 0 | 1 | Manufacturer of the medication |
| name | string | 1 | 1 | – |
| alias | string | 0 | unbounded | – |
| type | – | 0 | unbounded | Select the type of orginzation this is. A full list can be found here: http://hl7.org/fhir/R4/valueset-organization-type.html |
| dose_form | – | 0 | 1 | Select the dose form. A full list can be found here: http://hl7.org/fhir/R4/valueset-medication-form-codes.html |
| code | – | 0 | 1 | – |
| system | – | 0 | 1 | – |
| ingredients | – | 0 | 1 | – |
| ingredient | – | 0 | unbounded | Ingredients of the medication |
| is_active | boolean | 0 | 1 | – |
| strength | – | 0 | 1 | Quantity of ingredient present |
| numerator | quantity | 0 | 1 | – |
| denominator | quantity | 0 | 1 | – |
| substance | – | 1 | 1 | – |
| category | string (enum: allergen, biological, body, chemical, food, drug, material) | 0 | unbounded | Select the substance categories. A full list can be found here: http://hl7.org/fhir/R4/valueset-substance-category.html |
| description | string | 1 | 1 | – |
| code | – | 1 | 1 | – |
| code | – | 1 | 1 | Select what substance this is. A full list can be found here: http://hl7.org/fhir/R4/valueset-substance-code.html |
| system | – | 0 | 1 | – |
| monitoring_programs | – | 0 | 1 | – |
| monitoring_program | – | 0 | unbounded | Program under which a medication is reviewed |
| name | string | 0 | 1 | – |
| type | string | 0 | 1 | Type of program under which the medication is monitored |
| monographs | – | 0 | 1 | – |
| monograph | – | 0 | unbounded | Associated documentation about the medication |
| type | string | 0 | 1 | The category of medication document |
| cost_informations | – | 0 | 1 | – |
| cost_information | – | 0 | unbounded | The price of the medication |
| type | string | 1 | 1 | The category of the cost information. For example, manufacturers' cost, patient cost, claim reimbursement cost, actual acquisition cost. |
| source | string | 0 | 1 | The source or owner for the price information |
| cost | – | 1 | 1 | The actual cost of the medication |
| value | decimal | 0 | 1 | – |
| currency | currency | 0 | 1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html |
| plan_id | string | 1 | 1 | Plan IDs must be unique, even across different markets. |
| prior_authorization | boolean | 0 | 1 | A Boolean indication of whether the coverage plan imposes a prior authorization requirement on this drug |
| step_therapy | boolean | 0 | 1 | A Boolean indication of whether the coverage plan imposes a step therapy limit on this drug |
| quantity_limit | boolean | 0 | 1 | A Boolean indication of whether the coverage plan imposes a quantity limit on this drug |
| medicine_classifications | – | 0 | 1 | – |
| medicine_classification | – | 0 | unbounded | The type of category for the medication (for example, therapeutic classification, therapeutic sub-classification) |
| type | string | 1 | 1 | – |
| classification | string | 0 | unbounded | – |
| formulary_drugs_alternatives | formulary_drugs_alternatives | 0 | 1 | – |


### formulary_drugs_alternatives

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| formulary_drugs_alternative | – | 0 | unbounded | – |
| rx_norm_code | – | 1 | 1 | A list of RxNorm Codes can be found here: http://hl7.org/fhir/us/core/STU3/ValueSet-us-core-medication-codes.html |
| code | string | 1 | 1 | – |
| display | string | 1 | 1 | – |
| system | string (enum: http://www.nlm.nih.gov/research/umls/rxnorm) | 1 | 1 | – |
| status | string (enum: active, inactive, entered-in-error) | 0 | 1 | Status of medication. Status options can be found here: http://hl7.org/fhir/R4/valueset-medicationknowledge-status.html |
| manufacturer | – | 0 | 1 | Manufacturer of the medication |
| name | string | 1 | 1 | – |
| alias | string | 0 | unbounded | – |
| type | – | 0 | unbounded | Select the type of orginzation this is. A full list can be found here: http://hl7.org/fhir/R4/valueset-organization-type.html |
| dose_form | – | 0 | 1 | Select the dose form. A full list can be found here: http://hl7.org/fhir/R4/valueset-medication-form-codes.html |
| code | – | 0 | 1 | – |
| system | – | 0 | 1 | – |
| ingredients | – | 0 | 1 | – |
| ingredient | – | 0 | unbounded | Ingredients of the medication |
| is_active | boolean | 0 | 1 | – |
| strength | – | 0 | 1 | Quantity of ingredient present |
| numerator | quantity | 0 | 1 | – |
| denominator | quantity | 0 | 1 | – |
| substance | – | 1 | 1 | – |
| category | string (enum: allergen, biological, body, chemical, food, drug, material) | 0 | unbounded | Select the substance categories. A full list can be found here: http://hl7.org/fhir/R4/valueset-substance-category.html |
| description | string | 1 | 1 | – |
| code | – | 1 | 1 | – |
| code | – | 1 | 1 | Select what substance this is. A full list can be found here: http://hl7.org/fhir/R4/valueset-substance-code.html |
| system | – | 0 | 1 | – |
| monitoring_programs | – | 0 | 1 | – |
| monitoring_program | – | 0 | unbounded | Program under which a medication is reviewed |
| name | string | 0 | 1 | – |
| type | string | 0 | 1 | Type of program under which the medication is monitored |
| monographs | – | 0 | 1 | – |
| monograph | – | 0 | unbounded | Associated documentation about the medication |
| type | string | 0 | 1 | The category of medication document |
| cost_informations | – | 0 | 1 | – |
| cost_information | – | 0 | unbounded | The price of the medication |
| type | string | 1 | 1 | The category of the cost information. For example, manufacturers' cost, patient cost, claim reimbursement cost, actual acquisition cost. |
| source | string | 0 | 1 | The source or owner for the price information |
| cost | – | 1 | 1 | The actual cost of the medication |
| value | decimal | 0 | 1 | – |
| currency | currency | 0 | 1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html |
| plan_id | string | 1 | 1 | Plan IDs must be unique, even across different markets |
| prior_authorization | boolean | 0 | 1 | A Boolean indication of whether the coverage plan imposes a prior authorization requirement on this drug |
| step_therapy | boolean | 0 | 1 | A Boolean indication of whether the coverage plan imposes a step therapy limit on this drug |
| quantity_limit | boolean | 0 | 1 | A Boolean indication of whether the coverage plan imposes a quantity limit on this drug |
| medicine_classifications | – | 0 | 1 | – |
| medicine_classification | – | 0 | unbounded | The type of category for the medication (for example, therapeutic classification, therapeutic sub-classification) |
| type | string | 1 | 1 | – |
| classification | string | 0 | unbounded | – |


## Required Elements of Formulary XSD

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| coverage_plans |  | 1..1 | The CoveragePlan resource represents a health plan health plan and contains links to administrative information, a list of formulary drugs covered under that plan, and a definition of drug tiers and their associated cost-sharing models | – | – |
| schema_version | coverage_plans | 1..1 | This element defines what version of the roster schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | coverage_plans | 1..1 | This element is used to the unique identifier assigned to your organization | – | string |
| date_time_reported | coverage_plans | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |
| coverage_plan | coverage_plans | 1..unbounded | – | – | – |


## All Elements of Formulary XSD

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| coverage_plans |  | 1..1 | The CoveragePlan resource represents a health plan health plan and contains links to administrative information, a list of formulary drugs covered under that plan, and a definition of drug tiers and their associated cost-sharing models | – | – |
| schema_version | coverage_plans | 1..1 | This element defines what version of the roster schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | coverage_plans | 1..1 | This element is used to the unique identifier assigned to your organization | – | string |
| date_time_reported | coverage_plans | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |
| coverage_plan | coverage_plans | 1..unbounded | – | – | – |


## Practical Guidance

### Submission Frequency

Formulary files should be submitted according to the schedule agreed upon with HealthLX. Typical submission frequencies include daily, weekly, or monthly updates.

### Adds, Updates, and Deletes

- **Adds**: Include new member records with all required fields populated
- **Updates**: Submit complete member records with updated information
- **Deletes**: Follow the agreed-upon process for member terminations or removals

### Member Identification

Each member must be uniquely identified using the appropriate identifier fields. Ensure consistency in member identifiers across all submissions to maintain data integrity.

