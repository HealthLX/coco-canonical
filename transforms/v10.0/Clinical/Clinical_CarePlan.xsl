<xsl:stylesheet xpath-default-namespace="http://cocodata.org" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://hl7.org/fhir">
    <xsl:preserve-space elements="*"/>
    <xsl:variable name="CP" select="/clinicals/clinical/care_plans/care_plan"/>
    <xsl:variable name="GOAL" select="/clinicals/clinical/goals/goal"/>
    <xsl:variable name="COND" select="/clinicals/clinical/conditions/condition"/>
    <xsl:variable name="TASK" select="/clinicals/clinical/tasks/task"/>
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="SUPPORTING_INFO" select="/clinicals/clinical/care_plan_observations/care_plan_observation"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        <CarePlans>
            <xsl:for-each select="$CP">
                <xsl:variable name="CP_ID" select="unique_identifier"/>
                <CarePlan>
                    <id>
                        <xsl:attribute name="value">
                            <xsl:value-of select="concat(/clinical/customername, '-', $CP_ID)"/>
                        </xsl:attribute>
                    </id>
                    <meta>
                        <source>
                            <xsl:attribute name="value">
                                <xsl:value-of select="/clinicals/clinical/parentfile"/>
                            </xsl:attribute>
                        </source>
                        <profile value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan"/>
                    </meta>
                    <text>
                        <status>
                            <xsl:attribute name="value">
                                <xsl:value-of select="text/status"/>
                            </xsl:attribute>
                        </status>
                        <div>
                            <xsl:attribute name="value">
                                <xsl:value-of select="text/div"/>                                
                            </xsl:attribute>
                        </div>
                    </text>
                    <status>
                        <xsl:attribute name="value">
                            <xsl:value-of select="status"/>
                        </xsl:attribute>
                    </status>
                    <intent>
                        <xsl:attribute name="value">
                            <xsl:value-of select="intent"/>
                        </xsl:attribute>
                    </intent>
                    <category>
                        <coding>
                            <system>
                                <!-- "category_assess_plan" is likely not a needed node but this is only for LKL so do we want them to change it so it doesn't mess with the next client that sends us care plan data?-->
                                <xsl:attribute name="value">
                                    <xsl:value-of select="category/category_assess_plan/coding/system"/>
                                </xsl:attribute>
                            </system>
                            <code>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="category/category_assess_plan/coding/code"/>
                                </xsl:attribute>
                            </code>
                        </coding>
                    </category>
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
                    <xsl:for-each select="$COND[care_plan_id=$CP_ID]">
                        <addresses>
                            <reference>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="concat('Condition/', $CUSTOMER_PREFIX, '-', replace(unique_identifier,'_',''))"/>
                                </xsl:attribute>
                            </reference>
                            <type>
                                <xsl:attribute name="value">
                                    <xsl:text>Condition</xsl:text>
                                </xsl:attribute>
                            </type>
                        </addresses>
                    </xsl:for-each>
                    <!-- supporting info -->
                    <xsl:for-each select="$SUPPORTING_INFO[care_plan_id=$CP_ID]">
                        <supportingInfo>
                            <reference>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="concat('Observation/', $CUSTOMER_PREFIX, '-', replace(unique_identifier,'_',''))"/>
                                </xsl:attribute>
                            </reference>
                        </supportingInfo>
                    </xsl:for-each>
                    <xsl:for-each select="$GOAL[care_plan_id=$CP_ID]">
                        <goal>
                            <reference>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="concat('Goal/', $CUSTOMER_PREFIX, '-', replace(unique_identifier,'_',''))"/>
                                </xsl:attribute>
                            </reference>
                        </goal>
                    </xsl:for-each>
                    <xsl:for-each select="$TASK[care_plan_id=$CP_ID]">
                        <activity>
                            <reference>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="concat('Task/', $CUSTOMER_PREFIX, '-', replace(unique_identifier,'_',''))"/>
                                </xsl:attribute>
                            </reference>
                        </activity>
                    </xsl:for-each>
                </CarePlan>
            </xsl:for-each>
        </CarePlans>
    </xsl:template>
</xsl:stylesheet>
