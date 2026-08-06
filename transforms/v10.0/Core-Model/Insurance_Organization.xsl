<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://hl7.org/fhir"
    exclude-result-prefixes="xs" version="2.0">
    
    <xsl:variable name="POG_INSURANCE" select="insurance_plan"/>
   
   
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        <xsl:variable name="POG_CUSTOMER_PREFIX" select="$POG_INSURANCE/customername"/>
       
    <Organizations>
            <!-- Network Organization  -->
        <xsl:for-each select="$POG_INSURANCE/networks/network">
            
            <xsl:variable name="POG_NETWORKID" select="./network_id"/>
            <Organization xmlns="http://hl7.org/fhir">
           <id>
                <xsl:attribute name="value">
                    <xsl:value-of
                        select="concat($POG_CUSTOMER_PREFIX, '-',$POG_NETWORKID)"/>
                </xsl:attribute>
            </id>
            <meta>
                <xsl:call-template name="pog_meta_security_organization"/>
            </meta>
            <identifier>
                <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                <system>
                    <xsl:attribute name="value">
                        <xsl:value-of select="concat('https://data.healthlx.com/', $POG_CUSTOMER_PREFIX,'-NetworkID')"
                        />
                    </xsl:attribute>                           
                </system>
                <value>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="$POG_NETWORKID"/>
                    </xsl:attribute>
                </value>
            </identifier>
            
            <active>
                <!--  value="[boolean]"0..1 Whether the organization's record is still in active use -->
                
                <xsl:choose>
                    <xsl:when test="$POG_INSURANCE/status= 'active'">
                        <xsl:attribute name="value">
                            <xsl:value-of select="'true'"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="value">
                            <xsl:value-of select="'false'"/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                
                
            </active>
            
                <type>
                    <coding>
                        <system
                            value="http://hl7.org/fhir/us/davinci-pdex-plan-net/CodeSystem/OrgTypeCS"/>
                        <code value="ntwk"/>
                        <display value="Network"/>
                    </coding>
                    
                </type>
            <name>
               
                    <xsl:attribute name="value">
                        <xsl:value-of select="./name"/>
                    </xsl:attribute>
                
            </name>
            <!-- value="[string]"?? 0..1 Name used for the organization -->
            <alias/>
            <!--  value="[string]"0..* A list of alternate names that the organization is known as, or was known as in the past -->
            
            <!--<xsl:call-template name="pog_telcom_provider_organization"/>-->
            
            <!-- ?? 0..* Address An address for the organization -->
            
            <!--<xsl:call-template name="pog_address_provider_organization"/>-->
            
            <partOf><!-- 0..1 Reference(Organization) The organization of which this organization forms a part -->
              
            </partOf>
            
            <code><!-- 1..1 CodeableConcept Coded representation of the qualification -->
            </code>
            <endpoint><!-- 0..* Reference(Endpoint) Technical endpoints providing access to services operated for the organization --></endpoint>
         </Organization>
        </xsl:for-each>
        </Organizations>
        
        
    </xsl:template>

    <xsl:template name="pog_meta_security_organization">
        <meta>
            <xsl:variable name="EOB_PARENTFILE_NAME" select="$POG_INSURANCE/parentfile"/>
            <source>
                <xsl:attribute name="value">
                    <xsl:value-of select="$EOB_PARENTFILE_NAME"/>
                </xsl:attribute>
            </source>
        </meta>
    </xsl:template>
    
    
    
    
</xsl:stylesheet>
