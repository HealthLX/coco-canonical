<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="Condition" select="clinicals/clinical/conditions/condition"/>
    <xsl:variable name="CareTeam" select="/clinicals/clinical/care_teams/care_team"/>
    <xsl:variable name="ORG" select="/clinicals/clinical/organizations/organization"/>
    <xsl:variable name="Encounter" select="/clinicals/clinical/encounters/encounter"/>
    <xsl:variable name="DocRef" select="/clinicals/clinical/document_references/document_reference"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        <Encounters>
            <xsl:for-each select="$Encounter | $DocRef[context/encounter]">
                <Encounter xmlns="http://hl7.org/fhir">
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
                        
                        <profile
                            value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter"/>
                        
                    </meta>
                    <!-- <contained>
                        <xsl:call-template name="Internal_Location_container"/>
                    </contained> -->
                    <status>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./encounter_details/status | $DocRef/context/encounter/status"/>
                        </xsl:attribute>
                    </status>
                    <class>
                        <system value="http://terminology.hl7.org/CodeSystem/v3-ActCode"/>
                        <code>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./encounter_details/class | $DocRef/context/encounter/class"/>
                            </xsl:attribute>
                        </code>
                        <display>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./encounter_details/class | $DocRef/context/encounter/class"/>
                            </xsl:attribute>
                        </display>
                    </class>
                    <xsl:for-each select="./encounter_details/type | $DocRef/context/encounter/type">
                        <type>
                            <coding>
                                <system value="http://www.ama-assn.org/go/cpt"/>
                                <code>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./code"/>
                                    </xsl:attribute>
                                </code>
                                <xsl:if test="version">
                                    <version>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="version"/>
                                        </xsl:attribute>
                                    </version>
                                </xsl:if>
                                <xsl:if test="display">
                                    <display>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="display"/>
                                        </xsl:attribute>
                                    </display>
                                </xsl:if>
                            </coding>
                            <xsl:if test="text">
                                <text>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="text"/>
                                    </xsl:attribute>
                                </text>
                            </xsl:if>
                        </type>
                    </xsl:for-each>
                    <subject>
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
                    <xsl:for-each select="./encounter_details/participants/participant">
                        <participant>
                            <xsl:if test="type">
                                <type>
                                    <coding>
                                        <xsl:if test="type/system">
                                            <system>
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="type/system"/>
                                                </xsl:attribute>    
                                            </system>
                                        </xsl:if>
                                        <xsl:if test="type/code">
                                            <code>
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="type/code"/>
                                                </xsl:attribute>
                                            </code>
                                        </xsl:if>
                                    </coding>
                                </type>
                            </xsl:if>
                            <xsl:if test="period">
                                <period>
                                    <start>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="period/start"/>
                                        </xsl:attribute>
                                    </start>
                                    <xsl:if test="period/end">
                                        <end>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="period/end"/>
                                            </xsl:attribute>
                                        </end>
                                    </xsl:if>
                                </period>
                            </xsl:if>
                            <individual>
                                <xsl:choose>
                                    <xsl:when test="individual/reference">
                                        <reference>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="concat('Practitioner/', $CUSTOMER_PREFIX, '-', individual/reference)"/>
                                            </xsl:attribute>
                                        </reference>
                                    </xsl:when>
                                </xsl:choose>
                            </individual>
                        </participant>
                    </xsl:for-each>
                    <xsl:if test="./encounter_details/period | ./context/encounter/period">
                        <period>
                            <start>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./encounter_details/period/start | ./context/encounter/period/start"/>
                                </xsl:attribute>
                            </start>
                            <xsl:if test="./encounter_details/period/end | ./context/encounter/period/end">
                                <end>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./encounter_details/period/end | ./context/encounter/period/end"/>
                                    </xsl:attribute>
                                </end>
                            </xsl:if>
                        </period>
                    </xsl:if>
                    <xsl:for-each select="./encounter_details/reason_code">
                        <reasonCode>
                            <coding>
                                <xsl:if test="./system">
                                    <system>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./system"/>
                                        </xsl:attribute>
                                    </system>
                                </xsl:if>
                                <xsl:if test="./code">
                                    <code>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./code"/>
                                        </xsl:attribute>
                                    </code>
                                </xsl:if>
                            </coding>
                        </reasonCode>
                    </xsl:for-each>                 
                    <xsl:if test="./encounter_details/hospitalization | ./context/encounter/hospitalization">
                        <hospitalization>
                            <dischargeDisposition>
                                <coding>
                                    <system>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="./encounter_details/hospitalization/discharge_disposition/coding/system | ./context/encounter/hospitalization/discharge_disposition/coding/system"
                                            />
                                        </xsl:attribute>
                                        
                                    </system>
                                    <code>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="./encounter_details/hospitalization/discharge_disposition/coding/code | ./context/encounter/hospitalization/discharge_disposition/coding/code"
                                            />
                                        </xsl:attribute>
                                    </code>
                                    <display>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="./encounter_details/hospitalization/discharge_disposition/coding/display | ./context/encounter/hospitalization/discharge_disposition/coding/display"
                                            />
                                        </xsl:attribute>
                                    </display>
                                </coding>
                            </dischargeDisposition>
                        </hospitalization>                        
                    </xsl:if>
                    <xsl:for-each select="./encounter_details/locations/location | ./context/encounter/locations/location">
                        <location>
                            <reference>
                                <xsl:attribute name="value">                                    
                                    <xsl:value-of
                                        select="concat('Location/', $CUSTOMER_PREFIX, '-',./identifier/value)"
                                        > </xsl:value-of>
                                </xsl:attribute>
                            </reference>
                            <xsl:if test="./identifier/type">
                                <type>
                                    <xsl:attribute name="value">                                    
                                        <xsl:value-of
                                            select="./identifier/type"
                                            > </xsl:value-of>
                                    </xsl:attribute>
                                </type>
                            </xsl:if>
                            <display>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./name"/>
                                </xsl:attribute>
                            </display>                            
                        </location>
                    </xsl:for-each>
                </Encounter>
            </xsl:for-each>
        </Encounters>
    </xsl:template>

    <xsl:template name="Internal_Location_container">
        <xsl:variable name="LOC" select="./encounter_details/locations/location | ./context/encounter/locations/location"/>

        <Location xmlns="http://hl7.org/fhir">

            <id>
                <xsl:attribute name="value">
                    <xsl:value-of select="'LocationDerived1'"
                    > </xsl:value-of>
                </xsl:attribute>

            </id>


            <status>
                <!--  value="[boolean]"0..1 Whether the organization's record is still in active use -->
                <xsl:choose>
                    <xsl:when test="$LOC/status">
                        <xsl:attribute name="value">
                            <xsl:value-of select="$LOC/status"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="value">
                            <xsl:value-of select="'active'"/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </status>

            <address>
                <xsl:for-each select="$LOC/address/line">
                    <line>
                        <xsl:attribute name="value">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </line>
                </xsl:for-each>
                <city>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$LOC/address/city"/>
                    </xsl:attribute>
                </city>
                <district>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$LOC/address/district"/>
                    </xsl:attribute>
                </district>
                <state>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$LOC/address/state"/>
                    </xsl:attribute>
                </state>
                <postalCode>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$LOC/address/postal_code"/>
                    </xsl:attribute>
                </postalCode>
                <country>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$LOC/address/country"/>
                    </xsl:attribute>
                </country>
                <period>
                    <start>
                        <xsl:attribute name="value">
                            <xsl:value-of select="$LOC/address/period/start"/>
                        </xsl:attribute>
                    </start>
                    <end>
                        <xsl:attribute name="value">
                            <xsl:value-of select="$LOC/address/period/end"/>
                        </xsl:attribute>
                    </end>
                </period>
            </address>
        </Location>



    </xsl:template>

</xsl:stylesheet>
