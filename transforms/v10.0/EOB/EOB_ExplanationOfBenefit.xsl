<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="EOB_DEMOGRAPHIC" select="eob_list/eob"/>
    <xsl:variable name="EOB_LOCATIONS" select="eob_list/eob/addresses"/>
    <xsl:variable name="EOB_MEMBER" select="eob_list/eob/patient/person"/>
    <xsl:variable name="EOB_MEMBER_INSURANCE" select="eob_list/eob/insurances/insurance"/>
    <xsl:variable name="EOB_SUBSCRIBER" select="$EOB_DEMOGRAPHIC/patient/person/subscriber_id"/>
    <xsl:variable name="EOB_CUSTOMER_PREFIX" select="$EOB_DEMOGRAPHIC/customername"/>
    <xsl:variable name="EOB_PAYOR" select="$EOB_MEMBER_INSURANCE/coverage/payor"/>
    <xsl:variable name="isEOB_PAYOR_NAME" select="$EOB_PAYOR/name != ''"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        <ExplanationOfBenefit xmlns="http://hl7.org/fhir">
            <!-- from Resource: id, meta, implicitRules, and language -->
            <!-- from DomainResource: text, contained, extension, and modifierExtension -->
            <id>
                <xsl:attribute name="value">
                    <xsl:value-of
                        select="concat($EOB_CUSTOMER_PREFIX, '-', $EOB_DEMOGRAPHIC/eob_identifier/value)"
                    />
                </xsl:attribute>
            </id>
            <meta>
                
                <xsl:variable name="EOB_PARENTFILE_NAME" select="$EOB_DEMOGRAPHIC/parentfile"/>
                <source>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$EOB_PARENTFILE_NAME"/>
                    </xsl:attribute>
                </source>
                <profile value="http://hl7.org/fhir/us/carin-bb/StructureDefinition/C4BB-ExplanationOfBenefit"/>
            </meta>
            <contained>
                <!-- ?? 0..* Identifier Identifies this organization across multiple systems -->
                <xsl:call-template name="Internal_coverage_container"/>
                <xsl:call-template name="Internal_provider_container"/>
                <xsl:call-template name="Internal_insurer_container"/>
                <xsl:call-template name="Internal_payee_container"/>
                <xsl:call-template name="Internal_careteam_container"/>
                <xsl:call-template name="Internal_facility_container"/>
                <xsl:if test="$isEOB_PAYOR_NAME">
                    <xsl:call-template name="Internal_payor_org_container"/>
                </xsl:if>
            </contained>
            <identifier>
                <type>
                    <coding>
                        <system value="http://terminology.hl7.org/CodeSystem/v2-0203"/>
                        <code value="UCID"/>
                    </coding>
                </type>
                <!-- 0..* Identifier Business Identifier for the resource -->
                <value>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$EOB_DEMOGRAPHIC/eob_identifier/value"/>
                    </xsl:attribute>
                </value>
            </identifier>
            <!-- Commenting it to avoid unnecessary tags <traceNumber> --><!-- 0..* Identifier Number for tracking --><!-- </traceNumber> -->
            <status>
                <xsl:choose>
                    <xsl:when
                        test="$EOB_DEMOGRAPHIC/status = 'true' or $EOB_DEMOGRAPHIC/status = 'active'">
                        <xsl:attribute name="value">
                            <xsl:value-of select="'active'"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="value">
                            <xsl:value-of select="'cancelled'"/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </status>
            <type>
                <!-- 1..1 CodeableConcept Category or discipline -->
                <coding>
                    <system value="http://terminology.hl7.org/CodeSystem/claim-type"/>
                    <code>
                        <xsl:attribute name="value">
                            <xsl:value-of select="lower-case($EOB_DEMOGRAPHIC/type)"/>
                        </xsl:attribute>
                    </code>
                </coding>
            </type>
            <!-- if added for this task: https://teschglobal.atlassian.net/browse/SHSI-235 -->
            <xsl:if test="$EOB_DEMOGRAPHIC/sub_type != ''">
                <subType>
                    <!-- 0..1 CodeableConcept More granular claim type -->
                    <coding>
                        <system value="http://terminology.hl7.org/CodeSystem/ex-claimsubtype"/>
                        <code>
                            <xsl:choose>
                                <xsl:when test="$EOB_DEMOGRAPHIC/sub_type = 'Outpatient'">
                                    <xsl:attribute name="value">outpatient</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$EOB_DEMOGRAPHIC/sub_type = 'Inpatient'">
                                    <xsl:attribute name="value">inpatient</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$EOB_DEMOGRAPHIC/sub_type"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </code>
                    </coding>
                </subType>
            </xsl:if>
            <use>
                <!-- 1..1 claim | preauthorization | predetermination -->
                <xsl:attribute name="value">
                    <xsl:value-of select="$EOB_DEMOGRAPHIC/use"/>
                </xsl:attribute>
            </use>
            <patient>
                <!-- 1..1 Reference(Patient) The recipient of the products and services -->
                <xsl:variable name="EOB_VAR"
                    select="concat($EOB_CUSTOMER_PREFIX, '-', $EOB_DEMOGRAPHIC/patient/person/unique_person_id)"/>
                <xsl:variable name="inputString" select="$EOB_DEMOGRAPHIC/patient/reference"/>
                <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                <xsl:choose>
                    <xsl:when test="exists($EOB_DEMOGRAPHIC/patient/reference)">
                        <xsl:variable name="inputString" select="$EOB_DEMOGRAPHIC/patient/reference"/>
                        <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                        <reference>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="concat($parts[1], '/', $EOB_CUSTOMER_PREFIX, '-', $parts[2])"
                                />
                            </xsl:attribute>
                        </reference>
                    </xsl:when>
                    <xsl:otherwise>
                        <reference>
                            <xsl:attribute name="value">
                                <xsl:value-of select="concat('Patient/', $EOB_VAR)"/>
                            </xsl:attribute>
                        </reference>
                    </xsl:otherwise>
                </xsl:choose>
            </patient>
            <billablePeriod>
                <!-- 0..1 Period Relevant time frame for the claim -->
                <start>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$EOB_DEMOGRAPHIC/billable_period/start"/>
                    </xsl:attribute>
                </start>
                <end>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$EOB_DEMOGRAPHIC/billable_period/end"/>
                    </xsl:attribute>
                </end>
            </billablePeriod>
            <created>
                <!-- 1..1 Response creation date -->
                <!-- <xsl:value-of select="format-dateTime($dateTimeValue, '[D01]/[M01]/[Y0001] [H01]:[m01]:[s01]')"/>-->
                <xsl:attribute name="value">
                    <xsl:variable name="created" select="$EOB_DEMOGRAPHIC/created"/>                    
                    <xsl:choose>
                        <!-- If it's DATE only -->
                        <xsl:when test="matches($created, '^\d{4}-\d{2}-\d{2}$')">
                            <xsl:value-of select="concat($created, 'T00:00:00Z')"/>
                        </xsl:when>
                        
                        <!-- If it's already dateTime -->
                        <xsl:otherwise>
                            <xsl:value-of select="
                                format-dateTime(
                                xs:dateTime($created),
                                '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s02].000Z'
                                )
                                "/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- <xsl:value-of select="$EOB_DEMOGRAPHIC/created"/> -->
                </xsl:attribute>
            </created>
            <!-- Commenting it to avoid unnecessary tags <enterer> --><!-- 0..1 Reference(Patient|Practitioner|PractitionerRole|RelatedPerson) Author of the claim -->
                <!-- unknown-->
            <!-- </enterer> -->
            <insurer>
                <xsl:choose>
                    <xsl:when test="$EOB_DEMOGRAPHIC/insurer/reference">
                        <xsl:variable name="inputString" select="$EOB_DEMOGRAPHIC/insurer/reference"/>
                        <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                        <reference>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="concat($parts[1], '/', $EOB_CUSTOMER_PREFIX, '-', $parts[2])"
                                />
                            </xsl:attribute>
                        </reference>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- 0..1 Reference(Organization) Party responsible for reimbursement -->
                        <reference>
                            <xsl:attribute name="value">
                                <xsl:value-of select="'#InsurerOrganizationDerived1'"/>
                            </xsl:attribute>
                        </reference>
                    </xsl:otherwise>
                </xsl:choose>
            </insurer>
            <provider>
                <!-- 0..1 Reference(Organization|Practitioner|PractitionerRole) Party responsible for the claim -->
                <xsl:variable name="EOB_VAR"
                    select="./$EOB_DEMOGRAPHIC/provider/providing_organization"/>
                <xsl:choose>
                    <xsl:when test="$EOB_DEMOGRAPHIC/provider/reference">
                        <xsl:variable name="inputString"
                            select="$EOB_DEMOGRAPHIC/provider/reference"/>
                        <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                        <reference>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="concat($parts[1], '/', $EOB_CUSTOMER_PREFIX, '-', $parts[2])"
                                />
                            </xsl:attribute>
                        </reference>
                    </xsl:when>
                    <xsl:when test="$EOB_VAR != ''">
                        <reference>
                            <xsl:attribute name="value">
                                <xsl:value-of select="'#ProviderOrganizationDerived1'"/>
                            </xsl:attribute>
                        </reference>
                    </xsl:when>
                    <xsl:otherwise>
                        <reference>
                            <xsl:attribute name="value">
                                <xsl:value-of select="'#ProviderPractitionerDerived1'"/>
                            </xsl:attribute>
                        </reference>
                    </xsl:otherwise>
                </xsl:choose>
            </provider>
            <priority>
                <!-- 0..1 CodeableConcept Desired processing urgency -->
                <coding>
                    <system value="http://terminology.hl7.org/CodeSystem/processpriority"/>
                    <code value="normal"/>
                </coding>
            </priority>
            <!-- Commenting it to avoid unnecessary tags <fundsReserveRequested> --><!-- 0..1 CodeableConcept For whom to reserve funds --><!-- </fundsReserveRequested> -->
            <!-- Commenting it to avoid unnecessary tags <fundsReserve> --><!-- 0..1 CodeableConcept Funds reserved status --><!-- </fundsReserve> -->
            <xsl:if test="eob/relateds">
                <relateds>
                    <xsl:for-each select="eob_list/eob/relateds/related">
                        <related>
                            <claim>
                                <xsl:if test="claim/identifier">
                                    <identifier>
                                        <value>
                                            <xsl:value-of select="claim/identifier/value"/>
                                        </value>
                                        <type>
                                            <text>
                                                <xsl:value-of select="claim/identifier/type"/>
                                            </text>
                                        </type>
                                    </identifier>
                                </xsl:if>
                                <created>
                                    <xsl:attribute name="value">
                                    <xsl:choose>
                                        <xsl:when test="matches(., '^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$')">
                                            <xsl:value-of select="concat(claim/created, 'T00:00:00Z')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="format-dateTime(claim/created, '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s02].000Z')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    </xsl:attribute>
                                </created>
                            </claim>
                            <relationship>
                                <xsl:if test="relationship/code">
                                    <code>
                                        <xsl:value-of select="relationship/code"/>
                                    </code>
                                </xsl:if>
                                <xsl:if test="relationship/system">
                                    <system>
                                        <xsl:value-of select="relationship/system"/>
                                    </system>
                                </xsl:if>
                            </relationship>
                            <reference>
                                <value>
                                    <xsl:value-of select="reference/value"/>
                                </value>
                                <type>
                                    <text>
                                        <xsl:value-of select="reference/type"/>
                                    </text>
                                </type>
                            </reference>
                        </related>
                    </xsl:for-each>
                </relateds>
            </xsl:if>
            <!-- Commenting it to avoid unnecessary tags <prescription> --><!-- 0..1 Reference(MedicationRequest|VisionPrescription) Prescription authorizing services or products --><!-- </prescription> -->
            <!-- Commenting it to avoid unnecessary tags <originalPrescription> --><!-- 0..1 Reference(MedicationRequest) Original prescription if superceded by fulfiller --><!-- </originalPrescription> -->
            <!-- Commenting it to avoid unnecessary tags (not seeing this tag in EOBs) <event> -->
                <!-- 0..* Event information -->
            <!-- <type> --><!-- 1..1 CodeableConcept Specific event --><!-- </type> -->
            <!-- <when> --><!-- 1..1 dateTime|Period Occurance date or period --><!-- </when> -->
            <!-- </event> -->
            <payee>
                <!-- 0..1 Recipient of benefits payable -->
                <!-- <type><!-\- 0..1 CodeableConcept Category of recipient -\-></type> <party><!-\- 0..1 Reference(Organization|Patient|Practitioner|PractitionerRole| RelatedPerson) Recipient reference -\-></party>-->
                <type>
                    <coding>
                        <system>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./payee/type/system"/>
                            </xsl:attribute>
                        </system>
                        <code>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./payee/type/code"/>
                            </xsl:attribute>
                        </code>
                    </coding>
                </type>
                <party>
                    <!-- 0..1 Reference(Organization|Practitioner|PractitionerRole) Party responsible for the claim -->
                    <xsl:variable name="EOB_VAR"
                        select="./$EOB_DEMOGRAPHIC/payee/party/providing_organization"/>
                    <xsl:choose>
                        <xsl:when test="$EOB_DEMOGRAPHIC/payee/party/reference">
                            <xsl:variable name="inputString"
                                select="$EOB_DEMOGRAPHIC/payee/party/reference"/>
                            <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                            <reference>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="concat($parts[1], '/', $EOB_CUSTOMER_PREFIX, '-', $parts[2])"
                                    />
                                </xsl:attribute>
                            </reference>
                        </xsl:when>
                        <xsl:when test="$EOB_VAR != ''">
                            <reference>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="'#PayeeOrganizationDerived1'"/>
                                </xsl:attribute>
                            </reference>
                        </xsl:when>
                        <xsl:otherwise>
                            <reference>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="'#PayeePractitionerDerived1'"/>
                                </xsl:attribute>
                            </reference>
                        </xsl:otherwise>
                    </xsl:choose>
                </party>
            </payee>
            <!-- Commenting it to avoid unnecessary tags <referral> --><!-- 0..1 Reference(ServiceRequest) Treatment Referral --><!-- </referral> -->
            <!-- Commenting it to avoid unnecessary tags <encounter> --><!-- 0..* Reference(Encounter) Encounters associated with the listed treatments --><!-- </encounter> -->
            <xsl:if test="./$EOB_DEMOGRAPHIC/facility">
                <facility>
                    <xsl:for-each select="$EOB_DEMOGRAPHIC/facility/address">
                        <xsl:variable name="EOB_USE" select="./use"/>
                        <xsl:variable name="EOB_TYPE" select="./type"/>
                        <!-- 0..1 Reference(Location) Servicing Facility -->
                        <reference>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="concat('#', $EOB_USE, $EOB_TYPE, '-', 'facilitylocationDerived1')"
                                />
                            </xsl:attribute>
                        </reference>
                        <display>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./$EOB_DEMOGRAPHIC/facility/name"/>
                            </xsl:attribute>
                        </display>
                        
                    </xsl:for-each>
                </facility>
            </xsl:if>
            <xsl:if test="$EOB_DEMOGRAPHIC/claim">
                <claim>
                    <!-- 0..1 Reference(Claim) Claim reference.
                'D9' is the Claim identifier sent to the Payer vs. 'DCN’ which is the Claim identifier assigned by the Payer
                -->
                    <xsl:choose>
                        <xsl:when test="$EOB_DEMOGRAPHIC/claim/identifier/type != 'D9'">
                            <xsl:variable name="EOB_VAR"
                                select="concat($EOB_CUSTOMER_PREFIX, '-', $EOB_DEMOGRAPHIC/claim/identifier/value)"/>
                            <reference>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="concat('Claim/', $EOB_VAR)"/>
                                </xsl:attribute>
                            </reference>
                        </xsl:when>
                        <xsl:otherwise>
                            <identifier>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="concat('Claim/', '-', $EOB_DEMOGRAPHIC/claim/identifier/value)"
                                    />
                                </xsl:attribute>
                            </identifier>
                        </xsl:otherwise>
                    </xsl:choose>
                </claim>
            </xsl:if>            
            <!-- Commenting it to avoid unnecessary tags <claimResponse> --><!-- 0..1 Reference(ClaimResponse) Claim response reference --><!-- </claimResponse> -->
            <outcome>
                <!-- 1..1 queued | complete | error | partial -->
                <xsl:attribute name="value">
                    <xsl:value-of select="$EOB_DEMOGRAPHIC/outcome"/>
                </xsl:attribute>
            </outcome>
            <!-- Commenting it to avoid unnecessary tags <decision> --><!-- 0..1 CodeableConcept Result of the adjudication --><!-- </decision> -->
            <!-- Commenting it to avoid unnecessary tags <disposition/> -->
            <!-- 0..1 Disposition Message -->
            <!-- Commenting it to avoid unnecessary tags <preAuthRef> --><!-- 0..* Preauthorization reference --><!-- </preAuthRef> -->
            <!-- Commenting it to avoid unnecessary tags <preAuthRefPeriod> --><!-- 0..* Period Preauthorization in-effect period --><!-- </preAuthRefPeriod> -->
            <!-- Commenting it to avoid unnecessary tags <diagnosisRelatedGroup> --><!-- 0..1 CodeableConcept Package billing code --><!-- </diagnosisRelatedGroup> -->
            <xsl:for-each select="$EOB_DEMOGRAPHIC/care_teams/care_team">
                <careTeam>
                    <!-- 0..* Care Team members -->
                    <sequence>
                        <xsl:attribute name="value">
                            <xsl:choose>
                                <xsl:when test="./sequence">
                                    <xsl:value-of select="./sequence"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="position()"/>
                                </xsl:otherwise>
                            </xsl:choose>                           
                        </xsl:attribute>
                    </sequence>
                    <!-- 1..1 Order of care team -->
                    <provider>
                        <!-- 1..1 Reference(Organization|Practitioner|PractitionerRole) Practitioner or organization -->
                        <xsl:variable name="EOB_VAR" select="./provider/providing_organization"/>
                        <xsl:choose>
                            <xsl:when test="./provider/reference">
                                <xsl:variable name="inputString" select="./provider/reference"/>
                                <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                                <reference>
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="concat($parts[1], '/', $EOB_CUSTOMER_PREFIX, '-', $parts[2])"
                                        />
                                    </xsl:attribute>
                                </reference>
                            </xsl:when>
                            <xsl:when test="$EOB_VAR != ''">
                                <reference>
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="concat('#', ./sequence, '-', 'Care-teamOrganizationDerived1')"
                                        />
                                    </xsl:attribute>
                                </reference>
                            </xsl:when>
                            <xsl:when test="empty(./sequence)"/>
                            <xsl:otherwise>
                                <reference>
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="concat('#', ./sequence, '-', 'Care-teamPractitionerDerived1')"
                                        />
                                    </xsl:attribute>
                                </reference>
                            </xsl:otherwise>
                        </xsl:choose>
                    </provider>
                    <xsl:choose>
                        <xsl:when test="./is_responsible">
                            <responsible>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./is_responsible"/>
                                </xsl:attribute>
                            </responsible>
                        </xsl:when>
                    </xsl:choose>
                    <!-- 0..1 Indicator of the lead practitioner -->
                    <role>
                        <!-- 0..1 CodeableConcept Function within the team -->
                        <coding>
                            <system>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./role/system"/>
                                </xsl:attribute>
                            </system>
                            <code>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./role/code"/>
                                </xsl:attribute>
                            </code>
                        </coding>
                    </role>
                    <!-- Commenting it to avoid unnecessary tags <specialty> --><!-- 0..1 CodeableConcept Practitioner or provider specialization --><!-- </specialty> -->
                </careTeam>
            </xsl:for-each>
            <xsl:for-each select="$EOB_DEMOGRAPHIC/supporting_infos">
                <xsl:for-each select="supporting_info/*">
                    <supportingInfo>
                        <!-- 0..* Supporting information -->
                        <sequence>
                            <!-- 1..1 Information instance identifier -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="./sequence"/>
                            </xsl:attribute>
                        </sequence>
                        <category>
                            <!-- 1..1 CodeableConcept Classification of the supplied information -->
                            <coding>
                                <system>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./category/system"/>
                                    </xsl:attribute>
                                </system>
                                <code>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./category/code"/>
                                    </xsl:attribute>
                                </code>
                            </coding>
                        </category>
                        <xsl:if test="./code/code/text()!='' or not(empty(./code/code))">
                            <code>
                                <!-- 0..1 CodeableConcept Type of information -->
                                <coding>
                                    <system>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./category/system"/>
                                        </xsl:attribute>
                                    </system>
                                    <code>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./code/code"/>
                                        </xsl:attribute>
                                    </code>
                                </coding>
                            </code>
                        </xsl:if>
                        <!-- 0..1 date|Period When it occurred -->
                        <xsl:choose>
                            <xsl:when test="./timing/timingPeriod/start">
                                <timingPeriod>
                                    <start>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./timing/timingPeriod/start"/>
                                        </xsl:attribute>
                                    </start>
                                    <end>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./timing/timingPeriod/end"/>
                                        </xsl:attribute>
                                    </end>
                                </timingPeriod>
                            </xsl:when>
                            <xsl:otherwise>
                                <timingPeriod>
                                    <start>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./timing"/>
                                        </xsl:attribute>
                                    </start>
                                </timingPeriod>
                            </xsl:otherwise>
                        </xsl:choose>
                        <value><!-- 0..1 boolean|string|Quantity|Attachment|Reference(Any) Data to be provided --></value>
                        <reason><!-- 0..1 Coding Explanation for the information --></reason>
                    </supportingInfo>
                </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$EOB_DEMOGRAPHIC/diagnoses/diagnosis">
                <diagnosis>
                    <!-- 0..* Pertinent diagnosis information -->
                    <sequence>
                        <!-- 1..1 Information instance identifier -->
                        <xsl:attribute name="value">
                            <xsl:value-of select="./sequence"/>
                        </xsl:attribute>
                    </sequence>
                    <diagnosisCodeableConcept>
                        <coding>
                            <system value="http://hl7.org/fhir/ValueSet/icd-10"/>
                            <code>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./diagnosis_code/coding/code"/>
                                </xsl:attribute>
                            </code>
                        </coding>
                    </diagnosisCodeableConcept>
                    <xsl:if test="./type">
                        <type>
                            <coding>
                                <system value="http://terminology.hl7.org/CodeSystem/ex-diagnosistype"/>
                                <code>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./type/code"/>
                                    </xsl:attribute>
                                </code>
                            </coding>
                        </type>
                    </xsl:if>                    
                    <!-- <packageCode> <coding> <system value="http://terminology.hl7.org/CodeSystem/ex-diagnosisrelatedgroup"/> <code value="400"/> <display value="Head trauma - concussion"/> </coding> </packageCode>-->
                    <xsl:if test="./on_admission">
                        <onAdmission>
                            <!-- 0..1 CodeableConcept Present on admission -->
                            <coding>
                                <system>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./on_admission/system"/>
                                    </xsl:attribute>
                                </system>
                                <code>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./on_admission/code"/>
                                    </xsl:attribute>
                                </code>
                            </coding>
                        </onAdmission>
                    </xsl:if>                    
                </diagnosis>
            </xsl:for-each>
            <xsl:for-each select="$EOB_DEMOGRAPHIC/procedures/procedure">
                <procedure>
                    <!-- 0..* Clinical procedures performed -->
                    <sequence>
                        <!-- 1..1 Information instance identifier -->
                        <xsl:attribute name="value">
                            <xsl:value-of select="./sequence"/>
                        </xsl:attribute>
                    </sequence>
                    <type>
                        <!-- 0..* CodeableConcept Category of Procedure -->
                        <coding>
                            <system>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="normalize-space(./procedure_code/coding/system)"/>
                                </xsl:attribute>
                            </system>
                            <code>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="normalize-space(./type)"/>
                                </xsl:attribute>
                            </code>
                        </coding>
                    </type>
                    <date>
                        <!-- 0..1 When the procedure was performed -->
                        <xsl:attribute name="value">
                            <xsl:value-of select="./date"/>
                        </xsl:attribute>
                    </date>
                    <procedureCodeableConcept>
                        <coding>
                            <system>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="normalize-space(./procedure_code/coding/system)"/>
                                </xsl:attribute>
                            </system>
                            <code>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="normalize-space(./procedure_code/coding/code)"/>
                                </xsl:attribute>
                            </code>
                        </coding>
                        <text>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="normalize-space(./procedure_code/coding/display)"/>
                            </xsl:attribute>
                        </text>
                    </procedureCodeableConcept>
                    <udi>
                        <!-- <!-\- 0..* Reference(Device) Unique device identifier -\-> <!-\- need to create device logic for FHIR resource Cant find node in samples -\-> <xsl:variable name="EOB_VAR" select="./procedure_code/coding/code/unknown"/> <xsl:choose> <xsl:when test="$EOB_VAR"> <reference> <xsl:attribute name="value"> <xsl:value-of select="concat('Device/', $EOB_CUSTOMER_PREFIX, '-', $EOB_VAR)" /> </xsl:attribute> </reference> </xsl:when> </xsl:choose> -->
                    </udi>
                </procedure>
            </xsl:for-each>
            <!-- Commenting it to avoid unnecessary tags <precedence/> -->
            <!-- 0..1 Precedence (primary, secondary, etc.) -->
            <xsl:for-each select="$EOB_DEMOGRAPHIC/insurances/insurance">
                <insurance>
                    <!-- 0..* Patient insurance information -->
                    <focal>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./is_focal"/>
                        </xsl:attribute>
                    </focal>
                    <!-- 1..1 Coverage to be used for adjudication -->
                    <coverage>
                        <!-- 1..1 Reference(Coverage) Insurance information -->
                        <xsl:variable name="EOB_PLAN_ID"
                            select="./coverage/beneficiary/member_id_system"/>
                        <xsl:choose>
                            <xsl:when test="./coverage/reference">
                                <xsl:variable name="inputString" select="./coverage/reference"/>
                                <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                                <reference>
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="concat($parts[1], '/', $EOB_CUSTOMER_PREFIX, '-', $parts[2])"
                                        />
                                    </xsl:attribute>
                                </reference>
                            </xsl:when>
                            <xsl:otherwise>
                                <reference>
                                    <xsl:attribute name="value">
                                        <!-- <xsl:value-of select="concat('Coverage/', $EOB_CUSTOMER_PREFIX, '-', $EOB_SUBSCRIBER, $EOB_PLAN_ID)"/> -->
                                        <xsl:value-of
                                            select="concat('#CoverageDerived', position())"/>
                                    </xsl:attribute>
                                </reference>
                            </xsl:otherwise>
                        </xsl:choose>
                    </coverage>
                    <!--<preAuthRef value="[string]"/><!-\- 0..* Prior authorization reference number -\->-->
                </insurance>
                <!--<preAuthRef value="[string]"/><!-\- 0..* Prior authorization reference number -\->-->
            </xsl:for-each>
            <!-- No information on this will comeback -->
            <!-- Commenting it to avoid unnecessary tags <accident> -->
                <!-- 0..1 Details of the event -->
            <!-- <date/> -->
                <!-- 0..1 When the incident occurred -->
            <!-- <type> --><!-- 0..1 CodeableConcept The nature of the accident icon --><!-- </type> -->
            <!-- <location> --><!-- 0..1 Address|Reference(Location) Where the event occurred --><!-- </location> -->
            <!-- </accident> -->
            <!-- No information on this will comeback -->
            <!-- Commenting it to avoid unnecessary tags <patientPaid> --><!-- 0..1 Money Paid by the patient --><!-- </patientPaid> -->
            <xsl:for-each select="$EOB_DEMOGRAPHIC/items/item">
                <item>
                    <!-- 0..* Product or service provided -->
                    <sequence>
                        <!-- 1..1 Information instance identifier -->
                        <xsl:attribute name="value">
                            <xsl:value-of select="./sequence"/>
                        </xsl:attribute>
                    </sequence>
                    <xsl:for-each select="./care_team_sequence">
                        <careTeamSequence>
                            <!-- 0..* Applicable care team members -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                        </careTeamSequence>
                    </xsl:for-each>
                    <xsl:for-each select="./diagnosis_sequence">
                        <diagnosisSequence>
                            <!-- 0..* Applicable diagnoses -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                        </diagnosisSequence>
                    </xsl:for-each>
                    <xsl:for-each select="./procedure_sequence">
                        <procedureSequence>
                            <!-- 0..* Applicable procedures -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                        </procedureSequence>
                    </xsl:for-each>
                    <xsl:for-each select="./information_sequence">
                        <informationSequence>
                            <!-- 0..* Applicable exception and supporting information -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                        </informationSequence>
                    </xsl:for-each>
                    <!-- Commenting it to avoid unnecessary tags <traceNumber> --><!-- 0..* Identifier Number for tracking --><!-- </traceNumber> -->
                    <xsl:if test="./revenue">
                        <revenue>
                            <!-- 0..1 CodeableConcept Revenue or cost center code -->
                            <coding>
                                <system>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./revenue/system"/>
                                    </xsl:attribute>
                                </system>
                                <code>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./revenue/code"/>
                                    </xsl:attribute>
                                </code>
                            </coding>
                        </revenue>
                    </xsl:if>                    
                    <!-- Commenting it to avoid unnecessary tags <category> --><!-- 0..1 CodeableConcept Benefit classification --><!-- </category> -->
                    <productOrService>
                        <!-- 0..1 CodeableConcept Billing, service, product, or drug code -->
                        <coding>
                            <xsl:if test="./product_or_service/system">
                                <system>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./product_or_service/system"/>
                                    </xsl:attribute>
                                </system>
                            </xsl:if>
                            <xsl:if test="./product_or_service/code">
                                <code>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./product_or_service/code"/>
                                    </xsl:attribute>
                                </code>
                            </xsl:if>
                            <xsl:if test="./product_or_service/display">
                                <display>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./product_or_service/display"/>
                                    </xsl:attribute>
                                </display>
                            </xsl:if>
                        </coding>
                        <xsl:if test="./product_or_service/text">
                            <text>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./product_or_service/text"/>
                                </xsl:attribute>
                            </text>
                        </xsl:if>
                    </productOrService>
                    <!-- Commenting it to avoid unnecessary tags <productOrServiceEnd> --><!-- 0..1 CodeableConcept End of a range of codes --><!-- </productOrServiceEnd> -->
                    <!-- Commenting it to avoid unnecessary tags <request> --><!-- 0..* Reference(DeviceRequest|MedicationRequest|NutritionOrder|ServiceRequest|SupplyRequest|VisionPrescription) Request or Referral for Service --><!-- </request> -->
                    <xsl:for-each select="./modifier">
                        <modifier>
                            <!-- 0..* CodeableConcept Product or service billing modifiers -->
                            <coding>
                                <system>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./system"/>
                                    </xsl:attribute>
                                </system>
                                <code>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./code"/>
                                    </xsl:attribute>
                                </code>
                            </coding>
                        </modifier>
                    </xsl:for-each>
                    <!-- Commenting it to avoid unnecessary tags <programCode> --><!-- 0..* CodeableConcept Program the product or service is provided under --><!-- </programCode> -->
                    <xsl:if test="./serviced">
                        <servicedDate>
                            <!-- 0..1 date|Period Date or dates of service or product delivery -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="./serviced/serviced_date"/>
                            </xsl:attribute>
                        </servicedDate>
                    </xsl:if>                    
                    <!-- Commenting it to avoid unnecessary tags <location> --><!-- 0..1 CodeableConcept|Address|Reference(Location) Place of service or where product was supplied --><!-- </location> -->
                    <!-- Commenting it to avoid unnecessary tags <patientPaid> --><!-- 0..1 Money Paid by the patient --><!-- </patientPaid> -->
                    <xsl:if test="./quantity">
                        <quantity>
                            <!-- 0..1 Quantity(SimpleQuantity) Count of products or services -->
                            <value>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./quantity/value"/>
                                </xsl:attribute>
                            </value>
                        </quantity>
                    </xsl:if>                    
                    <!-- Commenting it to avoid unnecessary tags <unitPrice> --><!-- 0..1 Money Fee, charge or cost per item --><!-- </unitPrice> -->
                    <!-- Commenting it to avoid unnecessary tags <factor/> -->
                    <!-- 0..1 Price scaling factor -->
                    <!-- Commenting it to avoid unnecessary tags <tax> --><!-- 0..1 Money Total tax --><!-- </tax> -->
                    <xsl:if test="./net">
                        <net>
                            <!-- 0..1 Money Total item cost -->
                            <value>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./net/value"/>
                                </xsl:attribute>
                            </value>
                            <currency>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./net/currency"/>
                                </xsl:attribute>
                            </currency>
                        </net>
                    </xsl:if>                    
                    <!-- Commenting it to avoid unnecessary tags <udi> --><!-- 0..* Reference(Device) Unique device identifier --><!-- </udi> -->
                    <!-- Commenting it to avoid unnecessary tags <bodySite> -->
                        <!-- 0..* Anatomical location -->
                    <!-- <site> --><!-- 1..* CodeableReference(BodyStructure) Location --><!-- </site> -->
                        <!-- <subSite> --><!-- 0..* CodeableConcept Sub-location --><!-- </subSite> -->
                        <!-- </bodySite> -->
                    <!-- Commenting it to avoid unnecessary tags <encounter> --><!-- 0..* Reference(Encounter) Encounters associated with the listed treatments --><!-- </encounter> -->
                    <!-- <noteNumber/> -->
                    <!-- 0..* Applicable note numbers -->
                    <!-- Commenting it to avoid unnecessary tags<reviewOutcome> -->
                        <!-- 0..1 Adjudication results -->
                    <!-- <decision> --><!-- 0..1 CodeableConcept Result of the adjudication --><!-- </decision> -->
                    <!-- <reason> --><!-- 0..* CodeableConcept Reason for result of the adjudication --><!-- </reason> -->
                    <!-- <preAuthRef/> -->
                        <!-- 0..1 Preauthorization reference -->
                    <!-- <preAuthPeriod> --><!-- 0..1 Period Preauthorization reference effective period --><!-- </preAuthPeriod> -->
                    <!-- </reviewOutcome> -->
                    <xsl:for-each select="./adjudications/adjudication/adjudication_amount_type">
                        <adjudication>
                            <!-- 0..* Adjudication details -->
                            <category>
                                <!-- 1..1 CodeableConcept Type of adjudication information -->
                                <coding>
                                    <system>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./category/system"/>
                                        </xsl:attribute>
                                    </system>
                                    <code>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./category/code"/>
                                        </xsl:attribute>
                                    </code>
                                </coding>
                            </category>
                            <reason>
                                <!-- 0..1 CodeableConcept Explanation of adjudication outcome -->
                                <coding>
                                    <code>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./reason"/>
                                        </xsl:attribute>
                                    </code>
                                </coding>
                            </reason>
                            <xsl:if test="./amount">
                                <amount>
                                    <!-- 0..1 Money Monetary amount -->
                                    <value>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./amount/value"/>
                                        </xsl:attribute>
                                    </value>
                                    <currency>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./amount/currency"/>
                                        </xsl:attribute>
                                    </currency>
                                </amount>
                            </xsl:if>
                            <!-- Need an example to map <code value="eligpercent"/> will have a quantity -->
                            <xsl:if test="./quantity">
                                <quantity>
                                    <!-- 0..1 Quantity Non-monitary value -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./quantity"/>
                                    </xsl:attribute>
                                </quantity>
                            </xsl:if>
                        </adjudication>
                    </xsl:for-each>
                    <!-- Commenting it to avoid unnecessary tags <detail> -->
                        <!-- 0..* Additional items -->
                    <!-- <sequence> --><!-- 1..1 Information instance identifier --><!-- </sequence> -->
                    <!-- <traceNumber> --><!-- 0..* Identifier Number for tracking --><!-- </traceNumber> -->
                        <!-- <revenue> --><!-- 0..1 CodeableConcept Revenue or cost center code --><!-- </revenue> -->
                    <!-- <category> --><!-- 0..1 CodeableConcept Benefit classification --><!-- </category> -->
                    <!-- <productOrService> --><!-- 0..1 CodeableConcept Billing, service, product, or drug code --><!-- </productOrService> -->
                    <!-- <productOrServiceEnd> --><!-- 0..1 CodeableConcept End of a range of codes --><!-- </productOrServiceEnd> -->
                    <!-- <modifier> --><!-- 0..* CodeableConcept Service/Product billing modifiers --><!-- </modifier> -->
                    <!-- <programCode> --><!-- 0..* CodeableConcept Program the product or service is provided under --><!-- </programCode> -->
                    <!-- <patientPaid> --><!-- 0..1 Money Paid by the patient --><!-- </patientPaid> -->
                    <!-- <quantity> --><!-- 0..1 Quantity(SimpleQuantity) Count of products or services --><!-- </quantity> -->
                    <!-- <unitPrice> --><!-- 0..1 Money Fee, charge or cost per item --><!-- </unitPrice> -->
                    <!-- <factor/> -->
                        <!-- 0..1 Price scaling factor -->
                    <!-- <tax> --><!-- 0..1 Money Total tax --><!-- </tax> -->
                    <!-- <net> --><!-- 0..1 Money Total item cost --><!-- </net> -->
                    <!-- <udi> --><!-- 0..* Reference(Device) Unique device identifier --><!-- </udi> -->
                    <!-- <noteNumber/> -->
                        <!-- 0..* Applicable note numbers -->
                    <!-- <reviewOutcome> --><!-- 0..1 Content as for ExplanationOfBenefit.item.reviewOutcome Detail level adjudication results --><!-- </reviewOutcome> -->
                    <!-- <adjudication> --><!-- 0..* Content as for ExplanationOfBenefit.item.adjudication Detail level adjudication details --><!-- </adjudication> -->
                    <!-- <subDetail> -->
                            <!-- 0..* Additional items -->
                        <!-- <sequence/> -->
                            <!-- 1..1 Product or service provided -->
                        <!-- <traceNumber> --><!-- 0..* Identifier Number for tracking --><!-- </traceNumber> -->
                        <!-- <revenue> --><!-- 0..1 CodeableConcept Revenue or cost center code --><!-- </revenue> -->
                        <!-- <category> --><!-- 0..1 CodeableConcept Benefit classification --><!-- </category> -->
                        <!-- <productOrService> --><!-- 0..1 CodeableConcept Billing, service, product, or drug code --><!-- </productOrService> -->
                        <!-- <productOrServiceEnd> --><!-- 0..1 CodeableConcept End of a range of codes --><!-- </productOrServiceEnd> -->
                        <!-- <modifier> --><!-- 0..* CodeableConcept Service/Product billing modifiers --><!-- </modifier> -->
                        <!-- <programCode> --><!-- 0..* CodeableConcept Program the product or service is provided under --><!-- </programCode> -->
                        <!-- <patientPaid> --><!-- 0..1 Money Paid by the patient --><!-- </patientPaid> -->
                        <!-- <quantity> --><!-- 0..1 Quantity(SimpleQuantity) Count of products or services --><!-- </quantity> -->
                        <!-- <unitPrice> --><!-- 0..1 Money Fee, charge or cost per item --><!-- </unitPrice> -->
                        <!-- <factor/> -->
                            <!-- 0..1 Price scaling factor -->
                        <!-- <tax> --><!-- 0..1 Money Total tax --><!-- </tax> -->
                        <!-- <net> --><!-- 0..1 Money Total item cost --><!-- </net> -->
                        <!-- <udi> --><!-- 0..* Reference(Device) Unique device identifier --><!-- </udi> -->
                        <!-- <noteNumber/> -->
                            <!-- 0..* Applicable note numbers -->
                        <!-- <reviewOutcome> --><!-- 0..1 Content as for ExplanationOfBenefit.item.reviewOutcome Subdetail level adjudication results --><!-- </reviewOutcome> -->
                        <!-- <adjudication> --><!-- 0..* Content as for ExplanationOfBenefit.item.adjudication Subdetail level adjudication details --><!-- </adjudication> -->
                        <!-- </subDetail> -->
                    <!-- </detail> -->
                </item>
            </xsl:for-each>
            <!-- Commenting it to avoid unnecessary tags <addItem> -->
                <!-- 0..* Insurer added line items -->
            <!-- <itemSequence/> -->
                <!-- 0..* Item sequence number -->
            <!-- <detailSequence/> -->
                <!-- 0..* Detail sequence number -->
            <!-- <subDetailSequence/> -->
                <!-- 0..* Subdetail sequence number -->
            <!-- <traceNumber> --><!-- 0..* Identifier Number for tracking --><!-- </traceNumber> -->
            <!-- <provider> --><!-- 0..* Reference(Organization|Practitioner|PractitionerRole) Authorized providers --><!-- </provider> -->
            <!-- <revenue> --><!-- 0..1 CodeableConcept Revenue or cost center code --><!-- </revenue> -->
            <!-- <productOrService> --><!-- 0..1 CodeableConcept Billing, service, product, or drug code --><!-- </productOrService> -->
            <!-- <productOrServiceEnd> --><!-- 0..1 CodeableConcept End of a range of codes --><!-- </productOrServiceEnd> -->
            <!-- <request> --><!-- 0..* Reference(DeviceRequest|MedicationRequest|NutritionOrder|ServiceRequest|SupplyRequest|VisionPrescription) Request or Referral for Service --><!-- </request> -->
            <!-- <modifier> --><!-- 0..* CodeableConcept Service/Product billing modifiers --><!-- </modifier> -->
            <!-- <programCode> --><!-- 0..* CodeableConcept Program the product or service is provided under --><!-- </programCode> -->
            <!-- <serviced> --><!-- 0..1 date|Period Date or dates of service or product delivery --><!-- </serviced> -->
            <!-- <location> --><!-- 0..1 CodeableConcept|Address|Reference(Location) Place of service or where product was supplied --><!-- </location> -->
            <!-- <patientPaid> --><!-- 0..1 Money Paid by the patient --><!-- </patientPaid> -->
            <!-- <quantity> --><!-- 0..1 Quantity(SimpleQuantity) Count of products or services --><!-- </quantity> -->
            <!-- <unitPrice> --><!-- 0..1 Money Fee, charge or cost per item --><!-- </unitPrice> -->
            <!-- <factor/> -->
                <!-- 0..1 Price scaling factor -->
            <!-- <tax> --><!-- 0..1 Money Total tax --><!-- </tax> -->
            <!-- <net> --><!-- 0..1 Money Total item cost --><!-- </net> -->
            <!-- <bodySite> -->
                    <!-- 0..* Anatomical location -->
            <!-- <site> --><!-- 1..* CodeableReference(BodyStructure) Location --><!-- </site> -->
            <!-- <subSite> --><!-- 0..* CodeableConcept Sub-location --><!-- </subSite> -->
            <!-- </bodySite> -->
            <!-- <noteNumber/> -->
                <!-- 0..* Applicable note numbers -->
            <!-- <reviewOutcome> --><!-- 0..1 Content as for ExplanationOfBenefit.item.reviewOutcome Additem level adjudication results --><!-- </reviewOutcome> -->
            <!-- <adjudication> --><!-- 0..* Content as for ExplanationOfBenefit.item.adjudication Added items adjudication --><!-- </adjudication> -->
            <!-- <detail> -->
                    <!-- 0..* Insurer added line items -->
            <!-- <traceNumber> --><!-- 0..* Identifier Number for tracking --><!-- </traceNumber> -->
            <!-- <revenue> --><!-- 0..1 CodeableConcept Revenue or cost center code --><!-- </revenue> -->
            <!-- <productOrService> --><!-- 0..1 CodeableConcept Billing, service, product, or drug code --><!-- </productOrService> -->
            <!-- <productOrServiceEnd> --><!-- 0..1 CodeableConcept End of a range of codes --><!-- </productOrServiceEnd> -->
            <!-- <modifier> --><!-- 0..* CodeableConcept Service/Product billing modifiers --><!-- </modifier> -->
            <!-- <patientPaid> --><!-- 0..1 Money Paid by the patient --><!-- </patientPaid> -->
            <!-- <quantity> --><!-- 0..1 Quantity(SimpleQuantity) Count of products or services --><!-- </quantity> -->
            <!-- <unitPrice> --><!-- 0..1 Money Fee, charge or cost per item --><!-- </unitPrice> -->
            <!-- <factor/> -->
                    <!-- 0..1 Price scaling factor -->
            <!-- <tax> --><!-- 0..1 Money Total tax --><!-- </tax> -->
            <!-- <net> --><!-- 0..1 Money Total item cost --><!-- </net> -->
            <!-- <noteNumber/> -->
                    <!-- 0..* Applicable note numbers -->
            <!-- <reviewOutcome> --><!-- 0..1 Content as for ExplanationOfBenefit.item.reviewOutcome Additem detail level adjudication results --><!-- </reviewOutcome> -->
            <!-- <adjudication> --><!-- 0..* Content as for ExplanationOfBenefit.item.adjudication Added items adjudication --><!-- </adjudication> -->
            <!-- <subDetail> -->
                        <!-- 0..* Insurer added line items -->
            <!-- <traceNumber> --><!-- 0..* Identifier Number for tracking --><!-- </traceNumber> -->
            <!-- <revenue> --><!-- 0..1 CodeableConcept Revenue or cost center code --><!-- </revenue> -->
            <!-- <productOrService> --><!-- 0..1 CodeableConcept Billing, service, product, or drug code --><!-- </productOrService> -->
            <!-- <productOrServiceEnd> --><!-- 0..1 CodeableConcept End of a range of codes --><!-- </productOrServiceEnd> -->
            <!-- <modifier> --><!-- 0..* CodeableConcept Service/Product billing modifiers --><!-- </modifier> -->
            <!-- <patientPaid> --><!-- 0..1 Money Paid by the patient --><!-- </patientPaid> -->
            <!-- <quantity> --><!-- 0..1 Quantity(SimpleQuantity) Count of products or services --><!-- </quantity> -->
            <!-- <unitPrice> --><!-- 0..1 Money Fee, charge or cost per item --><!-- </unitPrice> -->
            <!-- <factor/> -->
                        <!-- 0..1 Price scaling factor -->
            <!-- <tax> --><!-- 0..1 Money Total tax --><!-- </tax> -->
            <!-- <net> --><!-- 0..1 Money Total item cost --><!-- </net> -->
            <!-- <noteNumber/> -->
                        <!-- 0..* Applicable note numbers -->
            <!-- <reviewOutcome> --><!-- 0..1 Content as for ExplanationOfBenefit.item.reviewOutcome Additem subdetail level adjudication results --><!-- </reviewOutcome> -->
            <!-- <adjudication> --><!-- 0..* Content as for ExplanationOfBenefit.item.adjudication Added items adjudication --><!-- </adjudication> -->
            <!-- </subDetail> -->
            <!-- </detail> -->
            <!-- </addItem> -->
            <!-- Commenting it to avoid unnecessary tags <adjudication> --><!-- 0..* Content as for ExplanationOfBenefit.item.adjudication Header-level adjudication --><!-- </adjudication> -->
            <xsl:for-each select="$EOB_DEMOGRAPHIC/totals/total/*">
                <total>
                    <!-- 0..* Adjudication totals -->
                    <xsl:variable name="CAT_CODE">
                        <xsl:choose>
                            <xsl:when test="./category/code">
                                <!--if this node exist -->
                                <xsl:value-of select="./category/code"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="./category"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="CAT_SYSTEM">
                        <xsl:choose>
                            <xsl:when
                                test="
                                    $CAT_CODE = 'submitted'
                                    or $CAT_CODE = 'copay'
                                    or $CAT_CODE = 'deductible'
                                    or $CAT_CODE = 'unallocdeduct'
                                    or $CAT_CODE = 'eligpercent'
                                    or $CAT_CODE = 'eligible'
                                    or $CAT_CODE = 'benefit'
                                    or $CAT_CODE = 'tax'">
                                <xsl:value-of
                                    select="'http://terminology.hl7.org/CodeSystem/adjudication'"/>
                            </xsl:when>
                            <xsl:when
                                test="
                                    $CAT_CODE = 'eligible'
                                    or $CAT_CODE = 'memberliability'
                                    or $CAT_CODE = 'benefit'
                                    or $CAT_CODE = 'priorpayerpaid'
                                    or $CAT_CODE = 'coinsurance'
                                    or $CAT_CODE = 'noncovered'
                                    or $CAT_CODE = 'paidbypatient'
                                    or $CAT_CODE = 'paidbypatientcash'
                                    or $CAT_CODE = 'paidbypatientother'
                                    or $CAT_CODE = 'paidbypatienthealthaccount'
                                    or $CAT_CODE = 'paidtoprovider'
                                    or $CAT_CODE = 'paidtopatient'
                                    or $CAT_CODE = 'discount'
                                    or $CAT_CODE = 'drugcost'">

                                <xsl:value-of
                                    select="'http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudication'"
                                />
                            </xsl:when>

                            <xsl:when
                                test="
                                    $CAT_CODE = 'innetwork'
                                    or $CAT_CODE = 'outofnetwork'
                                    or $CAT_CODE = 'other'">
                                <xsl:value-of
                                    select="'http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBPayerAdjudicationStatus'"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'TEXT'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <category>
                        <!-- 1..1 CodeableConcept Type of adjudication information -->
                        <xsl:choose>
                            <xsl:when test="$CAT_SYSTEM = 'TEXT'">
                                <!--<coding>
                                    <code>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="$CAT_CODE"/>
                                        </xsl:attribute>
                                    </code>
                                   
                                </coding>
                                <text>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$CAT_CODE"/>
                                    </xsl:attribute>

                                </text>-->
                            </xsl:when>
                            <xsl:otherwise>
                                <coding>
                                    <system>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="$CAT_SYSTEM"/>
                                        </xsl:attribute>
                                    </system>
                                    <code>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="$CAT_CODE"/>
                                        </xsl:attribute>
                                    </code>
                                </coding>


                            </xsl:otherwise>
                        </xsl:choose>



                    </category>
                    <amount>
                        <!-- 1..1 Money Financial total for the category -->
                        <value>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./amount/value"/>
                            </xsl:attribute>
                        </value>
                        <currency>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./amount/currency"/>
                            </xsl:attribute>
                        </currency>
                    </amount>
                </total>
            </xsl:for-each>
            <xsl:if test="$EOB_DEMOGRAPHIC/payment">
                <payment>
                    <!-- 0..1 Payment Details -->
                    <type>
                        <!-- 0..1 CodeableConcept Partial or complete payment -->
                        <!-- <coding> <code> </code> </coding>-->
                        <xsl:if test="lower-case($EOB_DEMOGRAPHIC/payment/type)= 'paid' or lower-case($EOB_DEMOGRAPHIC/payment/type)= 'denied' or lower-case($EOB_DEMOGRAPHIC/payment/type)= 'partiallypaid'">
                            <coding>
                                <system value="http://hl7.org/fhir/us/carin-bb/ValueSet/C4BBPayerClaimPaymentStatusCode"/>
                                <code>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="lower-case($EOB_DEMOGRAPHIC/payment/type)"/>
                                    </xsl:attribute>
                                </code>
                            </coding>
                        </xsl:if>
                        <text>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$EOB_DEMOGRAPHIC/payment/type"/>
                            </xsl:attribute>
                        </text>
                    </type>
                    <adjustment><!-- 0..1 Money Payment adjustment for non-claim issues -->
                    </adjustment>
                    <adjustmentReason><!-- 0..1 CodeableConcept Explanation for the variance --></adjustmentReason>
                    <date>
                        <!-- 0..1 Expected date of payment -->
                        <xsl:attribute name="value">
                            <xsl:value-of select="$EOB_DEMOGRAPHIC/payment/date"/>
                        </xsl:attribute>
                    </date>
                    <amount>
                        <!-- 0..1 Money Payable amount after adjustment -->
                        <value>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./payment/amount/value"/>
                            </xsl:attribute>
                        </value>
                        <currency>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./payment/amount/currency"/>
                            </xsl:attribute>
                        </currency>
                    </amount>
                    <identifier><!-- 0..1 Identifier Business identifier for the payment --></identifier>
                </payment>
            </xsl:if>            
            <!-- Commenting it to avoid unnecessary tags <formCode> --><!-- 0..1 CodeableConcept Printed form identifier --><!-- </formCode> -->
            <!-- Commenting it to avoid unnecessary tags <form> --><!-- 0..1 Attachment Printed reference or actual form --><!-- </form> -->
            <!-- Commenting it to avoid unnecessary tags <processNote> -->
                <!-- 0..* Note concerning adjudication -->
            <!-- <number/> -->
                <!-- 0..1 Note instance identifier -->
            <!-- <type> --><!-- 0..1 CodeableConcept Note purpose --><!-- </type> -->
            <!-- <text/> -->
                <!-- 0..1 Note explanatory text -->
            <!-- <language> --><!-- 0..1 CodeableConcept Language of the text --><!-- </language> -->
            <!-- </processNote> -->
            <!-- Commenting it to avoid unnecessary tags <benefitPeriod> --><!-- 0..1 Period When the benefits are applicable --><!-- </benefitPeriod> -->
            <!-- Commenting it to avoid unnecessary tags <benefitBalance> -->
                <!-- 0..* Balance by Benefit Category -->
            <!-- <category> --><!-- 1..1 CodeableConcept Benefit classification --><!-- </category> -->
            <!-- <excluded/> -->
                <!-- 0..1 Excluded from the plan -->
            <!-- <name/> -->
                <!-- 0..1 Short name for the benefit -->
            <!-- <description/> -->
                <!-- 0..1 Description of the benefit or services covered -->
            <!-- <network> --><!-- 0..1 CodeableConcept In or out of network --><!-- </network> -->
            <!-- <unit> --><!-- 0..1 CodeableConcept Individual or family --><!-- </unit> -->
            <!-- <term> --><!-- 0..1 CodeableConcept Annual or lifetime --><!-- </term> -->
            <!-- <financial> -->
                    <!-- 0..* Benefit Summary -->
            <!-- <type> --><!-- 1..1 CodeableConcept Benefit classification --><!-- </type> -->
            <!-- <allowed> --><!-- 0..1 unsignedInt|string|Money Benefits allowed --><!-- </allowed> -->
            <!-- <used> --><!-- 0..1 unsignedInt|Money Benefits used --><!-- </used> -->
            <!-- </financial> -->
            <!-- </benefitBalance> -->
        </ExplanationOfBenefit>
    </xsl:template>
    <xsl:template name="Internal_coverage_container">
        <xsl:if test="not(/eob/insurances[1]/insurance[1]/coverage[1]/reference[1])">
            <xsl:for-each select="$EOB_DEMOGRAPHIC/insurances/insurance">
                    <Coverage xmlns="http://hl7.org/fhir">
                        <id>
                            <xsl:attribute name="value">
                                <xsl:value-of select="concat('CoverageDerived', position())"/>
                            </xsl:attribute>
                        </id>
                        <xsl:choose>
                            <xsl:when test="lower-case(./is_focal) = 'true'">
                                <identifier>
                                    <type>
                                        <coding>
                                            <system>
                                                <xsl:attribute name="value">
                                                    <xsl:value-of
                                                        select="('http://terminology.hl7.org/CodeSystem/v2-0203')"
                                                    />
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
                                            <xsl:value-of select="$EOB_MEMBER/member_id"/>
                                        </xsl:attribute>
                                    </value>
                                </identifier>
                                <xsl:if test="position() &gt; 1">
                                    <identifier>
                                        <type>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./coverage/identifier/type"/>
                                            </xsl:attribute>
                                        </type>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./coverage/identifier/value"/>
                                            </xsl:attribute>
                                        </value>
                                    </identifier>
                                </xsl:if>
                            </xsl:when>
                            <!-- <xsl:otherwise>
                                <identifier>
                                    <type>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./coverage/identifier/type"/>
                                        </xsl:attribute>
                                    </type>
                                    <value>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./coverage/identifier/value"/>
                                        </xsl:attribute>
                                    </value>
                                </identifier>
                            </xsl:otherwise> -->
                            <xsl:otherwise>
                                <identifier/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--<identifier>
                    <type>
                        <coding>
                            <code>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="('MB')"/>
                                </xsl:attribute>
                            </code>
                            <system>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="('http://terminology.hl7.org/CodeSystem/v2-0203')"/>
                                </xsl:attribute>
                            </system>
                            <display>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="'Member Number'"/>
                                </xsl:attribute>
                            </display>
                        </coding>
                    </type>
                    <value>
                        <xsl:attribute name="value">
                            <xsl:value-of select="$EOB_MEMBER/member_id"/>
                        </xsl:attribute>
                    </value>
                </identifier>-->
                        <!-- <xsl:choose> <xsl:when test="$EOB_MEMBER_INSURANCE[1]/coverage/period/end != ''"> <xsl:choose> <xsl:when test="$EOB_MEMBER_INSURANCE[1]/coverage/period/end > current-date()"> <status value="active"/> </xsl:when> <xsl:when test="current-date() > $EOB_MEMBER_INSURANCE[1]/coverage/period/end "> <status value="cancelled"/> </xsl:when> <xsl:otherwise> <status value="active"/> </xsl:otherwise> </xsl:choose> </xsl:when> <xsl:when test="$EOB_MEMBER_INSURANCE[1]/coverage/period/end"> <status value="cancelled"/> </xsl:when> <xsl:otherwise> <status value="active"/> </xsl:otherwise> </xsl:choose>-->
                        <status value="active"/>
                        <type><!-- 0..1 CodeableConcept Coverage category such as medical or accident -->
                        </type>
                        <!--<policyHolder> <!-\- 0..1 Reference(Organization|Patient|RelatedPerson) Owner of the policy -\-> <reference> <xsl:attribute name="value"> <xsl:value-of select="concat('Patient/', $EOB_CUSTOMER_PREFIX, '-', $EOB_SUBSCRIBER)"/> <!-\- <xsl:value-of select="$PTT_beneficiary"/> -\-> </xsl:attribute> </reference> </policyHolder> <subscriber> <!-\- 0..1 Reference(Patient|RelatedPerson) Subscriber to the policy -\-> <reference> <xsl:attribute name="value"> <xsl:value-of select="concat('Patient/', $EOB_CUSTOMER_PREFIX, '-', $EOB_SUBSCRIBER)"/> <!-\- <xsl:value-of select="$PTT_beneficiary"/> -\-> </xsl:attribute> </reference> </subscriber>-->
                        <subscriberId>
                            <!-- 0..* Identifier ID assigned to the subscriber -->
                            <xsl:variable name="COV_MEMBER_ID"
                                select="./coverage/beneficiary/subscriber_id != '' and position() &gt; 1"/>
                            <!-- the position() &gt; 1 statement is to remain passive. This way those who have multiple insurances abide by the initial code and the updated code -->
                            <xsl:choose>
                                <xsl:when test="$COV_MEMBER_ID">
                                    <xsl:attribute name="value">
                                        <!--                                    <xsl:value-of select="$EOB_DEMOGRAPHIC/patient[position()]/person/subscriber_id"/>-->
                                        <xsl:value-of select="./coverage/beneficiary/subscriber_id"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$EOB_SUBSCRIBER"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                            
                        </subscriberId>
                        <beneficiary>
                            <xsl:choose>
                                <xsl:when test="./coverage/beneficiary/reference">
                                    <xsl:variable name="inputString"
                                        select="./coverage/beneficiary/reference"/>
                                    <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat($parts[1], '/', $EOB_CUSTOMER_PREFIX, '-', $parts[2])"
                                            />
                                        </xsl:attribute>
                                    </reference>
                                </xsl:when>
                                <xsl:when test="empty($EOB_MEMBER/unique_person_id[1])">
                                    <xsl:variable name="inputString"
                                        select="$EOB_DEMOGRAPHIC/patient/reference"/>
                                    <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('Patient/', $EOB_CUSTOMER_PREFIX, '-', $parts[2])"
                                            />
                                        </xsl:attribute>
                                    </reference>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- 1..1 Reference(Patient) Plan beneficiary -->
                                    <xsl:variable name="PTT_beneficiary"
                                        select="$EOB_MEMBER/unique_person_id[1]"/>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('Patient/', $EOB_CUSTOMER_PREFIX, '-', $PTT_beneficiary)"/>
                                            <!-- <xsl:value-of select="$PTT_beneficiary"/> -->
                                        </xsl:attribute>
                                    </reference>
                                </xsl:otherwise>
                            </xsl:choose>
                        </beneficiary>
                        <!-- <dependent value=""/> -->
                        <!-- 0..1 Dependent number -->
                        <relationship>
                            <!-- 0..1 CodeableConcept Beneficiary relationship to the subscriber -->
                            <xsl:variable name="PTT_relationship">
                                <!--child,parent , spouse , common, other, self, injured-->
                                <xsl:choose>
                                    <xsl:when
                                        test="(./coverage/relationship) = 'child' or 'parent' or 'spouse' or 'common' or 'self' or 'other' or 'injured'">
                                        <xsl:value-of select="./coverage/relationship"/>
                                    </xsl:when>
                                    <xsl:when
                                        test=". = 'Child' or 'Parent' or 'Spouse' or 'Common' or 'Self' or 'Other' or 'Injured'">
                                        <xsl:value-of select="lower-case(./coverage/relationship)"/>
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
                                        <xsl:value-of select="lower-case($PTT_relationship)"/>
                                    </xsl:attribute>
                                </code>
                                <!-- BP 2025-11-3 -->
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
                                    <xsl:value-of select="./coverage/period/start"/>
                                </xsl:attribute>
                            </start>
                            <xsl:if test= "not(empty(./coverage/period/end))">
                              <end>
                                  <xsl:attribute name="value">
                                      <xsl:value-of select="./coverage/period/end"/>
                                  </xsl:attribute>
                              </end>
                            </xsl:if>
                        </period>
                        <payor>
                            <xsl:choose>
                                <!-- <xsl:when test="./coverage/reference">
                             <xsl:variable name="inputString" select="./coverage/reference" />
                            <xsl:variable name="parts" select="tokenize($inputString, '/')" />
                            <reference>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="concat($parts[1], '/', $EOB_CUSTOMER_PREFIX,'-', $parts[2])"/>
                                </xsl:attribute>
                            </reference> 
                        </xsl:when> -->
                                <xsl:when test="$isEOB_PAYOR_NAME or ./coverage/reference">
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('#PayorOrganizationDerived', position())"/>
                                        </xsl:attribute>
                                    </reference>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:variable name="PTT_Organization"
                                        select="translate(./coverage/beneficiary/unique_person_id_assigner[1], ' ', '')"/>
                                    
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="concat('Organization/', $EOB_CUSTOMER_PREFIX, '-', $PTT_Organization)"
                                            />
                                        </xsl:attribute>
                                    </reference>
                                </xsl:otherwise>
                            </xsl:choose>
                        </payor>
                        <xsl:for-each select="./coverage/classes/class">
                            <class>
                                <type>
                                    <coding>
                                        <system value="http://terminology.hl7.org/CodeSystem/coverage-class"/>
                                        <code value="group"/>
                                    </coding>
                                </type>
                                <value>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./group/value"/>
                                    </xsl:attribute>
                                </value>
                                <name>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./group/name"/>
                                    </xsl:attribute>
                                </name>
                            </class>
                            <class>
                                <type>
                                    <coding>
                                        <system value="http://terminology.hl7.org/CodeSystem/coverage-class"/>
                                        <code value="plan"/>
                                    </coding>
                                </type>
                                <value>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./plan/value"/>
                                    </xsl:attribute>
                                </value>
                                <name>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./plan/name"/>
                                    </xsl:attribute>
                                </name>
                            </class>
                        </xsl:for-each>
                        <!-- <order value="1"/> <!-\- 0..1 Relative order of the coverage -\-> <network> <xsl:attribute name="value"> <xsl:value-of select="$EOB_MEMBER_INSURANCE/coverage/classes/class/group/name"/> </xsl:attribute> </network>-->
                    </Coverage>
            </xsl:for-each>
        </xsl:if>        
    </xsl:template>
    <!--CONTAINER LOGIC-->
    <!--CONTAINER LOGIC-->
    <!--CONTAINER LOGIC-->
    <xsl:template name="Internal_insurer_container">
        <xsl:variable name="EOB_VAR" select="./$EOB_DEMOGRAPHIC/insurer"/>
        <xsl:choose>
            <xsl:when test="$EOB_VAR != ''">
                <Organization xmlns="http://hl7.org/fhir">
                    <id>
                        <xsl:attribute name="value">
                            <xsl:value-of select="'InsurerOrganizationDerived1'"/>
                        </xsl:attribute>
                    </id>
                    <active>
                        <!-- value="[boolean]"0..1 Whether the organization's record is still in active use -->
                        <xsl:choose>
                            <xsl:when test="./$EOB_DEMOGRAPHIC/insurer/is_active != ''">
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="lower-case(./$EOB_DEMOGRAPHIC/insurer/is_active)"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="'true'"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </active>
                    <name>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./$EOB_DEMOGRAPHIC/insurer/name"/>
                        </xsl:attribute>
                    </name>
                    <xsl:for-each select="$EOB_DEMOGRAPHIC/insurer/addresses/address">
                        <address>
                            <type>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./type"/>
                                </xsl:attribute>
                            </type>
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
                                    <xsl:value-of select="./postal_code"/>
                                </xsl:attribute>
                            </postalCode>
                            <country>
                                <xsl:attribute name="value">
                                    <xsl:choose>
                                        <xsl:when test="./country != ''">
                                            <xsl:attribute name="value">
                                              <xsl:value-of select="./country"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="value">
                                              <xsl:value-of select="'USA'"/>
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                            </country>
                            <period>
                                <start>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./period/start"/>
                                    </xsl:attribute>
                                </start>
                                <end>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./period/end"/>
                                    </xsl:attribute>
                                </end>
                            </period>
                        </address>
                    </xsl:for-each>
                    
                </Organization>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Internal_provider_container">
        <xsl:if test="not($EOB_DEMOGRAPHIC/provider/reference)">
            <xsl:variable name="EOB_VAR" select="./$EOB_DEMOGRAPHIC/provider/providing_organization"/>
            <xsl:choose>
                <xsl:when test="$EOB_VAR != ''">
                    <Organization xmlns="http://hl7.org/fhir">
                        <id>
                            <xsl:attribute name="value">
                                <xsl:value-of select="'ProviderOrganizationDerived1'"/>
                            </xsl:attribute>
                        </id>
                        <active>
                            <!-- value="[boolean]"0..1 Whether the organization's record is still in active use -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="'true'"/>
                            </xsl:attribute>
                        </active>
                        <name>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="./$EOB_DEMOGRAPHIC/provider/providing_organization/name"/>
                            </xsl:attribute>
                        </name>
                    </Organization>
                </xsl:when>
                <xsl:otherwise>
                    <Practitioner xmlns="http://hl7.org/fhir">
                        <id>
                            <xsl:attribute name="value">
                                <xsl:value-of select="'ProviderPractitionerDerived1'"/>
                            </xsl:attribute>
                        </id>
                        <active>
                            <!-- value="[boolean]"0..1 Whether the organization's record is still in active use -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="'true'"/>
                            </xsl:attribute>
                        </active>
                        <!-- 0..1 Whether this practitioner's record is in active use -->
                        <name>
                            <use value="official"/>
                            <family>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./$EOB_DEMOGRAPHIC/provider/practitioner/name"
                                    />
                                </xsl:attribute>
                            </family>
                        </name>
                    </Practitioner>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>        
    </xsl:template>
    <xsl:template name="Internal_payee_container">
        <xsl:if test="not(./$EOB_DEMOGRAPHIC/payee/party/reference)">
            <xsl:variable name="EOB_VAR" select="./$EOB_DEMOGRAPHIC/payee/party/providing_organization"/>
            <xsl:choose>
                <xsl:when test="$EOB_VAR != ''">
                    <Organization xmlns="http://hl7.org/fhir">
                        <id>
                            <xsl:attribute name="value">
                                <xsl:value-of select="'PayeeOrganizationDerived1'"/>
                            </xsl:attribute>
                        </id>
                        <active>
                            <!-- value="[boolean]"0..1 Whether the organization's record is still in active use -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="'true'"/>
                            </xsl:attribute>
                        </active>
                        <name>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="./$EOB_DEMOGRAPHIC/payee/party/providing_organization/name"
                                />
                            </xsl:attribute>
                        </name>
                    </Organization>
                </xsl:when>
                <xsl:otherwise>
                    <Practitioner xmlns="http://hl7.org/fhir">
                        <id>
                            <xsl:attribute name="value">
                                <xsl:value-of select="'PayeePractitionerDerived1'"/>
                            </xsl:attribute>
                        </id>
                        <active>
                            <!-- value="[boolean]"0..1 Whether the organization's record is still in active use -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="'true'"/>
                            </xsl:attribute>
                        </active>
                        <!-- 0..1 Whether this practitioner's record is in active use -->
                        <name>
                            <use value="official"/>
                            <family>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="./$EOB_DEMOGRAPHIC/payee/party/practitioner/name"/>
                                </xsl:attribute>
                            </family>
                        </name>
                    </Practitioner>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>        
    </xsl:template>
    <xsl:template name="Internal_facility_container">
        <xsl:for-each select="$EOB_DEMOGRAPHIC/facility/address">
            <xsl:variable name="EOB_USE" select="./use"/>
            <xsl:variable name="EOB_TYPE" select="./type"/>
            <Location xmlns="http://hl7.org/fhir">
                <id>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="concat($EOB_USE, $EOB_TYPE, '-', 'facilitylocationDerived1')"
                        />
                    </xsl:attribute>
                </id>
                <address>
                    <type>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./type"/>
                        </xsl:attribute>
                    </type>
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
                            <xsl:value-of select="./postal_code"/>
                        </xsl:attribute>
                    </postalCode>
                    <country>
                        <xsl:attribute name="value">
                            <xsl:value-of select="'USA'"/>
                        </xsl:attribute>
                    </country>
                    <period>
                        <start>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./period/start"/>
                            </xsl:attribute>
                        </start>
                        <end>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./period/end"/>
                            </xsl:attribute>
                        </end>
                    </period>
                </address>
            </Location>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="Internal_careteam_container">
        <xsl:for-each select="$EOB_DEMOGRAPHIC/care_teams/care_team">
            <xsl:variable name="EOB_VAR" select="./provider/providing_organization"/>
            <xsl:choose>
                <xsl:when test="$EOB_VAR != ''">
                    <Organization xmlns="http://hl7.org/fhir">
                        <id>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="concat(./sequence, '-', 'Care-teamOrganizationDerived1')"
                                />
                            </xsl:attribute>
                        </id>
                        <active>
                            <!-- value="[boolean]"0..1 Whether the organization's record is still in active use -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="'true'"/>
                            </xsl:attribute>
                        </active>
                        <name>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./provider/providing_organization/name"/>
                            </xsl:attribute>
                        </name>
                    </Organization>
                </xsl:when>
                <xsl:when test="empty(./sequence)"/>
                <xsl:otherwise>
                    <Practitioner xmlns="http://hl7.org/fhir">
                        <id>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="concat(./sequence, '-', 'Care-teamPractitionerDerived1')"
                                />
                            </xsl:attribute>
                        </id>
                        <active>
                            <!-- value="[boolean]"0..1 Whether the organization's record is still in active use -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="'true'"/>
                            </xsl:attribute>
                        </active>
                        <!-- 0..1 Whether this practitioner's record is in active use -->
                        <name>
                            <use value="official"/>
                            <family>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./provider/practitioner/name"/>
                                </xsl:attribute>
                            </family>
                        </name>
                    </Practitioner>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="Internal_payor_org_container">
        <xsl:variable name="EOB_VAR" select="$isEOB_PAYOR_NAME"/>
        <!-- 0..1 Reference(Organization) Issuer of the policy -->


        <xsl:for-each select="$EOB_DEMOGRAPHIC/insurances/insurance">

            <Organization xmlns="http://hl7.org/fhir">

                <id>
                    <xsl:attribute name="value">
                        <xsl:value-of select="concat('PayorOrganizationDerived', position())"/>
                    </xsl:attribute>
                </id>

                <!-- tax test-->
                <xsl:for-each select="./coverage/payor/tax">
                    <xsl:if test="./value != ''">
                        <identifier>
                            <type>
                                <coding>
                                    <system>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="'http://terminology.hl7.org/CodeSystem/v2-0203'"
                                            />
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

                <xsl:for-each select="./coverage/payor/naic_code">
                    <xsl:if test="./value != ''">
                        <identifier>
                            <type>
                                <coding>
                                    <system>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="'http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBIdentifierType'"
                                            />
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

                <xsl:for-each select="./coverage/payor/payer_id">
                    <xsl:if test="./value != ''">
                        <identifier>
                            <type>
                                <coding>
                                    <system>
                                        <xsl:attribute name="system">
                                            <xsl:value-of
                                                select="'http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBIdentifierType'"
                                            />
                                        </xsl:attribute>
                                    </system>
                                    <code>
                                        <xsl:attribute name="code">
                                            <xsl:value-of select="'payerid'"/>
                                        </xsl:attribute>
                                    </code>
                                </coding>
                            </type>
                            <xsl:if test="./system != ''">
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
                            <xsl:when test="./coverage/payor/is_active = 'false'">
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
                        <xsl:value-of select="./coverage/payor/name"/>
                    </xsl:attribute>
                </name>

                <xsl:if test="./coverage/payor/telecoms != ''">
                    <xsl:for-each select="./coverage/payor/telecoms/telecom">
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

                <xsl:if test="./coverage/payor/addresses != ''">
                    <xsl:for-each select="./coverage/payor/addresses/address">
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
                            <district>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="district"/>
                                </xsl:attribute>
                            </district>
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
        </xsl:for-each>
    </xsl:template>
    <!--CONTAINER LOGIC-->
    <!--CONTAINER LOGIC-->
    <!--CONTAINER LOGIC-->
</xsl:stylesheet>

