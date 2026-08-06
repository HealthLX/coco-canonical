<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="CLIN" select="/clinicals/clinical"/>
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="Observation"
        select="/clinicals/clinical/observation_vital_signs/observation_vital_sign"/>
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
                        <source value="{$PARENTFILE_NAME}"/>
                        <xsl:choose>
                            <xsl:when
                                test="
                                    ./value/value_quantity_bp_systolic_diastolic/value_quantity_bp_systolic
                                    | ./value/value_quantity_bp_systolic_diastolic/value_quantity_bp_diastolic">
                                <profile
                                    value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-blood-pressure"
                                />
                            </xsl:when>
                            <xsl:when test="./value/value_quantity_body_height">
                                <profile
                                    value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-height"
                                />
                            </xsl:when>
                            <xsl:when test="./value/value_quantity_body_weight">
                                <profile
                                    value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-weight"
                                />
                            </xsl:when>
                            <xsl:when test="./value/value_quantity_body_temperature">
                                <profile
                                    value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-temperature"
                                />
                            </xsl:when>
                            <xsl:when test="./value/value_quantity_heart_rate">
                                <profile
                                    value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-heart-rate"
                                />
                            </xsl:when>
                            <xsl:when test="./value/value_quantity_respiratory_rate">
                                <profile
                                    value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-respiratory-rate"
                                />
                            </xsl:when>
                            <xsl:when test="./value/value_quantity_body_mass_index">
                                <profile
                                    value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-bmi"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <profile
                                    value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </meta>
                    <status value="{./status}"/>
                    <xsl:for-each select="category_vs_cat">
                        <category>
                            <coding>
                                <system value="{./coding/system}"/>
                                <code value="{./coding/code}"/>
                            </coding>
                        </category>
                    </xsl:for-each>
                    <xsl:if test="./code">
                        <code>
                            <coding>
                                <xsl:if test="./code/system">
                                    <system value="{./code/system}"/>
                                </xsl:if>
                                <xsl:if test="./code/version">
                                    <version value="{./code/version}"/>
                                </xsl:if>
                                <xsl:if test="./code/code">
                                    <code value="{./code/code}"/>
                                </xsl:if>
                                <xsl:if test="./code/display">
                                    <display value="{./code/display}"/>
                                </xsl:if>
                            </coding>
                        </code>
                    </xsl:if>
                    <subject>
                        <reference>
                            <!-- Looks like it should be patient id -->
                            <xsl:choose>
                                <xsl:when test="$PAT/reference">
                                    <xsl:variable name="inputString" select="$PAT/reference"/>
                                    <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                                    <xsl:variable name="parts_size" select="count($parts)"/>
                                    <xsl:attribute name="value">
                                        <xsl:choose>
                                            <xsl:when test="$parts_size > 1">
                                                <xsl:value-of
                                                  select="concat($parts[1], '/', $CUSTOMER_PREFIX, '-', $parts[2])"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                  select="concat('Patient/', $CUSTOMER_PREFIX, '-', $parts[1])"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="concat('Patient/', $CUSTOMER_PREFIX, '-', $PAT/unique_person_id)"
                                        />
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </reference>
                        <xsl:if test="$PAT/names/name[1]/text">
                            <display value="{$PAT/names/name[1]/text}"/>
                        </xsl:if>
                    </subject>
                    <!-- <effectiveDateTime value="{./effective/effective_date_time}"/> -->
                    <effectiveDateTime>
                        <xsl:attribute name="value">
                            <xsl:variable name="dt"
                                select="normalize-space(./effective/effective_date_time)"/>
                            <xsl:choose>
                                <!-- If it already matches a valid dateTime pattern (has timezone) -->
                                <xsl:when
                                    test="matches($dt, 'T\d{2}:\d{2}:\d{2}(\.\d+)?(Z|[+-]\d{2}:\d{2})$')">
                                    <xsl:value-of select="$dt"/>
                                </xsl:when>

                                <!-- If it has time but no timezone (e.g. '2025-10-16T00:00:00') -->
                                <xsl:when test="matches($dt, 'T\d{2}:\d{2}:\d{2}$')">
                                    <xsl:value-of select="concat($dt, 'Z')"/>
                                </xsl:when>

                                <!-- If it's just a date (YYYY-MM-DD) -->
                                <xsl:when test="matches($dt, '^\d{4}-\d{2}-\d{2}$')">
                                    <xsl:value-of select="$dt"/>
                                </xsl:when>

                                <!-- Otherwise, fallback (emit as-is) -->
                                <xsl:otherwise>
                                    <xsl:value-of select="$dt"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </effectiveDateTime>
                    <xsl:for-each
                        select="
                            ./value/value_quantity_respiratory_rate
                            | ./value/value_quantity_heart_rate
                            | ./value/value_quantity_body_temperature
                            | ./value/value_quantity_body_height
                            | ./value/value_quantity_head_circumference
                            | ./value/value_quantity_body_weight
                            | ./value/value_quantity_body_mass_index">
                        <valueQuantity>
                            <xsl:if test="value">
                                <value value="{value}"/>
                            </xsl:if>
                            <xsl:if test="comparator">
                                <comparator value="{comparator}"/>
                            </xsl:if>
                            <xsl:if test="unit">
                                <xsl:choose>
                                    <xsl:when
                                        test="translate(unit, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'mmhg'">
                                        <unit value="mm[Hg]"/>
                                    </xsl:when>
                                    <xsl:when
                                        test="translate(unit, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'bmi' and code = 'kg/m2'">
                                        <unit value="kg/m2"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <unit value="{unit}"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:if test="system">
                                <system value="{system}"/>
                            </xsl:if>
                            <xsl:if test="code">
                                <code value="{code}"/>
                            </xsl:if>
                        </valueQuantity>
                    </xsl:for-each>
                    <xsl:for-each
                        select="
                            ./value/value_quantity_oxygen_saturation
                            | ./value/value_quantity_bp_systolic_diastolic/value_quantity_bp_systolic
                            | ./value/value_quantity_bp_systolic_diastolic/value_quantity_bp_diastolic">
                        <component>
                            <code>
                                <coding>
                                    <xsl:choose>
                                        <xsl:when test="name() = 'value_quantity_bp_systolic'">
                                            <!-- SNOMED/LOINC for systolic BP -->
                                            <system value="http://loinc.org"/>
                                            <code value="8480-6"/>
                                            <display value="Systolic blood pressure"/>
                                        </xsl:when>
                                        <xsl:when test="name() = 'value_quantity_bp_diastolic'">
                                            <system value="http://loinc.org"/>
                                            <code value="8462-4"/>
                                            <display value="Diastolic blood pressure"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <display value="{name()}"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </coding>
                            </code>

                            <valueQuantity>
                                <xsl:if test="value">
                                    <value value="{value}"/>
                                </xsl:if>
                                <xsl:if test="comparator">
                                    <comparator value="{comparator}"/>
                                </xsl:if>
                                <xsl:if test="unit">
                                    <xsl:choose>
                                        <xsl:when
                                            test="translate(unit, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'mmhg'">
                                            <unit value="mm[Hg]"/>
                                        </xsl:when>
                                        <xsl:when
                                            test="translate(unit, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'bmi' and code = 'kg/m2'">
                                            <unit value="kg/m2"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <unit value="{unit}"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                                <xsl:if test="system">
                                    <system value="{system}"/>
                                </xsl:if>
                                <xsl:if test="code">
                                    <code value="{code}"/>
                                </xsl:if>
                            </valueQuantity>
                        </component>
                    </xsl:for-each>

                    <xsl:if test="./value/value_codeable_concept">
                        <valueCodeableConcept>
                            <xsl:variable name="vc" select="value/value_codeable_concept"/>
                            <xsl:if test="$vc/coding">
                                <coding>
                                    <xsl:variable name="vcod"
                                        select="value/value_codeable_concept/coding"/>
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
                    <xsl:if test="./value/value_string">
                        <valueString value="{./value/value_string}"/>
                    </xsl:if>
                    <xsl:if test="./value/value_boolean">
                        <valueBoolean value="{./value/value_boolean}"/>
                    </xsl:if>
                    <xsl:if test="./value/value_integer">
                        <valueInteger value="{./value/value_integer}"/>
                    </xsl:if>
                    <xsl:if test="./value/value_range/low or ./value/value_range/high">
                        <valueRange>
                            <xsl:if test="./value/value_range/low">
                                <low value="{./value/value_range/low}"/>
                            </xsl:if>
                            <xsl:if test="./value/value_range/high">
                                <high value="{./value/value_range/high}"/>
                            </xsl:if>
                        </valueRange>
                    </xsl:if>
                    <xsl:if test="./value/value_ratio/numerator or ./value/value_ratio/denominator">
                        <valueRatio>
                            <xsl:if test="./value/value_ratio/numerator">
                                <numerator value="{./value/value_ratio/numerator}"/>
                            </xsl:if>
                            <xsl:if test="./value/value_ratio/denominator">
                                <denominator value="{./value/value_ratio/denominator}"/>
                            </xsl:if>
                        </valueRatio>
                    </xsl:if>
                    <xsl:if test="./value/value_sampled_data">
                        <valueSampledData>
                            <origin>
                                <xsl:variable name="vo" select="./value/value_sampled_data/origin"/>

                                <xsl:if test="$vo/value">
                                    <value value="{$vo/value}"/>
                                </xsl:if>

                                <xsl:if test="$vo/unit">
                                    <unit value="{$vo/unit}"/>
                                </xsl:if>

                                <xsl:if test="$vo/system">
                                    <system value="{$vo/system}"/>
                                </xsl:if>

                                <xsl:if test="$vo/code">
                                    <code value="{$vo/code}"/>
                                </xsl:if>
                            </origin>
                            <xsl:if
                                test="./value/value_sampled_data/period/start or ./value/value_sampled_data/period/end">
                                <period>
                                    <xsl:if test="./value/value_sampled_data/period/start">
                                        <start value="{./value/value_sampled_data/period/start}"/>
                                    </xsl:if>
                                    <xsl:if test="./value/value_sampled_data/period/end">
                                        <end value="{./value/value_sampled_data/period/end}"/>
                                    </xsl:if>
                                </period>
                            </xsl:if>
                            <xsl:if test="./value/value_sampled_data/factor">
                                <factor value="{./value/value_sampled_data/factor}"/>
                            </xsl:if>
                            <xsl:if test="./value/value_sampled_data/lower_limit">
                                <lowerLimit value="{./value/value_sampled_data/lower_limit}"/>
                            </xsl:if>
                            <xsl:if test="./value/value_sampled_data/upper_limit">
                                <upperLimit value="{./value/value_sampled_data/upper_limit}"/>
                            </xsl:if>
                            <dimensions value="{./value/value_sampled_data/dimensions}"/>
                            <xsl:if test="./value/value_sampled_data/data">
                                <data value="{./value/value_sampled_data/data}"/>
                            </xsl:if>
                        </valueSampledData>
                    </xsl:if>
                    <xsl:if test="./value/value_time">
                        <valueTime value="{./value/value_time}"/>
                    </xsl:if>
                    <xsl:if test="./value/value_date_time">
                        <valueDateTime value="{./value/value_date_time}"/>
                    </xsl:if>
                    <xsl:if test="./value/value_period">
                        <valuePeriod>
                            <start value="{./value/value_period/start}"/>
                            <xsl:if test="./value/value_period/end">
                                <end value="{./value/value_period/end}"/>
                            </xsl:if>
                        </valuePeriod>
                    </xsl:if>
                    <xsl:if test="./data_absent_reason/code or ./data_absent_reason/system">
                        <dataAbsentReason>
                            <coding>
                                <xsl:if test="./data_absent_reason/system">
                                    <system value="{./data_absent_reason/system}"/>
                                </xsl:if>
                                <xsl:if test="./data_absent_reason/code">
                                    <code value="{./data_absent_reason/code}"/>
                                </xsl:if>
                            </coding>
                        </dataAbsentReason>
                    </xsl:if>
                    <!-- <specimen>
                        specimen type is required but not sure where it is in source <reference value="Specimen/specimen-example-serum"/><display value="Serum specimen"/>
                    </specimen> -->
                </Observation>
            </xsl:for-each>
            <xsl:call-template name="pediatric-weight-to-height"/>
            <xsl:call-template name="pediatric-head-circumference"/>
            <xsl:call-template name="pediatric-bmi"/>
            <xsl:call-template name="pulse_oximetry_observation"/>
        </Observations>
    </xsl:template>

    <xsl:template name="pediatric-weight-to-height">
        <!-- <xsl:variable name="PED" select="$CLIN/pediatric_weight_for_height_observations"/> -->
        <xsl:for-each select="$CLIN/pediatric_weight_for_height_observations">
            <xsl:variable name="PED" select="./pediatric_weight_for_height_observation"/>
            <Observation xmlns="http://hl7.org/fhir">
                <id>
                    <xsl:attribute name="value">
                        <!-- will need to check when we have good data-->
                        <xsl:value-of select="concat($CUSTOMER_PREFIX, '-', $PED/unique_identifier)"
                        />
                    </xsl:attribute>
                </id>

                <meta>
                    <source value="{$PARENTFILE_NAME}"/>
                    <profile
                        value="http://hl7.org/fhir/us/core/StructureDefinition/pediatric-weight-for-height"
                    />
                </meta>
                <status>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$PED/status"/>
                    </xsl:attribute>
                </status>
                <category>
                    <coding>
                        <system value="http://terminology.hl7.org/CodeSystem/observation-category"/>
                        <code value="vital-signs"/>
                        <display value="Vital Signs"/>
                    </coding>
                    <text value="Vital Signs"/>
                </category>
                <code>
                    <coding>
                        <system value="http://loinc.org"/>
                        <code value="77606-2"/>
                        <display value="Weight-for-length Per age and sex"/>
                    </coding>
                </code>
                <subject>
                    <reference>
                        <!-- Looks like it should be patient id -->
                        <xsl:choose>
                            <xsl:when test="$PAT/reference">
                                <xsl:variable name="inputString" select="$PAT/reference"/>
                                <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                                <xsl:variable name="parts_size" select="count($parts)"/>
                                <xsl:attribute name="value">
                                    <xsl:choose>
                                        <xsl:when test="$parts_size > 1">
                                            <xsl:value-of
                                                select="concat($parts[1], '/', $CUSTOMER_PREFIX, '-', $parts[2])"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                select="concat('Patient/', $CUSTOMER_PREFIX, '-', $parts[1])"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="concat('Patient/', $CUSTOMER_PREFIX, '-', $PAT/unique_person_id)"
                                    />
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </reference>
                    <xsl:if test="$PAT/names/name[1]/text">
                        <display value="{$PAT/names/name[1]/text}"/>
                    </xsl:if>
                </subject>
                <xsl:choose>
                    <xsl:when test="$PED/effective/effective_date_time">
                        <effectiveDateTime value="{$PED/effective/effective_date_time}"/>
                    </xsl:when>
                    <xsl:when test="$PED/effective/effective_period">
                        <effectivePeriod>
                            <start value="{$PED/effective/effective_period/start}"/>
                            <end value="{$PED/effective/effective_period/end}"/>
                        </effectivePeriod>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
                <valueQuantity>
                    <value value="{$PED/value_quantity/value}"/>
                    <comparator value="{$PED/value_quantity/comparator}"/>
                    <unit value="{$PED/value_quantity/unit}"/>
                    <system value="http://unitsofmeasure.org"/>
                    <code value="%"/>
                </valueQuantity>
            </Observation>
        </xsl:for-each>

    </xsl:template>
    <xsl:template name="pediatric-head-circumference">
        <!-- <xsl:variable name="PED" select="$CLIN/pediatric_weight_for_height_observations"/> -->
        <xsl:for-each select="$CLIN/pediatric_head_occipital_frontal_circumference_observations">
            <xsl:variable name="PED"
                select="./pediatric_head_occipital_frontal_circumference_observation"/>
            <Observation xmlns="http://hl7.org/fhir">
                <id>
                    <xsl:attribute name="value">
                        <!-- will need to check when we have good data-->
                        <xsl:value-of select="concat($CUSTOMER_PREFIX, '-', $PED/unique_identifier)"
                        />
                    </xsl:attribute>
                </id>

                <meta>
                    <source value="{$PARENTFILE_NAME}"/>
                    <profile
                        value="http://hl7.org/fhir/us/core/StructureDefinition/head-occipital-frontal-circumference-percentile"
                    />
                </meta>
                <status>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$PED/status"/>
                    </xsl:attribute>
                </status>
                <category>
                    <coding>
                        <system value="http://terminology.hl7.org/CodeSystem/observation-category"/>
                        <code value="vital-signs"/>
                        <display value="Vital Signs"/>
                    </coding>
                    <text value="Vital Signs"/>
                </category>
                <code>
                    <coding>
                        <system value="http://loinc.org"/>
                        <code value="8289-1"/>
                        <display value="Head Occipital-frontal circumference Percentile"/>
                    </coding>
                </code>
                <subject>
                    <reference>
                        <!-- Looks like it should be patient id -->
                        <xsl:choose>
                            <xsl:when test="$PAT/reference">
                                <xsl:variable name="inputString" select="$PAT/reference"/>
                                <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                                <xsl:variable name="parts_size" select="count($parts)"/>
                                <xsl:attribute name="value">
                                    <xsl:choose>
                                        <xsl:when test="$parts_size > 1">
                                            <xsl:value-of
                                                select="concat($parts[1], '/', $CUSTOMER_PREFIX, '-', $parts[2])"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                select="concat('Patient/', $CUSTOMER_PREFIX, '-', $parts[1])"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="concat('Patient/', $CUSTOMER_PREFIX, '-', $PAT/unique_person_id)"
                                    />
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </reference>
                    <xsl:if test="$PAT/names/name[1]/text">
                        <display value="{$PAT/names/name[1]/text}"/>
                    </xsl:if>
                </subject>
                <xsl:choose>
                    <xsl:when test="$PED/effective/effective_date_time">
                        <effectiveDateTime value="{$PED/effective/effective_date_time}"/>
                    </xsl:when>
                    <xsl:when test="$PED/effective/effective_period">
                        <effectivePeriod>
                            <start value="{$PED/effective/effective_period/start}"/>
                            <end value="{$PED/effective/effective_period/end}"/>
                        </effectivePeriod>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
                <valueQuantity>
                    <value value="{$PED/value_quantity/value}"/>
                    <comparator value="{$PED/value_quantity/comparator}"/>
                    <unit value="{$PED/value_quantity/unit}"/>
                    <system value="http://unitsofmeasure.org"/>
                    <code value="%"/>
                </valueQuantity>
            </Observation>
        </xsl:for-each>

    </xsl:template>
    <xsl:template name="pediatric-bmi">
        <!-- <xsl:variable name="PED" select="$CLIN/pediatric_weight_for_height_observations"/> -->
        <xsl:for-each select="$CLIN/pediatric_bmi_for_age_observations">
            <xsl:variable name="PED" select="./pediatric_bmi_for_age_observation"/>
            <Observation xmlns="http://hl7.org/fhir">
                <id>
                    <xsl:attribute name="value">
                        <!-- will need to check when we have good data-->
                        <xsl:value-of select="concat($CUSTOMER_PREFIX, '-', $PED/unique_identifier)"
                        />
                    </xsl:attribute>
                </id>

                <meta>
                    <source value="{$PARENTFILE_NAME}"/>
                    <profile
                        value="http://hl7.org/fhir/us/core/StructureDefinition/pediatric-bmi-for-age"
                    />
                </meta>
                <status>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$PED/status"/>
                    </xsl:attribute>
                </status>
                <category>
                    <coding>
                        <system value="http://terminology.hl7.org/CodeSystem/observation-category"/>
                        <code value="vital-signs"/>
                        <display value="Vital Signs"/>
                    </coding>
                    <text value="Vital Signs"/>
                </category>
                <code>
                    <coding>
                        <system value="http://loinc.org"/>
                        <code value="59576-9"/>
                        <display value="Body mass index (BMI) [Percentile] Per age and sex"/>
                    </coding>
                </code>
                <subject>
                    <reference>
                        <!-- Looks like it should be patient id -->
                        <xsl:choose>
                            <xsl:when test="$PAT/reference">
                                <xsl:variable name="inputString" select="$PAT/reference"/>
                                <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                                <xsl:variable name="parts_size" select="count($parts)"/>
                                <xsl:attribute name="value">
                                    <xsl:choose>
                                        <xsl:when test="$parts_size > 1">
                                            <xsl:value-of
                                                select="concat($parts[1], '/', $CUSTOMER_PREFIX, '-', $parts[2])"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                select="concat('Patient/', $CUSTOMER_PREFIX, '-', $parts[1])"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="concat('Patient/', $CUSTOMER_PREFIX, '-', $PAT/unique_person_id)"
                                    />
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </reference>
                    <xsl:if test="$PAT/names/name[1]/text">
                        <display value="{$PAT/names/name[1]/text}"/>
                    </xsl:if>
                </subject>
                <xsl:choose>
                    <xsl:when test="$PED/effective/effective_date_time">
                        <effectiveDateTime value="{$PED/effective/effective_date_time}"/>
                    </xsl:when>
                    <xsl:when test="$PED/effective/effective_period">
                        <effectivePeriod>
                            <start value="{$PED/effective/effective_period/start}"/>
                            <end value="{$PED/effective/effective_period/end}"/>
                        </effectivePeriod>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
                <valueQuantity>
                    <value value="{$PED/value_quantity/value}"/>
                    <comparator value="{$PED/value_quantity/comparator}"/>
                    <unit value="{$PED/value_quantity/unit}"/>
                    <system value="http://unitsofmeasure.org"/>
                    <code value="%"/>
                </valueQuantity>
            </Observation>
        </xsl:for-each>

    </xsl:template>
    <xsl:template name="pulse_oximetry_observation">
        <!-- <xsl:variable name="PED" select="$CLIN/pediatric_weight_for_height_observations"/> -->
        <xsl:for-each select="$CLIN/pulse_oximetry_observations">
            <xsl:variable name="O2" select="./pulse_oximetry_observation"/>
            <Observation xmlns="http://hl7.org/fhir">
                <id>
                    <xsl:attribute name="value">
                        <xsl:value-of select="concat($CUSTOMER_PREFIX, '-', $O2/unique_identifier)"
                        />
                    </xsl:attribute>
                </id>
                <meta>
                    <source value="{$PARENTFILE_NAME}"/>
                    <profile
                        value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-pulse-oximetry"
                    />
                </meta>
                <status>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$O2/status"/>
                    </xsl:attribute>
                </status>
                <category>
                    <coding>
                        <system value="http://terminology.hl7.org/CodeSystem/observation-category"/>
                        <code value="vital-signs"/>
                        <display value="Vital Signs"/>
                    </coding>
                    <text value="Vital Signs"/>
                </category>
                <code>
                    <coding>
                        <system value="http://loinc.org"/>
                        <code value="2708-6"/>
                        <display value="Oxygen saturation in Arterial blood"/>
                    </coding>
                    <coding>
                        <system value="http://loinc.org"/>
                        <code value="59408-5"/>
                        <display value="Oxygen saturation in Arterial blood by Pulse oximetry"/>
                    </coding>
                    <xsl:for-each
                        select="$O2/code/coding/coding_oxygen_sat_code | $O2/code/coding/coding_pulse_ox">
                        <xsl:if test="./code != '2708-6' and ./code != '59408-5'">
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
                                <xsl:if test="./version">
                                    <version>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./version"/>
                                        </xsl:attribute>
                                    </version>
                                </xsl:if>
                                <xsl:if test="./display">
                                    <display>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./display"/>
                                        </xsl:attribute>
                                    </display>
                                </xsl:if>
                                <xsl:if test="./userSelected">
                                    <userSelected>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="./userSelected"/>
                                        </xsl:attribute>
                                    </userSelected>
                                </xsl:if>
                            </coding>
                        </xsl:if>
                    </xsl:for-each>
                </code>
                <xsl:if test="$O2/code/text">
                    <text>
                        <xsl:attribute name="value">
                            <xsl:value-of select="$O2/code/text"/>
                        </xsl:attribute>
                    </text>
                </xsl:if>
                <subject>
                    <reference>
                        <!-- Looks like it should be patient id -->
                        <xsl:choose>
                            <xsl:when test="$PAT/reference">
                                <xsl:variable name="inputString" select="$PAT/reference"/>
                                <xsl:variable name="parts" select="tokenize($inputString, '/')"/>
                                <xsl:variable name="parts_size" select="count($parts)"/>
                                <xsl:attribute name="value">
                                    <xsl:choose>
                                        <xsl:when test="$parts_size > 1">
                                            <xsl:value-of
                                                select="concat($parts[1], '/', $CUSTOMER_PREFIX, '-', $parts[2])"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                select="concat('Patient/', $CUSTOMER_PREFIX, '-', $parts[1])"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="concat('Patient/', $CUSTOMER_PREFIX, '-', $PAT/unique_person_id)"
                                    />
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </reference>
                    <xsl:if test="$PAT/names/name[1]/text">
                        <display value="{$PAT/names/name[1]/text}"/>
                    </xsl:if>
                </subject>
                <xsl:choose>
                    <xsl:when test="$O2/effective/effective_date_time">
                        <effectiveDateTime value="{$O2/effective/effective_date_time}"/>
                    </xsl:when>
                    <xsl:when test="$O2/effective/effective_period">
                        <effectivePeriod>
                            <start value="{$O2/effective/effective_period/start}"/>
                            <xsl:if test="$O2/effective/effective_period/end">
                                <end value="{$O2/effective/effective_period/end}"/>
                            </xsl:if>
                        </effectivePeriod>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
                <xsl:if test="$O2/value_quantity">
                    <valueQuantity>
                        <value value="{$O2/value_quantity/value}"/>
                        <xsl:if test="$O2/value_quantity/comparator">
                            <comparator value="{$O2/value_quantity/comparator}"/>
                        </xsl:if>
                        <unit value="%O2"/>
                        <system value="http://unitsofmeasure.org"/>
                        <code value="%"/>
                    </valueQuantity>
                </xsl:if>
                <xsl:if test="./data_absent_reason/code or ./data_absent_reason/system">
                    <dataAbsentReason>
                        <coding>
                            <xsl:if test="./data_absent_reason/system">
                                <system value="{./data_absent_reason/system}"/>
                            </xsl:if>
                            <xsl:if test="./data_absent_reason/code">
                                <code value="{./data_absent_reason/code}"/>
                            </xsl:if>
                        </coding>
                    </dataAbsentReason>
                </xsl:if>
                <xsl:for-each select="$O2/component">
                    <component>
                        <xsl:if test="./component_flow_rate">
                            <code>
                                <coding>
                                    <system value="{./component_flow_rate/code/coding/system}"/>
                                    <code value="{./component_flow_rate/code/coding//code}"/>
                                </coding>
                            </code>
                            <xsl:if test="./value_quantity">
                                <valueQuantity>
                                    <value value="{./value_quantity/value}"/>
                                    <xsl:if test="./value_quantity/comparator">
                                        <comparator value="{./value_quantity/comparator}"/>
                                    </xsl:if>
                                    <unit value="liters/min"/>
                                    <system value="http://unitsofmeasure.org"/>
                                    <code value="L/min"/>
                                </valueQuantity>
                            </xsl:if>
                            <xsl:if test="./data_absent_reason/code or ./data_absent_reason/system">
                                <dataAbsentReason>
                                    <coding>
                                        <xsl:if test="./data_absent_reason/system">
                                            <system value="{./data_absent_reason/system}"/>
                                        </xsl:if>
                                        <xsl:if test="./data_absent_reason/code">
                                            <code value="{./data_absent_reason/code}"/>
                                        </xsl:if>
                                    </coding>
                                </dataAbsentReason>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="./component_concentration">
                            <code>
                                <coding>
                                    <system value="{./component_concentration/code/coding/system}"/>
                                    <code value="{./component_concentration/code/coding/code}"/>
                                </coding>
                            </code>
                            <xsl:if test="./value_quantity">
                                <valueQuantity>
                                    <value value="{./value_quantity/value}"/>
                                    <xsl:if test="./value_quantity/comparator">
                                        <comparator value="{./value_quantity/comparator}"/>
                                    </xsl:if>
                                    <unit value="%"/>
                                    <system value="http://unitsofmeasure.org"/>
                                    <code value="%"/>
                                </valueQuantity>
                            </xsl:if>
                            <xsl:if test="./data_absent_reason/code or ./data_absent_reason/system">
                                <dataAbsentReason>
                                    <coding>
                                        <xsl:if test="./data_absent_reason/system">
                                            <system value="{./data_absent_reason/system}"/>
                                        </xsl:if>
                                        <xsl:if test="./data_absent_reason/code">
                                            <code value="{./data_absent_reason/code}"/>
                                        </xsl:if>
                                    </coding>
                                </dataAbsentReason>
                            </xsl:if>
                        </xsl:if>
                    </component>
                </xsl:for-each>
            </Observation>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
