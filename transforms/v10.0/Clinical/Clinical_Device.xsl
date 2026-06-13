<xsl:stylesheet xpath-default-namespace="http://cocodata.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="PAT" select="/clinicals/clinical/patient"/>
    <xsl:variable name="Device" select="/clinicals/clinical/implantable_devices/implantable_device"/>
    <xsl:variable name="ORG" select="/clinicals/clinical/organizations/organization"/>
    <xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
    <xsl:variable name="PARENTFILE_NAME" select="clinicals/clinical/parentfile"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        
        <Devices>
            <xsl:for-each select="$Device">
                <Device xmlns="http://hl7.org/fhir">
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
                            value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-implantable-device|6.1.0"
                        />
                    </meta>
                    <udiCarrier>
                        <deviceIdentifier>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="./udi_carrier/device_identifier"/>
                            </xsl:attribute>
                        </deviceIdentifier>
                        <xsl:if test="./udi_carrier/carrier_aidc">
                            <carrierAIDC>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="./udi_carrier/carrier_aidc"/>
                                </xsl:attribute>
                            </carrierAIDC>
                        </xsl:if>
                        <xsl:if test="./udi_carrier/carrier_hrf">
                            <carrierHRF>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="./udi_carrier/carrier_hrf"/>
                                </xsl:attribute>
                            </carrierHRF>
                        </xsl:if>
                    </udiCarrier>
                    <xsl:if test="./distinct_identifier">
                        <distinctIdentifier>
                            <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="./distinct_identifier"/>
                                </xsl:attribute>
                        </distinctIdentifier>
                    </xsl:if>
                    <xsl:if test="./manufacture_date">
                        <manufactureDate>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="./manufacture_date"/>
                            </xsl:attribute>
                        </manufactureDate>
                    </xsl:if>
                    <xsl:if test="./expiration_date">
                        <expirationDate>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="./expiration_date"/>
                            </xsl:attribute>
                        </expirationDate>
                    </xsl:if>
                    <xsl:if test="./lot_number">
                        <lotNumber>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="./lot_number"/>
                            </xsl:attribute>
                        </lotNumber>
                    </xsl:if>
                    <xsl:if test="./serial_number">
                        <serialNumber>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="./serial_number"/>
                            </xsl:attribute>
                        </serialNumber>
                    </xsl:if>
                    <type>
                        <coding>
                            <system value="http://hl7.org/fhir/ValueSet/device-kind"/>
                            <code>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="./type/code"/>
                                </xsl:attribute>
                            </code>
                            
                            <display>
                                <xsl:attribute name="value">
                                    <xsl:value-of
                                        select="./type/display"/>
                                </xsl:attribute>
                            </display>
                        </coding>
                    </type>
                    <patient>
                        <reference>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="concat('Patient/',$CUSTOMER_PREFIX,'-',$PAT/unique_person_id)"/>
                            </xsl:attribute>
                        </reference>
                    </patient>
                </Device>
            </xsl:for-each>
        </Devices>
    </xsl:template>
</xsl:stylesheet>
