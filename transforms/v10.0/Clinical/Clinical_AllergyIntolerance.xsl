<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="LAB" select="clinicals/clinical/allergy_intolerances/allergy_intolerance"/>
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="Condition" select="clinicals/clinical/conditions/condition"/>
    <xsl:variable name="CareTeam" select="/clinicals/clinical/care_teams/care_team"/>
    <xsl:variable name="ORG" select="/clinicals/clinical/organizations/organization"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        
        <AllergyIntolerances>
            
            <xsl:for-each select="$LAB">
                <AllergyIntolerance xmlns="http://hl7.org/fhir">
                    <id>
                        <!-- Sample has 'example' so we should try and find a thing for id -->
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
                            value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance"/>

                    </meta>

                    <clinicalStatus>
                        <coding>
                            <system
                                value="http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical"/>
                            <code>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./clinical_status"/>
                                </xsl:attribute>
                            </code>
                        </coding>
                    </clinicalStatus>
                    <verificationStatus>
                        <coding>
                            <system
                                value="http://terminology.hl7.org/CodeSystem/allergyintolerance-verification"/>
                            <code>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./verification_status"/>
                                </xsl:attribute>
                            </code>
                        </coding>
                    </verificationStatus>
                    <xsl:for-each select="./category">
                        <category>
                            <xsl:attribute name="value">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                        </category>
                    </xsl:for-each>
                    <criticality>
                        <xsl:choose>
                            <xsl:when test="empty(./criticality)">
                                
                                <xsl:attribute name="value">
                                    <xsl:value-of select="'unable-to-assess'"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./criticality"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </criticality>
                    <text>
                        <xsl:attribute name="value">
                            <xsl:value-of select="empty(./allergy_code/code/text())"/>
                        </xsl:attribute>
                    </text>             
                    <code>
                            <xsl:choose>
                                <xsl:when test="empty(./allergy_code/code/text())">
                                    <text>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./allergy_code/text"/>
                                        </xsl:attribute>
                                    </text>                    
                                </xsl:when>
                                <xsl:otherwise>
                                    <coding>
                                         <system value="http://snomed.info/sct"/>
                                         <version value="http://snomed.info/sct/731000124108"/>
                                         <code>
                                             <xsl:attribute name="value">
                                                 <xsl:value-of select="./allergy_code/code"/>
                                             </xsl:attribute>
                                         </code> 
                                    </coding>
                                </xsl:otherwise>
                            </xsl:choose>
                            <display>
                                <!-- example has 'Product containing sulfonamide (product)' Not found in source. -->
                            </display>
                    </code>
                    <patient>
                        <reference>
                            <!-- Looks like it should be patient id -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="concat('Patient/',$CUSTOMER_PREFIX, '-', $PAT/unique_person_id)"/>
                            </xsl:attribute>
                        </reference>
                        <display>
                            <!-- looks like is should be patient full name -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="$PAT/names/name[1]/text"/>
                            </xsl:attribute>
                        </display>
                    </patient>
                    <xsl:for-each select="./reactions/reaction">
                        <reaction>
                            <xsl:for-each select="./manifestation">
                                <manifestation>
                                <xsl:choose>
                                    <xsl:when test="lower-case(./manifestation) = 'none' or lower-case(./mainfestation) = 'unknown' or empty(./mnifestation/text())">
                                        <coding>
                                          <system value="http://snomed.info/sct"/>
                                          <version value="http://snomed.info/sct/731000124108"/>
                                            <code value="3219008"/>
                                          <display value = "Disease type AND/OR category unknown"/>
                                        </coding>
                                        <text value="None"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        
                                            <coding>
                                                <system value="http://snomed.info/sct"/>
                                                <version value="http://snomed.info/sct/731000124108"/>
                                                <code>
                                                    <!--    <xsl:attribute name="value">
                                <xsl:value-of select="./manifestation"/>
                            </xsl:attribute>-->
                                                </code>
                                                <display>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="."/>
                                                    </xsl:attribute>
                                                </display>
                                            </coding>
                                            <text>
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="."/>
                                                </xsl:attribute>
                                            </text>
                                        
                                    </xsl:otherwise>
                                </xsl:choose>
                                </manifestation>
                            </xsl:for-each>
                            <severity>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./criticality"/>
                                </xsl:attribute>
                            </severity>
                        </reaction>
                    </xsl:for-each>
                </AllergyIntolerance>
            </xsl:for-each>
        </AllergyIntolerances>
    </xsl:template>


</xsl:stylesheet>
