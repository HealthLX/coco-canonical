
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

# Roster Implementation Guide

**HLX0123 HLX Roster IG (XSD_V10.0)**

**Version 10.0**

**February 6, 2026**

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

<h2 style="color:#E60073">Disclaimer</h2>

This document is provided by HealthLX for informational purposes only. Information within this document is believed to be correct as of the noted date of publication. Although HealthLX makes every reasonable effort to present information in a timely and accurate manner, HealthLX does not warrant this information for accuracy, completeness or fitness for any purpose, express or implied. The information provided herein does not constitute the rendering of legal, financial or other professional advice or recommendations by HealthLX.

<h2 style="color:#E60073">Overview</h2>

This implementation guide provides field mappings and requirements for HealthLX Roster data submissions in XML format based on FHIR R4 standards. XML format enables structured data exchange with built-in validation against the provided XSD schema.

<h2 style="color:#E60073">Overview</h2>

This implementation guide provides field mappings and requirements for HealthLX Roster data submissions in XML format based on FHIR R4 standards. XML format enables structured data exchange with built-in validation against the provided XSD schema.

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
| string | xs:string | – |  |
| positiveInt | xs:positiveInteger | – | \+?[1-9][0-9]* |
| unsignedInt | xs:unsignedInt | – | 0\|([1-9][0-9]*) |
| integer | xs:integer | – | [0]\|[-+]?[1-9][0-9]* |
| date | xs:date | – | ([12]\d{3}-(0[1-9]\|1[0-2])-(0[1-9]\|[12]\d\|3[01])) |
| dateTime | xs:string | – | ([12]\d{3})-(0[1-9]\|1[0-2])-(0[1-9]\|[1-2][0-9]\|3[0-1])(T([01][0-9]\|2[0-3]):[0-5][0-9]:[0-5][0-9](\.\d{1,6})?((Z\|(\+\|-)((0[0-9]\|1[0-3]):(00\|15\|30\|45)\|14:00))?))? |


</div>



<h2 style="color:#E60073"> Complex Types</h2>

<h3 style="color:#E60073">period</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| start | xs:dateTime | 0 | 1 | – |
| end | xs:dateTime | 0 | 1 | – |


</div>



<h3 style="color:#E60073">period_date</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| start | xs:date | 0 | 1 | – |
| end | xs:date | 0 | 1 | – |


</div>



<h3 style="color:#E60073">identifier</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | xs:string | 1 | 1 | – |
| type | xs:string | 1 | 1 | – |


</div>



<h3 style="color:#E60073">organization</h3>

<div class = "heatMap">

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


</div>



<h3 style="color:#E60073">telecom</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| system | – | 1 | 1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html |
| value | string | 1 | 1 | The actual value of the contact point |
| use | – | 0 | 1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html |
| rank | positiveInt | 0 | 1 | Specify preferred order of use (1 = highest) |
| period | period | 0 | 1 | Time period when the contact point was/is in use |


</div>



<h3 style="color:#E60073">address</h3>

<div class = "heatMap">

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
| country | xs:string | 0 | 1 | Country (e.g. can be ISO 3166 2 or 3 letter code) |
| period | period | 0 | 1 | – |


</div>



<h3 style="color:#E60073">codeableConcept</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| coding | – | 1 | 1 | – |
| code | xs:string | 1 | 1 | – |
| system | xs:anyURI | 1 | 1 | – |
| display | xs:string | 1 | 1 | – |
| text | xs:string | 1 | 1 | – |


</div>



<h2 style="color:#E60073">Required Elements of Roster XSD</h2>

