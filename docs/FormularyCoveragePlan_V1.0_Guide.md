
<style>
    .heatMap {
        text-align: Left;
    }
    .heatMap thead {
      position: sticky}
    .heatMap th {
        background: #3FA5DC;
        word-wrap: break-word;
        text-align: center;
        border: 0px solid lightgrey;
        color: white
    }
    .heatMap td {
        
        border: 1.5px solid lightgrey
    }
    .heatMap tr:nth-child(even) {background: lightgrey;}
    .heatMap td:first-child {
            font-weight: bold
        }
    /* .heatMap tr:nth-child(1) { background: red; }
    
    /* .heatMap tr:nth-child(2) { background: orange; } 
    .heatMap tr:nth-child(3) { background: gray; text: red} */

</style>

![HLX Logo](../assets/hlx_logo.png)

# Formulary Coverage Plan_V1.0 Implementation Guide

**HLX0123 HLX Formulary Coverage Plan_V1.0 IG (XSD_V6.1)**

**Version 6.1**

**January 27, 2026**

**Table of Contents**

1. [Overview](#overview)
2. [Encoding](#encoding)
3. [Interoperability](#interoperability)
4. [Change Log](#change-log)
5. [Simple Types](#simple-types)
6. [Complex Types](#complex-types)
7. [Required Elements of Formulary Coverage Plan_V1.0 XSD](#required-elements-of-formulary-coverage-plan_v1.0-xsd)
8. [All Elements of Formulary Coverage Plan_V1.0 XSD](#all-elements-of-formulary-coverage-plan_v1.0-xsd)
9. [Practical Guidance](#practical-guidance)

<h2 style="color:#E60073">Disclaimer</h2>

This document is provided by HealthLX for informational purposes only. Information within this document is believed to be correct as of the noted date of publication. Although HealthLX makes every reasonable effort to present information in a timely and accurate manner, HealthLX does not warrant this information for accuracy, completeness or fitness for any purpose, express or implied. The information provided herein does not constitute the rendering of legal, financial or other professional advice or recommendations by HealthLX.

<h2 style="color:#E60073">Overview</h2>

This implementation guide provides field mappings and requirements for HealthLX Formulary Coverage Plan_V1.0 data submissions in XML format based on FHIR R4 standards. XML format enables structured data exchange with built-in validation against the provided XSD schema.

<h2 style="color:#E60073">Overview</h2>

This implementation guide provides field mappings and requirements for HealthLX Formulary Coverage Plan_V1.0 data submissions in XML format based on FHIR R4 standards. XML format enables structured data exchange with built-in validation against the provided XSD schema.

<h2 style="color:#E60073">Encoding</h2>

Payers need to send their files with utf-8 encoding as shown below:

```xml
<?xml version="1.0" encoding="utf-8"?>
```

<h2 style="color:#E60073">Interoperability</h2>

This implementation guide is based on FHIR R4 (Fast Healthcare Interoperability Resources Release 4) standards. For more information about FHIR R4, visit: https://www.hl7.org/fhir/R4/

<h2 style="color:#E60073">Change Log</h2>

<div class = "heatMap">

| Version | Date |
|---------|------|
| 6.1 | January 27, 2026 |

</div>

<h2 style="color:#E60073"> Simple Types</h2>

<div class = "heatMap">

| Name | Base Type | Description | Pattern |
| --- | --- | --- | --- |
| string | xs:string | – | [ \r\n\t\S]+ |
| decimal | xs:decimal | – | -?(0\|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)? |
| boolean | xs:boolean | – | true\|false |
| date | xs:date | – | ([12]\d{3}-(0[1-9]\|1[0-2])-(0[1-9]\|[12]\d\|3[01])) |
| dateTime | xs:string | – | ([12]\d{3})-(0[1-9]\|1[0-2])-(0[1-9]\|[1-2][0-9]\|3[0-1])(T([01][0-9]\|2[0-3]):[0-5][0-9]:[0-5][0-9](\.\d{1,6})?((Z\|(\+\|-)((0[0-9]\|1[0-3]):(00\|15\|30\|45)\|14:00))?))? |
| currency | string | – |  |


</div>



<h2 style="color:#E60073"> Complex Types</h2>

<h3 style="color:#E60073">quantity</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 0 | 1 | – |
| comparator | – | 0 | 1 | A list of Quantity Comparator's can be found here: http://hl7.org/fhir/R4/valueset-quantity-comparator.html |
| unit | string | 0 | 1 | Unit representation (e.g. mcg) |
| system | string | 0 | 1 | The URI of the system that defines the coded unit form |
| code | string | 0 | 1 | Coded form of the unit |


</div>



<h2 style="color:#E60073">Required Elements of Formulary Coverage Plan_V1.0 XSD</h2>

<div class = "heatMap">

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| coverage_plans |  | 1..1 | The CoveragePlan resource represents a health plan health plan and contains links to administrative information, a list of formulary drugs covered under that plan, and a definition of drug tiers and their associated cost-sharing models | – | – |
| schema_version | coverage_plans | 1..1 | This element defines what version of the roster schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | coverage_plans | 1..1 | This element is used to the unique identifier assigned to your organization | – | string |
| date_time_reported | coverage_plans | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |
| coverage_plan | coverage_plans | 1..unbounded | – | – | – |
| plan_id | coverage_plan | 1..1 | – | – | string |
| plan_id_type | coverage_plan | 1..1 | – | – | – |
| title | coverage_plan | 1..1 | – | – | string |
| summary_url | coverage_plan | 1..1 | The URL that goes directly to the formulary brochure for the specific standard plan or plan variation. | – | string |
| network | coverage_plan | 1..unbounded | – | – | string |
| status | coverage_plan | 1..1 | The CoveragePlan Status (current, retired, entered-in-error). More details can be found here: http://hl7.org/fhir/R4/valueset-list-status.html | – | – |
| mode | coverage_plan | 1..1 | The CoveragePlan Mode (working, snapshot, changes). More details can be found here: http://hl7.org/fhir/R4/valueset-list-mode.html | – | – |
| drug_tiers | coverage_plan | 1..1 | A description of the drug tiers used by the formulary and how those tiers implement copay and coinsurance amounts. Drug tiers do not have any inherent meaning that is consistent across all formularies. Rather, each tier is defined using this element. | – | – |
| drug_tier | drug_tiers | 1..unbounded | The drug tier of a particular medication in a health plan. Base set are examples. Each plan may have its own controlled vocabulary. | – | – |
| drug_tier_id | drug_tier | 1..1 | – | – | – |
| – | drug_tier_id | – | One of: code, text | – | choice |
| code | drug_tier_id | 1..1 | – | – | – |
| text | drug_tier_id | 1..1 | – | – | string |
| mail_order | drug_tier | 1..1 | – | – | boolean |
| cost_sharing | cost_sharings | 1..unbounded | – | – | – |
| pharmacy_type | cost_sharing | 1..1 | – | – | – |
| – | pharmacy_type | – | One of: code, text | – | choice |
| code | pharmacy_type | 1..1 | – | – | – |
| text | pharmacy_type | 1..1 | – | – | string |
| copay_amount | cost_sharing | 1..1 | – | – | – |
| value | copay_amount | 1..1 | – | – | decimal |
| copay_option | cost_sharing | 1..1 | Copay options which can be found here: http://hl7.org/fhir/us/Davinci-drug-formulary/ValueSet-usdf-CopayOptionVS.html | – | – |
| coinsurance_rate | cost_sharing | 1..1 | – | – | decimal |
| coinsurance_option | cost_sharing | 1..1 | CoInsurance options which can be found here: http://hl7.org/fhir/us/Davinci-drug-formulary/ValueSet-usdf-CoinsuranceOptionVS.html | – | – |


</div>



<h2 style="color:#E60073">All Elements of Formulary Coverage Plan_V1.0 XSD</h2>

<h3 style="color:#E60073">Root Elements</h3>

<div class = "heatMap">

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| coverage_plans |  | 1..1 | The CoveragePlan resource represents a health plan health plan and contains links to administrative information, a list of formulary drugs covered under that plan, and a definition of drug tiers and their associated cost-sharing models | – | – |
| schema_version | coverage_plans | 1..1 | This element defines what version of the roster schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | coverage_plans | 1..1 | This element is used to the unique identifier assigned to your organization | – | string |
| date_time_reported | coverage_plans | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |
| coverage_plan | coverage_plans | 1..unbounded | – | – | – |
| plan_id | coverage_plan | 1..1 | – | – | string |
| plan_id_type | coverage_plan | 1..1 | – | – | – |
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
| – | drug_tier_id | – | One of: code, text | – | choice |
| code | drug_tier_id | 1..1 | – | – | – |
| text | drug_tier_id | 1..1 | – | – | string |
| mail_order | drug_tier | 1..1 | – | – | boolean |
| cost_sharings | drug_tier | 0..1 | – | – | – |
| cost_sharing | cost_sharings | 1..unbounded | – | – | – |
| pharmacy_type | cost_sharing | 1..1 | – | – | – |
| – | pharmacy_type | – | One of: code, text | – | choice |
| code | pharmacy_type | 1..1 | – | – | – |
| text | pharmacy_type | 1..1 | – | – | string |
| copay_amount | cost_sharing | 1..1 | – | – | – |
| value | copay_amount | 1..1 | – | – | decimal |
| currency | copay_amount | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| copay_option | cost_sharing | 1..1 | Copay options which can be found here: http://hl7.org/fhir/us/Davinci-drug-formulary/ValueSet-usdf-CopayOptionVS.html | – | – |
| coinsurance_rate | cost_sharing | 1..1 | – | – | decimal |
| coinsurance_option | cost_sharing | 1..1 | CoInsurance options which can be found here: http://hl7.org/fhir/us/Davinci-drug-formulary/ValueSet-usdf-CoinsuranceOptionVS.html | – | – |


</div>



<h2 style="color:#E60073">Practical Guidance</h2>

<h3 style="color:#E60073">Submission Frequency</h3>

Formulary Coverage Plan_V1.0 files should be submitted according to the schedule agreed upon with HealthLX. Typical submission frequencies include daily, weekly, or monthly updates.

<h3 style="color:#E60073">Adds, Updates, and Deletes</h3>

- **Adds**: Include new member records with all required fields populated
- **Updates**: Submit complete member records with updated information
- **Deletes**: Follow the agreed-upon process for member terminations or removals

<h3 style="color:#E60073">Member Identification</h3>

Each member must be uniquely identified using the appropriate identifier fields. Ensure consistency in member identifiers across all submissions to maintain data integrity.

