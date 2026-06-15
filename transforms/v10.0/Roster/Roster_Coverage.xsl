<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
<!--    xmlns="http://hl7.org/fhir">-->
    <xsl:preserve-space elements="*"/>


    <xsl:variable name="PTT_MEMBER_DEMOGRAPHICS" select="member"/>
    <xsl:variable name="PTT_MEMBER_ADDRESS" select="member/addresses/address"/>
    <xsl:variable name="PTT_CUSTOMER_PREFIX" select="$PTT_MEMBER_DEMOGRAPHICS/customername"/>
    <xsl:variable name="ORG_PAYOR" select="$PTT_MEMBER_DEMOGRAPHICS/health_coverage/payor"/>
    <xsl:variable name="isORG_PAYOR_NAME" select = "$ORG_PAYOR/name != ''"/>
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="PTT_GENDER">
        <xsl:value-of select="$PTT_MEMBER_DEMOGRAPHICS/gender"/>
    </xsl:variable>
    <xsl:variable name="PTT_BIRTHDATE">
        <xsl:value-of select="$PTT_MEMBER_DEMOGRAPHICS/birth_date"/>
    </xsl:variable>

    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">


        <Coverage xmlns="http://hl7.org/fhir">
            <!-- from Resource: id, meta, implicitRules, and language -->
            <!-- from DomainResource: text, contained, extension, and modifierExtension -->

            <id>
                <xsl:attribute name="value">
                    <xsl:value-of
                        select="concat($PTT_CUSTOMER_PREFIX, '-', $PTT_MEMBER_DEMOGRAPHICS/unique_record_identifier)"
                    />
                </xsl:attribute>
            </id>
            
            <contained>
                <xsl:if test="$isORG_PAYOR_NAME"><xsl:call-template name="Internal_payor_org_container"/></xsl:if>
            </contained>
            <meta>
                <xsl:variable name="EOB_PARENTFILE_NAME"
                    select="$PTT_MEMBER_DEMOGRAPHICS/parentfile"/>
                <source>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$EOB_PARENTFILE_NAME"/>
                    </xsl:attribute>
                </source>
            </meta>
            <identifier>
                <type>
                    <coding>
                        <system>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="('http://terminology.hl7.org/CodeSystem/v2-0203')"/>
                            </xsl:attribute>
                        </system>
                        <code>
                            <xsl:attribute name="value">
                                <xsl:value-of select="('MB')"/>
                            </xsl:attribute>
                        </code>
                        <display>
                            <xsl:attribute name="value">
                                <xsl:value-of select="'Member Number'"/>
                            </xsl:attribute>
                        </display>
                    </coding>
                </type>
                <value>
                    <xsl:attribute name="value">
                        <xsl:value-of select="($PTT_MEMBER_DEMOGRAPHICS/member_id)"/>
                    </xsl:attribute>

                </value>

            </identifier>
            <!-- 1..1 active | cancelled | draft | entered-in-error -->
     <!--       <xsl:choose>
                <xsl:when test="$PTT_MEMBER_DEMOGRAPHICS/health_coverage/coverage_period/end != ''">
                    <xsl:choose>

                        <xsl:when
                            test="$PTT_MEMBER_DEMOGRAPHICS/health_coverage/coverage_period/end > current-date()">
                            <status value="active"/>
                        </xsl:when>
                        <xsl:when
                            test="current-date() > $PTT_MEMBER_DEMOGRAPHICS/health_coverage/coverage_period/end">
                            <status value="cancelled"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <status value="active"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$PTT_MEMBER_DEMOGRAPHICS/health_coverage/coverage_period/end">
                    <status value="cancelled"/>
                </xsl:when>
                <xsl:otherwise>
                    <status value="active"/>
                </xsl:otherwise>
            </xsl:choose>-->
            <status value="active"/>
            
            <type><!-- 0..1 CodeableConcept Coverage category such as medical or accident -->
            </type>
            <policyHolder>
                <!-- 0..1 Reference(Organization|Patient|RelatedPerson) Owner of the policy -->
                <xsl:variable name="PTT_policyHolder"
                    select="$PTT_MEMBER_DEMOGRAPHICS/subscriber_id"/>
                <reference>

                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="concat('Patient/', $PTT_CUSTOMER_PREFIX, '-', $PTT_policyHolder)"/>
                        <!-- <xsl:value-of select="$PTT_beneficiary"/> -->
                    </xsl:attribute>
                </reference>

            </policyHolder>
            <subscriber>
                <!-- 0..1 Reference(Patient|RelatedPerson) Subscriber to the policy -->

                <xsl:variable name="PTT_subscriber_id"
                    select="$PTT_MEMBER_DEMOGRAPHICS/subscriber_id"/>
                <reference>

                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="concat('Patient/', $PTT_CUSTOMER_PREFIX, '-', $PTT_subscriber_id)"/>
                        <!-- <xsl:value-of select="$PTT_beneficiary"/> -->
                    </xsl:attribute>
                </reference>

            </subscriber>
            <subscriberId>
                <!-- 0..* Identifier ID assigned to the subscriber -->
                <xsl:attribute name="value">
                    <xsl:value-of select="$PTT_MEMBER_DEMOGRAPHICS/subscriber_id"/>
                </xsl:attribute>
            </subscriberId>
            <beneficiary>
                <!-- 1..1 Reference(Patient) Plan beneficiary -->
                <xsl:variable name="PTT_beneficiary"
                    select="$PTT_MEMBER_DEMOGRAPHICS/unique_person_ids[1]/unique_person_id"/>
                <reference>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="concat('Patient/', $PTT_CUSTOMER_PREFIX, '-', $PTT_beneficiary)"/>
                        <!-- <xsl:value-of select="$PTT_beneficiary"/> -->
                    </xsl:attribute>
                </reference>
            </beneficiary>
            <dependent value=""/>
            <!-- 0..1 Dependent number -->
            <relationship>
                <!-- 0..1 CodeableConcept Beneficiary relationship to the subscriber -->

                <xsl:variable name="PTT_relationship">
                    <!--child,parent , spouse ,  common, other, self, injured-->
                    <xsl:choose>
                        <xsl:when
                            test="
                                lower-case($PTT_MEMBER_DEMOGRAPHICS/relationship) = 'child' or 'parent'
                                or 'spouse' or 'common' or 'self' or 'other' or 'injured'">
                            <xsl:value-of select="lower-case($PTT_MEMBER_DEMOGRAPHICS/relationship)"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'other'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <coding>
                    <system>
                        <xsl:attribute name="value">
                            <xsl:value-of
                                select="'http://terminology.hl7.org/CodeSystem/subscriber-relationship'"
                            />
                        </xsl:attribute>
                    </system>
                    <code>
                        <xsl:attribute name="value">
                            <xsl:value-of
                                select="lower-case($PTT_relationship)"
                            />
                        </xsl:attribute>
                    </code>
                    <display>
                        <xsl:attribute name="value">
                            <xsl:value-of select="$PTT_relationship"/>
                        </xsl:attribute>
                    </display>
                </coding>
            </relationship>
            <period>
                <!-- 0..1 Period Coverage start and end dates -->
                <start>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="$PTT_MEMBER_DEMOGRAPHICS/health_coverage/coverage_period/start"
                        />
                    </xsl:attribute>
                </start>
                <end>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="$PTT_MEMBER_DEMOGRAPHICS/health_coverage/coverage_period/end"/>
                    </xsl:attribute>

                </end>
            </period>
            <payor>
                <!-- 0..1 Reference(Organization) Issuer of the policy -->
              
                    <xsl:choose>
                        <xsl:when test="$isORG_PAYOR_NAME">
                            <reference>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="'#PayorOrganizationDerived1'"/>
                                </xsl:attribute>
                            </reference>
                        </xsl:when>
                        <xsl:otherwise>     
                            <xsl:variable name="PTT_Organization"
                                select="$PTT_MEMBER_DEMOGRAPHICS/unique_person_ids/unique_person_id_assigner"/>                                               
                            <reference>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="concat('Organization/', $PTT_CUSTOMER_PREFIX, '-', $PTT_Organization)"
                                    />
                                </xsl:attribute>
                            </reference>
                        </xsl:otherwise>
                    </xsl:choose>
            </payor>

            <!--group_number-->
            <!--
            <class>
                <type>
                    <coding>
                        <system value="http://terminology.hl7.org/CodeSystem/coverage-class"/>
                        <code value="group"/>
                    </coding>
                </type>
                <value>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$PTT_MEMBER_DEMOGRAPHICS/health_coverage/group_number"
                        />
                        
                    </xsl:attribute>
                </value>
            <name>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$PTT_MEMBER_DEMOGRAPHICS/health_coverage/group_number"
                        />
                    </xsl:attribute>
                </name>
            </class> -->
            <!--policy_number-->
            
            <class>
                <type>
                    <coding>
                        <system value="http://terminology.hl7.org/CodeSystem/coverage-class"/>
                        <code value="group"/>
                    </coding>
                </type>
                <xsl:choose>
                    <xsl:when test=" empty($PTT_MEMBER_DEMOGRAPHICS/health_coverage/policy_number)">
                        <value>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="'unknown'"/>
                            </xsl:attribute>
                        </value>
                    </xsl:when>
                    <xsl:otherwise>
                        <value>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="$PTT_MEMBER_DEMOGRAPHICS/health_coverage/policy_number"/>
                            </xsl:attribute>
                            
                        </value>
                    </xsl:otherwise>
                </xsl:choose>
                <name>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="$PTT_MEMBER_DEMOGRAPHICS/health_coverage/policy_number"/>
                    </xsl:attribute>
                </name>
            </class> 
            <!--plan_name-->
            <class>
                <type>
                    <coding>
                        <system value="http://terminology.hl7.org/CodeSystem/coverage-class"/>
                        <code value="plan"/>
                    </coding>
                </type>
                <xsl:choose>
                    <xsl:when test="empty($PTT_MEMBER_DEMOGRAPHICS/health_coverage/plan_number)">
                        <!-- http://hl7.org/fhir/StructureDefinition/data-absent-reason -->
                        <value>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="'unknown'"/>
                            </xsl:attribute>
                        </value>
                    </xsl:when>
                    <xsl:otherwise>
                        <value>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="$PTT_MEMBER_DEMOGRAPHICS/health_coverage/plan_number"/>
                            </xsl:attribute>
                            <!-- add DAR Reason -->
                        </value>
                    </xsl:otherwise>
                </xsl:choose>
             </class>
            <order value="1"/>
            <!-- 0..1 Relative order of the coverage -->
            <network>
                <xsl:attribute name="value">
                    <xsl:value-of select="$PTT_MEMBER_DEMOGRAPHICS/health_coverage/group_number"/>
                </xsl:attribute>
            </network>
            <!-- 0..1 Insurer network -->
            <costToBeneficiary>
                <!-- 0..* Patient payments for services/products -->
                <type><!-- 0..1 CodeableConcept Cost category --></type>
                <category><!-- 0..1 CodeableConcept Benefit classification --></category>
                <network><!-- 0..1 CodeableConcept In or out of network --></network>
                <unit><!-- 0..1 CodeableConcept Individual or family --></unit>
                <term><!-- 0..1 CodeableConcept Annual or lifetime --></term>
                <value><!-- 0..1 Quantity(SimpleQuantity)|Money The amount or percentage due from the beneficiary --></value>
                <exception>
                    <!-- 0..* Exceptions for patient payments -->
                    <type><!-- 1..1 CodeableConcept Exception category --></type>
                    <period><!-- 0..1 Period The effective period of the exception --></period>
                </exception>
            </costToBeneficiary>
            <subrogation value=""/>
            <!-- 0..1 Reimbursement to insurer -->
            <contract><!-- 0..* Reference(Contract) Contract details --></contract>
            <insurancePlan><!-- 0..1 Reference(InsurancePlan) Insurance plan details --></insurancePlan>
        </Coverage>
    </xsl:template>
    <xsl:template name="Internal_payor_org_container">
        <xsl:variable name="ORG_VAR" select="$isORG_PAYOR_NAME"/>
        <!-- 0..1 Reference(Organization) Issuer of the policy -->
        <Organization xmlns="http://hl7.org/fhir">                
            <id>
                <xsl:attribute name="value">
                    <xsl:value-of select="'PayorOrganizationDerived1'"/>
                </xsl:attribute>
            </id>
            
            <!-- tax -->
            <xsl:for-each select="$ORG_PAYOR/tax">
                <xsl:if test="./value != ''">
                    <identifier>
                        <type>
                            <coding>
                                <system>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="'http://terminology.hl7.org/CodeSystem/v2-0203'"/>
                                    </xsl:attribute>
                                </system>
                                <code>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="'TAX'"/>
                                    </xsl:attribute>
                                </code>
                            </coding>
                        </type>
                        <system>
                            <xsl:attribute name="value">
                                <xsl:value-of select="'urn:oid:2.16.840.1.113883.4.4'"/>
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
            <!-- for naic_codes -->
            <xsl:for-each select="$ORG_PAYOR/naic_code">
                <xsl:if test="./value != ''">
                    <identifier>
                        <type>
                            <coding>
                                <system>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="'http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBIdentifierType'"/>
                                    </xsl:attribute>
                                </system>
                                <code>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="'naiccode'"/>
                                    </xsl:attribute>
                                </code>
                            </coding>
                        </type>
                        <system>
                            <xsl:attribute name="value">
                                <xsl:value-of select="'urn:oid:2.16.840.1.113883.6.300'"/>
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
            
            <!-- payer_id -->
            <xsl:for-each select="$ORG_PAYOR/payer_id">
                <xsl:if test="./value != ''">    
                    <identifier>
                        <type>
                            <coding>
                                <system>
                                    <xsl:attribute name="system">
                                        <xsl:value-of select="'http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBIdentifierType'"/>
                                    </xsl:attribute>
                                </system>
                                <code>
                                    <xsl:attribute name="code">
                                        <xsl:value-of select="'payerid'"/>
                                    </xsl:attribute>
                                </code>
                            </coding>
                        </type> 
                        <xsl:if test="./system !=''">
                            <system>
                                <xsl:attribute name="system">
                                    <xsl:value-of select="./system"/>
                                </xsl:attribute>                                
                            </system>
                        </xsl:if>
                        <value>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./value"/>
                            </xsl:attribute>
                        </value>
                    </identifier>
                </xsl:if>
            </xsl:for-each>
            
            <active>
                <!-- value="[boolean]"0..1 Whether the organization's record is still in active use -->
                <xsl:attribute name="value">
                    <xsl:choose>
                        <xsl:when test="$ORG_PAYOR/is_active = 'false'">
                            <xsl:value-of select="'false'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'true'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </active>
            <name>
                <xsl:attribute name="value">
                    <xsl:value-of select="$ORG_PAYOR/name"/>
                </xsl:attribute>
            </name>
            <xsl:if test="$ORG_PAYOR/alias != ''">
                <xsl:for-each select="$ORG_PAYOR/alias">
                    <alias>
                        <xsl:attribute name="value">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </alias>      
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$ORG_PAYOR/telecoms != ''">
                <xsl:for-each select="$ORG_PAYOR/telecoms/telecom">
                    <telecom>
                        <system>
                            <xsl:attribute name="value">
                                <xsl:value-of select="system"/>
                            </xsl:attribute>
                        </system>
                        <value>
                            <xsl:attribute name="value">
                                <xsl:value-of select="value"/>
                            </xsl:attribute>
                        </value>
                        <xsl:if test="use != ''">
                            <use>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="use"/>
                                </xsl:attribute>
                            </use>
                        </xsl:if>
                        <xsl:if test="rank != ''">
                            <rank>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="rank"/>
                                </xsl:attribute>
                            </rank>
                        </xsl:if>
                        <xsl:if test="period != ''">
                            <period>
                                <xsl:if test="period/start != ''">
                                    <start>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="period/start"/>
                                        </xsl:attribute>
                                    </start>
                                </xsl:if>
                                <xsl:if test="period/end != ''">
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
            </xsl:if>
            <xsl:if test="$ORG_PAYOR/addresses != ''">
                <xsl:for-each select="$ORG_PAYOR/addresses/address">
                    <address>
                        <xsl:if test="use != ''">
                            <use>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="use"/>
                                </xsl:attribute>
                            </use>
                        </xsl:if>
                        <xsl:if test="type != ''">
                            <type>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="type"/>
                                </xsl:attribute>
                            </type>
                        </xsl:if>
                        <xsl:if test="text != ''">
                            <text>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="text"/>
                                </xsl:attribute>
                            </text>
                        </xsl:if>
                        <xsl:for-each select="line">
                            <line>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="."/>
                                </xsl:attribute>
                            </line>
                        </xsl:for-each> 
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
                                <xsl:value-of select="postal_code"/>
                            </xsl:attribute>
                        </postalCode>
                        <xsl:if test="country != ''">
                            <country>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="country"/>
                                </xsl:attribute>
                            </country>
                        </xsl:if>
                        <xsl:if test="period != ''">
                            <period>
                                <xsl:if test="period/start != ''">
                                    <start>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="period/start"/>
                                        </xsl:attribute>
                                    </start>
                                </xsl:if>
                                <xsl:if test="period/end != ''">
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
            </xsl:if>
            
        </Organization>
    </xsl:template>
</xsl:stylesheet>
