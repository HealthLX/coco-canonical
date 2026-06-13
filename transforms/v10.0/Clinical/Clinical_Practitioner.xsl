<xsl:stylesheet xpath-default-namespace="http://cocodata.org" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://hl7.org/fhir">
	<xsl:preserve-space elements="*"/>
	<xsl:variable name="PRAC" select="/clinicals/clinical/practitioners/practitioner"/>
	<xsl:variable name="PRACROLE_PRAC"
		select="/clinicals/clinical/practitioners_roles/practitioner_role/practitioner"/>
	<xsl:variable name="DOCREF_PRAC"
		select="/clinicals/clinical/document_references/document_reference/author/practitioner"/>
	<xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
	<xsl:output method="xml" omit-xml-declaration="no" indent="yes"/>
	<!-- Main resource template structure -->
	<xsl:template match="*">


		<Practitioners>
			<xsl:for-each-group select="$PRAC | $PRACROLE_PRAC | $DOCREF_PRAC"
				group-by="normalize-space((./practitioner_details/npi | ./npi)[1])">
				<Practitioner>
					<!-- <xsl:call-template name="resource_meta"/> James:This node is not in sample output...-->
					<id>
						<xsl:attribute name="value">
							<xsl:choose>
								<xsl:when test="./practitioner_details/npi">
									<xsl:value-of
										select="concat($CUSTOMER_PREFIX, '-', ./practitioner_details/npi)"
									/>
								</xsl:when>
								<xsl:when test="./npi">
									<xsl:value-of select="concat($CUSTOMER_PREFIX, '-', ./npi)"/>
								</xsl:when>
							</xsl:choose>
						</xsl:attribute>
					</id>
					<!-- 0..* Identifier An identifier for the person as this agent -->
					<xsl:call-template name="resource_identifier"/>
					<!-- 0..1 Whether this practitioner's record is in active use <active> <xsl:attribute name="value"> <xsl:value-of select="/practitioner/is_active"/> </xsl:attribute> </active>-->
					<!-- 0..* HumanName The name(s) associated with the practitioner -->
					<xsl:call-template name="Practitioner_name"/>
					<!-- 0..* ContactPoint A contact detail for the practitioner (that apply to all roles) -->
					<xsl:call-template name="practitioner_telecom"/>
					<xsl:if test="practitioner_details/gender">
						<!-- 0..1 male | female | other | unknown -->
						<gender>
							<!-- Not in source -->
							<xsl:attribute name="value">
								<xsl:value-of select="./practitioner_details/gender"/>
							</xsl:attribute>
						</gender>
					</xsl:if>
					<xsl:if test="practitioner_details/birthDate">
						<birthDate>
							<!-- Not in source -->
							<xsl:attribute name="value">
								<xsl:value-of select="./practitioner_details/birthDate"/>
							</xsl:attribute>
						</birthDate>
					</xsl:if>
					<xsl:call-template name="Practitioner_address"/>
					<!-- ******************** Everthing that can be done without real data should be done. *************************** -->
					<!-- ********* Old comment: MAPPINGS NOT IMPLEMENTED below this comment ********* -->
					<!-- 0..1 The date on which the practitioner was born -->
					<!-- <birthDate> <xsl:attribute name="value"> <xsl:value-of select="/practitioner/birthDate"/> </xsl:attribute> </birthDate> -->
					<!-- 0..* Attachment Image of the person -->
					<!-- <photo> <xsl:call-template name="Practitioner_photo"/> </photo> -->
					<!-- 0..* Certification, licenses, or training pertaining to the provision of care -->
					<!-- <qualification> -->
					<!-- 0..* Identifier An identifier for this qualification for the practitioner -->
					<!-- <identifier> <xsl:call-template name="Practitioner_qualification_identifier"/> </identifier> -->
					<!-- 1..1 CodeableConcept Coded representation of the qualification -->
					<!-- <code> <xsl:call-template name="Practitioner_qualification_code"/> </code> -->
					<!-- 0..1 Period Period during which the qualification is valid -->
					<!-- <period> <xsl:call-template name="Practitioner_qualification_period"/> </period> -->
					<!-- 0..1 Reference(Organization) Organization that regulates and issues the qualification -->
					<!-- <issuer> -->
					<!-- <xsl:if test="practitioner/qualification_issuer != ''"> <reference> <xsl:attribute name="value"> <xsl:value-of select="concat('Organization/', /Practitioner/qualification_issuer)"/> </xsl:attribute> </reference> </xsl:if> -->
					<!-- </issuer> -->
					<!-- </qualification> -->
					<!-- 0..* CodeableConcept A language the practitioner can use in patient communication -->
					<!-- <communication> <xsl:call-template name="Practitioner_communication"/> </communication> -->
				</Practitioner>
			</xsl:for-each-group>
		</Practitioners>
	</xsl:template>
	<!-- Subtemplates -->
	<xsl:template name="resource_meta">
		<meta>
			<lastUpdated>
				<xsl:attribute name="value">
					<!--Get current date time-->
					<xsl:value-of select="current-dateTime()"/>
				</xsl:attribute>
			</lastUpdated>
		</meta>
	</xsl:template>
	<xsl:template name="resource_identifier">
		<identifier>
			<use value="official"/>
			<system value="urn:oid:2.16.840.1.113883.4.6"/>
			<!-- This urn is for NPI -->
			<value>
				<xsl:attribute name="value">
					<xsl:choose>
						<xsl:when test="./practitioner_details/npi">
							<xsl:value-of
								select="concat($CUSTOMER_PREFIX, '-', ./practitioner_details/npi)"/>
						</xsl:when>
						<xsl:when test="./npi">
							<xsl:value-of select="concat($CUSTOMER_PREFIX, '-', ./npi)"/>
						</xsl:when>
					</xsl:choose>
				</xsl:attribute>
			</value>
		</identifier>
		<!-- This isn't in source. Just NPI should be needed. <identifier> <value> <xsl:attribute name="value"> <xsl:value-of select="/practitioner/tax"/> </xsl:attribute> </value> </identifier> -->
	</xsl:template>
	<xsl:template name="Practitioner_name">
		<xsl:for-each select="./practitioner_details/names/name | ./names/name">
			<!-- 0..* HumanName The name(s) associated with the practitioner -->
			<name>
				<!-- 0..1 usual | official | temp | nickname | anonymous | old | maiden -->
				<use value="official">
					<!-- <xsl:attribute name="value" value="official"/> <xsl:value-of select="use"/> Not in source. -->
				</use>
				<!-- 0..1 Text representation of the full name <text> <xsl:attribute name="value"> <xsl:value-of select="text"/> </xsl:attribute> </text>-->
				<!-- 0..1 Family name (often called 'Surname') -->
				<family>
					<xsl:attribute name="value">
						<xsl:value-of select="family"/>
					</xsl:attribute>
				</family>
				<!-- 0..* Given names (not always 'first'). Includes middle names -->
				<xsl:for-each select="given">
					<given>
						<xsl:attribute name="value">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</given>
				</xsl:for-each>
				<!-- 0..* Parts that come before the name -->
				<xsl:for-each select="prefix">
					<prefix>
						<xsl:attribute name="value">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</prefix>
				</xsl:for-each>
				<!-- 0..* Parts that come after the name -->
				<xsl:for-each select="suffix">
					<suffix>
						<xsl:attribute name="value">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</suffix>
				</xsl:for-each>
				<!-- MAPPING NOT IMPLEMENTED: -->
				<!-- 0..1 Period Time period when name was/is in use -->
				<!-- <period> <xsl:call-template name="Practitioner_name_period"/> </period> -->
			</name>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="practitioner_telecom">
		<xsl:for-each select="./practitioner_details/telecoms | ./telecoms">
			<telecom>
				<!-- Nothing in source. Sample output doc only has system, value and use -->
				<!-- ?? 0..1 phone | fax | email | pager | url | sms | other -->
				<system>
					<xsl:attribute name="value">
						<xsl:value-of select="./system"/>
					</xsl:attribute>
				</system>
				<!-- 0..1 The actual contact point details -->
				<value>
					<xsl:attribute name="value">
						<xsl:value-of select="./value"/>
					</xsl:attribute>
				</value>
				<xsl:if test="./use">
					<!-- 0..1 home | work | temp | old | mobile - purpose of this contact point -->
					<use>
						<xsl:attribute name="value">
							<xsl:value-of select="./use"/>
						</xsl:attribute>
					</use>
				</xsl:if>
				<xsl:if test="rank">
					<rank>
						<xsl:attribute name="value">
							<xsl:value-of select="rank"/>
						</xsl:attribute>
					</rank>
				</xsl:if>
				<xsl:if test="period/start | period/end">
					<period>
						<xsl:if test="period/start">
							<start>
								<xsl:attribute name="value">
									<xsl:value-of select="period/start"/>
								</xsl:attribute>
							</start>
						</xsl:if>
						<xsl:if test="period/end">
							<end>
								<xsl:attribute name="value">
									<xsl:value-of select="period/end"/>
								</xsl:attribute>
							</end>
						</xsl:if>
					</period>
				</xsl:if>
			</telecom>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="Practitioner_address">
		<!-- 0..* Address Address(es) of the practitioner that are not role specific (typically home address) -->
		<xsl:for-each select="./practitioner_details/addresses/address | ./addresses/address">
			<address>
				<xsl:if test="use">
					<!-- 0..1 home | work | temp | old | billing - purpose of this address -->
					<use>
						<xsl:attribute name="value">
							<xsl:value-of select="./use"/>
						</xsl:attribute>
					</use>
				</xsl:if>
				<xsl:if test="type">
					<!-- 0..1 postal | physical | both -->
					<type>
						<xsl:attribute name="value">
							<xsl:value-of select="type"/>
						</xsl:attribute>
					</type>
				</xsl:if>
				<xsl:if test="text">
					<!-- 0..1 Text representation of the address -->
					<text>
						<xsl:attribute name="value">
							<xsl:value-of select="text"/>
						</xsl:attribute>
					</text>
				</xsl:if>
				<xsl:for-each select="./line">
					<!-- 0..* Street name, number, direction & P.O. Box etc. -->
					<line>
						<xsl:attribute name="value">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</line>
				</xsl:for-each>
				<!-- 0..1 Name of city, town etc. -->
				<city>
					<xsl:attribute name="value">
						<xsl:value-of select="./city"/>
					</xsl:attribute>
				</city>
				<xsl:if test="district">
					<!-- 0..1 District name (aka county) -->
					<district>
						<xsl:attribute name="value">
							<xsl:value-of select="district"/>
						</xsl:attribute>
					</district>
				</xsl:if>
				<xsl:if test="state">
					<!-- 0..1 Sub-unit of country (abbreviations ok) -->
					<state>
						<xsl:attribute name="value">
							<xsl:value-of select="state"/>
						</xsl:attribute>
					</state>
				</xsl:if>
				<!-- 0..1 Postal code for area -->
				<postalCode>
					<xsl:attribute name="value">
						<xsl:value-of select="./postal_code"/>
					</xsl:attribute>
				</postalCode>
				<!-- 0..1 Country (e.g. can be ISO 3166 2 or 3 letter code) -->
				<country>
					<xsl:attribute name="value">
						<xsl:value-of select="./country"/>
					</xsl:attribute>
				</country>
				<!-- 0..1 Period Time period when address was/is in use -->
				<xsl:if test="period/start | period/end">
					<period>
						<xsl:if test="period/start">
							<start>
								<xsl:attribute name="value">
									<xsl:value-of select="period/start"/>
								</xsl:attribute>
							</start>
						</xsl:if>
						<xsl:if test="period/end">
							<end>
								<xsl:attribute name="value">
									<xsl:value-of select="period/end"/>
								</xsl:attribute>
							</end>
						</xsl:if>
					</period>
				</xsl:if>
			</address>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
