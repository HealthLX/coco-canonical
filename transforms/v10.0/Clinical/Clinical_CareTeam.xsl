<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="CareTeam" select="/clinicals/clinical/care_teams/care_team"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        
        <CareTeams>
            <xsl:for-each select="$CareTeam">
                <CareTeam xmlns="http://hl7.org/fhir">
                    <id>
                        <!-- example has 'example' will need to verify id -->
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
                            value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-careteam"/>
                        
                        
                    </meta>
                    <xsl:if test="./participant/member/patient or ./participant/member/practitioner or ./participant/member/organization">
                        <contained>
                            <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                            <xsl:call-template name="Internal_participant_container"/>                            
                        </contained>
                    </xsl:if>
                    

                    <status>
                        <xsl:attribute name="value">
                            <!-- example has 'active' but still should be the spot. source has 'proposed'. Might want record_type? -->
                            <xsl:value-of select="./status"/>
                        </xsl:attribute>
                    </status>
                    
                    <!-- both examples have 'US-Core example CareTeam'. What name? Patient, doctor or org?-->
                    <!-- <name>
                        <xsl:attribute name="value">
                            <xsl:choose>
                                <xsl:when test="$PAT/reference">
                                    <xsl:variable name="inputString" select="$PAT/reference" />
                                    <xsl:variable name="parts" select="tokenize($inputString, '/')" />
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="concat($CUSTOMER_PREFIX, '-', $parts[2])"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat($CUSTOMER_PREFIX, '-', $PAT/unique_person_id)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </name> -->
                    <subject>
                            <xsl:choose>
                                <xsl:when test="$PAT/reference">
                                    <xsl:variable name="inputString" select="$PAT/reference" />
                                    <xsl:variable name="parts" select="tokenize($inputString, '/')" />
                                    <xsl:attribute name="value">
                                        <reference>
                                            <xsl:value-of select="concat($parts[1], '/', $CUSTOMER_PREFIX, '-', $parts[2])"/>
                                        </reference>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
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
                                </xsl:otherwise>
                            </xsl:choose>
                    </subject>
                    <xsl:for-each select="./participant">
                        <participant>
                            <xsl:for-each select="./role">
                                <role>
                                    <coding>
                                        <!-- if code is not provided, code and display should be 'unknown' and  system should be 'http://terminology.hl7.org/CodeSystem/data-absent-reason' version doesn't need sent as well-->
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'http://snomed.info/sct'"/>
                                            </xsl:attribute>
                                        </system>
                                        <version>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                  select="'http://snomed.info/sct/731000124108'"/>
                                            </xsl:attribute>
                                        </version>
                                        <code>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./code"/>
                                            </xsl:attribute>
                                        </code>

                                    </coding>
                                </role>
                            </xsl:for-each>
                            <member>
                                <xsl:choose>
                                    <!-- source sample has mixed nodes with multiple loops and this isn't working 100% of the time -->
                                    <xsl:when test="./member/patient">
                                        <reference>
                                            <xsl:attribute name="value">
                                                <!-- Looks like it should be patient id -->
                                                <xsl:attribute name="value">
                                                  <xsl:value-of
                                                      select="concat('#',./member/patient/names/name[1]/family, ./member/patient/names/name[1]/given[1],'-','participantPatientDerived1')"
                                                  />
                                                </xsl:attribute>
                                            </xsl:attribute>
                                        </reference>


                                        <display>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat( ./member/patient/names/name[1]/family, ./member/patient/names/name[1]/given[1])"/>
                                            </xsl:attribute>
                                        </display>
                                    </xsl:when>
                                    <xsl:when test="./member/organization">
                                        <reference>
                                            <xsl:attribute name="value">
                                                <!-- Looks like it should be patient id -->
                                                <xsl:attribute name="value">
                                                  <xsl:value-of
                                                      select="concat('#', ./member/organization/name[1],'-','participantOrganizationDerived',position())"
                                                  />
                                                </xsl:attribute>
                                            </xsl:attribute>
                                        </reference>
                                        <display>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./member/organization/name[1]"
                                                />
                                            </xsl:attribute>
                                        </display>
                                    </xsl:when>
                                    <xsl:when test="./member/practitioner">
                                        <reference>
                                                <!-- Looks like it should be patient id -->
                                                <xsl:attribute name="value">
                                                  <xsl:value-of
                                                      select="concat('Practitioner/', ./member/practitioner/names/name[1]/family, ./member/practitioner/names/name[1]/given[1],'-','participantPractitionerDerived1')"
                                                  />
                                                </xsl:attribute>
                                        </reference>
                                        <display>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat(./member/practitioner/names/name[1]/family, ' ', ./member/practitioner/names/name[1]/given[1])"
                                                />
                                            </xsl:attribute>
                                        </display>
                                    </xsl:when>
                                    <xsl:when test="exists(./member/related_person)">
                                        
                                            <identifier>
                                                <xsl:attribute name="value">
                                                    <xsl:value-of
                                                        select="./unique_identifier"
                                                    />
                                                </xsl:attribute>
                                            </identifier>
                                        <xsl:if test="exists(./member/related_person/names)">
                                            <xsl:for-each select="./member/related_person/names/name">
                                                <names>
                                                    <name>
                                                        <family>
                                                            <xsl:attribute name="value">
                                                                <xsl:value-of
                                                                    select="./family"/>
                                                            </xsl:attribute>
                                                        </family>
                                                        <given>
                                                            <xsl:attribute name="value">
                                                                <xsl:value-of
                                                                    select="./given"/>
                                                            </xsl:attribute>
                                                        </given>
                                                        <!-- 0..1 usual | official | temp | nickname | anonymous | old | maiden -->
                                                        <xsl:if test="use">
                                                            <xsl:element name="use">
                                                                <xsl:attribute name="value">
                                                                    <xsl:value-of select="use"/>
                                                                </xsl:attribute>
                                                            </xsl:element>
                                                        </xsl:if>
                                                        <!-- 0..1 Text representation of the full name -->
                                                        <xsl:if test="text">
                                                            <xsl:element name="text">
                                                                <xsl:attribute name="value">
                                                                    <xsl:value-of select="text"/>
                                                                </xsl:attribute>
                                                            </xsl:element>
                                                        </xsl:if>
                                                        <!-- 0..1 Family name (often called 'Surname') -->
                                                        <family>
                                                            <xsl:attribute name="value">
                                                                <xsl:value-of select="./family"/>
                                                            </xsl:attribute>
                                                        </family>
                                                        <!-- 0..* Given names (not always 'first'). Includes middle names -->
                                                        <given>
                                                            <xsl:attribute name="value">
                                                                <xsl:value-of select="./given"/>
                                                            </xsl:attribute>
                                                        </given>
                                                        <!-- 0..* Parts that come before the name -->
                                                        <xsl:if test="prefix">
                                                            <xsl:element name="prefix">
                                                                <xsl:attribute name="value">
                                                                    <xsl:value-of select="prefix"/>
                                                                </xsl:attribute>
                                                            </xsl:element>
                                                        </xsl:if>
                                                        <!-- 0..* Parts that come after the name -->
                                                        <xsl:if test="suffix">
                                                            <xsl:element name="suffix">
                                                                <xsl:attribute name="value">
                                                                    <xsl:value-of select="suffix"/>
                                                                </xsl:attribute>
                                                            </xsl:element>
                                                        </xsl:if>
                                                    </name>
                                                </names>
                                            </xsl:for-each>
                                        </xsl:if>
                                        <xsl:if test="exists(./member/related_person/telecoms)">
                                            <telecoms>
                                                <xsl:for-each select="./member/related_person/telecoms/telecom">
                                                    <telecom>
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
                                                        <!-- 0..1 home | work | temp | old | mobile - purpose of this contact point -->
                                                        <use>
                                                            <xsl:attribute name="value">
                                                                <xsl:value-of select="./use"/>
                                                            </xsl:attribute>
                                                        </use>
                                                        <!-- 0..1 Specify preferred order of use (1 = highest) -->
                                                        <rank>
                                                            <xsl:attribute name="value">
                                                                <xsl:value-of select="position()"/>
                                                            </xsl:attribute>
                                                        </rank>
                                                        <!-- 0..1 Period Time period when the contact point was/is in use -->
                                                        <xsl:if test="period">
                                                            <xsl:element name="period">
                                                                <xsl:if test="period/start">
                                                                    <xsl:element name="start">
                                                                        <xsl:attribute name="value">
                                                                            <xsl:value-of select="period/start"/>
                                                                        </xsl:attribute>
                                                                    </xsl:element>
                                                                </xsl:if>
                                                                <xsl:if test="period/end">
                                                                    <xsl:element name="end">
                                                                        <xsl:attribute name="value">
                                                                            <xsl:value-of select="period/end"/>
                                                                        </xsl:attribute>
                                                                    </xsl:element>
                                                                </xsl:if>
                                                            </xsl:element>
                                                        </xsl:if>
                                                    </telecom>
                                                </xsl:for-each>
                                            </telecoms>
                                        </xsl:if>
                                        <xsl:if test="exists(./member/related_person/addresses)">
                                            <addresses>
                                                <xsl:for-each select="./member/related_person/addresses/address">
                                                    <address>
                                                        <!-- 0..1 home | work | temp | old | billing - purpose of this address -->
                                                        <!-- <use>
    					<xsl:attribute name="value">
    						<xsl:value-of select="lower-case(address_use)"/>
    					</xsl:attribute>
    				</use> -->
                                                        <!-- 0..1 postal | physical | both -->
                                                        <xsl:if test="./type">
                                                            <type>
                                                                <xsl:attribute name="value">
                                                                    <xsl:value-of select="./type"/>
                                                                </xsl:attribute>
                                                            </type>
                                                        </xsl:if>
                                                        <!-- 0..1 Text representation of the address -->
                                                        <!-- 
    				<text>
    					<xsl:attribute name="value">
    						<xsl:value-of select=""/>
    					</xsl:attribute>
    				</text>
    				 -->
                                                        <!-- 0..* Street name, number, direction & P.O. Box etc. -->
                                                        <xsl:for-each select="./line">
                                                            <line>
                                                                <xsl:attribute name="value">
                                                                    <xsl:value-of select="."/>
                                                                </xsl:attribute>
                                                            </line>
                                                        </xsl:for-each>
                                                        <!-- 0..1 Name of city, town etc. -->
                                                        <xsl:if test="./city">
                                                            <city>
                                                                <xsl:attribute name="value">
                                                                    <xsl:value-of select="./city"/>
                                                                </xsl:attribute>
                                                            </city>
                                                        </xsl:if>
                                                        <!-- 0..1 District name (aka county) -->
                                                        <xsl:if test="./district">
                                                            <district>
                                                                <xsl:attribute name="value">
                                                                    <xsl:value-of select="./district"/>
                                                                </xsl:attribute>
                                                            </district>
                                                        </xsl:if>
                                                        <!-- 0..1 Sub-unit of country (abbreviations ok) -->
                                                        <xsl:if test="./state">
                                                            <state>
                                                                <xsl:attribute name="value">
                                                                    <xsl:value-of select="./state"/>
                                                                </xsl:attribute>
                                                            </state>
                                                        </xsl:if>
                                                        <!-- 0..1 Postal code for area -->
                                                        <xsl:if test="./postal_code">
                                                            <postalCode>
                                                                <xsl:attribute name="value">
                                                                    <xsl:value-of select="./postal_code"/>
                                                                </xsl:attribute>
                                                            </postalCode>
                                                        </xsl:if>
                                                        <!-- 0..1 Country (e.g. can be ISO 3166 2 or 3 letter code) -->
                                                        <country>
                                                            <xsl:choose>
                                                                <xsl:when test="./country">
                                                                    <xsl:attribute name="value">
                                                                        <xsl:value-of select="./country"/>
                                                                    </xsl:attribute>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:attribute name="value">USA</xsl:attribute>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                        </country>
                                                        <!-- 0..1 Period Time period when address was/is in use -->
                                                        <xsl:if test="period">
                                                            <xsl:element name="period">
                                                                <xsl:if test="period/start">
                                                                    <xsl:element name="start">
                                                                        <xsl:attribute name="value">
                                                                            <xsl:value-of select="period/start"/>
                                                                        </xsl:attribute>
                                                                    </xsl:element>
                                                                </xsl:if>
                                                                <xsl:if test="period/end">
                                                                    <xsl:element name="end">
                                                                        <xsl:attribute name="value">
                                                                            <xsl:value-of select="period/end"/>
                                                                        </xsl:attribute>
                                                                    </xsl:element>
                                                                </xsl:if>
                                                            </xsl:element>
                                                        </xsl:if>
                                                    </address>
                                                </xsl:for-each>
                                            </addresses>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:when test="./member/reference">
                                        <reference>
                                            <xsl:variable name="inputString" select="./member/reference" />
                                            <xsl:variable name="parts" select="tokenize($inputString, '/')" />
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="concat($parts[1], '/', $CUSTOMER_PREFIX, '-', $parts[2])"/>
                                            </xsl:attribute>
                                        </reference>
                                    </xsl:when>
                                </xsl:choose>

                            </member>

                        </participant>
                    </xsl:for-each>
                </CareTeam>
            </xsl:for-each>
        </CareTeams>

    </xsl:template>
    <xsl:template name="Internal_participant_container">
        <xsl:for-each select="./participant">
            <xsl:choose>
                <xsl:when test="./member/patient">
                    <Patient>
                        <meta>
                            <profile value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"/>
                        </meta>
                        <id>
                            <xsl:attribute name="value">
                                <xsl:value-of select="concat(./member/patient/names/name[1]/family, ./member/patient/names/name[1]/given[1],'-','participantPatientDerived1' )"/>
                            </xsl:attribute>
                        </id>
                        <!-- <name>
                            
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="concat(./member/patient/names/name[1]/family,' ', ./member/patient/names/name[1]/given[1] )"/>
                            </xsl:attribute>
                            
                        </name>-->
                       
                        <xsl:for-each select="./member/patient/names/name">
                                <name>
                                    <family>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./family"/>
                                        </xsl:attribute>
                                    </family>
                                    <given>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./given[1]"/>
                                        </xsl:attribute>
                                    </given>
                                </name>
                            </xsl:for-each>
                        
                            
                        
                            <gender>
                                <xsl:attribute name="value">
                                    <xsl:choose>
                                        <xsl:when test="starts-with(./member/patient/gender, 'm')">male</xsl:when>
                                        <xsl:when test="starts-with(./member/patient/gender, 'f')">female</xsl:when>
                                        <xsl:otherwise>unknown</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                            </gender>
                            <active value="true"/>
                            
                            <xsl:call-template name="ptt_address"/>
                     </Patient>
                    
                </xsl:when>
                <xsl:when test="./member/practitioner">
                    <Practitioner>
                        <!-- <xsl:call-template name="resource_meta"/> James:This node is not in sample output...-->
                        <id>
                            <xsl:attribute name="value">
                                <!--This should not be NPI... <id value="f007"/> This is the Id for a doctor. Other example are here: https://www.hl7.org/fhir/practitioner-examples.html -->
                                <xsl:value-of  select="concat( ./member/practitioner/names/name[1]/family,./member/practitioner/names/name[1]/given[1],'-','participantPractitionerDerived1')"/>
                            </xsl:attribute>
                        </id>
                        <!-- 0..* Identifier An identifier for the person as this agent -->
                        
                        <!-- 0..1 Whether this practitioner's record is in active use <active> <xsl:attribute name="value"> <xsl:value-of select="/practitioner/is_active"/> </xsl:attribute> </active>-->
                        <!-- 0..* HumanName The name(s) associated with the practitioner -->
                        <xsl:for-each
                            select="./member/practitioner/names/name">
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
                </xsl:when>
                <xsl:when test="./member/organization">
                    <Organization>
                        <id>
                            <xsl:attribute name="value">
                                <xsl:value-of select="concat(./member/organization/name[1],'-','participantOrganizationDerived1' )"/>
                            </xsl:attribute>
                        </id>
                        <active>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./member/organization/is_active"/>
                            </xsl:attribute>
                        </active>
                        <name>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./member/organization/name[1]"/>
                            </xsl:attribute>
                        </name>
                    </Organization>
                </xsl:when>                
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="Practitioner_name">
        <xsl:for-each
            select="./names/name">
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
                        <xsl:value-of select="family"/>
                    </xsl:attribute>
                </family>
                <!-- 0..* Given names (not always 'first'). Includes middle names -->
                <xsl:for-each select="given">
                    <given>
                        <xsl:attribute name="value">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </given>
                </xsl:for-each>
                <!-- 0..* Parts that come before the name -->
                <xsl:for-each select="prefix">
                    <prefix>
                        <xsl:attribute name="value">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </prefix>
                </xsl:for-each>
                <!-- 0..* Parts that come after the name -->
                <xsl:for-each select="suffix">
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
    </xsl:template>
    
    <xsl:template name="ptt_address">
        <xsl:for-each select="./member/patient/addresses/address">
            <address>
                
                <line>
                    <xsl:attribute name="value">
                        <xsl:value-of select="./line[1]"/>
                    </xsl:attribute>
                </line>
                <line>
                    <xsl:attribute name="value">
                        <xsl:value-of select="./line[2]"/>
                    </xsl:attribute>
                </line>
                <city>
                    <xsl:attribute name="value">
                        <xsl:value-of select="./city"/>
                    </xsl:attribute>
                </city>
                
                <state>
                    <xsl:attribute name="value">
                        <xsl:value-of select="./state"/>
                    </xsl:attribute>
                </state>
                <postalCode>
                    <xsl:attribute name="value">
                        <xsl:value-of select="./postal_code"/>
                    </xsl:attribute>
                </postalCode>
                
                <country>
                    <xsl:attribute name="value">USA</xsl:attribute>
                </country>
               
            </address>
        </xsl:for-each>
    </xsl:template>
 
</xsl:stylesheet>
