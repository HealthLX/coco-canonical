<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="Condition" select="clinicals/clinical/conditions/condition"/>
    <xsl:variable name="CareTeam" select="/clinicals/clinical/care_teams/care_team"/>
    <xsl:variable name="ORG" select="/clinicals/clinical/organizations/organization"/>
    <xsl:variable name="DxReportNote"
        select="clinicals/clinical/diagnostic_report_notes/diagnostic_report_note"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        <DiagnosticReports>

            <xsl:for-each select="$DxReportNote">
                <DiagnosticReport xmlns="http://hl7.org/fhir">
                    <id>
                        <xsl:attribute name="value">
                            <!-- example files have the type of lab work done here so this will likely need changed-->
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
                            value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-notes"
                        />
                    </meta>
                    
                    <contained>
                        <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                        <xsl:call-template name="Internal_participant_container"/>
                        
                    </contained>
                    
                    <status>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./status"/>
                        </xsl:attribute>
                    </status>
                    <!-- might want a for each category added but not in example-->
                    <xsl:for-each select="./category">
                        <category>
                            <coding>
                                <system>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./system"/>
                                    </xsl:attribute>
                                </system>
                                <code>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./code"/>
                                    </xsl:attribute>
                                </code>
                                <display>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./code"/>
                                    </xsl:attribute>
                                </display>
                            </coding>
                        </category>
                    </xsl:for-each>
                    <code>
                        <xsl:if test="./code/system or ./code/code or ./code/version or ./code/display">
                            <coding>
                                <xsl:if test="./code/system">
                                    <system>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./code/system"/>
                                        </xsl:attribute>
                                    </system>
                                </xsl:if>
                                <xsl:if test="./code/version">
                                    <version>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./code/version"/>
                                        </xsl:attribute>
                                    </version>
                                </xsl:if>
                                <xsl:if test="./code/code">
                                    <code>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./code/code"/>
                                        </xsl:attribute>
                                    </code>
                                </xsl:if>
                                <xsl:if test="./code/display">
                                    <display>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./code/display"/>
                                        </xsl:attribute>
                                    </display>
                                </xsl:if>
                            </coding>
                        </xsl:if>
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
                    </subject>
                    <effectiveDateTime>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./effective/effective_date_time"/>
                        </xsl:attribute>
                    </effectiveDateTime>
                    <issued>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./issued"/>
                        </xsl:attribute>
                    </issued>
                    <xsl:for-each select="./performer">
                        <performer>
                            
                            <xsl:choose>
                                <xsl:when test="./reported_practitioner">
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('#', ./reported_practitioner/names/name[1]/family,./member/practitioner/names/name[1]/given[1],'-','performerPractitionerDerived1')"
                                            />
                                        </xsl:attribute>
                                    </reference>
                                    <display>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="./reported_practitioner/names/name[1]/family"
                                            />
                                        </xsl:attribute>
                                    </display>
                                </xsl:when>
                                <!--  <xsl:otherwise>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('Organization/', ./reported_organization/name[1])"
                                            />
                                        </xsl:attribute>
                                    </reference>
                                    <display>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./reported_organization/name[1]"/>
                                        </xsl:attribute>
                                    </display>
                                </xsl:otherwise>-->
                            </xsl:choose>
                        </performer>
                    </xsl:for-each>
                    <!-- <xsl:for-each select="./result">
                        <result>
                            <reference>
                                <!-\- Might want observation_value but it's blank in source. -\->
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./observation_value"/>
                                </xsl:attribute>
                            </reference>
                            <display>
                                <!-\- Might want observation_value but it's blank in source. -\->
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./observation_value"/>
                                </xsl:attribute>
                            </display>
                        </result>
                    </xsl:for-each>-->
                    <xsl:for-each select="./presented_form">
                        <presentedForm>
                            <contentType>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="./content_type"
                                    />
                                </xsl:attribute>
                            </contentType>
                            <data>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./data"/>
                                </xsl:attribute>
                            </data>
                        </presentedForm>
                    </xsl:for-each>
                </DiagnosticReport>
                
            </xsl:for-each>
        </DiagnosticReports>
    </xsl:template>
    
    
    
    
    
    <xsl:template name="Internal_participant_container">
        
        <xsl:for-each select="./performer">
       
                    <Practitioner>
                        <!-- <xsl:call-template name="resource_meta"/> James:This node is not in sample output...-->
                        <id>
                            <xsl:attribute name="value">
                                <!--This should not be NPI... <id value="f007"/> This is the Id for a doctor. Other example are here: https://www.hl7.org/fhir/practitioner-examples.html -->
                                <xsl:value-of  select="concat( ./reported_practitioner/names/name[1]/family,./member/practitioner/names/name[1]/given[1],'-','performerPractitionerDerived1')"/>
                            </xsl:attribute>
                        </id>
                        <!-- 0..* Identifier An identifier for the person as this agent -->
                        
                        <!-- 0..1 Whether this practitioner's record is in active use <active> <xsl:attribute name="value"> <xsl:value-of select="/practitioner/is_active"/> </xsl:attribute> </active>-->
                        <!-- 0..* HumanName The name(s) associated with the practitioner -->
                        <xsl:for-each
                            select="./reported_practitioner/names/name">
                            <!-- 0..* HumanName The name(s) associated with the practitioner -->
                            <name>
                                <!-- 0..1 usual | official | temp | nickname | anonymous | old | maiden -->
                                <use value="official">
                                    <!-- <xsl:attribute name="value" value="official"/> <xsl:value-of select="use"/> Not in source. -->
                                </use>
                                <!-- 0..1 Text representation of the full name <text> <xsl:attribute name="value"> <xsl:value-of select="text"/> </xsl:attribute> </text>-->
                                <!-- 0..1 Family name (often called 'Surname') -->
                                <family>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./family"/>
                                    </xsl:attribute>
                                </family>
                                <!-- 0..* Given names (not always 'first'). Includes middle names -->
                                <xsl:for-each select="./given">
                                    <given>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="."/>
                                        </xsl:attribute>
                                    </given>
                                </xsl:for-each>
                                <!-- 0..* Parts that come before the name -->
                                <xsl:for-each select="./prefix">
                                    <prefix>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="."/>
                                        </xsl:attribute>
                                    </prefix>
                                </xsl:for-each>
                                <!-- 0..* Parts that come after the name -->
                                <xsl:for-each select="./suffix">
                                    <suffix>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="."/>
                                        </xsl:attribute>
                                    </suffix>
                                </xsl:for-each>
                                <!-- MAPPING NOT IMPLEMENTED: -->
                                <!-- 0..1 Period Time period when name was/is in use -->
                                <!-- <period> <xsl:call-template name="Practitioner_name_period"/> </period> -->
                            </name>
                        </xsl:for-each>
                    </Practitioner> 
          </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