<div class = "heatMap">

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| roster |  | 1..1 | – | – | – |
| schema_version | roster | 1..1 | This element defines what version of the roster schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | roster | 1..1 | This element is used to the unique identifier assigned to your organization | – | string |
| date_time_reported | roster | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |
| member | roster | 1..unbounded | – | – | – |
| – | member | – | All of (any order): us_core_race, us_core_ethnicity, us_core_birth_sex, is_subscriber, relationship, birth_date, deceased_date_time, gender, tribal_affiliations, sexual_orientations, gender_identities, relatedPersons, occupations, unique_person_ids, member_identity, member_id, member_id_system, subscriber_id, names, telecoms, addresses, health_coverage, communications, smoking_status, record_type, unique_record_identifier, delegates | – | all |
| text | us_core_race | 1..1 | Use this element for adding a text description | – | string |
| text | us_core_ethnicity | 1..1 | Use this element for adding a text description | – | string |
| is_subscriber | member | 1..1 | This element is used to identify if this person is the subscriber (True / False). (e.g. The main policy holder of the plan) | – | xs:boolean |
| relationship | member | 1..1 | Relationship to the Subscriber. The full list can be found here: http://hl7.org/fhir/R4/valueset-subscriber-relationship.html | – | – |
| birth_date | member | 1..1 | Birth date (1900-01-01) | – | date |
| gender | member | 1..1 | Use this element for Sex/Administrative Gender (male, female, other or unknown) | – | – |
| tribal_affiliation | tribal_affiliations | 1..unbounded | – | – | – |
| codeable_concept | tribal_affiliation | 1..1 | – | – | codeableConcept |
| is_enrolled | tribal_affiliation | 1..1 | – | – | xs:boolean |
| sexual_orientation | sexual_orientations | 1..unbounded | – | – | – |
| codeable_concept | sexual_orientation | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | sexual_orientation | 1..1 | MUST be one of: registered \| preliminary \| final \| amended | – | – |
| gender_identity | gender_identities | 1..unbounded | – | – | – |
| codeable_concept | gender_identity | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | gender_identity | 1..1 | MUST be one of: registered \| preliminary \| final \| amended | – | – |
| relatedPerson | relatedPersons | 1..unbounded | – | – | – |
| active | relatedPerson | 1..1 | – | – | xs:boolean |
| names | relatedPerson | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| use | name | 1..1 | – | – | xs:string |
| text | name | 1..1 | – | – | xs:string |
| family | name | 1..1 | – | – | xs:string |
| given | name | 1..unbounded | – | – | xs:string |
| telecoms | relatedPerson | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
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
| communication_language | relatedPerson | 1..1 | – | – | xs:string |
| relationship | relatedPerson | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| occupation_item | occupations | 1..unbounded | – | – | – |
| status | occupation_item | 1..1 | – | – | – |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| industry | occupation_item | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| unique_person_ids | member | 1..1 | – | – | – |
| unique_person_id | unique_person_ids | 1..1 | This is the person's unique member number in the Payer system across plans. This number is not reused for anyone else. | – | string |
| unique_person_id_assigner | unique_person_ids | 1..1 | Organization that issued id | – | xs:string |
| member_id | member | 1..1 | Use this element to list the Member Number. | – | string |
| subscriber_id | member | 1..1 | Use this element to list the Subscriber Number. An identifier for a subscriber of an insurance policy which is unique for, and usually assigned by, the insurance carrier. Use Case: A person is the subscriber of an insurance policy. The person’s family may be plan members, but are not the subscriber. | – | string |
| names | member | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | – |
| text | name | 1..1 | Use this element to enter the entire name of the member | – | string |
| family | name | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | name | 1..unbounded | Given names (not always 'first'). Includes middle names | – | string |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. Please provide at least one form of contact (e.g. phone, email, etc.) | – | – |
| system | telecom | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | telecom | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| address | addresses | 1..unbounded | Use this element to list all the addresses the member is associated with. It is recommended that at least one address be supplied for identification purposes. | – | – |
| text | address | 1..1 | Use this element to list the address in it's entirety (e.g. 123 Test Way City, State 12345) | – | string |
| line | address | 1..unbounded | – | – | string |
| city | address | 1..1 | – | – | string |
| state | address | 1..1 | – | – | string |
| postal_code | address | 1..1 | – | – | string |
| country | address | 1..1 | Country (e.g. can be ISO 3166 2 or 3 letter code) | – | string |
| health_coverage | member | 1..1 | – | – | – |
| plan_id | health_coverage | 1..1 | The Identifier of the plan associated with the Plan Name | – | string |
| plan_name | health_coverage | 1..1 | – | – | string |
| coverage_status | health_coverage | 1..1 | Indicates the current status of coverage for the member. Must be one of: active, cancelled, draft, entered-in-error | – | string |
| codeable_concept | coverage_type | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| coverage_period | health_coverage | 1..1 | Use this element to provide dates of coverage for this member. If the coverage is still active, do not provide an End date. Format is YYYY-MM-DD. | – | period |
| communication | communications | 1..unbounded | Use this element to provide the languages the member communicates in | – | – |
| language_code | communication | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| unique_record_identifier | member | 1..1 | – | – | string |
| delegate | delegates | 1..unbounded | – | – | – |
| family | delegate | 1..1 | Family name (often called 'Surname') (Note: At least Family or Given need to be filled in) | – | string |
| given | delegate | 1..1 | Given names (not always 'first'). Includes middle names | – | string |
| telecoms | delegate | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. | – | – |
| system | telecom | 1..1 | – | – | – |
| value | telecom | 1..1 | – | – | string |
| email_address | delegate | 1..1 | – | – | string |
| is_member | delegate | 1..1 | Fixed to false | – | – |


