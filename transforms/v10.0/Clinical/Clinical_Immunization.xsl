<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="Immunization" select="/clinicals/clinical/immunizations/immunization"/>
    <xsl:variable name="ORG" select="/clinicals/clinical/organizations/organization"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        
        <Immunizations>
            <xsl:for-each select="$Immunization">
        <Immunization xmlns="http://hl7.org/fhir">
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
                <profile value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-immunization"/>
                    
            </meta>
          <status>
              <xsl:attribute name="value">
                  <xsl:value-of select="./status"/>
              </xsl:attribute>
          </status>
            <vaccineCode>
                <xsl:if test="./vaccine_code/system or ./vaccine_code/code or ./vaccine_code/version or ./vaccine_code/display">
                    <coding>
                        <xsl:if test="./vaccine_code/system">
                            <system>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./vaccine_code/system"/>
                                </xsl:attribute>
                            </system>
                        </xsl:if>
                        <xsl:if test="./vaccine_code/version">
                            <version>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./vaccine_code/version"/>
                                </xsl:attribute>
                            </version>
                        </xsl:if>
                        <xsl:if test="./vaccine_code/code">
                            <code>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./vaccine_code/code"/>
                                </xsl:attribute>
                            </code>
                        </xsl:if>
                        <xsl:if test="./vaccine_code/display">
                            <display>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./vaccine_code/display"/>
                                </xsl:attribute>
                            </display>
                        </xsl:if>
                    </coding>
                </xsl:if>
                <xsl:if test="./vaccine_code/text">
                    <text>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./vaccine_code/text"/>
                        </xsl:attribute>
                    </text>
                </xsl:if>
            </vaccineCode>
            <patient>
                <reference>
                    <xsl:attribute name="value">
                        <xsl:value-of select="concat('Patient/',$CUSTOMER_PREFIX,'-',$PAT/member_id)"/>
                    </xsl:attribute>
                </reference>
            </patient>
            
                
            <xsl:choose>
                
                <xsl:when test="empty(./occurrence/occurrence_date_time)">
                     <occurrenceString>
                        <xsl:attribute name="value">
                            <xsl:value-of select="'unknown'"/>
                        </xsl:attribute>
                     </occurrenceString>
                </xsl:when>
                <xsl:otherwise>
                    <occurrenceDateTime>
                        <xsl:attribute name="value">
                            <xsl:choose>
                                <xsl:when test="matches(., '^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$')">
                                    <xsl:value-of select="concat(./occurrence/occurrence_date_time, 'T00:00:00Z')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="format-dateTime(./occurrence/occurrence_date_time, '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s02].000Z')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </occurrenceDateTime>
                </xsl:otherwise>
            </xsl:choose>
                
            
        </Immunization>
            </xsl:for-each>
        </Immunizations>
    </xsl:template>
</xsl:stylesheet>
