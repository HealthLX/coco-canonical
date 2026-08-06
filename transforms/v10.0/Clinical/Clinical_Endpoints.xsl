<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="Endpoint"
        select="/clinicals/clinical/practitioners_roles/practitioner_role/endpoints"/>
    <xsl:variable name="ORG" select="/clinicals/clinical/organizations/organization"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">

        <Endpoints>
            <xsl:for-each select="$Endpoint">
                <Endpoint xmlns="http://hl7.org/fhir">
                    <xsl:if test="./identifier">
                        <identifier>
                            <type>
                                <coding>
                                    
                                    <code>
                                        <xsl:attribute name="value">
                                            
                                            <xsl:value-of select="./identifier/type"/>
                                        </xsl:attribute>
                                    </code>
                                </coding>
                            </type>
                        
                            <value>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="./identifier/value"/>
                                </xsl:attribute>
                            </value>
                        </identifier>
                    </xsl:if>
                    <status>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./status"/>
                        </xsl:attribute>
                    </status>
                    <connectionType>
                        <system
                            value="http://terminology.hl7.org/CodeSystem/endpoint-connection-type"/>
                        <code>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./connectionType/code"/>
                            </xsl:attribute>
                        </code>
                    </connectionType>
                    <xsl:if test="./name">
                        <name>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./name"/>
                            </xsl:attribute>
                        </name>
                    </xsl:if>
                    <xsl:if test="./managing_organization">
                        <managingOrganization>
                            <reference>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="concat('Organization/', $CUSTOMER_PREFIX, '-', ./managing_organization/npi)"
                                    />
                                </xsl:attribute>
                            </reference>
                        </managingOrganization>
                    </xsl:if>
                    <xsl:if test="./contacts/contact">

                        <contact>
                            <xsl:for-each select="./contacts/contact">

                                <system>
                                    <!-- ?? 0..1 value="[code]"phone | fax | email | pager | url | sms | other -->
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./system"/>
                                    </xsl:attribute>
                                </system>
                                <value>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./value"/>
                                    </xsl:attribute>
                                </value>
                                <use>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="./use"/>
                                    </xsl:attribute>
                                </use>
                                <rank>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="position()"/>
                                    </xsl:attribute>
                                </rank>
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

                            </xsl:for-each>
                        </contact>

                    </xsl:if>
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
                    <payloadType>
                        <!-- 0..* CodeableConcept Kind of organization <xsl:attribute name="value"> <xsl:value-of select="$POG_PROVIDER_DEMOGRAPHIC/type" /> </xsl:attribute> -->
                        <coding>
                            <xsl:choose>
                                <xsl:when test="./payload_type/system">
                                    <system value="{./payload_type/system}"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <system value="http://terminology.hl7.org/CodeSystem/endpoint-payload-type"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <code value="{./payload_type/code}"/>
                        </coding>
                    </payloadType>
                    <payloadMimeType>
                        <code value="{./payload_mime_type/code}"/>
                    </payloadMimeType>
                    <address>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./address"/>
                        </xsl:attribute>
                    </address>
                   <xsl:for-each select="./header">
                       <header>
                           <xsl:attribute name="value">
                               <xsl:value-of select="."/>
                           </xsl:attribute>
                       </header>
                   </xsl:for-each>
                </Endpoint>
            </xsl:for-each>
        </Endpoints>
    </xsl:template>
</xsl:stylesheet>
