![HLX Logo](../assets/hlx_logo.png)

# Provider-Directory Implementation Guide

**HLX0123 HLX Provider-Directory IG (XSD_V10.0)**

**Version 10.0**

**January 2, 2026**

**Table of Contents**

1. [Overview](#overview)
2. [Encoding](#encoding)
3. [Interoperability](#interoperability)
4. [Change Log](#change-log)
5. [Simple Types](#simple-types)
6. [Complex Types](#complex-types)
7. [Required Elements of Provider-Directory XSD](#required-elements-of-provider-directory-xsd)
8. [All Elements of Provider-Directory XSD](#all-elements-of-provider-directory-xsd)
9. [Practical Guidance](#practical-guidance)

## Disclaimer

This document is provided by HealthLX for informational purposes only. Information within this document is believed to be correct as of the noted date of publication. Although HealthLX makes every reasonable effort to present information in a timely and accurate manner, HealthLX does not warrant this information for accuracy, completeness or fitness for any purpose, express or implied. The information provided herein does not constitute the rendering of legal, financial or other professional advice or recommendations by HealthLX.

## Overview

This implementation guide provides field mappings and requirements for HealthLX Provider-Directory data submissions in XML format based on FHIR R4 standards. XML format enables structured data exchange with built-in validation against the provided XSD schema.

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
| 10.0 | January 2, 2026 |

## Simple Types

| Name | Base Type | Description | Pattern |
| --- | --- | --- | --- |
| string | xs:string | – |  |
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
| organization_role | string | – |  |
| role | string | – |  |
| type_of_organization | string | – |  |


## Complex Types

### networks

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| network | – | 1 | unbounded | – |
| network_id | network_id | 1 | 1 | Unique Identifier of this Network |
| name | string | 0 | 1 | Name of this Network |


### period

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| start | dateTime | 0 | 1 | – |
| end | dateTime | 0 | 1 | – |


### new_patients

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| accepting_patients | – | 1 | 1 | New Patients indicates whether new patients are being accepted in general, or from a specific network.If no new patients are accepted, no characteristics are allowed |
| from_network | – | 0 | 1 | – |
| network_id | network_id | 1 | 1 | Unique Identifier of this Network |
| name | string | 0 | 1 | Name of this Network |
| characteristics | string | 0 | unbounded | Open text for additional information |


### not_available

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| description | string | 1 | 1 | Description of why the dates are not available |
| period | period | 0 | 1 | Start/End dates when service is not available |


### available_time

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| all_day | xs:boolean | 0 | 1 | Available All Day |
| days_of_week | – | 0 | unbounded | Days of the week available |
| available_start_time | time | 0 | 1 | Opening time of day (ignored if all_day = true) |
| available_end_time | time | 0 | 1 | Closing time of day (ignored if all_day = true) |


### human_name

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| use | – | 0 | 1 | use this element to describe the name. More information can be found here: http://hl7.org/fhir/R4/valueset-name-use.html |
| text | string | 0 | 1 | – |
| family | string | 1 | 1 | family name (often called 'Surname') |
| given | string | 0 | unbounded | Given names (not always 'first'). Includes middle names |
| prefix | string | 0 | unbounded | – |
| suffix | string | 0 | unbounded | – |
| period | period | 0 | 1 | Time period when name was/is in use. If the name is still in use, do not supply an End date |


### organization_branch

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| identifier | identifier | 0 | 1 | – |
| period | period | 0 | 1 | Time period when id is/was valid for use |
| is_active | xs:boolean | 0 | 1 | – |
| type | type_of_organization | 0 | 1 | Select the type of orginzation this is. A full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-OrgTypeVS.html |
| name | string | 1 | 1 | – |
| alias | string | 0 | unbounded | – |
| telecoms | – | 0 | 1 | – |
| telecom | telecom_minimum | 0 | unbounded | – |
| addresses | – | 0 | 1 | – |
| address | address | 0 | unbounded | – |
| contacts | – | 0 | 1 | – |
| contact | – | 0 | unbounded | – |
| purpose | – | 0 | 1 | The purpose of this contact within is within the organization. A full list can be found here: https://www.hl7.org/fhir/valueset-contactentity-type.html |
| name | human_name | 0 | 1 | – |
| telecoms | – | 0 | 1 | – |
| telecom | telecom_minimum | 0 | unbounded | – |
| address | address | 0 | 1 | – |


### telecom_minimum

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| system | – | 1 | 1 | use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html |
| value | string | 1 | 1 | The actual value of the contact point |
| use | – | 0 | 1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html |
| rank | positiveInt | 0 | 1 | Specify preferred order of use (1 = highest) |
| period | period | 0 | 1 | Time period when the contact point was in use |


### telecom

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| id | string | 0 | 1 | use this element to reference the CLIA |
| system | – | 0 | 1 | use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html |
| value | string | 0 | 1 | The actual value of the contact point |
| use | – | 0 | 1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html |
| rank | positiveInt | 0 | 1 | Specify preferred order of use (1 = highest) |
| period | period | 0 | 1 | Time period when the contact point was/is in use |
| contactpoint_available_times | – | 0 | 1 | – |
| contactpoint_available_time | available_time | 0 | unbounded | – |
| via_intermediaries | – | 0 | 1 | – |
| via_intermediary | – | 0 | unbounded | – |
| name | string | 1 | 1 | – |
| telecoms | – | 0 | 1 | – |
| telecom | – | 0 | unbounded | – |
| system | – | 1 | 1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html |
| value | string | 1 | 1 | The actual value of the contact point |


### address

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| id | string | 0 | 1 | use this element to reference the CLIA |
| use | – | 0 | 1 | purpose of this address. A full list can be found here: https://www.hl7.org/fhir/valueset-address-use.html |
| type | – | 0 | 1 | The address type. A full list can be found here: https://www.hl7.org/fhir/valueset-address-type.html |
| text | string | 0 | 1 | The full text representation of the address |
| line | string | 1 | unbounded | – |
| city | string | 0 | 1 | – |
| district | string | 0 | 1 | District name (aka County) |
| state | string | 0 | 1 | – |
| postal_code | string | 0 | 1 | – |
| country | string | 0 | 1 | – |
| period | period | 0 | 1 | Time period when address was/is in use |
| geo_locations | – | 0 | 1 | – |
| geo_location | – | 0 | unbounded | – |
| latitude | decimal | 1 | 1 | – |
| longitude | decimal | 1 | 1 | – |


### languages

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| language | – | 1 | 1 | Language the practitioner can use in patient communication. The full list can be found here: http://hl7.org/fhir/R4/valueset-languages.html |
| proficiency | – | 0 | 1 | The proficiency of the language. The full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-LanguageProficiencyVS.html |


### locations

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| location | – | 0 | unbounded | – |
| status | – | 1 | 1 | – |
| operational_status | – | 0 | 1 | The operational status of the location. A full list can be found here: https://www.hl7.org/fhir/v2/0116/index.html |
| identifiers | – | 0 | 1 | – |
| identifier | identifier | 0 | unbounded | – |
| name | string | 1 | 1 | – |
| alias | string | 0 | unbounded | – |
| description | string | 0 | 1 | – |
| types | – | 0 | 1 | – |
| type | – | 0 | unbounded | A role of a place that further classifies the setting (e.g., accident site, road side, work site, community location) in which services are delivered. A full list can be found here: https://terminology.hl7.org/1.0.0/ValueSet-v3-ServiceDeliveryLocationRoleType.html |
| physical_type | – | 0 | 1 | This example value set defines a set of codes that can be used to indicate the physical form of the Location. A full list can be found here: http://hl7.org/fhir/R4/valueset-location-physical-type.html |
| position | – | 0 | 1 | – |
| longitude | decimal | 1 | 1 | – |
| latitude | decimal | 1 | 1 | – |
| altitude | decimal | 0 | 1 | – |
| part_of | location_part_of | 0 | 1 | – |
| hours_of_operations | – | 0 | 1 | – |
| hours_of_operation | – | 0 | unbounded | – |
| all_day | xs:boolean | 0 | 1 | – |
| days_of_week | – | 0 | unbounded | – |
| opening_time | time | 0 | 1 | – |
| closing_time | time | 0 | 1 | – |
| availability_exceptions | string | 0 | 1 | Description of availability exceptions |
| accessibility | – | 0 | unbounded | Accessibility options. A full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-AccessibilityVS.html |
| new_patients_list | – | 0 | 1 | – |
| new_patients | new_patients | 0 | unbounded | – |
| telecoms | – | 0 | 1 | – |
| telecom | telecom | 0 | unbounded | – |
| address | address | 0 | 1 | – |


### location_part_of

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| status | – | 1 | 1 | – |
| operational_status | – | 0 | 1 | The operational status of the location. A full list can be found here: https://www.hl7.org/fhir/v2/0116/index.html |
| identifiers | – | 0 | 1 | – |
| identifier | identifier | 0 | unbounded | – |
| name | string | 1 | 1 | – |
| alias | string | 0 | unbounded | – |
| description | string | 0 | 1 | – |
| types | – | 0 | 1 | – |
| type | – | 0 | unbounded | A role of a place that further classifies the setting (e.g., accident site, road side, work site, community location) in which services are delivered. A full list can be found here: https://terminology.hl7.org/1.0.0/ValueSet-v3-ServiceDeliveryLocationRoleType.html |
| physical_type | – | 0 | 1 | This example value set defines a set of codes that can be used to indicate the physical form of the Location. A full list can be found here: http://hl7.org/fhir/R4/valueset-location-physical-type.html |
| position | – | 0 | 1 | – |
| longitude | decimal | 1 | 1 | – |
| latitude | decimal | 1 | 1 | – |
| altitude | decimal | 0 | 1 | – |
| hours_of_operations | – | 0 | 1 | – |
| hours_of_operation | – | 0 | unbounded | – |
| all_day | xs:boolean | 0 | 1 | – |
| days_of_week | – | 0 | unbounded | – |
| opening_time | time | 0 | 1 | – |
| closing_time | time | 0 | 1 | – |
| availability_exceptions | string | 0 | 1 | Description of availability exceptions |
| accessibility | – | 0 | unbounded | Accessibility options. A full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-AccessibilityVS.html |
| new_patients_list | – | 0 | 1 | – |
| new_patients | new_patients | 0 | unbounded | – |


### practitioner_specialties

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| specialty | – | 0 | unbounded | Individual and Group Specialties from National Uniform Claim Committee (NUCC) Health Care Provider Taxonomy code set. A full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-IndividualAndGroupSpecialtiesVS.html |


### provider_organization_specialties

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| specialty | – | 0 | unbounded | Specialties value set based on National Uniform Claim Committee (NUCC) Health Care Provider Taxonomy code set. A full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-SpecialtiesVS.html |


### healthcare_services

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| healthcare_service | – | 0 | unbounded | – |
| identifiers | – | 0 | 1 | – |
| identifier | identifier | 0 | unbounded | – |
| is_active | xs:boolean | 0 | 1 | – |
| category | – | 1 | 1 | Valueset for descripting the broad category of service being performed or delivered by a health care service. A full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-HealthcareServiceCategoryVS.html |
| types | – | 0 | 1 | – |
| type | – | 0 | unbounded | Valueset for HealthCareService type. A full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-HealthcareServiceTypeVS.html |
| specialties | provider_organization_specialties | 0 | 1 | – |
| name | string | 0 | 1 | Description of service as presented to a consumer while searching |
| comment | string | 0 | 1 | Additional description and/or any specific issues not covered elsewhere |
| extra_details | string | 0 | 1 | Extra details about the service that can't be placed in the other fields |
| delivery_methods | – | 1 | 1 | – |
| delivery_method | – | 1 | unbounded | – |
| type | – | 1 | 1 | Physical or Virtual Service Delivery |
| virtual_modalities | – | 0 | unbounded | Modalities of Virtual Delivery-Choose from code valueset. More information can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-VirtualModalitiesVS.html |
| new_patients_list | – | 0 | 1 | – |
| new_patients | new_patients | 0 | unbounded | – |
| eligibilities | – | 0 | 1 | – |
| eligibility | – | 0 | unbounded | – |
| code | coding | 0 | 1 | Coded value for the eligibility |
| comment | string | 0 | 1 | Describes the eligibility conditions for the service |
| programs | – | 0 | 1 | – |
| program | – | 0 | unbounded | – |
| code | – | 0 | 1 | This value set defines an example set of codes that could be can be used to classify groupings of service-types/specialties. A full list can be found here: http://hl7.org/fhir/R4/valueset-program.html |
| display | string | 1 | 1 | – |
| characteristics | – | 0 | 1 | – |
| characteristic | coding | 0 | unbounded | – |
| communications | – | 0 | 1 | – |
| communication | coding | 0 | unbounded | – |
| referral_methods | – | 0 | 1 | – |
| referral_method | – | 0 | unbounded | – |
| code | – | 0 | 1 | The methods of referral can be used when referring to a specific HealthCareService resource. A full list can be found here: http://hl7.org/fhir/R4/valueset-service-referral-method.html |
| display | string | 1 | 1 | – |
| appointment_required | xs:boolean | 0 | 1 | – |
| available_times | – | 0 | 1 | – |
| available_time | available_time | 0 | unbounded | – |
| not_availables | – | 0 | 1 | – |
| not_available | not_available | 0 | unbounded | – |
| availability_exceptions | string | 0 | 1 | – |
| locations | locations | 0 | 1 | – |


### organization

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| npi | NPI | 0 | 1 | – |
| clia | clia | 0 | 1 | Clinical Laboratory Improvement Amendments (CLIA) Number for laboratories |
| is_active | xs:boolean | 1 | 1 | Whether the organization's record is still in active use |
| types | – | 0 | 1 | – |
| type | type_of_organization | 1 | unbounded | Organization type, a full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-OrgTypeVS.html |
| name | string | 1 | 1 | – |
| alias | string | 0 | unbounded | – |
| org_description | string | 0 | 1 | – |
| part_of | organization_part_of | 0 | 1 | – |
| telecoms | – | 0 | 1 | – |
| telecom | telecom | 0 | unbounded | – |
| addresses | – | 0 | 1 | – |
| address | address | 0 | unbounded | – |


### organization_part_of

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| npi | NPI | 0 | 1 | – |
| clia | string | 0 | 1 | Clinical Laboratory Improvement Amendments (CLIA) Number for laboratories |
| is_active | xs:boolean | 1 | 1 | Whether the organization's record is still in active use |
| types | – | 1 | 1 | – |
| type | type_of_organization | 1 | unbounded | Organization type, a full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-OrgTypeVS.html |
| name | string | 1 | 1 | – |
| alias | string | 0 | unbounded | – |
| org_description | string | 0 | 1 | – |
| telecoms | – | 0 | 1 | – |
| telecom | telecom | 0 | unbounded | – |
| addresses | – | 0 | 1 | – |
| address | address | 0 | unbounded | – |


### identifier

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | string | 1 | 1 | – |
| type | string | 1 | 1 | – |


### coding

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| system | string | 0 | 1 | – |
| code | string | 0 | 1 | – |
| display | string | 0 | 1 | – |


### codeable_concept

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| coding | coding | 0 | unbounded | – |
| text | string | 0 | 1 | – |


### qualification

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| identifiers | – | 0 | 1 | – |
| identifier | identifier | 0 | unbounded | Provides an identifier for the qualification |
| code | coding | 1 | 1 | Indicates the type of qualification |
| period | period | 0 | 1 | Indicates a period of time during which the current status applies |
| issuer | organization_branch | 0 | 1 | This organization that regulates and issues the qualification |
| status | – | 1 | 1 | Describes the current status of the qualification (i.e. active, inactive, issued in error, revoked, pending, unknown) |
| where_valid | string | 0 | unbounded | Indicates where the qualification is valid. users may select any number of specific locations, classes of locations, or combination thereof |


### clia

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| id | string | 1 | 1 | – |
| value | string | 1 | 1 | Clinical Laboratory Improvement Amendments (CLIA) Number for laboratories |


## Required Elements of Provider-Directory XSD

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| providers |  | 1..1 | – | – | – |
| schema_version | providers | 1..1 | This element defines what version of the provider directory schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | providers | 1..1 | This element is used to the unique identifier assigned to your organization | – | string |
| date_time_reported | providers | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |
| provider | providers | 1..unbounded | – | – | – |
| – | provider | – | One of: practitioner, providing_organization | – | choice |
| practitioner | provider | 1..unbounded | Practitioner is a person who is directly or indirectly involved in the provisioning of healthcare | – | – |
| names | practitioner | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | human_name |
| specialty | specialties | 1..unbounded | – | – | codeable_concept |
| providing_organization | provider | 1..unbounded | This element is used when the Provider Type is an organizatiaon | – | – |
| clia | clias | 1..unbounded | – | – | clia |
| is_active | providing_organization | 1..1 | – | – | xs:boolean |
| name | providing_organization | 1..1 | – | – | string |
| code | codes | 1..unbounded | Value Set for Organization Affiliation Roles. The full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-OrganizationAffiliationRoleVS.html | – | codeable_concept |
| specialty | specialties | 1..unbounded | – | – | codeable_concept |


## All Elements of Provider-Directory XSD

### Root Elements

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| providers |  | 1..1 | – | – | – |
| schema_version | providers | 1..1 | This element defines what version of the provider directory schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | providers | 1..1 | This element is used to the unique identifier assigned to your organization | – | string |
| date_time_reported | providers | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |
| provider | providers | 1..unbounded | – | – | – |
| – | provider | – | One of: practitioner, providing_organization | – | choice |
| practitioner | provider | 1..unbounded | Practitioner is a person who is directly or indirectly involved in the provisioning of healthcare | – | – |


### Practitioners

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| unique_identifier | practitioner | 0..1 | – | – | string |
| npi | practitioner | 0..1 | – | – | NPI |
| is_active | practitioner | 0..1 | Whether this practitioner's record is in active use | – | xs:boolean |
| names | practitioner | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | human_name |
| telecoms | practitioner | 0..1 | – | – | – |
| telecom | telecoms | 0..unbounded | – | – | telecom |
| addresses | practitioner | 0..1 | – | – | – |
| address | addresses | 0..unbounded | – | – | address |
| gender | practitioner | 0..1 | – | – | – |
| birth_date | practitioner | 0..1 | – | – | date |
| qualifications | practitioner | 0..1 | – | – | – |
| qualification | qualifications | 0..unbounded | – | – | qualification |
| communications | practitioner | 0..1 | – | – | – |
| communication | communications | 0..unbounded | – | – | languages |
| period | practitioner | 0..1 | – | – | period |
| affiliated_organization | practitioner | 0..1 | – | – | organization |
| codes | practitioner | 0..1 | – | – | – |
| code | codes | 0..unbounded | This element is used to indicate the role of a Practitioner. The full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-PractitionerRoleVS.html | – | codeable_concept |
| specialties | practitioner | 0..1 | – | – | – |
| specialty | specialties | 1..unbounded | – | – | codeable_concept |
| available_times | practitioner | 0..1 | – | – | – |
| available_time | available_times | 0..unbounded | – | – | available_time |
| not_availables | practitioner | 0..1 | – | – | – |
| not_available | not_availables | 0..unbounded | – | – | not_available |
| availability_exceptions | practitioner | 0..1 | – | – | string |
| new_patients_list | practitioner | 0..1 | – | – | – |
| new_patients | new_patients_list | 0..unbounded | – | – | new_patients |
| networks | practitioner | 0..1 | – | – | networks |


### Locations

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| locations | practitioner | 0..1 | – | – | locations |


### Practitioners

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| healthcare_services | practitioner | 0..1 | – | – | healthcare_services |
| providing_organization | provider | 1..unbounded | This element is used when the Provider Type is an organizatiaon | – | – |
| unique_identifier | providing_organization | 0..1 | – | – | string |
| npi | providing_organization | 0..1 | – | – | NPI |
| clias | providing_organization | 0..1 | – | – | – |
| clia | clias | 1..unbounded | – | – | clia |
| is_active | providing_organization | 1..1 | – | – | xs:boolean |
| types | providing_organization | 0..1 | – | – | – |
| type | types | 0..unbounded | Organization type, a full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-OrgTypeVS.html | – | type_of_organization |
| name | providing_organization | 1..1 | – | – | string |
| alias | providing_organization | 0..unbounded | A list of alternate names that the organization is known as, or was known as in the past | – | string |
| org_description | providing_organization | 0..1 | – | – | string |
| telecoms | providing_organization | 0..1 | – | – | – |
| telecom | telecoms | 0..unbounded | – | – | telecom |
| addresses | providing_organization | 0..1 | – | – | – |
| address | addresses | 0..unbounded | – | – | address |
| codes | providing_organization | 0..1 | – | – | – |
| code | codes | 1..unbounded | Value Set for Organization Affiliation Roles. The full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-OrganizationAffiliationRoleVS.html | – | codeable_concept |
| specialties | providing_organization | 0..1 | – | – | – |
| specialty | specialties | 1..unbounded | – | – | codeable_concept |
| qualifications | providing_organization | 0..1 | – | – | – |
| qualification | qualifications | 0..unbounded | – | – | qualification |
| contacts | providing_organization | 0..1 | – | – | – |
| contact | contacts | 0..unbounded | – | – | – |
| name | contact | 0..1 | – | – | human_name |
| purpose | contact | 0..1 | The purpose of this contact within is within the organization. A full list can be found here: https://www.hl7.org/fhir/valueset-contactentity-type.html | – | – |
| telecoms | contact | 0..1 | – | – | – |
| telecom | telecoms | 0..unbounded | – | – | telecom |
| address | contact | 0..unbounded | – | – | address |
| period | providing_organization | 0..1 | The period during which the participatingOrganization is affiliated with the primary organization | – | period |
| affiliated_organization | providing_organization | 0..1 | – | – | organization |
| part_of | providing_organization | 0..1 | – | – | organization |
| networks | providing_organization | 0..1 | – | – | networks |


### Locations

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| locations | providing_organization | 0..1 | – | – | locations |
| healthcare_services | providing_organization | 0..1 | – | – | healthcare_services |


## Practical Guidance

### Submission Frequency

Provider-Directory files should be submitted according to the schedule agreed upon with HealthLX. Typical submission frequencies include daily, weekly, or monthly updates.

### Adds, Updates, and Deletes

- **Adds**: Include new member records with all required fields populated
- **Updates**: Submit complete member records with updated information
- **Deletes**: Follow the agreed-upon process for member terminations or removals

### Member Identification

Each member must be uniquely identified using the appropriate identifier fields. Ensure consistency in member identifiers across all submissions to maintain data integrity.

