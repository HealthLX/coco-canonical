<xsl:stylesheet xpath-default-namespace="http://cocodata.org" version="2.0" xmlns="http://hl7.org/fhir"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:preserve-space elements="*"/>
	<xsl:output indent="no" method="xml"/>

	<xsl:variable name="POG_CUSTOMER_PREFIX" select="eob_list/eob/provider/practitioner/customername"/>


	<!-- Main resource template structure -->
	<xsl:template match="*">
		<!-- https://www.hl7.org/fhir/practitioner.html -->
		<Practitioner>
			<xsl:call-template name="resource_meta"/>

			<id>
				<xsl:attribute name="value">
					<xsl:value-of select="concat($POG_CUSTOMER_PREFIX, '-', /practitioner/npi)"/>
				</xsl:attribute>
			</id>

			<!-- 0..* Identifier An identifier for the person as this agent -->
			<xsl:call-template name="resource_identifier"/>

			<!-- 0..1 Whether this practitioner's record is in active use -->
			<active>
				<xsl:attribute name="value">true</xsl:attribute>
			</active>

			<!-- 0..* HumanName The name(s) associated with the practitioner -->
			<xsl:call-template name="Practitioner_name"/>

			<!-- 0..* ContactPoint A contact detail for the practitioner (that apply to all roles) -->
			<xsl:call-template name="practitioner_telecom"/>

			<!-- 0..1 male | female | other | unknown -->
			<gender>
				<xsl:attribute name="value">
					<xsl:value-of select="/eob_list/eob/provider/practitioner/gender"/>
				</xsl:attribute>
			</gender>

			<!-- 0..* Address Address(es) of the practitioner that are not role specific (typically home address) -->
			<address>
				<xsl:call-template name="Practitioner_address"/>
			</address>

			<!-- ********* MAPPINGS NOT IMPLEMENTED below this comment ********* -->

			<!-- 0..1 The date  on which the practitioner was born -->
			<!-- <birthDate>
				<xsl:attribute name="value">
					<xsl:value-of select="/eob_list/eob/provider/practitioner/birthDate"/>
				</xsl:attribute>
			</birthDate> -->
			<!-- 0..* Attachment Image of the person -->
			<!-- <photo>
				<xsl:call-template name="Practitioner_photo"/>
			</photo> -->
			<!-- 0..* Certification, licenses, or training pertaining to the provision of care -->
			<!-- <qualification> -->
			<!-- 0..* Identifier An identifier for this qualification for the practitioner -->
			<!-- <identifier>
					<xsl:call-template name="Practitioner_qualification_identifier"/>
				</identifier> -->
			<!-- 1..1 CodeableConcept Coded representation of the qualification -->
			<!-- <code>
					<xsl:call-template name="Practitioner_qualification_code"/>
				</code> -->
			<!-- 0..1 Period Period during which the qualification is valid -->
			<!-- <period>
					<xsl:call-template name="Practitioner_qualification_period"/>
				</period> -->
			<!-- 0..1 Reference(Organization) Organization that regulates and issues the qualification -->
			<!-- <issuer> -->
			<!-- <xsl:if test="practitioner/qualification_issuer != ''">
						<reference>
							<xsl:attribute name="value">
								<xsl:value-of select="concat('Organization/', /Practitioner/qualification_issuer)"/>
							</xsl:attribute>
						</reference>
					</xsl:if> -->
			<!-- </issuer> -->
			<!-- </qualification> -->
			<!-- 0..* CodeableConcept A language the practitioner can use in patient communication -->
			<!-- <communication>
				<xsl:call-template name="Practitioner_communication"/>
			</communication> -->
		</Practitioner>
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
			<system value="http://hl7.org/fhir/sid/us-npi"/>
			<value>
				<xsl:attribute name="value">
					<xsl:value-of select="concat($POG_CUSTOMER_PREFIX, '-', /practitioner/npi)"/>
				</xsl:attribute>
			</value>
		</identifier>
		<identifier>
			<value>
				<xsl:attribute name="value">
					<xsl:value-of select="concat($POG_CUSTOMER_PREFIX, '-', /practitioner/tax)"/>
				</xsl:attribute>
			</value>
		</identifier>
	</xsl:template>

	<xsl:template name="Practitioner_name">
		<xsl:for-each select="/eob_list/eob/provider/practitioner/names/name">
			<!-- 0..* HumanName The name(s) associated with the practitioner -->
			<name>
				<!-- 0..1 usual | official | temp | nickname | anonymous | old | maiden -->
				<use>
					<xsl:attribute name="value">
						<xsl:value-of select="use"/>
					</xsl:attribute>
				</use>

				<!-- 0..1 Text representation of the full name -->
				<text>
					<xsl:attribute name="value">
						<xsl:value-of select="text"/>
					</xsl:attribute>
				</text>

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
				<!-- <period>
					<xsl:call-template name="Practitioner_name_period"/>
				</period> -->
			</name>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="practitioner_telecom">
		<xsl:for-each select="/eob_list/eob/provider/practitioner/telecoms/telecom">
			<telecom>
				<!-- ?? 0..1 phone | fax | email | pager | url | sms | other -->
				<system>
					<xsl:attribute name="value">
						<xsl:value-of select="system"/>
					</xsl:attribute>
				</system>
				<!-- 0..1 The actual contact point details -->
				<value>
					<xsl:attribute name="value">
						<xsl:value-of select="value"/>
					</xsl:attribute>
				</value>
				<!-- 0..1 home | work | temp | old | mobile - purpose of this contact point -->
				<use>
					<xsl:attribute name="value">
						<xsl:value-of select="use"/>
					</xsl:attribute>
				</use>
				<!-- 0..1 Specify preferred order of use (1 = highest) -->
				<rank>
					<xsl:attribute name="value">
						<xsl:value-of select="rank"/>
					</xsl:attribute>
				</rank>
				<!-- 0..1 Period Time period when the contact point was/is in use -->
				<period>
					<start>
						<xsl:attribute name="value">
							<xsl:value-of select="period/start"/>
						</xsl:attribute>
					</start>
					<end>
						<xsl:attribute name="value">
							<xsl:value-of select="period/end"/>
						</xsl:attribute>
					</end>
				</period>
			</telecom>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="Practitioner_address">
		<!-- 0..* Address Address(es) of the practitioner that are not role specific (typically home address) -->
		<xsl:for-each select="/eob_list/eob/provider/practitioner/addresses/address">
			<address>
				<!-- 0..1 home | work | temp | old | billing - purpose of this address -->
				<use>
					<xsl:attribute name="value">
						<xsl:value-of select="use"/>
					</xsl:attribute>
				</use>
				<!-- 0..1 postal | physical | both -->
				<type>
					<xsl:attribute name="value">
						<xsl:value-of select="type"/>
					</xsl:attribute>
				</type>
				<!-- 0..1 Text representation of the address -->
				<text>
					<xsl:attribute name="value">
						<xsl:value-of select="text"/>
					</xsl:attribute>
				</text>
				<!-- 0..* Street name, number, direction & P.O. Box etc. -->
				<xsl:for-each select="line">
					<line>
						<xsl:attribute name="value">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</line>
				</xsl:for-each>
				<!-- 0..1 Name of city, town etc. -->
				<city>
					<xsl:attribute name="value">
						<xsl:value-of select="city"/>
					</xsl:attribute>
				</city>
				<!-- 0..1 District name (aka county) -->
				<district>
					<xsl:attribute name="value">
						<xsl:value-of select="district"/>
					</xsl:attribute>
				</district>
				<!-- 0..1 Sub-unit of country (abbreviations ok) -->
				<state>
					<xsl:attribute name="value">
						<xsl:value-of select="state"/>
					</xsl:attribute>
				</state>
				<!-- 0..1 Postal code for area -->
				<postalCode>
					<xsl:attribute name="value">
						<xsl:value-of select="postal_code"/>
					</xsl:attribute>
				</postalCode>
				<!-- 0..1 Country (e.g. can be ISO 3166 2 or 3 letter code) -->
				<country>
					<xsl:attribute name="value">
						<xsl:value-of select="country"/>
					</xsl:attribute>
				</country>
				<!-- 0..1 Period Time period when address was/is in use -->
				<period>
					<start>
						<xsl:attribute name="value">
							<xsl:value-of select="period/start"/>
						</xsl:attribute>
					</start>
					<end>
						<xsl:attribute name="value">
							<xsl:value-of select="period/end"/>
						</xsl:attribute>
					</end>
				</period>
			</address>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
