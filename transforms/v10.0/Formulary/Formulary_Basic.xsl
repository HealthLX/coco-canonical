<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xpath-default-namespace="http://cocodata.org">
    <!-- coco canonical roots formulary data at coverage_plans/coverage_plan (vs. the flat
         hlx-saas input). customername/parentfile are not present in coco's Formulary canonical,
         so the customer prefix / meta source resolve empty until those are added to the model. -->
    <xsl:variable name="FOR_COVERAGE" select="/coverage_plans/coverage_plan"/>
    <xsl:variable name="FOR_CUSTOMER_PREFIX" select="$FOR_COVERAGE/customername"/>



    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="*">
        <Basics>
            <xsl:for-each select="$FOR_COVERAGE/drug_tiers/drug_tier">
                <xsl:variable name="DRUG_TIER" select="./drug_tier_id/code"/>
                <xsl:variable name="DRUG_TIER_DESC" select="./drug_tier_id/code"/>
                <xsl:for-each select="./formulary_drugs/formulary_drug">
                    <Basic xmlns="http://hl7.org/fhir">
                        <id>
                            <!-- value="FormularyItem-D3001-1000091"-->


                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="concat($FOR_CUSTOMER_PREFIX, '-', 'FormularyItem-', $DRUG_TIER, '-', $FOR_COVERAGE/plan_id, '-',./rx_norm_code/code)"
                                />
                            </xsl:attribute>
                        </id>
                        <xsl:call-template name="pog_meta_security_organization"/>
                        <extension
                            url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PlanID-extension">
                            <valueString>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="concat($FOR_CUSTOMER_PREFIX, '-',$FOR_COVERAGE/plan_id)"/>
                                </xsl:attribute>
                            </valueString>
                        </extension>
                        

                        <extension
                            url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyReference-extension">
                            <valueReference>
                                <reference>
                                    <!--value="InsurancePlan/FormularyD3001"/>-->
                                    <xsl:attribute name="value">

                                        <xsl:value-of
                                            select="concat('InsurancePlan/', $FOR_CUSTOMER_PREFIX, '-', $FOR_COVERAGE/plan_id)"
                                        />
                                    </xsl:attribute>
                                </reference>
                            </valueReference>
                        </extension>
                        <extension
                            url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-AvailabilityStatus-extension">
                            <valueCode>
                                <!--value="active"/>-->
                                <xsl:attribute name="value">

                                    <xsl:value-of select="'active'"/>
                                </xsl:attribute>

                            </valueCode>
                        </extension>
                <!--         <extension url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PharmacyBenefitType-extension">
                <valueCodeableConcept>
                    <coding>
                        <system value="http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-PharmacyBenefitTypeCS-TEMPORARY-TRIAL-USE"/>
                        <code value="1-month-in-mail"/>
                        <display value="1 month in network mail order"/>
                    </coding>
                </valueCodeableConcept>
            </extension>-->
                       
                          
            <extension url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-DrugTierID-extension">
                <valueCodeableConcept>
                    <coding>
                        <system value="http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-DrugTierCS-TEMPORARY-TRIAL-USE"/>
                        <code>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$DRUG_TIER_DESC"/>
                            </xsl:attribute>
                         </code>
                         <display>
                            <xsl:attribute name="value">
                                <xsl:value-of select="concat('Drug Tier ',$DRUG_TIER)"/>
                            </xsl:attribute>
                        </display>
                    </coding>
                </valueCodeableConcept>
            </extension>
                          
                        
           <!-- <extension url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-AvailabilityPeriod-extension">
                <valuePeriod>
                    <start value="2021-01-01"/>
                    <end value="2021-12-31"/>
                </valuePeriod>
            </extension>
            <extension url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PharmacyBenefitType-extension">
                <valueCodeableConcept>
                    <coding>
                        <system value="http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-PharmacyBenefitTypeCS-TEMPORARY-TRIAL-USE"/>
                        <code value="3-month-in-mail"/>
                        <display value="3 month in network mail order"/>
                    </coding>
                </valueCodeableConcept>
            </extension>-->
                        <extension
                            url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PriorAuthorization-extension">
                            <valueBoolean>
                                
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./step_therapy"/>
                                </xsl:attribute>
                                
                            </valueBoolean>
                        </extension>
                        <extension
                            url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-StepTherapyLimit-extension">
                            <valueBoolean>
                                
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./prior_authorization"/>
                                </xsl:attribute>
                                
                            </valueBoolean>
                        </extension>
                     <!--   <extension
                            url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-StepTherapyLimitNewStartsOnly-extension">
                            <valueBoolean value="false"/>
                        </extension>-->
                        <extension
                            url="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-QuantityLimit-extension">
                           
                           
                               
                                   <xsl:choose>
                                       <xsl:when test="./quantity_limit">
                                           <valueBoolean value="false"/>
                                       </xsl:when>
                                       <xsl:when test="./quantity_limit>1">
                                           <valueBoolean value="true"/>
                                       </xsl:when>
                                       
                                       <xsl:otherwise>
                                           <valueBoolean value="false"/>
                                       </xsl:otherwise>
                                   </xsl:choose>
                            
                        </extension>
                        <code>
                            <coding>
                                <system
                                    value="http://hl7.org/fhir/us/davinci-drug-formulary/CodeSystem/usdf-InsuranceItemTypeCS"/>
                                <code value="formulary-item"/>
                                <display value="Formulary Item"/>
                            </coding>
                        </code>
                        <subject>
                            <!--value="MedicationKnowledge/FormularyDrug-1000091"-->

                            <reference>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="concat('MedicationKnowledge/', $FOR_CUSTOMER_PREFIX, '-', $FOR_COVERAGE/plan_id, '-', $DRUG_TIER,'-',./rx_norm_code/code)"
                                    />                      
                               
                                </xsl:attribute>
                            </reference>
                            <display>
                                
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select=" ./rx_norm_code/display"
                                    />
                                </xsl:attribute>
                                
                            </display>
                        </subject>
                    </Basic>
                </xsl:for-each>
            </xsl:for-each>
        </Basics>

    </xsl:template>
    <xsl:template name="pog_meta_security_organization">
        <meta>
            <xsl:variable name="EOB_PARENTFILE_NAME" select="$FOR_COVERAGE/parentfile"/>
            <source>
                <xsl:attribute name="value">
                    <xsl:value-of select="$EOB_PARENTFILE_NAME"/>
                </xsl:attribute>
            </source>
            <profile
                value="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyItem"/>

        </meta>
    </xsl:template>


</xsl:stylesheet>
