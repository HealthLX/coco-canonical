
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

# Insurance Plan_V4.2 Implementation Guide

**HLX0123 HLX Insurance Plan_V4.2 IG (XSD_V4.1)**

**Version 4.1**

**January 27, 2026**

**Table of Contents**

1. [Overview](#overview)
2. [Encoding](#encoding)
3. [Interoperability](#interoperability)
4. [Change Log](#change-log)
5. [Simple Types](#simple-types)
6. [Complex Types](#complex-types)
7. [Required Elements of Insurance Plan_V4.2 XSD](#required-elements-of-insurance-plan_v4.2-xsd)
8. [All Elements of Insurance Plan_V4.2 XSD](#all-elements-of-insurance-plan_v4.2-xsd)
9. [Practical Guidance](#practical-guidance)

<h2 style="color:#E60073">Disclaimer</h2>

This document is provided by HealthLX for informational purposes only. Information within this document is believed to be correct as of the noted date of publication. Although HealthLX makes every reasonable effort to present information in a timely and accurate manner, HealthLX does not warrant this information for accuracy, completeness or fitness for any purpose, express or implied. The information provided herein does not constitute the rendering of legal, financial or other professional advice or recommendations by HealthLX.

<h2 style="color:#E60073">Overview</h2>

This implementation guide provides field mappings and requirements for HealthLX Insurance Plan_V4.2 data submissions in XML format based on FHIR R4 standards. XML format enables structured data exchange with built-in validation against the provided XSD schema.

<h2 style="color:#E60073">Overview</h2>

This implementation guide provides field mappings and requirements for HealthLX Insurance Plan_V4.2 data submissions in XML format based on FHIR R4 standards. XML format enables structured data exchange with built-in validation against the provided XSD schema.

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
| 4.1 | January 27, 2026 |

</div>

<h2 style="color:#E60073"> Simple Types</h2>

<div class = "heatMap">

| Name | Base Type | Description | Pattern |
| --- | --- | --- | --- |
| string | xs:string | – | [ \r\n\t\S]+ |
| NPI | xs:string | – | [0-9]{10} |
| network_id | xs:string | – | [A-Za-z0-9\-\.]{1,64} |
| resource_id | xs:string | – | [A-Za-z0-9\-\.]{1,64} |
| positiveInt | xs:positiveInteger | – | \+?[1-9][0-9]* |
| unsignedInt | xs:unsignedInt | – | 0\|([1-9][0-9]*) |
| integer | xs:integer | – | [0]\|[-+]?[1-9][0-9]* |
| time | xs:time | – | ([01][0-9]\|2[0-3]):[0-5][0-9]:[0-5][0-9](\.\d{1,9})? |
| dateTime | xs:string | – | ([12]\d{3})-(0[1-9]\|1[0-2])-(0[1-9]\|[1-2][0-9]\|3[0-1])(T([01][0-9]\|2[0-3]):[0-5][0-9]:[0-5][0-9](\.\d{1,6})?((Z\|(\+\|-)((0[0-9]\|1[0-3]):(00\|15\|30\|45)\|14:00))?))? |
| date | xs:date | – | ([12]\d{3}-(0[1-9]\|1[0-2])-(0[1-9]\|[12]\d\|3[01])) |
| decimal | xs:decimal | – | -?(0\|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)? |
| boolean | xs:boolean | – | true\|false |
| location_role_type | string | – |  |
| type_of_organization | string | – |  |
| purpose | string | – |  |


</div>



<h2 style="color:#E60073"> Complex Types</h2>

<h3 style="color:#E60073">identifier</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | string | 1 | 1 | – |
| type | string | 1 | 1 | – |


</div>



<h3 style="color:#E60073">human_name</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| use | – | 0 | 1 | use this element to describe the name. More information can be found here: http://hl7.org/fhir/R4/valueset-name-use.html |
| text | string | 0 | 1 | – |
| family | string | 0 | 1 | family name (often called 'Surname') |
| given | string | 0 | unbounded | Given names (not always 'first'). Includes middle names |
| prefix | string | 0 | unbounded | – |
| suffix | string | 0 | unbounded | – |
| period | period | 0 | 1 | Time period when name was/is in use. If the name is still in use, do not supply an End date |


</div>



<h3 style="color:#E60073">position</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| longitude | decimal | 1 | 1 | – |
| latitude | decimal | 1 | 1 | – |
| altitude | decimal | 0 | 1 | – |


</div>



<h3 style="color:#E60073">address</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| use | – | 0 | 1 | Purpose of this address. A full list can be found here: https://www.hl7.org/fhir/valueset-address-use.html |
| type | – | 0 | 1 | The address type. A full list can be found here: https://www.hl7.org/fhir/valueset-address-type.html |
| text | string | 0 | 1 | The full text representation of the address |
| line | string | 1 | unbounded | – |
| city | string | 1 | 1 | – |
| district | string | 0 | 1 | District name (aka County) |
| state | string | 1 | 1 | – |
| postal_code | string | 1 | 1 | – |
| country | string | 0 | 1 | – |
| period | period | 0 | 1 | Time period when address was/is in use |
| geo_locations | – | 0 | 1 | – |
| geo_location | – | 0 | unbounded | – |
| latitude | decimal | 1 | 1 | – |
| longitude | decimal | 1 | 1 | – |


</div>



<h3 style="color:#E60073">period</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| start | dateTime | 0 | 1 | – |
| end | dateTime | 0 | 1 | – |


</div>



<h3 style="color:#E60073">telecom</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| system | – | 1 | 1 | use this element to describe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html |
| value | string | 1 | 1 | The actual value of the contact point |
| use | – | 0 | 1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html |
| rank | positiveInt | 0 | 1 | Specify preferred order of use (1 = highest) |
| period | period | 0 | 1 | Time period when the contact point was/is in use |
| contactpoint_available_times | – | 0 | 1 | – |
| contactpoint_available_time | available_time | 0 | unbounded | – |
| via_intermediaries | – | 0 | 1 | – |
| via_intermediary | – | 0 | unbounded | – |
| name | string | 1 | 1 | – |
| telecom | – | 0 | unbounded | – |
| system | – | 1 | 1 | The use of the contact point. http://hl7.org/fhir/R4/valueset-contact-point-system.html |
| value | string | 1 | 1 | The actual value of the contact point |


</div>



<h3 style="color:#E60073">organization</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| unique_identifier | resource_id | 1 | 1 | – |
| npi | NPI | 0 | 1 | – |
| clia | string | 0 | 1 | Clinical Laboratory Improvement Amendments (CLIA) Number for laboratories |
| is_active | boolean | 1 | 1 | Whether the organization's record is still in active use |
| types | – | 1 | 1 | – |
| type | type_of_organization | 1 | unbounded | Organization type, a full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-OrgTypeVS.html |
| name | string | 1 | 1 | – |
| alias | string | 0 | unbounded | – |
| org_description | string | 0 | 1 | – |
| part_of | organization_part_of | 0 | 1 | – |
| telecoms | – | 0 | 1 | – |
| telecom | telecom | 0 | unbounded | – |
| addresses | – | 0 | 1 | – |
| address | address | 0 | unbounded | – |


</div>



<h3 style="color:#E60073">organization_part_of</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| unique_identifier | resource_id | 1 | 1 | – |
| npi | NPI | 0 | 1 | – |
| clia | string | 0 | 1 | Clinical Laboratory Improvement Amendments (CLIA) Number for laboratories |
| is_active | boolean | 1 | 1 | Whether the organization's record is still in active use |
| types | – | 1 | 1 | – |
| type | type_of_organization | 1 | unbounded | Organization type, a full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-OrgTypeVS.html |
| name | string | 1 | 1 | – |
| alias | string | 0 | unbounded | – |
| org_description | string | 0 | 1 | – |
| telecoms | – | 0 | 1 | – |
| telecom | telecom | 0 | unbounded | – |
| addresses | – | 0 | 1 | – |
| address | address | 0 | unbounded | – |


</div>



<h3 style="color:#E60073">available_time</h3>

<div class = "heatMap">

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| all_day | boolean | 0 | 1 | Available All Day |
| days_of_week | – | 0 | unbounded | Days of the week available |
| available_start_time | time | 0 | 1 | Opening time of day (ignored if AllDay = true) |
| available_end_time | time | 0 | 1 | Closing time of day (ignored if AllDay = true) |


</div>



<h2 style="color:#E60073">Required Elements of Insurance Plan_V4.2 XSD</h2>

<div class = "heatMap">

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| payer |  | 1..1 | – | – | – |
| schema_version | payer | 1..1 | This element defines what version of the roster schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | payer | 1..1 | This element is used to the unique identifier assigned to your organization | – | string |
| date_time_reported | payer | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |
| payer_type | payer | 1..1 | Organization Type, value is restricted to only 'payer' | – | – |
| payer_unique_identifier | payer | 1..1 | – | – | resource_id |
| payer_name | payer | 1..1 | Name used for the organization | – | string |
| insurance_plan | payer | 1..unbounded | An Insurance Plan is a discrete package of health insurance coverage benefits that are offered under a particular network type.InsurancePlan describes a health insurance offering comprised of a list of covered benefits (i.e. the product), costs associated with those benefits (i.e. the plan), and additional information about the offering, such as who it is owned and administered by, a coverage area, contact information, etc. | – | – |
| plan_id | insurance_plan | 1..1 | Business Identifier for Product\Plan | – | identifier |
| status | insurance_plan | 1..1 | Insurance Plan Status | – | – |
| type | insurance_plan | 1..1 | Insurance Plan Product Type. The full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-InsuranceProductTypeVS.html | – | – |
| administered_by | insurance_plan | 1..1 | – | – | organization |
| status | coverage_area | 1..1 | Status | – | – |
| name | coverage_area | 1..1 | Name of the location as used by humans | – | string |
| networks | insurance_plan | 1..1 | – | – | – |
| network | networks | 1..unbounded | Network associated with Insurance Plans. A plan may be associated with multiple networks, and a network may be associated with many plans | – | – |
| network_id | network | 1..1 | Unique Identifier for this Network | – | network_id |
| status | location_reference | 1..1 | Status | – | – |
| name | location_reference | 1..1 | Name of the location as used by humans | – | string |


</div>



<h2 style="color:#E60073">All Elements of Insurance Plan_V4.2 XSD</h2>

<h3 style="color:#E60073">Root Elements</h3>

<div class = "heatMap">

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| payer |  | 1..1 | – | – | – |
| schema_version | payer | 1..1 | This element defines what version of the roster schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | payer | 1..1 | This element is used to the unique identifier assigned to your organization | – | string |
| date_time_reported | payer | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |
| payer_type | payer | 1..1 | Organization Type, value is restricted to only 'payer' | – | – |
| payer_unique_identifier | payer | 1..1 | – | – | resource_id |
| npi | payer | 0..1 | – | – | NPI |
| clia | payer | 0..1 | Clinical Laboratory Improvement Amendments (CLIA) Number for laboratories | – | string |
| payer_name | payer | 1..1 | Name used for the organization | – | string |
| payer_alias | payer | 0..unbounded | A list of alternate names that the organization is known as, or was known as in the past | – | string |
| org_description | payer | 0..1 | Organization Description | – | string |
| telecoms | payer | 0..1 | – | – | – |
| telecom | telecoms | 0..unbounded | – | – | telecom |
| addresses | payer | 0..1 | – | – | – |
| address | addresses | 0..unbounded | – | – | address |
| insurance_plan | payer | 1..unbounded | An Insurance Plan is a discrete package of health insurance coverage benefits that are offered under a particular network type.InsurancePlan describes a health insurance offering comprised of a list of covered benefits (i.e. the product), costs associated with those benefits (i.e. the plan), and additional information about the offering, such as who it is owned and administered by, a coverage area, contact information, etc. | – | – |
| plan_id | insurance_plan | 1..1 | Business Identifier for Product\Plan | – | identifier |
| status | insurance_plan | 1..1 | Insurance Plan Status | – | – |
| type | insurance_plan | 1..1 | Insurance Plan Product Type. The full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-InsuranceProductTypeVS.html | – | – |
| name | insurance_plan | 0..1 | Official name of Plan | – | string |
| alias | insurance_plan | 0..unbounded | Alternate names | – | string |
| period | insurance_plan | 0..1 | – | – | period |
| administered_by | insurance_plan | 1..1 | – | – | organization |
| coverage_areas | insurance_plan | 0..1 | – | – | – |
| coverage_area | coverage_areas | 0..unbounded | – | – | – |
| status | coverage_area | 1..1 | Status | – | – |
| identifiers | coverage_area | 0..1 | – | – | – |
| identifier | identifiers | 0..unbounded | Unique code or number identifying the location to its users | – | string |
| name | coverage_area | 1..1 | Name of the location as used by humans | – | string |
| alias | coverage_area | 0..unbounded | A list of alternate names that the location is known as, or was known as, in the past | – | string |
| description | coverage_area | 0..1 | Additional details about the location that could be displayed as further information to identify the location beyond its name | – | string |
| type | coverage_area | 0..unbounded | Type of function performed. A full list can be found here: https://www.hl7.org/fhir/v3/ServiceDeliveryLocationRoleType/vs.html | – | location_role_type |
| position | coverage_area | 0..1 | – | – | position |
| contacts | insurance_plan | 0..1 | – | – | – |
| contact | contacts | 0..unbounded | – | – | – |
| name | contact | 0..1 | A name associated with the contact | – | human_name |
| purpose | contact | 0..1 | The purpose of this contact. A full list can be found here: https://www.hl7.org/fhir/valueset-contactentity-type.html | – | purpose |
| telecoms | contact | 0..1 | – | – | – |
| telecom | telecoms | 0..unbounded | – | – | telecom |
| address | contact | 0..1 | – | – | address |
| networks | insurance_plan | 1..1 | – | – | – |
| network | networks | 1..unbounded | Network associated with Insurance Plans. A plan may be associated with multiple networks, and a network may be associated with many plans | – | – |
| network_id | network | 1..1 | Unique Identifier for this Network | – | network_id |
| name | network | 0..1 | Name of the Network | – | string |
| alias | network | 0..unbounded | A list of alternate names that the Network is known as, or was known as in the past | – | string |
| types | network | 0..1 | – | – | – |
| type | types | 0..unbounded | Organization type, a full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-OrgTypeVS.html | – | type_of_organization |
| contacts | network | 0..1 | – | – | – |
| contact | contacts | 0..unbounded | – | – | – |
| name | contact | 0..1 | A name associated with the contact | – | human_name |
| purpose | contact | 0..1 | The purpose of this contact. A full list can be found here: https://www.hl7.org/fhir/valueset-contactentity-type.html | – | purpose |
| telecoms | contact | 0..1 | – | – | – |
| telecom | telecoms | 0..unbounded | – | – | telecom |
| address | contact | 0..1 | – | – | address |
| location_references | network | 0..1 | – | – | – |
| location_reference | location_references | 0..unbounded | – | – | – |
| status | location_reference | 1..1 | Status | – | – |
| operational_status | location_reference | 0..1 | The operational status of the location. A full list can be found here: https://terminology.hl7.org/1.0.0//ValueSet-v2-0116.html | – | – |
| identifiers | location_reference | 0..1 | – | – | – |
| identifier | identifiers | 0..unbounded | Unique code or number identifying the location to its users | – | string |
| name | location_reference | 1..1 | Name of the location as used by humans | – | string |
| alias | location_reference | 0..unbounded | A list of alternate names that the location is known as, or was known as, in the past | – | string |
| description | location_reference | 0..1 | Additional details about the location that could be displayed as further information to identify the location beyond its name | – | string |
| type | location_reference | 0..unbounded | Type of function performed. A full list can be found here: https://www.hl7.org/fhir/v3/ServiceDeliveryLocationRoleType/vs.html | – | location_role_type |
| physical_type | location_reference | 0..1 | Physical form of the location. A full list can be found here: https://www.hl7.org/fhir/valueset-location-physical-type.html | – | – |
| position | location_reference | 0..1 | – | – | position |
| availability_exceptions | network | 0..1 | – | – | string |


</div>



<h2 style="color:#E60073">Practical Guidance</h2>

<h3 style="color:#E60073">Submission Frequency</h3>

Insurance Plan_V4.2 files should be submitted according to the schedule agreed upon with HealthLX. Typical submission frequencies include daily, weekly, or monthly updates.

<h3 style="color:#E60073">Adds, Updates, and Deletes</h3>

- **Adds**: Include new member records with all required fields populated
- **Updates**: Submit complete member records with updated information
- **Deletes**: Follow the agreed-upon process for member terminations or removals

<h3 style="color:#E60073">Member Identification</h3>

Each member must be uniquely identified using the appropriate identifier fields. Ensure consistency in member identifiers across all submissions to maintain data integrity.

