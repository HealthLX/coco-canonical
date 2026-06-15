<xsl:stylesheet xpath-default-namespace="http://cocodata.org" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://hl7.org/fhir">
    <xsl:preserve-space elements="*"/>
    <xsl:output method="xml" omit-xml-declaration="no" indent="yes"/>
    <xsl:variable name="ORG" select="/clinicals/clinical/organizations/organization"/>
    <xsl:variable name="DOCREF_ORG"
        select="/clinicals/clinical/document_references/document_reference/author/organization"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:variable name="PRACROLE_ORG"
        select="/clinicals/clinical/practitioners_roles/practitioner_role/organization"/>
    <!-- Main resource template structure -->
    <!-- ******************** Everthing that can be done without real data should be done. Need to look into address and telecoms when we get data*************************** -->
    <xsl:template match="*">
        <Organizations>
            <xsl:for-each-group select="$ORG | $PRACROLE_ORG | $DOCREF_ORG"
                group-by="concat(
                normalize-space((./organization_details/npi | ./npi)[1]),
                '|',
                normalize-space((./organization_details/clia | ./clia)[1])
                )">
                <Organization>
                    <id>
                        <xsl:choose>
                            <xsl:when test="unique_identifier">
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="concat($CUSTOMER_PREFIX, '-', ./unique_identifier)"
                                    />
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when test="clia">
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="concat($CUSTOMER_PREFIX, '-', ./npi, '-', ./clia)"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="concat($CUSTOMER_PREFIX, '-', ./npi)"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </id>

                    <meta>
                        <source>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$PARENTFILE_NAME"/>
                            </xsl:attribute>
                        </source>

                        <profile
                            value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization"
                        />
                    </meta>

                    <!-- ?? 0..* Identifier Identifies this organization across multiple systems -->
                    <xsl:call-template name="pog_text_identifier_provider_organization"/>
                    <active>
                        <xsl:attribute name="value">
                            <xsl:value-of
                                select="(./organization_details/is_active | ./is_active)[1]"/>
                        </xsl:attribute>
                    </active>
                    <type>
                        <!-- 0..* CodeableConcept Kind of organization <xsl:attribute name="value"> <xsl:value-of select="$POG_PROVIDER_DEMOGRAPHIC/type" /> </xsl:attribute> -->
                        <coding>
                            <system value="http://terminology.hl7.org/CodeSystem/organization-type"/>
                            <code value="prov"/>
                            <display value="Healthcare Provider"/>
                        </coding>
                    </type>
                    <name>
                        <xsl:attribute name="value">
                            <xsl:value-of select="(./organization_details/name | ./name)[1]"/>
                        </xsl:attribute>
                    </name>
                    <!-- nothing in soure file for $ORG/organization_details/telecoms/telecom -->
                    <xsl:call-template name="org_telcom"/>
                    <!-- Nothing in address from source -->
                    <xsl:call-template name="org_address"/>
                    <!-- <alias/> value="[string]"0..* A list of alternate names that the organization is known as, or was known as in the past -->
                    <!-- <contact> <xsl:call-template name="pog_telcom_provider_organization"/> </contact> -->
                    <!-- ?? 0..* Address An address for the organization <contact> <xsl:call-template name="pog_address_provider_organization"/> </contact> <partOf>-->
                    <!-- 0..1 Reference(Organization) The organization of which this organization forms a part -->
                    <!--</partOf> <code> 1..1 CodeableConcept Coded representation of the qualification -->
                    <!--</code> <endpoint> 0..* Reference(Endpoint) Technical endpoints providing access to services operated for the organization </endpoint>-->
                </Organization>
            </xsl:for-each-group>
        </Organizations>
    </xsl:template>
    <xsl:template name="pog_text_identifier_provider_organization">
        <xsl:if test="(./organization_details/npi | ./npi)[1]">
            <identifier>
                <!-- Is this the correct url?????? sample file has http://hl7.org/fhir/sid/us-npi-->
                <system value="http://hl7.org/fhir/sid/us-npi"/>
                <value>
                    <xsl:attribute name="value">
                        <xsl:value-of select="(./organization_details/npi | ./npi)[1]"/>
                    </xsl:attribute>
                </value>
            </identifier>
        </xsl:if>
        <xsl:if test="(./organization_details/clia | ./clia)[1]">
            <identifier>
                <system value="urn:oid:2.16.840.1.113883.4.7"/>
                <!-- This is for clia based on sample and validation -->
                <value>
                    <xsl:attribute name="value">
                        <xsl:value-of select="(./organization_details/clia | ./clia)[1]"/>
                    </xsl:attribute>
                </value>
            </identifier>

        </xsl:if>
    </xsl:template>
    <xsl:template name="org_address">
        <xsl:for-each select="(./organization_details/addresses/address | ./addresses/address)">
            <address>
                <xsl:if test="use">
                    <use>
                        <xsl:attribute name="value">
                            <xsl:value-of select="use"/>
                        </xsl:attribute>
                    </use>
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
                <xsl:if test="district">
                    <district>
                        <xsl:attribute name="value">
                            <xsl:value-of select="district"/>
                        </xsl:attribute>
                    </district>
                </xsl:if>
                <state>
                    <xsl:attribute name="value">
                        <xsl:value-of select="state"/>
                    </xsl:attribute>
                </state>
                <postalCode>
                    <xsl:attribute name="value">
                        <xsl:value-of select="postal_code"/>
                    </xsl:attribute>
                </postalCode>
                <country>
                    <xsl:attribute name="value">USA</xsl:attribute>
                </country>
            </address>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="org_telcom">
        <xsl:for-each select="(./organization_details/telecoms/telecom | ./telecoms/telecom)">
            <telecom>
                <system>
                    <!-- ?? 0..1 value="[code]"phone | fax | email | pager | url | sms | other -->
                    <xsl:attribute name="value">
                        <xsl:value-of select="./system"/>
                    </xsl:attribute>
                </system>
                <value>
                    <xsl:attribute name="value">
                        <xsl:value-of select="./value"/>
                    </xsl:attribute>
                </value>
                <xsl:if test="use">
                    <use>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./use"/>
                        </xsl:attribute>
                    </use>
                </xsl:if>
                <rank>
                    <xsl:attribute name="value">
                        <xsl:value-of select="position()"/>
                    </xsl:attribute>
                </rank>
                <xsl:if test="period/start | period/end">
                    <period>
                        <xsl:if test="period/start">
                            <start>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./period/start"/>
                                </xsl:attribute>
                            </start>
                        </xsl:if>
                        <xsl:if test="period/end">
                            <end>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./period/end"/>
                                </xsl:attribute>
                            </end>
                        </xsl:if>
                    </period>
                </xsl:if>
            </telecom>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
