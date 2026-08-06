<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="Condition" select="/clinicals/clinical/conditions/condition"/>
    <xsl:variable name="MedicationRequest" select="clinicals/clinical/medication_requests/medication_request"/>
    <xsl:variable name="ORG" select="/clinicals/clinical/organizations/organization"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">

        <MedicationRequests>
            <xsl:for-each select="$MedicationRequest">
                <MedicationRequest xmlns="http://hl7.org/fhir">
                    <id>
                        <xsl:attribute name="value">
                            <!-- will need to check when we have good data-->
                            <xsl:value-of
                                select="concat($CUSTOMER_PREFIX, '-', ./unique_identifier)"/>
                        </xsl:attribute>
                    </id>
                    <meta>
                        <source>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$PARENTFILE_NAME"/>
                            </xsl:attribute>
                        </source>
                        <profile value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-medicationrequest"/>
                    </meta>
                    <contained>
                        <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                        <xsl:call-template name="Internal_requester_container"/>
                    </contained>
                    <!-- from Resource: id, meta, implicitRules, and language -->
                    <!-- from DomainResource: text, contained, extension, and modifierExtension -->
                    <identifier>
                        <value>
                            <xsl:attribute name="value">
                                <!-- will need to check when we have good data-->
                                <xsl:value-of
                                    select="concat($CUSTOMER_PREFIX, '-', ./unique_identifier)"/>
                            </xsl:attribute>
                        </value>
                    </identifier>
                    <status>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./status"/>
                        </xsl:attribute>
                    </status>
                    <statusReason><!-- 0..1 CodeableConcept Reason for current status --></statusReason>
                    <intent>
                        <!-- 1..1 proposal | plan | order | original-order | reflex-order | filler-order | instance-order | option -->
                        <xsl:attribute name="value">
                            <xsl:value-of select="./intent"/>
                        </xsl:attribute>
                    </intent>
                    <medicationCodeableConcept>
                        <xsl:choose>
                            <xsl:when test="./medication/medication_code/code">
                                <coding>
                                    <xsl:if test="./medication/medication_code/system">
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./medication/medication_code/system"/>
                                            </xsl:attribute>
                                        </system>
                                    </xsl:if>
                                    <xsl:if test="/medication/medication_code/version">
                                        <version>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./medication/medication_code/version"/>
                                            </xsl:attribute>
                                        </version>
                                    </xsl:if>
                                    <code>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./medication/medication_code/code"/>
                                        </xsl:attribute>
                                    </code>
                                    <xsl:if test="./medication/medication_code/display">
                                        <display>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./medication/medication_code/display"/>
                                            </xsl:attribute>
                                        </display>
                                    </xsl:if>
                                </coding>  
                                <xsl:if test="./medication/medication_code/text">
                                    <text>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./medication/medication_code/text"/>
                                        </xsl:attribute>
                                    </text>
                                </xsl:if>                                
                            </xsl:when>
                            <xsl:otherwise>
                                <extension>
                                    <url value="http://hl7.org/fhir/StructureDefinition/data-absent-reason"/>
                                    <valueCode value="unknown"/>
                                </extension>
                            </xsl:otherwise>
                        </xsl:choose>
                    </medicationCodeableConcept>
                    <subject>
                        <!-- 1..1 Reference(Patient|Group) Who or group medication request is for -->
                        <xsl:choose>
                            <xsl:when test="$PAT/reference">
                                <reference>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="concat('Patient/', $CUSTOMER_PREFIX, '-', $PAT/reference)"/>
                                    </xsl:attribute>
                                </reference>
                            </xsl:when>
                            <xsl:otherwise>
                                <reference>
                                    <!-- Looks like it should be patient id -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="concat('Patient/', $CUSTOMER_PREFIX, '-', $PAT/unique_person_id)"
                                        />
                                    </xsl:attribute>
                                </reference>
                                <display>
                                    <!-- looks like is should be patient full name -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$PAT/names/name[1]/text"/>
                                    </xsl:attribute>
                                </display>
                            </xsl:otherwise>
                        </xsl:choose> 
                    </subject>
                    <encounter>
                        <!-- 0..1 Reference(Encounter) Encounter created as part of encounter/admission/stay -->
                        <!-- Do I need to create more encounter-->
                        <xsl:for-each select="./encounter/identifier">
                            <reference>
                                <!-- Looks like it should be patient id -->
                                <xsl:attribute name="value">
                                    <xsl:value-of select="concat('Encounter/', .)"/>
                                </xsl:attribute>
                            </reference>
                        </xsl:for-each>
                        <xsl:for-each select="./encounter/reference">
                            <xsl:variable name="inputString" select="."/>
                            <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                            <reference>                               
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="concat($parts[1], '/', $CUSTOMER_PREFIX, '-', $parts[2])"
                                    />
                                </xsl:attribute>
                            </reference>
                        </xsl:for-each>
                    </encounter>
                    <supportingInformation><!-- 0..* Reference(Any) Information to support ordering of the medication --></supportingInformation>
                    <xsl:if test="authored_on">
                        <authoredOn>
                            <xsl:attribute name="value">
                                <xsl:value-of select="authored_on"/>
                            </xsl:attribute>
                        </authoredOn>
                    </xsl:if>
                    <!--  value="[dateTime]" 0..1 When request was initially authored -->
                    <requester>
                        <!-- 0..1 Reference(Practitioner|PractitionerRole|Organization|Patient|RelatedPerson|Device) Who/What requested the Request -->
                        <!--contained resources-->
                        <xsl:choose>
                            <xsl:when test="./requester/organization">
                                <!-- Looks like it should be patient id -->
                                <reference value="#RequesterOrganizationDerived1"/>
                            </xsl:when>
                            <xsl:when test="./requester/practitioner">
                                <!-- Looks like it should be patient id -->
                                <reference value="#RequesterPractitionerDerived1"/>
                            </xsl:when>
                            <xsl:when test="./requester/reference">
                                <xsl:variable name="inputString" select="requester/reference"/>
                                <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                                <reference>
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="concat($parts[1], '/', $CUSTOMER_PREFIX, '-', $parts[2])"
                                        />
                                    </xsl:attribute>
                                </reference>                                
                            </xsl:when>
                            <xsl:otherwise>
                                <extension url="http://hl7.org/fhir/StructureDefinition/data-absent-reason">
                                    <valueCode value="unknown"/>
                                </extension>
                                <display value="Unknown requester"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </requester>
                    <performer><!-- 0..1 Reference(Practitioner|PractitionerRole|Organization|
   Patient|Device|RelatedPerson|CareTeam) Intended performer of administration --></performer>
                    <performerType><!-- 0..1 CodeableConcept Desired kind of performer of the medication administration --></performerType>
                    <recorder><!-- 0..1 Reference(Practitioner|PractitionerRole) Person who entered the request --></recorder>
                    <reasonCode>
                        <xsl:if test="./reason_code/coding/system or ./reason_code/coding/code or ./reason_code/coding/version or ./reason_code/coding/display">
                            <coding>
                                <xsl:if test="./reason_code/coding/system">
                                    <system>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./reason_code/coding/system"/>
                                        </xsl:attribute>
                                    </system>
                                </xsl:if>
                                <xsl:if test="./reason_code/coding/version">
                                    <version>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./reason_code/coding/version"/>
                                        </xsl:attribute>
                                    </version>
                                </xsl:if>
                                <xsl:if test="./reason_code/coding/code">
                                    <code>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./reason_code/coding/code"/>
                                        </xsl:attribute>
                                    </code>
                                </xsl:if>
                                <xsl:if test="./reason_code/coding/display">
                                    <display>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./reason_code/coding/display"/>
                                        </xsl:attribute>
                                    </display>
                                </xsl:if>
                            </coding>
                        </xsl:if>
                        <xsl:if test="./reason_code/text">
                            <text>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./reason_code/text"/>
                                </xsl:attribute>
                            </text>
                        </xsl:if>
                    </reasonCode>
                    <reasonReference><!-- 0..* Reference(Condition|Observation) Condition or observation that supports why the prescription is being written --></reasonReference>
                    <instantiatesCanonical/>
                    <!-- 0..* Instantiates FHIR protocol or definition -->
                    <instantiatesUri/>
                    <!-- 0..* Instantiates external protocol or definition -->
                    <basedOn><!-- 0..* Reference(CarePlan|MedicationRequest|ServiceRequest|
   ImmunizationRecommendation) What request fulfills --></basedOn>
                    <groupIdentifier><!-- 0..1 Identifier Composite request this is part of --></groupIdentifier>
                    <courseOfTherapyType><!-- 0..1 CodeableConcept Overall pattern of medication administration --></courseOfTherapyType>
                    <insurance><!-- 0..* Reference(Coverage|ClaimResponse) Associated insurance coverage --></insurance>
                    <note><!-- 0..* Annotation Information about the prescription --></note>
                    <xsl:for-each select="./dosage_instruction">
                        <dosageInstruction>
                            <!-- 0..* Dosage How the medication should be taken -->
                            <text>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./text"/>
                                </xsl:attribute>
                            </text>
                            <doseAndRate>
                                <doseQuantity>
                                    <value>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./dose_quantity"/>
                                        </xsl:attribute>
                                    </value>
                                    <unit>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./dose_unit"/>
                                        </xsl:attribute>
                                    </unit>
                                </doseQuantity>
                            </doseAndRate>
                        </dosageInstruction>
                    </xsl:for-each>
                    <dispenseRequest>
                        <!-- 0..1 Medication supply authorization -->
                        <initialFill>
                            <!-- 0..1 First fill details -->
                            <quantity><!-- 0..1 Quantity(SimpleQuantity) First fill quantity --></quantity>
                            <duration><!-- 0..1 Duration First fill duration --></duration>
                        </initialFill>
                        <dispenseInterval><!-- 0..1 Duration Minimum period of time between dispenses --></dispenseInterval>
                        <validityPeriod><!-- 0..1 Period Time period supply is authorized for --></validityPeriod>
                        <numberOfRepeatsAllowed/>
                        <!-- 0..1 Number of refills authorized -->
                        <quantity><!-- 0..1 Quantity(SimpleQuantity) Amount of medication to supply per dispense --></quantity>
                        <expectedSupplyDuration><!-- 0..1 Duration Number of days supply per dispense --></expectedSupplyDuration>
                        <performer><!-- 0..1 Reference(Organization) Intended dispenser --></performer>
                    </dispenseRequest>
                    <substitution>
                        <!-- 0..1 Any restrictions on medication substitution -->
                        <allowed><!-- 1..1 boolean|CodeableConcept Whether substitution is allowed or not -->
                        </allowed>
                        <reason><!-- 0..1 CodeableConcept Why should (not) substitution be made --></reason>
                    </substitution>
                    <priorPrescription><!-- 0..1 Reference(MedicationRequest) An order/prescription that is being replaced --></priorPrescription>
                    <detectedIssue><!-- 0..* Reference(DetectedIssue) Clinical Issue with action --></detectedIssue>
                    <eventHistory><!-- 0..* Reference(Provenance) A list of events of interest in the lifecycle --></eventHistory>
                </MedicationRequest>
            </xsl:for-each>
        </MedicationRequests>
    </xsl:template>
    
    <xsl:template name="Internal_requester_container">
            <xsl:choose>
                <xsl:when test="./requester/organization">
                    <Organization xmlns="http://hl7.org/fhir">
                        <id>
                            <xsl:attribute name="value">
                                <xsl:value-of select="'RequesterOrganizationDerived1'"/> 
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
                                    select="./requester/organization/name[1]"/>
                            </xsl:attribute>
                        </name>
                    </Organization>
                </xsl:when>
                <xsl:when test="./requester/practitioner">
                    <Practitioner xmlns="http://hl7.org/fhir">
                        <id>
                            <xsl:attribute name="value">
                                <xsl:value-of select="'RequesterPractitionerDerived1'"/>
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
                                    <xsl:value-of select="concat(./requester/practitioner/names/name[1]/family,' ', ./requester/practitioner/names/name[1]/given[1])"/>
                                </xsl:attribute>
                            </family>
                        </name>
                    </Practitioner>
                </xsl:when>
            </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
