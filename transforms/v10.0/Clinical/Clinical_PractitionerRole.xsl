<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://hl7.org/fhir"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <PractitionerRoles xmlns="http://hl7.org/fhir">
            <xsl:for-each select="./clinicals/clinical/practitioners_roles/practitioner_role">
                <PractitionerRole xmlns="http://hl7.org/fhir">
                    <id>
                        <xsl:attribute name="value">
                            <xsl:value-of select="concat($CUSTOMER_PREFIX, '-', ./unique_identifier)"/>
                        </xsl:attribute>
                    </id>
                    <meta>
                        <source value="{$PARENTFILE_NAME}"/>
                        <profile value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole"/>
                    </meta>
                    <practitioner>
                        <reference>
                            <xsl:attribute name="value">
                                <xsl:value-of  select="concat('Practitioner/', $CUSTOMER_PREFIX, '-', ./practitioner/npi)"/>
                            </xsl:attribute>
                        </reference>
                        <xsl:if test="./practitioner/names/name[1]/text">
                           <display>
                               <xsl:attribute name="value">
                                   <xsl:value-of select="./practitioner/names/name[1]/text"/>
                               </xsl:attribute>
                           </display>
                        </xsl:if>
                    </practitioner>
                    <organization>
                        <reference>
                            <xsl:attribute name="value">
                                <xsl:value-of  select="concat('Organization/', $CUSTOMER_PREFIX, '-', ./organization/npi)"/>
                            </xsl:attribute>
                        </reference>
                        <display>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./organization/name[1]"/>
                            </xsl:attribute>
                        </display>
                    </organization>
                    <xsl:for-each select="./code">
                        <code>
                            <coding>
                                <xsl:if test="./system">
                                    <system value="{./system}"/>
                                </xsl:if>
                                <xsl:if test="./version">
                                    <version value="{./version}"/>
                                </xsl:if>
                                <xsl:if test="./code">
                                    <code value="{./code}"/>
                                </xsl:if>
                                <xsl:if test="./display">
                                    <display value="{./display}"/>
                                </xsl:if>
                            </coding>
                            <xsl:if test="./text">
                                <text value="{./text}"/>
                            </xsl:if>
                        </code>
                    </xsl:for-each>
                    <xsl:for-each select="./specialty">
                        <specialty>
                            <coding>
                                <xsl:if test="./system">
                                    <system value="{./system}"/>
                                </xsl:if>
                                <xsl:if test="./version">
                                    <version value="{./version}"/>
                                </xsl:if>
                                <xsl:if test="./code">
                                    <code value="{./code}"/>
                                </xsl:if>
                                <xsl:if test="./display">
                                    <display value="{./display}"/>
                                </xsl:if>
                            </coding>
                            <xsl:if test="./text">
                                <text value="{./text}"/>
                            </xsl:if>
                        </specialty>
                    </xsl:for-each>
                    <xsl:if test="./location and ./location/identifier">
                        <location>
                            <identifier>
                                <value value="{./location[1]/identifier[1]/value}"/>
                            </identifier>
                        </location>
                    </xsl:if>
                    <xsl:for-each select="./telecom">
                        <telecom>
                            <xsl:if test="system"><system value="{system}"/></xsl:if>
                            <xsl:if test="value"><value value="{value}"/></xsl:if>
                            <xsl:if test="use"><use value="{use}"/></xsl:if>
                            <xsl:if test="rank"><rank value="{rank}"/></xsl:if>
                            <xsl:if test="period"><period>
                                <xsl:if test="period/start"><start value="{period/start}"/></xsl:if>
                                <xsl:if test="period/end"><end value="{period/end}"/></xsl:if>
                            </period></xsl:if>
                        </telecom>
                    </xsl:for-each>
                    <xsl:for-each select="./endpoints">
                        <endpoint>
                            <identifier>
                                <value value="{./identifier[1]/value}"/>
                            </identifier>
                            <xsl:if test="./name">
                                <display value="{./name}"/>
                            </xsl:if>
                        </endpoint>
                    </xsl:for-each>
                </PractitionerRole>
            </xsl:for-each>
        </PractitionerRoles>
    </xsl:template>
</xsl:stylesheet>
