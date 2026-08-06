<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="FOR_COVERAGE" select="/coverage_plans/coverage_plan"/>
    <xsl:variable name="FOR_ROOT" select="row"/>
    <xsl:variable name="PTT_CUSTOMER_PREFIX" select="/coverage_plans/coverage_plan/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="/coverage_plans/coverage_plan/parentfile"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        <List xmlns="http://hl7.org/fhir">
            <id>
                <xsl:attribute name="value">
                    <xsl:choose>
                        <xsl:when test="$FOR_COVERAGE/plan_id != 'NASC'">
                            <xsl:value-of
                                select="concat($PTT_CUSTOMER_PREFIX, '-', replace($FOR_COVERAGE/plan_id, '_', '-'))"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="concat($PTT_CUSTOMER_PREFIX, '-', replace($FOR_COVERAGE/plan_id, '_', '-'), '-1')"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </id>
            <meta>
                <source>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$PARENTFILE_NAME"/>
                    </xsl:attribute>
                </source>
                <profile
                    value="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-CoveragePlan"
                />
            </meta>
            <xsl:for-each-group select="$FOR_COVERAGE/drug_tiers/drug_tier" group-by=".">
                <extension
                    url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-DrugTierDefinition-extension">
                    <extension url="drugTierID">
                        <valueCodeableConcept>
                            <xsl:choose>
                                <xsl:when test="drug_tier_id/code != ''">
                                    <coding>
                                        <system
                                            value="http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-DrugTierCS"/>
                                        <code>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="drug_tier_id/code"/>
                                            </xsl:attribute>
                                        </code>
                                        <display>
                                            <xsl:variable name="X1">
                                                <xsl:call-template name="usdf-PharmacyTypeCS">
                                                  <xsl:with-param name="Inboundparm"
                                                  select="drug_tier_id/code"/>
                                                </xsl:call-template>
                                            </xsl:variable>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$X1"/>
                                            </xsl:attribute>
                                        </display>
                                    </coding>
                                </xsl:when>
                                <xsl:otherwise>
                                    <text>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="drug_tier_id/text"/>
                                        </xsl:attribute>
                                    </text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </valueCodeableConcept>
                    </extension>
                    <extension url="mailOrder">
                        <valueBoolean>
                            <xsl:attribute name="value">
                                <xsl:value-of select="mail_order"/>
                            </xsl:attribute>
                        </valueBoolean>
                    </extension>
                    <xsl:for-each select="cost_sharings/cost_sharing">
                        <extension url="costSharing">
                            <extension url="pharmacyType">
                                <valueCodeableConcept>														
                                    <xsl:choose>
                                        <xsl:when
                                            test="pharmacy_type/code != ''">
                                            <coding>
                                                <system
                                                  value="http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-PharmacyTypeCS"/>
                                                <code>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of
                                                  select="pharmacy_type/code"
                                                  />
                                                  </xsl:attribute>
                                                </code>
                                                <display>
                                                  <xsl:variable name="X">
                                                  <xsl:call-template
                                                  name="cost_sharing_pharmacy_type_code">
                                                  <xsl:with-param name="Inboundparm"
                                                  select="pharmacy_type/code"
                                                  />
                                                  </xsl:call-template>
                                                  </xsl:variable>
                                                  <xsl:attribute name="value">
                                                  <xsl:value-of select="$X"/>
                                                  </xsl:attribute>
                                                </display>
                                            </coding>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <text>
                                                <xsl:attribute name="value">
                                                  <xsl:value-of
                                                  select="pharmacy_type/text"
                                                  />
                                                </xsl:attribute>
                                            </text>
                                        </xsl:otherwise>
                                    </xsl:choose>
												   
                                </valueCodeableConcept>
                            </extension>
                            <extension url="copayAmount">
                                <valueMoney>
                                    <value>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="copay_amount/value"
                                            />
                                        </xsl:attribute>
                                    </value>
                                </valueMoney>
                            </extension>
                            <extension url="copayOption">
                                <valueCodeableConcept>
                                    <coding>
                                        <system
                                            value="http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-CopayOptionCS"/>
                                        <code>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                  select="copay_option"/>
                                            </xsl:attribute>
                                        </code>
                                        <display>
                                            <xsl:variable name="X3">
                                                <xsl:call-template name="usdf-CopayOptionCS">
                                                  <xsl:with-param name="Inboundparm"
                                                  select="copay_option"/>
                                                </xsl:call-template>
                                            </xsl:variable>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$X3"/>
                                            </xsl:attribute>
                                        </display>
                                    </coding>
                                </valueCodeableConcept>
                            </extension>
                            <extension url="coinsuranceRate">
                                <valueDecimal>
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="coinsurance_rate"/>
                                    </xsl:attribute>
                                </valueDecimal>
                            </extension>
                            <extension url="coinsuranceOption">
                                <valueCodeableConcept>
                                    <coding>
                                        <system
                                            value="http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-CoinsuranceOptionCS"/>
                                        <code>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                  select="coinsurance_option"
                                                />
                                            </xsl:attribute>
                                        </code>
                                        <display>
                                            <xsl:variable name="X3">
                                                <xsl:call-template name="usdf-CopayOptionCS">
                                                  <xsl:with-param name="Inboundparm"
                                                  select="coinsurance_option"
                                                  />
                                                </xsl:call-template>
                                            </xsl:variable>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$X3"/>
                                            </xsl:attribute>
                                        </display>
                                    </coding>
                                </valueCodeableConcept>
                            </extension>
                        </extension>
                    </xsl:for-each>
                </extension>
            </xsl:for-each-group>
            <xsl:if test="$FOR_COVERAGE[1]/marketing_url != ''">
                <extension
                    url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-MarketingURL-extension">
                    <valueUrl>
                        <xsl:attribute name="value">
                            <xsl:value-of select="$FOR_COVERAGE[1]/marketing_url"/>
                        </xsl:attribute>
                    </valueUrl>
                </extension>
            </xsl:if>
            <xsl:if test="$FOR_COVERAGE[1]/formulary_url != ''">
                <extension
                    url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyURL-extension">
                    <valueUrl>
                        <valueUrl>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$FOR_COVERAGE[1]/formulary_url"/>
                            </xsl:attribute>
                        </valueUrl>
                    </valueUrl>
                </extension>
            </xsl:if>
            <xsl:if test="$FOR_COVERAGE[1]/summary_url != ''">
                <extension
                    url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-SummaryURL-extension">
                    <valueUrl>
                        <xsl:attribute name="value">
                            <xsl:value-of select="$FOR_COVERAGE[1]/summary_url"/>
                        </xsl:attribute>
                    </valueUrl>
                </extension>
            </xsl:if>
            <xsl:if test="$FOR_COVERAGE[1]/summary_url != ''">
                <extension
                    url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-EmailPlanContact-extension">
                    <valueUrl>
                        <xsl:value-of select="$FOR_COVERAGE[1]/email_plan_contact"/>
                    </valueUrl>
                </extension>
            </xsl:if>
            <extension
                url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-Network-extension">
                <valueString>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$FOR_COVERAGE[1]/network"/>
                    </xsl:attribute>
                </valueString>
            </extension>
            <extension
                url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PlanIDType-extension">
                <valueString>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$FOR_COVERAGE[1]/plan_id_type"/>
                    </xsl:attribute>
                </valueString>
            </extension>
            <identifier>
                <!-- I 0..* Identifier Business Identifier for Product -->
                <!-- ?? 0..* Identifier Identifies this organization across multiple systems -->
                <system>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="concat('https://data.healthlx.com/', $PTT_CUSTOMER_PREFIX, '-FormularyPlanID')"
                        />
                    </xsl:attribute>
                </system>
                <value>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$FOR_COVERAGE[1]/plan_id"/>
                    </xsl:attribute>
                </value>
            </identifier>
            <status>
                <xsl:attribute name="value">
                    <xsl:value-of select="$FOR_COVERAGE[1]/status"/>
                </xsl:attribute>
            </status>
            <mode>
                <xsl:attribute name="value">
                    <xsl:value-of select="$FOR_COVERAGE[1]/mode"/>
                </xsl:attribute>
            </mode>
            <title>
                <xsl:attribute name="value">
                    <xsl:value-of select="$FOR_COVERAGE[1]/title"/>
                </xsl:attribute>
            </title>
            <code>
                <coding>
                    <system value="http://terminology.hl7.org/CodeSystem/v3-ActCode"/>
                    <code value="DRUGPOL"/>
                    <display value="drug policy"/>
                </coding>
            </code>
            <date>
                <xsl:attribute name="value">
                    <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
                </xsl:attribute>
            </date>
        </List>
    </xsl:template>
    <xsl:template name="cost_sharing_pharmacy_type_code">
        <xsl:param name="Inboundparm"/>
        <xsl:variable name="PHAR_TYPE_CODE_DISPLAY">
            <xsl:choose>
                <xsl:when test="$Inboundparm = '1-month-in-retail'">
                    <xsl:value-of select="'1 month in network retail'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = '1-month-out-retail'">
                    <xsl:value-of select="'1 month out of network retail'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = '1-month-in-mail'">
                    <xsl:value-of select="'1 month in network mail order'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = '1-month-out-mail'">
                    <xsl:value-of select="'1 month out of network mail order'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = '3-month-in-retail'">
                    <xsl:value-of select="'3 month in network retail'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = '3-month-out-retail'">
                    <xsl:value-of select="'3 month out of network retail'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = '3-month-in-mail'">
                    <xsl:value-of select="'3 month in network mail order'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = '3-month-out-mail'">
                    <xsl:value-of select="'3 month out of network mail order'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$PHAR_TYPE_CODE_DISPLAY"/>
    </xsl:template>
    <xsl:template name="usdf-PharmacyTypeCS">
        <xsl:param name="Inboundparm"/>
        <xsl:variable name="PHAR_TYPE_DISPLAY_1">
            <xsl:choose>
                <xsl:when test="$Inboundparm = 'generic'">
                    <xsl:value-of select="'Generic'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = 'non-preferred-generic'">
                    <xsl:value-of select="'Non-preferred Generic'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = 'preferred-brand'">
                    <xsl:value-of select="'Preferred Brand'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = 'non-preferred-brand'">
                    <xsl:value-of select="'Non-preferred Brand'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = 'preferred-generic'">
                    <xsl:value-of select="'Preferred Generic'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = 'specialty'">
                    <xsl:value-of select="'Specialty'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = 'zero-cost-share-preventative'">
                    <xsl:value-of select="'Zero cost-share preventative'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = 'medical-service'">
                    <xsl:value-of select="'Medical Service'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$PHAR_TYPE_DISPLAY_1"/>
    </xsl:template>
    <xsl:template name="usdf-CopayOptionCS">
        <xsl:param name="Inboundparm"/>
        <xsl:variable name="PHAR_TYPE_DISPLAY_2">
            <xsl:choose>
                <xsl:when test="$Inboundparm = 'after-deductible'">
                    <xsl:value-of select="'After Deductible'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = 'before-deductible'">
                    <xsl:value-of select="'Before Deductible'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = 'no-charge'">
                    <xsl:value-of select="'No Charge'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = 'no-charge-after-deductible'">
                    <xsl:value-of select="'No Charge After Deductible'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = 'charge'">
                    <xsl:value-of select="'Charge'"/>
                </xsl:when>
                <xsl:when test="$Inboundparm = 'not-applicable'">
                    <xsl:value-of select="'Not Applicable'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$PHAR_TYPE_DISPLAY_2"/>
    </xsl:template>
</xsl:stylesheet>
