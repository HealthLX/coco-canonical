<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="Provenance" select="/clinicals/clinical/provenances/provenance"/>
    <xsl:variable name="ORG" select="/clinicals/clinical/organizations/organization"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        
        <Provenances>
            <xsl:for-each select="$Provenance">
                <Provenance xmlns="http://hl7.org/fhir">
                    <id>
                        <!-- example has 'health-concern-example' and 'encounter-diagnosis-example1'-->
                        <xsl:attribute name="value">
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
                        <profile
                            value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-provenance|6.1.0"
                        />
                    </meta>
                    <xsl:variable name="fhirResource">
                        <xsl:call-template name="map-to-fhir-resource">
                            <xsl:with-param name="type" select="./target/resource_type"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <target>
                        <reference>
                            <xsl:attribute name="value">
                                <xsl:value-of select="concat($fhirResource,'/',$CUSTOMER_PREFIX,'-',./target/unique_identifier)"/>
                            </xsl:attribute>
                        </reference>
                    </target>
                    <recorded>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./recorded"/>
                        </xsl:attribute>
                    </recorded>
                    <xsl:if test="./agent/agent_provenance_general">
                        <agent>
                            <type>
                                <coding>
                                    <system>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./agent/agent_provenance_general/type/system"/>
                                        </xsl:attribute>
                                    </system>
                                    <code>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./agent/agent_provenance_general/type/code"/>
                                        </xsl:attribute>
                                    </code>
                                </coding>
                            </type>
                            <who>
                                <xsl:choose>
                                    <xsl:when test="./agent/agent_provenance_general/who/patient/unique_person_id">
                                        <reference>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('Patient/',$CUSTOMER_PREFIX,'-',./agent/agent_provenance_general/who/patient/unique_person_id)"/>
                                            </xsl:attribute>
                                        </reference>
                                    </xsl:when>
                                    <xsl:when test="./agent/agent_provenance_general/who/practitioner/npi">
                                        <reference>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('Practitioner/',$CUSTOMER_PREFIX,'-',./agent/agent_provenance_general/who/practitioner/npi)"/>
                                            </xsl:attribute>
                                        </reference>
                                    </xsl:when>
                                    <xsl:when test="./agent/agent_provenance_general/who/organization/npi">
                                        <reference>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('Organization/',$CUSTOMER_PREFIX,'-',./agent/agent_provenance_general/who/organization/npi)"/>
                                            </xsl:attribute>
                                        </reference>
                                    </xsl:when>
                                </xsl:choose>
                            </who>
                            <xsl:if test="./agent/agent_provenance_general/on_behalf_of">
                                <onBehalfOf>
                                    <reference>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="concat('Organization/',$CUSTOMER_PREFIX,'-',./agent/agent_provenance_general/on_behalf_of/organization/npi)"/>
                                        </xsl:attribute>
                                    </reference>
                                </onBehalfOf>
                            </xsl:if>
                        </agent>
                    </xsl:if>
                    <xsl:if test="./agent/agent_provenance_author">
                        <agent>
                            <type>
                                <coding>
                                    <system value="http://terminology.hl7.org/CodeSystem/provenance-participant-type"/>
                                    <code value="author"/>
                                </coding>
                            </type>
                            <who>
                                <xsl:choose>
                                    <xsl:when test="./agent/agent_provenance_author/who/patient/unique_person_id">
                                        <reference>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('Patient/',$CUSTOMER_PREFIX,'-',./agent/agent_provenance_author/who/patient/unique_person_id)"/>
                                            </xsl:attribute>
                                        </reference>
                                    </xsl:when>
                                    <xsl:when test="./agent/agent_provenance_author/who/practitioner/npi">
                                        <reference>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('Practitioner/',$CUSTOMER_PREFIX,'-',./agent/agent_provenance_author/who/practitioner/npi)"/>
                                            </xsl:attribute>
                                        </reference>
                                    </xsl:when>
                                    <xsl:when test="./agent/agent_provenance_author/who/organization/npi">
                                        <reference>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('Organization/',$CUSTOMER_PREFIX,'-',./agent/agent_provenance_author/who/organization/npi)"/>
                                            </xsl:attribute>
                                        </reference>
                                    </xsl:when>
                                </xsl:choose>
                            </who>
                            <xsl:if test="./agent/agent_provenance_author/on_behalf_of">
                                <onBehalfOf>
                                    <reference>
                                        <xsl:choose>
                                            <xsl:when test="./agent/agent_provenance_author/on_behalf_of/patient/unique_person_id">
                                                
                                                <xsl:attribute name="value">
                                                    <xsl:value-of
                                                        select="concat('Patient/',$CUSTOMER_PREFIX,'-',./agent/agent_provenance_author/on_behalf_of/patient/unique_person_id)"/>
                                                </xsl:attribute>
                                                
                                            </xsl:when>
                                            <xsl:when test="./agent/agent_provenance_author/on_behalf_of/practitioner/npi">
                                                
                                                <xsl:attribute name="value">
                                                    <xsl:value-of
                                                        select="concat('Practitioner/',$CUSTOMER_PREFIX,'-',./agent/agent_provenance_author/on_behalf_of/practitioner/npi)"/>
                                                </xsl:attribute>
                                                
                                            </xsl:when>
                                            <xsl:when test="./agent/agent_provenance_author/on_behalf_of/organization/npi">
                                                
                                                <xsl:attribute name="value">
                                                    <xsl:value-of
                                                        select="concat('Organization/',$CUSTOMER_PREFIX,'-',./agent/agent_provenance_author/on_behalf_of/organization/npi)"/>
                                                </xsl:attribute>
                                                
                                            </xsl:when>
                                        </xsl:choose>
                                    </reference>
                                </onBehalfOf>
                            </xsl:if>                            
                        </agent>
                    </xsl:if>
                    <xsl:if test="./agent/agent_provenance_transmitter">
                        <agent>
                            <type>
                                <coding>
                                    <system value="http://terminology.hl7.org/CodeSystem/provenance-participant-type"/>
                                    <code value="author"/>
                                </coding>
                            </type>
                            <who>
                                <xsl:choose>
                                    <xsl:when test="./agent/agent_provenance_transmitter/who/patient/unique_person_id">
                                        <reference>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('Patient/',$CUSTOMER_PREFIX,'-',./agent/agent_provenance_transmitter/who/patient/unique_person_id)"/>
                                            </xsl:attribute>
                                        </reference>
                                    </xsl:when>
                                    <xsl:when test="./agent/agent_provenance_transmitter/who/practitioner/npi">
                                        <reference>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('Practitioner/',$CUSTOMER_PREFIX,'-',./agent/agent_provenance_transmitter/who/practitioner/npi)"/>
                                            </xsl:attribute>
                                        </reference>
                                    </xsl:when>
                                    <xsl:when test="./agent/agent_provenance_transmitter/who/organization/npi">
                                        <reference>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                    select="concat('Organization/',$CUSTOMER_PREFIX,'-',./agent/agent_provenance_transmitter/who/organization/npi)"/>
                                            </xsl:attribute>
                                        </reference>
                                    </xsl:when>
                                </xsl:choose>
                            </who>
                            <xsl:if test="./on_behalf_of">
                                <onBehalfOf>
                                    <reference>
                                        <xsl:choose>
                                            <xsl:when test="./agent/agent_provenance_transmitter/on_behalf_of/patient/unique_person_id">
                                                
                                                <xsl:attribute name="value">
                                                    <xsl:value-of
                                                        select="concat('Patient/',$CUSTOMER_PREFIX,'-',./agent/agent_provenance_transmitter/on_behalf_of/patient/unique_person_id)"/>
                                                </xsl:attribute>
                                                
                                            </xsl:when>
                                            <xsl:when test="./agent/agent_provenance_transmitter/on_behalf_of/practitioner/npi">
                                                
                                                <xsl:attribute name="value">
                                                    <xsl:value-of
                                                        select="concat('Practitioner/',$CUSTOMER_PREFIX,'-',./agent/agent_provenance_transmitter/on_behalf_of/practitioner/npi)"/>
                                                </xsl:attribute>
                                                
                                            </xsl:when>
                                            <xsl:when test="./agent/agent_provenance_transmitter/on_behalf_of/organization/npi">
                                                
                                                <xsl:attribute name="value">
                                                    <xsl:value-of
                                                        select="concat('Organization/',$CUSTOMER_PREFIX,'-',./agent/agent_provenance_transmitter/on_behalf_of/organization/npi)"/>
                                                </xsl:attribute>
                                                
                                            </xsl:when>
                                        </xsl:choose>
                                    </reference>
                                </onBehalfOf>
                            </xsl:if>
                        </agent>
                    </xsl:if>
                </Provenance>
            </xsl:for-each>
        </Provenances>
    </xsl:template>
    <xsl:template name="map-to-fhir-resource">
        <xsl:param name="type"/>
        <xsl:choose>
            <xsl:when test="$type = 'allergy_intolerance'">AllergyIntolerance</xsl:when>
            <xsl:when test="$type = 'care_plan'">CarePlan</xsl:when>
            <xsl:when test="$type = 'care_team'">CareTeam</xsl:when>
            <xsl:when test="$type = 'condition'">Condition</xsl:when>
            <xsl:when test="$type = 'diagnostic_report_lab'">DiagnosticReport</xsl:when>
            <xsl:when test="$type = 'diagnostic_report_note'">DiagnosticReport</xsl:when>
            <xsl:when test="$type = 'document_reference'">DocumentReference</xsl:when>
            <xsl:when test="$type = 'encounter'">Encounter</xsl:when>
            <xsl:when test="$type = 'goal'">Goal</xsl:when>
            <xsl:when test="$type = 'immunization'">Immunization</xsl:when>
            <xsl:when test="$type = 'implantable_device'">Device</xsl:when>
            <xsl:when test="$type = 'lab_observation'">Observation</xsl:when>
            <xsl:when test="$type = 'medication_request'">MedicationRequest</xsl:when>
            <xsl:when test="$type = 'patient'">Patient</xsl:when>
            <xsl:when test="$type = 'pediatric_bmi_for_age_observation'">Observation</xsl:when>
            <xsl:when test="$type = 'pediatric_weight_for_height_observation'">Observation</xsl:when>
            <xsl:when test="$type = 'procedure'">Procedure</xsl:when>
            <xsl:when test="$type = 'pulse_oximetry_observation'">Observation</xsl:when>
            <xsl:when test="$type = 'smoking_status_observation'">Observation</xsl:when>
            <xsl:when test="$type = 'observation_vital_sign'">Observation</xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
