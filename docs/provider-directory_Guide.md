![HLX Logo](../assets/hlx_logo.png)

# Provider-Directory Implementation Guide

**HLX0123 HLX Provider-Directory IG (XSD_V10.0)**

**Version 10.0**

**December 22, 2025**

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
| 10.0 | December 22, 2025 |

## Simple Types

| Name | Base Type | Description | Enumerations | Constraints |
| --- | --- | --- | --- | --- |
| string | xs:string | – | – | – |
| NPI | xs:string | – | – | Pattern: [0-9]{10} |
| network_id | xs:string | – | – | Pattern: [A-Za-z0-9\-\.]{1,64} |
| resource_id | xs:string | – | – | Pattern: [A-Za-z0-9\-\.]{1,64} |
| positiveInt | xs:positiveInteger | – | – | Pattern: \+?[1-9][0-9]* |
| unsignedInt | xs:unsignedInt | – | – | Pattern: 0\|([1-9][0-9]*) |
| integer | xs:integer | – | – | Pattern: [0]\|[-+]?[1-9][0-9]* |
| time | xs:time | – | – | Pattern: ([01][0-9]\|2[0-3]):[0-5][0-9]:[0-5][0-9](\.\d{1,9})? |
| dateTime | xs:string | – | – | Pattern: ([12]\d{3})-(0[1-9]\|1[0-2])-(0[1-9]\|[1-2][0-9]\|3[0-1])(T([01][0-9]\|2[0-3]):[0-5][0-9]:[0-5][0-9](\.\d{1,6})?((Z\|(\+\|-)((0[0-9]\|1[0-3]):(00\|15\|30\|45)\|14:00))?))? |
| date | xs:date | – | – | Pattern: ([12]\d{3}-(0[1-9]\|1[0-2])-(0[1-9]\|[12]\d\|3[01])) |
| decimal | xs:decimal | – | – | Pattern: -?(0\|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)? |
| organization_role | string | – | provider, agency, research, payer, diagnostics, supplier, HIE/HIO, behavioral, bt, dme, group, home, hospital, laboratory, other, outpatient, pharmacy, transport, urgent, hospice, nurseCustodial, residential, respite, retail | – |
| role | string | – | ap, apn, at, au, bh, ba, bt, cnw, crnp, ch, cs, co, dp, de, drr, dn, om, em, ho, lpn, mt, ma, nh, na, nu, ot, op, oo, os, rx, pt, ph, pa, po, py, rn, rt, sw, sp, sh, te, doctor, nurse, pharmacist, researcher, teacher, ict | – |
| type_of_organization | string | – | fac, prvgrp, Payer, atyprv, bus | – |


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
| accepting_patients | string (enum: no, yes, existing, existingplusfamily) | 1 | 1 | New Patients indicates whether new patients are being accepted in general, or from a specific network.If no new patients are accepted, no characteristics are allowed |
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
| days_of_week | string (enum: mon, tue, wed, thu, fri, sat, sun) | 0 | unbounded | Days of the week available |
| available_start_time | time | 0 | 1 | Opening time of day (ignored if all_day = true) |
| available_end_time | time | 0 | 1 | Closing time of day (ignored if all_day = true) |


### human_name

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| use | string (enum: usual, official, temp, nickname, anonymous, old, maiden) | 0 | 1 | use this element to describe the name. More information can be found here: http://hl7.org/fhir/R4/valueset-name-use.html |
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
| purpose | string (enum: BILL, ADMIN, HR, PAYOR, PATINF, PRESS) | 0 | 1 | The purpose of this contact within is within the organization. A full list can be found here: https://www.hl7.org/fhir/valueset-contactentity-type.html |
| name | human_name | 0 | 1 | – |
| telecoms | – | 0 | 1 | – |
| telecom | telecom_minimum | 0 | unbounded | – |
| address | address | 0 | 1 | – |


### telecom_minimum

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| system | string (enum: phone, fax, email, pager, url, sms, other) | 1 | 1 | use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html |
| value | string | 1 | 1 | The actual value of the contact point |
| use | string (enum: home, work, temp, old, mobile) | 0 | 1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html |
| rank | positiveInt | 0 | 1 | Specify preferred order of use (1 = highest) |
| period | period | 0 | 1 | Time period when the contact point was in use |


### telecom

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| id | string | 0 | 1 | use this element to reference the CLIA |
| system | string (enum: phone, fax, email, pager, url, sms, other) | 0 | 1 | use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html |
| value | string | 0 | 1 | The actual value of the contact point |
| use | string (enum: home, work, temp, old, mobile) | 0 | 1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html |
| rank | positiveInt | 0 | 1 | Specify preferred order of use (1 = highest) |
| period | period | 0 | 1 | Time period when the contact point was/is in use |
| contactpoint_available_times | – | 0 | 1 | – |
| contactpoint_available_time | available_time | 0 | unbounded | – |
| via_intermediaries | – | 0 | 1 | – |
| via_intermediary | – | 0 | unbounded | – |
| name | string | 1 | 1 | – |
| telecoms | – | 0 | 1 | – |
| telecom | – | 0 | unbounded | – |
| system | string (enum: phone, fax, email, pager, url, sms, other) | 1 | 1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html |
| value | string | 1 | 1 | The actual value of the contact point |


