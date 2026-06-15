<xsl:stylesheet xpath-default-namespace="http://cocodata.org" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://hl7.org/fhir" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
    <xsl:preserve-space elements="*"/>
    <!-- Complete fully flushed out  FMC3 -->

    <!-- Complete fully flushed out  FMC3 -->

    <xsl:variable name="EOB_CUSTOMER_PREFIX" select="$EOB_DEMOGRAPHIC/customername"/>
    <xsl:variable name="EOB_SUBSCRIBER" select="$EOB_DEMOGRAPHIC/patient/person/subscriber_id"/>
    <xsl:variable name="EOB_MEMBER" select="eob_list/eob/patient/person"/>
    <xsl:variable name="EOB_DEMOGRAPHIC" select="eob_list/eob"/>
    <xsl:variable name="EOB_LOCATIONS" select="eob_list/eob/addresses"/>
    <xsl:variable name="EOB_MEMBER_INSURANCE" select="eob_list/eob/insurances/insurance"/>

    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <Claim>
            <id>
                <xsl:attribute name="value">
                    <xsl:value-of select="concat($EOB_CUSTOMER_PREFIX, '-', $EOB_DEMOGRAPHIC/claim/identifier/value)"/>
                </xsl:attribute>
            </id>
            <contained>
                <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                <xsl:call-template name="Internal_coverage_container"/>
                <xsl:call-template name="Internal_provider_container"/>
                <xsl:call-template name="Internal_insurer_container"/>
                <xsl:call-template name="Internal_payee_container"/>
                <xsl:call-template name="Internal_careteam_container"/>
                <xsl:call-template name="Internal_location_container"/>
            </contained>
            <xsl:call-template name="meta_security"/>
            <xsl:call-template name="text_identifier_claim"/>
            <xsl:if test="$EOB_DEMOGRAPHIC/traceNumber">
                <traceNumber>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$EOB_DEMOGRAPHIC/traceNumber"/>
                    </xsl:attribute>
                </traceNumber>
            </xsl:if>
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
                <coding>
                    <system value="http://terminology.hl7.org/CodeSystem/claim-type"/>
                    <code>
                        <xsl:attribute name="value">
                            <xsl:value-of select="lower-case($EOB_DEMOGRAPHIC/type)"/>
                        </xsl:attribute>
                    </code>
                </coding>
            </type>
            <xsl:if test="$EOB_DEMOGRAPHIC/subType">
                <subType>
                    <coding>
                        <system value="http://hl7.org/fhir/ValueSet/claim-subtype"/>
                        <code>
                            <xsl:attribute name="value">
                                <xsl:value-of select="lower-case($EOB_DEMOGRAPHIC/subType)"/>
                            </xsl:attribute>
                        </code>
                    </coding>
                </subType>
            </xsl:if>
            <use value="claim"/>
            <patient>
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
                        <!-- 1..1 Reference(Patient) The recipient of the products and services -->
                        <xsl:variable name="EOB_VAR"
                            select="$EOB_DEMOGRAPHIC/patient/person/unique_person_id"/>
                        <reference>
                            
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="concat('Patient/', $EOB_CUSTOMER_PREFIX, '-', $EOB_VAR)"/>
                            </xsl:attribute>
                        </reference>
                    </xsl:otherwise>
                </xsl:choose>
            </patient>
            <xsl:if test="$EOB_DEMOGRAPHIC/billable_period">
                <billablePeriod>
                    <!-- 0..1 Period Relevant time frame for the claim -->
                    <xsl:if test="$EOB_DEMOGRAPHIC/billable_period/start">
                        <start>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$EOB_DEMOGRAPHIC/billable_period/start"/>
                            </xsl:attribute>
                        </start>
                    </xsl:if>
                    <xsl:if test="$EOB_DEMOGRAPHIC/billable_period/end">
                        <end>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$EOB_DEMOGRAPHIC/billable_period/end"/>
                            </xsl:attribute>
                        </end>
                    </xsl:if>                    
                </billablePeriod>
            </xsl:if>            
            <created>
                <!-- 1..1 Response creation date -->
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
                </xsl:attribute>
            </created>
            <!-- Commenting to avoid unnecessary tags <enterer> --><!-- 0..1 Reference(Practitioner|PractitionerRole) Author of the claim -->
                <!--  <reference>
                    <xsl:attribute name="value">
                        <xsl:variable name="RENDERING_PROVIDER_ID">
                            <!-\-<xsl:call-template name="EPT_text_identifier_provider_practitioner"/>-\->
                        </xsl:variable>
                        <xsl:value-of select="concat('Organization/', $RENDERING_PROVIDER_ID)"/>
                    </xsl:attribute>
                </reference>-->
            <!-- </enterer> -->
            <insurer>
                <!-- 0..1 Reference(Organization) Party responsible for reimbursement -->
                <reference>
                    <xsl:attribute name="value">
                        <xsl:value-of select="'#InsurerOrganizationDerived1'"/>
                    </xsl:attribute>
                </reference>
            </insurer>
            <provider>
                <!-- 0..1 Reference(Organization|Practitioner|PractitionerRole) Party responsible for the claim -->
                <xsl:choose>
                    <xsl:when test="exists($EOB_DEMOGRAPHIC/provider/reference)">
                        <xsl:variable name="inputString" select="$EOB_DEMOGRAPHIC/provider/reference"/>
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
                        <xsl:variable name="EOB_VAR"
                            select="./$EOB_DEMOGRAPHIC/provider/providing_organization/clia"/>
                        <xsl:choose>
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
                    </xsl:otherwise>
                </xsl:choose>
            </provider>
            <priority>
                <coding>
                    <code value="normal"/>
                </coding>
            </priority>
            <!-- Commenting it to avoid unnecessary tags <fundsReserve>--><!-- 0..1 CodeableConcept For whom to reserve funds --><!--</fundsReserve>-->
            <!-- Commenting it to avoid unnecessary tags <related> -->
                <!-- 0..* Prior or corollary claims -->
            <!-- <claim> --><!-- 0..1 Reference(Claim) Reference to the related claim --><!-- </claim> -->
            <!-- <relationship> --><!-- 0..1 CodeableConcept How the reference claim is related --><!-- </relationship> -->
            <!-- <reference> --><!-- 0..1 Identifier File or case reference --><!-- </reference> -->
            <!-- </related> -->
            <!-- Commenting it to avoid unnecessary tags <prescription> -->
                <!-- 0..1 Reference(DeviceRequest|MedicationRequest|VisionPrescription) Prescription authorizing services and products -->
            <!-- </prescription> -->
            <!--  
                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                        
                        logic needed to determine what XSLT to produce reference 
                        DeviceRequest|MedicationRequest|VisionPrescription  FMC3 
                    
                         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                       -->

            <!-- Commenting it to avoid unnecessary tags <originalPrescription> -->
                <!-- 0..1 Reference(DeviceRequest|MedicationRequest|  VisionPrescription) Original prescription if superseded by fulfiller -->
                <!--  
                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                        
                        logic needed to determine what XSLT to produce reference 
                        DeviceRequest|MedicationRequest|VisionPrescription  FMC3 
                    
                         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                       -->
            <!-- </originalPrescription> -->
            <payee>
                <!-- 0..1 Recipient of benefits payable -->
                <!-- <type><!-\- 0..1 CodeableConcept Category of recipient -\-></type>
            <party><!-\- 0..1 Reference(Organization|Patient|Practitioner|PractitionerRole|
    RelatedPerson) Recipient reference -\-></party>-->
                <type>
                    <coding>
                        <system>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./$EOB_DEMOGRAPHIC/payee/type/system"/>
                            </xsl:attribute>
                        </system>
                        <code>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./$EOB_DEMOGRAPHIC/payee/type/code"/>
                            </xsl:attribute>
                        </code>
                    </coding>
                </type>
                <party>
                    <!-- 0..1 Reference(Organization|Practitioner|PractitionerRole) Party responsible for the claim -->
                    <xsl:choose>
                        <xsl:when test="exists($EOB_DEMOGRAPHIC/payee/party/reference)">
                            <xsl:variable name="inputString" select="$EOB_DEMOGRAPHIC/payee/party/reference"/>
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
                            <xsl:variable name="EOB_VAR"
                                select="./$EOB_DEMOGRAPHIC/payee/party/providing_organization"/>                           
                            <xsl:choose>
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
                        </xsl:otherwise>
                    </xsl:choose>
                </party>
            </payee>
            <!-- Commenting it to avoid unnecessary tags <referral> --><!-- 0..1 Reference(ServiceRequest) Treatment referral --><!-- </referral>-->
            <!-- Commenting it to avoid unnecessary tags <facility> -->
                <!-- 0..1 Reference(Location) Servicing Facility -->
                <!-- substring logic and padding without right doesn't existin xlst-->
            <!-- </facility> -->
            
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
                        <xsl:choose>
                            <xsl:when test="exists(./provider/reference)">
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
                            <xsl:otherwise>
                                <xsl:variable name="EOB_VAR" select="./provider/providing_organization"/>
                                <xsl:choose>
                                    <xsl:when test="$EOB_VAR != ''">
                                        <reference>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('#', ./sequence, '-', 'Care-teamOrganizationDerived1')"
                                                />
                                            </xsl:attribute>
                                        </reference>
                                    </xsl:when>
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
                    <!-- Commenting it to avoid unnecessary tags <specialty> --><!-- 0..1 CodeableConcept Practitioner or provider specialization -->
                    <!-- </specialty> -->
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
                        <!-- 0..1 boolean|string|Quantity|Attachment|Reference(Any) Data to be provided -->
                        <!-- <value></value> -->
                        <!-- 0..1 Coding Explanation for the information -->
                        <!-- <reason></reason> -->
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
                    <!-- <packageCode>
                <coding>
                    <system value="http://terminology.hl7.org/CodeSystem/ex-diagnosisrelatedgroup"/>
                    <code value="400"/>
                    <display value="Head trauma - concussion"/>
                </coding>
            </packageCode>-->
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
                                    <xsl:value-of select="./type"/>
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
                                    <xsl:value-of select="./procedure_code/coding/code"/>
                                </xsl:attribute>
                            </code>
                        </coding>
                    </procedureCodeableConcept>
                    <udi>
                        <!-- 0..* Reference(Device) Unique device identifier -->
                        <!-- need to create device logic for FHIR resource
                           Cant find node in samples  -->
                        <!-- <xsl:variable name="EOB_VAR" select="./procedure_code/coding/code/unknown"/>

                        <xsl:choose>
                            <xsl:when test="$EOB_VAR">
                                <reference>

                                    <xsl:attribute name="value">
                                        <xsl:value-of select="concat('Device/', $EOB_VAR)"/>
                                    </xsl:attribute>
                                </reference>
                            </xsl:when>
                        </xsl:choose>-->
                    </udi>
                </procedure>
            </xsl:for-each>
            <xsl:for-each select="$EOB_DEMOGRAPHIC/insurances/insurance">
                <insurance>
                    <!-- 0..* Patient insurance information -->
                    <sequence>
                        <xsl:attribute name="value">
                            <xsl:value-of select="position()"/>                            
                        </xsl:attribute>
                    </sequence>
                    <focal>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./is_focal"/>
                        </xsl:attribute>
                    </focal>
                    <!-- 1..1 Coverage to be used for adjudication -->
                    <coverage>
                        <!-- 1..1 Reference(Coverage) Insurance information -->
                        <!--  <xsl:variable name="EOB_VAR" select="./coverage/beneficiary/member_id"/>
                        <xsl:variable name="EOB_VAR1"
                            select="./coverage/beneficiary/member_id_system"/>-->
                        <!--unique_record_identifier from Roster/member = EOB_VAR + EOB_VAR1-->
                        <xsl:choose>
                            <xsl:when test="exists(./coverage/reference)">
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
                                        <!-- <xsl:value-of select="concat('Coverage/', $EOB_VAR, $EOB_VAR1)"/> -->
                                        <xsl:value-of select="'#CoverageDerived1'"/>
                                    </xsl:attribute>
                                </reference>
                            </xsl:otherwise>
                        </xsl:choose>                              
                    </coverage>
                    <!--<preAuthRef value="[string]"/><!-\- 0..* Prior authorization reference number -\->-->
                </insurance>
            </xsl:for-each>
            <!-- Commenting it to avoid unnecessary tags <accident>
                <date> </date> -->
                <!-- 1..1 value="[date]" When the incident occurred -->
            <!-- <type> --><!-- 0..1 CodeableConcept The nature of the accident --><!-- </type> -->
            <!-- <location> --><!-- 0..1 [X] Address|Reference(Location) Where the event occurred -->
            <!-- </location> -->
            <!-- </accident> -->            
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
                        <xsl:if test="./product_or_service">
                            <productOrService>
                                <!-- 0..1 CodeableConcept Billing, service, product, or drug code -->
                                <coding>
                                    <xsl:if test="/product_or_service/system">
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./product_or_service/system"/>
                                            </xsl:attribute>
                                        </system>
                                    </xsl:if>
                                    <code>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./product_or_service/code"/>
                                        </xsl:attribute>
                                    </code>
                                </coding>
                            </productOrService>
                        </xsl:if>
                        
                        <!-- Not part of Claim <productOrServiceEnd> --><!-- 0..1 CodeableConcept End of a range of codes --><!-- </productOrServiceEnd> -->
                        <!-- Not part of Claim <request> --><!-- 0..* Reference(DeviceRequest|MedicationRequest|NutritionOrder|ServiceRequest|SupplyRequest|VisionPrescription) Request or Referral for Service --><!-- </request>-->
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
                        <xsl:if test="/quantity">
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
                        <!-- Not part of Claim <tax> --><!-- 0..1 Money Total tax --><!-- </tax> -->
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
                        <!-- Not part of Claim <noteNumber/> -->
                        <!-- 0..* Applicable note numbers -->
                        <!-- Not part of Claim <reviewOutcome> -->
                            <!-- 0..1 Adjudication results -->
                        <!-- <decision> --><!-- 0..1 CodeableConcept Result of the adjudication --><!-- </decision> -->
                        <!-- <reason> --><!-- 0..* CodeableConcept Reason for result of the adjudication --><!-- </reason> -->
                        <!-- <preAuthRef/> -->
                            <!-- 0..1 Preauthorization reference -->
                        <!-- <preAuthPeriod> --><!-- 0..1 Period Preauthorization reference effective period --><!-- </preAuthPeriod> -->
                        <!-- </reviewOutcome> -->
                        <!-- Wrong structure found, invalid tags: analyze <xsl:for-each select="./adjudications/adjudication/adjudication_amount_type">
                            <adjudication>
                                <category>
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
                                <xsl:if test="./quantity">
                                    <quantity>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./quantity"/>
                                        </xsl:attribute>
                                    </quantity>
                                </xsl:if>
                            </adjudication>
                        </xsl:for-each> -->
                        <!-- Commenting it to avoid unnecessary tags <detail> -->
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
            <!-- Each Claim have only one total why are we iterating? -->
            <xsl:for-each select="$EOB_DEMOGRAPHIC/totals/total">
                <xsl:choose>
                    <xsl:when test="./category.code = 'submitted'">
                        <total>
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
                        </total>
                    </xsl:when>             
                    <xsl:when test="./adjudication_amount_type">
                        <xsl:for-each select="./adjudication_amount_type">
                            <xsl:if test="./category/code = 'submitted' or ./category = 'submitted'">
                                <total>
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
                                </total>
                            </xsl:if>
                        </xsl:for-each>                    
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </Claim>
    </xsl:template>


    <xsl:template name="meta_security">
        <meta>
            <xsl:variable name="EOB_PARENTFILE_NAME" select="$EOB_DEMOGRAPHIC/parentfile"/>
            <source>
                <xsl:attribute name="value">
                    <xsl:value-of select="$EOB_PARENTFILE_NAME"/>
                </xsl:attribute>
            </source>
        </meta>
    </xsl:template>
    <xsl:template name="text_identifier_claim">
        <identifier>
            <system>
                <xsl:attribute name="value">
                    <xsl:value-of select="'http://terminology.hl7.org/CodeSystem/v2-0203'"/>
                    <!-- Hardcoded  FMC3-->
                </xsl:attribute>
            </system>
            <value>
                <xsl:attribute name="value">
                    <xsl:value-of select="$EOB_DEMOGRAPHIC/claim/identifier/value"/>
                </xsl:attribute>
            </value>
        </identifier>
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
                        <!--  value="[boolean]"0..1 Whether the organization's record is still in active use -->
                        <xsl:attribute name="value">
                            <xsl:value-of select="'true'"/>
                        </xsl:attribute>
                    </active>
                    <name>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./$EOB_DEMOGRAPHIC/insurer/name"/>
                        </xsl:attribute>
                    </name>
                </Organization>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Internal_provider_container">
        <xsl:if test="not($EOB_DEMOGRAPHIC/provider/reference)">
            <xsl:variable name="EOB_VAR" select="$EOB_DEMOGRAPHIC/provider/providing_organization"/>
            <xsl:choose>
                <xsl:when test="$EOB_VAR != ''">
                    <Organization xmlns="http://hl7.org/fhir">
                        <id>
                            <xsl:attribute name="value">
                                <xsl:value-of select="'ProviderOrganizationDerived1'"/>
                            </xsl:attribute>
                        </id>  
                        <active>
                            <!--  value="[boolean]"0..1 Whether the organization's record is still in active use -->
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
                            <!--  value="[boolean]"0..1 Whether the organization's record is still in active use -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="'true'"/>
                            </xsl:attribute>
                        </active>
                        <!-- 0..1 Whether this practitioner's record is in active use -->
                        <name>
                            <use value="official"/> 
                            <family>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./$EOB_DEMOGRAPHIC/provider/practitioner/name"/>
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
                            <!--  value="[boolean]"0..1 Whether the organization's record is still in active use -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="'true'"/>
                            </xsl:attribute>
                        </active>
                        <name>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="./$EOB_DEMOGRAPHIC/payee/party/providing_organization/name"/>
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
                            <!--  value="[boolean]"0..1 Whether the organization's record is still in active use -->
                            <xsl:attribute name="value">
                                <xsl:value-of select="'true'"/>
                            </xsl:attribute>
                        </active>
                        <!-- 0..1 Whether this practitioner's record is in active use -->
                        <name>
                            <use value="official"/> 
                            
                            <family>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./$EOB_DEMOGRAPHIC/payee/party/practitioner/name"/>
                            </xsl:attribute>
                            </family>
                        </name>
                    </Practitioner>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template name="Internal_location_container"> </xsl:template>
    <xsl:template name="Internal_careteam_container">
        <xsl:for-each select="$EOB_DEMOGRAPHIC/care_teams/care_team">
            <xsl:variable name="EOB_VAR" select="./provider/providing_organization"/>
            <xsl:if test="not(./provider/reference)">
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
                                <!--  value="[boolean]"0..1 Whether the organization's record is still in active use -->
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
                    <xsl:otherwise>
                        <Practitioner xmlns="http://hl7.org/fhir">
                            <id>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="concat(./sequence, '-', 'Care-teamPractitionerDerived1')"/>
                                </xsl:attribute>
                            </id>
                            <active>
                                <!--  value="[boolean]"0..1 Whether the organization's record is still in active use -->
                                <xsl:attribute name="value">
                                    <xsl:value-of select="'true'"/>
                                </xsl:attribute>
                            </active>
                            <!-- 0..1 Whether this practitioner's record is in active use -->
                            <text>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./provider/practitioner/name"/>
                                </xsl:attribute>
                            </text>
                        </Practitioner>
    
    
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>


    </xsl:template>

    <xsl:template name="Internal_coverage_container">
        <xsl:if test="not(/eob/insurances[1]/insurance[1]/coverage[1]/reference[1])">
            <Coverage xmlns="http://hl7.org/fhir">
                <id>
                    <xsl:attribute name="value">
                        <xsl:value-of select="'CoverageDerived1'"/>
                    </xsl:attribute>
                </id>
                <identifier>
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
                        <xsl:choose>
                            <xsl:when test="eob/patient/reference">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="eob_list/eob/patient/reference"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$EOB_MEMBER/member_id"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </value>
                </identifier>
                <!--       <xsl:choose>
                    <xsl:when test="$EOB_MEMBER_INSURANCE[1]/coverage/period/end != ''">
                        <xsl:choose>
                            
                            <xsl:when
                                test="$EOB_MEMBER_INSURANCE[1]/coverage/period/end  > current-date()">
                                <status value="active"/>
                            </xsl:when>
                            <xsl:when
                                test="current-date() > $EOB_MEMBER_INSURANCE[1]/coverage/period/end ">
                                <status value="cancelled"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <status value="active"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$EOB_MEMBER_INSURANCE[1]/coverage/period/end">
                        <status value="cancelled"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <status value="active"/>
                    </xsl:otherwise>
                </xsl:choose>-->
                <status value="active"/>
                
                    <!-- 0..* Self-pay parties and responsibility -->
                   <!--  <party> -->
                        <!-- 1..1 Reference(Organization|Patient|RelatedPerson) Parties performing self-payment -->
    <!--
                        <xsl:variable name="PTT_Organization"
                            select="translate($EOB_MEMBER_INSURANCE[1]/coverage/beneficiary/unique_person_id_assigner[1], ' ', '')"/>
                        <reference>
    
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="concat('Organization/', $EOB_CUSTOMER_PREFIX, '-', $PTT_Organization)"
                                />
                            </xsl:attribute>
                        </reference>
                    </party> -->
                    <!-- <responsibility>
                        0..1 Party's responsibility 
                    </responsibility> -->
                
                <!-- 0..1 CodeableConcept Coverage category such as medical or accident -->
                <!-- <type>
                </type> -->
                <!--     <policyHolder>
                    <!-\- 0..1 Reference(Organization|Patient|RelatedPerson) Owner of the policy -\->
                    <reference>
                        <xsl:attribute name="value">
                            <xsl:value-of
                                select="concat('Patient/', $EOB_CUSTOMER_PREFIX, '-', $EOB_SUBSCRIBER)"/>
                            <!-\- <xsl:value-of select="$PTT_beneficiary"/> -\->
                        </xsl:attribute>
                    </reference>
                </policyHolder>
                <subscriber>
                    <!-\- 0..1 Reference(Patient|RelatedPerson) Subscriber to the policy -\->
                    
                    <reference>
                        
                        <xsl:attribute name="value">
                            <xsl:value-of
                                select="concat('Patient/', $EOB_CUSTOMER_PREFIX, '-', $EOB_SUBSCRIBER)"/>
                            <!-\- <xsl:value-of select="$PTT_beneficiary"/> -\->
                        </xsl:attribute>
                    </reference>
                    
                </subscriber>-->
                <subscriberId>
                    <!-- 0..* Identifier ID assigned to the subscriber -->
                    <xsl:attribute name="value">
                        <xsl:value-of select="$EOB_SUBSCRIBER"/>
                    </xsl:attribute>
                </subscriberId>
                <beneficiary>
                    <!-- 1..1 Reference(Patient) Plan beneficiary -->
    
    
                    <xsl:variable name="PTT_beneficiary"
                        select="$EOB_MEMBER_INSURANCE[1]/coverage/beneficiary/unique_person_id"/>
                    <reference>
    
                        <xsl:attribute name="value">
                            <xsl:value-of
                                select="concat('Patient/', $EOB_CUSTOMER_PREFIX, '-', $PTT_beneficiary)"/>
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
                                    lower-case($EOB_MEMBER_INSURANCE[1]/coverage/relationship) = 'child' or 'parent'
                                    or 'spouse' or 'common' or 'self' or 'other' or 'injured'">
                                <xsl:value-of
                                    select="lower-case($EOB_MEMBER_INSURANCE[1]/coverage/relationship)"
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
                            <xsl:value-of select="$EOB_MEMBER_INSURANCE[1]/coverage/period/start"/>
                        </xsl:attribute>
                    </start>
                    <end>
                        <xsl:attribute name="value">
                            <xsl:value-of select="$EOB_MEMBER_INSURANCE[1]/coverage/period/end"/>
                        </xsl:attribute>
    
                    </end>
                </period>
                <payor>
                    <!-- 0..1 Reference(Organization) Issuer of the policy -->
    
                    <xsl:variable name="PTT_Organization"
                        select="translate($EOB_MEMBER_INSURANCE[1]/coverage/beneficiary/unique_person_id_assigner[1], ' ', '')"/>
                    <reference>
    
                        <xsl:attribute name="value">
                            <xsl:value-of
                                select="concat('Organization/', $EOB_CUSTOMER_PREFIX, '-', $PTT_Organization)"
                            />
                        </xsl:attribute>
                    </reference>
                </payor>
    
                <class>
                    <type>
                        <coding>
                            <system value="http://terminology.hl7.org/CodeSystem/coverage-class"/>
                            <code value="group"/>
                        </coding>
                    </type>
                    <value>
    
                        <xsl:attribute name="value">
                            <xsl:value-of
                                select="$EOB_MEMBER_INSURANCE[1]/coverage/classes/class/group/value"/>
                        </xsl:attribute>
    
    
                    </value>
                    <name>
                        <xsl:attribute name="value">
                            <xsl:value-of
                                select="$EOB_MEMBER_INSURANCE[1]/coverage/classes/class/group/name"/>
                        </xsl:attribute>
                    </name>
                </class>
                <class>
                    <type>
                        <coding>
                            <system value="http://terminology.hl7.org/CodeSystem/coverage-class"/>
                            <code value="plan_name"/>
                        </coding>
                    </type>
                    <value>
    
                        <xsl:attribute name="value">
                            <xsl:value-of
                                select="$EOB_MEMBER_INSURANCE[1]/coverage/classes/class/plan/value"/>
                        </xsl:attribute>
    
    
                    </value>
                    <name>
                        <xsl:attribute name="value">
                            <xsl:value-of
                                select="$EOB_MEMBER_INSURANCE[1]/coverage/classes/class/plan/name"/>
                        </xsl:attribute>
                    </name>
                </class>
                <!-- <order value="1"/> -->
                <!-- 0..1 Relative order of the coverage -->
                <network>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$EOB_MEMBER_INSURANCE/coverage/classes/class/group/name"/>
                    </xsl:attribute>
                </network>
                -->
            </Coverage>
        </xsl:if>
    </xsl:template>

    <!--CONTAINER LOGIC-->
    <!--CONTAINER LOGIC-->
    <!--CONTAINER LOGIC-->
</xsl:stylesheet>