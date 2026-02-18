---
layout: default
title: "EOB Implementation Guide"
---

![HLX Logo](assets/hlx_logo.png)

# EOB Implementation Guide

**HLX0123 HLX EOB IG (XSD_V10.0)**

**Version 10.0**

**February 6, 2026**

**Table of Contents**

1. [Overview](#overview)
2. [Encoding](#encoding)
3. [Interoperability](#interoperability)
4. [Change Log](#change-log)
5. [Simple Types](#simple-types)
6. [Core Model Types](#core-model-types)
7. [Complex Types](#complex-types)
8. [Required Elements of EOB XSD](#required-elements-of-eob-xsd)
9. [All Elements of EOB XSD](#all-elements-of-eob-xsd)
10. [Practical Guidance](#practical-guidance)

<h2 style="color:#E60073">Disclaimer</h2>

This document is provided by HealthLX for informational purposes only. Information within this document is believed to be correct as of the noted date of publication. Although HealthLX makes every reasonable effort to present information in a timely and accurate manner, HealthLX does not warrant this information for accuracy, completeness or fitness for any purpose, express or implied. The information provided herein does not constitute the rendering of legal, financial or other professional advice or recommendations by HealthLX.

<h2 style="color:#E60073">Overview</h2>

This implementation guide provides field mappings and requirements for HealthLX EOB data submissions in XML format based on FHIR R4 standards. XML format enables structured data exchange with built-in validation against the provided XSD schema.

<h2 style="color:#E60073">Overview</h2>

This implementation guide provides field mappings and requirements for HealthLX EOB data submissions in XML format based on FHIR R4 standards. XML format enables structured data exchange with built-in validation against the provided XSD schema.

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
| 10.0 | February 6, 2026 |

</div>

<h2 style="color:#E60073"> Simple Types</h2>

<div class = "heatMap">

| Name | Base Type | Description | Pattern |
| --- | --- | --- | --- |
| unsignedInt | xs:unsignedInt | – | 0\|([1-9][0-9]*) |
| integer | xs:integer | – | [0]\|[-+]?[1-9][0-9]* |
| time | xs:time | – | ([01][0-9]\|2[0-3]):[0-5][0-9]:[0-5][0-9](\.\d{1,9})? |
| dateTime | xs:string | – | ([12]\d{3})-(0[1-9]\|1[0-2])-(0[1-9]\|[1-2][0-9]\|3[0-1])(T([01][0-9]\|2[0-3]):[0-5][0-9]:[0-5][0-9](\.\d{1,6})?((Z\|(\+\|-)((0[0-9]\|1[0-3]):(00\|15\|30\|45)\|14:00))?))? |
| date | xs:date | – | ([12]\d{3}-(0[1-9]\|1[0-2])-(0[1-9]\|[12]\d\|3[01])) |
| decimal | xs:decimal | – | -?(0\|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)? |
| currency | core:string | – |  |
| adjudication_category | core:string | – |  |
| language | core:string | – |  |
| reference | core:string | – |  |


</div>



## Core Model Types

The following types are imported from the Core-model. See [Core-model Guide](Core-model_Guide.md) for complete documentation.

<div class = "heatMap">

| Name | Base Type | Description | Pattern |
| --- | --- | --- | --- |
| NPI | xs:string | – | [0-9]{10} |
| positiveInt | xs:positiveInteger | – | \+?[1-9][0-9]* |
| string | xs:string | – | [ \r\n\t\S]+ |


</div>



<h2 style="color:#E60073"> Complex Types</h2>

<h3 style="color:#E60073">period</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| start | dateTime | 0 | 1 | – |
| end | dateTime | 0 | 1 | – |


</div>



<h3 style="color:#E60073">identifier</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | core:string | 1 | 1 | – |
| type | core:string | 0 | 1 | – |
| system | core:string | 0 | 1 | – |


</div>



<h3 style="color:#E60073">eob_identifier</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | core:string | 1 | 1 | – |
| type | – | 1 | 1 | – |


</div>



<h3 style="color:#E60073">timing</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| timing_date | date | 0 | 1 | – |
| timing_period | period | 0 | 1 | – |


</div>



<h3 style="color:#E60073">quantity</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 0 | 1 | – |
| comparator | core:string | 0 | 1 | – |
| unit | core:string | 0 | 1 | – |
| system | core:string | 0 | 1 | – |
| code | core:string | 0 | 1 | – |


</div>



<h3 style="color:#E60073">value</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value_boolean | xs:boolean | 0 | 1 | – |
| value_string | core:string | 0 | 1 | – |
| value_quantity | quantity | 0 | 1 | – |
| value_reference | – | 0 | 1 | – |
| reference | core:string | 0 | 1 | – |
| type | core:string | 0 | 1 | – |
| identifier | identifier | 0 | 1 | – |
| display | core:string | 0 | 1 | – |


</div>



<h3 style="color:#E60073">human_name</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| use | – | 0 | 1 | Use this element to describe the name. More information can be found here: http://hl7.org/fhir/R4/valueset-name-use.html |
| text | core:string | 0 | 1 | Use this element to enter the entire name |
| family | core:string | 1 | 1 | Family name (often called 'Surname') |
| given | core:string | 1 | unbounded | Given names (not always 'first'). Includes middle names |
| prefix | core:string | 0 | unbounded | – |
| suffix | core:string | 0 | unbounded | – |
| period | period | 0 | 1 | Time period when name was/is in use. If the name is still in use, do not supply an End date |


</div>



<h3 style="color:#E60073">address</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| use | – | 0 | 1 | The use of this address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-use.html |
| type | – | 0 | 1 | The type of address. More information can be found here: http://hl7.org/fhir/R4/valueset-address-type.html |
| text | core:string | 0 | 1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) |
| line | core:string | 1 | unbounded | – |
| city | core:string | 1 | 1 | Name of city, town etc. |
| district | core:string | 0 | 1 | Use this element to list the District name (aka county) |
| state | core:string | 0 | 1 | Sub-unit of country (abbreviations ok) |
| postal_code | core:string | 1 | 1 | The postal code or post code of the address. The postal code supports an unlimited amount of numbers and letters. |
| country | xs:string | 0 | 1 | Country (e.g. can be ISO 3166 2 or 3 letter code) |
| period | period | 0 | 1 | – |


</div>



<h3 style="color:#E60073">telecom</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| system | – | 1 | 1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html |
| value | core:string | 1 | 1 | The actual value of the contact point |
| use | – | 0 | 1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html |
| rank | core:positiveInt | 0 | 1 | Specify preferred order of use (1 = highest) |
| period | period | 0 | 1 | Time period when the contact point was/is in use |


</div>



<h3 style="color:#E60073">practitioner</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| npi | core:NPI | 0 | 1 | National Provider Identifier (NPI) |
| tax | core:string | 0 | unbounded | An identifier for the person as this agent |
| names | – | 1 | 1 | – |
| name | human_name | 1 | unbounded | – |
| reference | core:string | 1 | 1 | – |
| telecoms | – | 0 | 1 | – |
| telecom | telecom | 0 | unbounded | – |
| addresses | – | 0 | 1 | – |
| address | address | 0 | unbounded | – |


</div>



<h3 style="color:#E60073">organization</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| npi | core:NPI | 0 | 1 | National Provider Identifier (NPI) |
| clia | core:string | 0 | 1 | Clinical Laboratory Improvement Amendments (CLIA) Number for laboratories |
| tax | identifier | 0 | unbounded | Tax Id Number |
| naic_code | identifier | 0 | unbounded | – |
| payer_id | identifier | 0 | unbounded | – |
| is_active | xs:boolean | 1 | 1 | – |
| name | core:string | 1 | 1 | – |
| alias | core:string | 0 | unbounded | – |
| telecoms | – | 0 | 1 | – |
| telecom | telecom | 0 | unbounded | – |
| addresses | – | 0 | 1 | – |
| address | address | 0 | unbounded | – |


</div>



<h3 style="color:#E60073">member_person</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| member_id | core:string | 1 | 1 | Use this element to list the Member ID . |
| member_id_system | core:string | 0 | 1 | Use this element to identify the system that issues the Member ID . |
| subscriber_id | core:string | 1 | 1 | Use this element to list the Subscriber ID. |
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
| language | – | 1 | 1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html |
| language_code | language | 1 | 1 | – |
| system | – | 0 | 1 | – |
| display | core:string | 0 | 1 | Description |
| is_preferred | xs:boolean | 0 | 1 | Is this language the preferred language (true/false) |
| us_core_race | – | 0 | 1 | – |
| omb_category_code | – | 0 | 5 | This element is for selecting 1 of the 5 OMB race category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html |
| code | – | 1 | 1 | – |
| system | – | 0 | 1 | – |
| detailed_code | – | 0 | unbounded | This element is for selecting 1 of the additional expansion codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html |
| text | core:string | 1 | 1 | Use this element for adding a text description |
| us_core_ethnicity | – | 0 | 1 | – |
| omb_category_code | – | 0 | 1 | This element is for selecting 1 of the OMB ethnicity category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-omb-ethnicity-category.html |
| detailed_code | – | 0 | unbounded | This element is for selecting 1 of the additional ethnicity codes from the CDC that can be found here: https://www.hl7.org/fhir/us/core/ValueSet-detailed-ethnicity.html |
| text | core:string | 1 | 1 | Use this element for adding a text description if the ethnicity is not listed within the enummeration |
| us_core_birth_sex | – | 0 | 1 | This element is used for selecting birth sex (M = Male, F = Female, UNK = Unknown) |


</div>



<h3 style="color:#E60073">subscriber_person</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| member_id | core:string | 0 | 1 | Use this element to list the Member ID . |
| member_id_system | core:string | 0 | 1 | Use this element to identify the system that issues the Member ID . |
| subscriber_id | core:string | 1 | 1 | Use this element to list the Subscriber ID. |
| unique_person_id | core:string | 0 | 1 | This is the person's unique member number in the Payer system across plans. This number is not reused for anyone else. |
| unique_person_id_assigner | core:string | 0 | 1 | Organization that issued id |
| unique_person_id_assigner_type | core:string | 0 | 1 | Type of organization that issued id |
| names | – | 1 | 1 | – |
| name | human_name | 1 | unbounded | – |
| gender | – | 0 | 1 | Use this element for Gender (male, female, other or unknown) |
| birth_date | xs:date | 0 | 1 | Birth date (1900-01-01) |
| marital_status | – | 0 | 1 | Marital Status, more information can be found here: http://hl7.org/fhir/R4/valueset-marital-status.html |
| deceased | – | 0 | 1 | – |
| is_deceased | xs:boolean | 0 | 1 | – |
| deceased_date_time | dateTime | 0 | 1 | – |
| telecoms | – | 0 | 1 | – |
| telecom | telecom | 0 | unbounded | – |
| addresses | – | 0 | 1 | – |
| address | address | 0 | unbounded | – |
| communications | – | 0 | 1 | – |
| communication | – | 0 | unbounded | – |
| language_code | language | 1 | 1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html |
| is_preferred | xs:boolean | 0 | 1 | Is this language the preferred language (true/false) |
| display | core:string | 0 | 1 | Description |
| us_core_race | – | 0 | 1 | – |
| omb_category_code | – | 0 | 5 | This element is for selecting 1 of the 5 OMB race category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html |
| detailed_code | – | 0 | unbounded | This element is for selecting 1 of the additional expansion codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html |
| text | core:string | 1 | 1 | Use this element for adding a text description |
| us_core_ethnicity | – | 0 | 1 | – |
| omb_category_code | – | 0 | 1 | This element is for selecting 1 of the OMB ethnicity category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-omb-ethnicity-category.html |
| detailed_code | – | 0 | unbounded | This element is for selecting 1 of the additional ethnicity codes from the CDC that can be found here: https://www.hl7.org/fhir/us/core/ValueSet-detailed-ethnicity.html |
| text | core:string | 1 | 1 | Use this element for adding a text description if the ethnicity is not listed within the enummeration |
| us_core_birth_sex | – | 0 | 1 | This element is used for selecting birth sex (M = Male, F = Female, UNK = Unknown) |


</div>



<h2 style="color:#E60073">Required Elements of EOB XSD</h2>

<div class = "heatMap">

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| eob_list |  | 1..1 | – | – | – |
| schema_version | eob_list | 1..1 | This element defines what version of the EOB schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | eob_list | 1..1 | This element is used to the unique identifier assigned to your organization | – | core:string |
| date_time_reported | eob_list | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |
| eob | eob_list | 1..unbounded | – | – | – |
| eob_identifier | eob | 1..1 | This is a unique business identifier assigned to the EOB. In the event, that this EOB changes in either status or content, the replacement EOB would be expected to have the same identifier. | – | eob_identifier |
| status | eob | 1..1 | Claim processing status code | – | – |
| type | eob | 1..1 | Claim type code (institutional, oral, pharmacy, professional or vision) | – | – |
| use | eob | 1..1 | The purpose of the Claim: predetermination, preauthorization, claim. More information can be found here: http://hl7.org/fhir/R4/valueset-claim-use.html | – | – |
| created | eob | 1..1 | – | – | dateTime |
| outcome | eob | 1..1 | This value set includes Claim Processing Outcome codes. More information can be found here: http://hl7.org/fhir/R4/valueset-remittance-outcome.html | – | – |
| claim | eob | 1..1 | – | – | – |
| identifier | claim | 1..unbounded | Please include the following claim identifiers -The Payer Claim Control Number as it would be returned on the 835 2100 CLP07. This number must apply to the entire claim. Please use an identifier.type of DCN. - If available, the Claim Identifier for Transmission Intermediaries as sent to the payer on the 837 2300 Ref*D9. Please use an identifier.type of D9 | – | identifier |
| patient | eob | 1..1 | – | – | – |
| insurer | eob | 1..1 | – | – | – |
| provider | eob | 1..1 | – | – | – |
| – | provider | – | One of: practitioner, providing_organization | – | choice |
| practitioner | provider | 1..1 | – | – | practitioner |
| providing_organization | provider | 1..1 | – | – | organization |
| relationship | related | 1..1 | How the reference claim is related (prior or replacedby) | – | – |
| reference | related | 1..1 | File or case reference (Identifier) | – | identifier |
| created | claim | 1..1 | claim creation date | – | dateTime |
| type | payee | 1..1 | Category of recipient | – | – |
| party | payee | 1..1 | – | – | – |
| – | party | – | One of: reference, practitioner, providing_organization, patient | – | choice |
| reference | party | 1..1 | – | – | core:string |
| practitioner | party | 1..1 | – | – | practitioner |
| providing_organization | party | 1..1 | – | – | organization |
| patient | party | 1..1 | – | – | member_person |
| provider | care_team | 1..1 | – | – | – |
| – | provider | – | One of: reference, practitioner, providing_organization | – | choice |
| reference | provider | 1..1 | – | – | core:string |
| practitioner | provider | 1..1 | – | – | practitioner |
| providing_organization | provider | 1..1 | – | – | organization |
| role | care_team | 1..1 | This element defines Function within the team,Enumuration set is combined list of possible code value set from each profile: Inpatient-Facility and Outpatient-Facility (primary,attending,performing,referring,operating,otheroperating), Pharmacy (prescribing,primary) and Professional-NonClinician (primary,performing,referring,supervisor,purchasedservice) | – | – |
| code | role | 1..1 | – | – | – |
| sequence | diagnosis | 1..1 | – | – | core:positiveInt |
| diagnosis_code | diagnosis | 1..1 | ICD-10 Codes | – | – |
| coding | diagnosis_code | 1..unbounded | – | – | – |
| code | coding | 1..1 | ICD-10-CM Diagnosis Codes-Large list of codes hence no enumeration included | – | core:string |
| sequence | procedure | 1..1 | – | – | core:positiveInt |
| procedure_code | procedure | 1..1 | – | – | – |
| coding | procedure_code | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string |
| insurances | eob | 1..1 | – | – | – |
| insurance | insurances | 1..unbounded | – | – | – |
| is_focal | insurance | 1..1 | Is Coverage to be used for adjudication | – | xs:boolean |
| coverage | insurance | 1..1 | – | – | – |
| sequence | item | 1..1 | Item instance identifier | – | core:positiveInt |
| product_or_service | item | 1..1 | Current Procedural Terminology (CPT) - Healthcare Common Procedure Coding System (HCPCS) level II alphanumeric codes - Procedure Codes NDC or Compound | – | – |
| code | product_or_service | 1..1 | – | – | core:string |
| – | serviced | – | One of: serviced_date, serviced_period | – | choice |
| – | location | – | One of: location_codeable_concept, location_address, location_reference | – | choice |
| category | adjudication_amount_type | 1..1 | – | – | – |
| code | category | 1..1 | – | – | adjudication_category |
| code | denial_reason | 1..1 | – | – | – |
| system | denial_reason | 1..1 | – | – | – |
| reason | denial_reason | 1..1 | Adjudication Denial Reason | – | – |
| code | reason | 1..1 | – | – | core:string |
| category | allowed_units | 1..1 | – | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| category | in_out_network | 1..1 | Indicates the in network or out of network payment status of the claim. More info can be found here: http://hl7.org/fhir/us/carin-bb/STU1/ValueSet-C4BBPayerBenefitPaymentStatus.html | – | – |
| category | adjudication_generic | 1..1 | – | – | – |
| code | category | 1..1 | – | – | adjudication_category |
| product_or_service | detail | 1..1 | Billing, service, product, or drug code | – | core:string |
| category | adjudication_amount_type | 1..1 | – | – | – |
| code | category | 1..1 | – | – | adjudication_category |
| amount | adjudication_amount_type | 1..1 | – | – | – |
| category | denial_reason | 1..1 | – | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| category | adjudication_generic | 1..1 | – | – | – |
| code | category | 1..1 | – | – | adjudication_category |
| totals | eob | 1..1 | – | – | – |
| total | totals | 1..unbounded | – | – | – |
| adjudication_amount_type | total | 1..unbounded | – | – | – |
| category | adjudication_amount_type | 1..1 | – | – | – |
| code | category | 1..1 | – | – | adjudication_category |
| system | category | 1..1 | – | – | – |
| amount | adjudication_amount_type | 1..1 | – | – | – |
| value | amount | 1..1 | – | – | decimal |
| category | in_out_network | 1..1 | – | – | – |
| code | category | 1..1 | Indicates the in network or out of network payment status of the claim. More info can be found here: : http://hl7.org/fhir/us/carin-bb/STU1/ValueSet-C4BBPayerBenefitPaymentStatus.html | – | – |
| system | category | 1..1 | – | – | – |
| amount | in_out_network | 1..1 | – | – | – |
| value | amount | 1..1 | – | – | decimal |
| category | benefit_balance | 1..1 | Benefit Category Codes. More information can be found here: http://hl7.org/fhir/R4/valueset-ex-benefitcategory.html Preferred code sets list: 1,2,3,4,5,14,23,24,25,26,27,28,30,35,36,37,49,55,56,61,62,63,69,76,F1,F3,F4,F6 | – | core:string |
| type | financial | 1..1 | Benefit classification. More information can be found here: http://hl7.org/fhir/R4/valueset-benefit-type.html Preferred code sets list: benefit,deductible,visit,room,copay,copay-percent,copay-maximum,vision-exam,vision-glasses,vision-contacts,medical-primarycare,pharmacy-dispense | – | core:string |
| – | allowed | – | One of: allowed_unsigned_int, allowed_string, allowed_money | – | choice |
| – | used | – | One of: used_unsigned_int, used_money | – | choice |
| sequence | billing_network_contracting_status | 1..1 | Information instance identifier | – | core:positiveInt |
| category | billing_network_contracting_status | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | billing_network_contracting_status | 1..1 | – | – | – |
| code | code | 1..1 | – | – | – |
| sequence | admission_period | 1..1 | Information instance identifier | – | core:positiveInt |
| category | admission_period | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| timing | admission_period | 1..1 | – | – | – |
| timingPeriod | timing | 1..1 | – | – | period |
| sequence | clm_recvd_date | 1..1 | Information instance identifier | – | core:positiveInt |
| category | clm_recvd_date | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| timing | clm_recvd_date | 1..1 | – | – | date |
| sequence | type_of_bill | 1..1 | Information instance identifier | – | core:positiveInt |
| category | type_of_bill | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | type_of_bill | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| sequence | point_of_origin | 1..1 | Information instance identifier | – | core:positiveInt |
| category | point_of_origin | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| sequence | adm_type | 1..1 | Information instance identifier | – | core:positiveInt |
| category | adm_type | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | adm_type | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| sequence | discharge_status | 1..1 | Information instance identifier | – | core:positiveInt |
| category | discharge_status | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | discharge_status | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| sequence | drg | 1..1 | Information instance identifier | – | core:positiveInt |
| category | drg | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | drg | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| sequence | performing_network_contracting_status | 1..1 | Information instance identifier | – | core:positiveInt |
| category | performing_network_contracting_status | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | performing_network_contracting_status | 1..1 | – | – | – |
| code | code | 1..1 | – | – | – |
| sequence | service_facility | 1..1 | Information instance identifier | – | core:positiveInt |
| category | service_facility | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| value | service_facility | 1..1 | – | – | – |
| value_reference | value | 1..1 | – | – | organization |
| sequence | brand_generic_code | 1..1 | Information instance identifier | – | core:positiveInt |
| category | brand_generic_code | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | brand_generic_code | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| sequence | rx_origin_code | 1..1 | Information instance identifier | – | core:positiveInt |
| category | rx_origin_code | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | rx_origin_code | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| sequence | compound_code | 1..1 | Information instance identifier | – | core:positiveInt |
| category | compound_code | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | ICD-10-CM Diagnosis Codes-Large list of codes hence no enumeration included | – | – |
| system | category | 1..1 | – | – | – |
| code | compound_code | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| sequence | days_supply | 1..1 | Information instance identifier | – | core:positiveInt |
| category | days_supply | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| sequence | dawcode | 1..1 | Information instance identifier | – | core:positiveInt |
| category | dawcode | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | dawcode | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| sequence | refill_num | 1..1 | Information instance identifier | – | core:positiveInt |
| category | refill_num | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| record_type | eob | 1..1 | This element describes the action for this member (A = Add, U = Update, D = Delete) | – | – |


</div>



<h2 style="color:#E60073">All Elements of EOB XSD</h2>

<h3 style="color:#E60073">Root Elements</h3>

<div class = "heatMap">

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| eob_list |  | 1..1 | – | – | – |
| schema_version | eob_list | 1..1 | This element defines what version of the EOB schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | eob_list | 1..1 | This element is used to the unique identifier assigned to your organization | – | core:string |
| date_time_reported | eob_list | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |
| eob | eob_list | 1..unbounded | – | – | – |
| eob_identifier | eob | 1..1 | This is a unique business identifier assigned to the EOB. In the event, that this EOB changes in either status or content, the replacement EOB would be expected to have the same identifier. | – | eob_identifier |
| status | eob | 1..1 | Claim processing status code | – | – |
| type | eob | 1..1 | Claim type code (institutional, oral, pharmacy, professional or vision) | – | – |
| sub_type | eob | 0..1 | sub type of Institutional Profiles | – | – |
| use | eob | 1..1 | The purpose of the Claim: predetermination, preauthorization, claim. More information can be found here: http://hl7.org/fhir/R4/valueset-claim-use.html | – | – |
| billable_period | eob | 0..1 | – | – | period |
| created | eob | 1..1 | – | – | dateTime |
| outcome | eob | 1..1 | This value set includes Claim Processing Outcome codes. More information can be found here: http://hl7.org/fhir/R4/valueset-remittance-outcome.html | – | – |
| disposition | eob | 0..1 | – | – | core:string |
| pre_auth_ref | eob | 0..unbounded | – | – | core:string |
| pre_auth_ref_periods | eob | 0..1 | – | – | – |
| pre_auth_ref_period | pre_auth_ref_periods | 0..unbounded | – | – | period |
| claim | eob | 1..1 | – | – | – |
| identifier | claim | 1..unbounded | Please include the following claim identifiers -The Payer Claim Control Number as it would be returned on the 835 2100 CLP07. This number must apply to the entire claim. Please use an identifier.type of DCN. - If available, the Claim Identifier for Transmission Intermediaries as sent to the payer on the 837 2300 Ref*D9. Please use an identifier.type of D9 | – | identifier |
| created | claim | 0..1 | claim creation date | – | dateTime |


</div>



<h3 style="color:#E60073">Patient Information</h3>

<div class = "heatMap">

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| patient | eob | 1..1 | – | – | – |
| insurer | eob | 1..1 | – | – | – |
| provider | eob | 1..1 | – | – | – |
| – | provider | – | One of: practitioner, providing_organization | – | choice |
| practitioner | provider | 1..1 | – | – | practitioner |
| providing_organization | provider | 1..1 | – | – | organization |
| facility | eob | 0..1 | – | – | – |
| identifier | facility | 0..unbounded | Claim site of service NPI | – | identifier |
| name | facility | 0..1 | Name of the facility as used by humans | – | core:string |
| alias | facility | 0..unbounded | A list of alternate names that the facility is known as, or was known as, in the past. | – | core:string |
| description | facility | 0..1 | Additional details about the facility that could be displayed as further information to identify the location beyond its name. | – | core:string |
| type | facility | 0..unbounded | A role of a place that further classifies the setting (e.g., accident site, road side, work site, community location) in which services are delivered. More information can be found here: http://hl7.org/fhir/R4/v3/ServiceDeliveryLocationRoleType/vs.html | – | – |
| telecoms | facility | 0..1 | – | – | – |
| telecom | telecoms | 0..unbounded | – | – | telecom |
| address | facility | 0..1 | – | – | address |
| relateds | eob | 0..1 | – | – | – |
| related | relateds | 0..unbounded | – | – | – |
| relationship | related | 1..1 | How the reference claim is related (prior or replacedby) | – | – |
| code | relationship | 0..1 | – | – | – |
| system | relationship | 0..1 | – | – | – |
| reference | related | 1..1 | File or case reference (Identifier) | – | identifier |
| claim | related | 0..1 | Reference to the related claim | – | – |
| identifier | claim | 0..unbounded | – | – | identifier |
| created | claim | 1..1 | claim creation date | – | dateTime |
| payee | eob | 0..1 | – | – | – |
| type | payee | 1..1 | Category of recipient | – | – |
| code | type | 0..1 | – | – | – |
| system | type | 0..1 | – | – | – |
| party | payee | 1..1 | – | – | – |
| – | party | – | One of: reference, practitioner, providing_organization, patient | – | choice |
| reference | party | 1..1 | – | – | core:string |
| practitioner | party | 1..1 | – | – | practitioner |
| providing_organization | party | 1..1 | – | – | organization |
| patient | party | 1..1 | – | – | member_person |


</div>



<h3 style="color:#E60073">Care Teams</h3>

<div class = "heatMap">

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| care_teams | eob | 0..1 | – | – | – |
| care_team | care_teams | 0..unbounded | – | – | – |
| sequence | care_team | 0..1 | Order of the care team | – | core:positiveInt |
| is_responsible | care_team | 0..1 | Is this the lead practitioner? | – | xs:boolean |
| provider | care_team | 1..1 | – | – | – |
| – | provider | – | One of: reference, practitioner, providing_organization | – | choice |
| reference | provider | 1..1 | – | – | core:string |
| practitioner | provider | 1..1 | – | – | practitioner |
| providing_organization | provider | 1..1 | – | – | organization |
| role | care_team | 1..1 | This element defines Function within the team,Enumuration set is combined list of possible code value set from each profile: Inpatient-Facility and Outpatient-Facility (primary,attending,performing,referring,operating,otheroperating), Pharmacy (prescribing,primary) and Professional-NonClinician (primary,performing,referring,supervisor,purchasedservice) | – | – |
| code | role | 1..1 | – | – | – |
| system | role | 0..1 | – | – | – |
| qualification | care_team | 0..1 | Practitioner credential or specialization. More information can be found here: http://hl7.org/fhir/R4/codesystem-provider-qualification.html | – | – |
| code | qualification | 0..1 | – | – | core:string |
| system | qualification | 0..1 | – | – | – |
| diagnoses | eob | 0..1 | – | – | – |
| diagnosis | diagnoses | 0..unbounded | Required segment for Institutional[Inpatient and Outpatient] and Professional-NonClinician Profile | – | – |
| sequence | diagnosis | 1..1 | – | – | core:positiveInt |
| diagnosis_code | diagnosis | 1..1 | ICD-10 Codes | – | – |
| coding | diagnosis_code | 1..unbounded | – | – | – |
| code | coding | 1..1 | ICD-10-CM Diagnosis Codes-Large list of codes hence no enumeration included | – | core:string |
| system | coding | 0..1 | – | – | – |
| version | coding | 0..1 | – | – | core:string |
| display | coding | 0..1 | Diagnosis description | – | core:string |
| type | diagnosis | 0..unbounded | Diagnosis type codes for inpatient, outpatient, nonclinician and pharmacy | – | – |
| code | type | 0..1 | – | – | – |
| system | type | 0..1 | – | – | – |
| on_admission | diagnosis | 0..1 | Diagnosis on Admission Codes. More information can be found here: http://hl7.org/fhir/R4/valueset-ex-diagnosis-on-admission.html | – | – |
| code | on_admission | 0..1 | – | – | core:string |
| system | on_admission | 0..1 | – | – | – |
| package_code | diagnosis | 0..1 | – | – | core:string |


</div>



<h3 style="color:#E60073">Procedures</h3>

<div class = "heatMap">

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| procedures | eob | 0..1 | – | – | – |
| procedure | procedures | 0..unbounded | – | – | – |
| sequence | procedure | 1..1 | – | – | core:positiveInt |
| procedure_code | procedure | 1..1 | – | – | – |
| coding | procedure_code | 1..unbounded | – | – | – |
| code | coding | 1..1 | – | – | core:string |
| system | coding | 0..1 | – | – | – |
| version | coding | 0..1 | – | – | core:string |
| display | coding | 0..1 | – | – | core:string |
| type | procedure | 0..unbounded | Preferred codesets:principal,other | – | core:string |
| date | procedure | 0..1 | – | – | date |
| precedence | eob | 0..1 | – | – | core:positiveInt |
| insurances | eob | 1..1 | – | – | – |
| insurance | insurances | 1..unbounded | – | – | – |
| is_focal | insurance | 1..1 | Is Coverage to be used for adjudication | – | xs:boolean |
| pre_auth_ref | insurance | 0..unbounded | Prior authorization reference number | – | core:string |
| coverage | insurance | 1..1 | – | – | – |
| items | eob | 0..1 | – | – | – |
| item | items | 0..unbounded | – | – | – |
| sequence | item | 1..1 | Item instance identifier | – | core:positiveInt |
| care_team_sequence | item | 0..unbounded | Applicable care team members | – | core:positiveInt |
| diagnosis_sequence | item | 0..unbounded | Applicable diagnoses | – | core:positiveInt |
| procedure_sequence | item | 0..unbounded | Applicable procedures | – | core:positiveInt |
| information_sequence | item | 0..unbounded | Applicable exception and supporting information,Enumuration list is not published yet but required | – | core:positiveInt |
| revenue | item | 0..1 | Revenue or cost center code | – | – |
| code | revenue | 0..1 | – | – | core:string |
| system | revenue | 0..1 | Required valid value for institutional profile:https://www.nubc.org/CodeSystem/RevenueCodes | – | core:string |
| category | item | 0..1 | Benefit classification. More information can be found here: http://hl7.org/fhir/R4/valueset-ex-benefitcategory.html Preferred code sets list: 1 ,2 ,3 ,4 ,5 ,14 ,23 ,24 ,25 ,26 ,27 ,28 ,30 ,35 ,36 ,37 ,49 ,55 ,56 ,61 ,62 ,63 ,69 ,76 ,F1 ,F3 ,F4 ,F6 | – | core:string |
| product_or_service | item | 1..1 | Current Procedural Terminology (CPT) - Healthcare Common Procedure Coding System (HCPCS) level II alphanumeric codes - Procedure Codes NDC or Compound | – | – |
| code | product_or_service | 1..1 | – | – | core:string |
| system | product_or_service | 0..1 | – | – | – |
| display | product_or_service | 0..1 | – | – | core:string |
| text | product_or_service | 0..1 | – | – | core:string |
| modifier | item | 0..unbounded | Current Procedural Terminology (CPT) - Healthcare Common Procedure Coding System (HCPCS) level II alphanumeric codes - Procedure Modifier Codes ModifierTypeCodes | – | – |
| code | modifier | 0..1 | – | – | core:string |
| system | modifier | 0..1 | – | – | – |
| program_code | item | 0..unbounded | Program Reason Codes | – | core:string |
| serviced | item | 0..1 | Date or dates of service or product delivery | – | – |
| – | serviced | – | One of: serviced_date, serviced_period | – | choice |
| serviced_date | serviced | 0..1 | – | – | date |
| serviced_period | serviced | 0..1 | – | – | period |
| quantity | item | 0..1 | – | – | – |
| value | quantity | 0..1 | – | – | decimal |
| unit | quantity | 0..1 | – | – | core:string |
| system | quantity | 0..1 | – | – | core:string |
| code | quantity | 0..1 | – | – | core:string |
| unit_price | item | 0..1 | – | – | – |
| value | unit_price | 0..1 | – | – | decimal |
| currency | unit_price | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| factor | item | 0..1 | Price scaling factor | – | decimal |
| net | item | 0..1 | – | – | – |
| value | net | 0..1 | – | – | decimal |
| currency | net | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| note_number | item | 0..unbounded | Applicable note numbers | – | core:positiveInt |
| location | item | 0..1 | – | – | – |


</div>



<h3 style="color:#E60073">Locations</h3>

<div class = "heatMap">

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| – | location | – | One of: location_codeable_concept, location_address, location_reference | – | choice |
| location_codeable_concept | location | 0..1 | – | – | core:string |
| location_address | location | 0..1 | – | – | address |
| location_reference | location | 0..1 | Place of service or where product was supplied | – | – |
| identifier | location_reference | 0..unbounded | Claim site of service NPI | – | identifier |
| name | location_reference | 0..1 | Name of the facility as used by humans | – | core:string |
| alias | location_reference | 0..unbounded | A list of alternate names that the facility is known as, or was known as, in the past. | – | core:string |
| description | location_reference | 0..1 | Additional details about the facility that could be displayed as further information to identify the location beyond its name. | – | core:string |
| type | location_reference | 0..unbounded | A role of a place that further classifies the setting (e.g., accident site, road side, work site, community location) in which services are delivered. More information can be found here: http://hl7.org/fhir/R4/v3/ServiceDeliveryLocationRoleType/vs.html | – | – |
| telecoms | location_reference | 0..1 | – | – | – |
| telecom | telecoms | 0..unbounded | – | – | telecom |
| address | location_reference | 0..1 | – | – | address |
| adjudications | item | 0..1 | – | – | – |
| adjudication | adjudications | 0..unbounded | – | – | – |
| adjudication_amount_type | adjudication | 0..unbounded | – | – | – |
| category | adjudication_amount_type | 1..1 | – | – | – |
| code | category | 1..1 | – | – | adjudication_category |
| system | category | 0..1 | – | – | – |
| reason | adjudication_amount_type | 0..1 | Adjudication Reason Codes | – | core:string |
| amount | adjudication_amount_type | 0..1 | – | – | – |
| value | amount | 0..1 | – | – | decimal |
| currency | amount | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| value | adjudication_amount_type | 0..1 | Non-monitary value | – | decimal |
| denial_reason | adjudication | 0..unbounded | – | – | – |
| code | denial_reason | 1..1 | – | – | – |
| system | denial_reason | 1..1 | – | – | – |
| reason | denial_reason | 1..1 | Adjudication Denial Reason | – | – |
| code | reason | 1..1 | – | – | core:string |
| system | reason | 0..1 | – | – | – |
| amount | denial_reason | 0..1 | – | – | – |
| value | amount | 0..1 | – | – | decimal |
| currency | amount | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| value | denial_reason | 0..1 | – | – | decimal |
| allowed_units | adjudication | 0..1 | – | – | – |
| category | allowed_units | 1..1 | – | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| reason | allowed_units | 0..1 | Explanation of adjudication outcome | – | core:string |
| amount | allowed_units | 0..1 | – | – | – |
| value | amount | 0..1 | – | – | decimal |
| currency | amount | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| value | allowed_units | 0..1 | – | – | decimal |
| in_out_network | adjudication | 0..1 | – | – | – |
| category | in_out_network | 1..1 | Indicates the in network or out of network payment status of the claim. More info can be found here: http://hl7.org/fhir/us/carin-bb/STU1/ValueSet-C4BBPayerBenefitPaymentStatus.html | – | – |
| reason | in_out_network | 0..1 | Adjudication Reason Codes | – | core:string |
| amount | in_out_network | 0..1 | – | – | – |
| value | amount | 0..1 | – | – | decimal |
| currency | amount | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| value | in_out_network | 0..1 | – | – | decimal |
| adjudication_generic | adjudication | 0..unbounded | – | – | – |
| category | adjudication_generic | 1..1 | – | – | – |
| code | category | 1..1 | – | – | adjudication_category |
| system | category | 0..1 | – | – | – |
| reason | adjudication_generic | 0..1 | Explanation of adjudication outcome | – | core:string |
| amount | adjudication_generic | 0..1 | – | – | – |
| value | amount | 0..1 | – | – | decimal |
| currency | amount | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| value | adjudication_generic | 0..1 | – | – | decimal |
| details | item | 0..1 | – | – | – |
| detail | details | 0..unbounded | – | – | – |
| product_or_service | detail | 1..1 | Billing, service, product, or drug code | – | core:string |
| quantity | detail | 0..1 | – | – | – |
| value | quantity | 0..1 | – | – | decimal |
| unit | quantity | 0..1 | – | – | core:string |
| system | quantity | 0..1 | – | – | core:string |
| code | quantity | 0..1 | – | – | core:string |
| adjudications | eob | 0..1 | – | – | – |
| adjudication | adjudications | 0..unbounded | – | – | – |
| adjudication_amount_type | adjudication | 0..unbounded | – | – | – |
| category | adjudication_amount_type | 1..1 | – | – | – |
| code | category | 1..1 | – | – | adjudication_category |
| system | category | 0..1 | – | – | – |
| reason | adjudication_amount_type | 0..1 | Adjudication Reason Codes | – | core:string |
| amount | adjudication_amount_type | 1..1 | – | – | – |
| value | amount | 0..1 | – | – | decimal |
| currency | amount | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| value | adjudication_amount_type | 0..1 | – | – | decimal |
| denial_reason | adjudication | 0..unbounded | – | – | – |
| category | denial_reason | 1..1 | – | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| reason | denial_reason | 0..1 | Explanation of adjudication outcome | – | core:string |
| amount | denial_reason | 0..1 | – | – | – |
| value | amount | 0..1 | – | – | decimal |
| currency | amount | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| value | denial_reason | 0..1 | – | – | decimal |
| adjudication_generic | adjudication | 0..unbounded | – | – | – |
| category | adjudication_generic | 1..1 | – | – | – |
| code | category | 1..1 | – | – | adjudication_category |
| system | category | 0..1 | – | – | – |
| reason | adjudication_generic | 0..1 | Explanation of adjudication outcome | – | core:string |
| amount | adjudication_generic | 0..1 | – | – | – |
| value | amount | 0..1 | – | – | decimal |
| currency | amount | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| value | adjudication_generic | 0..1 | – | – | decimal |
| totals | eob | 1..1 | – | – | – |
| total | totals | 1..unbounded | – | – | – |
| adjudication_amount_type | total | 1..unbounded | – | – | – |
| category | adjudication_amount_type | 1..1 | – | – | – |
| code | category | 1..1 | – | – | adjudication_category |
| system | category | 1..1 | – | – | – |
| amount | adjudication_amount_type | 1..1 | – | – | – |
| value | amount | 1..1 | – | – | decimal |
| currency | amount | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| in_out_network | total | 0..1 | – | – | – |
| category | in_out_network | 1..1 | – | – | – |
| code | category | 1..1 | Indicates the in network or out of network payment status of the claim. More info can be found here: : http://hl7.org/fhir/us/carin-bb/STU1/ValueSet-C4BBPayerBenefitPaymentStatus.html | – | – |
| system | category | 1..1 | – | – | – |
| amount | in_out_network | 1..1 | – | – | – |
| value | amount | 1..1 | – | – | decimal |
| currency | amount | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| payment | eob | 0..1 | – | – | – |
| type | payment | 0..1 | Indicates whether the claim / item was paid or denied. More information can be found here: http://hl7.org/fhir/us/carin-bb/STU1/ValueSet-C4BBPayerClaimPaymentStatusCode.html | – | – |
| adjustment | payment | 0..1 | – | – | – |
| value | adjustment | 0..1 | – | – | decimal |
| currency | adjustment | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| adjustment_reason | payment | 0..1 | Payment Adjustment Reason Code | – | core:string |
| date | payment | 0..1 | Expected date of payment | – | date |
| amount | payment | 0..1 | Payable amount after adjustment | – | – |
| value | amount | 0..1 | – | – | decimal |
| currency | amount | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| identifier | payment | 0..1 | Business identifier for the payment | – | identifier |
| process_notes | eob | 0..1 | – | – | – |
| process_note | process_notes | 0..unbounded | Note concerning adjudication | – | – |
| number | process_note | 0..1 | Note instance identifier | – | core:positiveInt |
| type | process_note | 0..1 | The presentation types of notes. More information can be found here: http://hl7.org/fhir/R4/valueset-note-type.html | – | – |
| text | process_note | 0..1 | Note explanatory text | – | core:string |
| language | process_note | 0..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html | – | language |
| benefit_period | eob | 0..1 | – | – | period |
| benefit_balances | eob | 0..1 | – | – | – |
| benefit_balance | benefit_balances | 0..unbounded | – | – | – |
| category | benefit_balance | 1..1 | Benefit Category Codes. More information can be found here: http://hl7.org/fhir/R4/valueset-ex-benefitcategory.html Preferred code sets list: 1,2,3,4,5,14,23,24,25,26,27,28,30,35,36,37,49,55,56,61,62,63,69,76,F1,F3,F4,F6 | – | core:string |
| is_excluded | benefit_balance | 0..1 | Excluded from the plan | – | xs:boolean |
| name | benefit_balance | 0..1 | Short name for the benefit | – | core:string |
| description | benefit_balance | 0..1 | Description of the benefit or services covered | – | core:string |
| network | benefit_balance | 0..1 | In or out of network. More information can be found here: http://hl7.org/fhir/R4/valueset-benefit-network.html Preferred code sets list: in or out | – | core:string |
| unit | benefit_balance | 0..1 | Individual or family. More information can be found here: http://hl7.org/fhir/R4/valueset-benefit-unit.html Preferred code sets list: individual or individual | – | core:string |
| term | benefit_balance | 0..1 | Annual or lifetime. More information can be found here: http://hl7.org/fhir/R4/valueset-benefit-term.html Preferred code sets list: annual or day or lifetime | – | core:string |
| financials | benefit_balance | 0..1 | – | – | – |
| financial | financials | 0..unbounded | – | – | – |
| type | financial | 1..1 | Benefit classification. More information can be found here: http://hl7.org/fhir/R4/valueset-benefit-type.html Preferred code sets list: benefit,deductible,visit,room,copay,copay-percent,copay-maximum,vision-exam,vision-glasses,vision-contacts,medical-primarycare,pharmacy-dispense | – | core:string |
| allowed | financial | 0..1 | – | – | – |
| – | allowed | – | One of: allowed_unsigned_int, allowed_string, allowed_money | – | choice |
| allowed_unsigned_int | allowed | 0..1 | – | – | unsignedInt |
| allowed_string | allowed | 0..1 | – | – | core:string |
| allowed_money | allowed | 0..1 | – | – | – |
| value | allowed_money | 0..1 | – | – | decimal |
| currency | allowed_money | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| used | financial | 0..1 | – | – | – |
| – | used | – | One of: used_unsigned_int, used_money | – | choice |
| used_unsigned_int | used | 0..1 | – | – | unsignedInt |
| used_money | used | 0..1 | – | – | – |
| value | used_money | 0..1 | – | – | decimal |
| currency | used_money | 0..1 | Currency codes which can be found here: http://hl7.org/fhir/R4/valueset-currencies.html | – | currency |
| supporting_infos | eob | 0..1 | – | – | – |
| supporting_info | supporting_infos | 0..unbounded | – | – | – |
| billing_network_contracting_status | supporting_info | 0..1 | – | – | – |
| sequence | billing_network_contracting_status | 1..1 | Information instance identifier | – | core:positiveInt |
| category | billing_network_contracting_status | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | billing_network_contracting_status | 1..1 | – | – | – |
| code | code | 1..1 | – | – | – |
| system | code | 0..1 | – | – | – |
| timing | billing_network_contracting_status | 0..1 | – | – | timing |
| value | billing_network_contracting_status | 0..1 | – | – | value |
| reason | billing_network_contracting_status | 0..1 | – | – | core:string |
| admission_period | supporting_info | 0..1 | – | – | – |
| sequence | admission_period | 1..1 | Information instance identifier | – | core:positiveInt |
| category | admission_period | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | admission_period | 0..1 | Preferred code sets list: student,disabled | – | core:string |
| timing | admission_period | 1..1 | – | – | – |
| timingPeriod | timing | 1..1 | – | – | period |
| value | admission_period | 0..1 | – | – | value |
| reason | admission_period | 0..1 | – | – | core:string |
| clm_recvd_date | supporting_info | 0..1 | – | – | – |
| sequence | clm_recvd_date | 1..1 | Information instance identifier | – | core:positiveInt |
| category | clm_recvd_date | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | clm_recvd_date | 0..1 | Preferred code sets list: student,disabled | – | core:string |
| timing | clm_recvd_date | 1..1 | – | – | date |
| value | clm_recvd_date | 0..1 | – | – | value |
| reason | clm_recvd_date | 0..1 | – | – | core:string |
| type_of_bill | supporting_info | 0..1 | – | – | – |
| sequence | type_of_bill | 1..1 | Information instance identifier | – | core:positiveInt |
| category | type_of_bill | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | type_of_bill | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| system | code | 0..1 | – | – | – |
| timing | type_of_bill | 0..1 | – | – | timing |
| value | type_of_bill | 0..1 | – | – | value |
| reason | type_of_bill | 0..1 | – | – | core:string |
| point_of_origin | supporting_info | 0..1 | – | – | – |
| sequence | point_of_origin | 1..1 | Information instance identifier | – | core:positiveInt |
| category | point_of_origin | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | point_of_origin | 0..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| system | code | 0..1 | – | – | – |
| timing | point_of_origin | 0..1 | – | – | timing |
| value | point_of_origin | 0..1 | – | – | value |
| reason | point_of_origin | 0..1 | – | – | core:string |
| adm_type | supporting_info | 0..1 | – | – | – |
| sequence | adm_type | 1..1 | Information instance identifier | – | core:positiveInt |
| category | adm_type | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | adm_type | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| system | code | 0..1 | – | – | – |
| timing | adm_type | 0..1 | – | – | timing |
| value | adm_type | 0..1 | – | – | value |
| reason | adm_type | 0..1 | – | – | core:string |
| discharge_status | supporting_info | 0..1 | – | – | – |
| sequence | discharge_status | 1..1 | Information instance identifier | – | core:positiveInt |
| category | discharge_status | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | discharge_status | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| system | code | 0..1 | – | – | – |
| timing | discharge_status | 0..1 | – | – | timing |
| value | discharge_status | 0..1 | – | – | value |
| reason | discharge_status | 0..1 | – | – | core:string |
| drg | supporting_info | 0..1 | – | – | – |
| sequence | drg | 1..1 | Information instance identifier | – | core:positiveInt |
| category | drg | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | drg | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| system | code | 0..1 | – | – | – |
| timing | drg | 0..1 | – | – | timing |
| value | drg | 0..1 | – | – | value |
| reason | drg | 0..1 | – | – | core:string |
| performing_network_contracting_status | supporting_info | 0..1 | – | – | – |
| sequence | performing_network_contracting_status | 1..1 | Information instance identifier | – | core:positiveInt |
| category | performing_network_contracting_status | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | performing_network_contracting_status | 1..1 | – | – | – |
| code | code | 1..1 | – | – | – |
| system | code | 0..1 | – | – | – |
| timing | performing_network_contracting_status | 0..1 | – | – | timing |
| value | performing_network_contracting_status | 0..1 | – | – | value |
| reason | performing_network_contracting_status | 0..1 | – | – | core:string |
| service_facility | supporting_info | 0..1 | – | – | – |
| sequence | service_facility | 1..1 | Information instance identifier | – | core:positiveInt |
| category | service_facility | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | service_facility | 0..1 | Preferred code sets list: student,disabled | – | core:string |
| timing | service_facility | 0..1 | – | – | timing |
| value | service_facility | 1..1 | – | – | – |
| value_reference | value | 1..1 | – | – | organization |
| reason | service_facility | 0..1 | – | – | core:string |
| brand_generic_code | supporting_info | 0..1 | – | – | – |
| sequence | brand_generic_code | 1..1 | Information instance identifier | – | core:positiveInt |
| category | brand_generic_code | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | brand_generic_code | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| system | code | 0..1 | – | – | – |
| timing | brand_generic_code | 0..1 | – | – | timing |
| value | brand_generic_code | 0..1 | – | – | value |
| reason | brand_generic_code | 0..1 | – | – | core:string |
| rx_origin_code | supporting_info | 0..1 | – | – | – |
| sequence | rx_origin_code | 1..1 | Information instance identifier | – | core:positiveInt |
| category | rx_origin_code | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | rx_origin_code | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| system | code | 0..1 | – | – | – |
| timing | rx_origin_code | 0..1 | – | – | timing |
| value | rx_origin_code | 0..1 | – | – | value |
| reason | rx_origin_code | 0..1 | – | – | core:string |
| compound_code | supporting_info | 0..1 | – | – | – |
| sequence | compound_code | 1..1 | Information instance identifier | – | core:positiveInt |
| category | compound_code | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | ICD-10-CM Diagnosis Codes-Large list of codes hence no enumeration included | – | – |
| system | category | 1..1 | – | – | – |
| code | compound_code | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| system | code | 0..1 | – | – | – |
| timing | compound_code | 0..1 | – | – | timing |
| value | compound_code | 0..1 | – | – | value |
| reason | compound_code | 0..1 | – | – | core:string |
| days_supply | supporting_info | 0..1 | – | – | – |
| sequence | days_supply | 1..1 | Information instance identifier | – | core:positiveInt |
| category | days_supply | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | days_supply | 0..1 | Preferred code sets list: student,disabled | – | core:string |
| timing | days_supply | 0..1 | – | – | timing |
| value | days_supply | 0..1 | – | – | quantity |
| reason | days_supply | 0..1 | – | – | core:string |
| dawcode | supporting_info | 0..1 | – | – | – |
| sequence | dawcode | 1..1 | Information instance identifier | – | core:positiveInt |
| category | dawcode | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | dawcode | 1..1 | – | – | – |
| code | code | 1..1 | – | – | core:string |
| system | code | 0..1 | – | – | – |
| timing | dawcode | 0..1 | – | – | timing |
| value | dawcode | 0..1 | – | – | value |
| reason | dawcode | 0..1 | – | – | core:string |
| refill_num | supporting_info | 0..1 | – | – | – |
| sequence | refill_num | 1..1 | Information instance identifier | – | core:positiveInt |
| category | refill_num | 1..1 | Classification of the supplied information | – | – |
| code | category | 1..1 | – | – | – |
| system | category | 1..1 | – | – | – |
| code | refill_num | 0..1 | Preferred code sets list: student,disabled | – | core:string |
| timing | refill_num | 0..1 | – | – | timing |
| value | refill_num | 0..1 | – | – | quantity |
| reason | refill_num | 0..1 | – | – | core:string |
| record_type | eob | 1..1 | This element describes the action for this member (A = Add, U = Update, D = Delete) | – | – |


</div>



<h2 style="color:#E60073">Practical Guidance</h2>

<h3 style="color:#E60073">Submission Frequency</h3>

EOB files should be submitted according to the schedule agreed upon with HealthLX. Typical submission frequencies include daily, weekly, or monthly updates.

<h3 style="color:#E60073">Adds, Updates, and Deletes</h3>

- **Adds**: Include new member records with all required fields populated
- **Updates**: Submit complete member records with updated information
- **Deletes**: Follow the agreed-upon process for member terminations or removals

<h3 style="color:#E60073">Member Identification</h3>

Each member must be uniquely identified using the appropriate identifier fields. Ensure consistency in member identifiers across all submissions to maintain data integrity.