### address

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| id | string | 0 | 1 | use this element to reference the CLIA |
| use | string (enum: home, work, temp, old, billing) | 0 | 1 | purpose of this address. A full list can be found here: https://www.hl7.org/fhir/valueset-address-use.html |
| type | string (enum: postal, physical, both) | 0 | 1 | The address type. A full list can be found here: https://www.hl7.org/fhir/valueset-address-type.html |
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
| status | string (enum: active, suspended, inactive) | 1 | 1 | – |
| operational_status | string (enum: C, H, I, K, O, U) | 0 | 1 | The operational status of the location. A full list can be found here: https://www.hl7.org/fhir/v2/0116/index.html |
| identifiers | – | 0 | 1 | – |
| identifier | identifier | 0 | unbounded | – |
| name | string | 1 | 1 | – |
| alias | string | 0 | unbounded | – |
| description | string | 0 | 1 | – |
| types | – | 0 | 1 | – |
| type | string (enum: _DedicatedServiceDeliveryLocationRoleType, _DedicatedClinicalLocationRoleType, DX, CVDX, CATH, ECHO, GIDX, ENDOS, RADDX, RADO, RNEU, HOSP, CHR, GACH, MHSP, PSYCHF, RH, RHAT, RHII, RHMAD, RHPI, RHPIH, RHPIMS, RHPIVS, RHYAD, HU, BMTU, CCU, CHEST, EPIL, ER, ETU, HD, HLAB, INLAB, OUTLAB, HRAD, HUSCS, ICU, PEDICU, PEDNICU, INPHARM, MBL, NCCS, NS, OUTPHARM, PEDU, PHU, RHU, SLEEP, NCCF, SNF, OF, ALL, AMPUT, BMTC, BREAST, CANC, CAPC, CARD, PEDCARD, COAG, CRS, DERM, ENDO, PEDE, ENT, FMC, GI, PEDGI, GIM, GYN, HEM, PEDHEM, HTN, IEC, INFD, PEDID, INV, LYMPH, MGEN, NEPH, PEDNEPH, NEUR, OB, OMS, ONCL, PEDHO, OPH, OPTC, ORTHO, HAND, PAINCL, PC, PEDC, PEDRHEUM, POD, PREV, PROCTO, PROFF, PROS, PSI, PSY, RHEUM, SPMED, SU, PLS, URO, TR, TRAVEL, WND, RTF, PRC, SURF, _DedicatedNonClinicalLocationRoleType, DADDR, MOBL, AMB, PHARM, _IncidentalServiceDeliveryLocationRoleType, ACC, COMM, CSC, PTRES, SCHOOL, UPC, WORK) | 0 | unbounded | A role of a place that further classifies the setting (e.g., accident site, road side, work site, community location) in which services are delivered. A full list can be found here: https://terminology.hl7.org/1.0.0/ValueSet-v3-ServiceDeliveryLocationRoleType.html |
| physical_type | – | 0 | 1 | This example value set defines a set of codes that can be used to indicate the physical form of the Location. A full list can be found here: http://hl7.org/fhir/R4/valueset-location-physical-type.html |
| position | – | 0 | 1 | – |
| longitude | decimal | 1 | 1 | – |
| latitude | decimal | 1 | 1 | – |
| altitude | decimal | 0 | 1 | – |
| part_of | location_part_of | 0 | 1 | – |
| hours_of_operations | – | 0 | 1 | – |
| hours_of_operation | – | 0 | unbounded | – |
| all_day | xs:boolean | 0 | 1 | – |
| days_of_week | string (enum: mon, tue, wed, thu, fri, sat, sun) | 0 | unbounded | – |
| opening_time | time | 0 | 1 | – |
| closing_time | time | 0 | 1 | – |
| availability_exceptions | string | 0 | 1 | Description of availability exceptions |
| accessibility | string (enum: cultcomp, handiaccess, adacomp, pubtrans, anssrvc, vision, cognitive, mobility) | 0 | unbounded | Accessibility options. A full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-AccessibilityVS.html |
| new_patients_list | – | 0 | 1 | – |
| new_patients | new_patients | 0 | unbounded | – |
| telecoms | – | 0 | 1 | – |
| telecom | telecom | 0 | unbounded | – |
| address | address | 0 | 1 | – |


### location_part_of

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| status | string (enum: active, suspended, inactive) | 1 | 1 | – |
| operational_status | string (enum: C, H, I, K, O, U) | 0 | 1 | The operational status of the location. A full list can be found here: https://www.hl7.org/fhir/v2/0116/index.html |
| identifiers | – | 0 | 1 | – |
| identifier | identifier | 0 | unbounded | – |
| name | string | 1 | 1 | – |
| alias | string | 0 | unbounded | – |
| description | string | 0 | 1 | – |
| types | – | 0 | 1 | – |
| type | string (enum: _DedicatedServiceDeliveryLocationRoleType, _DedicatedClinicalLocationRoleType, DX, CVDX, CATH, ECHO, GIDX, ENDOS, RADDX, RADO, RNEU, HOSP, CHR, GACH, MHSP, PSYCHF, RH, RHAT, RHII, RHMAD, RHPI, RHPIH, RHPIMS, RHPIVS, RHYAD, HU, BMTU, CCU, CHEST, EPIL, ER, ETU, HD, HLAB, INLAB, OUTLAB, HRAD, HUSCS, ICU, PEDICU, PEDNICU, INPHARM, MBL, NCCS, NS, OUTPHARM, PEDU, PHU, RHU, SLEEP, NCCF, SNF, OF, ALL, AMPUT, BMTC, BREAST, CANC, CAPC, CARD, PEDCARD, COAG, CRS, DERM, ENDO, PEDE, ENT, FMC, GI, PEDGI, GIM, GYN, HEM, PEDHEM, HTN, IEC, INFD, PEDID, INV, LYMPH, MGEN, NEPH, PEDNEPH, NEUR, OB, OMS, ONCL, PEDHO, OPH, OPTC, ORTHO, HAND, PAINCL, PC, PEDC, PEDRHEUM, POD, PREV, PROCTO, PROFF, PROS, PSI, PSY, RHEUM, SPMED, SU, PLS, URO, TR, TRAVEL, WND, RTF, PRC, SURF, _DedicatedNonClinicalLocationRoleType, DADDR, MOBL, AMB, PHARM, _IncidentalServiceDeliveryLocationRoleType, ACC, COMM, CSC, PTRES, SCHOOL, UPC, WORK) | 0 | unbounded | A role of a place that further classifies the setting (e.g., accident site, road side, work site, community location) in which services are delivered. A full list can be found here: https://terminology.hl7.org/1.0.0/ValueSet-v3-ServiceDeliveryLocationRoleType.html |
| physical_type | – | 0 | 1 | This example value set defines a set of codes that can be used to indicate the physical form of the Location. A full list can be found here: http://hl7.org/fhir/R4/valueset-location-physical-type.html |
| position | – | 0 | 1 | – |
| longitude | decimal | 1 | 1 | – |
| latitude | decimal | 1 | 1 | – |
| altitude | decimal | 0 | 1 | – |
| hours_of_operations | – | 0 | 1 | – |
| hours_of_operation | – | 0 | unbounded | – |
| all_day | xs:boolean | 0 | 1 | – |
| days_of_week | string (enum: mon, tue, wed, thu, fri, sat, sun) | 0 | unbounded | – |
| opening_time | time | 0 | 1 | – |
| closing_time | time | 0 | 1 | – |
| availability_exceptions | string | 0 | 1 | Description of availability exceptions |
| accessibility | string (enum: cultcomp, handiaccess, adacomp, pubtrans, anssrvc, vision, cognitive, mobility) | 0 | unbounded | Accessibility options. A full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-AccessibilityVS.html |
| new_patients_list | – | 0 | 1 | – |
| new_patients | new_patients | 0 | unbounded | – |


