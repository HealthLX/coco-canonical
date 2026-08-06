<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://hl7.org/fhir">
	<xsl:preserve-space elements="*"/>
	<xsl:output method="xml" indent="no"/>

	<xsl:template match="*">
		<Patient>
			<xsl:call-template name="resource_meta"/>

			<id>
				<xsl:attribute name="value">
					<!-- <xsl:value-of select="/member/member_id"/> -->
					<xsl:value-of
						select="concat(/member/customername, '-', /member/unique_person_ids/unique_person_id)"
					/>
				</xsl:attribute>
			</id>

			<xsl:call-template name="resource_extensions"/>

			<xsl:call-template name="resource_identifier"/>

			<active value="true"/>

			<xsl:call-template name="patient_name"/>

			<xsl:call-template name="patient_telecom"/>

			<gender>
				<xsl:call-template name="patient_gender"/>
			</gender>

			<birthDate>
				<xsl:attribute name="value">
					<xsl:value-of select="/member/birth_date"/>
				</xsl:attribute>
			</birthDate>

			<xsl:call-template name="patient_address"/>

			<!--Need to move the logic into SQL to determine marital status based on FHIR code-->
			<!-- <maritalStatus>
				<xsl:call-template name="patient_marital_status"/>
			</maritalStatus> -->

			<xsl:call-template name="patient_contact"/>

			<xsl:call-template name="patient_communication"/>
		</Patient>
	</xsl:template>


	<!-- Subtemplates -->
	<xsl:template name="resource_meta">
		<meta>
			<source>
				<xsl:attribute name="value">
					<xsl:value-of select="/member/parentfile"/>
				</xsl:attribute>
			</source>
			<lastUpdated>
				<xsl:attribute name="value">
					<!--Get current date time-->
					<xsl:value-of select="current-dateTime()"/>
				</xsl:attribute>
			</lastUpdated>
		</meta>
	</xsl:template>

	<xsl:template name="resource_extensions">
		<!-- from DomainResource: text, contained, extension, and modifierExtension -->
		<extension url="http://hl7.org/fhir/us/core/StructureDefinition/us-core-race">
			<extension url="ombCategory">
				<valueCoding>
					<system>
						<xsl:choose>
							<xsl:when test="/member/us_core_race/code = 'UNK'">
								<xsl:attribute name="value">http://terminology.hl7.org/CodeSystem/v3-NullFlavor</xsl:attribute>
							</xsl:when>
							<xsl:when test="/member/us_core_race/code = 'ASKU'">
								<xsl:attribute name="value">http://terminology.hl7.org/CodeSystem/v3-NullFlavor</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="value">urn:oid:2.16.840.1.113883.6.238</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</system>
					<code>
						<xsl:attribute name="value">
							<xsl:value-of select="/member/us_core_race/code"/>
						</xsl:attribute>
					</code>
					<display>
						<xsl:choose>
							<xsl:when test="/member/us_core_race/code = 'UNK'">
								<xsl:attribute name="value">unknown</xsl:attribute>
							</xsl:when>
							<xsl:when test="/member/us_core_race/code = 'ASKU'">
								<xsl:attribute name="value">asked but unknown</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="value">
									<xsl:value-of select="/member/us_core_race/text"/>
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</display>
				</valueCoding>
			</extension>

			<extension url="text">
				<valueString>
					<xsl:attribute name="value">
						<xsl:value-of select="/member/us_core_race/text"/>
					</xsl:attribute>

				</valueString>
			</extension>
		</extension>

		<extension url="http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity">
			<extension url="ombCategory">
				<valueCoding>
					<system>
						<xsl:choose>
							<xsl:when test="/member/us_core_ethnicity/code = 'UNK'">
								<xsl:attribute name="value">http://terminology.hl7.org/CodeSystem/v3-NullFlavor</xsl:attribute>
							</xsl:when>
							<xsl:when test="/member/us_core_ethnicity/code = 'ASKU'">
								<xsl:attribute name="value">http://terminology.hl7.org/CodeSystem/v3-NullFlavor</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="value">urn:oid:2.16.840.1.113883.6.238</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</system>
					<code>
						<xsl:attribute name="value">
							<xsl:value-of select="/member/us_core_ethnicity/code"/>
						</xsl:attribute>
					</code>
					<display>
						<xsl:choose>
							<xsl:when test="/member/us_core_ethnicity/code = 'UNK'">
								<xsl:attribute name="value">unknown</xsl:attribute>
							</xsl:when>
							<xsl:when test="/member/us_core_ethnicity/code = 'ASKU'">
								<xsl:attribute name="value">asked but unknown</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="value">
									<xsl:value-of select="/member/us_core_ethnicity/text"/>
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</display>
				</valueCoding>
			</extension>

			<extension url="text">
				<valueString>
					<xsl:attribute name="value">
						<xsl:value-of select="/member/us_core_ethnicity/text"/>
					</xsl:attribute>

				</valueString>
			</extension>
		</extension>

		<!-- <extension
				url="http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity">
			<extension url="ombCategory">
				<valueCoding>
					<system value="urn:oid:2.16.840.1.113883.6.238"/>
					<code>
						<xsl:attribute name="value">
							<xsl:value-of select="/member/us_core_ethnicity/code"/>
						</xsl:attribute>
					</code>
					<display>
						<xsl:attribute name="value">
							<xsl:value-of select="/member/us_core_ethnicity/text"/>
						</xsl:attribute>
					</display>
				</valueCoding>
				<extension url="text">
					<valueString>
						<xsl:attribute name="value">
							<xsl:value-of select="/member/us_core_ethnicity/text"/>
						</xsl:attribute>
					</valueString>
				</extension>
			</extension>
		</extension>-->
	</xsl:template>

	<xsl:template name="resource_identifier">
		<identifier>
			<!-- 0..1 usual | official | temp | secondary | old (If known) -->
			<!-- <use>
				<xsl:attribute name="value">
					<xsl:value-of select="/member/..."/>
				</xsl:attribute>
			</use> -->

			<!-- <type>
				<coding> -->
			<!-- 0..1 Identity of the terminology system -->
			<!-- <system>
						<xsl:attribute name="value">
							<xsl:value-of select="/member/identifier_type_system"/>
						</xsl:attribute>
					</system> -->
			<!-- 0..1 Version of the system - if relevant -->
			<!-- <version>
						<xsl:attribute name="value">
							<xsl:value-of select="/member/identifier_type_version"/>
						</xsl:attribute>
					</version> -->
			<!-- 0..1 Symbol in syntax defined by the system -->
			<!-- <code>
						<xsl:attribute name="value">
							<xsl:value-of select="/member/identifier_type_code"/>
						</xsl:attribute>
					</code> -->
			<!-- 0..1 Representation defined by the system -->
			<!-- <display>
						<xsl:attribute name="value">
							<xsl:value-of select="/member/identifier_type_display"/>
						</xsl:attribute>
					</display>
				</coding> -->
			<!-- 0..1 Plain text representation of the concept -->
			<!-- <text>
					<xsl:attribute name="value">
						<xsl:value-of select="/member/identifier_type_text"/>
					</xsl:attribute>
				</text>
			</type> -->
			<system>
				<xsl:attribute name="value">
					<xsl:value-of select="/member/member_id_system"/>
				</xsl:attribute>
			</system>
			<value>
				<xsl:attribute name="value">
					<xsl:value-of
						select="/member/unique_person_ids/unique_person_id"
					/>
				</xsl:attribute>
			</value>
		</identifier>
	</xsl:template>

	<xsl:template name="patient_name">
		<xsl:for-each select="/member/names/name">
			<name>
				<!-- 0..1 usual | official | temp | nickname | anonymous | old | maiden -->
				<xsl:if test="use">
					<xsl:element name="use">
						<xsl:attribute name="value">
							<xsl:value-of select="use"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<!-- 0..1 Text representation of the full name -->
				<xsl:if test="text">
					<xsl:element name="text">
						<xsl:attribute name="value">
							<xsl:value-of select="text"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<!-- 0..1 Family name (often called 'Surname') -->
				<family>
					<xsl:attribute name="value">
						<xsl:value-of select="./family"/>
					</xsl:attribute>
				</family>
				<!-- 0..* Given names (not always 'first'). Includes middle names -->
				<given>
					<xsl:attribute name="value">
						<xsl:value-of select="./given"/>
					</xsl:attribute>
				</given>
				<!-- 0..* Parts that come before the name -->
				<xsl:if test="prefix">
					<xsl:element name="prefix">
						<xsl:attribute name="value">
							<xsl:value-of select="prefix"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<!-- 0..* Parts that come after the name -->
				<xsl:if test="suffix">
					<xsl:element name="suffix">
						<xsl:attribute name="value">
							<xsl:value-of select="suffix"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<!-- 0..1 Period Time period when name was/is in use -->
				<xsl:if test="period">
					<xsl:element name="period">
						<xsl:if test="period/start">
							<xsl:element name="start">
								<xsl:attribute name="value">
									<xsl:value-of select="period/start"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<xsl:if test="period/end">
							<xsl:element name="end">
								<xsl:attribute name="value">
									<xsl:value-of select="period/end"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:if>
			</name>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="patient_telecom">
		<xsl:for-each select="/member/telecoms/telecom">
			<telecom>
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
				<!-- 0..1 home | work | temp | old | mobile - purpose of this contact point -->
				<use>
					<xsl:attribute name="value">
						<xsl:value-of select="./use"/>
					</xsl:attribute>
				</use>
				<!-- 0..1 Specify preferred order of use (1 = highest) -->
				<rank>
					<xsl:attribute name="value">
						<xsl:value-of select="position()"/>
					</xsl:attribute>
				</rank>
				<!-- 0..1 Period Time period when the contact point was/is in use -->
				<xsl:if test="period">
					<xsl:element name="period">
						<xsl:if test="period/start">
							<xsl:element name="start">
								<xsl:attribute name="value">
									<xsl:value-of select="period/start"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<xsl:if test="period/end">
							<xsl:element name="end">
								<xsl:attribute name="value">
									<xsl:value-of select="period/end"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:if>
			</telecom>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="patient_gender">
		<xsl:attribute name="value">
			<xsl:choose>
				<xsl:when test="starts-with(/member/gender, 'male')">male</xsl:when>
				<xsl:when test="starts-with(/member/gender, 'female')">female</xsl:when>
				<xsl:otherwise>unknown</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="patient_address">
		<xsl:for-each select="/member/addresses/address">
			<address>
				<!-- 0..1 home | work | temp | old | billing - purpose of this address -->
				<!-- <use>
					<xsl:attribute name="value">
						<xsl:value-of select="lower-case(address_use)"/>
					</xsl:attribute>
				</use> -->
				<!-- 0..1 postal | physical | both -->
				<xsl:if test="./type">
					<type>
						<xsl:attribute name="value">
							<xsl:value-of select="./type"/>
						</xsl:attribute>
					</type>
				</xsl:if>
				<!-- 0..1 Text representation of the address -->
				<!-- 
				<text>
					<xsl:attribute name="value">
						<xsl:value-of select=""/>
					</xsl:attribute>
				</text>
				 -->
				<!-- 0..* Street name, number, direction & P.O. Box etc. -->
				<xsl:for-each select="./line">
					<line>
						<xsl:attribute name="value">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</line>
				</xsl:for-each>
				<!-- 0..1 Name of city, town etc. -->
				<xsl:if test="./city">
					<city>
						<xsl:attribute name="value">
							<xsl:value-of select="./city"/>
						</xsl:attribute>
					</city>
				</xsl:if>
				<!-- 0..1 District name (aka county) -->
				<xsl:if test="./district">
					<district>
						<xsl:attribute name="value">
							<xsl:value-of select="./district"/>
						</xsl:attribute>
					</district>
				</xsl:if>
				<!-- 0..1 Sub-unit of country (abbreviations ok) -->
				<xsl:if test="./state">
					<state>
						<xsl:attribute name="value">
							<xsl:value-of select="./state"/>
						</xsl:attribute>
					</state>
				</xsl:if>
				<!-- 0..1 Postal code for area -->
				<xsl:if test="./postal_code">
					<postalCode>
						<xsl:attribute name="value">
							<xsl:value-of select="./postal_code"/>
						</xsl:attribute>
					</postalCode>
				</xsl:if>
				<!-- 0..1 Country (e.g. can be ISO 3166 2 or 3 letter code) -->
				<country>
					<xsl:choose>
						<xsl:when test="./country">
							<xsl:attribute name="value">
								<xsl:value-of select="./country"/>
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="value">USA</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</country>
				<!-- 0..1 Period Time period when address was/is in use -->
				<xsl:if test="period">
					<xsl:element name="period">
						<xsl:if test="period/start">
							<xsl:element name="start">
								<xsl:attribute name="value">
									<xsl:value-of select="period/start"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<xsl:if test="period/end">
							<xsl:element name="end">
								<xsl:attribute name="value">
									<xsl:value-of select="period/end"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:if>
			</address>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="patient_marital_status">
		<!-- CodeableConcept -->
		<!-- 0..* Coding Code defined by a terminology system -->
		<coding>
			<!-- 0..1 Identity of the terminology system -->
			<system>
				<xsl:attribute name="value">
					<xsl:value-of select="/member/marital_status_system"/>
				</xsl:attribute>
			</system>
			<!-- 0..1 Version of the system - if relevant -->
			<version>
				<xsl:attribute name="value">
					<xsl:value-of select="/member/marital_status_version"/>
				</xsl:attribute>
			</version>
			<!-- 0..1 Symbol in syntax defined by the system -->
			<code>
				<xsl:attribute name="value">
					<xsl:value-of select="/member/marital_status_code"/>
				</xsl:attribute>
			</code>
			<!-- 0..1 Representation defined by the system -->
			<display>
				<xsl:attribute name="value">
					<xsl:value-of select="/member/marital_status_display"/>
				</xsl:attribute>
			</display>
			<!-- MAPPING NOT IMPLEMENTED: -->
			<!-- 0..1 If this coding was chosen directly by the user -->
			<!-- 
			<userSelected>
				<xsl:attribute name="value">
					<xsl:value-of select=""/>
				</xsl:attribute>
			</userSelected>
			 -->
		</coding>
		<!-- 0..1 Plain text representation of the concept -->
		<text>
			<xsl:attribute name="value">
				<xsl:value-of select="/member/marital_status_text"/>
			</xsl:attribute>
		</text>
	</xsl:template>

	<xsl:template name="patient_contact">
		<xsl:for-each select="/member/member_contacts/member_contact">
			<!-- 0..* A contact party (e.g. guardian, partner, friend) for the patient -->
			<contact>
				<!-- 0..* CodeableConcept The kind of relationship -->
				<relationship/>
				<!-- 0..1 HumanName A name associated with the contact person -->
				<name>
					<text>
						<xsl:attribute name="value">
							<xsl:value-of select="first_name"/>&#160;<xsl:value-of
								select="last_name"/>
						</xsl:attribute>
					</text>
				</name>
				<!-- 0..* ContactPoint A contact detail for the person -->
				<telecom>
					<xsl:attribute name="value">
						<xsl:value-of select="phones/phone/phone_number"/>
					</xsl:attribute>
				</telecom>
				<!-- 0..1 Address Address for the contact person -->
				<address>
					<line>
						<xsl:attribute name="value">
							<xsl:value-of select="addresses/address/address_line_1"/>
						</xsl:attribute>
					</line>
					<city>
						<xsl:attribute name="value">
							<xsl:value-of select="addresses/address/city"/>
						</xsl:attribute>
					</city>
					<district>
						<xsl:attribute name="value">
							<xsl:value-of select="addresses/address/county"/>
						</xsl:attribute>
					</district>
					<state>
						<xsl:attribute name="value">
							<xsl:value-of select="addresses/address/state"/>
						</xsl:attribute>
					</state>
					<postalcode>
						<xsl:attribute name="value">
							<xsl:value-of select="addresses/address/zip_code"/>
						</xsl:attribute>
					</postalcode>
					<country>
						<xsl:attribute name="value">USA</xsl:attribute>
					</country>
				</address>
				<!-- 0..1 value="[code]" male | female | other | unknown -->
				<gender/>
				<!-- ?? 0..1 Reference(Organization) Organization that is associated with the contact -->
				<organization/>
				<!-- 0..1 Period The period during which this contact person or organization is valid to be contacted relating to this patient -->
				<xsl:if test="period">
					<xsl:element name="period">
						<xsl:if test="period/start">
							<xsl:element name="start">
								<xsl:attribute name="value">
									<xsl:value-of select="period/start"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<xsl:if test="period/end">
							<xsl:element name="end">
								<xsl:attribute name="value">
									<xsl:value-of select="period/end"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:if>
			</contact>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="patient_communication">
		<xsl:for-each select="/member/communications/communication">
			<communication>
				<language>
					<xsl:choose>
						<xsl:when test="./language_code != 'NO_MATCHING_language_code'">
							<coding>
								<system value="urn:ietf:bcp:47"/>
								<!--     IETF language tag     -->
								<code>
									<xsl:attribute name="value">
										<xsl:value-of select="./language_code"/>
									</xsl:attribute>
								</code>
								<display>
									<xsl:attribute name="value">
										<xsl:value-of select="./display"/>
									</xsl:attribute>
								</display>
							</coding>
						</xsl:when>
						<xsl:otherwise>
							<text>
								<xsl:attribute name="value">
									<xsl:value-of select="./display"/><!-- Change made for SHSI-342 but not tested -->
								</xsl:attribute>
							</text>
						</xsl:otherwise>
					</xsl:choose>
				</language>
				<preferred>
					<xsl:attribute name="value">
						<xsl:value-of select="./is_preferred"/>
					</xsl:attribute>
				</preferred>
			</communication>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
