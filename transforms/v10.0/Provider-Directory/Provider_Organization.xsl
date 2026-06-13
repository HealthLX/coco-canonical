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
        <xsl:apply-templates select="/providers/provider[providing_organization]"/>
    </xsl:template>
    <xsl:template match="text()"/>

    <xsl:variable name="POG_PROVIDER" select="/providers/provider[providing_organization][1]"/>
    <xsl:variable name="POG_PROVIDER_DEMOGRAPHIC" select="$POG_PROVIDER/providing_organization"/>
    <xsl:variable name="POG_PROVIDER_LOCATIONS"
        select="$POG_PROVIDER/providing_organization/addresses"/>
    <xsl:variable name="POG_CUSTOMER_PREFIX" select="$POG_PROVIDER/customername"/>
    <xsl:variable name="POG_CLIA" select="$POG_PROVIDER_DEMOGRAPHIC/clia"/>
    <xsl:variable name="POG_CLIAS" select="$POG_PROVIDER_DEMOGRAPHIC/clias/clia"/>
    <xsl:variable name="POG_NPI" select="$POG_PROVIDER_DEMOGRAPHIC/npi"/>
    <xsl:variable name="POG_UNIQUE_ID" select="$POG_PROVIDER_DEMOGRAPHIC/unique_identifier"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="provider[providing_organization]">
        <!-- Parent Organization -->
        <Organization xmlns="http://hl7.org/fhir">
            <xsl:call-template name="resource_id"/>
            <xsl:call-template name="pog_meta_security_organization"/>
            <xsl:call-template name="resource_identifier"/>
            <active>
                <xsl:attribute name="value">
                    <xsl:value-of select="$POG_PROVIDER_DEMOGRAPHIC[1]/is_active"/>
                </xsl:attribute>
            </active>
            <type>
                <xsl:for-each select="$POG_PROVIDER/providing_organization/types/type">
                    <coding>
                        <system
                            value="http://hl7.org/fhir/us/davinci-pdex-plan-net/CodeSystem/OrgTypeCS"/>
                        <xsl:choose>
                            <xsl:when test=". = 'fac'">
                                <code value="fac"/>
                                <display value="Facility"/>
                            </xsl:when>
                            <xsl:when test=". = 'prvgrp'">
                                <code value="prvgrp"/>
                                <display value="Provider Group"/>
                            </xsl:when>
                            <xsl:when test=". = 'payer'">
                                <code value="payer"/>
                                <display value="Payer"/>
                            </xsl:when>
                            <xsl:when test=". = 'atyprv'">
                                <code value="atyprv"/>
                                <display value="Atypical Provider"/>
                            </xsl:when>
                            <xsl:when test=". = 'bus'">
                                <code value="bus"/>
                                <display value="Non-Healthcare Business"/>
                            </xsl:when>
                            <xsl:when test=". = 'ntwk'">
                                <code value="ntwk"/>
                                <display value="Network"/>
                            </xsl:when>
                        </xsl:choose>
                    </coding>
                </xsl:for-each>
            </type>
            <name>
                <xsl:attribute name="value">
                    <xsl:value-of select="$POG_PROVIDER_DEMOGRAPHIC/name"/>
                </xsl:attribute>
            </name>
            <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/alias/alias">
                <alias>
                    <!-- <alias value="ABC Insurance"/>  -->
                    <xsl:attribute name="value">
                        <xsl:value-of select="normalize-space(.)"/>
                    </xsl:attribute>
                </alias>
            </xsl:for-each>
            <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/telecoms/telecom">
                <telecom>
                    <!-- Removing telecom ids since it's not used for internal reference in the resource. Keeping the code in case it's needed in the future
                    <xsl:if test="id">
                        <id>
                            <xsl:attribute name="value">
                                <xsl:value-of select="concat('tele-', id)"/>
                            </xsl:attribute>
                        </id>
                    </xsl:if> -->
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
            <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/addresses/address">
                <address>
                    <!-- Removing address ids since it's not used for internal reference in the resource. Keeping the code in case it's needed in the future -->
                    <xsl:if test="count($POG_CLIA) &gt; 1">
                        <id>
                            <xsl:attribute name="value">
                                <!-- <xsl:value-of select="concat('addr-',position())"/> -->
                                <xsl:value-of
                                    select="concat('addr-', ../preceding-sibling::clia, '-', position())"
                                />
                            </xsl:attribute>
                        </id>
                    </xsl:if>
                    <xsl:if test="use">
                        <use>
                            <xsl:attribute name="value">
                                <xsl:value-of select="use"/>
                            </xsl:attribute>
                        </use>
                    </xsl:if>
                    <xsl:if test="type">
                        <type>
                            <xsl:attribute name="value">
                                <xsl:value-of select="type"/>
                            </xsl:attribute>
                        </type>
                    </xsl:if>
                    <xsl:if test="text">
                        <text>
                            <xsl:attribute name="value">
                                <xsl:value-of select="text"/>
                            </xsl:attribute>
                        </text>
                    </xsl:if>
                    <line>
                        <xsl:attribute name="value">
                            <xsl:value-of select="line"/>
                        </xsl:attribute>
                    </line>
                    <city>
                        <xsl:attribute name="value">
                            <xsl:value-of select="city"/>
                        </xsl:attribute>
                    </city>
                    <state>
                        <xsl:attribute name="value">
                            <xsl:value-of select="state"/>
                        </xsl:attribute>
                    </state>
                    <postalCode>
                        <xsl:attribute name="value">
                            <xsl:value-of select="postal_code | postalCode"/>
                        </xsl:attribute>
                    </postalCode>
                    <xsl:if test="country">
                        <country>
                            <xsl:attribute name="value">
                                <xsl:value-of select="country"/>
                            </xsl:attribute>
                        </country>
                    </xsl:if>
                    <xsl:if test="district">
                        <district>
                            <xsl:attribute name="value">
                                <xsl:value-of select="district"/>
                            </xsl:attribute>
                        </district>
                    </xsl:if>
                    <xsl:if test="period">
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
                </address>
            </xsl:for-each>
            <xsl:if test="$POG_PROVIDER_DEMOGRAPHIC/part_of">
                <partOf>
                    <reference>
                        <type>Organization</type>
                        <xsl:choose>
                            <xsl:when test="$POG_PROVIDER_DEMOGRAPHIC/part_of/npi">
                                <identifier>
                                    <type>
                                        <coding>
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
                                            <xsl:value-of select="$POG_PROVIDER_DEMOGRAPHIC/part_of/npi"/>
                                        </xsl:attribute>
                                    </value>
                                </identifier>
                            </xsl:when>
                            <xsl:when test="$POG_PROVIDER_DEMOGRAPHIC/part_of/clia">
                                <identifier>
                                    <system>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="'http://terminology.hl7.org/NamingSystem/CLIA'"/>
                                        </xsl:attribute>
                                    </system>
                                    <value>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="$POG_PROVIDER_DEMOGRAPHIC/part_of/clia"/>
                                        </xsl:attribute>
                                    </value>
                                </identifier>
                            </xsl:when>
                        </xsl:choose>
                        <display>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$POG_PROVIDER_DEMOGRAPHIC/part_of/name"/>
                            </xsl:attribute>
                        </display>
                    </reference>
                </partOf>
            </xsl:if>
            <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/contacts/contact">
                <contact>
                    <xsl:if test="id">
                        <id>
                            <xsl:attribute name="value">
                                <xsl:value-of select="id"/>
                            </xsl:attribute>
                        </id>
                    </xsl:if>
                    <xsl:if test="extensions">
                        <xsl:for-each select="extensions/extension">
                            <extension>
                                <url>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="url"/>
                                    </xsl:attribute>
                                </url>
                                <xsl:if test="value">
                                    <value>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="value"/>
                                        </xsl:attribute>
                                    </value>
                                </xsl:if>
                            </extension>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="purpose">
                        <purpose>
                            <xsl:attribute name="value">
                                <xsl:value-of select="purpose"/>
                            </xsl:attribute>
                        </purpose>
                    </xsl:if>
                    <xsl:if test="name">
                        <name>
                            <xsl:if test="name/use">
                                <use>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="name/use"/>
                                    </xsl:attribute>
                                </use>
                            </xsl:if>
                            <xsl:if test="name/text">
                                <text>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="name/text"/>
                                    </xsl:attribute>
                                </text>
                            </xsl:if>
                            <xsl:if test="name/family">
                                <family>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="name/family"/>
                                    </xsl:attribute>
                                </family>
                            </xsl:if>
                            <xsl:for-each select="name/given">
                                <given>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="given"/>
                                    </xsl:attribute>
                                </given>
                            </xsl:for-each>
                            <xsl:for-each select="name/prefix">
                                <prefix>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="prefix"/>
                                    </xsl:attribute>
                                </prefix>
                            </xsl:for-each>
                            <xsl:for-each select="name/sufix">
                                <sufix>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="sufix"/>
                                    </xsl:attribute>
                                </sufix>
                            </xsl:for-each>
                            <xsl:if test="period">
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
                        </name>
                    </xsl:if>
                    <xsl:for-each select="telecoms/telecom">
                        <telecom>
                            <xsl:if test="system">
                                <system>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="system"/>
                                    </xsl:attribute>
                                </system>
                            </xsl:if>
                            <xsl:if test="value">
                                <value>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="value"/>
                                    </xsl:attribute>
                                </value>
                            </xsl:if>
                            <xsl:if test="use">
                                <use>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="use"/>
                                    </xsl:attribute>
                                </use>
                            </xsl:if>
                        </telecom>
                    </xsl:for-each>
                    <xsl:if test="address">
                        <address>
                            <xsl:if test="address/use">
                                <use>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="address/use"/>
                                    </xsl:attribute>
                                </use>
                            </xsl:if>
                            <xsl:if test="address/type">
                                <use>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="address/type"/>
                                    </xsl:attribute>
                                </use>
                            </xsl:if>
                            <xsl:if test="address/text">
                                <text>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="address/text"/>
                                    </xsl:attribute>
                                </text>
                            </xsl:if>
                            <line>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="address/line"/>
                                </xsl:attribute>
                            </line>
                            <city>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="address/city"/>
                                </xsl:attribute>
                            </city>
                            <state>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="address/state"/>
                                </xsl:attribute>
                            </state>
                            <postalCode>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="address/postal_code | address/postalCode"
                                    />
                                </xsl:attribute>
                            </postalCode>
                            <xsl:if test="address/country">
                                <country>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="address/country"/>
                                    </xsl:attribute>
                                </country>
                            </xsl:if>
                            <xsl:if test="address/district">
                                <district>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="address/district"/>
                                    </xsl:attribute>
                                </district>
                            </xsl:if>
                            <xsl:if test="address/period">
                                <period>
                                    <xsl:if test="address/period/start">
                                        <start>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="address/period/start"/>
                                            </xsl:attribute>
                                        </start>
                                    </xsl:if>
                                    <xsl:if test="address/period/end">
                                        <end>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="address/period/end"/>
                                            </xsl:attribute>
                                        </end>
                                    </xsl:if>
                                </period>
                            </xsl:if>
                        </address>
                    </xsl:if>
                </contact>
            </xsl:for-each>
        </Organization>
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
    <xsl:template name="resource_id">
        <xsl:variable name="CODE">
            <xsl:choose>
                <xsl:when test="$POG_UNIQUE_ID">
                    <xsl:value-of select="$POG_UNIQUE_ID[1]"/>
                </xsl:when>
                <xsl:when test="$POG_NPI">
                    <xsl:value-of select="$POG_NPI[1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$POG_CLIA[1]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <id>
            <xsl:attribute name="value">
                <xsl:value-of select="concat($POG_CUSTOMER_PREFIX, '-', $CODE)"/>
            </xsl:attribute>
        </id>
    </xsl:template>
    <xsl:template name="resource_identifier">
        <xsl:if test="$POG_NPI">
            <identifier>
                <type>
                    <coding>
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
                        <xsl:value-of select="$POG_NPI[1]"/>
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
                <value>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="concat($POG_CUSTOMER_PREFIX, '-', $POG_PROVIDER/practitioner/tax)"
                        />
                    </xsl:attribute>
                </value>
            </identifier>
        </xsl:if>
        <xsl:if test="$POG_CLIAS">
            <xsl:for-each select="$POG_CLIAS">
                <identifier>
                    <id>
                        <xsl:attribute name="value">
                            <xsl:value-of select="id"/>
                        </xsl:attribute>
                    </id>
                    <system>
                        <xsl:attribute name="value">
                            <xsl:value-of select="'http://terminology.hl7.org/NamingSystem/CLIA'"/>
                        </xsl:attribute>
                    </system>
                    <value>
                        <xsl:attribute name="value">
                            <xsl:value-of select="value"/>
                        </xsl:attribute>
                    </value>
                </identifier>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$POG_CLIA">
            <xsl:for-each select="$POG_CLIA">
                <identifier>
                    <system>
                        <xsl:attribute name="value">
                            <xsl:value-of select="'http://terminology.hl7.org/NamingSystem/CLIA'"/>
                        </xsl:attribute>
                    </system>
                    <value>
                        <xsl:attribute name="value">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </value>
                </identifier>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