### practitioner_specialties

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| specialty | string (enum: 101200000X, 101Y00000X, 101YA0400X, 101YM0800X, 101YP1600X, 101YP2500X, 101YS0200X, 102L00000X, 102X00000X, 103G00000X, 103K00000X, 103T00000X, 103TA0400X, 103TA0700X, 103TB0200X, 103TC0700X, 103TC1900X, 103TC2200X, 103TE1100X, 103TF0000X, 103TF0200X, 103TH0004X, 103TH0100X, 103TM1800X, 103TP0016X, 103TP0814X, 103TP2701X, 103TR0400X, 103TS0200X, 104100000X, 1041C0700X, 1041S0200X, 106E00000X, 106H00000X, 106S00000X, 111N00000X, 111NI0013X, 111NI0900X, 111NN0400X, 111NN1001X, 111NP0017X, 111NR0200X, 111NR0400X, 111NS0005X, 111NT0100X, 111NX0100X, 111NX0800X, 122300000X, 1223D0001X, 1223D0004X, 1223E0200X, 1223G0001X, 1223P0106X, 1223P0221X, 1223P0300X, 1223P0700X, 1223S0112X, 1223X0008X, 1223X0400X, 122400000X, 124Q00000X, 125J00000X, 125K00000X, 125Q00000X, 126800000X, 126900000X, 132700000X, 133N00000X, 133NN1002X, 133V00000X, 133VN1004X, 133VN1005X, 133VN1006X, 136A00000X, 146D00000X, 146L00000X, 146M00000X, 146N00000X, 152W00000X, 152WC0802X, 152WL0500X, 152WP0200X, 152WS0006X, 152WV0400X, 152WX0102X, 156F00000X, 156FC0800X, 156FC0801X, 156FX1100X, 156FX1101X, 156FX1201X, 156FX1202X, 156FX1700X, 156FX1800X, 156FX1900X, 163W00000X, 163WA0400X, 163WA2000X, 163WC0200X, 163WC0400X, 163WC1400X, 163WC1500X, 163WC1600X, 163WC2100X, 163WC3500X, 163WD0400X, 163WD1100X, 163WE0003X, 163WE0900X, 163WF0300X, 163WG0000X, 163WG0100X, 163WG0600X, 163WH0200X, 163WH0500X, 163WH1000X, 163WI0500X, 163WI0600X, 163WL0100X, 163WM0102X, 163WM0705X, 163WM1400X, 163WN0002X, 163WN0003X, 163WN0300X, 163WN0800X, 163WN1003X, 163WP0000X, 163WP0200X, 163WP0218X, 163WP0807X, 163WP0808X, 163WP0809X, 163WP1700X, 163WP2201X, 163WR0006X, 163WR0400X, 163WR1000X, 163WS0121X, 163WS0200X, 163WU0100X, 163WW0000X, 163WW0101X, 163WX0002X, 163WX0003X, 163WX0106X, 163WX0200X, 163WX0601X, 163WX0800X, 163WX1100X, 163WX1500X, 164W00000X, 164X00000X, 167G00000X, 170100000X, 170300000X, 171000000X, 1710I1002X, 1710I1003X, 171100000X, 171400000X, 171M00000X, 171R00000X, 171W00000X, 171WH0202X, 171WV0202X, 172A00000X, 172M00000X, 172P00000X, 172V00000X, 173000000X, 173C00000X, 173F00000X, 174400000X, 1744G0900X, 1744P3200X, 1744R1102X, 1744R1103X, 174H00000X, 174M00000X, 174MM1900X, 174N00000X, 174V00000X, 175F00000X, 175L00000X, 175M00000X, 175T00000X, 176B00000X, 176P00000X, 183500000X, 1835C0205X, 1835G0303X, 1835N0905X, 1835N1003X, 1835P0018X, 1835P0200X, 1835P1200X, 1835P1300X, 1835P2201X, 1835X0200X, 183700000X, 193200000X, 202C00000X, 202K00000X, 204C00000X, 204D00000X, 204E00000X, 204F00000X, 204R00000X, 207K00000X, 207KA0200X, 207KI0005X, 207L00000X, 207LA0401X, 207LC0200X, 207LH0002X, 207LP2900X, 207LP3000X, 207N00000X, 207ND0101X, 207ND0900X, 207NI0002X, 207NP0225X, 207NS0135X, 207P00000X, 207PE0004X, 207PE0005X, 207PH0002X, 207PP0204X, 207PS0010X, 207PT0002X, 207Q00000X, 207QA0000X, 207QA0401X, 207QA0505X, 207QB0002X, 207QG0300X, 207QH0002X, 207QS0010X, 207QS1201X, 207R00000X, 207RA0000X, 207RA0001X, 207RA0201X, 207RA0401X, 207RB0002X, 207RC0000X, 207RC0001X, 207RC0200X, 207RE0101X, 207RG0100X, 207RG0300X, 207RH0000X, 207RH0002X, 207RH0003X, 207RH0005X, 207RI0001X, 207RI0008X, 207RI0011X, 207RI0200X, 207RM1200X, 207RN0300X, 207RP1001X, 207RR0500X, 207RS0010X, 207RS0012X, 207RT0003X, 207RX0202X, 207SC0300X, 207SG0201X, 207SG0202X, 207SG0203X, 207SG0205X, 207SM0001X, 207T00000X, 207U00000X, 207UN0901X, 207UN0902X, 207UN0903X, 207V00000X, 207VB0002X, 207VC0200X, 207VE0102X, 207VF0040X, 207VG0400X, 207VH0002X, 207VM0101X, 207VX0000X, 207VX0201X, 207W00000X, 207WX0200X, 207X00000X, 207XP3100X, 207XS0106X, 207XS0114X, 207XS0117X, 207XX0004X, 207XX0005X, 207XX0801X, 207Y00000X, 207YP0228X, 207YS0012X, 207YS0123X, 207YX0007X, 207YX0602X, 207YX0901X, 207YX0905X, 207ZB0001X, 207ZC0006X, 207ZC0008X, 207ZC0500X, 207ZD0900X, 207ZF0201X, 207ZH0000X, 207ZI0100X, 207ZM0300X, 207ZN0500X, 207ZP0007X, 207ZP0101X, 207ZP0102X, 207ZP0104X, 207ZP0105X, 207ZP0213X, 208000000X, 2080A0000X, 2080B0002X, 2080C0008X, 2080H0002X, 2080I0007X, 2080N0001X, 2080P0006X, 2080P0008X, 2080P0201X, 2080P0202X, 2080P0203X, 2080P0204X, 2080P0205X, 2080P0206X, 2080P0207X, 2080P0208X, 2080P0210X, 2080P0214X, 2080P0216X, 2080S0010X, 2080S0012X, 2080T0002X, 2080T0004X, 208100000X, 2081H0002X, 2081N0008X, 2081P0004X, 2081P0010X, 2081P0301X, 2081P2900X, 2081S0010X, 208200000X, 2082S0099X, 2082S0105X, 2083A0100X, 2083B0002X, 2083C0008X, 2083P0011X, 2083P0500X, 2083P0901X, 2083S0010X, 2083T0002X, 2083X0100X, 2084A0401X, 2084A2900X, 2084B0002X, 2084B0040X, 2084D0003X, 2084F0202X, 2084H0002X, 2084N0008X, 2084N0400X, 2084N0402X, 2084N0600X, 2084P0005X, 2084P0015X, 2084P0301X, 2084P0800X, 2084P0802X, 2084P0804X, 2084P0805X, 2084P2900X, 2084S0010X, 2084S0012X, 2084V0102X, 2085B0100X, 2085D0003X, 2085H0002X, 2085N0700X, 2085N0904X, 2085P0229X, 2085R0001X, 2085R0202X, 2085R0203X, 2085R0204X, 2085R0205X, 2085U0001X, 208600000X, 2086H0002X, 2086S0102X, 2086S0105X, 2086S0120X, 2086S0122X, 2086S0127X, 2086S0129X, 2086X0206X, 208800000X, 2088F0040X, 2088P0231X, 208C00000X, 208D00000X, 208G00000X, 208M00000X, 208U00000X, 208VP0000X, 208VP0014X, 209800000X, 211D00000X, 213E00000X, 213EP0504X, 213EP1101X, 213ER0200X, 213ES0000X, 213ES0103X, 213ES0131X, 221700000X, 222Q00000X, 222Z00000X, 224900000X, 224L00000X, 224P00000X, 224Y00000X, 224Z00000X, 224ZE0001X, 224ZF0002X, 224ZL0004X, 224ZR0403X, 225000000X, 225100000X, 2251C2600X, 2251E1200X, 2251E1300X, 2251G0304X, 2251H1200X, 2251H1300X, 2251N0400X, 2251P0200X, 2251S0007X, 2251X0800X, 225200000X, 225400000X, 225500000X, 2255A2300X, 2255R0406X, 225600000X, 225700000X, 225800000X, 225A00000X, 225B00000X, 225C00000X, 225CA2400X, 225CA2500X, 225CX0006X, 225X00000X, 225XE0001X, 225XE1200X, 225XF0002X, 225XG0600X, 225XH1200X, 225XH1300X, 225XL0004X, 225XM0800X, 225XN1300X, 225XP0019X, 225XP0200X, 225XR0403X, 226000000X, 226300000X, 227800000X, 2278C0205X, 2278E0002X, 2278E1000X, 2278G0305X, 2278G1100X, 2278H0200X, 2278P1004X, 2278P1005X, 2278P1006X, 2278P3800X, 2278P3900X, 2278P4000X, 2278S1500X, 227900000X, 2279C0205X, 2279E0002X, 2279E1000X, 2279G0305X, 2279G1100X, 2279H0200X, 2279P1004X, 2279P1005X, 2279P1006X, 2279P3800X, 2279P3900X, 2279P4000X, 2279S1500X, 229N00000X, 231H00000X, 231HA2400X, 231HA2500X, 235500000X, 2355A2700X, 2355S0801X, 235Z00000X, 237600000X, 237700000X, 242T00000X, 243U00000X, 246Q00000X, 246QB0000X, 246QC1000X, 246QC2700X, 246QH0000X, 246QH0401X, 246QH0600X, 246QI0000X, 246QL0900X, 246QL0901X, 246QM0706X, 246QM0900X, 246R00000X, 246RH0600X, 246RM2200X, 246RP1900X, 246W00000X, 246X00000X, 246XC2901X, 246XC2903X, 246XS1301X, 246Y00000X, 246YC3301X, 246YC3302X, 246YR1600X, 246Z00000X, 246ZA2600X, 246ZB0301X, 246ZB0302X, 246ZB0500X, 246ZB0600X, 246ZC0007X, 246ZE0500X, 246ZE0600X, 246ZG0701X, 246ZG1000X, 246ZI1000X, 246ZN0300X, 246ZS0410X, 246ZX2200X, 247000000X, 2470A2800X, 247100000X, 2471B0102X, 2471C1101X, 2471C1106X, 2471C3401X, 2471C3402X, 2471M1202X, 2471M2300X, 2471N0900X, 2471Q0001X, 2471R0002X, 2471S1302X, 2471V0105X, 2471V0106X, 247200000X, 2472B0301X, 2472D0500X, 2472E0500X, 2472R0900X, 2472V0600X, 247ZC0005X, 363A00000X, 363AM0700X, 363AS0400X, 363L00000X, 363LA2100X, 363LA2200X, 363LC0200X, 363LC1500X, 363LF0000X, 363LG0600X, 363LN0000X, 363LN0005X, 363LP0200X, 363LP0222X, 363LP0808X, 363LP1700X, 363LP2300X, 363LS0200X, 363LW0102X, 363LX0001X, 363LX0106X, 364S00000X, 364SA2100X, 364SA2200X, 364SC0200X, 364SC1501X, 364SC2300X, 364SE0003X, 364SE1400X, 364SF0001X, 364SG0600X, 364SH0200X, 364SH1100X, 364SI0800X, 364SL0600X, 364SM0705X, 364SN0000X, 364SN0800X, 364SP0200X, 364SP0807X, 364SP0808X, 364SP0809X, 364SP0810X, 364SP0811X, 364SP0812X, 364SP0813X, 364SP1700X, 364SP2800X, 364SR0400X, 364SS0200X, 364ST0500X, 364SW0102X, 364SX0106X, 364SX0200X, 364SX0204X, 367500000X, 367A00000X, 367H00000X, 372500000X, 372600000X, 373H00000X, 374700000X, 3747A0650X, 3747P1801X, 374J00000X, 374K00000X, 374T00000X, 374U00000X, 376G00000X, 376J00000X, 376K00000X, 405300000X, 1223X2210X, 133VN1101X, 133VN1201X, 133VN1301X, 133VN1401X, 133VN1501X, 207RA0002X, 207WX0009X, 207WX0107X, 207WX0108X, 207WX0109X, 207WX0110X, 207WX0120X, 2083A0300X, 193400000X, 251G00000X, 261Q00000X, 261QA1903X, 261QF0400X, 261QM1300X, 261QP2300X, 261QR1300X, 273R00000X, 273Y00000X, 282E00000X, 282N00000X, 314000000X, 332B00000X, 341600000X, 291U00000X, 261QM0801X, 390200000X, 261QR0200X) | 0 | unbounded | Individual and Group Specialties from National Uniform Claim Committee (NUCC) Health Care Provider Taxonomy code set. A full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-IndividualAndGroupSpecialtiesVS.html |


