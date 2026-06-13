<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="FOR_DRUG" select="/coverage_plans/coverage_plan/drug_tiers/drug_tier/formulary_drugs/formulary_drug"/>
    <xsl:variable name="FOR_CUSTOMER_PREFIX" select="formulary_drug/customername"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        <MedicationKnowledge xmlns="http://hl7.org/fhir">
            <id>
                <xsl:attribute name="value">
                     <xsl:value-of
                         select="concat($FOR_CUSTOMER_PREFIX, '-', $FOR_DRUG/plan_id, '-', $FOR_DRUG/drug_tier_id/code, '-', $FOR_DRUG/rx_norm_code/code)"
                            />
                </xsl:attribute>
            </id>
            <status>
                <xsl:attribute name="value">
                    <xsl:choose><!-- The CoveragePlan Status (current, retired, entered-in-error).  More details can be found here:  http://hl7.org/fhir/R4/valueset-list-status.html > -->
                        <xsl:when test="$FOR_DRUG/status = 'active' or $FOR_DRUG/status = 'current'">
                            <xsl:text>active</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>inactive</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </status>
            <meta>
                <profile value="http://hl7.org/fhir/StructureDefinition/MedicationKnowledge"/>
            </meta>
            <extension
                url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-DrugTierID-extension">
                <valueCodeableConcept>
                    <coding>
                        <system
                            value="http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-DrugTierCS"/>
                        <code>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$FOR_DRUG/drug_tier_id/code"/>
                            </xsl:attribute>
                        </code>
                        <display>
                            <xsl:attribute name="value">
                                <!-- Display should be mapped to these values https://hl7.org/fhir/us/davinci-drug-formulary/STU1.1/ValueSet-DrugTierVS.html#expansion -->
                                <xsl:choose>
                                    <xsl:when test="$FOR_DRUG/drug_tier_id/code = 'generic'">
                                        <xsl:text>Generic</xsl:text>
                                    </xsl:when>
                                    <xsl:when
                                        test="$FOR_DRUG/drug_tier_id/code = 'preferred-generic'">
                                        <xsl:text>Preferred Generic</xsl:text>
                                    </xsl:when>
                                    <xsl:when
                                        test="$FOR_DRUG/drug_tier_id/code = 'non-preferred-generic'">
                                        <xsl:text>Non-preferred Generic</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$FOR_DRUG/drug_tier_id/code = 'specialty'">
                                        <xsl:text>Specialty</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$FOR_DRUG/drug_tier_id/code = 'brand'">
                                        <xsl:text>Brand</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$FOR_DRUG/drug_tier_id/code = 'preferred-brand'">
                                        <xsl:text>Preferred Brand</xsl:text>
                                    </xsl:when>
                                    <xsl:when
                                        test="$FOR_DRUG/drug_tier_id/code = 'non-preferred-brand'">
                                        <xsl:text>Non-preferred Brand</xsl:text>
                                    </xsl:when>
                                    <xsl:when
                                        test="$FOR_DRUG/drug_tier_id/code = 'zero-cost-share-preventative'">
                                        <xsl:text>Zero cost-share preventative</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$FOR_DRUG/drug_tier_id/code = 'medical-service'">
                                        <xsl:text>Medical Service</xsl:text>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:attribute>
                        </display>
                    </coding>
                </valueCodeableConcept>
            </extension>
            <extension
                url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-MailOrder-extension">
                <valueBoolean>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$FOR_DRUG/mail_order"/>
                    </xsl:attribute>
                </valueBoolean>
            </extension>
            <extension
                url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PriorAuthorization-extension">
                <valueBoolean>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$FOR_DRUG/prior_authorization"/>
                    </xsl:attribute>
                </valueBoolean>
            </extension>
            <extension
                url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-StepTherapyLimit-extension">
                <valueBoolean>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$FOR_DRUG/step_therapy"/>
                    </xsl:attribute>
                </valueBoolean>
            </extension>
            <extension
                url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-QuantityLimit-extension">
                <valueBoolean>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$FOR_DRUG/quantity_limit"/>
                    </xsl:attribute>
                </valueBoolean>
            </extension>
            <extension
                url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PlanID-extension">
                <valueString>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$FOR_DRUG/plan_id"/>
                    </xsl:attribute>
                </valueString>
            </extension>
            <code>
                <coding>
                    <xsl:choose>
                        <xsl:when test="$FOR_DRUG/rx_norm_code/system">
                            <system>
                                <xsl:attribute name="value">
                                <xsl:value-of select="$FOR_DRUG/rx_norm_code/system"/>
                                    </xsl:attribute>
                            </system>
                        </xsl:when>
                        <xsl:otherwise>
                            <system value="http://www.nlm.nih.gov/research/umls/rxnorm"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$FOR_DRUG/rx_norm_code/code">
                        <code>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$FOR_DRUG/rx_norm_code/code"/>
                            </xsl:attribute>
                        </code>
                    </xsl:if>
                    <xsl:if test="$FOR_DRUG/rx_norm_code/display">
                        <display>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$FOR_DRUG/rx_norm_code/display"/>
                            </xsl:attribute>
                        </display>
                    </xsl:if>
                </coding>
                <xsl:if test="$FOR_DRUG/rx_norm_code/text">
                    <text>
                        <xsl:attribute name="value">
                            <xsl:value-of select="$FOR_DRUG/rx_norm_code/text"/>
                        </xsl:attribute>
                    </text>
                </xsl:if>
            </code>
            <name>
                <xsl:attribute name="value"><xsl:value-of select="$FOR_DRUG/rx_norm_code/display"/></xsl:attribute>
            </name>
            <xsl:if test="$FOR_DRUG/dose_form">
                <definitional>
                <doseForm>
                    <xsl:if
                        test="$FOR_DRUG/dose_form/code or $FOR_DRUG/dose_form/display or $FOR_DRUG/dose_form/system or $FOR_DRUG/dose_form/text" >
                        <coding>
                            <system value="http://snomed.info/sct"/> 
                            <xsl:if test="$FOR_DRUG/dose_form/code">
                                <code>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$FOR_DRUG/dose_form/code"/>
                                    </xsl:attribute>
                                </code>
                            </xsl:if>
                            <xsl:if test="$FOR_DRUG/dose_form/text">
                                <display>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$FOR_DRUG/dose_form/text"/>
                                    </xsl:attribute>
                                </display>
                            </xsl:if>
                        </coding>
                    </xsl:if>
                    <!-- <xsl:if test="$FOR_DRUG/dose_form/text">
                        <text>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$FOR_DRUG/dose_form/text"/>
                            </xsl:attribute>
                            </text>
                    </xsl:if> -->
                </doseForm>
                    </definitional>
            </xsl:if>
        </MedicationKnowledge>
    </xsl:template>
</xsl:stylesheet>
