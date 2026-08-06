<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="Observation" select="/clinicals/clinical/lab_observations/lab_observation"/>
    <xsl:variable name="MedicationRequest" select="/clinicals/clinical/medication_requests/medication_request"/>
    <xsl:variable name="ORG" select="/clinicals/clinical/organizations/organization"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        <Observations>
            <xsl:for-each select="$Observation">
                <Observation xmlns="http://hl7.org/fhir">
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
                            value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab"
                        />
                    </meta>
                    <xsl:if test="./specimen">
                        <contained>
                            <Specimen>
                                <id>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./specimen/identifier"/>
                                    </xsl:attribute>
                                </id>
                                <status>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./specimen/status"/>
                                    </xsl:attribute>
                                </status>
                                <type>
                                    <coding>
                                        <system
                                            value="http://terminology.hl7.org/CodeSystem/v2-0487"/>
                                        <code>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./specimen/type/coding/code"/>
                                            </xsl:attribute>
                                        </code>
                                        <display>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                  select="./specimen/type/coding/display"/>
                                            </xsl:attribute>
                                        </display>
                                    </coding>
                                </type>
                                <subject>
                                    <reference>
                                        <xsl:choose>
                                            <xsl:when test="$PAT/reference">
                                                <xsl:variable name="inputString"
                                                  select="$PAT/reference"/>
                                                <xsl:variable name="parts"
                                                  select="tokenize($inputString, '/')"/>
                                                <xsl:attribute name="value">
                                                  <xsl:value-of
                                                  select="concat($parts[1], '/', $CUSTOMER_PREFIX, '-', $parts[2])"
                                                  />
                                                </xsl:attribute>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:attribute name="value">
                                                  <xsl:value-of
                                                  select="concat('Patient/', $PAT/unique_person_id)"
                                                  />
                                                </xsl:attribute>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </reference>
                                </subject>
                                <receivedTime>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./specimen/receivedDateTime"/>
                                    </xsl:attribute>
                                </receivedTime>
                                <collection>
                                    <collectedDateTime>
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                select="./specimen/collection/collectedDateTime"/>
                                        </xsl:attribute>
                                    </collectedDateTime>
                                    <quantity>
                                        <value>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                  select="./specimen/collection/quantity/value"/>
                                            </xsl:attribute>
                                        </value>
                                        <unit>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                  select="./specimen/collection/quantity/unit"/>
                                            </xsl:attribute>
                                        </unit>
                                        <system value="http://unitsofmeasure.org"/>
                                        <code>
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                  select="./specimen/collection/quantity/code"/>
                                            </xsl:attribute>
                                        </code>
                                    </quantity>
                                    <method>
                                        <coding>
                                            <system>
                                                <xsl:attribute name="value">
                                                  <xsl:value-of
                                                  select="./specimen/collection/method/coding/system"
                                                  />
                                                </xsl:attribute>
                                            </system>
                                            <code>
                                                <xsl:attribute name="value">
                                                  <xsl:value-of
                                                  select="./specimen/collection/method/coding/code"
                                                  />
                                                </xsl:attribute>
                                            </code>
                                            <display>
                                                <xsl:attribute name="value">
                                                  <xsl:value-of
                                                  select="./specimen/collection/method/coding/display"
                                                  />
                                                </xsl:attribute>
                                            </display>
                                        </coding>
                                    </method>
                                </collection>
                            </Specimen>
                        </contained>
                    </xsl:if>
                    <status>
                        <xsl:attribute name="value">
                            <!-- will need to check when we have good data-->
                            <xsl:value-of select="./status"/>
                        </xsl:attribute>
                    </status>
                    <category>
                        <!-- Looks like it should be hardcoded for labs -->
                        <coding>
                            <system
                                value="http://terminology.hl7.org/CodeSystem/observation-category"/>
                            <code value="laboratory"/>
                            <display value="Laboratory"/>
                        </coding>
                        <text value="Laboratory"/>
                    </category>
                    <xsl:if test="./observation_code/coding">
                        <xsl:element name="code">
                            <xsl:element name="coding">
                                <xsl:if test="./observation_code/coding/system">
                                    <xsl:element name="system">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./observation_code/coding/system"
                                            />
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="./observation_code/coding/version">
                                    <xsl:element name="version">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./observation_code/coding/version"
                                            />
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="./observation_code/coding/code">
                                    <xsl:element name="code">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./observation_code/coding/code"/>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="./observation_code/coding/display">
                                    <xsl:element name="display">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./observation_code/coding/display"
                                            />
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:element>
                            <xsl:if test="./observation_code/text">
                                <xsl:element name="text">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./observation_code/text"/>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                        </xsl:element>
                    </xsl:if>
                    <subject>
                        <reference>
                            <xsl:choose>
                                <xsl:when test="$PAT/reference">
                                    <xsl:variable name="inputString" select="$PAT/reference"/>
                                    <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="concat($parts[1], '/', $CUSTOMER_PREFIX, '-', $parts[2])"
                                        />
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="concat('Patient/', $PAT/unique_person_id)"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </reference>
                        <xsl:if test="$PAT/names/name[1]/text">
                            <display value="{$PAT/names/name[1]/text}"/>
                        </xsl:if>
                    </subject>
                    <effectiveDateTime>
                        <xsl:attribute name="value">
                            <!-- will need to check when we have good data-->
                            <xsl:value-of select="./observation_effective/effective_period/start"/>
                        </xsl:attribute>
                    </effectiveDateTime>
                    <xsl:if test="./observation_value/value_quantity">
                        <valueQuantity>
                            <xsl:variable name="vq" select="observation_value/value_quantity"/>
                            <xsl:if test="$vq/value">
                                <value value="{$vq/value}"/>
                            </xsl:if>
                            <xsl:if test="$vq/comparator">
                                <comparator value="{$vq/comparator}"/>
                            </xsl:if>
                            <xsl:if test="$vq/unit">
                                <unit value="{$vq/unit}"/>
                            </xsl:if>
                            <xsl:if test="$vq/system">
                                <system value="{$vq/system}"/>
                            </xsl:if>
                            <xsl:if test="$vq/code">
                                <code value="{$vq/code}"/>
                            </xsl:if>
                        </valueQuantity>
                    </xsl:if>
                    <xsl:if test="./observation_value/value_codeable_concept">
                        <valueCodeableConcept>
                            <xsl:variable name="vc"
                                select="observation_value/value_codeable_concept"/>
                            <xsl:if test="$vc/coding">
                                <coding>
                                    <xsl:variable name="vcod"
                                        select="observation_value/value_codeable_concept/coding"/>
                                    <xsl:if test="$vcod/system">
                                        <system value="{$vcod/system}"/>
                                    </xsl:if>
                                    <xsl:if test="$vcod/version">
                                        <version value="{$vcod/version}"/>
                                    </xsl:if>
                                    <xsl:if test="$vcod/code">
                                        <code value="{$vcod/code}"/>
                                    </xsl:if>
                                    <xsl:if test="$vcod/display">
                                        <display value="{$vcod/display}"/>
                                    </xsl:if>
                                    <xsl:if test="$vcod/userSelected">
                                        <userSelected value="{$vcod/userSelected}"/>
                                    </xsl:if>
                                </coding>
                            </xsl:if>
                            <xsl:if test="$vc/text">
                                <text value="{$vc/text}"/>
                            </xsl:if>
                        </valueCodeableConcept>
                    </xsl:if>
                    <xsl:if test="./observation_value/value_string">
                        <valueString value="{./observation_value/value_string}"/>
                    </xsl:if>
                    <xsl:if test="./data_absent_reason">
                        <dataAbsentReason>
                            <coding>
                                <system
                                    value="http://hl7.org/fhir/R4/valueset-data-absent-reason.html"/>
                                <code value="{./data_absent_reason}"/>
                            </coding>
                            <text value="{./data_absent_reason}"/>
                        </dataAbsentReason>
                    </xsl:if>
                    <xsl:for-each select="./interpretation">
                        <interpretation>
                            <coding>
                                <system
                                    value="http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"/>
                                <code value="{.}"/>
                            </coding>
                            <text value="{.}"/>
                        </interpretation>
                    </xsl:for-each>
                    <xsl:if test="./specimen">
                        <specimen>
                            <reference>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="concat('#', ./specimen/identifier)"/>
                                </xsl:attribute>
                            </reference>
                            <display>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./specimen/display"/>
                                </xsl:attribute>
                            </display>
                        </specimen>
                    </xsl:if>
                </Observation>
            </xsl:for-each>
        </Observations>
    </xsl:template>
</xsl:stylesheet>