### provider_organization_specialties

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| specialty | string (enum: 101200000X, 101Y00000X, 101YA0400X, 101YM0800X, 101YP1600X, 101YP2500X, 101YS0200X, 102L00000X, 102X00000X, 103G00000X, 103K00000X, 103T00000X, 103TA0400X, 103TA0700X, 103TB0200X, 103TC0700X, 103TC1900X, 103TC2200X, 103TE1100X, 103TF0000X, 103TF0200X, 103TH0004X, 103TH0100X, 103TM1800X, 103TP0016X, 103TP0814X, 103TP2701X, 103TR0400X, 103TS0200X, 104100000X, 1041C0700X, 1041S0200X, 106E00000X, 106H00000X, 106S00000X, 111N00000X, 111NI0013X, 111NI0900X, 111NN0400X, 111NN1001X, 111NP0017X, 111NR0200X, 111NR0400X, 111NS0005X, 111NT0100X, 111NX0100X, 111NX0800X, 122300000X, 1223D0001X, 1223D0004X, 1223E0200X, 1223G0001X, 1223P0106X, 1223P0221X, 1223P0300X, 1223P0700X, 1223S0112X, 1223X0008X, 1223X0400X, 1223X2210X, 122400000X, 124Q00000X, 125J00000X, 125K00000X, 125Q00000X, 126800000X, 126900000X, 132700000X, 133N00000X, 133NN1002X, 133V00000X, 133VN1004X, 133VN1005X, 133VN1006X, 133VN1101X, 133VN1201X, 133VN1301X, 133VN1401X, 133VN1501X, 136A00000X, 146D00000X, 146L00000X, 146M00000X, 146N00000X, 152W00000X, 152WC0802X, 152WL0500X, 152WP0200X, 152WS0006X, 152WV0400X, 152WX0102X, 156F00000X, 156FC0800X, 156FC0801X, 156FX1100X, 156FX1101X, 156FX1201X, 156FX1202X, 156FX1700X, 156FX1800X, 156FX1900X, 163W00000X, 163WA0400X, 163WA2000X, 163WC0200X, 163WC0400X, 163WC1400X, 163WC1500X, 163WC1600X, 163WC2100X, 163WC3500X, 163WD0400X, 163WD1100X, 163WE0003X, 163WE0900X, 163WF0300X, 163WG0000X, 163WG0100X, 163WG0600X, 163WH0200X, 163WH0500X, 163WH1000X, 163WI0500X, 163WI0600X, 163WL0100X, 163WM0102X, 163WM0705X, 163WM1400X, 163WN0002X, 163WN0003X, 163WN0300X, 163WN0800X, 163WN1003X, 163WP0000X, 163WP0200X, 163WP0218X, 163WP0807X, 163WP0808X, 163WP0809X, 163WP1700X, 163WP2201X, 163WR0006X, 163WR0400X, 163WR1000X, 163WS0121X, 163WS0200X, 163WU0100X, 163WW0000X, 163WW0101X, 163WX0002X, 163WX0003X, 163WX0106X, 163WX0200X, 163WX0601X, 163WX0800X, 163WX1100X, 163WX1500X, 164W00000X, 164X00000X, 167G00000X, 170100000X, 170300000X, 171000000X, 1710I1002X, 1710I1003X, 171100000X, 171400000X, 171M00000X, 171R00000X, 171W00000X, 171WH0202X, 171WV0202X, 172A00000X, 172M00000X, 172P00000X, 172V00000X, 173000000X, 173C00000X, 173F00000X, 174400000X, 1744G0900X, 1744P3200X, 1744R1102X, 1744R1103X, 174H00000X, 174M00000X, 174MM1900X, 174N00000X, 174V00000X, 175F00000X, 175L00000X, 175M00000X, 175T00000X, 176B00000X, 176P00000X, 183500000X, 1835C0205X, 1835G0303X, 1835N0905X, 1835N1003X, 1835P0018X, 1835P0200X, 1835P1200X, 1835P1300X, 1835P2201X, 1835X0200X, 183700000X, 193200000X, 202C00000X, 202K00000X, 204C00000X, 204D00000X, 204E00000X, 204F00000X, 204R00000X, 207K00000X, 207KA0200X, 207KI0005X, 207L00000X, 207LA0401X, 207LC0200X, 207LH0002X, 207LP2900X, 207LP3000X, 207N00000X, 207ND0101X, 207ND0900X, 207NI0002X, 207NP0225X, 207NS0135X, 207P00000X, 207PE0004X, 207PE0005X, 207PH0002X, 207PP0204X, 207PS0010X, 207PT0002X, 207Q00000X, 207QA0000X, 207QA0401X, 207QA0505X, 207QB0002X, 207QG0300X, 207QH0002X, 207QS0010X, 207QS1201X, 207R00000X, 207RA0000X, 207RA0001X, 207RA0002X, 207RA0201X, 207RA0401X, 207RB0002X, 207RC0000X, 207RC0001X, 207RC0200X, 207RE0101X, 207RG0100X, 207RG0300X, 207RH0000X, 207RH0002X, 207RH0003X, 207RH0005X, 207RI0001X, 207RI0008X, 207RI0011X, 207RI0200X, 207RM1200X, 207RN0300X, 207RP1001X, 207RR0500X, 207RS0010X, 207RS0012X, 207RT0003X, 207RX0202X, 207SC0300X, 207SG0201X, 207SG0202X, 207SG0203X, 207SG0205X, 207SM0001X, 207T00000X, 207U00000X, 207UN0901X, 207UN0902X, 207UN0903X, 207V00000X, 207VB0002X, 207VC0200X, 207VE0102X, 207VF0040X, 207VG0400X, 207VH0002X, 207VM0101X, 207VX0000X, 207VX0000X, 207W00000X, 207WX0009X, 207WX0107X, 207WX0108X, 207WX0109X, 207WX0110X, 207WX0120X, 207WX0200X, 207X00000X, 207XP3100X, 207XS0106X, 207XS0114X, 207XS0117X, 207XX0004X, 207XX0005X, 207XX0801X, 207Y00000X, 207YP0228X, 207YS0012X, 207YS0123X, 207YX0007X, 207YX0602X, 207YX0901X, 207YX0905X, 207ZB0001X, 207ZC0006X, 207ZC0008X, 207ZC0500X, 207ZD0900X, 207ZF0201X, 207ZH0000X, 207ZI0100X, 207ZM0300X, 207ZN0500X, 207ZP0007X, 207ZP0101X, 207ZP0102X, 207ZP0104X, 207ZP0105X, 207ZP0213X, 208000000X, 2080A0000X, 2080B0002X, 2080C0008X, 2080H0002X, 2080I0007X, 2080N0001X, 2080P0006X, 2080P0008X, 2080P0201X, 2080P0202X, 2080P0203X, 2080P0204X, 2080P0205X, 2080P0206X, 2080P0207X, 2080P0208X, 2080P0210X, 2080P0214X, 2080P0216X, 2080S0010X, 2080S0012X, 2080T0002X, 2080T0004X, 208100000X, 2081H0002X, 2081N0008X, 2081P0004X, 2081P0010X, 2081P0301X, 2081P2900X, 2081S0010X, 208200000X, 2082S0099X, 2082S0105X, 2083A0100X, 2083A0300X, 2083B0002X, 2083C0008X, 2083P0011X, 2083P0500X, 2083P0901X, 2083S0010X, 2083T0002X, 2083X0100X, 2084A0401X, 2084A2900X, 2084B0002X, 2084B0040X, 2084D0003X, 2084F0202X, 2084H0002X, 2084N0008X, 2084N0400X, 2084N0402X, 2084N0600X, 2084P0005X, 2084P0015X, 2084P0301X, 2084P0800X, 2084P0802X, 2084P0804X, 2084P0805X, 2084P2900X, 2084S0010X, 2084S0012X, 2084V0102X, 2085B0100X, 2085D0003X, 2085H0002X, 2085N0700X, 2085N0904X, 2085P0229X, 2085R0001X, 2085R0202X, 2085R0203X, 2085R0204X, 2085R0205X, 2085U0001X, 208600000X, 2086H0002X, 2086S0102X, 2086S0105X, 2086S0120X, 2086S0122X, 2086S0127X, 2086S0129X, 2086X0206X, 208800000X, 2088F0040X, 2088P0231X, 208C00000X, 208D00000X, 208G00000X, 208M00000X, 208U00000X, 208VP0000X, 208VP0014X, 209800000X, 211D00000X, 213E00000X, 213EP0504X, 213EP1101X, 213ER0200X, 213ES0000X, 213ES0103X, 213ES0131X, 221700000X, 222Q00000X, 222Z00000X, 224900000X, 224L00000X, 224P00000X, 224Y00000X, 224Z00000X, 224ZE0001X, 224ZF0002X, 224ZL0004X, 224ZR0403X, 225000000X, 225100000X, 2251C2600X, 2251E1200X, 2251E1300X, 2251G0304X, 2251H1200X, 2251H1300X, 2251N0400X, 2251P0200X, 2251S0007X, 2251X0800X, 225200000X, 225400000X, 225500000X, 2255A2300X, 2255R0406X, 225600000X, 225700000X, 225800000X, 225A00000X, 225B00000X, 225C00000X, 225CA2400X, 225CA2500X, 225CX0006X, 225X00000X, 225XE0001X, 225XE1200X, 225XF0002X, 225XG0600X, 225XH1200X, 225XH1300X, 225XL0004X, 225XM0800X, 225XN1300X, 225XP0019X, 225XP0200X, 225XR0403X, 226000000X, 226300000X, 227800000X, 2278C0205X, 2278E0002X, 2278E1000X, 2278G0305X, 2278G1100X, 2278H0200X, 2278P1004X, 2278P1005X, 2278P1006X, 2278P3800X, 2278P3900X, 2278P4000X, 2278S1500X, 227900000X, 2279C0205X, 2279E0002X, 2279E1000X, 2279G0305X, 2279G1100X, 2279H0200X, 2279P1004X, 2279P1005X, 2279P1006X, 2279P3800X, 2279P3900X, 2279P4000X, 2279S1500X, 229N00000X, 231H00000X, 231HA2400X, 231HA2500X, 235500000X, 2355A2700X, 2355S0801X, 235Z00000X, 237600000X, 237700000X, 242T00000X, 243U00000X, 246Q00000X, 246QB0000X, 246QC1000X, 246QC2700X, 246QH0000X, 246QH0401X, 246QH0600X, 246QI0000X, 246QL0900X, 246QL0901X, 246QM0706X, 246QM0900X, 246R00000X, 246RH0600X, 246RM2200X, 246RP1900X, 246W00000X, 246X00000X, 246XC2901X, 246XC2903X, 246XS1301X, 246Y00000X, 246YC3301X, 246YC3302X, 246YR1600X, 246Z00000X, 246ZA2600X, 246ZB0301X, 246ZB0302X, 246ZB0500X, 246ZB0600X, 246ZC0007X, 246ZE0500X, 246ZE0600X, 246ZG0701X, 246ZG1000X, 246ZI1000X, 246ZN0300X, 246ZS0410X, 246ZX2200X, 247000000X, 2470A2800X, 247100000X, 2471B0102X, 2471C1101X, 2471C1106X, 2471C3401X, 2471C3402X, 2471M1202X, 2471M2300X, 2471N0900X, 2471Q0001X, 2471R0002X, 2471S1302X, 2471V0105X, 2471V0106X, 247200000X, 2472B0301X, 2472D0500X, 2472E0500X, 2472R0900X, 2472V0600X, 247ZC0005X, 342000000X, 363A00000X, 363AM0700X, 363AS0400X, 363L00000X, 363LA2100X, 363LA2200X, 363LC0200X, 363LC1500X, 363LF0000X, 363LG0600X, 363LN0000X, 363LN0005X, 363LP0200X, 363LP0222X, 363LP0808X, 363LP1700X, 363LP2300X, 363LS0200X, 363LW0102X, 363LX0001X, 363LX0106X, 364S00000X, 364SA2100X, 364SA2200X, 364SC0200X, 364SC1501X, 364SC2300X, 364SE0003X, 364SE1400X, 364SF0001X, 364SG0600X, 364SH0200X, 364SH1100X, 364SI0800X, 364SL0600X, 364SM0705X, 364SN0000X, 364SN0800X, 364SP0200X, 364SP0807X, 364SP0808X, 364SP0809X, 364SP0810X, 364SP0811X, 364SP0812X, 364SP0813X, 364SP1700X, 364SP2800X, 364SR0400X, 364SS0200X, 364ST0500X, 364SW0102X, 364SX0106X, 364SX0200X, 364SX0204X, 367500000X, 367A00000X, 367H00000X, 372500000X, 372600000X, 373H00000X, 374700000X, 3747A0650X, 3747P1801X, 374J00000X, 374K00000X, 374T00000X, 374U00000X, 376G00000X, 376J00000X, 376K00000X, 405300000X, 251300000X, 251B00000X, 251C00000X, 251E00000X, 251F00000X, 251G00000X, 251J00000X, 251K00000X, 251S00000X, 251T00000X, 251V00000X, 251X00000X, 252Y00000X, 253J00000X, 253Z00000X, 261Q00000X, 261QA0005X, 261QA0006X, 261QA0600X, 261QA0900X, 261QA1903X, 261QA3000X, 261QB0400X, 261QC0050X, 261QC1500X, 261QC1800X, 261QD0000X, 261QD1600X, 261QE0002X, 261QE0700X, 261QE0800X, 261QF0050X, 261QF0400X, 261QG0250X, 261QH0100X, 261QH0700X, 261QI0500X, 261QL0400X, 261QM0801X, 261QM0850X, 261QM0855X, 261QM1000X, 261QM1100X, 261QM1101X, 261QM1102X, 261QM1103X, 261QM1200X, 261QM1300X, 261QM2500X, 261QM2800X, 261QM3000X, 261QP0904X, 261QP0905X, 261QP1100X, 261QP2000X, 261QP2300X, 261QP2400X, 261QP3300X, 261QR0200X, 261QR0206X, 261QR0207X, 261QR0208X, 261QR0400X, 261QR0401X, 261QR0404X, 261QR0405X, 261QR0800X, 261QR1100X, 261QR1300X, 261QS0112X, 261QS0132X, 261QS1000X, 261QS1200X, 261QU0200X, 261QV0200X, 261QX0100X, 261QX0200X, 261QX0203X, 273100000X, 273R00000X, 273Y00000X, 275N00000X, 276400000X, 281P00000X, 281PC2000X, 282E00000X, 282J00000X, 282N00000X, 282NC0060X, 282NC2000X, 282NR1301X, 282NW0100X, 283Q00000X, 283X00000X, 283XC2000X, 284300000X, 286500000X, 2865M2000X, 2865X1600X, 291900000X, 291U00000X, 292200000X, 293D00000X, 302F00000X, 302R00000X, 305R00000X, 305S00000X, 310400000X, 3104A0625X, 3104A0630X, 310500000X, 311500000X, 311Z00000X, 311ZA0620X, 313M00000X, 314000000X, 3140N1450X, 315D00000X, 315P00000X, 174200000X, 177F00000X, 320600000X, 320700000X, 320800000X, 320900000X, 322D00000X, 323P00000X, 324500000X, 3245S0500X, 385H00000X, 385HR2050X, 385HR2055X, 385HR2060X, 385HR2065X, 331L00000X, 332000000X, 332100000X, 332800000X, 332900000X, 332B00000X, 332BC3200X, 332BD1200X, 332BN1400X, 332BP3500X, 332BX2000X, 332G00000X, 332H00000X, 332S00000X, 332U00000X, 333300000X, 333600000X, 3336C0002X, 3336C0003X, 3336C0004X, 3336H0001X, 3336I0012X, 3336L0003X, 3336M0002X, 3336M0003X, 3336N0007X, 3336S0011X, 335E00000X, 335G00000X, 335U00000X, 335V00000X, 341600000X, 3416A0800X, 3416L0300X, 3416S0300X, 341800000X, 3418M1110X, 3418M1120X, 3418M1130X, 343800000X, 343900000X, 344600000X, 344800000X, 347B00000X, 347C00000X, 347D00000X, 347E00000X, 193400000X, 390200000X) | 0 | unbounded | Specialties value set based on National Uniform Claim Committee (NUCC) Health Care Provider Taxonomy code set. A full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-SpecialtiesVS.html |


