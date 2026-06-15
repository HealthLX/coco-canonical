<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="Condition" select="clinicals/clinical/conditions/condition"/>
    <xsl:variable name="CareTeam" select="/clinicals/clinical/care_teams/care_team"/>
    <xsl:variable name="ORG" select="/clinicals/clinical/organizations/organization"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:variable name="ENC" select="/clinicals/clinical/encounters/encounter/encounter_details/diagnoses/diagnosis/condition"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        <Conditions>
            <xsl:for-each select="$Condition">
                <Condition xmlns="http://hl7.org/fhir">
                    <id>
                        <!-- example has 'health-concern-example' and 'encounter-diagnosis-example1'-->
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
                            value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-problems-health-concerns"
                        />
                    </meta>


                    <extension url="http://hl7.org/fhir/StructureDefinition/condition-assertedDate">
                        <valueDateTime>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./recorded_date"/>
                            </xsl:attribute>
                        </valueDateTime>
                    </extension>
                    <clinicalStatus>
                        <coding>
                            <system value="http://terminology.hl7.org/CodeSystem/condition-clinical"/>
                            <code>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./clinical_status"/>
                                </xsl:attribute>
                            </code>
                            <!-- display is in one example as well as ../<text> but looks like all the same data<display>
                        <xsl:attribute name="value">
                            <xsl:value-of select="$Condition/clinical_status"/>
                        </xsl:attribute>
                    </display> -->
                        </coding>

                    </clinicalStatus>
                    <xsl:if test="./verification_status">
                        <verificationStatus>
                            <coding>
                                <system
                                    value="http://terminology.hl7.org/CodeSystem/condition-ver-status"/>
                                <code>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="verification_status"/>
                                    </xsl:attribute>
                                </code>
                                <!-- display is in one example as well as ../<text> but looks like all the same data<display>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$Condition/verification_status"/>
                            </xsl:attribute>
                        </display> -->
                            </coding>
                        </verificationStatus>
                    </xsl:if>
                    <!-- <xsl:for-each select="./category"> -->
                    <category>
                        <coding>
                            <xsl:choose>
                                <xsl:when test="./category[1]='problem-list-item'">
                                    <system value="http://terminology.hl7.org/CodeSystem/condition-category"/>
                                </xsl:when>
                                <xsl:when test="./category[1]='health-concern'">
                                    <system value="http://hl7.org/fhir/us/core/CodeSystem/condition-category"/>
                                </xsl:when>
                            </xsl:choose>
                            <code value="{./category[1]}"/>
                        </coding>
                    </category>
                    <xsl:if test="./category[2]">
                        <category>
                            <coding>
                                <system value="http://hl7.org/fhir/us/core/CodeSystem/us-core-category"/>
                                <code value="{./category[2]}"/>
                            </coding>
                        </category>
                    </xsl:if>
                    <!-- <category>
                        <coding>
                            <system value="http://terminology.hl7.org/CodeSystem/condition-category"/>
                            <code value="problem-list-item"/>
                            <display value="Problem List Item"/>
                        </coding>
                        <text value="Problem List Item"/>
                    </category> -->
                    <code>
                        <xsl:if test="./condition_code/system or ./condition_code/code or ./condition_code/version or ./condition_code/display">
                            <coding>
                                <xsl:if test="./condition_code/system">
                                    <system>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./condition_code/system"/>
                                        </xsl:attribute>
                                    </system>
                                </xsl:if>
                                <xsl:if test="./condition_code/version">
                                    <version>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./condition_code/version"/>
                                        </xsl:attribute>
                                    </version>
                                </xsl:if>
                                <xsl:if test="./condition_code/code">
                                    <code>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./condition_code/code"/>
                                        </xsl:attribute>
                                    </code>
                                </xsl:if>
                                <xsl:if test="./condition_code/display">
                                    <display>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./condition_code/display"/>
                                        </xsl:attribute>
                                    </display>
                                </xsl:if>
                            </coding>
                        </xsl:if>
                        <xsl:if test="./condition_code/text">
                            <text>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./condition_code/text"/>
                                </xsl:attribute>
                            </text>
                        </xsl:if>
                    </code>
                    <subject>
                        <reference>
                            <xsl:choose>
                                <xsl:when test="$PAT/reference">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="concat('Patient/',$CUSTOMER_PREFIX, '-', substring-after($PAT/reference,'/'))"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- Looks like it should be patient id -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="concat('Patient/',$CUSTOMER_PREFIX, '-', $PAT/unique_person_id)"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </reference>
                        <display>
                            <!-- looks like is should be patient full name -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="$PAT/names/name[1]/text"/>
                            </xsl:attribute>
                        </display>
                    </subject>

                    <onsetDateTime>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./onset/onset_period/start"/>
                        </xsl:attribute>
                    </onsetDateTime>

                    <recordedDate>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./recorded_date"/>
                        </xsl:attribute>
                    </recordedDate>
                </Condition>
            </xsl:for-each>
            <xsl:if test="$ENC"> 
                <xsl:call-template name="encounter_diagnosis"/>
            </xsl:if>
        </Conditions>
    </xsl:template>
    
    
    <xsl:template name="encounter_diagnosis">
        
        <xsl:for-each select="$ENC">
            <Condition xmlns="http://hl7.org/fhir">
                <id>
                    <!-- example has 'health-concern-example' and 'encounter-diagnosis-example1'-->
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
                        value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-encounter-diagnosis"
                    />
                </meta>
                
                
                <extension url="http://hl7.org/fhir/StructureDefinition/condition-assertedDate">
                    <valueDateTime>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./recorded_date"/>
                        </xsl:attribute>
                    </valueDateTime>
                </extension>
                <clinicalStatus>
                    <coding>
                        <system value="http://terminology.hl7.org/CodeSystem/condition-clinical"/>
                        <code>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./clinical_status"/>
                            </xsl:attribute>
                        </code>
                        <!-- display is in one example as well as ../<text> but looks like all the same data<display>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$Condition/clinical_status"/>
                            </xsl:attribute>
                        </display> -->
                    </coding>
                    
                </clinicalStatus>
                <xsl:if test="./verification_status">
                    <verificationStatus>
                        <coding>
                            <system
                                value="http://terminology.hl7.org/CodeSystem/condition-ver-status"/>
                            <code>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="verification_status"/>
                                </xsl:attribute>
                            </code>
                            <!-- display is in one example as well as ../<text> but looks like all the same data<display>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$Condition/verification_status"/>
                                </xsl:attribute>
                            </display> -->
                        </coding>
                    </verificationStatus>
                </xsl:if>
                <!-- <xsl:for-each select="./category"> -->
                <category>
                    <coding>
                        <system value="http://terminology.hl7.org/CodeSystem/condition-category"/>
                        <code value="problem-list-item"/>
                        <display value="Problem List Item"/>
                    </coding>
                </category>
                <!-- <category>
                            <coding>
                                <system>
                                    <xsl:choose>
                                        <xsl:when test="condition_code/system != '' ">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="condition_code/system"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">http://hl7.org/fhir/us/core/CodeSystem/condition-category</xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </system>
                                <code>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="condition_code/code"/>
                                    </xsl:attribute>
                                </code>
                                <display>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="condition_code/display"/>
                                    </xsl:attribute>
                                </display>
                            </coding>
                            <text>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="category"/>
                                </xsl:attribute>
                            </text>
                        </category> -->
                <!-- </xsl:for-each> -->
                
                <code>
                    <coding>
                        <system>
                            <xsl:choose>
                                <xsl:when test="condition_code/system != '' ">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="condition_code/system"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="value">http://snomed.info/sct</xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </system>
                        <!-- <version value="http://snomed.info/sct/731000124108"/> -->
                        <code>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./condition_code/code"/>
                            </xsl:attribute>
                        </code>
                        <!-- Closest thing in source -->
                        <!-- <display>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./condition_code/code"/>
                                    </xsl:attribute>
                                </display> -->
                    </coding>
                    <text>
                        <!-- Closest thing in source -->
                        <xsl:attribute name="value">
                            <xsl:value-of select="./condition_code/code"/>
                        </xsl:attribute>
                    </text>
                </code>
                <subject>
                    <reference>
                        <xsl:choose>
                            <xsl:when test="$PAT/reference">
                                <xsl:value-of select="concat('Patient/',$CUSTOMER_PREFIX, '-', substring-after($PAT/reference,'/'))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Looks like it should be patient id -->
                                <xsl:attribute name="value">
                                    <xsl:value-of select="concat('Patient/',$CUSTOMER_PREFIX, '-', $PAT/unique_person_id)"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                    </xsl:choose>
                    </reference>
                    <display>
                        <!-- looks like is should be patient full name -->
                        <xsl:attribute name="value">
                            <xsl:value-of select="$PAT/names/name[1]/text"/>
                        </xsl:attribute>
                    </display>
                </subject>
                
                <onsetDateTime>
                    <xsl:attribute name="value">
                        <xsl:value-of select="./onset/onset_period/start"/>
                    </xsl:attribute>
                </onsetDateTime>
                
                <recordedDate>
                    <xsl:attribute name="value">
                        <xsl:value-of select="./recorded_date"/>
                    </xsl:attribute>
                </recordedDate>
            </Condition>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
