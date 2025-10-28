<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://hl7.org/fhir"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <xsl:variable name="PTT_MEMBER_DEMOGRAPHICS" select="member"/>
        <xsl:variable name="PTT_CUSTOMER_PREFIX" select="$PTT_MEMBER_DEMOGRAPHICS/customername"/>
        <xsl:variable name="PTT_text">
            <xsl:choose>
                <xsl:when test="$PTT_MEMBER_DEMOGRAPHICS/smoking_status = '449868002'">
                    <xsl:value-of select="'Current every day smoker'"/>
                </xsl:when>
                <xsl:when test="$PTT_MEMBER_DEMOGRAPHICS/smoking_status = '428041000124106'">
                    <xsl:value-of select="'Current some day smoker'"/>
                </xsl:when>
                <xsl:when test="$PTT_MEMBER_DEMOGRAPHICS/smoking_status = '8517006'">
                    <xsl:value-of select="'Former smoker'"/>
                </xsl:when>
                <xsl:when test="$PTT_MEMBER_DEMOGRAPHICS/smoking_status = '266919005'">
                    <xsl:value-of select="'Never smoker'"/>
                </xsl:when>
                <xsl:when test="$PTT_MEMBER_DEMOGRAPHICS/smoking_status = '77176002'">
                    <xsl:value-of select="'Smoker - current status unknown'"/>
                </xsl:when>
                <xsl:when test="$PTT_MEMBER_DEMOGRAPHICS/smoking_status = '266927001'">
                    <xsl:value-of select="'Unknown if ever smoked'"/>
                </xsl:when>
                <xsl:when test="$PTT_MEMBER_DEMOGRAPHICS/smoking_status = '428071000124103'">
                    <xsl:value-of select="'Current Heavy tobacco smoker'"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Do your else stuff -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <Observation xmlns="http://hl7.org/fhir">
            <id>
                <xsl:attribute name="value">
                    <!-- <xsl:value-of select="$PTT_MEMBER_DEMOGRAPHICS/member_id"/> -->
                    <xsl:value-of
                        select="concat($PTT_CUSTOMER_PREFIX, '-', $PTT_MEMBER_DEMOGRAPHICS/member_id, '-smoke')"
                    />
                </xsl:attribute>
            </id>
            <meta>
                <xsl:variable name="EOB_PARENTFILE_NAME" select="$PTT_MEMBER_DEMOGRAPHICS/parentfile"/>
                <source>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$EOB_PARENTFILE_NAME"/>
                    </xsl:attribute>
                </source>
            </meta>
           <identifier>
                <xsl:attribute name="value">
                    <!-- <xsl:value-of select="$PTT_MEMBER_DEMOGRAPHICS/member_id"/> -->
                    <xsl:value-of
                        select="concat($PTT_CUSTOMER_PREFIX, '-', $PTT_MEMBER_DEMOGRAPHICS/member_id, '-smoke')"
                    />
                </xsl:attribute>
            </identifier>
            <status value="final"/>
            <category>
                <coding>
                    <system value="http://terminology.hl7.org/CodeSystem/observation-category"/>
                    <code value="social-history"/>
                    <display value="Social History"/>
                </coding>
                <text value="Social History"/>
            </category>
            <code>
                <coding>
                    <system value="http://loinc.org"/>
                    <code value="72166-2"/>
                    <display value="Tobacco smoking status"/>
                </coding>
            </code>
            <!--   <subject>
                <reference value="Patient/example"/>
                <display value="Amy Shaw"/>
            </subject>
            <effectiveDateTime value="2016-03-18T05:27:04Z"/>
            <valueCodeableConcept>
                <coding>
                    <system value="http://snomed.info/sct"/>
                    <version value="http://snomed.info/sct/731000124108"/>
                    <code value="428041000124106"/>
                </coding>
                <text value="Current some day smoker"/>
            </valueCodeableConcept>
        </Observation>-->
            <subject>
                <xsl:variable name="PTT_beneficiary" select="$PTT_MEMBER_DEMOGRAPHICS/unique_person_ids/unique_person_id"/>
                <reference>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="concat('Patient/', $PTT_CUSTOMER_PREFIX, '-', $PTT_beneficiary)"
                        />
                    </xsl:attribute>
                </reference>
                <display>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="$PTT_MEMBER_DEMOGRAPHICS/member_id"
                        />
                    </xsl:attribute>
                </display>
            </subject>
            <!--          <performer> 
                <xsl:variable name="PTT_Performer" select="$PTT_MEMBER_DEMOGRAPHICS/unique_record_identifier"/>
               
                <reference>
                    <xsl:attribute name="value">
                        <xsl:value-of select="concat('patient/',$PTT_Performer)"/>
                    </xsl:attribute>
                </reference> 
                <reference value="Practitioner/f202"/> 
                <display value="Luigi Maas"/> 
            </performer>
    need feedback FMC3
  -->

            <effectiveDateTime>
                <xsl:attribute name="value">
                    <xsl:value-of
                        select="$PTT_MEMBER_DEMOGRAPHICS/health_coverage/coverage_period/start"/>
                </xsl:attribute>
            </effectiveDateTime>
            <valueCodeableConcept>
                <coding>
                    <system value="http://snomed.info/sct"/>
                    <version value="http://snomed.info/sct/731000124108"/>
                    <!--      Logic here 
                    449868002 = Current every day smoker, 
                    428041000124106 = Current some day smoker, 
                    8517006 = Former smoker, 
                    266919005 = Never smoker, 
                    77176002 = Smoker - current status unknown, 
                    266927001 = Unknown if ever smoked, 
                    428071000124103 = Current Heavy tobacco smoker, 
                    Logic here -->
                    <xsl:variable name="PTT_code" select="$PTT_MEMBER_DEMOGRAPHICS/smoking_status"/>


                    <code>
                        <xsl:attribute name="value">
                            <xsl:value-of select="$PTT_code"/>
                        </xsl:attribute>
                    </code>
                </coding>
                <text>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$PTT_text"/>
                    </xsl:attribute>
                </text>
            </valueCodeableConcept>
        </Observation>
    </xsl:template>
</xsl:stylesheet>
