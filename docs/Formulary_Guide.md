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

| Name | Base Type | Description | Pattern |
| --- | --- | --- | --- |
| string | xs:string | – | [ \r\n\t\S]+ |
| decimal | xs:decimal | – | -?(0\|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)? |
| boolean | xs:boolean | – | true\|false |
| date | xs:date | – | ([12]\d{3}-(0[1-9]\|1[0-2])-(0[1-9]\|[12]\d\|3[01])) |
| dateTime | xs:string | – | ([12]\d{3})-(0[1-9]\|1[0-2])-(0[1-9]\|[1-2][0-9]\|3[0-1])(T([01][0-9]\|2[0-3]):[0-5][0-9]:[0-5][0-9](\.\d{1,6})?((Z\|(\+\|-)((0[0-9]\|1[0-3]):(00\|15\|30\|45)\|14:00))?))? |
| currency | string | – |  |


## Complex Types

### quantity

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 0 | 1 | – |
| comparator | – | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
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
| system | – | 1 | 1 | – |
| status | – | 0 | 1 | Status of medication. Status options can be found here: http://hl7.org/fhir/R4/valueset-medicationknowledge-status.html |
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
| category | – | 0 | unbounded | Select the substance categories. A full list can be found here: http://hl7.org/fhir/R4/valueset-substance-category.html |
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
| system | – | 1 | 1 | – |
| status | – | 0 | 1 | Status of medication. Status options can be found here: http://hl7.org/fhir/R4/valueset-medicationknowledge-status.html |
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
| category | – | 0 | unbounded | Select the substance categories. A full list can be found here: http://hl7.org/fhir/R4/valueset-substance-category.html |
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
| plan_id | coverage_plan | 1..1 | – | – | string |
| plan_id_type | coverage_plan | 1..1 | Type of Plan ID. For all Marketplace plans this should be: HIOS-PLAN-ID. Other recommended values: commercial, QHP, Medicare Advantage, Medicaid, Dental Plan, vision, Indian Health Service etc | – | string |
| title | coverage_plan | 1..1 | – | – | string |
| summary_url | coverage_plan | 1..1 | The URL that goes directly to the formulary brochure for the specific standard plan or plan variation. | – | string |
| network | coverage_plan | 1..unbounded | – | – | string |
| status | coverage_plan | 1..1 | The CoveragePlan Status (current, retired, entered-in-error). More details can be found here: http://hl7.org/fhir/R4/valueset-list-status.html | – | – |
| mode | coverage_plan | 1..1 | The CoveragePlan Mode (working, snapshot, changes). More details can be found here: http://hl7.org/fhir/R4/valueset-list-mode.html | – | – |
| drug_tiers | coverage_plan | 1..1 | A description of the drug tiers used by the formulary and how those tiers implement copay and coinsurance amounts. Drug tiers do not have any inherent meaning that is consistent across all formularies. Rather, each tier is defined using this element. | – | – |
| drug_tier | drug_tiers | 1..unbounded | The drug tier of a particular medication in a health plan. Base set are examples. Each plan may have its own controlled vocabulary. | – | – |
| drug_tier_id | drug_tier | 1..1 | – | – | – |
| mail_order | drug_tier | 1..1 | – | – | boolean |
| pharmacy_type | cost_sharing | 1..1 | Types of Pharmacies. Each payer will have its own controlled vocabulary. More inoformation can be found here: http://hl7.org/fhir/us/Davinci-drug-formulary/ValueSet-usdf-PharmacyTypeVS.html | – | – |
| copay_amount | cost_sharing | 1..1 | – | – | – |
| copay_option | cost_sharing | 1..1 | Copay options which can be found here: http://hl7.org/fhir/us/Davinci-drug-formulary/ValueSet-usdf-CopayOptionVS.html | – | – |
| coinsurance_rate | cost_sharing | 1..1 | – | – | decimal |
| coinsurance_option | cost_sharing | 1..1 | CoInsurance options which can be found here: http://hl7.org/fhir/us/Davinci-drug-formulary/ValueSet-usdf-CoinsuranceOptionVS.html | – | – |
| formulary_drugs | drug_tier | 1..1 | – | – | formulary_drugs |