</div>



<h2 style="color:#E60073">All Elements of Roster XSD</h2>

<h3 style="color:#E60073">Root Elements</h3>

<div class = "heatMap">

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| roster |  | 1..1 | – | – | – |
| schema_version | roster | 1..1 | This element defines what version of the roster schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | roster | 1..1 | This element is used to the unique identifier assigned to your organization | – | string |
| date_time_reported | roster | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |
| member | roster | 1..unbounded | – | – | – |
| – | member | – | All of (any order): us_core_race, us_core_ethnicity, us_core_birth_sex, is_subscriber, relationship, birth_date, deceased_date_time, gender, tribal_affiliations, sexual_orientations, gender_identities, relatedPersons, occupations, unique_person_ids, member_identity, member_id, member_id_system, subscriber_id, names, telecoms, addresses, health_coverage, communications, smoking_status, record_type, unique_record_identifier, delegates | – | all |
| us_core_race | member | 0..1 | – | – | – |
| code | us_core_race | 0..5 | This element is for selecting 1 of the 5 OMB race category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html | – | – |
| detailed_code | us_core_race | 0..unbounded | This element is for selecting 1 of the additional expansion codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html | – | – |
| text | us_core_race | 1..1 | Use this element for adding a text description | – | string |
| us_core_ethnicity | member | 0..1 | – | – | – |
| code | us_core_ethnicity | 0..1 | This element is for selecting 1 of the OMB ethnicity category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-omb-ethnicity-category.html | – | – |
| detailed_code | us_core_ethnicity | 0..unbounded | This element is for selecting 1 of the additional ethnicity codes from the CDC that can be found here: https://www.hl7.org/fhir/us/core/ValueSet-detailed-ethnicity.html | – | – |
| text | us_core_ethnicity | 1..1 | Use this element for adding a text description | – | string |
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
| sexual_orientations | member | 0..1 | – | – | – |
| sexual_orientation | sexual_orientations | 1..unbounded | – | – | – |
| codeable_concept | sexual_orientation | 1..1 | MUST be one of: https://hl7.org/fhir/us/core/STU6.1/ValueSet-us-core-sexual-orientation.html | – | codeableConcept |
| status | sexual_orientation | 1..1 | MUST be one of: registered \| preliminary \| final \| amended | – | – |
| gender_identities | member | 0..1 | – | – | – |
| gender_identity | gender_identities | 1..unbounded | – | – | – |
| codeable_concept | gender_identity | 1..1 | SHOULD be one of: https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.32/expansion | – | codeableConcept |
| status | gender_identity | 1..1 | MUST be one of: registered \| preliminary \| final \| amended | – | – |
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
| telecoms | relatedPerson | 1..1 | – | – | – |
| telecom | telecoms | 1..unbounded | – | – | – |
| system | telecom | 1..1 | – | – | xs:string |
| value | telecom | 1..1 | – | – | xs:string |
| use | telecom | 1..1 | – | – | xs:string |
| rank | telecom | 0..1 | – | – | xs:integer |
| period | telecom | 0..1 | – | – | period_date |
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
| communication_language | relatedPerson | 1..1 | – | – | xs:string |
| relationship | relatedPerson | 1..1 | – | – | – |
| codeable_concept | relationship | 1..1 | – | – | codeableConcept |
| occupations | member | 0..1 | – | – | – |
| occupation_item | occupations | 1..unbounded | – | – | – |
| status | occupation_item | 1..1 | – | – | – |
| effectivePeriod | occupation_item | 0..1 | – | – | period_date |
| codeable_concept | occupation_item | 1..1 | – | – | codeableConcept |
| industry | occupation_item | 1..1 | – | – | – |
| codeable_concept | industry | 1..1 | – | – | codeableConcept |
| unique_person_ids | member | 1..1 | – | – | – |
| unique_person_id | unique_person_ids | 1..1 | This is the person's unique member number in the Payer system across plans. This number is not reused for anyone else. | – | string |
| unique_person_id_assigner | unique_person_ids | 1..1 | Organization that issued id | – | xs:string |
| unique_person_id_assigner_type | unique_person_ids | 0..1 | Type of organization that issued id | – | string |
| member_identity | member | 0..1 | – | – | – |
| member_last_4_ssn | member_identity | 0..1 | Use this element for last 4 digit of member SSN (0000) | – | xs:string |
| secret_display_name | member_identity | 0..1 | Use this element for the secret display name when SSN is not available | – | string |
| secret_value | member_identity | 0..1 | Use this element for the secret value when SSN is not available | – | string |
| secret_length | member_identity | 0..1 | Use this element for the secret length when SSN is not available | – | unsignedInt |
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
| telecoms | member | 0..1 | – | – | – |
| telecom | telecoms | 1..unbounded | Contact points of telecommunications. Please provide at least one form of contact (e.g. phone, email, etc.) | – | – |
| system | telecom | 1..1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html | – | – |
| value | telecom | 1..1 | The actual value of the contact point. This is a free form text field allowing country and extension. (e.g. (+001) 111-111-1111 x1111) | – | string |
| use | telecom | 0..1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html | – | – |
| rank | telecom | 0..1 | Specify preferred order of use (1 = highest) | – | positiveInt |
| period | telecom | 0..1 | Time period when the contact point was/is in use | – | period |
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
| health_coverage | member | 1..1 | – | – | – |
| group_number | health_coverage | 0..1 | – | – | string |
| policy_number | health_coverage | 0..1 | Each person covered by a health insurance plan has a unique ID number that allows healthcare providers and their staff to verify coverage and arrange payment for services. This is also known as member number and/or card-id and or member-id. | – | string |
| plan_id | health_coverage | 1..1 | The Identifier of the plan associated with the Plan Name | – | string |
| plan_name | health_coverage | 1..1 | – | – | string |
| coverage_status | health_coverage | 1..1 | Indicates the current status of coverage for the member. Must be one of: active, cancelled, draft, entered-in-error | – | string |
| coverage_type | health_coverage | 0..1 | – | – | – |
| codeable_concept | coverage_type | 1..1 | Category of healthcare payers, insurance products, or benefits. | – | codeableConcept |
| coverage_period | health_coverage | 1..1 | Use this element to provide dates of coverage for this member. If the coverage is still active, do not provide an End date. Format is YYYY-MM-DD. | – | period |
| network_id | health_coverage | 0..1 | Network associated with the plan | – | string |
| payor | health_coverage | 0..1 | Payer Identifier-Issuer of the Policy | – | organization |
| communications | member | 0..1 | – | – | – |
| communication | communications | 1..unbounded | Use this element to provide the languages the member communicates in | – | – |
| language_code | communication | 1..1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html Also includes the List of ISO 639 language codes officially assigned. More info can be found here: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | – | – |
| display | communication | 0..1 | Type the name of the language if not found here (http://hl7.org/fhir/R4/datatypes.html#CodeableConcept) | – | string |
| is_preferred | communication | 0..1 | Is this language the preferred language (true/false) | – | xs:boolean |
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
| email_address | delegate | 1..1 | – | – | string |
| start | delegate | 0..1 | – | – | dateTime |
| end | delegate | 0..1 | – | – | dateTime |
| is_member | delegate | 1..1 | Fixed to false | – | – |


</div>



<h2 style="color:#E60073">Practical Guidance</h2>

<h3 style="color:#E60073">Submission Frequency</h3>

Roster files should be submitted according to the schedule agreed upon with HealthLX. Typical submission frequencies include daily, weekly, or monthly updates.

<h3 style="color:#E60073">Adds, Updates, and Deletes</h3>

- **Adds**: Include new member records with all required fields populated
- **Updates**: Submit complete member records with updated information
- **Deletes**: Follow the agreed-upon process for member terminations or removals

<h3 style="color:#E60073">Member Identification</h3>

Each member must be uniquely identified using the appropriate identifier fields. Ensure consistency in member identifiers across all submissions to maintain data integrity.

