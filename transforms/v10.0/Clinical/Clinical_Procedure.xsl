<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="Procedure" select="/clinicals/clinical/procedures/procedure"/>
    <xsl:variable name="MedicationRequest" select="/clinicals/clinical/medication_requests/medication_request"/>
    <xsl:variable name="ORG" select="/clinicals/clinical/organizations/organization"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        <Procedures>
            <xsl:for-each select="$Procedure">
                <Procedure xmlns="http://hl7.org/fhir">
                    <id>
                        <xsl:attribute name="value">
                            <!-- will need to check when we have good data-->
                            <xsl:value-of select="concat($CUSTOMER_PREFIX, '-',./unique_identifier)"/>
                        </xsl:attribute>
                    </id>
                    <meta>
                        <source>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$PARENTFILE_NAME"/>
                            </xsl:attribute>
                        </source>

                        <profile
                            value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure"
                        />
                    </meta>
                    <basedOn>
                        <reference>
                            <!-- not in source but is in both examples -->
                        </reference>
                    </basedOn>
                    <status>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./status"/>
                        </xsl:attribute>
                    </status>
                    <code>
                        <xsl:if test="./procedure_code/system or ./procedure_code/code or ./procedure_code/version or ./procedure_code/display">
                            <coding>
                                <xsl:if test="./procedure_code/system">
                                    <system>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./procedure_code/system"/>
                                        </xsl:attribute>
                                    </system>
                                </xsl:if>
                                <xsl:if test="./procedure_code/version">
                                    <version>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./procedure_code/version"/>
                                        </xsl:attribute>
                                    </version>
                                </xsl:if>
                                <xsl:if test="./procedure_code/code">
                                    <code>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./procedure_code/code"/>
                                        </xsl:attribute>
                                    </code>
                                </xsl:if>
                                <xsl:if test="./procedure_code/display">
                                    <display>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./procedure_code/display"/>
                                        </xsl:attribute>
                                    </display>
                                </xsl:if>
                            </coding>
                        </xsl:if>
                        <xsl:if test="./procedure_code/text">
                            <text>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./procedure_code/text"/>
                                </xsl:attribute>
                            </text>
                        </xsl:if>
                        <xsl:for-each select="./procedure_code/extension">
                            <extension>
                                <xsl:if test="id">
                                    <xsl:element name="id">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="id"/>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:attribute name="url"><xsl:value-of select="url"/></xsl:attribute>
                                <xsl:element name="valueCode">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="valueCode"/>
                                    </xsl:attribute>
                                </xsl:element>
                            </extension>
                        </xsl:for-each>
                    </code>
                    <subject>
                        <xsl:choose>
                            <xsl:when test="$PAT/reference">
                                <xsl:variable name="inputString" select="$PAT/reference" />
                                <xsl:variable name="parts" select="tokenize($inputString, '/')" />
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="concat($parts[1], '/', $CUSTOMER_PREFIX, '-', $parts[2])"/>
                                        </xsl:attribute>
                                    </reference>
                            </xsl:when>
                            <xsl:otherwise>
                                <reference>
                                    <!-- Looks like it should be patient id -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="concat('Patient/',$CUSTOMER_PREFIX, '-',$PAT/unique_person_id)"/>
                                    </xsl:attribute>
                                </reference>
                                <display>
                                    <!-- looks like is should be patient full name -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$PAT/names/name[1]/text"/>
                                    </xsl:attribute>
                                </display>
                            </xsl:otherwise>
                        </xsl:choose>
                    </subject>
                        <xsl:choose>
                            <xsl:when test="./performed/performed_date_time">
                                <performedDateTime>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./performed/performed_date_time"/>
                                    </xsl:attribute>
                                </performedDateTime>
                            </xsl:when>
                            <xsl:when test="./performed/performed_period/start">
                                <performedDateTime>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./performed/performed_period/start"/>
                                    </xsl:attribute>
                                </performedDateTime>
                            </xsl:when>
                        </xsl:choose>                    
                </Procedure>
            </xsl:for-each>
        </Procedures>
    </xsl:template>
</xsl:stylesheet>
