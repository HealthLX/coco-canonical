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
    <xsl:variable name="POG_PROVIDER_DEMOGRAPHIC" select="$POG_PROVIDER/practitioner"/>
    <xsl:variable name="POG_PROVIDER_LOCATIONS" select="$POG_PROVIDER/practitioner/addresses"/>
    <xsl:variable name="POG_CUSTOMER_PREFIX" select="$POG_PROVIDER/customername"/>
    <xsl:variable name="POG_NPI" select="$POG_PROVIDER_DEMOGRAPHIC/npi"/>
    <xsl:variable name="POG_CLIA" select="$POG_PROVIDER_DEMOGRAPHIC/clia"/>
    <xsl:variable name="POG_UNIQUE_ID" select="$POG_PROVIDER_DEMOGRAPHIC/unique_identifier"/>

    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="provider">
        <!-- Single-resource output: emit only the first PractitionerRole (first network). -->
        <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/networks/network[1]">
            <xsl:variable name="CODE">
                <xsl:choose>
                    <xsl:when test="$POG_UNIQUE_ID">
                        <xsl:value-of select="$POG_UNIQUE_ID"/>
                    </xsl:when>
                    <xsl:when test="$POG_NPI">
                        <xsl:value-of select="$POG_NPI"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$POG_CLIA"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="POG_NETWORKID" select="./network_id"/>
            <PractitionerRole xmlns="http://hl7.org/fhir">
                    <xsl:call-template name="resource_id"/>

                    <meta>
                        <xsl:call-template name="pog_meta_security_practitionerrole"/>
                    </meta>


                    <extension
                        url="http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/network-reference">
                        <valueReference>
                            <reference>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', $POG_NETWORKID)"
                                    />
                                </xsl:attribute>
                            </reference>
                        </valueReference>
                    </extension>

                    <xsl:call-template name="resource_identifier"/>


                    <active>
                        <!--  value="[boolean]"0..1 Whether the organization's record is still in active use -->
                        <xsl:attribute name="value">
                            <xsl:value-of select="$POG_PROVIDER_DEMOGRAPHIC/is_active"/>
                        </xsl:attribute>
                    </active>
                    <xsl:variable name="CODE">
                        <xsl:choose>
                            <xsl:when test="$POG_UNIQUE_ID">
                                <xsl:value-of select="$POG_UNIQUE_ID"/>
                            </xsl:when>
                            <xsl:when test="$POG_NPI">
                                <xsl:value-of select="$POG_NPI"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$POG_CLIA"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <practitioner>
                        <reference>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="concat('Practitioner/', $POG_CUSTOMER_PREFIX, '-', $CODE)"
                                />
                            </xsl:attribute>
                        </reference>

                        <display>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$POG_PROVIDER_DEMOGRAPHIC/names/name/text"/>
                            </xsl:attribute>
                        </display>
                    </practitioner>
                    <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/codes/code">
                        <xsl:element name="code">
                            <xsl:if test="system or code or display">
                                <xsl:element name="coding">
                                    <xsl:if test="system">
                                        <xsl:element name="system">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="system"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="code">
                                        <xsl:element name="code">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="code"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="display">
                                        <xsl:element name="display">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="display"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="coding">
                                <xsl:element name="coding">
                                    <xsl:if test="coding/system">
                                        <xsl:element name="system">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="coding/system"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="coding/code">
                                        <xsl:element name="code">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="coding/code"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="coding/display">
                                        <xsl:element name="display">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="coding/display"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="text">
                                    <xsl:element name="text">
                                        <xsl:value-of select="text"/>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="coding">
                                            <xsl:if test="coding/display">
                                                <xsl:element name="text">
                                                  <xsl:value-of select="coding/display"/>
                                                </xsl:element>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:if test="display">
                                                <xsl:element name="text">
                                                  <xsl:value-of select="display"/>
                                                </xsl:element>
                                            </xsl:if>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:for-each>
                    <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/specialties/specialty">
                        <xsl:element name="specialty">
                            <xsl:choose>
                                <xsl:when test="system or code or display">
                                    <xsl:element name="coding">
                                        <xsl:if test="system">
                                            <xsl:element name="system">
                                                <xsl:attribute name="value">
                                                  <xsl:value-of select="system"/>
                                                </xsl:attribute>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="code">
                                            <xsl:element name="code">
                                                <xsl:attribute name="value">
                                                  <xsl:value-of select="code"/>
                                                </xsl:attribute>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="display">
                                            <xsl:element name="display">
                                                <xsl:attribute name="value">
                                                  <xsl:value-of select="display"/>
                                                </xsl:attribute>
                                            </xsl:element>
                                        </xsl:if>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when test="coding">
                                    <xsl:element name="coding">
                                        <xsl:if test="coding/system">
                                            <xsl:element name="system">
                                                <xsl:attribute name="value">
                                                  <xsl:value-of select="coding/system"/>
                                                </xsl:attribute>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="coding/code">
                                            <xsl:element name="code">
                                                <xsl:attribute name="value">
                                                  <xsl:value-of select="coding/code"/>
                                                </xsl:attribute>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="coding/display">
                                            <xsl:element name="display">
                                                <xsl:attribute name="value">
                                                  <xsl:value-of select="coding/display"/>
                                                </xsl:attribute>
                                            </xsl:element>
                                        </xsl:if>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="coding">
                                        <xsl:element name="code">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="."/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="text">
                                    <xsl:element name="text">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="text"/>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="coding">
                                            <xsl:if test="coding/display">
                                                <xsl:element name="text">
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="coding/display"/>
                                                  </xsl:attribute>
                                                </xsl:element>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:if test="display">
                                                <xsl:element name="text">
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="display"/>
                                                  </xsl:attribute>
                                                </xsl:element>
                                            </xsl:if>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:for-each>
                    <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/addresses/address">
                        <xsl:if test="./type != 'postal'">
                            <location>
                                <reference>
                                    <xsl:choose>
                                        <xsl:when test="./hash">
                                            <xsl:attribute name="value">

                                                <xsl:value-of
                                                  select="concat('Location/', $POG_CUSTOMER_PREFIX, '-', ./hash)"
                                                />
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">

                                                <xsl:value-of
                                                  select="concat('Location/', $POG_CUSTOMER_PREFIX, '-', $CODE, ./use, ./type)"
                                                />
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </reference>
                                <display>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./text"/>
                                    </xsl:attribute>
                                </display>
                            </location>
                        </xsl:if>
                    </xsl:for-each>

                    <!-- <healthcareService>
                        <!-\- 0..* Reference(HealthcareService) Healthcare services provided through the role -\->
                        <reference>
                            <xsl:attribute name="value">

                                <xsl:value-of
                                    select="concat('HealthcareService/', $POG_CUSTOMER_PREFIX, '-', $POG_NPI)"
                                />
                            </xsl:attribute>
                        </reference>                   </healthcareService>-->


                    <type>
                        <coding>
                            <system
                                value="http://hl7.org/fhir/us/davinci-pdex-plan-net/CodeSystem/OrgTypeCS"/>
                            <code value="ntwk"/>
                            <display value="Network"/>
                        </coding>
                    </type>
                    <name>
                        <text>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./name"/>
                            </xsl:attribute>
                        </text>
                    </name>
                    <!-- value="[string]"?? 0..1 Name used for the organization -->
                    <alias/>
                    <!--  value="[string]"0..* A list of alternate names that the organization is known as, or was known as in the past -->

                    <xsl:call-template name="pog_telcom_provider_organization"/>

                    <!-- ?? 0..* Address An address for the organization -->

                    <!--<xsl:call-template name="pog_address_provider_organization"/>-->

                    <partOf><!-- 0..1 Reference(Organization) The organization of which this organization forms a part -->
                        <!--    <reference>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', $POG_NPI)"/>
                    </xsl:attribute>
                </reference>
            -->
                    </partOf>
                    <contact>
                        <name>
                            <family>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="$POG_PROVIDER_DEMOGRAPHIC/names/name/family"/>
                                </xsl:attribute>
                            </family>
                            <given>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="$POG_PROVIDER_DEMOGRAPHIC/names/name/given"/>
                                </xsl:attribute>
                            </given>
                        </name>

                    </contact>

                    <code><!-- 1..1 CodeableConcept Coded representation of the qualification -->
                    </code>
                    <endpoint><!-- 0..* Reference(Endpoint) Technical endpoints providing access to services operated for the organization --></endpoint>
            </PractitionerRole>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="pog_meta_security_practitionerrole">
        <meta>
            <xsl:variable name="EOB_PARENTFILE_NAME" select="$POG_PROVIDER/parentfile"/>
            <source>
                <xsl:attribute name="value">
                    <xsl:value-of select="$EOB_PARENTFILE_NAME"/>
                </xsl:attribute>
            </source>

            <profile
                value="http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-Network"/>

        </meta>
    </xsl:template>

    <xsl:template name="pog_telcom_provider_organization">
        <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/telecoms/telecom">
            <telecom>
                <!-- ?? 0..1 phone | fax | email | pager | url | sms | other -->
                <system>
                    <xsl:attribute name="value">
                        <xsl:value-of select="system"/>
                    </xsl:attribute>
                </system>
                <!-- 0..1 The actual contact point details -->
                <value>
                    <xsl:attribute name="value">
                        <xsl:value-of select="value"/>
                    </xsl:attribute>
                </value>
                <xsl:if test="use">
                    <!-- 0..1 home | work | temp | old | mobile - purpose of this contact point -->
                    <use>
                        <xsl:attribute name="value">
                            <xsl:value-of select="use"/>
                        </xsl:attribute>
                    </use>
                </xsl:if>
                <xsl:if test="rank">
                    <!-- 0..1 Specify preferred order of use (1 = highest) -->
                    <rank>
                        <xsl:attribute name="value">
                            <xsl:value-of select="rank"/>
                        </xsl:attribute>
                    </rank>
                </xsl:if>
                <xsl:if test="period/start or period/end">
                    <!-- 0..1 Period Time period when the contact point was/is in use -->
                    <period>
                        <xsl:if test="period/start">
                            <start>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="period/start"/>
                                </xsl:attribute>
                            </start>
                        </xsl:if>
                        <xsl:if test="period/end">
                            <end>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="period/end"/>
                                </xsl:attribute>
                            </end>
                        </xsl:if>
                    </period>
                </xsl:if>
            </telecom>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="resource_id">
        <xsl:variable name="POG_NETWORKID" select="./network_id"/>

        <xsl:variable name="CODE">
            <xsl:choose>
                <xsl:when test="$POG_UNIQUE_ID">
                    <xsl:value-of select="$POG_UNIQUE_ID"/>
                </xsl:when>
                <xsl:when test="$POG_NPI">
                    <xsl:value-of select="$POG_NPI"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$POG_CLIA"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <id>
            <xsl:attribute name="value">
                <xsl:value-of select="concat($POG_CUSTOMER_PREFIX, '-', $POG_NETWORKID, '-', $CODE)"
                />
            </xsl:attribute>
        </id>

    </xsl:template>
    <xsl:template name="resource_identifier">
        <xsl:variable name="POG_NETWORKID" select="./network_id"/>

        <xsl:if test="$POG_NPI">
            <identifier>
                <type>
                    <coding>
                        <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                        <system>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="'http://terminology.hl7.org/CodeSystem/v2-0203'"/>
                            </xsl:attribute>

                        </system>
                        <code>
                            <xsl:attribute name="value">
                                <xsl:value-of select="'NPI'"/>
                            </xsl:attribute>
                        </code>
                        <display>
                            <xsl:attribute name="value">
                                <xsl:value-of select="'National Provider Identifier'"/>
                            </xsl:attribute>
                        </display>

                    </coding>

                </type>

                <system>
                    <xsl:attribute name="value">
                        <xsl:value-of select="'http://hl7.org/fhir/sid/us-npi'"/>
                    </xsl:attribute>
                </system>
                <value>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$POG_NPI"/>
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
                        <xsl:value-of select="concat($POG_CUSTOMER_PREFIX, '-', $POG_UNIQUE_ID)"/>
                    </xsl:attribute>
                </value>
            </identifier>
        </xsl:if>
        <xsl:if test="$POG_PROVIDER/practitioner/tax">
            <identifier>
                <system>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="concat('https://data.healthlx.com/', 'TAX', '-', $POG_CUSTOMER_PREFIX)"
                        />
                    </xsl:attribute>
                </system>
                <value>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="concat($POG_CUSTOMER_PREFIX, '-', $POG_PROVIDER/practitioner/tax)"
                        />
                    </xsl:attribute>
                </value>
            </identifier>
        </xsl:if>
        <xsl:if test="$POG_CLIA">

            <identifier>
                <system>
                    <xsl:attribute name="value">
                        <xsl:value-of select="'http://terminology.hl7.org/NamingSystem/CLIA'"/>
                    </xsl:attribute>
                </system>
                <value>

                    <xsl:attribute name="value">
                        <xsl:value-of select="$POG_CLIA"/>
                    </xsl:attribute>
                </value>
            </identifier>
        </xsl:if>

    </xsl:template>


</xsl:stylesheet>
