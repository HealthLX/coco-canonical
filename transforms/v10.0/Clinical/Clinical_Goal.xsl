<xsl:stylesheet xpath-default-namespace="http://cocodata.org" exclude-result-prefixes="xs" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="GOAL" select="/clinicals/clinical/goals/goal"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:output indent="yes" method="xml"/>
    <xsl:template match="*">
        <Goals>
            <xsl:for-each select="$GOAL">
                <Goal xmlns="http://hl7.org/fhir">
                    <id>
                        <xsl:attribute name="value">
                            <!-- will need to check when we have good data-->
                            <xsl:value-of
                                select="concat($CUSTOMER_PREFIX, '-', replace(./unique_identifier, '_', ''))"
                            />
                        </xsl:attribute>
                    </id>
                    <meta>
                        <source>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$PARENTFILE_NAME"/>
                            </xsl:attribute>
                        </source>
                        <profile
                            value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-goal"/>
                    </meta>
                    <lifecycleStatus>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./lifecycle_status"/>
                        </xsl:attribute>
                    </lifecycleStatus>
                    <xsl:if test="./description">
                        <description>
                            <xsl:if
                                test="./description/system or ./description/code or ./description/version or ./description/display">
                                <coding>
                                    <xsl:if test="./description/system">
                                        <system>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./description/system"/>
                                            </xsl:attribute>
                                        </system>
                                    </xsl:if>
                                    <xsl:if test="./description/version">
                                        <version>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./description/version"/>
                                            </xsl:attribute>
                                        </version>
                                    </xsl:if>
                                    <xsl:if test="./description/code">
                                        <code>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./description/code"/>
                                            </xsl:attribute>
                                        </code>
                                    </xsl:if>
                                    <xsl:if test="./description/display">
                                        <display>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="./description/display"/>
                                            </xsl:attribute>
                                        </display>
                                    </xsl:if>
                                </coding>
                            </xsl:if>
                            <xsl:if test="./description/text">
                                <text>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./description/text"/>
                                    </xsl:attribute>
                                </text>
                            </xsl:if>
                        </description>
                    </xsl:if>
                    <subject>
                        <reference>

                            <xsl:choose>
                                <xsl:when test="substring-after(/clinical/patient/reference,'/')">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="concat('Patient/', $CUSTOMER_PREFIX, '-',substring-after(/clinical/patient/reference,'/'))"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:when test="string-length(/clinical/patient/reference)&gt;0">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="concat('Patient/', $CUSTOMER_PREFIX, '-',/clinical/patient/reference)"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="value">
                                        <xsl:value-of
                                            select="concat('Patient/', $CUSTOMER_PREFIX, '-', $PAT/member_id)"
                                        />
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </reference>
                        <display>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$PAT/names/name[1]/text"/>
                            </xsl:attribute>
                        </display>
                    </subject>
                    <xsl:if test="./start_date">
                        <startDate>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./start_date"/>
                            </xsl:attribute>
                        </startDate>
                    </xsl:if>
                    <xsl:if test="./target/due_date">
                        <target>
                            <dueDate>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./target/due_date"/>
                                </xsl:attribute>
                            </dueDate>
                        </target>
                    </xsl:if>
                </Goal>
            </xsl:for-each>
        </Goals>
    </xsl:template>
</xsl:stylesheet>
