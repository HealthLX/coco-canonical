<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://hl7.org/fhir"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:variable name="POG_PROVIDER_DEMOGRAPHIC" select="eob_list/eob/provider/providing_organization"/>
    <xsl:variable name="POG_CUSTOMER_PREFIX" select="eob_list/eob/customername"/>
    
    <xsl:variable name="POG_PROVIDER_LOCATIONS"
        select="eob_list/eob/provider/providing_organization/addresses"/>
    <xsl:variable name="EOB_VAR" select="./eob_list/eob/provider/providing_organization/clia"/>
    <xsl:variable name="EOB_VAR1" select="./eob_list/eob/provider/practitioner/npi"/>
    <xsl:variable name="EOB_VAR2" select="./eob_list/eob/provider/practitioner/clia"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        <Organization xmlns="http://hl7.org/fhir">
            <id>
                <xsl:choose>
                    <xsl:when test="$EOB_VAR != ''">


                        <xsl:attribute name="value">
                            <xsl:value-of select="concat($POG_CUSTOMER_PREFIX, '-', $EOB_VAR)"/>
                        </xsl:attribute>

                    </xsl:when>
                    <xsl:when test="$EOB_VAR1 != ''">


                        <xsl:attribute name="value">
                            <xsl:value-of select="concat($POG_CUSTOMER_PREFIX, '-', $EOB_VAR1)"/>
                        </xsl:attribute>

                    </xsl:when>
                    <xsl:otherwise>


                        <xsl:attribute name="value">
                            <xsl:value-of select="concat($POG_CUSTOMER_PREFIX, '-', $EOB_VAR2)"/>
                        </xsl:attribute>

                    </xsl:otherwise>
                </xsl:choose>

            </id>

            <meta>
                <xsl:variable name="EOB_PARENTFILE_NAME" select="eob_list/eob/parentfile"/>
                 <source>
                     <xsl:attribute name="value">
                         <xsl:value-of select="$EOB_PARENTFILE_NAME"/>
                      </xsl:attribute>
                  </source>
            </meta>
            <identifier>
                <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                <xsl:call-template name="pog_text_identifier_provider_organization"/>
            </identifier>

            <active>
                <!--  value="[boolean]"0..1 Whether the organization's record is still in active use -->
                <xsl:attribute name="value">
                    <xsl:value-of select="$POG_PROVIDER_DEMOGRAPHIC/is_active"/>
                </xsl:attribute>
            </active>

            <type>
                <!-- 0..* CodeableConcept Kind of organization
                <xsl:attribute name="value">
                    <xsl:value-of
                        select="$POG_PROVIDER_DEMOGRAPHIC/type"
                    />
                </xsl:attribute> -->
                <coding>
                    <system value="http://terminology.hl7.org/CodeSystem/organization-type"/>
                    <code value="prov"/>
                    <display value="Healthcare Provider"/>
                </coding>


            </type>
            <name>
                <text>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$POG_PROVIDER_DEMOGRAPHIC/name"/>
                    </xsl:attribute>
                </text>
            </name>
            <!-- value="[string]"?? 0..1 Name used for the organization -->
            <alias/>
            <!--  value="[string]"0..* A list of alternate names that the organization is known as, or was known as in the past -->
            <contact>
                <xsl:call-template name="pog_telcom_provider_organization"/>
            </contact>
            <!-- ?? 0..* Address An address for the organization -->
            <contact>
                <xsl:call-template name="pog_address_provider_organization"/>
            </contact>
            <partOf><!-- 0..1 Reference(Organization) The organization of which this organization forms a part --></partOf>

            <code><!-- 1..1 CodeableConcept Coded representation of the qualification -->
            </code>
            <endpoint><!-- 0..* Reference(Endpoint) Technical endpoints providing access to services operated for the organization --></endpoint>
        </Organization>

    </xsl:template>

    <xsl:template name="pog_text_identifier_provider_organization">

        <value>
            <xsl:choose>
                <xsl:when test="$EOB_VAR != ''">


                    <xsl:attribute name="value">
                        <xsl:value-of select="concat($POG_CUSTOMER_PREFIX, '-', $EOB_VAR)"/>
                    </xsl:attribute>

                </xsl:when>
                <xsl:when test="$EOB_VAR1 != ''">


                    <xsl:attribute name="value">
                        <xsl:value-of select="concat($POG_CUSTOMER_PREFIX, '-', $EOB_VAR1)"/>
                    </xsl:attribute>

                </xsl:when>
                <xsl:otherwise>


                    <xsl:attribute name="value">
                        <xsl:value-of select="concat($POG_CUSTOMER_PREFIX, '-', $EOB_VAR2)"/>
                    </xsl:attribute>

                </xsl:otherwise>
            </xsl:choose>
        </value>


    </xsl:template>
   
    <xsl:template name="pog_telcom_provider_organization">
        <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/telecoms/telecom">

            <telecom>
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
    </xsl:template>

    <xsl:template name="pog_address_provider_organization">
        <xsl:for-each select="$POG_PROVIDER_LOCATIONS/address">

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
                        <xsl:value-of select="./zip_code"/>
                    </xsl:attribute>
                </postalCode>

                <country>
                    <xsl:attribute name="value">USA</xsl:attribute>
                </country>
            </address>

        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