### healthcare_services

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| healthcare_service | – | 0 | unbounded | – |
| identifiers | – | 0 | 1 | – |
| identifier | identifier | 0 | unbounded | – |
| is_active | xs:boolean | 0 | 1 | – |
| category | string (enum: Behavioral, Dental, DME, Emergency, Group, Home, Hospital, Laboratory, Other, Outpatient, Provider, Pharmacy, Transport, Urgent, Vision) | 1 | 1 | Valueset for descripting the broad category of service being performed or delivered by a health care service. A full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-HealthcareServiceCategoryVS.html |
| types | – | 0 | 1 | – |
| type | string (enum: 1, 3, 8, 9, 10, 11, 21, 26, 31, 33, 34, 36, 42, 51, 55, 67, 68, 69, 70, 71, 72, 75, 76, 78, 79, 80, 81, 82, 96, 97, 99, 102, 103, 105, 106, 107, 108, 111, 118, 119, 126, 127, 128, 130, 134, 146, 147, 224, 230, 233, 238, 245, 275, 284, 296, 301, 308, 309, 310, 316, 317, 323, 328, 331, 344, 345, 352, 366, 400, 409, 411, 427, 429, 440, 446, 459, 468, 470, 488, 494, 495, 501, 513, 530, 531, 532, 534, 535, 537, 539, 546, 548, 552, 554, 559, 560, 565, 569, 570, 571, 614, 628) | 0 | unbounded | Valueset for HealthCareService type. A full list can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-HealthcareServiceTypeVS.html |
| specialties | provider_organization_specialties | 0 | 1 | – |
| name | string | 0 | 1 | Description of service as presented to a consumer while searching |
| comment | string | 0 | 1 | Additional description and/or any specific issues not covered elsewhere |
| extra_details | string | 0 | 1 | Extra details about the service that can't be placed in the other fields |
| delivery_methods | – | 1 | 1 | – |
| delivery_method | – | 1 | unbounded | – |
| type | string (enum: virtual, physical) | 1 | 1 | Physical or Virtual Service Delivery |
| virtual_modalities | string (enum: phone, video, tdd, sms, app, web) | 0 | unbounded | Modalities of Virtual Delivery-Choose from code valueset. More information can be found here: https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/ValueSet-VirtualModalitiesVS.html |
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
| status | string (enum: active, inactive, issued-in-error, revoked, pending, unknown) | 1 | 1 | Describes the current status of the qualification (i.e. active, inactive, issued in error, revoked, pending, unknown) |
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
| – | provider | – | All of (any order): practitioner, providing_organization | – | sequence |
| practitioner | provider | 1..unbounded | Practitioner is a person who is directly or indirectly involved in the provisioning of healthcare | – | – |
| names | practitioner | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | human_name |
| providing_organization | provider | 1..unbounded | This element is used when the Provider Type is an organizatiaon | – | – |


