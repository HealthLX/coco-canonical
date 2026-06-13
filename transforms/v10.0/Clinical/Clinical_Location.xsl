<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="LOC" select="clinicals/clinical/locations/location"/>
    <xsl:variable name="LOC_PRACTROLE" select="/clinicals/clinical/practitioners_roles/practitioner_role"/>
    <xsl:variable name="ORG" select="clinicals/clinical/organizations/organization"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        <Locations>
            <xsl:for-each select="$LOC | $LOC_PRACTROLE">
                <Location xmlns="http://hl7.org/fhir">
                    <!-- from Resource: id, meta, implicitRules, and language -->
                    <!-- from DomainResource: text, contained, extension, and modifierExtension -->
                    <id>
                        <!-- Sample has 'hospital' so we should try and find a type for id -->
                        <xsl:attribute name="value">
                            <xsl:choose>
                                <xsl:when test="./location">
                                    <xsl:value-of select="concat($CUSTOMER_PREFIX, '-', ./unique_identifier), '-', ./location[1]/identifier[1]/value"/>                                    
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat($CUSTOMER_PREFIX, '-', ./unique_identifier)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </id>
                    <meta>
                        <source>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$PARENTFILE_NAME"/>
                            </xsl:attribute>
                        </source>

                    </meta>
                    <!-- Not in sample file <identifier> 0..* Identifier Unique code or number identifying the location to its users <xsl:attribute name="value"> <xsl:value-of select="concat($EOB_CLIA,$EOB_USE,$EOB_TYPE)"/> </xsl:attribute> </identifier>-->
                    <xsl:for-each select="./identifier | ./location/identifier">
                        <identifier>
                            <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                            <system>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="concat('https://data.healthlx.com/', '_', ./type)"/>
                                </xsl:attribute>
                            </system>
                            <value>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./value"/>
                                </xsl:attribute>
                            </value>
                        </identifier>
                    </xsl:for-each>

                    <status>
                        <!-- 0..1 active | suspended | inactive -->
                        <xsl:choose>
                            <xsl:when test="./location_details/status = 'active'">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="'active'"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when test="./location/status = 'active'">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="'active'"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="'inactive'"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </status>
                    <!-- Not in sample output <operationalStatus> 0..1 Coding The operational status of the location (typically only for a bed/room) </operationalStatus>-->
                    <name>
                        <!-- 0..1 Name of the location as used by humans -->
                        <xsl:attribute name="value">
                            <xsl:value-of select="./location_details/name | ./location/name"/>
                        </xsl:attribute>
                    </name>
                    <!-- Not in sample document <alia></alia> 0..* A list of alternate names that the location is known as, or was known as, in the past -->
                    <!-- In one of two sample docs. Not sure if it's source doc till we have data <description> 0..1 Additional details about the location that could be displayed as further information to identify the location beyond its name </description> -->
                    <!-- Not in sample document. <mode> 0..1 instance | kind </mode> -->
                    <!-- Not in sample document. <type> 0..* CodeableConcept Type of function performed </type> -->
                    <!-- 0..* ContactPoint Contact details of the location -->
                    <xsl:for-each select="./location_details/telecoms/telecom | ./location/telecoms/telecom">
                        <telecom>
                            <!-- Nothing in source. Sample output doc only has system, value and use -->
                            <!-- ?? 0..1 phone | fax | email | pager | url | sms | other -->
                            <system>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./system"/>
                                </xsl:attribute>
                            </system>
                            <!-- 0..1 The actual contact point details -->
                            <value>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./value"/>
                                </xsl:attribute>
                            </value>
                            <xsl:if test="./use">
                                <!-- 0..1 home | work | temp | old | mobile - purpose of this contact point -->
                                <use>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./use"/>
                                    </xsl:attribute>
                                </use>
                            </xsl:if>
                            <xsl:if test="rank">
                                <rank>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="rank"/>
                                    </xsl:attribute>
                                </rank>
                            </xsl:if>
                            <xsl:if test="period/start | period/end">
                                <period>
                                    <xsl:if test="period/start">
                                        <start>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="period/start"/>
                                            </xsl:attribute>
                                        </start>
                                    </xsl:if>
                                    <xsl:if test="period/end">
                                        <end>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="period/end"/>
                                            </xsl:attribute>
                                        </end>
                                    </xsl:if>
                                </period>
                            </xsl:if>
                        </telecom>
                    </xsl:for-each>
                    <address>
                        <!-- Not in sample document <use> <xsl:attribute name="value"> <xsl:value-of select="$LOC/location_details/use"/> </xsl:attribute> </use> -->
                        <line>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./location_details/address/line[1] | ./location/address/line[1]"/>
                            </xsl:attribute>
                        </line>
                        <city>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./location_details/address/city | ./location/address/city"/>
                            </xsl:attribute>
                        </city>
                        <!-- Not in sample document <district> <xsl:attribute name="value"> <xsl:value-of select="$POG_PROVIDER_LOCATIONS/district"/> </xsl:attribute> </district> -->
                        <state>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./location_details/address/state | ./location/address/state"/>
                            </xsl:attribute>
                        </state>
                        <postalCode>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./location_details/address/postal_code | ./location/address/postal_code"/>
                            </xsl:attribute>
                        </postalCode>
                        <country>
                            <xsl:value-of select="./location_details/address/country | ./location/address/country"/>
                        </country>
                    </address>
                    <!-- <physicalType><!-\- 0..1 CodeableConcept Physical form of the location -\-> <coding> <system value="http://terminology.hl7.org/CodeSystem/claim-type"/> <code> <xsl:attribute name="value"> <xsl:value-of select="$EOB_DEMOGRAPHIC/type"/> </xsl:attribute> </code> </coding> </physicalType>-->
                    <!-- In one of two sample docs but I didn't see it in the source file<position> <!-\- 0..1 The absolute geographic location -\-> <longitude value="[decimal]"/><!-\- 1..1 Longitude with WGS84 datum -\-> <latitude value="[decimal]"/><!-\- 1..1 Latitude with WGS84 datum -\-> <altitude value="[decimal]"/><!-\- 0..1 Altitude with WGS84 datum -\-> </position>-->

                    <managingOrganization>
                        <!-- 0..1 Reference(Organization) Organization responsible for provisioning and upkeep -->
                        <!-- 1..1 Reference(Patient) The recipient of the products and services -->
                        <reference>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="concat('Organization/', '#local', ./location_details/managing_organization/name[1] | ./location/managing_organization/name[1])"
                                />
                            </xsl:attribute>
                        </reference>
                        <display>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="./location_details/managing_organization/name[1] | ./location/managing_organization/name[1]"/>

                            </xsl:attribute>
                        </display>
                    </managingOrganization>
                </Location>
            </xsl:for-each>
        </Locations>
    </xsl:template>

    <xsl:template name="pog_meta_security_organization">

        <meta>
            <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
            <source>
                <xsl:attribute name="value">
                    <xsl:value-of select="$PARENTFILE_NAME"/>
                </xsl:attribute>
            </source>

        </meta>
    </xsl:template>
</xsl:stylesheet>
