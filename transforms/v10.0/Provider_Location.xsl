<xsl:stylesheet version="3.0"
    xmlns="http://hl7.org/fhir"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:coco="http://cocodata.org"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://cocodata.org"
    exclude-result-prefixes="coco">

    <!-- Explicit entrypoint + suppress built-in text-node copying (prevents stray text before root). -->
    <xsl:template match="/">
        <xsl:apply-templates select="/providers/provider"/>
    </xsl:template>
    <xsl:template match="text()"/>

    <xsl:variable name="POG_PROVIDER" select="/providers/provider"/>
    <xsl:variable name="POG_PROVIDER_DEMOGRAPHIC" select="$POG_PROVIDER/providing_organization"/>
    <xsl:variable name="POG_PROVIDER_LOCATIONS"
        select="$POG_PROVIDER/providing_organization/addresses"/>
    <xsl:variable name="POG_CUSTOMER_PREFIX" select="$POG_PROVIDER/customername"/>

    <xsl:variable name="POG_CLIA" select="$POG_PROVIDER_DEMOGRAPHIC/clia"/>
    <xsl:variable name="POG_NPI" select="$POG_PROVIDER/practitioner/npi"/>
    <xsl:variable name="POG_USE" select="$POG_PROVIDER_LOCATIONS/use"/>
    <xsl:variable name="POG_TYPE" select="$POG_PROVIDER_LOCATIONS/type"/>

    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="provider">

        <!-- This stylesheet can produce multiple Location elements; emit exactly one root Location. -->
        <xsl:variable name="locs" as="element()*">
            <xsl:choose>
                <xsl:when test="$POG_PROVIDER/providing_organization">

                    <xsl:variable name="POG_CLIA" select="$POG_PROVIDER/providing_organization/clia"/>
                    <xsl:variable name="POG_NPI" select="distinct-values($POG_PROVIDER/providing_organization/npi)"/>
                    <xsl:variable name="POG_PROVIDER_DEMOGRAPHIC" select="$POG_PROVIDER/providing_organization"/>
                    <xsl:variable name="POG_UNIQUE_ID" select="$POG_PROVIDER/providing_organization/unique_identifier"/>
                    <xsl:for-each select="($POG_PROVIDER/providing_organization/addresses/address[type != 'postal'])[1]">
                            <Location xmlns="http://hl7.org/fhir">

                                <!-- from Resource: id, meta, implicitRules, and language -->
                                <!-- from DomainResource: text, contained, extension, and modifierExtension -->
                                <xsl:variable name="CODE">
                                    <xsl:choose>
                                        <xsl:when test="$POG_UNIQUE_ID">
                                            <xsl:value-of select="../preceding-sibling::unique_identifier"/>
                                        </xsl:when>
                                        <xsl:when test="$POG_NPI">
                                            <xsl:value-of select="../preceding-sibling::npi"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="../preceding-sibling::clia"/>                                                
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <code value="{$CODE}"/>
                                <id>
                                    <xsl:choose>
                                        <xsl:when test="./hash">
                                            <xsl:attribute name="value">

                                                <xsl:value-of
                                                  select="concat($POG_CUSTOMER_PREFIX, '-', ./hash)"
                                                />
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">

                                                <xsl:value-of
                                                  select="concat($POG_CUSTOMER_PREFIX, '-', $CODE, ./use, ./type)"
                                                />
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </id>


                                <xsl:call-template name="pog_meta_security_organization"/>
                                    
                                <xsl:if test="$POG_NPI">
                                    <identifier>
                                        <type>
                                            <coding>
                                                <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                                                <system>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'http://terminology.hl7.org/CodeSystem/v2-0203'"
                                                        />
                                                    </xsl:attribute>
                                                    
                                                </system>
                                                <code>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="'NPI'"/>
                                                    </xsl:attribute>
                                                </code>
                                                <display>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'National Provider Identifier'"/>
                                                    </xsl:attribute>
                                                </display>
                                                
                                            </coding>
                                            
                                        </type>
                                        
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://hl7.org/fhir/sid/us-npi'"/>
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::npi"/>
                                            </xsl:attribute>
                                        </value>
                                        
                                    </identifier>
                                </xsl:if>
                                <xsl:if test="$POG_UNIQUE_ID">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('https://data.healthlx.com/', 'ID', '-', $POG_CUSTOMER_PREFIX)"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ../preceding-sibling::unique_identifier)"
                                                />
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                <xsl:if test="$POG_CLIA">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://terminology.hl7.org/NamingSystem/CLIA'"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::clia"/>
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>


                                <status>
                                    <!-- 0..1 active | suspended | inactive -->
                                    <xsl:choose>
                                        <xsl:when
                                            test="$POG_PROVIDER_DEMOGRAPHIC/is_active = 'true'">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'active'"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'inactive'"/>
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </status>
                                <operationalStatus><!-- 0..1 Coding The operational status of the location (typically only for a bed/room) --></operationalStatus>
                                <name>
                                    <!-- 0..1 Name of the location as used by humans -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="../preceding-sibling::name"/>
                                    </xsl:attribute>
                                </name>
                                <type>
                                    <coding>
                                        <system
                                            value="http://terminology.hl7.org/CodeSystem/v3-RoleCode"/>
                                        <code value="HOSP"/>
                                    </coding>
                                </type>
                                <alia/>
                                <!-- 0..* A list of alternate names that the location is known as, or was known as, in the past -->
                                <description>
                                    <!-- 0..1 Additional details about the location that could be displayed as further information to identify the location beyond its name -->

                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="$POG_PROVIDER_DEMOGRAPHIC[1]/codes/code[1]/display"
                                        />
                                    </xsl:attribute>
                                </description>
                                <mode><!-- 0..1 instance | kind -->
                                </mode>
                                <type><!-- 0..* CodeableConcept Type of function performed --></type>
                                <!-- 0..* ContactPoint Contact details of the location -->


                                <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/telecoms/telecom">
                                    <telecom>
                                        <xsl:for-each
                                            select="./contactpoint_available_times/contactpoint_available_time">
                                            <extension
                                                url="http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/contactpoint-availabletime">
                                                <extension url="daysOfWeek">

                                                  <valueCode>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./days_of_week"/>
                                                  </xsl:attribute>
                                                  </valueCode>
                                                </extension>
                                                <extension url="availableStartTime">
                                                  <valueTime>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./available_start_time"/>
                                                  </xsl:attribute>
                                                  </valueTime>
                                                </extension>
                                                <extension url="availableEndTime">
                                                  <valueTime>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./available_end_time"/>
                                                  </xsl:attribute>
                                                  </valueTime>
                                                </extension>
                                            </extension>



                                        </xsl:for-each>
                                        <use>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./use"/>
                                            </xsl:attribute>
                                        </use>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./value"/>
                                            </xsl:attribute>
                                        </value>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./system"/>
                                            </xsl:attribute>
                                        </system>

                                    </telecom>

                                </xsl:for-each>

                                <address>
                                    <use>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./use"/>
                                        </xsl:attribute>
                                    </use>
                                    <line>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./line"/>
                                        </xsl:attribute>
                                    </line>
                                    <city>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./city"/>
                                        </xsl:attribute>
                                    </city>
                                    <district>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./district"/>
                                        </xsl:attribute>
                                    </district>
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
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./country"/>
                                        </xsl:attribute>
                                    </country>
                                </address>

                                <!--   <physicalType><!-\- 0..1 CodeableConcept Physical form of the location -\->
                                   
                                       <coding>
                                           <system value="http://terminology.hl7.org/CodeSystem/claim-type"/>
                                           <code>
                                               
                                               <xsl:attribute name="value">
                                                   <xsl:value-of select="$EOB_DEMOGRAPHIC/type"/>
                                               </xsl:attribute>
                                           </code>
                                       </coding>
                                   
                                   </physicalType>-->
                                <!-- <position>  <!-\- 0..1 The absolute geographic location -\->
                                       <longitude value="[decimal]"/><!-\- 1..1 Longitude with WGS84 datum -\->
                                       <latitude value="[decimal]"/><!-\- 1..1 Latitude with WGS84 datum -\->
                                       <altitude value="[decimal]"/><!-\- 0..1 Altitude with WGS84 datum -\->
                                   </position>-->
                                <managingOrganization>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', $CODE)"
                                            />
                                        </xsl:attribute>
                                    </reference>

                                    <!-- 0..1 Reference(Organization) Organization responsible for provisioning and upkeep -->
                                    <!-- 1..1 Reference(Patient) The recipient of the products and services -->
                                </managingOrganization>
                            </Location>
                    </xsl:for-each>
                    <xsl:for-each select="$POG_PROVIDER/providing_organization/locations/location">
                        <xsl:variable name="PARTOF" select="./part_of"/>
                        <xsl:for-each select="./address">
                            <xsl:if test="./type != 'postal'">
                            <Location xmlns="http://hl7.org/fhir">
                                <xsl:variable name="CODE">
                                    <xsl:choose>
                                        <xsl:when test="$POG_UNIQUE_ID">
                                            <xsl:value-of select="../preceding-sibling::unique_identifier"/>
                                        </xsl:when>
                                        <xsl:when test="$POG_NPI">
                                            <xsl:value-of select="../preceding-sibling::npi"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="../preceding-sibling::clia"/>                                                
                                        </xsl:otherwise>
                                    </xsl:choose> 
                                </xsl:variable>
                                <!-- from Resource: id, meta, implicitRules, and language -->
                                <!-- from DomainResource: text, contained, extension, and modifierExtension -->
                                <id>
                                    <xsl:choose>
                                        <xsl:when test="./hash">
                                            <xsl:attribute name="value">

                                                <xsl:value-of
                                                  select="concat($POG_CUSTOMER_PREFIX, '-', ./hash)"
                                                />
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">

                                                <xsl:value-of
                                                  select="concat($POG_CUSTOMER_PREFIX, '-', $CODE, ./use, ./type)"
                                                />
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </id>
                                <xsl:call-template name="pog_meta_security_organization"/>
                                <xsl:if test="$POG_NPI">
                                    <identifier>
                                        <type>
                                            <coding>
                                                <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                                                <system>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'http://terminology.hl7.org/CodeSystem/v2-0203'"
                                                        />
                                                    </xsl:attribute>
                                                    
                                                </system>
                                                <code>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="'NPI'"/>
                                                    </xsl:attribute>
                                                </code>
                                                <display>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'National Provider Identifier'"/>
                                                    </xsl:attribute>
                                                </display>
                                                
                                            </coding>
                                            
                                        </type>
                                        
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://hl7.org/fhir/sid/us-npi'"/>
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::npi"/>
                                            </xsl:attribute>
                                        </value>
                                        
                                    </identifier>
                                </xsl:if>
                                <xsl:if test="$POG_UNIQUE_ID">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('https://data.healthlx.com/', 'ID', '-', $POG_CUSTOMER_PREFIX)"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ../preceding-sibling::unique_identifier)"
                                                />
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                <xsl:if test="$POG_CLIA">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://terminology.hl7.org/NamingSystem/CLIA'"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::clia"/>
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>


                                <status>
                                    <!-- 0..1 active | suspended | inactive -->
                                    <xsl:choose>
                                        <xsl:when
                                            test="$POG_PROVIDER_DEMOGRAPHIC/is_active = 'true'">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'active'"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'inactive'"/>
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </status>
                                <operationalStatus><!-- 0..1 Coding The operational status of the location (typically only for a bed/room) --></operationalStatus>
                                <name>
                                    <!-- 0..1 Name of the location as used by humans -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="../preceding-sibling::name"/>
                                    </xsl:attribute>
                                </name>
                                <type>
                                    <coding>
                                        <system
                                            value="http://terminology.hl7.org/CodeSystem/v3-RoleCode"/>
                                        <code value="HOSP"/>
                                    </coding>
                                </type>
                                <alia/>
                                <!-- 0..* A list of alternate names that the location is known as, or was known as, in the past -->
                                <description>
                                    <!-- 0..1 Additional details about the location that could be displayed as further information to identify the location beyond its name -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="$POG_PROVIDER_DEMOGRAPHIC[1]/codes/code[1]/display"
                                        />
                                    </xsl:attribute>
                                </description>
                                <mode><!-- 0..1 instance | kind -->
                                </mode>
                                <type><!-- 0..* CodeableConcept Type of function performed --></type>
                                <!-- 0..* ContactPoint Contact details of the location -->


                                <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/telecoms/telecom">
                                    <telecom>
                                        <xsl:for-each
                                            select="./contactpoint_available_times/contactpoint_available_time">
                                            <extension
                                                url="http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/contactpoint-availabletime">
                                                <extension url="daysOfWeek">

                                                  <valueCode>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./days_of_week"/>
                                                  </xsl:attribute>
                                                  </valueCode>
                                                </extension>
                                                <extension url="availableStartTime">
                                                  <valueTime>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./available_start_time"/>
                                                  </xsl:attribute>
                                                  </valueTime>
                                                </extension>
                                                <extension url="availableEndTime">
                                                  <valueTime>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./available_end_time"/>
                                                  </xsl:attribute>
                                                  </valueTime>
                                                </extension>
                                            </extension>



                                        </xsl:for-each>
                                        <use>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./use"/>
                                            </xsl:attribute>
                                        </use>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./value"/>
                                            </xsl:attribute>
                                        </value>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./system"/>
                                            </xsl:attribute>
                                        </system>

                                    </telecom>

                                </xsl:for-each>

                                <address>
                                    <use>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./use"/>
                                        </xsl:attribute>
                                    </use>
                                    <line>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./line"/>
                                        </xsl:attribute>
                                    </line>
                                    <city>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./city"/>
                                        </xsl:attribute>
                                    </city>
                                    <district>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./district"/>
                                        </xsl:attribute>
                                    </district>
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
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./country"/>
                                        </xsl:attribute>
                                    </country>
                                </address>

                                <!--   <physicalType><!-\- 0..1 CodeableConcept Physical form of the location -\->
                                
                                    <coding>
                                        <system value="http://terminology.hl7.org/CodeSystem/claim-type"/>
                                        <code>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$EOB_DEMOGRAPHIC/type"/>
                                            </xsl:attribute>
                                        </code>
                                    </coding>
                                
                                </physicalType>-->
                                <!-- <position>  <!-\- 0..1 The absolute geographic location -\->
                                    <longitude value="[decimal]"/><!-\- 1..1 Longitude with WGS84 datum -\->
                                    <latitude value="[decimal]"/><!-\- 1..1 Latitude with WGS84 datum -\->
                                    <altitude value="[decimal]"/><!-\- 0..1 Altitude with WGS84 datum -\->
                                </position>-->
                                <managingOrganization>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', $CODE)"
                                            />
                                        </xsl:attribute>
                                    </reference>
                                </managingOrganization>   
                                <xsl:if test="normalize-space($PARTOF) != ''">
                                    <partOf>
                                        <reference>
                                            <xsl:copy-of select="$PARTOF/identifiers/identifier[1]"/>
                                            <display>
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="$PARTOF/name"/>
                                                </xsl:attribute>
                                            </display>
                                        </reference>
                                    </partOf>
                                </xsl:if>
                                <!-- 0..1 Reference(Organization) Organization responsible for provisioning and upkeep -->
                                <!-- 1..1 Reference(Patient) The recipient of the products and services -->                                   
                            </Location>
                            </xsl:if>
                        </xsl:for-each>   
                    </xsl:for-each>
                    <xsl:for-each select="$POG_PROVIDER/providing_organization/affiliated_organization/addresses/address">
                        <xsl:if test="./type != 'postal'">
                            <Location xmlns="http://hl7.org/fhir">
                                <xsl:variable name="CODE">
                                    <xsl:choose>
                                        <xsl:when test="$POG_UNIQUE_ID">
                                            <xsl:value-of select="../preceding-sibling::unique_identifier"/>
                                        </xsl:when>
                                        <xsl:when test="$POG_NPI">
                                            <xsl:value-of select="../preceding-sibling::npi"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="../preceding-sibling::clia"/>                                                
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <!-- from Resource: id, meta, implicitRules, and language -->
                                <!-- from DomainResource: text, contained, extension, and modifierExtension -->
                                <id>
                                    <xsl:choose>
                                        <xsl:when test="./hash">
                                            <xsl:attribute name="value">

                                                <xsl:value-of
                                                  select="concat($POG_CUSTOMER_PREFIX, '-', ./hash)"
                                                />
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">

                                                <xsl:value-of
                                                  select="concat($POG_CUSTOMER_PREFIX, '-', $CODE, ./use, ./type)"
                                                />
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </id>
                                <xsl:call-template name="pog_meta_security_organization"/>
                                <xsl:if test="$POG_NPI">
                                    <identifier>
                                        <type>
                                            <coding>
                                                <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                                                <system>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'http://terminology.hl7.org/CodeSystem/v2-0203'"
                                                        />
                                                    </xsl:attribute>
                                                    
                                                </system>
                                                <code>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="'NPI'"/>
                                                    </xsl:attribute>
                                                </code>
                                                <display>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'National Provider Identifier'"/>
                                                    </xsl:attribute>
                                                </display>
                                                
                                            </coding>
                                            
                                        </type>
                                        
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://hl7.org/fhir/sid/us-npi'"/>
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::npi"/>
                                            </xsl:attribute>
                                        </value>
                                        
                                    </identifier>
                                </xsl:if>
                                <xsl:if test="$POG_UNIQUE_ID">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('https://data.healthlx.com/', 'ID', '-', $POG_CUSTOMER_PREFIX)"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ../preceding-sibling::unique_identifier)"
                                                />
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                <xsl:if test="$POG_CLIA">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://terminology.hl7.org/NamingSystem/CLIA'"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::clia"/>
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>


                                <status>
                                    <!-- 0..1 active | suspended | inactive -->
                                    <xsl:choose>
                                        <xsl:when
                                            test="$POG_PROVIDER_DEMOGRAPHIC/is_active = 'true'">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'active'"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'inactive'"/>
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </status>
                                <operationalStatus><!-- 0..1 Coding The operational status of the location (typically only for a bed/room) --></operationalStatus>
                                <name>
                                    <!-- 0..1 Name of the location as used by humans -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="../preceding-sibling::name"/>
                                    </xsl:attribute>
                                </name>
                                <type>
                                    <coding>
                                        <system
                                            value="http://terminology.hl7.org/CodeSystem/v3-RoleCode"/>
                                        <code value="HOSP"/>
                                    </coding>
                                </type>
                                <alia/>
                                <!-- 0..* A list of alternate names that the location is known as, or was known as, in the past -->
                                <description>
                                    <!-- 0..1 Additional details about the location that could be displayed as further information to identify the location beyond its name -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="$POG_PROVIDER_DEMOGRAPHIC[1]/codes/code[1]/display"
                                        />
                                    </xsl:attribute>
                                </description>
                                <mode><!-- 0..1 instance | kind -->
                                </mode>
                                <type><!-- 0..* CodeableConcept Type of function performed --></type>
                                <!-- 0..* ContactPoint Contact details of the location -->


                                <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/telecoms/telecom">
                                    <telecom>
                                        <xsl:for-each
                                            select="./contactpoint_available_times/contactpoint_available_time">
                                            <extension
                                                url="http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/contactpoint-availabletime">
                                                <extension url="daysOfWeek">

                                                  <valueCode>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./days_of_week"/>
                                                  </xsl:attribute>
                                                  </valueCode>
                                                </extension>
                                                <extension url="availableStartTime">
                                                  <valueTime>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./available_start_time"/>
                                                  </xsl:attribute>
                                                  </valueTime>
                                                </extension>
                                                <extension url="availableEndTime">
                                                  <valueTime>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./available_end_time"/>
                                                  </xsl:attribute>
                                                  </valueTime>
                                                </extension>
                                            </extension>



                                        </xsl:for-each>
                                        <use>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./use"/>
                                            </xsl:attribute>
                                        </use>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./value"/>
                                            </xsl:attribute>
                                        </value>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./system"/>
                                            </xsl:attribute>
                                        </system>

                                    </telecom>

                                </xsl:for-each>

                                <address>
                                    <use>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./use"/>
                                        </xsl:attribute>
                                    </use>
                                    <line>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./line"/>
                                        </xsl:attribute>
                                    </line>
                                    <city>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./city"/>
                                        </xsl:attribute>
                                    </city>
                                    <district>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./district"/>
                                        </xsl:attribute>
                                    </district>
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
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./country"/>
                                        </xsl:attribute>
                                    </country>
                                </address>

                                <!--   <physicalType><!-\- 0..1 CodeableConcept Physical form of the location -\->
                                
                                    <coding>
                                        <system value="http://terminology.hl7.org/CodeSystem/claim-type"/>
                                        <code>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$EOB_DEMOGRAPHIC/type"/>
                                            </xsl:attribute>
                                        </code>
                                    </coding>
                                
                                </physicalType>-->
                                <!-- <position>  <!-\- 0..1 The absolute geographic location -\->
                                    <longitude value="[decimal]"/><!-\- 1..1 Longitude with WGS84 datum -\->
                                    <latitude value="[decimal]"/><!-\- 1..1 Latitude with WGS84 datum -\->
                                    <altitude value="[decimal]"/><!-\- 0..1 Altitude with WGS84 datum -\->
                                </position>-->
                                <managingOrganization>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', $CODE)"
                                            />
                                        </xsl:attribute>
                                    </reference>
                                </managingOrganization>

                                <!-- 0..1 Reference(Organization) Organization responsible for provisioning and upkeep -->
                                <!-- 1..1 Reference(Patient) The recipient of the products and services -->


                            </Location>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$POG_PROVIDER/providing_organization/affiliated_organization/part_of/addresses/address">
                        <xsl:if test="./type != 'postal'">
                            <Location xmlns="http://hl7.org/fhir">
                                <xsl:variable name="CODE">
                                    <xsl:choose>
                                        <xsl:when test="$POG_UNIQUE_ID">
                                            <xsl:value-of select="../preceding-sibling::unique_identifier"/>
                                        </xsl:when>
                                        <xsl:when test="$POG_NPI">
                                            <xsl:value-of select="../preceding-sibling::npi"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="../preceding-sibling::clia"/>                                                
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <!-- from Resource: id, meta, implicitRules, and language -->
                                <!-- from DomainResource: text, contained, extension, and modifierExtension -->
                                <id>
                                    <xsl:choose>
                                        <xsl:when test="./hash">
                                            <xsl:attribute name="value">
                                                
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ./hash)"
                                                />
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', $CODE, ./use, ./type)"
                                                />
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </id>
                                <xsl:call-template name="pog_meta_security_organization"/>
                                <xsl:if test="$POG_NPI">
                                    <identifier>
                                        <type>
                                            <coding>
                                                <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                                                <system>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'http://terminology.hl7.org/CodeSystem/v2-0203'"
                                                        />
                                                    </xsl:attribute>
                                                    
                                                </system>
                                                <code>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="'NPI'"/>
                                                    </xsl:attribute>
                                                </code>
                                                <display>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'National Provider Identifier'"/>
                                                    </xsl:attribute>
                                                </display>
                                                
                                            </coding>
                                            
                                        </type>
                                        
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://hl7.org/fhir/sid/us-npi'"/>
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::npi"/>
                                            </xsl:attribute>
                                        </value>
                                        
                                    </identifier>
                                </xsl:if>
                                <xsl:if test="$POG_UNIQUE_ID">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('https://data.healthlx.com/', 'ID', '-', $POG_CUSTOMER_PREFIX)"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ../preceding-sibling::unique_identifier)"
                                                />
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                <xsl:if test="$POG_CLIA">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://terminology.hl7.org/NamingSystem/CLIA'"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::clia"/>
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                
                                <status>
                                    <!-- 0..1 active | suspended | inactive -->
                                    <xsl:choose>
                                        <xsl:when
                                            test="$POG_PROVIDER_DEMOGRAPHIC/is_active = 'true'">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'active'"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'inactive'"/>
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </status>
                                <operationalStatus><!-- 0..1 Coding The operational status of the location (typically only for a bed/room) --></operationalStatus>
                                <name>
                                    <!-- 0..1 Name of the location as used by humans -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="../preceding-sibling::name"/>
                                    </xsl:attribute>
                                </name>
                                <type>
                                    <coding>
                                        <system
                                            value="http://terminology.hl7.org/CodeSystem/v3-RoleCode"/>
                                        <code value="HOSP"/>
                                    </coding>
                                </type>
                                <alia/>
                                <!-- 0..* A list of alternate names that the location is known as, or was known as, in the past -->
                                <description>
                                    <!-- 0..1 Additional details about the location that could be displayed as further information to identify the location beyond its name -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="$POG_PROVIDER_DEMOGRAPHIC[1]/codes/code[1]/display"
                                        />
                                    </xsl:attribute>
                                </description>
                                <mode><!-- 0..1 instance | kind -->
                                </mode>
                                <type><!-- 0..* CodeableConcept Type of function performed --></type>
                                <!-- 0..* ContactPoint Contact details of the location -->
                                
                                
                                <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/telecoms/telecom">
                                    <telecom>
                                        <xsl:for-each
                                            select="./contactpoint_available_times/contactpoint_available_time">
                                            <extension
                                                url="http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/contactpoint-availabletime">
                                                <extension url="daysOfWeek">
                                                    
                                                    <valueCode>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./days_of_week"/>
                                                        </xsl:attribute>
                                                    </valueCode>
                                                </extension>
                                                <extension url="availableStartTime">
                                                    <valueTime>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./available_start_time"/>
                                                        </xsl:attribute>
                                                    </valueTime>
                                                </extension>
                                                <extension url="availableEndTime">
                                                    <valueTime>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./available_end_time"/>
                                                        </xsl:attribute>
                                                    </valueTime>
                                                </extension>
                                            </extension>
                                            
                                            
                                            
                                        </xsl:for-each>
                                        <use>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./use"/>
                                            </xsl:attribute>
                                        </use>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./value"/>
                                            </xsl:attribute>
                                        </value>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./system"/>
                                            </xsl:attribute>
                                        </system>
                                        
                                    </telecom>
                                    
                                </xsl:for-each>
                                
                                <address>
                                    <use>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./use"/>
                                        </xsl:attribute>
                                    </use>
                                    <line>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./line"/>
                                        </xsl:attribute>
                                    </line>
                                    <city>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./city"/>
                                        </xsl:attribute>
                                    </city>
                                    <district>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./district"/>
                                        </xsl:attribute>
                                    </district>
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
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./country"/>
                                        </xsl:attribute>
                                    </country>
                                </address>
                                
                                <!--   <physicalType><!-\- 0..1 CodeableConcept Physical form of the location -\->
                                
                                    <coding>
                                        <system value="http://terminology.hl7.org/CodeSystem/claim-type"/>
                                        <code>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$EOB_DEMOGRAPHIC/type"/>
                                            </xsl:attribute>
                                        </code>
                                    </coding>
                                
                                </physicalType>-->
                                <!-- <position>  <!-\- 0..1 The absolute geographic location -\->
                                    <longitude value="[decimal]"/><!-\- 1..1 Longitude with WGS84 datum -\->
                                    <latitude value="[decimal]"/><!-\- 1..1 Latitude with WGS84 datum -\->
                                    <altitude value="[decimal]"/><!-\- 0..1 Altitude with WGS84 datum -\->
                                </position>-->
                                <managingOrganization>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', $CODE)"
                                            />
                                        </xsl:attribute>
                                    </reference>
                                </managingOrganization>
                                
                                <!-- 0..1 Reference(Organization) Organization responsible for provisioning and upkeep -->
                                <!-- 1..1 Reference(Patient) The recipient of the products and services -->
                                
                                
                            </Location>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$POG_PROVIDER/providing_organization/healthcare_services/healthcare_service/locations/location/address">
                        <xsl:if test="./type != 'postal'">
                            <Location xmlns="http://hl7.org/fhir">
                                <xsl:variable name="CODE">
                                    <xsl:choose>
                                        <xsl:when test="$POG_UNIQUE_ID">
                                            <xsl:value-of select="../preceding-sibling::unique_identifier"/>
                                        </xsl:when>
                                        <xsl:when test="$POG_NPI">
                                            <xsl:value-of select="../preceding-sibling::npi"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="../preceding-sibling::clia"/>                                                
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <!-- from Resource: id, meta, implicitRules, and language -->
                                <!-- from DomainResource: text, contained, extension, and modifierExtension -->
                                <id>
                                    <xsl:choose>
                                        <xsl:when test="./hash">
                                            <xsl:attribute name="value">
                                                
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ./hash)"
                                                />
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', $CODE, ./use, ./type)"
                                                />
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </id>
                                <xsl:call-template name="pog_meta_security_organization"/>
                                <xsl:if test="$POG_NPI">
                                    <identifier>
                                        <type>
                                            <coding>
                                                <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                                                <system>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'http://terminology.hl7.org/CodeSystem/v2-0203'"
                                                        />
                                                    </xsl:attribute>
                                                    
                                                </system>
                                                <code>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="'NPI'"/>
                                                    </xsl:attribute>
                                                </code>
                                                <display>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'National Provider Identifier'"/>
                                                    </xsl:attribute>
                                                </display>
                                                
                                            </coding>
                                            
                                        </type>
                                        
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://hl7.org/fhir/sid/us-npi'"/>
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::npi"/>
                                            </xsl:attribute>
                                        </value>
                                        
                                    </identifier>
                                </xsl:if>
                                <xsl:if test="$POG_UNIQUE_ID">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('https://data.healthlx.com/', 'ID', '-', $POG_CUSTOMER_PREFIX)"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ../preceding-sibling::unique_identifier)"
                                                />
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                <xsl:if test="$POG_CLIA">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://terminology.hl7.org/NamingSystem/CLIA'"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::clia"/>
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                
                                <status>
                                    <!-- 0..1 active | suspended | inactive -->
                                    <xsl:choose>
                                        <xsl:when
                                            test="$POG_PROVIDER_DEMOGRAPHIC/is_active = 'true'">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'active'"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'inactive'"/>
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </status>
                                <operationalStatus><!-- 0..1 Coding The operational status of the location (typically only for a bed/room) --></operationalStatus>
                                <name>
                                    <!-- 0..1 Name of the location as used by humans -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="../preceding-sibling::name"/>
                                    </xsl:attribute>
                                </name>
                                <type>
                                    <coding>
                                        <system
                                            value="http://terminology.hl7.org/CodeSystem/v3-RoleCode"/>
                                        <code value="HOSP"/>
                                    </coding>
                                </type>
                                <alia/>
                                <!-- 0..* A list of alternate names that the location is known as, or was known as, in the past -->
                                <description>
                                    <!-- 0..1 Additional details about the location that could be displayed as further information to identify the location beyond its name -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="$POG_PROVIDER_DEMOGRAPHIC[1]/codes/code[1]/display"
                                        />
                                    </xsl:attribute>
                                </description>
                                <mode><!-- 0..1 instance | kind -->
                                </mode>
                                <type><!-- 0..* CodeableConcept Type of function performed --></type>
                                <!-- 0..* ContactPoint Contact details of the location -->
                                
                                
                                <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/telecoms/telecom">
                                    <telecom>
                                        <xsl:for-each
                                            select="./contactpoint_available_times/contactpoint_available_time">
                                            <extension
                                                url="http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/contactpoint-availabletime">
                                                <extension url="daysOfWeek">
                                                    
                                                    <valueCode>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./days_of_week"/>
                                                        </xsl:attribute>
                                                    </valueCode>
                                                </extension>
                                                <extension url="availableStartTime">
                                                    <valueTime>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./available_start_time"/>
                                                        </xsl:attribute>
                                                    </valueTime>
                                                </extension>
                                                <extension url="availableEndTime">
                                                    <valueTime>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./available_end_time"/>
                                                        </xsl:attribute>
                                                    </valueTime>
                                                </extension>
                                            </extension>
                                            
                                            
                                            
                                        </xsl:for-each>
                                        <use>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./use"/>
                                            </xsl:attribute>
                                        </use>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./value"/>
                                            </xsl:attribute>
                                        </value>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./system"/>
                                            </xsl:attribute>
                                        </system>
                                        
                                    </telecom>
                                    
                                </xsl:for-each>
                                
                                <address>
                                    <use>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./use"/>
                                        </xsl:attribute>
                                    </use>
                                    <line>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./line"/>
                                        </xsl:attribute>
                                    </line>
                                    <city>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./city"/>
                                        </xsl:attribute>
                                    </city>
                                    <district>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./district"/>
                                        </xsl:attribute>
                                    </district>
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
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./country"/>
                                        </xsl:attribute>
                                    </country>
                                </address>
                                
                                <!--   <physicalType><!-\- 0..1 CodeableConcept Physical form of the location -\->
                                
                                    <coding>
                                        <system value="http://terminology.hl7.org/CodeSystem/claim-type"/>
                                        <code>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$EOB_DEMOGRAPHIC/type"/>
                                            </xsl:attribute>
                                        </code>
                                    </coding>
                                
                                </physicalType>-->
                                <!-- <position>  <!-\- 0..1 The absolute geographic location -\->
                                    <longitude value="[decimal]"/><!-\- 1..1 Longitude with WGS84 datum -\->
                                    <latitude value="[decimal]"/><!-\- 1..1 Latitude with WGS84 datum -\->
                                    <altitude value="[decimal]"/><!-\- 0..1 Altitude with WGS84 datum -\->
                                </position>-->
                                <managingOrganization>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', $CODE)"
                                            />
                                        </xsl:attribute>
                                    </reference>
                                </managingOrganization>
                                
                                <!-- 0..1 Reference(Organization) Organization responsible for provisioning and upkeep -->
                                <!-- 1..1 Reference(Patient) The recipient of the products and services -->
                                
                                
                            </Location>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$POG_PROVIDER/providing_organization/part_of/addresses/address">
                        <xsl:if test="./type != 'postal'">
                            <Location xmlns="http://hl7.org/fhir">
                                <xsl:variable name="CODE">
                                    <xsl:choose>
                                        <xsl:when test="$POG_UNIQUE_ID">
                                            <xsl:value-of select="../preceding-sibling::unique_identifier"/>
                                        </xsl:when>
                                        <xsl:when test="$POG_NPI">
                                            <xsl:value-of select="../preceding-sibling::npi"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="../preceding-sibling::clia"/>                                                
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <!-- from Resource: id, meta, implicitRules, and language -->
                                <!-- from DomainResource: text, contained, extension, and modifierExtension -->
                                <id>
                                    <xsl:choose>
                                        <xsl:when test="./hash">
                                            <xsl:attribute name="value">
                                                
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ./hash)"
                                                />
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', $CODE, ./use, ./type)"
                                                />
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </id>
                                <xsl:call-template name="pog_meta_security_organization"/>
                                <xsl:if test="$POG_NPI">
                                    <identifier>
                                        <type>
                                            <coding>
                                                <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                                                <system>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'http://terminology.hl7.org/CodeSystem/v2-0203'"
                                                        />
                                                    </xsl:attribute>
                                                    
                                                </system>
                                                <code>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="'NPI'"/>
                                                    </xsl:attribute>
                                                </code>
                                                <display>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'National Provider Identifier'"/>
                                                    </xsl:attribute>
                                                </display>
                                                
                                            </coding>
                                            
                                        </type>
                                        
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://hl7.org/fhir/sid/us-npi'"/>
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::npi"/>
                                            </xsl:attribute>
                                        </value>
                                        
                                    </identifier>
                                </xsl:if>
                                <xsl:if test="$POG_UNIQUE_ID">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('https://data.healthlx.com/', 'ID', '-', $POG_CUSTOMER_PREFIX)"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ../preceding-sibling::unique_identifier)"
                                                />
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                <xsl:if test="$POG_CLIA">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://terminology.hl7.org/NamingSystem/CLIA'"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::clia"/>
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                
                                <status>
                                    <!-- 0..1 active | suspended | inactive -->
                                    <xsl:choose>
                                        <xsl:when
                                            test="$POG_PROVIDER_DEMOGRAPHIC/is_active = 'true'">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'active'"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'inactive'"/>
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </status>
                                <operationalStatus><!-- 0..1 Coding The operational status of the location (typically only for a bed/room) --></operationalStatus>
                                <name>
                                    <!-- 0..1 Name of the location as used by humans -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="../preceding-sibling::name"/>
                                    </xsl:attribute>
                                </name>
                                <type>
                                    <coding>
                                        <system
                                            value="http://terminology.hl7.org/CodeSystem/v3-RoleCode"/>
                                        <code value="HOSP"/>
                                    </coding>
                                </type>
                                <alia/>
                                <!-- 0..* A list of alternate names that the location is known as, or was known as, in the past -->
                                <description>
                                    <!-- 0..1 Additional details about the location that could be displayed as further information to identify the location beyond its name -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="$POG_PROVIDER_DEMOGRAPHIC[1]/codes/code[1]/display"
                                        />
                                    </xsl:attribute>
                                </description>
                                <mode><!-- 0..1 instance | kind -->
                                </mode>
                                <type><!-- 0..* CodeableConcept Type of function performed --></type>
                                <!-- 0..* ContactPoint Contact details of the location -->
                                
                                
                                <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/telecoms/telecom">
                                    <telecom>
                                        <xsl:for-each
                                            select="./contactpoint_available_times/contactpoint_available_time">
                                            <extension
                                                url="http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/contactpoint-availabletime">
                                                <extension url="daysOfWeek">
                                                    
                                                    <valueCode>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./days_of_week"/>
                                                        </xsl:attribute>
                                                    </valueCode>
                                                </extension>
                                                <extension url="availableStartTime">
                                                    <valueTime>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./available_start_time"/>
                                                        </xsl:attribute>
                                                    </valueTime>
                                                </extension>
                                                <extension url="availableEndTime">
                                                    <valueTime>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./available_end_time"/>
                                                        </xsl:attribute>
                                                    </valueTime>
                                                </extension>
                                            </extension>
                                            
                                            
                                            
                                        </xsl:for-each>
                                        <use>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./use"/>
                                            </xsl:attribute>
                                        </use>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./value"/>
                                            </xsl:attribute>
                                        </value>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./system"/>
                                            </xsl:attribute>
                                        </system>
                                        
                                    </telecom>
                                    
                                </xsl:for-each>
                                
                                <address>
                                    <use>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./use"/>
                                        </xsl:attribute>
                                    </use>
                                    <line>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./line"/>
                                        </xsl:attribute>
                                    </line>
                                    <city>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./city"/>
                                        </xsl:attribute>
                                    </city>
                                    <district>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./district"/>
                                        </xsl:attribute>
                                    </district>
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
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./country"/>
                                        </xsl:attribute>
                                    </country>
                                </address>
                                
                                <!--   <physicalType><!-\- 0..1 CodeableConcept Physical form of the location -\->
                                
                                    <coding>
                                        <system value="http://terminology.hl7.org/CodeSystem/claim-type"/>
                                        <code>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$EOB_DEMOGRAPHIC/type"/>
                                            </xsl:attribute>
                                        </code>
                                    </coding>
                                
                                </physicalType>-->
                                <!-- <position>  <!-\- 0..1 The absolute geographic location -\->
                                    <longitude value="[decimal]"/><!-\- 1..1 Longitude with WGS84 datum -\->
                                    <latitude value="[decimal]"/><!-\- 1..1 Latitude with WGS84 datum -\->
                                    <altitude value="[decimal]"/><!-\- 0..1 Altitude with WGS84 datum -\->
                                </position>-->
                                <managingOrganization>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', $CODE)"
                                            />
                                        </xsl:attribute>
                                    </reference>
                                </managingOrganization>
                                
                                <!-- 0..1 Reference(Organization) Organization responsible for provisioning and upkeep -->
                                <!-- 1..1 Reference(Patient) The recipient of the products and services -->
                                
                                
                            </Location>
                        </xsl:if>
                    </xsl:for-each>
                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="POG_CLIA" select="$POG_PROVIDER/practitioner/clia"/>
                    <xsl:variable name="POG_NPI" select="$POG_PROVIDER/practitioner/npi"/>
                    <xsl:variable name="POG_PROVIDER_DEMOGRAPHIC" select="$POG_PROVIDER/practitioner"/>
                    <xsl:variable name="POG_UNIQUE_ID" select="$POG_PROVIDER/practitioner/unique_identifier"/>
                    <xsl:for-each select="($POG_PROVIDER/practitioner/addresses/address[type != 'postal'])[1]">
                            <Location xmlns="http://hl7.org/fhir">
                                <xsl:variable name="CODE">
                                    <xsl:choose>
                                        <xsl:when test="$POG_UNIQUE_ID">
                                            <xsl:value-of select="../preceding-sibling::unique_identifier"/>
                                        </xsl:when>
                                        <xsl:when test="$POG_NPI">
                                            <xsl:value-of select="../preceding-sibling::npi"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="../preceding-sibling::clia"/>                                                
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <!-- from Resource: id, meta, implicitRules, and language -->
                                <!-- from DomainResource: text, contained, extension, and modifierExtension -->
                                <id>
                                    <xsl:choose>
                                        <xsl:when test="./hash">
                                            <xsl:attribute name="value">

                                                <xsl:value-of
                                                  select="concat($POG_CUSTOMER_PREFIX, '-', ./hash)"
                                                />
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">

                                                <xsl:value-of
                                                  select="concat($POG_CUSTOMER_PREFIX, '-', $CODE, ./use, ./type)"
                                                />
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </id>
                                <xsl:call-template name="pog_meta_security_organization"/>
                                <xsl:if test="$POG_NPI">
                                    <identifier>
                                        <type>
                                            <coding>
                                                <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                                                <system>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'http://terminology.hl7.org/CodeSystem/v2-0203'"
                                                        />
                                                    </xsl:attribute>
                                                    
                                                </system>
                                                <code>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="'NPI'"/>
                                                    </xsl:attribute>
                                                </code>
                                                <display>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'National Provider Identifier'"/>
                                                    </xsl:attribute>
                                                </display>
                                                
                                            </coding>
                                            
                                        </type>
                                        
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://hl7.org/fhir/sid/us-npi'"/>
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::npi"/>
                                            </xsl:attribute>
                                        </value>
                                        
                                    </identifier>
                                </xsl:if>
                                <xsl:if test="$POG_UNIQUE_ID">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('https://data.healthlx.com/', 'ID', '-', $POG_CUSTOMER_PREFIX)"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ../preceding-sibling::unique_identifier)"
                                                />
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                <xsl:if test="$POG_CLIA">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://terminology.hl7.org/NamingSystem/CLIA'"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::clia"/>
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>


                                <status>
                                    <!-- 0..1 active | suspended | inactive -->
                                    <xsl:choose>
                                        <xsl:when
                                            test="$POG_PROVIDER_DEMOGRAPHIC/is_active = 'true'">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'active'"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'inactive'"/>
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </status>
                                <operationalStatus><!-- 0..1 Coding The operational status of the location (typically only for a bed/room) --></operationalStatus>
                                <name>
                                    <!-- 0..1 Name of the location as used by humans -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="../preceding-sibling::name"/>
                                    </xsl:attribute>
                                </name>
                                <type>
                                    <coding>
                                        <system
                                            value="http://terminology.hl7.org/CodeSystem/v3-RoleCode"/>
                                        <code value="HOSP"/>
                                    </coding>
                                </type>
                                <alia/>
                                <!-- 0..* A list of alternate names that the location is known as, or was known as, in the past -->
                                <description>
                                    <!-- 0..1 Additional details about the location that could be displayed as further information to identify the location beyond its name -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="$POG_PROVIDER_DEMOGRAPHIC[1]/codes/code[1]/display"
                                        />
                                    </xsl:attribute>
                                </description>
                                <mode><!-- 0..1 instance | kind -->
                                </mode>
                                <type><!-- 0..* CodeableConcept Type of function performed --></type>
                                <!-- 0..* ContactPoint Contact details of the location -->


                                <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/telecoms/telecom">
                                    <telecom>
                                        <xsl:for-each
                                            select="./contactpoint_available_times/contactpoint_available_time">
                                            <extension
                                                url="http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/contactpoint-availabletime">
                                                <extension url="daysOfWeek">

                                                  <valueCode>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./days_of_week"/>
                                                  </xsl:attribute>
                                                  </valueCode>
                                                </extension>
                                                <extension url="availableStartTime">
                                                  <valueTime>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./available_start_time"/>
                                                  </xsl:attribute>
                                                  </valueTime>
                                                </extension>
                                                <extension url="availableEndTime">
                                                  <valueTime>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./available_end_time"/>
                                                  </xsl:attribute>
                                                  </valueTime>
                                                </extension>
                                            </extension>



                                        </xsl:for-each>
                                        <use>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./use"/>
                                            </xsl:attribute>
                                        </use>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./value"/>
                                            </xsl:attribute>
                                        </value>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./system"/>
                                            </xsl:attribute>
                                        </system>

                                    </telecom>

                                </xsl:for-each>

                                <address>
                                    <use>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./use"/>
                                        </xsl:attribute>
                                    </use>
                                    <line>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./line"/>
                                        </xsl:attribute>
                                    </line>
                                    <city>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./city"/>
                                        </xsl:attribute>
                                    </city>
                                    <district>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./district"/>
                                        </xsl:attribute>
                                    </district>
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
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./country"/>
                                        </xsl:attribute>
                                    </country>
                                </address>

                                <!--   <physicalType><!-\- 0..1 CodeableConcept Physical form of the location -\->
                                
                                    <coding>
                                        <system value="http://terminology.hl7.org/CodeSystem/claim-type"/>
                                        <code>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$EOB_DEMOGRAPHIC/type"/>
                                            </xsl:attribute>
                                        </code>
                                    </coding>
                                
                                </physicalType>-->
                                <!-- <position>  <!-\- 0..1 The absolute geographic location -\->
                                    <longitude value="[decimal]"/><!-\- 1..1 Longitude with WGS84 datum -\->
                                    <latitude value="[decimal]"/><!-\- 1..1 Latitude with WGS84 datum -\->
                                    <altitude value="[decimal]"/><!-\- 0..1 Altitude with WGS84 datum -\->
                                </position>-->
                                <managingOrganization>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', $CODE)"
                                            />
                                        </xsl:attribute>
                                    </reference>
                                </managingOrganization>

                                <!-- 0..1 Reference(Organization) Organization responsible for provisioning and upkeep -->
                                <!-- 1..1 Reference(Patient) The recipient of the products and services -->


                            </Location>
                    </xsl:for-each>
                    <xsl:if test="not($POG_PROVIDER/practitioner/addresses/address[type != 'postal'])">
                    <xsl:for-each select="($POG_PROVIDER/practitioner/locations/location/address[type != 'postal'])[1]">
                            <Location xmlns="http://hl7.org/fhir">
                                <xsl:variable name="CODE">
                                    <xsl:choose>
                                        <xsl:when test="$POG_UNIQUE_ID">
                                            <xsl:value-of select="../preceding-sibling::unique_identifier"/>
                                        </xsl:when>
                                        <xsl:when test="$POG_NPI">
                                            <xsl:value-of select="../preceding-sibling::npi"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="../preceding-sibling::clia"/>                                                
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <!-- from Resource: id, meta, implicitRules, and language -->
                                <!-- from DomainResource: text, contained, extension, and modifierExtension -->
                                <id>
                                    <xsl:choose>
                                        <xsl:when test="./hash">
                                            <xsl:attribute name="value">

                                                <xsl:value-of
                                                  select="concat($POG_CUSTOMER_PREFIX, '-', ./hash)"
                                                />
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">

                                                <xsl:value-of
                                                  select="concat($POG_CUSTOMER_PREFIX, '-', $CODE, ./use, ./type)"
                                                />
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </id>
                                <xsl:call-template name="pog_meta_security_organization"/>
                                <xsl:if test="$POG_NPI">
                                    <identifier>
                                        <type>
                                            <coding>
                                                <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                                                <system>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'http://terminology.hl7.org/CodeSystem/v2-0203'"
                                                        />
                                                    </xsl:attribute>
                                                    
                                                </system>
                                                <code>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="'NPI'"/>
                                                    </xsl:attribute>
                                                </code>
                                                <display>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'National Provider Identifier'"/>
                                                    </xsl:attribute>
                                                </display>
                                                
                                            </coding>
                                            
                                        </type>
                                        
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://hl7.org/fhir/sid/us-npi'"/>
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::npi"/>
                                            </xsl:attribute>
                                        </value>
                                        
                                    </identifier>
                                </xsl:if>
                                <xsl:if test="$POG_UNIQUE_ID">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('https://data.healthlx.com/', 'ID', '-', $POG_CUSTOMER_PREFIX)"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ../preceding-sibling::unique_identifier)"
                                                />
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                <xsl:if test="$POG_CLIA">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://terminology.hl7.org/NamingSystem/CLIA'"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::clia"/>
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>


                                <status>
                                    <!-- 0..1 active | suspended | inactive -->
                                    <xsl:choose>
                                        <xsl:when
                                            test="$POG_PROVIDER_DEMOGRAPHIC/is_active = 'true'">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'active'"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'inactive'"/>
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </status>
                                <operationalStatus><!-- 0..1 Coding The operational status of the location (typically only for a bed/room) --></operationalStatus>
                                <name>
                                    <!-- 0..1 Name of the location as used by humans -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="../preceding-sibling::name"/>
                                    </xsl:attribute>
                                </name>
                                <type>
                                    <coding>
                                        <system
                                            value="http://terminology.hl7.org/CodeSystem/v3-RoleCode"/>
                                        <code value="HOSP"/>
                                    </coding>
                                </type>
                                <alia/>
                                <!-- 0..* A list of alternate names that the location is known as, or was known as, in the past -->
                                <description>
                                    <!-- 0..1 Additional details about the location that could be displayed as further information to identify the location beyond its name -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="$POG_PROVIDER_DEMOGRAPHIC[1]/codes/code[1]/display"
                                        />
                                    </xsl:attribute>
                                </description>
                                <mode><!-- 0..1 instance | kind -->
                                </mode>
                                <type><!-- 0..* CodeableConcept Type of function performed --></type>
                                <!-- 0..* ContactPoint Contact details of the location -->


                                <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/telecoms/telecom">
                                    <telecom>
                                        <xsl:for-each
                                            select="./contactpoint_available_times/contactpoint_available_time">
                                            <extension
                                                url="http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/contactpoint-availabletime">
                                                <extension url="daysOfWeek">

                                                  <valueCode>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./days_of_week"/>
                                                  </xsl:attribute>
                                                  </valueCode>
                                                </extension>
                                                <extension url="availableStartTime">
                                                  <valueTime>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./available_start_time"/>
                                                  </xsl:attribute>
                                                  </valueTime>
                                                </extension>
                                                <extension url="availableEndTime">
                                                  <valueTime>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./available_end_time"/>
                                                  </xsl:attribute>
                                                  </valueTime>
                                                </extension>
                                            </extension>



                                        </xsl:for-each>
                                        <use>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./use"/>
                                            </xsl:attribute>
                                        </use>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./value"/>
                                            </xsl:attribute>
                                        </value>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./system"/>
                                            </xsl:attribute>
                                        </system>

                                    </telecom>

                                </xsl:for-each>

                                <address>
                                    <use>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./use"/>
                                        </xsl:attribute>
                                    </use>
                                    <line>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./line"/>
                                        </xsl:attribute>
                                    </line>
                                    <city>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./city"/>
                                        </xsl:attribute>
                                    </city>
                                    <district>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./district"/>
                                        </xsl:attribute>
                                    </district>
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
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./country"/>
                                        </xsl:attribute>
                                    </country>
                                </address>

                                <!--   <physicalType><!-\- 0..1 CodeableConcept Physical form of the location -\->
                                
                                    <coding>
                                        <system value="http://terminology.hl7.org/CodeSystem/claim-type"/>
                                        <code>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$EOB_DEMOGRAPHIC/type"/>
                                            </xsl:attribute>
                                        </code>
                                    </coding>
                                
                                </physicalType>-->
                                <!-- <position>  <!-\- 0..1 The absolute geographic location -\->
                                    <longitude value="[decimal]"/><!-\- 1..1 Longitude with WGS84 datum -\->
                                    <latitude value="[decimal]"/><!-\- 1..1 Latitude with WGS84 datum -\->
                                    <altitude value="[decimal]"/><!-\- 0..1 Altitude with WGS84 datum -\->
                                </position>-->
                                <managingOrganization>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', $CODE)"
                                            />
                                        </xsl:attribute>
                                    </reference>
                                </managingOrganization>

                                <!-- 0..1 Reference(Organization) Organization responsible for provisioning and upkeep -->
                                <!-- 1..1 Reference(Patient) The recipient of the products and services -->


                            </Location>
                    </xsl:for-each>
                    </xsl:if>
                    <xsl:for-each select="$POG_PROVIDER/practitioner/affiliated_organization/addresses/address">
                        <xsl:if test="./type != 'postal'">
                            <Location xmlns="http://hl7.org/fhir">
                                <xsl:variable name="CODE">
                                    <xsl:choose>
                                        <xsl:when test="$POG_UNIQUE_ID">
                                            <xsl:value-of select="../preceding-sibling::unique_identifier"/>
                                        </xsl:when>
                                        <xsl:when test="$POG_NPI">
                                            <xsl:value-of select="../preceding-sibling::npi"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="../preceding-sibling::clia"/>                                                
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <!-- from Resource: id, meta, implicitRules, and language -->
                                <!-- from DomainResource: text, contained, extension, and modifierExtension -->
                                <id>
                                    <xsl:choose>
                                        <xsl:when test="./hash">
                                            <xsl:attribute name="value">

                                                <xsl:value-of
                                                  select="concat($POG_CUSTOMER_PREFIX, '-', ./hash)"
                                                />
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">

                                                <xsl:value-of
                                                  select="concat($POG_CUSTOMER_PREFIX, '-', $CODE, ./use, ./type)"
                                                />
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </id>
                                <xsl:call-template name="pog_meta_security_organization"/>
                                <xsl:if test="$POG_NPI">
                                    <identifier>
                                        <type>
                                            <coding>
                                                <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                                                <system>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'http://terminology.hl7.org/CodeSystem/v2-0203'"
                                                        />
                                                    </xsl:attribute>
                                                    
                                                </system>
                                                <code>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="'NPI'"/>
                                                    </xsl:attribute>
                                                </code>
                                                <display>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'National Provider Identifier'"/>
                                                    </xsl:attribute>
                                                </display>
                                                
                                            </coding>
                                            
                                        </type>
                                        
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://hl7.org/fhir/sid/us-npi'"/>
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::npi"/>
                                            </xsl:attribute>
                                        </value>
                                        
                                    </identifier>
                                </xsl:if>
                                <xsl:if test="$POG_UNIQUE_ID">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('https://data.healthlx.com/', 'ID', '-', $POG_CUSTOMER_PREFIX)"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ../preceding-sibling::unique_identifier)"
                                                />
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                <xsl:if test="$POG_CLIA">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://terminology.hl7.org/NamingSystem/CLIA'"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::clia"/>
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>


                                <status>
                                    <!-- 0..1 active | suspended | inactive -->
                                    <xsl:choose>
                                        <xsl:when
                                            test="$POG_PROVIDER_DEMOGRAPHIC/is_active = 'true'">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'active'"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'inactive'"/>
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </status>
                                <operationalStatus><!-- 0..1 Coding The operational status of the location (typically only for a bed/room) --></operationalStatus>
                                <name>
                                    <!-- 0..1 Name of the location as used by humans -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="../preceding-sibling::name"/>
                                    </xsl:attribute>
                                </name>
                                <type>
                                    <coding>
                                        <system
                                            value="http://terminology.hl7.org/CodeSystem/v3-RoleCode"/>
                                        <code value="HOSP"/>
                                    </coding>
                                </type>
                                <alia/>
                                <!-- 0..* A list of alternate names that the location is known as, or was known as, in the past -->
                                <description>
                                    <!-- 0..1 Additional details about the location that could be displayed as further information to identify the location beyond its name -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="$POG_PROVIDER_DEMOGRAPHIC[1]/codes/code[1]/display"
                                        />
                                    </xsl:attribute>
                                </description>
                                <mode><!-- 0..1 instance | kind -->
                                </mode>
                                <type><!-- 0..* CodeableConcept Type of function performed --></type>
                                <!-- 0..* ContactPoint Contact details of the location -->


                                <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/telecoms/telecom">
                                    <telecom>
                                        <xsl:for-each
                                            select="./contactpoint_available_times/contactpoint_available_time">
                                            <extension
                                                url="http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/contactpoint-availabletime">
                                                <extension url="daysOfWeek">

                                                  <valueCode>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./days_of_week"/>
                                                  </xsl:attribute>
                                                  </valueCode>
                                                </extension>
                                                <extension url="availableStartTime">
                                                  <valueTime>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./available_start_time"/>
                                                  </xsl:attribute>
                                                  </valueTime>
                                                </extension>
                                                <extension url="availableEndTime">
                                                  <valueTime>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="./available_end_time"/>
                                                  </xsl:attribute>
                                                  </valueTime>
                                                </extension>
                                            </extension>



                                        </xsl:for-each>
                                        <use>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./use"/>
                                            </xsl:attribute>
                                        </use>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./value"/>
                                            </xsl:attribute>
                                        </value>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./system"/>
                                            </xsl:attribute>
                                        </system>

                                    </telecom>

                                </xsl:for-each>

                                <address>
                                    <use>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./use"/>
                                        </xsl:attribute>
                                    </use>
                                    <line>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./line"/>
                                        </xsl:attribute>
                                    </line>
                                    <city>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./city"/>
                                        </xsl:attribute>
                                    </city>
                                    <district>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./district"/>
                                        </xsl:attribute>
                                    </district>
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
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./country"/>
                                        </xsl:attribute>
                                    </country>
                                </address>

                                <!--   <physicalType><!-\- 0..1 CodeableConcept Physical form of the location -\->
                                
                                    <coding>
                                        <system value="http://terminology.hl7.org/CodeSystem/claim-type"/>
                                        <code>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$EOB_DEMOGRAPHIC/type"/>
                                            </xsl:attribute>
                                        </code>
                                    </coding>
                                
                                </physicalType>-->
                                <!-- <position>  <!-\- 0..1 The absolute geographic location -\->
                                    <longitude value="[decimal]"/><!-\- 1..1 Longitude with WGS84 datum -\->
                                    <latitude value="[decimal]"/><!-\- 1..1 Latitude with WGS84 datum -\->
                                    <altitude value="[decimal]"/><!-\- 0..1 Altitude with WGS84 datum -\->
                                </position>-->
                                <managingOrganization>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', $CODE)"
                                            />
                                        </xsl:attribute>
                                    </reference>
                                </managingOrganization>

                                <!-- 0..1 Reference(Organization) Organization responsible for provisioning and upkeep -->
                                <!-- 1..1 Reference(Patient) The recipient of the products and services -->


                            </Location>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$POG_PROVIDER/practitioner/healthcare_services/healthcare_service/locations/location/address">
                        <xsl:if test="./type != 'postal'">
                            <Location xmlns="http://hl7.org/fhir">
                                <xsl:variable name="CODE">
                                    <xsl:choose>
                                        <xsl:when test="$POG_UNIQUE_ID">
                                            <xsl:value-of select="../preceding-sibling::unique_identifier"/>
                                        </xsl:when>
                                        <xsl:when test="$POG_NPI">
                                            <xsl:value-of select="../preceding-sibling::npi"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="../preceding-sibling::clia"/>                                                
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <!-- from Resource: id, meta, implicitRules, and language -->
                                <!-- from DomainResource: text, contained, extension, and modifierExtension -->
                                <id>
                                    <xsl:choose>
                                        <xsl:when test="./hash">
                                            <xsl:attribute name="value">
                                                
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ./hash)"
                                                />
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', $CODE, ./use, ./type)"
                                                />
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </id>
                                <xsl:call-template name="pog_meta_security_organization"/>
                                <xsl:if test="$POG_NPI">
                                    <identifier>
                                        <type>
                                            <coding>
                                                <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                                                <system>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'http://terminology.hl7.org/CodeSystem/v2-0203'"
                                                        />
                                                    </xsl:attribute>
                                                    
                                                </system>
                                                <code>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="'NPI'"/>
                                                    </xsl:attribute>
                                                </code>
                                                <display>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'National Provider Identifier'"/>
                                                    </xsl:attribute>
                                                </display>
                                                
                                            </coding>
                                            
                                        </type>
                                        
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://hl7.org/fhir/sid/us-npi'"/>
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::npi"/>
                                            </xsl:attribute>
                                        </value>
                                        
                                    </identifier>
                                </xsl:if>
                                <xsl:if test="$POG_UNIQUE_ID">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('https://data.healthlx.com/', 'ID', '-', $POG_CUSTOMER_PREFIX)"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ../preceding-sibling::unique_identifier)"
                                                />
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                <xsl:if test="$POG_CLIA">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://terminology.hl7.org/NamingSystem/CLIA'"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::clia"/>
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                
                                <status>
                                    <!-- 0..1 active | suspended | inactive -->
                                    <xsl:choose>
                                        <xsl:when
                                            test="$POG_PROVIDER_DEMOGRAPHIC/is_active = 'true'">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'active'"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'inactive'"/>
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </status>
                                <operationalStatus><!-- 0..1 Coding The operational status of the location (typically only for a bed/room) --></operationalStatus>
                                <name>
                                    <!-- 0..1 Name of the location as used by humans -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="../preceding-sibling::name"/>
                                    </xsl:attribute>
                                </name>
                                <type>
                                    <coding>
                                        <system
                                            value="http://terminology.hl7.org/CodeSystem/v3-RoleCode"/>
                                        <code value="HOSP"/>
                                    </coding>
                                </type>
                                <alia/>
                                <!-- 0..* A list of alternate names that the location is known as, or was known as, in the past -->
                                <description>
                                    <!-- 0..1 Additional details about the location that could be displayed as further information to identify the location beyond its name -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="$POG_PROVIDER_DEMOGRAPHIC[1]/codes/code[1]/display"
                                        />
                                    </xsl:attribute>
                                </description>
                                <mode><!-- 0..1 instance | kind -->
                                </mode>
                                <type><!-- 0..* CodeableConcept Type of function performed --></type>
                                <!-- 0..* ContactPoint Contact details of the location -->
                                
                                
                                <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/telecoms/telecom">
                                    <telecom>
                                        <xsl:for-each
                                            select="./contactpoint_available_times/contactpoint_available_time">
                                            <extension
                                                url="http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/contactpoint-availabletime">
                                                <extension url="daysOfWeek">
                                                    
                                                    <valueCode>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./days_of_week"/>
                                                        </xsl:attribute>
                                                    </valueCode>
                                                </extension>
                                                <extension url="availableStartTime">
                                                    <valueTime>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./available_start_time"/>
                                                        </xsl:attribute>
                                                    </valueTime>
                                                </extension>
                                                <extension url="availableEndTime">
                                                    <valueTime>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./available_end_time"/>
                                                        </xsl:attribute>
                                                    </valueTime>
                                                </extension>
                                            </extension>
                                            
                                            
                                            
                                        </xsl:for-each>
                                        <use>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./use"/>
                                            </xsl:attribute>
                                        </use>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./value"/>
                                            </xsl:attribute>
                                        </value>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./system"/>
                                            </xsl:attribute>
                                        </system>
                                        
                                    </telecom>
                                    
                                </xsl:for-each>
                                
                                <address>
                                    <use>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./use"/>
                                        </xsl:attribute>
                                    </use>
                                    <line>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./line"/>
                                        </xsl:attribute>
                                    </line>
                                    <city>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./city"/>
                                        </xsl:attribute>
                                    </city>
                                    <district>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./district"/>
                                        </xsl:attribute>
                                    </district>
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
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./country"/>
                                        </xsl:attribute>
                                    </country>
                                </address>
                                
                                <!--   <physicalType><!-\- 0..1 CodeableConcept Physical form of the location -\->
                                
                                    <coding>
                                        <system value="http://terminology.hl7.org/CodeSystem/claim-type"/>
                                        <code>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$EOB_DEMOGRAPHIC/type"/>
                                            </xsl:attribute>
                                        </code>
                                    </coding>
                                
                                </physicalType>-->
                                <!-- <position>  <!-\- 0..1 The absolute geographic location -\->
                                    <longitude value="[decimal]"/><!-\- 1..1 Longitude with WGS84 datum -\->
                                    <latitude value="[decimal]"/><!-\- 1..1 Latitude with WGS84 datum -\->
                                    <altitude value="[decimal]"/><!-\- 0..1 Altitude with WGS84 datum -\->
                                </position>-->
                                <managingOrganization>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', $CODE)"
                                            />
                                        </xsl:attribute>
                                    </reference>
                                </managingOrganization>
                                
                                <!-- 0..1 Reference(Organization) Organization responsible for provisioning and upkeep -->
                                <!-- 1..1 Reference(Patient) The recipient of the products and services -->
                                
                                
                            </Location>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$POG_PROVIDER/practitioner/part_of/addresses/address">
                        <xsl:if test="./type != 'postal'">
                            <Location xmlns="http://hl7.org/fhir">
                                <xsl:variable name="CODE">
                                    <xsl:choose>
                                        <xsl:when test="$POG_UNIQUE_ID">
                                            <xsl:value-of select="../preceding-sibling::unique_identifier"/>
                                        </xsl:when>
                                        <xsl:when test="$POG_NPI">
                                            <xsl:value-of select="../preceding-sibling::npi"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="../preceding-sibling::clia"/>                                                
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <!-- from Resource: id, meta, implicitRules, and language -->
                                <!-- from DomainResource: text, contained, extension, and modifierExtension -->
                                <id>
                                    <xsl:choose>
                                        <xsl:when test="./hash">
                                            <xsl:attribute name="value">
                                                
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ./hash)"
                                                />
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', $CODE, ./use, ./type)"
                                                />
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </id>
                                <xsl:call-template name="pog_meta_security_organization"/>
                                <xsl:if test="$POG_NPI">
                                    <identifier>
                                        <type>
                                            <coding>
                                                <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                                                <system>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'http://terminology.hl7.org/CodeSystem/v2-0203'"
                                                        />
                                                    </xsl:attribute>
                                                    
                                                </system>
                                                <code>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="'NPI'"/>
                                                    </xsl:attribute>
                                                </code>
                                                <display>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'National Provider Identifier'"/>
                                                    </xsl:attribute>
                                                </display>
                                                
                                            </coding>
                                            
                                        </type>
                                        
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://hl7.org/fhir/sid/us-npi'"/>
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::npi"/>
                                            </xsl:attribute>
                                        </value>
                                        
                                    </identifier>
                                </xsl:if>
                                <xsl:if test="$POG_UNIQUE_ID">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('https://data.healthlx.com/', 'ID', '-', $POG_CUSTOMER_PREFIX)"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ../preceding-sibling::unique_identifier)"
                                                />
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                <xsl:if test="$POG_CLIA">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://terminology.hl7.org/NamingSystem/CLIA'"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::clia"/>
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                
                                <status>
                                    <!-- 0..1 active | suspended | inactive -->
                                    <xsl:choose>
                                        <xsl:when
                                            test="$POG_PROVIDER_DEMOGRAPHIC/is_active = 'true'">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'active'"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'inactive'"/>
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </status>
                                <operationalStatus><!-- 0..1 Coding The operational status of the location (typically only for a bed/room) --></operationalStatus>
                                <name>
                                    <!-- 0..1 Name of the location as used by humans -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="../preceding-sibling::name"/>
                                    </xsl:attribute>
                                </name>
                                <type>
                                    <coding>
                                        <system
                                            value="http://terminology.hl7.org/CodeSystem/v3-RoleCode"/>
                                        <code value="HOSP"/>
                                    </coding>
                                </type>
                                <alia/>
                                <!-- 0..* A list of alternate names that the location is known as, or was known as, in the past -->
                                <description>
                                    <!-- 0..1 Additional details about the location that could be displayed as further information to identify the location beyond its name -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="$POG_PROVIDER_DEMOGRAPHIC[1]/codes/code[1]/display"
                                        />
                                    </xsl:attribute>
                                </description>
                                <mode><!-- 0..1 instance | kind -->
                                </mode>
                                <type><!-- 0..* CodeableConcept Type of function performed --></type>
                                <!-- 0..* ContactPoint Contact details of the location -->
                                
                                
                                <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/telecoms/telecom">
                                    <telecom>
                                        <xsl:for-each
                                            select="./contactpoint_available_times/contactpoint_available_time">
                                            <extension
                                                url="http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/contactpoint-availabletime">
                                                <extension url="daysOfWeek">
                                                    
                                                    <valueCode>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./days_of_week"/>
                                                        </xsl:attribute>
                                                    </valueCode>
                                                </extension>
                                                <extension url="availableStartTime">
                                                    <valueTime>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./available_start_time"/>
                                                        </xsl:attribute>
                                                    </valueTime>
                                                </extension>
                                                <extension url="availableEndTime">
                                                    <valueTime>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./available_end_time"/>
                                                        </xsl:attribute>
                                                    </valueTime>
                                                </extension>
                                            </extension>
                                            
                                            
                                            
                                        </xsl:for-each>
                                        <use>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./use"/>
                                            </xsl:attribute>
                                        </use>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./value"/>
                                            </xsl:attribute>
                                        </value>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./system"/>
                                            </xsl:attribute>
                                        </system>
                                        
                                    </telecom>
                                    
                                </xsl:for-each>
                                
                                <address>
                                    <use>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./use"/>
                                        </xsl:attribute>
                                    </use>
                                    <line>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./line"/>
                                        </xsl:attribute>
                                    </line>
                                    <city>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./city"/>
                                        </xsl:attribute>
                                    </city>
                                    <district>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./district"/>
                                        </xsl:attribute>
                                    </district>
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
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./country"/>
                                        </xsl:attribute>
                                    </country>
                                </address>
                                
                                <!--   <physicalType><!-\- 0..1 CodeableConcept Physical form of the location -\->
                                
                                    <coding>
                                        <system value="http://terminology.hl7.org/CodeSystem/claim-type"/>
                                        <code>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$EOB_DEMOGRAPHIC/type"/>
                                            </xsl:attribute>
                                        </code>
                                    </coding>
                                
                                </physicalType>-->
                                <!-- <position>  <!-\- 0..1 The absolute geographic location -\->
                                    <longitude value="[decimal]"/><!-\- 1..1 Longitude with WGS84 datum -\->
                                    <latitude value="[decimal]"/><!-\- 1..1 Latitude with WGS84 datum -\->
                                    <altitude value="[decimal]"/><!-\- 0..1 Altitude with WGS84 datum -\->
                                </position>-->
                                <managingOrganization>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', $CODE)"
                                            />
                                        </xsl:attribute>
                                    </reference>
                                </managingOrganization>
                                
                                <!-- 0..1 Reference(Organization) Organization responsible for provisioning and upkeep -->
                                <!-- 1..1 Reference(Patient) The recipient of the products and services -->
                                
                                
                            </Location>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$POG_PROVIDER/practitioner/affiliated_organization/part_of/addresses/address">
                        <xsl:if test="./type != 'postal'">
                            <Location xmlns="http://hl7.org/fhir">
                                <xsl:variable name="CODE">
                                    <xsl:choose>
                                        <xsl:when test="$POG_UNIQUE_ID">
                                            <xsl:value-of select="../preceding-sibling::unique_identifier"/>
                                        </xsl:when>
                                        <xsl:when test="$POG_NPI">
                                            <xsl:value-of select="../preceding-sibling::npi"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="../preceding-sibling::clia"/>                                                
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <!-- from Resource: id, meta, implicitRules, and language -->
                                <!-- from DomainResource: text, contained, extension, and modifierExtension -->
                                <id>
                                    <xsl:choose>
                                        <xsl:when test="./hash">
                                            <xsl:attribute name="value">
                                                
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ./hash)"
                                                />
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', $CODE, ./use, ./type)"
                                                />
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </id>
                                <xsl:call-template name="pog_meta_security_organization"/>
                                <xsl:if test="$POG_NPI">
                                    <identifier>
                                        <type>
                                            <coding>
                                                <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                                                <system>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'http://terminology.hl7.org/CodeSystem/v2-0203'"
                                                        />
                                                    </xsl:attribute>
                                                    
                                                </system>
                                                <code>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="'NPI'"/>
                                                    </xsl:attribute>
                                                </code>
                                                <display>
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of
                                                            select="'National Provider Identifier'"/>
                                                    </xsl:attribute>
                                                </display>
                                                
                                            </coding>
                                            
                                        </type>
                                        
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://hl7.org/fhir/sid/us-npi'"/>
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::npi"/>
                                            </xsl:attribute>
                                        </value>
                                        
                                    </identifier>
                                </xsl:if>
                                <xsl:if test="$POG_UNIQUE_ID">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('https://data.healthlx.com/', 'ID', '-', $POG_CUSTOMER_PREFIX)"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat($POG_CUSTOMER_PREFIX, '-', ../preceding-sibling::unique_identifier)"
                                                />
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                <xsl:if test="$POG_CLIA">
                                    
                                    <identifier>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="'http://terminology.hl7.org/NamingSystem/CLIA'"
                                                />
                                            </xsl:attribute>
                                        </system>
                                        <value>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="../preceding-sibling::clia"/>
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                                
                                
                                <status>
                                    <!-- 0..1 active | suspended | inactive -->
                                    <xsl:choose>
                                        <xsl:when
                                            test="$POG_PROVIDER_DEMOGRAPHIC/is_active = 'true'">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'active'"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="'inactive'"/>
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </status>
                                <operationalStatus><!-- 0..1 Coding The operational status of the location (typically only for a bed/room) --></operationalStatus>
                                <name>
                                    <!-- 0..1 Name of the location as used by humans -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="../preceding-sibling::name"/>
                                    </xsl:attribute>
                                </name>
                                <type>
                                    <coding>
                                        <system
                                            value="http://terminology.hl7.org/CodeSystem/v3-RoleCode"/>
                                        <code value="HOSP"/>
                                    </coding>
                                </type>
                                <alia/>
                                <!-- 0..* A list of alternate names that the location is known as, or was known as, in the past -->
                                <description>
                                    <!-- 0..1 Additional details about the location that could be displayed as further information to identify the location beyond its name -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="$POG_PROVIDER_DEMOGRAPHIC[1]/codes/code[1]/display"
                                        />
                                    </xsl:attribute>
                                </description>
                                <mode><!-- 0..1 instance | kind -->
                                </mode>
                                <type><!-- 0..* CodeableConcept Type of function performed --></type>
                                <!-- 0..* ContactPoint Contact details of the location -->
                                
                                
                                <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/telecoms/telecom">
                                    <telecom>
                                        <xsl:for-each
                                            select="./contactpoint_available_times/contactpoint_available_time">
                                            <extension
                                                url="http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/contactpoint-availabletime">
                                                <extension url="daysOfWeek">
                                                    
                                                    <valueCode>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./days_of_week"/>
                                                        </xsl:attribute>
                                                    </valueCode>
                                                </extension>
                                                <extension url="availableStartTime">
                                                    <valueTime>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./available_start_time"/>
                                                        </xsl:attribute>
                                                    </valueTime>
                                                </extension>
                                                <extension url="availableEndTime">
                                                    <valueTime>
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="./available_end_time"/>
                                                        </xsl:attribute>
                                                    </valueTime>
                                                </extension>
                                            </extension>
                                            
                                            
                                            
                                        </xsl:for-each>
                                        <use>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./use"/>
                                            </xsl:attribute>
                                        </use>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./value"/>
                                            </xsl:attribute>
                                        </value>
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./system"/>
                                            </xsl:attribute>
                                        </system>
                                        
                                    </telecom>
                                    
                                </xsl:for-each>
                                
                                <address>
                                    <use>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./use"/>
                                        </xsl:attribute>
                                    </use>
                                    <line>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./line"/>
                                        </xsl:attribute>
                                    </line>
                                    <city>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./city"/>
                                        </xsl:attribute>
                                    </city>
                                    <district>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./district"/>
                                        </xsl:attribute>
                                    </district>
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
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./country"/>
                                        </xsl:attribute>
                                    </country>
                                </address>
                                
                                <!--   <physicalType><!-\- 0..1 CodeableConcept Physical form of the location -\->
                                
                                    <coding>
                                        <system value="http://terminology.hl7.org/CodeSystem/claim-type"/>
                                        <code>
                                            
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$EOB_DEMOGRAPHIC/type"/>
                                            </xsl:attribute>
                                        </code>
                                    </coding>
                                
                                </physicalType>-->
                                <!-- <position>  <!-\- 0..1 The absolute geographic location -\->
                                    <longitude value="[decimal]"/><!-\- 1..1 Longitude with WGS84 datum -\->
                                    <latitude value="[decimal]"/><!-\- 1..1 Latitude with WGS84 datum -\->
                                    <altitude value="[decimal]"/><!-\- 0..1 Altitude with WGS84 datum -\->
                                </position>-->
                                <managingOrganization>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', $CODE)"
                                            />
                                        </xsl:attribute>
                                    </reference>
                                </managingOrganization>
                                
                                <!-- 0..1 Reference(Organization) Organization responsible for provisioning and upkeep -->
                                <!-- 1..1 Reference(Patient) The recipient of the products and services -->
                                
                                
                            </Location>
                        </xsl:if>
                    </xsl:for-each>
                    
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="exists($locs[1])">
                <xsl:sequence select="$locs[1]"/>
            </xsl:when>
            <xsl:otherwise>
                <Location xmlns="http://hl7.org/fhir"/>
            </xsl:otherwise>
        </xsl:choose>


    </xsl:template>


    <xsl:template name="pog_meta_security_organization">
        <meta>
            <xsl:variable name="EOB_PARENTFILE_NAME" select="$POG_PROVIDER/parentfile"/>
            <source>
                <xsl:attribute name="value">
                    <xsl:value-of select="$EOB_PARENTFILE_NAME"/>
                </xsl:attribute>
            </source>
        </meta>
    </xsl:template>
    
    <xsl:template name="pog_telcom_provider_organization"> </xsl:template>

</xsl:stylesheet>
