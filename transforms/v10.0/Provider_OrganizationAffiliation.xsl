<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://hl7.org/fhir"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:variable name="POG_PROVIDER" select="provider"/>
    <xsl:variable name="POG_PROVIDER_DEMOGRAPHIC"
        select="$POG_PROVIDER/providing_organization"/>
    <xsl:variable name="POG_PROVIDER_LOCATIONS"
        select="$POG_PROVIDER/providing_organization/addresses"/>
    <xsl:variable name="POG_CUSTOMER_PREFIX" select="$POG_PROVIDER/customername"/>
    <xsl:variable name="POG_CLIA" select="$POG_PROVIDER_DEMOGRAPHIC/clia"/>
    <xsl:variable name="POG_NPI" select="$POG_PROVIDER_DEMOGRAPHIC/npi"/>
    <xsl:variable name="POG_UNIQUE_ID" select="$POG_PROVIDER_DEMOGRAPHIC/unique_identifier"/>
    

    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="*">
        <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC">
            <xsl:variable name="POG_CLIA" select="./clia"/>
            <xsl:variable name="POG_NPI_SINGLE" select="./npi[1]"/>
            <xsl:variable name="POG_UNIQUE_ID" select="./unique_identifier"/>
            
            <OrganizationAffiliation xmlns="http://hl7.org/fhir">
                
            <xsl:variable name="CODE">
                <xsl:choose>
                    <xsl:when test="$POG_UNIQUE_ID">
                        <xsl:value-of select="./unique_identifier"/>
                    </xsl:when>
                    <xsl:when test="$POG_NPI">
                        <xsl:value-of select="./npi"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="./clia"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- from Resource: id, meta, implicitRules, and language -->
            <xsl:call-template name="resource_id">
                <xsl:with-param name="CTX" select="."/>
            </xsl:call-template>
           <!-- 0..* Identifier An identifier for the person as this agent -->
            <xsl:call-template name="pog_meta_security_organization"/>
            
                <xsl:call-template name="resource_identifier">
                    <xsl:with-param name="CTX" select="."/>
                </xsl:call-template>
          
            <!-- from DomainResource: text, contained, extension, and modifierExtension -->
           
           <active>
                <!--  value="[boolean]"0..1 Whether the organization's record is still in active use -->
                <xsl:attribute name="value">
                    <xsl:value-of select="./is_active"/>
                </xsl:attribute>
            </active>
            <period><!-- 0..1 Period The period during which the participatingOrganization is affiliated with the primary organization --></period>
            <organization>
                <!-- 0..1 Reference(Organization) Organization where the role is available -->
                
                <xsl:variable name="CODE">
                    <xsl:choose>
                        <xsl:when test="$POG_UNIQUE_ID">
                            <xsl:value-of select="./unique_identifier"/>
                        </xsl:when>
                        <xsl:when test="$POG_NPI">
                            <xsl:value-of select="./npi"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="./clia"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <reference>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', $CODE)"/>
                    </xsl:attribute>

                </reference>
                <display>
                    <xsl:attribute name="value">
                        <xsl:value-of select="./name"/>
                    </xsl:attribute>
                </display>
            </organization>
            <participatingOrganization><!-- 0..1 Reference(Organization) Organization that provides/performs the role (e.g. providing services or is a member of) --></participatingOrganization>

            <!-- 0..* Reference(Organization) Health insurance provider network in which the participatingOrganization provides the role's services (if defined) at the indicated locations (if defined) -->
            <xsl:for-each select="./networks/network">
                <network>
                    <reference>
                        <xsl:attribute name="value">

                            <xsl:value-of
                                select="concat('Organization/', $POG_CUSTOMER_PREFIX, '-', ./network_id)"
                            />
                        </xsl:attribute>
                    </reference>
                    <display>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./name"/>
                        </xsl:attribute>
                    </display>
                </network>
            </xsl:for-each>

            <xsl:for-each select="./codes/code">
                <xsl:element name="code">
                    <xsl:if test="system or code or display">
                        <xsl:element name="coding">
                            <xsl:if test="system">
                                <xsl:element name="system">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="system"/>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="code">
                                <xsl:element name="code">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="code"/>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="display">
                                <xsl:element name="display">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="display"/>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                        </xsl:element>    
                    </xsl:if>
                    <xsl:if test="coding">
                        <xsl:element name="coding">
                            <xsl:if test="coding/system">
                                <xsl:element name="system">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="coding/system"/>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="coding/code">
                                <xsl:element name="code">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="coding/code"/>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="coding/display">
                                <xsl:element name="display">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="coding/display"/>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                        </xsl:element>    
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="text">
                            <xsl:element name="text">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="text"/>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="coding">
                                    <xsl:if test="coding/display">
                                        <xsl:element name="text">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="coding/display"/>
                                            </xsl:attribute></xsl:element>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="display">
                                        <xsl:element name="text">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="display"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/specialties/specialty">
                <xsl:element name="specialty">
                    <xsl:choose>
                        <xsl:when test="system or code or display">
                            <xsl:element name="coding">
                                <xsl:if test="system">
                                    <xsl:element name="system">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="system"/>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="code">
                                    <xsl:element name="code">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="code"/>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="display">
                                    <xsl:element name="display">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="display"/>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="coding">
                            <xsl:element name="coding">
                                <xsl:if test="coding/system">
                                    <xsl:element name="system">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="coding/system"/>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="coding/code">
                                    <xsl:element name="code">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="coding/code"/>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="coding/display">
                                    <xsl:element name="display">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="coding/display"/>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="coding">
                                <xsl:element name="code">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="."/>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="text">
                            <xsl:element name="text">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="text"/>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="coding">
                                    <xsl:if test="coding/display">
                                        <xsl:element name="text">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="coding/display"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="display">
                                        <xsl:element name="text">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="display"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:for-each>
            <!-- 0..* Reference(Location) The location(s) at which the role occurs -->
            <xsl:for-each select="./addresses/address">
                <xsl:if test="./type != 'postal'">
                    <location>
                        <reference>
                         <xsl:choose>
                             <xsl:when test="./hash and ./type != 'postal'">
                                 <xsl:attribute name="value">
                                     
                                     <xsl:value-of
                                         select="concat('Location/', $POG_CUSTOMER_PREFIX, '-', ./hash)"
                                     />
                                 </xsl:attribute>
                             </xsl:when>
                             <xsl:when test="./type != 'postal'">
                                 
                                     <xsl:attribute name="value">
                                         
                                         <xsl:value-of
                                             select="concat('Location/', $POG_CUSTOMER_PREFIX, '-', $CODE, ./use, ./type)"
                                         />
                                     </xsl:attribute>
                                 
                             </xsl:when>
                         </xsl:choose>
                        </reference>
                        <display>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./text"/>
                            </xsl:attribute>
                        </display>
                    </location>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/locations/location/address">
                <xsl:if test="./type != 'postal'">
                    <location>
                        <reference>
                            <xsl:choose>
                                <xsl:when test="./hash and ./type != 'postal'">
                                    <xsl:attribute name="value">
                                        
                                        <xsl:value-of
                                            select="concat('Location/', $POG_CUSTOMER_PREFIX, '-', ./hash)"
                                        />
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:when test="./type != 'postal'">
                                    
                                    <xsl:attribute name="value">
                                        
                                        <xsl:value-of
                                            select="concat('Location/', $POG_CUSTOMER_PREFIX, '-', $CODE, ./use, ./type)"
                                        />
                                    </xsl:attribute>
                                    
                                </xsl:when>
                            </xsl:choose>
                        </reference>
                        <display>
                            <xsl:attribute name="value">
                                <xsl:value-of select="./text"/>
                            </xsl:attribute>
                        </display>
                    </location>
                </xsl:if>
            </xsl:for-each>
            
           <!-- <healthcareService><!-\- 0..* Reference(HealthcareService) Healthcare services provided through the role -\->
                <reference>
                    <xsl:attribute name="value">
                        
                        <xsl:value-of
                            select="concat('HealthcareService/', $POG_CUSTOMER_PREFIX, '-', $POG_CLIA)"
                        />
                    </xsl:attribute>
                </reference>
            </healthcareService>-->
            <xsl:for-each select="$POG_PROVIDER_DEMOGRAPHIC/telecoms/telecom">

                <telecom>
                    <!-- 0..* ContactPoint Contact details at the participatingOrganization relevant to this Affiliation -->

                    <use>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./use"/>
                        </xsl:attribute>
                    </use>
                    <value>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./value"/>
                        </xsl:attribute>
                    </value>
                    <system>
                        <xsl:attribute name="value">
                            <xsl:value-of select="./system"/>
                        </xsl:attribute>
                    </system>

                </telecom>

            </xsl:for-each>

            <endpoint><!-- 0..* Reference(Endpoint) Technical endpoints providing access to services operated for this role --></endpoint>
        </OrganizationAffiliation>

        </xsl:for-each>
    </xsl:template>

    <xsl:template name="pog_meta_security_organization">
        <meta>
            <xsl:variable name="EOB_PARENTFILE_NAME" select="$POG_PROVIDER/parentfile"/>
            <source>
                <xsl:attribute name="value">
                    <xsl:value-of select="$EOB_PARENTFILE_NAME"/>
                </xsl:attribute>
            </source>
        </meta>
    </xsl:template>
    
    <xsl:template name="resource_identifier">
        <xsl:param name="CTX"/>
        
        <xsl:if test="$POG_NPI">
            <identifier>
                <type>
                    <coding>
                        <!-- ?? 0..* Identifier Identifies this organization  across multiple systems -->
                        <system>
                            <xsl:attribute name="value">
                                <xsl:value-of
                                    select="'http://terminology.hl7.org/CodeSystem/v2-0203'"/>
                            </xsl:attribute>
                            
                        </system>
                        <code>
                            <xsl:attribute name="value">
                                <xsl:value-of select="'NPI'"/>
                            </xsl:attribute>
                        </code>
                        <display>
                            <xsl:attribute name="value">
                                <xsl:value-of select="'National Provider Identifier'"/>
                            </xsl:attribute>
                        </display>
                        
                    </coding>
                    
                </type>
                
                <system>
                    <xsl:attribute name="value">
                        <xsl:value-of select="'http://hl7.org/fhir/sid/us-npi'"/>
                    </xsl:attribute>
                </system>
                <value>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$CTX/npi"/>
                    </xsl:attribute>
                </value>
                
            </identifier>
        </xsl:if>
        <xsl:if test="$POG_UNIQUE_ID">
            
            <identifier>
                <system>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="concat('https://data.healthlx.com/', 'ID', '-', $POG_CUSTOMER_PREFIX)"
                        />
                    </xsl:attribute>
                </system>
                <value>
                    
                    <xsl:attribute name="value">
                        <xsl:value-of select="concat($POG_CUSTOMER_PREFIX, '-', $CTX/unique_identifier)"/>
                    </xsl:attribute>
                </value>
            </identifier>
        </xsl:if>
        <xsl:if test="$POG_PROVIDER/practitioner/tax">
            
            <identifier>
                <value>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="concat($POG_CUSTOMER_PREFIX, '-', $POG_PROVIDER/practitioner/tax)"
                        />
                    </xsl:attribute>
                </value>
            </identifier>
        </xsl:if>
        <xsl:if test="$POG_CLIA">
            <xsl:for-each select="$CTX/clia">
                <identifier>
                    <system>
                        <xsl:attribute name="value">
                            <xsl:value-of
                                select="'http://terminology.hl7.org/NamingSystem/CLIA'"
                            />
                        </xsl:attribute>
                    </system>
                    <value>
                        
                        <xsl:attribute name="value">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </value>
                </identifier>
            </xsl:for-each>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template name="resource_id">
        <xsl:param name="CTX"/>
        
        <xsl:variable name="CODE">
            <!-- taken out to account for many clias, now a concat unique id + npi + clia
            <xsl:choose>
                <xsl:when test="$POG_UNIQUE_ID">
                    <xsl:value-of select="$CTX/unique_identifier"/>
                </xsl:when>
                <xsl:when test="$POG_NPI">
                    <xsl:value-of select="$CTX/npi"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$CTX/clia"/>
                </xsl:otherwise>
            </xsl:choose> -->
            <xsl:value-of select="concat($CTX/unique_identifier,$CTX/npi,$CTX/clia)"/>
        </xsl:variable>
        <id>
            <xsl:attribute name="value">
                <xsl:value-of select="concat($POG_CUSTOMER_PREFIX, '-', $CODE)"	/>
            </xsl:attribute>
        </id>
        
         
    </xsl:template>

</xsl:stylesheet>
