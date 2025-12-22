![HLX Logo](../assets/hlx_logo.png)

# EOB Implementation Guide

**HLX0123 HLX EOB IG (XSD_V10.0)**

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
8. [Required Elements of EOB XSD](#required-elements-of-eob-xsd)
9. [All Elements of EOB XSD](#all-elements-of-eob-xsd)
10. [Practical Guidance](#practical-guidance)

## Disclaimer

This document is provided by HealthLX for informational purposes only. Information within this document is believed to be correct as of the noted date of publication. Although HealthLX makes every reasonable effort to present information in a timely and accurate manner, HealthLX does not warrant this information for accuracy, completeness or fitness for any purpose, express or implied. The information provided herein does not constitute the rendering of legal, financial or other professional advice or recommendations by HealthLX.

## Overview

This implementation guide provides field mappings and requirements for HealthLX EOB data submissions in XML format based on FHIR R4 standards. XML format enables structured data exchange with built-in validation against the provided XSD schema.

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
| unsignedInt | xs:unsignedInt | – | – | Pattern: 0\|([1-9][0-9]*) |
| integer | xs:integer | – | – | Pattern: [0]\|[-+]?[1-9][0-9]* |
| time | xs:time | – | – | Pattern: ([01][0-9]\|2[0-3]):[0-5][0-9]:[0-5][0-9](\.\d{1,9})? |
| dateTime | xs:string | – | – | Pattern: ([12]\d{3})-(0[1-9]\|1[0-2])-(0[1-9]\|[1-2][0-9]\|3[0-1])(T([01][0-9]\|2[0-3]):[0-5][0-9]:[0-5][0-9](\.\d{1,6})?((Z\|(\+\|-)((0[0-9]\|1[0-3]):(00\|15\|30\|45)\|14:00))?))? |
| date | xs:date | – | – | Pattern: ([12]\d{3}-(0[1-9]\|1[0-2])-(0[1-9]\|[12]\d\|3[01])) |
| decimal | xs:decimal | – | – | Pattern: -?(0\|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)? |
| currency | core:string | – | AED, AFN, ALL, AMD, ANG, AOA, ARS, AUD, AWG, AZN, BAM, BBD, BDT, BGN, BHD, BIF, BMD, BND, BOB, BOV, BRL, BSD, BTN, BWP, BYN, BZD, CAD, CDF, CHE, CHF, CHW, CLF, CLP, CNY, COP, COU, CRC, CUC, CUP, CVE, CZK, DJF, DKK, DOP, DZD, EGP, ERN, ETB, EUR, FJD, FKP, GBP, GEL, GGP, GHS, GIP, GMD, GNF, GTQ, GYD, HKD, HNL, HRK, HTG, HUF, IDR, ILS, IMP, INR, IQD, IRR, ISK, JEP, JMD, JOD, JPY, KES, KGS, KHR, KMF, KPW, KRW, KWD, KYD, KZT, LAK, LBP, LKR, LRD, LSL, LYD, MAD, MDL, MGA, MKD, MMK, MNT, MOP, MRU, MUR, MVR, MWK, MXN, MXV, MYR, MZN, NAD, NGN, NIO, NOK, NPR, NZD, OMR, PAB, PEN, PGK, PHP, PKR, PLN, PYG, QAR, RON, RSD, RUB, RWF, SAR, SBD, SCR, SDG, SEK, SGD, SHP, SLL, SOS, SRD, SSP, STN, SVC, SYP, SZL, THB, TJS, TMT, TND, TOP, TRY, TTD, TVD, TWD, TZS, UAH, UGX, USD, USN, UYI, UYU, UZS, VEF, VND, VUV, WST, XAF, XAG, XAU, XBA, XBB, XBC, XBD, XCD, XDR, XOF, XPD, XPF, XPT, XSU, XTS, XUA, XXX, YER, ZAR, ZMW, ZWL | – |
| adjudication_category | core:string | – | submitted, copay, eligible, deductible, benefit, coinsurance, noncovered, priorpayerpaid, paidbypatient, paidtopatient, paidtoprovider, memberliability, discount, drugcost, inoutnetwork, denialreason, allowedunits | – |
| language | core:string | – | ar, bn, cs, da, de, de-AT, de-CH, de-DE, el, en, en-AU, en-CA, en-GB, en-IN, en-NZ, en-SG, en-US, es, es-AR, es-ES, es-UY, fi, fr, fr-BE, fr-CH, fr-FR, fy, fy-NL, hi, hr, it, it-CH, it-IT, ja, ko, nl, nl-BE, nl-NL, no, no-NO, pa, pl, pt, pt-BR, ru, ru-RU, sr, sr-RS, sv, sv-SE, te, tr, zh, zh-CN, zh-HK, zh-SG, zh-TW | – |
| reference | core:string | – | – | – |


## Core Model Types

The following types are imported from the Core-model. See [Core-model Guide](Core-model_Guide.md) for complete documentation.

| Name | Base Type | Description | Enumerations | Constraints |
| --- | --- | --- | --- | --- |
| NPI | xs:string | – | – | Pattern: [0-9]{10} |
| positiveInt | xs:positiveInteger | – | – | Pattern: \+?[1-9][0-9]* |
| string | xs:string | – | – | Pattern: [ \r\n\t\S]+ |


## Complex Types

### period

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| start | dateTime | 0 | 1 | – |
| end | dateTime | 0 | 1 | – |


### identifier

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | core:string | 1 | 1 | – |
| type | core:string | 0 | 1 | – |
| system | core:string | 0 | 1 | – |


### eob_identifier

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | core:string | 1 | 1 | – |
| type | core:string (enum: uc) | 1 | 1 | – |


### timing

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| timing_date | date | 0 | 1 | – |
| timing_period | period | 0 | 1 | – |


### quantity

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| value | decimal | 0 | 1 | – |
| comparator | core:string | 0 | 1 | – |
| unit | core:string | 0 | 1 | – |
| system | core:string | 0 | 1 | – |
| code | core:string | 0 | 1 | – |


### value

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
| state | core:string | 0 | 1 | Sub-unit of country (abbreviations ok) |
| postal_code | core:string | 1 | 1 | The postal code or post code of the address. The postal code supports an unlimited amount of numbers and letters. |
| country | xs:string | 0 | 1 | Country (e.g. can be ISO 3166 2 or 3 letter code) |
| period | period | 0 | 1 | – |


### telecom

| Field Name | Type | MinOccurs | MaxOccurs | Description |
| --- | --- | --- | --- | --- |
| system | core:string (enum: phone, fax, email, pager, url, sms, other) | 1 | 1 | Use this element to descripbe the contact point. https://www.hl7.org/fhir/valueset-contact-point-system.html |
| value | core:string | 1 | 1 | The actual value of the contact point |
| use | core:string (enum: home, work, temp, old, mobile) | 0 | 1 | The use of the contact point. https://www.hl7.org/fhir/valueset-contact-point-use.html |
| rank | core:positiveInt | 0 | 1 | Specify preferred order of use (1 = highest) |
| period | period | 0 | 1 | Time period when the contact point was/is in use |


### practitioner

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


### organization

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


### member_person

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
| language | – | 1 | 1 | This value set includes common codes from BCP-47 (http://tools.ietf.org/html/bcp47). More information can be found here: http://hl7.org/fhir/R4/valueset-languages.html |
| language_code | language | 1 | 1 | – |
| system | core:string (enum: urn:ietf:bcp:47) | 0 | 1 | – |
| display | core:string | 0 | 1 | Description |
| is_preferred | xs:boolean | 0 | 1 | Is this language the preferred language (true/false) |
| us_core_race | – | 0 | 1 | – |
| omb_category_code | – | 0 | 5 | This element is for selecting 1 of the 5 OMB race category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html |
| code | core:string (enum: 1002-5, 2028-9, 2054-5, 2076-8, 2106-3, UNK, ASKU) | 1 | 1 | – |
| system | core:string (enum: urn:oid:2.16.840.1.113883.6.238, http://terminology.hl7.org/CodeSystem/v3-NullFlavor) | 0 | 1 | – |
| detailed_code | xs:string (enum: 1000-9, 1004-1, 1735-0, 1006-6, 1008-2, 1010-8, 1021-5, 1026-4, 1028-0, 1030-6, 1033-0, 1035-5, 1037-1, 1039-7, 1041-3, 1044-7, 1053-8, 1068-6, 1076-9, 1078-5, 1080-1, 1082-7, 1086-8, 1088-4, 1100-7, 1102-3, 1106-4, 1108-0, 1112-2, 1114-8, 1123-9, 1150-2, 1153-6, 1155-1, 1162-7, 1165-0, 1167-6, 1169-2, 1171-8, 1173-4, 1175-9, 1178-3, 1180-9, 1182-5, 1184-1, 1186-6, 1189-0, 1191-6, 1193-2, 1207-0, 1209-6, 1211-2, 1214-6, 1222-9, 1233-6, 1250-0, 1252-6, 1254-2, 1256-7, 1258-3, 1260-9, 1262-5, 1264-1, 1267-4, 1269-0, 1271-6, 1275-7, 1277-3, 1279-9, 1281-5, 1285-6, 1297-1, 1299-7, 1301-1, 1303-7, 1305-2, 1309-4, 1312-8, 1317-7, 1319-3, 1321-9, 1323-5, 1325-0, 1331-8, 1340-9, 1342-5, 1344-1, 1348-2, 1350-8, 1352-4, 1354-0, 1356-5, 1358-1, 1363-1, 1365-6, 1368-0, 1370-6, 1372-2, 1374-8, 1376-3, 1378-9, 1380-5, 1382-1, 1387-0, 1389-6, 1391-2, 1403-5, 1405-0, 1407-6, 1409-2, 1411-8, 1416-7, 1439-9, 1441-5, 1445-6, 1448-0, 1450-6, 1453-0, 1456-3, 1460-5, 1462-1, 1464-7, 1474-6, 1478-7, 1487-8, 1489-4, 1518-0, 1541-2, 1543-8, 1545-3, 1547-9, 1549-5, 1551-1, 1556-0, 1558-6, 1560-2, 1562-8, 1564-4, 1566-9, 1573-5, 1576-8, 1578-4, 1582-6, 1584-2, 1586-7, 1602-2, 1607-1, 1609-7, 1643-6, 1645-1, 1647-7, 1649-3, 1651-9, 1653-5, 1659-2, 1661-8, 1663-4, 1665-9, 1667-5, 1670-9, 1675-8, 1677-4, 1679-0, 1683-2, 1685-7, 1687-3, 1692-3, 1694-9, 1696-4, 1700-4, 1702-0, 1704-6, 1707-9, 1709-5, 1711-1, 1715-2, 1717-8, 1722-8, 1724-4, 1732-7, 1011-6, 1012-4, 1013-2, 1014-0, 1015-7, 1016-5, 1017-3, 1018-1, 1019-9, 1022-3, 1023-1, 1024-9, 1031-4, 1042-1, 1045-4, 1046-2, 1047-0, 1048-8, 1049-6, 1050-4, 1051-2, 1054-6, 1055-3, 1056-1, 1057-9, 1058-7, 1059-5, 1060-3, 1061-1, 1062-9, 1063-7, 1064-5, 1065-2, 1066-0, 1069-4, 1070-2, 1071-0, 1072-8, 1073-6, 1074-4, 1083-5, 1084-3, 1089-2, 1090-0, 1091-8, 1092-6, 1093-4, 1094-2, 1095-9, 1096-7, 1097-5, 1098-3, 1103-1, 1104-9, 1109-8, 1110-6, 1115-5, 1116-3, 1117-1, 1118-9, 1119-7, 1120-5, 1121-3, 1124-7, 1125-4, 1126-2, 1127-0, 1128-8, 1129-6, 1130-4, 1131-2, 1132-0, 1133-8, 1134-6, 1135-3, 1136-1, 1137-9, 1138-7, 1139-5, 1140-3, 1141-1, 1142-9, 1143-7, 1144-5, 1145-2, 1146-0, 1147-8, 1148-6, 1151-0, 1156-9, 1157-7, 1158-5, 1159-3, 1160-1, 1163-5, 1176-7, 1187-4, 1194-0, 1195-7, 1196-5, 1197-3, 1198-1, 1199-9, 1200-5, 1201-3, 1202-1, 1203-9, 1204-7, 1205-4, 1212-0, 1215-3, 1216-1, 1217-9, 1218-7, 1219-5, 1220-3, 1223-7, 1224-5, 1225-2, 1226-0, 1227-8, 1228-6, 1229-4, 1230-2, 1231-0, 1234-4, 1235-1, 1236-9, 1237-7, 1238-5, 1239-3, 1240-1, 1241-9, 1242-7, 1243-5, 1244-3, 1245-0, 1246-8, 1247-6, 1248-4, 1265-8, 1272-4, 1273-2, 1282-3, 1283-1, 1286-4, 1287-2, 1288-0, 1289-8, 1290-6, 1291-4, 1292-2, 1293-0, 1294-8, 1295-5, 1306-0, 1307-8, 1310-2, 1313-6, 1314-4, 1315-1, 1326-8, 1327-6, 1328-4, 1329-2, 1332-6, 1333-4, 1334-2, 1335-9, 1336-7, 1337-5, 1338-3, 1345-8, 1346-6, 1359-9, 1360-7, 1361-5, 1366-4, 1383-9, 1384-7, 1385-4, 1392-0, 1393-8, 1394-6, 1395-3, 1396-1, 1397-9, 1398-7, 1399-5, 1400-1, 1401-9, 1412-6, 1413-4, 1414-2, 1417-5, 1418-3, 1419-1, 1420-9, 1421-7, 1422-5, 1423-3, 1424-1, 1425-8, 1426-6, 1427-4, 1428-2, 1429-0, 1430-8, 1431-6, 1432-4, 1433-2, 1434-0, 1435-7, 1436-5, 1437-3, 1442-3, 1443-1, 1446-4, 1451-4, 1454-8, 1457-1, 1458-9, 1465-4, 1466-2, 1467-0, 1468-8, 1469-6, 1470-4, 1471-2, 1472-0, 1475-3, 1476-1, 1479-5, 1480-3, 1481-1, 1482-9, 1483-7, 1484-5, 1485-2, 1490-2, 1491-0, 1492-8, 1493-6, 1494-4, 1495-1, 1496-9, 1497-7, 1498-5, 1499-3, 1500-8, 1501-6, 1502-4, 1503-2, 1504-0, 1505-7, 1506-5, 1507-3, 1508-1, 1509-9, 1510-7, 1511-5, 1512-3, 1513-1, 1514-9, 1515-6, 1516-4, 1519-8, 1520-6, 1521-4, 1522-2, 1523-0, 1524-8, 1525-5, 1526-3, 1527-1, 1528-9, 1529-7, 1530-5, 1531-3, 1532-1, 1533-9, 1534-7, 1535-4, 1536-2, 1537-0, 1538-8, 1539-6, 1552-9, 1553-7, 1554-5, 1567-7, 1568-5, 1569-3, 1570-1, 1571-9, 1574-3, 1579-2, 1580-0, 1587-5, 1588-3, 1589-1, 1590-9, 1591-7, 1592-5, 1593-3, 1594-1, 1595-8, 1596-6, 1597-4, 1598-2, 1599-0, 1600-6, 1603-0, 1604-8, 1605-5, 1610-5, 1611-3, 1612-1, 1613-9, 1614-7, 1615-4, 1616-2, 1617-0, 1618-8, 1619-6, 1620-4, 1621-2, 1622-0, 1623-8, 1624-6, 1625-3, 1626-1, 1627-9, 1628-7, 1629-5, 1630-3, 1631-1, 1632-9, 1633-7, 1634-5, 1635-2, 1636-0, 1637-8, 1638-6, 1639-4, 1640-2, 1641-0, 1654-3, 1655-0, 1656-8, 1657-6, 1668-3, 1671-7, 1672-5, 1673-3, 1680-8, 1681-6, 1688-1, 1689-9, 1690-7, 1697-2, 1698-0, 1705-3, 1712-9, 1713-7, 1718-6, 1719-4, 1720-2, 1725-1, 1726-9, 1727-7, 1728-5, 1729-3, 1730-1, 1731-9, 1733-5, 1737-6, 1840-8, 1966-1, 1739-2, 1811-9, 1740-0, 1741-8, 1742-6, 1743-4, 1744-2, 1745-9, 1746-7, 1747-5, 1748-3, 1749-1, 1750-9, 1751-7, 1752-5, 1753-3, 1754-1, 1755-8, 1756-6, 1757-4, 1758-2, 1759-0, 1760-8, 1761-6, 1762-4, 1763-2, 1764-0, 1765-7, 1766-5, 1767-3, 1768-1, 1769-9, 1770-7, 1771-5, 1772-3, 1773-1, 1774-9, 1775-6, 1776-4, 1777-2, 1778-0, 1779-8, 1780-6, 1781-4, 1782-2, 1783-0, 1784-8, 1785-5, 1786-3, 1787-1, 1788-9, 1789-7, 1790-5, 1791-3, 1792-1, 1793-9, 1794-7, 1795-4, 1796-2, 1797-0, 1798-8, 1799-6, 1800-2, 1801-0, 1802-8, 1803-6, 1804-4, 1805-1, 1806-9, 1807-7, 1808-5, 1809-3, 1813-5, 1837-4, 1814-3, 1815-0, 1816-8, 1817-6, 1818-4, 1819-2, 1820-0, 1821-8, 1822-6, 1823-4, 1824-2, 1825-9, 1826-7, 1827-5, 1828-3, 1829-1, 1830-9, 1831-7, 1832-5, 1833-3, 1834-1, 1835-8, 1838-2, 1842-4, 1844-0, 1891-1, 1896-0, 1845-7, 1846-5, 1847-3, 1848-1, 1849-9, 1850-7, 1851-5, 1852-3, 1853-1, 1854-9, 1855-6, 1856-4, 1857-2, 1858-0, 1859-8, 1860-6, 1861-4, 1862-2, 1863-0, 1864-8, 1865-5, 1866-3, 1867-1, 1868-9, 1869-7, 1870-5, 1871-3, 1872-1, 1873-9, 1874-7, 1875-4, 1876-2, 1877-0, 1878-8, 1879-6, 1880-4, 1881-2, 1882-0, 1883-8, 1884-6, 1885-3, 1886-1, 1887-9, 1888-7, 1889-5, 1892-9, 1893-7, 1894-5, 1897-8, 1898-6, 1899-4, 1900-0, 1901-8, 1902-6, 1903-4, 1904-2, 1905-9, 1906-7, 1907-5, 1908-3, 1909-1, 1910-9, 1911-7, 1912-5, 1913-3, 1914-1, 1915-8, 1916-6, 1917-4, 1918-2, 1919-0, 1920-8, 1921-6, 1922-4, 1923-2, 1924-0, 1925-7, 1926-5, 1927-3, 1928-1, 1929-9, 1930-7, 1931-5, 1932-3, 1933-1, 1934-9, 1935-6, 1936-4, 1937-2, 1938-0, 1939-8, 1940-6, 1941-4, 1942-2, 1943-0, 1944-8, 1945-5, 1946-3, 1947-1, 1948-9, 1949-7, 1950-5, 1951-3, 1952-1, 1953-9, 1954-7, 1955-4, 1956-2, 1957-0, 1958-8, 1959-6, 1960-4, 1961-2, 1962-0, 1963-8, 1964-6, 1968-7, 1972-9, 1984-4, 1990-1, 1992-7, 2002-4, 2004-0, 2006-5, 1969-5, 1970-3, 1973-7, 1974-5, 1975-2, 1976-0, 1977-8, 1978-6, 1979-4, 1980-2, 1981-0, 1982-8, 1985-1, 1986-9, 1987-7, 1988-5, 1993-5, 1994-3, 1995-0, 1996-8, 1997-6, 1998-4, 1999-2, 2000-8, 2007-3, 2008-1, 2009-9, 2010-7, 2011-5, 2012-3, 2013-1, 2014-9, 2015-6, 2016-4, 2017-2, 2018-0, 2019-8, 2020-6, 2021-4, 2022-2, 2023-0, 2024-8, 2025-5, 2026-3, 2029-7, 2030-5, 2031-3, 2032-1, 2033-9, 2034-7, 2035-4, 2036-2, 2037-0, 2038-8, 2039-6, 2040-4, 2041-2, 2042-0, 2043-8, 2044-6, 2045-3, 2046-1, 2047-9, 2048-7, 2049-5, 2050-3, 2051-1, 2052-9, 2056-0, 2058-6, 2060-2, 2067-7, 2068-5, 2069-3, 2070-1, 2071-9, 2072-7, 2073-5, 2074-3, 2075-0, 2061-0, 2062-8, 2063-6, 2064-4, 2065-1, 2066-9, 2078-4, 2085-9, 2100-6, 2500-7, 2079-2, 2080-0, 2081-8, 2082-6, 2083-4, 2086-7, 2087-5, 2088-3, 2089-1, 2090-9, 2091-7, 2092-5, 2093-3, 2094-1, 2095-8, 2096-6, 2097-4, 2098-2, 2101-4, 2102-2, 2103-0, 2104-8, 2108-9, 2118-8, 2129-5, 2109-7, 2110-5, 2111-3, 2112-1, 2113-9, 2114-7, 2115-4, 2116-2, 2119-6, 2120-4, 2121-2, 2122-0, 2123-8, 2124-6, 2125-3, 2126-1, 2127-9, 2131-1) | 0 | unbounded | This element is for selecting 1 of the additional expansion codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html |
| text | core:string | 1 | 1 | Use this element for adding a text description |
| us_core_ethnicity | – | 0 | 1 | – |
| omb_category_code | core:string (enum: 2135-2, 2186-5) | 0 | 1 | This element is for selecting 1 of the OMB ethnicity category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-omb-ethnicity-category.html |
| detailed_code | xs:string (enum: 2133-7, 2137-8, 2148-5, 2155-0, 2165-9, 2178-2, 2180-8, 2182-4, 2184-0, 2138-6, 2139-4, 2140-2, 2141-0, 2142-8, 2143-6, 2144-4, 2145-1, 2146-9, 2149-3, 2150-1, 2151-9, 2152-7, 2153-5, 2156-8, 2157-6, 2158-4, 2159-2, 2160-0, 2161-8, 2162-6, 2163-4, 2166-7, 2167-5, 2168-3, 2169-1, 2170-9, 2171-7, 2172-5, 2173-3, 2174-1, 2175-8, 2176-6) | 0 | unbounded | This element is for selecting 1 of the additional ethnicity codes from the CDC that can be found here: https://www.hl7.org/fhir/us/core/ValueSet-detailed-ethnicity.html |
| text | core:string | 1 | 1 | Use this element for adding a text description if the ethnicity is not listed within the enummeration |
| us_core_birth_sex | core:string (enum: M, F, UNK) | 0 | 1 | This element is used for selecting birth sex (M = Male, F = Female, UNK = Unknown) |


### subscriber_person

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
| gender | core:string (enum: male, female, other, unknown) | 0 | 1 | Use this element for Gender (male, female, other or unknown) |
| birth_date | xs:date | 0 | 1 | Birth date (1900-01-01) |
| marital_status | core:string (enum: A, D, I, L, M, P, S, T, U, W, UNK) | 0 | 1 | Marital Status, more information can be found here: http://hl7.org/fhir/R4/valueset-marital-status.html |
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
| omb_category_code | core:string (enum: 1002-5, 2028-9, 2054-5, 2076-8, 2106-3) | 0 | 5 | This element is for selecting 1 of the 5 OMB race category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html |
| detailed_code | xs:string (enum: 1000-9, 1004-1, 1735-0, 1006-6, 1008-2, 1010-8, 1021-5, 1026-4, 1028-0, 1030-6, 1033-0, 1035-5, 1037-1, 1039-7, 1041-3, 1044-7, 1053-8, 1068-6, 1076-9, 1078-5, 1080-1, 1082-7, 1086-8, 1088-4, 1100-7, 1102-3, 1106-4, 1108-0, 1112-2, 1114-8, 1123-9, 1150-2, 1153-6, 1155-1, 1162-7, 1165-0, 1167-6, 1169-2, 1171-8, 1173-4, 1175-9, 1178-3, 1180-9, 1182-5, 1184-1, 1186-6, 1189-0, 1191-6, 1193-2, 1207-0, 1209-6, 1211-2, 1214-6, 1222-9, 1233-6, 1250-0, 1252-6, 1254-2, 1256-7, 1258-3, 1260-9, 1262-5, 1264-1, 1267-4, 1269-0, 1271-6, 1275-7, 1277-3, 1279-9, 1281-5, 1285-6, 1297-1, 1299-7, 1301-1, 1303-7, 1305-2, 1309-4, 1312-8, 1317-7, 1319-3, 1321-9, 1323-5, 1325-0, 1331-8, 1340-9, 1342-5, 1344-1, 1348-2, 1350-8, 1352-4, 1354-0, 1356-5, 1358-1, 1363-1, 1365-6, 1368-0, 1370-6, 1372-2, 1374-8, 1376-3, 1378-9, 1380-5, 1382-1, 1387-0, 1389-6, 1391-2, 1403-5, 1405-0, 1407-6, 1409-2, 1411-8, 1416-7, 1439-9, 1441-5, 1445-6, 1448-0, 1450-6, 1453-0, 1456-3, 1460-5, 1462-1, 1464-7, 1474-6, 1478-7, 1487-8, 1489-4, 1518-0, 1541-2, 1543-8, 1545-3, 1547-9, 1549-5, 1551-1, 1556-0, 1558-6, 1560-2, 1562-8, 1564-4, 1566-9, 1573-5, 1576-8, 1578-4, 1582-6, 1584-2, 1586-7, 1602-2, 1607-1, 1609-7, 1643-6, 1645-1, 1647-7, 1649-3, 1651-9, 1653-5, 1659-2, 1661-8, 1663-4, 1665-9, 1667-5, 1670-9, 1675-8, 1677-4, 1679-0, 1683-2, 1685-7, 1687-3, 1692-3, 1694-9, 1696-4, 1700-4, 1702-0, 1704-6, 1707-9, 1709-5, 1711-1, 1715-2, 1717-8, 1722-8, 1724-4, 1732-7, 1011-6, 1012-4, 1013-2, 1014-0, 1015-7, 1016-5, 1017-3, 1018-1, 1019-9, 1022-3, 1023-1, 1024-9, 1031-4, 1042-1, 1045-4, 1046-2, 1047-0, 1048-8, 1049-6, 1050-4, 1051-2, 1054-6, 1055-3, 1056-1, 1057-9, 1058-7, 1059-5, 1060-3, 1061-1, 1062-9, 1063-7, 1064-5, 1065-2, 1066-0, 1069-4, 1070-2, 1071-0, 1072-8, 1073-6, 1074-4, 1083-5, 1084-3, 1089-2, 1090-0, 1091-8, 1092-6, 1093-4, 1094-2, 1095-9, 1096-7, 1097-5, 1098-3, 1103-1, 1104-9, 1109-8, 1110-6, 1115-5, 1116-3, 1117-1, 1118-9, 1119-7, 1120-5, 1121-3, 1124-7, 1125-4, 1126-2, 1127-0, 1128-8, 1129-6, 1130-4, 1131-2, 1132-0, 1133-8, 1134-6, 1135-3, 1136-1, 1137-9, 1138-7, 1139-5, 1140-3, 1141-1, 1142-9, 1143-7, 1144-5, 1145-2, 1146-0, 1147-8, 1148-6, 1151-0, 1156-9, 1157-7, 1158-5, 1159-3, 1160-1, 1163-5, 1176-7, 1187-4, 1194-0, 1195-7, 1196-5, 1197-3, 1198-1, 1199-9, 1200-5, 1201-3, 1202-1, 1203-9, 1204-7, 1205-4, 1212-0, 1215-3, 1216-1, 1217-9, 1218-7, 1219-5, 1220-3, 1223-7, 1224-5, 1225-2, 1226-0, 1227-8, 1228-6, 1229-4, 1230-2, 1231-0, 1234-4, 1235-1, 1236-9, 1237-7, 1238-5, 1239-3, 1240-1, 1241-9, 1242-7, 1243-5, 1244-3, 1245-0, 1246-8, 1247-6, 1248-4, 1265-8, 1272-4, 1273-2, 1282-3, 1283-1, 1286-4, 1287-2, 1288-0, 1289-8, 1290-6, 1291-4, 1292-2, 1293-0, 1294-8, 1295-5, 1306-0, 1307-8, 1310-2, 1313-6, 1314-4, 1315-1, 1326-8, 1327-6, 1328-4, 1329-2, 1332-6, 1333-4, 1334-2, 1335-9, 1336-7, 1337-5, 1338-3, 1345-8, 1346-6, 1359-9, 1360-7, 1361-5, 1366-4, 1383-9, 1384-7, 1385-4, 1392-0, 1393-8, 1394-6, 1395-3, 1396-1, 1397-9, 1398-7, 1399-5, 1400-1, 1401-9, 1412-6, 1413-4, 1414-2, 1417-5, 1418-3, 1419-1, 1420-9, 1421-7, 1422-5, 1423-3, 1424-1, 1425-8, 1426-6, 1427-4, 1428-2, 1429-0, 1430-8, 1431-6, 1432-4, 1433-2, 1434-0, 1435-7, 1436-5, 1437-3, 1442-3, 1443-1, 1446-4, 1451-4, 1454-8, 1457-1, 1458-9, 1465-4, 1466-2, 1467-0, 1468-8, 1469-6, 1470-4, 1471-2, 1472-0, 1475-3, 1476-1, 1479-5, 1480-3, 1481-1, 1482-9, 1483-7, 1484-5, 1485-2, 1490-2, 1491-0, 1492-8, 1493-6, 1494-4, 1495-1, 1496-9, 1497-7, 1498-5, 1499-3, 1500-8, 1501-6, 1502-4, 1503-2, 1504-0, 1505-7, 1506-5, 1507-3, 1508-1, 1509-9, 1510-7, 1511-5, 1512-3, 1513-1, 1514-9, 1515-6, 1516-4, 1519-8, 1520-6, 1521-4, 1522-2, 1523-0, 1524-8, 1525-5, 1526-3, 1527-1, 1528-9, 1529-7, 1530-5, 1531-3, 1532-1, 1533-9, 1534-7, 1535-4, 1536-2, 1537-0, 1538-8, 1539-6, 1552-9, 1553-7, 1554-5, 1567-7, 1568-5, 1569-3, 1570-1, 1571-9, 1574-3, 1579-2, 1580-0, 1587-5, 1588-3, 1589-1, 1590-9, 1591-7, 1592-5, 1593-3, 1594-1, 1595-8, 1596-6, 1597-4, 1598-2, 1599-0, 1600-6, 1603-0, 1604-8, 1605-5, 1610-5, 1611-3, 1612-1, 1613-9, 1614-7, 1615-4, 1616-2, 1617-0, 1618-8, 1619-6, 1620-4, 1621-2, 1622-0, 1623-8, 1624-6, 1625-3, 1626-1, 1627-9, 1628-7, 1629-5, 1630-3, 1631-1, 1632-9, 1633-7, 1634-5, 1635-2, 1636-0, 1637-8, 1638-6, 1639-4, 1640-2, 1641-0, 1654-3, 1655-0, 1656-8, 1657-6, 1668-3, 1671-7, 1672-5, 1673-3, 1680-8, 1681-6, 1688-1, 1689-9, 1690-7, 1697-2, 1698-0, 1705-3, 1712-9, 1713-7, 1718-6, 1719-4, 1720-2, 1725-1, 1726-9, 1727-7, 1728-5, 1729-3, 1730-1, 1731-9, 1733-5, 1737-6, 1840-8, 1966-1, 1739-2, 1811-9, 1740-0, 1741-8, 1742-6, 1743-4, 1744-2, 1745-9, 1746-7, 1747-5, 1748-3, 1749-1, 1750-9, 1751-7, 1752-5, 1753-3, 1754-1, 1755-8, 1756-6, 1757-4, 1758-2, 1759-0, 1760-8, 1761-6, 1762-4, 1763-2, 1764-0, 1765-7, 1766-5, 1767-3, 1768-1, 1769-9, 1770-7, 1771-5, 1772-3, 1773-1, 1774-9, 1775-6, 1776-4, 1777-2, 1778-0, 1779-8, 1780-6, 1781-4, 1782-2, 1783-0, 1784-8, 1785-5, 1786-3, 1787-1, 1788-9, 1789-7, 1790-5, 1791-3, 1792-1, 1793-9, 1794-7, 1795-4, 1796-2, 1797-0, 1798-8, 1799-6, 1800-2, 1801-0, 1802-8, 1803-6, 1804-4, 1805-1, 1806-9, 1807-7, 1808-5, 1809-3, 1813-5, 1837-4, 1814-3, 1815-0, 1816-8, 1817-6, 1818-4, 1819-2, 1820-0, 1821-8, 1822-6, 1823-4, 1824-2, 1825-9, 1826-7, 1827-5, 1828-3, 1829-1, 1830-9, 1831-7, 1832-5, 1833-3, 1834-1, 1835-8, 1838-2, 1842-4, 1844-0, 1891-1, 1896-0, 1845-7, 1846-5, 1847-3, 1848-1, 1849-9, 1850-7, 1851-5, 1852-3, 1853-1, 1854-9, 1855-6, 1856-4, 1857-2, 1858-0, 1859-8, 1860-6, 1861-4, 1862-2, 1863-0, 1864-8, 1865-5, 1866-3, 1867-1, 1868-9, 1869-7, 1870-5, 1871-3, 1872-1, 1873-9, 1874-7, 1875-4, 1876-2, 1877-0, 1878-8, 1879-6, 1880-4, 1881-2, 1882-0, 1883-8, 1884-6, 1885-3, 1886-1, 1887-9, 1888-7, 1889-5, 1892-9, 1893-7, 1894-5, 1897-8, 1898-6, 1899-4, 1900-0, 1901-8, 1902-6, 1903-4, 1904-2, 1905-9, 1906-7, 1907-5, 1908-3, 1909-1, 1910-9, 1911-7, 1912-5, 1913-3, 1914-1, 1915-8, 1916-6, 1917-4, 1918-2, 1919-0, 1920-8, 1921-6, 1922-4, 1923-2, 1924-0, 1925-7, 1926-5, 1927-3, 1928-1, 1929-9, 1930-7, 1931-5, 1932-3, 1933-1, 1934-9, 1935-6, 1936-4, 1937-2, 1938-0, 1939-8, 1940-6, 1941-4, 1942-2, 1943-0, 1944-8, 1945-5, 1946-3, 1947-1, 1948-9, 1949-7, 1950-5, 1951-3, 1952-1, 1953-9, 1954-7, 1955-4, 1956-2, 1957-0, 1958-8, 1959-6, 1960-4, 1961-2, 1962-0, 1963-8, 1964-6, 1968-7, 1972-9, 1984-4, 1990-1, 1992-7, 2002-4, 2004-0, 2006-5, 1969-5, 1970-3, 1973-7, 1974-5, 1975-2, 1976-0, 1977-8, 1978-6, 1979-4, 1980-2, 1981-0, 1982-8, 1985-1, 1986-9, 1987-7, 1988-5, 1993-5, 1994-3, 1995-0, 1996-8, 1997-6, 1998-4, 1999-2, 2000-8, 2007-3, 2008-1, 2009-9, 2010-7, 2011-5, 2012-3, 2013-1, 2014-9, 2015-6, 2016-4, 2017-2, 2018-0, 2019-8, 2020-6, 2021-4, 2022-2, 2023-0, 2024-8, 2025-5, 2026-3, 2029-7, 2030-5, 2031-3, 2032-1, 2033-9, 2034-7, 2035-4, 2036-2, 2037-0, 2038-8, 2039-6, 2040-4, 2041-2, 2042-0, 2043-8, 2044-6, 2045-3, 2046-1, 2047-9, 2048-7, 2049-5, 2050-3, 2051-1, 2052-9, 2056-0, 2058-6, 2060-2, 2067-7, 2068-5, 2069-3, 2070-1, 2071-9, 2072-7, 2073-5, 2074-3, 2075-0, 2061-0, 2062-8, 2063-6, 2064-4, 2065-1, 2066-9, 2078-4, 2085-9, 2100-6, 2500-7, 2079-2, 2080-0, 2081-8, 2082-6, 2083-4, 2086-7, 2087-5, 2088-3, 2089-1, 2090-9, 2091-7, 2092-5, 2093-3, 2094-1, 2095-8, 2096-6, 2097-4, 2098-2, 2101-4, 2102-2, 2103-0, 2104-8, 2108-9, 2118-8, 2129-5, 2109-7, 2110-5, 2111-3, 2112-1, 2113-9, 2114-7, 2115-4, 2116-2, 2119-6, 2120-4, 2121-2, 2122-0, 2123-8, 2124-6, 2125-3, 2126-1, 2127-9, 2131-1) | 0 | unbounded | This element is for selecting 1 of the additional expansion codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-detailed-race.html |
| text | core:string | 1 | 1 | Use this element for adding a text description |
| us_core_ethnicity | – | 0 | 1 | – |
| omb_category_code | core:string (enum: 2135-2, 2186-5) | 0 | 1 | This element is for selecting 1 of the OMB ethnicity category codes that can be found here: http://hl7.org/fhir/us/core/ValueSet-omb-ethnicity-category.html |
| detailed_code | xs:string (enum: 2133-7, 2137-8, 2148-5, 2155-0, 2165-9, 2178-2, 2180-8, 2182-4, 2184-0, 2138-6, 2139-4, 2140-2, 2141-0, 2142-8, 2143-6, 2144-4, 2145-1, 2146-9, 2149-3, 2150-1, 2151-9, 2152-7, 2153-5, 2156-8, 2157-6, 2158-4, 2159-2, 2160-0, 2161-8, 2162-6, 2163-4, 2166-7, 2167-5, 2168-3, 2169-1, 2170-9, 2171-7, 2172-5, 2173-3, 2174-1, 2175-8, 2176-6) | 0 | unbounded | This element is for selecting 1 of the additional ethnicity codes from the CDC that can be found here: https://www.hl7.org/fhir/us/core/ValueSet-detailed-ethnicity.html |
| text | core:string | 1 | 1 | Use this element for adding a text description if the ethnicity is not listed within the enummeration |
| us_core_birth_sex | core:string (enum: M, F, UNK) | 0 | 1 | This element is used for selecting birth sex (M = Male, F = Female, UNK = Unknown) |


## Required Elements of EOB XSD

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| eob_list |  | 1..1 | – | – | – |
| schema_version | eob_list | 1..1 | This element defines what version of the EOB schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | eob_list | 1..1 | This element is used to the unique identifier assigned to your organization | – | core:string |
| date_time_reported | eob_list | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |
| eob | eob_list | 1..unbounded | – | – | – |


## All Elements of EOB XSD

| Name | Parent | Cardinality | Description | Examples | Data Type |
| --- | --- | --- | --- | --- | --- |
| eob_list |  | 1..1 | – | – | – |
| schema_version | eob_list | 1..1 | This element defines what version of the EOB schema you will be validating against (e.g. 1.0) | – | xs:decimal |
| sender_id | eob_list | 1..1 | This element is used to the unique identifier assigned to your organization | – | core:string |
| date_time_reported | eob_list | 1..1 | This element is used to the identify the date time this information was reported (e.g. 2001-10-26T21:32:52+02:00) | – | xs:dateTime |
| eob | eob_list | 1..unbounded | – | – | – |


## Practical Guidance

### Submission Frequency

EOB files should be submitted according to the schedule agreed upon with HealthLX. Typical submission frequencies include daily, weekly, or monthly updates.

### Adds, Updates, and Deletes

- **Adds**: Include new member records with all required fields populated
- **Updates**: Submit complete member records with updated information
- **Deletes**: Follow the agreed-upon process for member terminations or removals

### Member Identification

Each member must be uniquely identified using the appropriate identifier fields. Ensure consistency in member identifiers across all submissions to maintain data integrity.

