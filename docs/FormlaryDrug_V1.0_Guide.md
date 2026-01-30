
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

# Formlary Drug_V1.0 Implementation Guide

**HLX0123 HLX Formlary Drug_V1.0 IG (XSD_V6.1)**

**Version 6.1**

**January 27, 2026**

**Table of Contents**

1. [Overview](#overview)
2. [Encoding](#encoding)
3. [Interoperability](#interoperability)
4. [Change Log](#change-log)
5. [Simple Types](#simple-types)
6. [Complex Types](#complex-types)
7. [Required Elements of Formlary Drug_V1.0 XSD](#required-elements-of-formlary-drug_v1.0-xsd)
8. [All Elements of Formlary Drug_V1.0 XSD](#all-elements-of-formlary-drug_v1.0-xsd)
9. [Practical Guidance](#practical-guidance)

<h2 style="color:#E60073">Disclaimer</h2>

This document is provided by HealthLX for informational purposes only. Information within this document is believed to be correct as of the noted date of publication. Although HealthLX makes every reasonable effort to present information in a timely and accurate manner, HealthLX does not warrant this information for accuracy, completeness or fitness for any purpose, express or implied. The information provided herein does not constitute the rendering of legal, financial or other professional advice or recommendations by HealthLX.

<h2 style="color:#E60073">Overview</h2>

This implementation guide provides field mappings and requirements for HealthLX Formlary Drug_V1.0 data submissions in XML format based on FHIR R4 standards. XML format enables structured data exchange with built-in validation against the provided XSD schema.

<h2 style="color:#E60073">Overview</h2>

This implementation guide provides field mappings and requirements for HealthLX Formlary Drug_V1.0 data submissions in XML format based on FHIR R4 standards. XML format enables structured data exchange with built-in validation against the provided XSD schema.

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



<h2 style="color:#E60073">Required Elements of Formlary Drug_V1.0 XSD</h2>

<div class = "heatMap">

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| formulary_drugs |  | 1..1 | The FormularyDrug resource represents a drug that is part of a drug formulary. A drug formulary is a list of brand-name and generic prescription drugs a health insurer agrees to pay for, at least partially, as part of health insurance coverage.In addition to identifying the drug by its RxNorm code, and the PlanID of the formulary, the FormularyDrug entry provides information on prescribing limitations, and optionally drug classification and alternatives | – | – |
| formulary_drug | formulary_drugs | 1..unbounded | – | – | – |
| rx_norm_code | formulary_drug | 1..1 | A list of RxNorm Codes can be found here: http://hl7.org/fhir/us/core/STU3/ValueSet-us-core-medication-codes.html | – | – |
| code | rx_norm_code | 1..1 | – | – | string |
| display | rx_norm_code | 1..1 | – | – | string |
| system | rx_norm_code | 1..1 | – | – | – |
| name | manufacturer | 1..1 | – | – | string |
| substance | ingredient | 1..1 | – | – | – |
| description | substance | 1..1 | – | – | string |
| code | substance | 1..1 | – | – | – |
| code | code | 1..1 | Select what substance this is. A full list can be found here: http://hl7.org/fhir/R4/valueset-substance-code.html | – | – |
| type | cost_information | 1..1 | The category of the cost information. For example, manufacturers' cost, patient cost, claim reimbursement cost, actual acquisition cost. | – | string |
| cost | cost_information | 1..1 | The actual cost of the medication | – | – |
| plan_id | formulary_drug | 1..1 | Plan IDs must be unique, even across different markets. | – | string |
| drug_tier_id | formulary_drug | 1..1 | – | – | – |
| – | drug_tier_id | – | One of: code, text | – | choice |
| code | drug_tier_id | 1..1 | – | – | – |
| text | drug_tier_id | 1..1 | – | – | string |
| mail_order | formulary_drug | 1..1 | – | – | boolean |
| type | medicine_classification | 1..1 | – | – | string |
| alternative_rx_norm_code | formulary_drug_alternatives | 1..unbounded | – | – | string |


</div>



<h2 style="color:#E60073">All Elements of Formlary Drug_V1.0 XSD</h2>

<h3 style="color:#E60073">Root Elements</h3>

<div class = "heatMap">

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| formulary_drugs |  | 1..1 | The FormularyDrug resource represents a drug that is part of a drug formulary. A drug formulary is a list of brand-name and generic prescription drugs a health insurer agrees to pay for, at least partially, as part of health insurance coverage.In addition to identifying the drug by its RxNorm code, and the PlanID of the formulary, the FormularyDrug entry provides information on prescribing limitations, and optionally drug classification and alternatives | – | – |
| formulary_drug | formulary_drugs | 1..unbounded | – | – | – |
| rx_norm_code | formulary_drug | 1..1 | A list of RxNorm Codes can be found here: http://hl7.org/fhir/us/core/STU3/ValueSet-us-core-medication-codes.html | – | – |
| code | rx_norm_code | 1..1 | – | – | string |
| display | rx_norm_code | 1..1 | – | – | string |
| system | rx_norm_code | 1..1 | – | – | – |
| status | formulary_drug | 0..1 | Status of medication. Status options can be found here: http://hl7.org/fhir/R4/valueset-medicationknowledge-status.html | – | – |
| manufacturer | formulary_drug | 0..1 | Manufacturer of the medication | – | – |
| name | manufacturer | 1..1 | – | – | string |
| alias | manufacturer | 0..unbounded | – | – | string |
| type | manufacturer | 0..unbounded | Select the type of orginzation this is. A full list can be found here: http://hl7.org/fhir/R4/valueset-organization-type.html | – | – |
| dose_form | formulary_drug | 0..1 | Select the dose form. A full list can be found here: http://hl7.org/fhir/R4/valueset-medication-form-codes.html | – | – |
| code | dose_form | 0..1 | – | – | – |
| system | dose_form | 0..1 | – | – | – |
| ingredients | formulary_drug | 0..1 | – | – | – |
| ingredient | ingredients | 0..unbounded | Ingredients of the medication | – | – |
| is_active | ingredient | 0..1 | – | – | boolean |
| strength | ingredient | 0..1 | Quantity of ingredient present | – | – |
| numerator | strength | 0..1 | – | – | quantity |
| denominator | strength | 0..1 | – | – | quantity |
| substance | ingredient | 1..1 | – | – | – |
| category | substance | 0..unbounded | Select the substance categories. A full list can be found here: http://hl7.org/fhir/R4/valueset-substance-category.html | – | – |
| description | substance | 1..1 | – | – | string |
| code | substance | 1..1 | – | – | – |
| code | code | 1..1 | Select what substance this is. A full list can be found here: http://hl7.org/fhir/R4/valueset-substance-code.html | – | – |
| system | code | 0..1 | – | – | – |
| monitoring_programs | formulary_drug | 0..1 | – | – | – |
| monitoring_program | monitoring_programs | 0..unbounded | Program under which a medication is reviewed | – | – |
| name | monitoring_program | 0..1 | – | – | string |
| type | monitoring_program | 0..1 | Type of program under which the medication is monitored | – | string |
| monographs | formulary_drug | 0..1 | – | – | – |
| monograph | monographs | 0..unbounded | Associated documentation about the medication | – | – |
| type | monograph | 0..1 | The category of medication document | – | string |
| cost_informations | formulary_drug | 0..1 | – | – | – |
| cost_information | cost_informations | 0..unbounded | The price of the medication | – | – |
| type | cost_information | 1..1 | The category of the cost information. For example, manufacturers' cost, patient cost, claim reimbursement cost, actual acquisition cost. | – | string |
| source | cost_information | 0..1 | The source or owner for the price information | – | string |
| cost | cost_information | 1..1 | The actual cost of the medication | – | – |
| value | cost | 0..1 | – | – | decimal |
| currency | cost | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| plan_id | formulary_drug | 1..1 | Plan IDs must be unique, even across different markets. | – | string |
| drug_tier_id | formulary_drug | 1..1 | – | – | – |
| – | drug_tier_id | – | One of: code, text | – | choice |
| code | drug_tier_id | 1..1 | – | – | – |
| text | drug_tier_id | 1..1 | – | – | string |
| prior_authorization | formulary_drug | 0..1 | A Boolean indication of whether the coverage plan imposes a prior authorization requirement on this drug | – | boolean |
| step_therapy | formulary_drug | 0..1 | A Boolean indication of whether the coverage plan imposes a step therapy limit on this drug | – | boolean |
| quantity_limit | formulary_drug | 0..1 | A Boolean indication of whether the coverage plan imposes a quantity limit on this drug | – | boolean |
| mail_order | formulary_drug | 1..1 | – | – | boolean |
| medicine_classifications | formulary_drug | 0..1 | – | – | – |
| medicine_classification | medicine_classifications | 0..unbounded | The type of category for the medication (for example, therapeutic classification, therapeutic sub-classification) | – | – |
| type | medicine_classification | 1..1 | – | – | string |
| classification | medicine_classification | 0..unbounded | – | – | string |
| formulary_drug_alternatives | formulary_drug | 0..1 | – | – | – |
| alternative_rx_norm_code | formulary_drug_alternatives | 1..unbounded | – | – | string |


</div>



<h2 style="color:#E60073">Practical Guidance</h2>

<h3 style="color:#E60073">Submission Frequency</h3>

Formlary Drug_V1.0 files should be submitted according to the schedule agreed upon with HealthLX. Typical submission frequencies include daily, weekly, or monthly updates.

<h3 style="color:#E60073">Adds, Updates, and Deletes</h3>

- **Adds**: Include new member records with all required fields populated
- **Updates**: Submit complete member records with updated information
- **Deletes**: Follow the agreed-upon process for member terminations or removals

<h3 style="color:#E60073">Member Identification</h3>

Each member must be uniquely identified using the appropriate identifier fields. Ensure consistency in member identifiers across all submissions to maintain data integrity.

