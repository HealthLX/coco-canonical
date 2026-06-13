<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:variable name="FOR_ROOT" select="/coverage_plans/coverage_plan"/>
    
    <xsl:variable name="PTT_CUSTOMER_PREFIX" select="$FOR_ROOT/customername"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
  
    
    <InsurancePlan xmlns="http://hl7.org/fhir"> 
        
        <!-- from Resource: id, meta, implicitRules, and language -->
        <id>
            <xsl:attribute name="value">
                <xsl:value-of
                    select="concat($PTT_CUSTOMER_PREFIX, '-', $FOR_ROOT/plan_id)"
                />
            </xsl:attribute>
        </id>
        <xsl:call-template name="pog_meta_security_organization"/>
        
        <!-- from DomainResource: text, contained, extension, and modifierExtension -->
        <identifier><!-- I 0..* Identifier Business Identifier for Product -->
            <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
            <system>
                <xsl:attribute name="value">
                    <xsl:value-of select="concat('https://data.healthlx.com/', $PTT_CUSTOMER_PREFIX,'-FormularyPlanID')"/>
                  
                </xsl:attribute>
                
            </system>
            <value>
                <xsl:attribute name="value">
                    <xsl:value-of
                        select="concat($PTT_CUSTOMER_PREFIX, '-',$FOR_ROOT/plan_id)"/>
                </xsl:attribute>
            </value>
        
        </identifier>
        <status>
            <xsl:attribute name="value">
                <xsl:value-of
                    select="'active'"/>
            </xsl:attribute>
            
        </status><!-- 0..1 draft | active | retired | unknown -->
        <type><!-- 0..* CodeableConcept Kind of product -->
            
            <system value="http://terminology.hl7.org/CodeSystem/insurance-plan-type"> </system>
            <value>
                <xsl:attribute name="value">
                    <xsl:value-of
                        select="'Drug'"/>
                </xsl:attribute>
            </value>
            
           
        </type>
        <name>
         
                <xsl:attribute name="value">
                    <xsl:value-of
                        select="$FOR_ROOT/title"/>
                </xsl:attribute>
            
            
        </name>
      <!--  <alias value="[string]"/><!-\- 0..* Alternate names -\->-->
        <period><!-- 0..1 Period When the product is available --></period>
        <ownedBy><!-- 0..1 Reference(Organization) Product issuer -->
            <reference>
                <xsl:attribute name="value">
                    <xsl:value-of
                        select="concat('Organization/' ,$PTT_CUSTOMER_PREFIX ,'-',$PTT_CUSTOMER_PREFIX )"/>
                    
                </xsl:attribute>
            </reference>
        
        </ownedBy>
       <!-- <administeredBy>
            <value>
                <xsl:attribute name="value">
                    <xsl:value-of
                        select="$FOR_ROOT/administered_by/name"/>
                </xsl:attribute>
            </value>
        
        </administeredBy>-->
        <coverageArea><!-- 0..* Reference(Location) Where product applies --></coverageArea>
        <contact><!-- 0..* ExtendedContactDetail Official contact details relevant to the health insurance plan/product --></contact>
        <endpoint><!-- 0..* Reference(Endpoint) Technical endpoint --></endpoint>
      <!--   <xsl:for-each select="$FOR_ROOT/networks/network">
        <network><!-\- 0..* Reference(Organization) What networks are Included -\->
            <reference>
                <xsl:attribute name="value">
                    <xsl:value-of
                        select="concat('Organization/' ,$PTT_CUSTOMER_PREFIX ,'-',$PTT_CUSTOMER_PREFIX )"/>
                   
                </xsl:attribute>
            </reference>
         </network>
        </xsl:for-each>-->
        <!--<coverage>  <!-\- 0..* Coverage details -\->
            <type><!-\- 1..1 CodeableConcept Type of coverage -\-></type>
            <network><!-\- 0..* Reference(Organization) What networks provide coverage -\-></network>
            <benefit>  <!-\- 1..* List of benefits -\->
                <type><!-\- 1..1 CodeableConcept Type of benefit -\-></type>
                <requirement value="[string]"/><!-\- 0..1 Referral requirements -\->
                <limit>  <!-\- 0..* Benefit limits -\->
                    <value><!-\- 0..1 Quantity Maximum value allowed -\-></value>
                    <code><!-\- 0..1 CodeableConcept Benefit limit details -\-></code>
                </limit>
            </benefit>
        </coverage>-->
        <!--<plan>  <!-\- 0..* Plan details -\->
            <identifier>
                
            </identifier>
            <type><!-\- 0..1 CodeableConcept Type of plan -\-></type>
            <coverageArea><!-\- 0..* Reference(Location) Where product applies -\-></coverageArea>
            <network><!-\- 0..* Reference(Organization) What networks provide coverage -\->
            
            
            
            </network>
            <generalCost>  <!-\- 0..* Overall costs -\->
                <type><!-\- 0..1 CodeableConcept Type of cost -\-></type>
                <groupSize value="[positiveInt]"/><!-\- 0..1 Number of enrollees -\->
                <cost><!-\- 0..1 Money Cost value -\-></cost>
                <comment value="[string]"/><!-\- 0..1 Additional cost information -\->
            </generalCost>
            <specificCost>  <!-\- 0..* Specific costs -\->
                <category><!-\- 1..1 CodeableConcept General category of benefit -\-></category>
                <benefit>  <!-\- 0..* Benefits list -\->
                    <type><!-\- 1..1 CodeableConcept Type of specific benefit -\-></type>
                    <cost>  <!-\- 0..* List of the costs -\->
                        <type><!-\- 1..1 CodeableConcept Type of cost -\-></type>
                        <applicability><!-\- 0..1 CodeableConcept in-network | out-of-network | other -\-></applicability>
                        <qualifiers><!-\- 0..* CodeableConcept Additional information about the cost -\-></qualifiers>
                        <value><!-\- 0..1 Quantity The actual cost value -\-></value>
                    </cost>
                </benefit>
            </specificCost>
        </plan>-->
    </InsurancePlan>
    
    </xsl:template>
    <xsl:template name="pog_meta_security_organization">
        <meta>
            <xsl:variable name="EOB_PARENTFILE_NAME" select="$FOR_ROOT/parentfile"/>
            <source>
                <xsl:attribute name="value">
                    <xsl:value-of select="$EOB_PARENTFILE_NAME"/>
                </xsl:attribute>
            </source>
            <profile value="http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyItem"/>
            
        </meta>
    </xsl:template>
  
    
</xsl:stylesheet>