## All Elements of Formulary XSD

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| coverage_plans |  | 1..1 | The CoveragePlan resource represents a health plan health plan and contains links to administrative information, a list of formulary drugs covered under that plan, and a definition of drug tiers and their associated cost-sharing models | – | – |
| schema_version | coverage_plans | 1..1 | This element defines what version of the roster schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | coverage_plans | 1..1 | This element is used to the unique identifier assigned to your organization | – | string |
| date_time_reported | coverage_plans | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |
| coverage_plan | coverage_plans | 1..unbounded | – | – | – |
| plan_id | coverage_plan | 1..1 | – | – | string |
| plan_id_type | coverage_plan | 1..1 | Type of Plan ID. For all Marketplace plans this should be: HIOS-PLAN-ID. Other recommended values: commercial, QHP, Medicare Advantage, Medicaid, Dental Plan, vision, Indian Health Service etc | – | string |
| title | coverage_plan | 1..1 | – | – | string |
| marketing_url | coverage_plan | 0..1 | The URL that goes directly to the plan brochure for the specific standard plan or plan variation | – | string |
| summary_url | coverage_plan | 1..1 | The URL that goes directly to the formulary brochure for the specific standard plan or plan variation. | – | string |
| formulary_url | coverage_plan | 0..1 | The URL that goes directly to the formulary brochure for the specific standard plan or plan variation. | – | string |
| email_plan_contact | coverage_plan | 0..1 | – | – | string |
| network | coverage_plan | 1..unbounded | – | – | string |
| status | coverage_plan | 1..1 | The CoveragePlan Status (current, retired, entered-in-error). More details can be found here: http://hl7.org/fhir/R4/valueset-list-status.html | – | – |
| mode | coverage_plan | 1..1 | The CoveragePlan Mode (working, snapshot, changes). More details can be found here: http://hl7.org/fhir/R4/valueset-list-mode.html | – | – |
| date | coverage_plan | 0..1 | – | – | dateTime |
| drug_tiers | coverage_plan | 1..1 | A description of the drug tiers used by the formulary and how those tiers implement copay and coinsurance amounts. Drug tiers do not have any inherent meaning that is consistent across all formularies. Rather, each tier is defined using this element. | – | – |
| drug_tier | drug_tiers | 1..unbounded | The drug tier of a particular medication in a health plan. Base set are examples. Each plan may have its own controlled vocabulary. | – | – |
| drug_tier_id | drug_tier | 1..1 | – | – | – |
| code | drug_tier_id | 0..1 | – | – | – |
| text | drug_tier_id | 0..1 | – | – | string |
| mail_order | drug_tier | 1..1 | – | – | boolean |
| cost_sharings | drug_tier | 0..1 | – | – | – |
| cost_sharing | cost_sharings | 0..unbounded | – | – | – |
| pharmacy_type | cost_sharing | 1..1 | Types of Pharmacies. Each payer will have its own controlled vocabulary. More inoformation can be found here: http://hl7.org/fhir/us/Davinci-drug-formulary/ValueSet-usdf-PharmacyTypeVS.html | – | – |
| copay_amount | cost_sharing | 1..1 | – | – | – |
| value | copay_amount | 0..1 | – | – | decimal |
| currency | copay_amount | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| copay_option | cost_sharing | 1..1 | Copay options which can be found here: http://hl7.org/fhir/us/Davinci-drug-formulary/ValueSet-usdf-CopayOptionVS.html | – | – |
| coinsurance_rate | cost_sharing | 1..1 | – | – | decimal |
| coinsurance_option | cost_sharing | 1..1 | CoInsurance options which can be found here: http://hl7.org/fhir/us/Davinci-drug-formulary/ValueSet-usdf-CoinsuranceOptionVS.html | – | – |
| formulary_drugs | drug_tier | 1..1 | – | – | formulary_drugs |


## Practical Guidance

### Submission Frequency

Formulary files should be submitted according to the schedule agreed upon with HealthLX. Typical submission frequencies include daily, weekly, or monthly updates.

### Adds, Updates, and Deletes

- **Adds**: Include new member records with all required fields populated
- **Updates**: Submit complete member records with updated information
- **Deletes**: Follow the agreed-upon process for member terminations or removals

### Member Identification

Each member must be uniquely identified using the appropriate identifier fields. Ensure consistency in member identifiers across all submissions to maintain data integrity.

