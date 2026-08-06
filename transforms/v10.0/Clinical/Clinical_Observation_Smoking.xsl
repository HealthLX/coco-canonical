<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="Observation" select="/clinicals/clinical/smoking_status_observations/smoking_status_observation"/>
    <xsl:variable name="ORG" select="/clinicals/clinical/organizations/organization"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        <Observations>
            <xsl:for-each select="$Observation">
                <Observation xmlns="http://hl7.org/fhir">
                    <id>
                        <xsl:attribute name="value">
                            <xsl:value-of
                                select="concat($CUSTOMER_PREFIX, '-', ./unique_identifier)"/>
                        </xsl:attribute>
                    </id>
                    <meta>
                        <source>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$PARENTFILE_NAME"/>
                            </xsl:attribute>
                        </source>
                        <profile
                            value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus"
                        />
                    </meta>
                    <status>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./status"/>
                        </xsl:attribute>
                    </status>
                    <category>
                        <coding>
                            <system
                                value="http://terminology.hl7.org/CodeSystem/observation-category"/>
                            <code value="social-history"/>
                            <display value="Social History"/>
                        </coding>
                        <text value="Social History"/>
                    </category>
                    <code>
                        <coding>
                            <system>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./code/system"/>
                                </xsl:attribute>
                            </system>
                            <code>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./code/code"/>
                                </xsl:attribute>
                            </code>
                            <xsl:if test="./code/version">
                                <version>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./code/version"/>
                                    </xsl:attribute>
                                </version>
                            </xsl:if>
                            <xsl:if test="./code/display">
                                <display>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./code/display"/>
                                    </xsl:attribute>
                                </display>
                            </xsl:if>
                        </coding>
                        <xsl:if test="./code/text">
                            <text>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./code/text"/>
                                </xsl:attribute>
                            </text>
                        </xsl:if>
                    </code>
                    <subject>
                        <reference>
                            <xsl:choose>
                                <xsl:when test="$PAT/reference">
                                    <xsl:variable name="inputString" select="$PAT/reference"/>
                                    <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="concat($parts[1], '/', $CUSTOMER_PREFIX, '-', $parts[2])"
                                        />
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="concat('Patient/', $CUSTOMER_PREFIX, '-', $PAT/unique_person_id)"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </reference>
                        <xsl:if test="$PAT/names/name[1]/text">
                            <display value="{$PAT/names/name[1]/text}"/>
                        </xsl:if>
                    </subject>
                    <effectiveDateTime>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./issued"/>
                        </xsl:attribute>
                    </effectiveDateTime>
                    <issued>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./issued"/>
                        </xsl:attribute>
                    </issued>
                    <!-- <performer/> is must support but not existing in current data -->
                    <valueCodeableConcept>
                        <coding>
                            <xsl:if test="./value_codeable_concept/system">
                                <system>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./value_codeable_concept/system"/>
                                    </xsl:attribute>
                                </system>
                            </xsl:if>
                            <code>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./value_codeable_concept/code"/>
                                </xsl:attribute>
                            </code>
                            <xsl:if test="./value_codeable_concept/version">
                                <version>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./value_codeable_concept/version"/>
                                    </xsl:attribute>
                                </version>
                            </xsl:if>
                            <xsl:if test="./value_codeable_concept/display">
                                <display>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./value_codeable_concept/display"/>
                                    </xsl:attribute>
                                </display>
                            </xsl:if>
                        </coding>
                        <xsl:if test="./value_codeable_concept/text">
                            <text>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./value_codeable_concept/text"/>
                                </xsl:attribute>
                            </text>
                        </xsl:if>
                    </valueCodeableConcept>
                    <!-- <valueQuantity/> is must support but not existing in current data -->
                </Observation>
            </xsl:for-each>
        </Observations>
    </xsl:template>
</xsl:stylesheet>
