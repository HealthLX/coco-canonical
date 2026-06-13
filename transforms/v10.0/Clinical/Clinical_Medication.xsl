<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="Condition" select="/clinicals/clinical/conditions/condition"/>
    <xsl:variable name="Medication" select="clinicals/clinical/medication_requests/medication_request"/>
    <xsl:variable name="ORG" select="/clinicals/clinical/organizations/organization"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        
        <Medications>
            <xsl:for-each select="$Medication">
        <Medication xmlns="http://hl7.org/fhir">
            <id>
                <xsl:attribute name="value">
                    <!-- will need to check when we have good data-->
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
                <profile value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication"/>
                    
            </meta>
          
            <code>
                <xsl:if test="./medication/medication_code/system or ./medication/medication_code/code or ./medication/medication_code/version or ./medication/medication_code/display">
                    <coding>
                        <xsl:if test="./medication/medication_code/system">
                            <system>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./medication/medication_code/system"/>
                                </xsl:attribute>
                            </system>
                        </xsl:if>
                        <xsl:if test="./medication/medication_code/version">
                            <version>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./medication/medication_code/version"/>
                                </xsl:attribute>
                            </version>
                        </xsl:if>
                        <xsl:if test="./medication/medication_code/code">
                            <code>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./medication/medication_code/code"/>
                                </xsl:attribute>
                            </code>
                        </xsl:if>
                        <xsl:if test="./medication/medication_code/display">
                            <display>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./medication/medication_code/display"/>
                                </xsl:attribute>
                            </display>
                        </xsl:if>
                    </coding>
                </xsl:if>
                <xsl:if test="./medication/medication_code/text">
                    <text>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./medication/medication_code/text"/>
                        </xsl:attribute>
                    </text>
                </xsl:if>
            </code>
        </Medication>
            </xsl:for-each>
        </Medications>
    </xsl:template>
</xsl:stylesheet>
