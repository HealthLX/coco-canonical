<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://hl7.org/fhir"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <DocumentReferences xmlns="http://hl7.org/fhir">
            <xsl:for-each select="./clinicals/clinical/document_references/document_reference">
                <DocumentReference xmlns="http://hl7.org/fhir">
                    <id>
                        <xsl:attribute name="value">
                            <xsl:value-of
                                select="concat($CUSTOMER_PREFIX, '-', ./unique_identifier)"/>
                        </xsl:attribute>
                    </id>
                    <meta>
                        <source value="{$PARENTFILE_NAME}"/>
                        <profile
                            value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference"
                        />
                    </meta>
                    <status value="{status}"/>
                    <type>
                        <coding>
                            <xsl:if test="type/system">
                                <system value="{type/system}"/>
                            </xsl:if>
                            <xsl:if test="type/version">
                                <version value="{type/version}"/>
                            </xsl:if>
                            <xsl:if test="type/code">
                                <code value="{type/code}"/>
                            </xsl:if>
                            <xsl:if test="type/display">
                                <display value="{type/display}"/>
                            </xsl:if>
                        </coding>
                        <xsl:if test="type/text">
                            <text value="{type/text}"/>
                        </xsl:if>
                    </type>
                    <xsl:for-each select="./category">
                        <category>
                            <coding>
                                <xsl:if test="system">
                                    <system value="{system}"/>
                                </xsl:if>
                                <xsl:if test="version">
                                    <version value="{version}"/>
                                </xsl:if>
                                <xsl:if test="code">
                                    <code value="{code}"/>
                                </xsl:if>
                                <xsl:if test="display">
                                    <display value="{display}"/>
                                </xsl:if>
                            </coding>
                            <xsl:if test="text">
                                <text value="{text}"/>
                            </xsl:if>
                        </category>
                    </xsl:for-each>
                    <subject>
                        <reference>
                            <xsl:choose>
                                <xsl:when test="$PAT/reference">
                                    <xsl:variable name="inputString" select="$PAT/reference"/>
                                    <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                                    <xsl:variable name="parts_size" select="count($parts)"/>
                                    <xsl:attribute name="value">
                                        <xsl:choose>
                                            <xsl:when test="$parts_size > 1">
                                                <xsl:value-of
                                                  select="concat($parts[1], '/', $CUSTOMER_PREFIX, '-', $parts[2])"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                  select="concat('Patient/', $CUSTOMER_PREFIX, '-', $parts[1])"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="concat('Patient/', $CUSTOMER_PREFIX, '-', $PAT/unique_person_id)"
                                        />
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </reference>
                        <xsl:if test="$PAT/names/name[1]/text">
                            <display value="{$PAT/names/name[1]/text}"/>
                        </xsl:if>
                    </subject>
                    <xsl:if test="date">
                        <date value="{date}"/>
                    </xsl:if>
                    <xsl:apply-templates select="author"/>
                    <xsl:if test="custodian">
                        <custodian>
                            <reference type="organization">
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="concat($CUSTOMER_PREFIX, '-', organization/npi)"/>
                                </xsl:attribute>
                            </reference>
                        </custodian>
                    </xsl:if>
                    <xsl:for-each select="content">
                        <content>
                            <attachment>
                                <contentType value="{attachment/content_type}"/>
                                <xsl:if test="attachment/data">
                                    <data value="{attachment/data}"/>
                                </xsl:if>
                                <xsl:if test="attachment/url">
                                    <url value="{attachment/url}"/>
                                </xsl:if>
                            </attachment>
                            <xsl:if test="format/code or format/system">
                                <format>
                                    <xsl:if test="format/system"><system value="{format/system}"/></xsl:if>
                                    <xsl:if test="format/code"><code value="{format/code}"/></xsl:if>
                                </format>
                            </xsl:if>
                        </content>
                        <xsl:if test="context/encounter">
                            <context>
                                <encounter>
                                    <identifier>
                                        <value value="{context/encounter/identifier[1]}"/>
                                    </identifier>
                                </encounter>
                                <xsl:if test="context/period">
                                    <period>
                                        <xsl:if test="context/period/start"><start value="{context/period/start}"/></xsl:if>
                                        <xsl:if test="context/period/end"><end value="{context/period/end}"/></xsl:if>
                                    </period>
                                </xsl:if>
                            </context>
                        </xsl:if>
                    </xsl:for-each>
                </DocumentReference>
            </xsl:for-each>
        </DocumentReferences>
    </xsl:template>
    <xsl:template match="author">
        <author>
            <xsl:if test="patient">
                <reference type="patient">
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="concat($CUSTOMER_PREFIX, '-', patient/unique_person_id)"/>
                    </xsl:attribute>
                </reference>
            </xsl:if>
            <xsl:if test="practitioner">
                <reference type="practitioner">
                    <xsl:attribute name="value">
                        <xsl:value-of select="concat($CUSTOMER_PREFIX, '-', practitioner/npi)"/>
                    </xsl:attribute>
                </reference>
            </xsl:if>
            <xsl:if test="organization">
                <reference type="organization">
                    <xsl:attribute name="value">
                        <xsl:value-of select="concat($CUSTOMER_PREFIX, '-', organization/npi)"/>
                    </xsl:attribute>
                </reference>
            </xsl:if>
        </author>
    </xsl:template>
</xsl:stylesheet>