## All Elements of Provider-Directory XSD

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| providers |  | 1..1 | – | – | – |
| schema_version | providers | 1..1 | This element defines what version of the provider directory schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | providers | 1..1 | This element is used to the unique identifier assigned to your organization | – | string |
| date_time_reported | providers | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |
| provider | providers | 1..unbounded | – | – | – |
| – | provider | – | All of (any order): practitioner, providing_organization | – | sequence |
| practitioner | provider | 1..unbounded | Practitioner is a person who is directly or indirectly involved in the provisioning of healthcare | – | – |
| unique_identifier | practitioner | 0..1 | – | – | string |
| npi | practitioner | 0..1 | – | – | NPI |
| is_active | practitioner | 0..1 | Whether this practitioner's record is in active use | – | xs:boolean |
| names | practitioner | 1..1 | – | – | – |
| name | names | 1..unbounded | – | – | human_name |
| telecoms | practitioner | 0..1 | – | – | – |
| telecom | telecoms | 0..unbounded | – | – | telecom |
| addresses | practitioner | 0..1 | – | – | – |
| address | addresses | 0..unbounded | – | – | address |
| gender | practitioner | 0..1 | – | – | string (enum: male, female, other, unknown) |
| providing_organization | provider | 1..unbounded | This element is used when the Provider Type is an organizatiaon | – | – |
| unique_identifier | providing_organization | 0..1 | – | – | string |


## Practical Guidance

### Submission Frequency

Provider-Directory files should be submitted according to the schedule agreed upon with HealthLX. Typical submission frequencies include daily, weekly, or monthly updates.

### Adds, Updates, and Deletes

- **Adds**: Include new member records with all required fields populated
- **Updates**: Submit complete member records with updated information
- **Deletes**: Follow the agreed-upon process for member terminations or removals

### Member Identification

Each member must be uniquely identified using the appropriate identifier fields. Ensure consistency in member identifiers across all submissions to maintain data integrity.

