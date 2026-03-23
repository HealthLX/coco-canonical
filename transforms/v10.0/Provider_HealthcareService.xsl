<xsl:stylesheet version="3.0"
    xmlns="http://hl7.org/fhir"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:coco="http://cocodata.org"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://cocodata.org"
    exclude-result-prefixes="coco">

    <xsl:variable name="POG_PROVIDER" select="/provider"/>
    <xsl:variable name="POG_CUSTOMER_PREFIX" select="$POG_PROVIDER/customername"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="POG_PROVIDER_DEMOGRAPHIC">
        <xsl:choose>
            <xsl:when test="$POG_PROVIDER/providing_organization">
                <xsl:value-of select="$POG_PROVIDER/providing_organization"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="practitioner"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="POG_PROVIDER_LOCATIONS"
        select="$POG_PROVIDER_DEMOGRAPHIC/locations/location"/>
    <xsl:variable name="POG_CLIA" select="$POG_PROVIDER/providing_organization/clia"/>
    <xsl:variable name="POG_NPI">
        <xsl:choose>
            <xsl:when test="$POG_PROVIDER/providing_organization/npi">
                <xsl:value-of select="$POG_PROVIDER/providing_organization/npi"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="practitioner/npi"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    

    <xsl:template match="provider">



        <xsl:choose>
            <xsl:when test="//healthcare_services/healthcare_service">

                <HealthcareServices>



                    <xsl:for-each select="//healthcare_services/healthcare_service">
                        <HealthcareService xmlns="http://hl7.org/fhir">
                            <id>
                                <xsl:choose>
                                    <xsl:when test="$POG_NPI">
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat($POG_CUSTOMER_PREFIX, '-', $POG_NPI, '-', position())"
                                            />
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat($POG_CUSTOMER_PREFIX, '-', $POG_CLIA, '-', position())"
                                            />
                                        </xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </id>
                            <!-- from Resource: id, meta, implicitRules, and language -->
                            <!-- from DomainResource: text, contained, extension, and modifierExtension -->
                            <xsl:call-template name="pog_meta_security_organization"/>
                            <contained>
                                <xsl:call-template name="pog_contained_locations"/>
                            </contained>
                            <xsl:if test="$POG_CLIA">
                                <identifier>
                                    <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                                    <system>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('https://data.healthlx.com/', 'ORG_ID', '-', $POG_CUSTOMER_PREFIX)"
                                            />
                                        </xsl:attribute>
                                    </system>
                                    <value>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat($POG_CUSTOMER_PREFIX, '-', $POG_CLIA)"
                                            />
                                        </xsl:attribute>
                                    </value>
                                </identifier>
                            </xsl:if>
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
                                            <xsl:value-of select="'http://hl7.org/fhir/sid/us-npi'"
                                            />
                                        </xsl:attribute>
                                    </system>
                                    <value>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="$POG_NPI"/>
                                        </xsl:attribute>
                                    </value>
                                </identifier>
                            </xsl:if>
                            <active>
                                <!-- 0..1 Whether this HealthcareService record is in active use -->
                                <xsl:attribute name="value">
                                    <xsl:value-of select="'true'"/>
                                </xsl:attribute>
                            </active>
                            <providedBy>
                                <!-- 0..1 Reference(Organization) Organization that provides this service -->
                                <xsl:choose>
                                    <xsl:when test="$POG_NPI">
                                        <reference>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                  select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', $POG_NPI)"
                                                />
                                            </xsl:attribute>
                                        </reference>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <reference>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                  select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', $POG_CLIA)"
                                                />
                                            </xsl:attribute>
                                        </reference>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </providedBy>
                            <category>
                                <!-- 0..* CodeableConcept Broad category of service being performed or delivered -->
                                <!--<coding> 
                <system value="http://terminology.hl7.org/CodeSystem/service-category"/> 
                <code value="8"/> 
                <display value="Counselling"/> 
            </coding> 
            <text value="Counselling"/> -->
                                <coding>
                                    <system> </system>
                                    <code> </code>
                                    <display/>
                                </coding>
                                <text> </text>
                            </category>
                            <type>
                                <!-- 0..* CodeableConcept Type of service that may be delivered or performed -->
                                <!--<coding> 
                <system value="http://terminology.hl7.org/CodeSystem/service-category"/> 
                <code value="8"/> 
                <display value="Counselling"/> 
            </coding> 
            <text value="Counselling"/>  -->
                                <coding>
                                    <system> </system>
                                    <code> </code>
                                    <display/>
                                </coding>
                                <text> </text>
                            </type>
                            <specialty><!-- 0..* CodeableConcept Specialties handled by the HealthcareService -->
                                <!--    <coding> 
                <system value="http://snomed.info/sct"/> 
                <code value="47505003"/> 
                <display value="Posttraumatic stress disorder"/> 
            </coding> -->
                            </specialty>



                            <!-- 0..* Reference(Location) Location(s) where service may be provided -->

                            <xsl:for-each select="./locations/location">
                                <location>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('#', ./address/use, ./address/type, 'Location_Derived1')"
                                            />
                                        </xsl:attribute>
                                    </reference>
                                </location>
                            </xsl:for-each>
                            <name>
                                <!-- 0..1 Description of service as presented to a consumer while searching -->
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$POG_PROVIDER_DEMOGRAPHIC/name"/>
                                </xsl:attribute>
                            </name>
                            <!--    
        <comment value="[string]"/><!-\- 0..1 Additional description and/or any specific issues not covered elsewhere -\->
        <extraDetails value="[markdown]"/><!-\- 0..1 Extra details about the service that can't be placed in the other fields -\->
     -->
                            <photo><!-- 0..1 Attachment Facilitates quick identification of the service --></photo>

                            <xsl:for-each select="./telecoms/telecom">
                                <telecom>
                                    <!-- 0..* ContactPoint Contacts related to the healthcare service -->
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

                            <!-- <coverageArea><!-\- 0..* Reference(Location) Location(s) service is intended for/available to -\-></coverageArea>
        <serviceProvisionCode><!-\- 0..* CodeableConcept Conditions under which service is available/offered -\-></serviceProvisionCode>
        <eligibility>  <!-\- 0..* Specific eligibility requirements required to use the service -\->
            <code><!-\- 0..1 CodeableConcept Coded value for the eligibility -\-></code>
            <comment value="[markdown]"/><!-\- 0..1 Describes the eligibility conditions for the service -\->
        </eligibility>
        <program><!-\- 0..* CodeableConcept Programs that this service is applicable to -\-></program>
     -->
                            <!-- <Wheelchair_Accessible>Y</Wheelchair_Accessible>
        <Restroom_Handicap_Accessible>Y</Restroom_Handicap_Accessible>
        <Parking_Handicap_Access>Y</Parking_Handicap_Access>
        <Building_Handicap_Access>Y</Building_Handicap_Access>
        <TTY_Disability_Services></TTY_Disability_Services>
        <Mental___Physical_Disability_Services></Mental___Physical_Disability_Services>
        <Sign_Language_Services>N</Sign_Language_Services>
        <type>Durable Medical Equipment</type>
        <Email_Address></Email_Address>
        <Website>www.180medical.com</Website>
        <Accept_New_Patients>Y</Accept_New_Patients>
        <Medicare></Medicare>
        <Medicaid></Medicaid>
       -->

                            <xsl:for-each select="./characteristics/characteristic">
                                <xsl:if test="contains(./display, 'Wheelchair_')">
                                    <characteristic>
                                        <!-- 0..* CodeableConcept Collection of characteristics (attributes) -->
                                        <coding>
                                            <display value="Wheelchair access"/>
                                        </coding>
                                    </characteristic>
                                </xsl:if>
                                <xsl:if test="contains(./display, 'Restroom_')">
                                    <characteristic>
                                        <!-- 0..* CodeableConcept Collection of characteristics (attributes) -->
                                        <coding>
                                            <display value="Restroom Handicap Accessible"/>
                                        </coding>
                                    </characteristic>
                                </xsl:if>
                                <xsl:if test="contains(./display, 'Parking_')">
                                    <characteristic>
                                        <!-- 0..* CodeableConcept Collection of characteristics (attributes) -->
                                        <coding>
                                            <display value="Parking Handicap Access"/>
                                        </coding>
                                    </characteristic>
                                </xsl:if>
                                <xsl:if test="contains(./display, 'Mental_')">
                                    <characteristic>
                                        <!-- 0..* CodeableConcept Collection of characteristics (attributes) -->
                                        <coding>
                                            <display value="Mental Physical Disability Services"/>
                                        </coding>
                                    </characteristic>
                                </xsl:if>
                            </xsl:for-each>

                            <communication><!-- 0..* CodeableConcept The language that this service is offered in --></communication>
                            <referralMethod><!-- 0..* CodeableConcept Ways that the service accepts referrals --></referralMethod>
                            <!--    <appointmentRequired value="[boolean]"/><!-\- 0..1 If an appointment is required for access to this service -\->
   -->

                            <xsl:for-each
                                select="./available_times/available_time">
                                <availableTime>
                                    <!-- 0..* Times the Service Site is available -->
                                    <daysOfWeek>
                                        <!-- 0..* mon | tue | wed | thu | fri | sat | sun -->
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./days_of_week"/>
                                        </xsl:attribute>
                                    </daysOfWeek>
                                    <allDay>
                                        <!-- 0..1 Always available? e.g. 24 hour service -->
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./all_day"/>
                                        </xsl:attribute>
                                    </allDay>
                                    <xsl:if test="./all_day = 'false'">
                                        <xsl:if test="./available_start_time">
                                            <availableStartTime>
                                                <!-- 0..1 Opening time of day (ignored if allDay = true) -->
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="./available_start_time"/>
                                                </xsl:attribute>
                                            </availableStartTime>
                                        </xsl:if>
                                        <xsl:if test="./available_end_time">
                                            <availableEndTime>
                                                <!-- 0..1 Closing time of day (ignored if allDay = true) -->
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="./available_end_time"/>
                                                </xsl:attribute>
                                            </availableEndTime>
                                        </xsl:if>
                                    </xsl:if>
                                </availableTime>
                            </xsl:for-each>


                            <!-- <notAvailable>  <!-\- 0..* Not available during this time due to provided reason -\->
                      <description value="[string]"/><!-\- 1..1 Reason presented to the user explaining why time not available -\->
                      <during><!-\- 0..1 Period Service not available from this date -\-></during>
                  </notAvailable>
                  <availabilityExceptions value="[string]"/><!-\- 0..1 Description of availability exceptions -\->
                  <endpoint><!-\- 0..* Reference(Endpoint) Technical endpoints providing access to electronic services operated for the healthcare service -\-></endpoint>
           -->
                        </HealthcareService>
                    </xsl:for-each>

                </HealthcareServices>
            </xsl:when>
            <xsl:otherwise>
                <HealthLX_remove_not_applicable>
                    <remove/>
                    <!--this will be removed after transformation-->
                </HealthLX_remove_not_applicable>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="pog_contained_locations">
        <xsl:for-each select="./locations/location">
            <!--         -->
            <Location>
                <id>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="concat(./address/use, ./address/type, 'Location_Derived1')"/>
                    </xsl:attribute>

                </id>

                <description>
                    <xsl:attribute name="value">
                        <xsl:value-of select="./description"/>

                    </xsl:attribute>
                </description>

                <xsl:for-each select="./identifiers/identifier">
                    <xsl:if test="./type">

                        <identifier>

                            <system>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="concat('https://data.healthlx.com/', $POG_CUSTOMER_PREFIX, ./type)"/>

                                </xsl:attribute>

                            </system>
                            <value>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./value"/>
                                </xsl:attribute>
                            </value>
                        </identifier>
                    </xsl:if>
                </xsl:for-each>

                <address>
                    <use>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./address/use"/>
                        </xsl:attribute>
                    </use>
                    <line>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./address/line"/>
                        </xsl:attribute>
                    </line>
                    <city>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./address/city"/>
                        </xsl:attribute>
                    </city>
                    <district>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./address/district"/>
                        </xsl:attribute>
                    </district>
                    <state>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./address/state"/>
                        </xsl:attribute>
                    </state>
                    <postalCode>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./address/postal_code"/>
                        </xsl:attribute>
                    </postalCode>

                    <country>
                        <xsl:value-of select="./address/country"/>
                    </country>
                </address>

                <mode value="instance"/>

                <physicalType>
                    <coding>
                        <code value="area"/>
                        <display value="Area"/>
                    </coding>
                </physicalType>
            </Location>
        </xsl:for-each>

    </xsl:template>
    <!--

-->




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




</xsl:stylesheet>
