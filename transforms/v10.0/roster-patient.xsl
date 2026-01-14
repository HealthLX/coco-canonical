<xsl:stylesheet 
	version="10.0" 
	xmlns="http://hl7.org/fhir"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:coco="http://cocodata.org"
	exclude-result-prefixes="coco">
	<xsl:preserve-space elements="*"/>
	<xsl:output method="xml" indent="no"/>
	<xsl:template match="/coco:roster">
		<Patient>
			<id>
				<xsl:attribute name="value">
					<!-- <xsl:value-of select="/coco:roster/coco:member/coco:member_id"/> -->
					<xsl:value-of
						select="concat(/coco:roster/coco:member/coco:customername, '-', /coco:roster/coco:member/coco:unique_person_ids/coco:unique_person_id)"
					/>
				</xsl:attribute>
			</id>
			<xsl:call-template name="resource_meta"/>
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
					<xsl:value-of select="/coco:roster/coco:member/coco:birth_date"/>
				</xsl:attribute>
			</birthDate>

			<xsl:if test="/coco:roster/coco:member/coco:deceased_date_time">
				<deceasedDateTime>
					<xsl:attribute name="value">
						<xsl:value-of select="/coco:roster/coco:member/coco:deceased_date_time"/>
					</xsl:attribute>
				</deceasedDateTime>
			</xsl:if>

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
			<lastUpdated>
				<xsl:attribute name="value" select="current-dateTime()"/>
			</lastUpdated>

			<xsl:if test="coco:member/coco:parentfile != ''">
				<source>
					<xsl:attribute name="value" select="coco:member/coco:parentfile"/>
				</source>
			</xsl:if>
		</meta>
	</xsl:template>

	<xsl:template name="resource_extensions">
		<!-- from DomainResource: text, contained, extension, and modifierExtension -->
		<extension url="http://hl7.org/fhir/us/core/StructureDefinition/us-core-race">
			<extension url="ombCategory">
				<valueCoding>
					<xsl:variable name="race_code" select="coco:member/coco:us_core_race/coco:code[1]"/>
					<system>
						<xsl:choose>
							<xsl:when test="$race_code = 'UNK' or $race_code = 'ASKU'">
								<xsl:attribute name="value">http://terminology.hl7.org/CodeSystem/v3-NullFlavor</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="value">urn:oid:2.16.840.1.113883.6.238</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</system>
					<code>
						<xsl:attribute name="value" select="$race_code"/>
					</code>
					<display>
						<xsl:attribute name="value">
							<xsl:choose>
								<xsl:when test="$race_code = 'UNK'">unknown</xsl:when>
								<xsl:when test="$race_code = 'ASKU'">asked but unknown</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="if (coco:member/coco:us_core_race/coco:text != '') 
									                      then coco:member/coco:us_core_race/coco:text 
									                      else 'unknown'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</display>
				</valueCoding>
			</extension>

			<extension url="text">
				<valueString>
					<xsl:attribute name="value" select="coco:member/coco:us_core_race/coco:text"/>
				</valueString>
			</extension>
		</extension>

		<extension url="http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity">
			<extension url="ombCategory">
				<valueCoding>
					<xsl:variable name="eth_code" select="coco:member/coco:us_core_ethnicity/coco:code"/>
					<system value="urn:oid:2.16.840.1.113883.6.238"/>
					<code>
						<xsl:attribute name="value" select="$eth_code"/>
					</code>
					<display>
						<xsl:attribute name="value">
							<xsl:choose>
								<xsl:when test="$eth_code = 'UNK'">unknown</xsl:when>
								<xsl:when test="$eth_code = 'ASKU'">asked but unknown</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="if (coco:member/coco:us_core_ethnicity/coco:text != '') 
									                      then coco:member/coco:us_core_ethnicity/coco:text 
									                      else 'unknown'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</display>
				</valueCoding>
			</extension>
			<extension url="text">
				<valueString>
					<xsl:attribute name="value" select="coco:member/coco:us_core_ethnicity/coco:text"/>
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
					<xsl:value-of select="/coco:roster/coco:member/coco:member_id_system"/>
				</xsl:attribute>
			</system>
			<value>
				<xsl:attribute name="value">
					<xsl:value-of
						select="/coco:roster/coco:member/coco:unique_person_ids/coco:unique_person_id"
					/>
				</xsl:attribute>
			</value>
		</identifier>
	</xsl:template>

	<xsl:template name="patient_name">
		<xsl:for-each select="/coco:roster/coco:member/coco:names/coco:name">
			<name>
				<!-- 0..1 usual | official | temp | nickname | anonymous | old | maiden -->
				<xsl:if test="coco:use">
					<xsl:element name="use">
						<xsl:attribute name="value">
							<xsl:value-of select="coco:use"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<!-- 0..1 Text representation of the full name -->
				<xsl:if test="coco:text">
					<xsl:element name="text">
						<xsl:attribute name="value">
							<xsl:value-of select="coco:text"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<!-- 0..1 Family name (often called 'Surname') -->
				<family>
					<xsl:attribute name="value">
						<xsl:value-of select="./coco:family"/>
					</xsl:attribute>
				</family>
				<!-- 0..* Given names (not always 'first'). Includes middle names -->
				<given>
					<xsl:attribute name="value">
						<xsl:value-of select="./coco:given"/>
					</xsl:attribute>
				</given>
				<!-- 0..* Parts that come before the name -->
				<xsl:if test="coco:prefix">
					<xsl:element name="prefix">
						<xsl:attribute name="value">
							<xsl:value-of select="coco:prefix"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<!-- 0..* Parts that come after the name -->
				<xsl:if test="coco:suffix">
					<xsl:element name="suffix">
						<xsl:attribute name="value">
							<xsl:value-of select="coco:suffix"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<!-- 0..1 Period Time period when name was/is in use -->
				<xsl:if test="coco:period">
					<xsl:element name="period">
						<xsl:if test="coco:period/coco:start">
							<xsl:element name="start">
								<xsl:attribute name="value">
									<xsl:value-of select="coco:period/coco:start"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<xsl:if test="coco:period/coco:end">
							<xsl:element name="end">
								<xsl:attribute name="value">
									<xsl:value-of select="coco:period/coco:end"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:if>
			</name>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="patient_telecom">
		<xsl:for-each select="/coco:roster/coco:member/coco:telecoms/coco:telecom">
			<telecom>
				<!-- ?? 0..1 phone | fax | email | pager | url | sms | other -->
				<system>
					<xsl:attribute name="value">
						<xsl:value-of select="./coco:system"/>
					</xsl:attribute>
				</system>
				<!-- 0..1 The actual contact point details -->
				<value>
					<xsl:attribute name="value">
						<xsl:value-of select="./coco:value"/>
					</xsl:attribute>
				</value>
				<!-- 0..1 home | work | temp | old | mobile - purpose of this contact point -->
				<use>
					<xsl:attribute name="value">
						<xsl:value-of select="./coco:use"/>
					</xsl:attribute>
				</use>
				<!-- 0..1 Specify preferred order of use (1 = highest) -->
				<rank>
					<xsl:attribute name="value">
						<xsl:value-of select="position()"/>
					</xsl:attribute>
				</rank>
				<!-- 0..1 Period Time period when the contact point was/is in use -->
				<xsl:if test="coco:period">
					<xsl:element name="period">
						<xsl:if test="coco:period/coco:start">
							<xsl:element name="start">
								<xsl:attribute name="value">
									<xsl:value-of select="coco:period/coco:start"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<xsl:if test="coco:period/coco:end">
							<xsl:element name="end">
								<xsl:attribute name="value">
									<xsl:value-of select="coco:period/coco:end"/>
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
				<xsl:when test="starts-with(/coco:roster/coco:member/coco:gender, 'male')">male</xsl:when>
				<xsl:when test="starts-with(/coco:roster/coco:member/coco:gender, 'female')">female</xsl:when>
				<xsl:otherwise>unknown</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="patient_address">
		<xsl:for-each select="/coco:roster/coco:member/coco:addresses/coco:address">
			<address>
				<!-- 0..1 home | work | temp | old | billing - purpose of this address -->
				<!-- <use>
					<xsl:attribute name="value">
						<xsl:value-of select="lower-case(address_use)"/>
					</xsl:attribute>
				</use> -->
				<!-- 0..1 postal | physical | both -->
				<xsl:if test="./coco:type">
					<type>
						<xsl:attribute name="value">
							<xsl:value-of select="./coco:type"/>
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
				<xsl:for-each select="./coco:line">
					<line>
						<xsl:attribute name="value">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</line>
				</xsl:for-each>
				<!-- 0..1 Name of city, town etc. -->
				<xsl:if test="./coco:city">
					<city>
						<xsl:attribute name="value">
							<xsl:value-of select="./coco:city"/>
						</xsl:attribute>
					</city>
				</xsl:if>
				<!-- 0..1 District name (aka county) -->
				<xsl:if test="./coco:district">
					<district>
						<xsl:attribute name="value">
							<xsl:value-of select="./coco:district"/>
						</xsl:attribute>
					</district>
				</xsl:if>
				<!-- 0..1 Sub-unit of country (abbreviations ok) -->
				<xsl:if test="./coco:state">
					<state>
						<xsl:attribute name="value">
							<xsl:value-of select="./coco:state"/>
						</xsl:attribute>
					</state>
				</xsl:if>
				<!-- 0..1 Postal code for area -->
				<xsl:if test="./coco:postal_code">
					<postalCode>
						<xsl:attribute name="value">
							<xsl:value-of select="./coco:postal_code"/>
						</xsl:attribute>
					</postalCode>
				</xsl:if>
				<!-- 0..1 Country (e.g. can be ISO 3166 2 or 3 letter code) -->
				<country>
					<xsl:choose>
						<xsl:when test="./coco:country">
							<xsl:attribute name="value">
								<xsl:value-of select="./coco:country"/>
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="value">USA</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</country>
				<!-- 0..1 Period Time period when address was/is in use -->
				<xsl:if test="coco:period">
					<xsl:element name="period">
						<xsl:if test="coco:period/coco:start">
							<xsl:element name="start">
								<xsl:attribute name="value">
									<xsl:value-of select="coco:period/coco:start"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<xsl:if test="coco:period/coco:end">
							<xsl:element name="end">
								<xsl:attribute name="value">
									<xsl:value-of select="coco:period/coco:end"/>
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
					<xsl:value-of select="/coco:roster/coco:member/coco:marital_status_system"/>
				</xsl:attribute>
			</system>
			<!-- 0..1 Version of the system - if relevant -->
			<version>
				<xsl:attribute name="value">
					<xsl:value-of select="/coco:roster/coco:member/coco:marital_status_version"/>
				</xsl:attribute>
			</version>
			<!-- 0..1 Symbol in syntax defined by the system -->
			<code>
				<xsl:attribute name="value">
					<xsl:value-of select="/coco:roster/coco:member/coco:marital_status_code"/>
				</xsl:attribute>
			</code>
			<!-- 0..1 Representation defined by the system -->
			<display>
				<xsl:attribute name="value">
					<xsl:value-of select="/coco:roster/coco:member/coco:marital_status_display"/>
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
				<xsl:value-of select="/coco:roster/coco:member/coco:marital_status_text"/>
			</xsl:attribute>
		</text>
	</xsl:template>

	<xsl:template name="patient_contact">
		<xsl:for-each select="/coco:roster/coco:member/coco:member_contacts/coco:member_contact">
			<!-- 0..* A contact party (e.g. guardian, partner, friend) for the patient -->
			<contact>
				<!-- 0..* CodeableConcept The kind of relationship -->
				<relationship/>
				<!-- 0..1 HumanName A name associated with the contact person -->
				<name>
					<text>
						<xsl:attribute name="value">
							<xsl:value-of select="coco:first_name"/>&#160;<xsl:value-of
								select="coco:last_name"/>
						</xsl:attribute>
					</text>
				</name>
				<!-- 0..* ContactPoint A contact detail for the person -->
				<telecom>
					<xsl:attribute name="value">
						<xsl:value-of select="coco:phones/coco:phone/coco:phone_number"/>
					</xsl:attribute>
				</telecom>
				<!-- 0..1 Address Address for the contact person -->
				<address>
					<line>
						<xsl:attribute name="value">
							<xsl:value-of select="coco:addresses/coco:address/coco:address_line_1"/>
						</xsl:attribute>
					</line>
					<city>
						<xsl:attribute name="value">
							<xsl:value-of select="coco:addresses/coco:address/coco:city"/>
						</xsl:attribute>
					</city>
					<district>
						<xsl:attribute name="value">
							<xsl:value-of select="coco:addresses/coco:address/coco:county"/>
						</xsl:attribute>
					</district>
					<state>
						<xsl:attribute name="value">
							<xsl:value-of select="coco:addresses/coco:address/coco:state"/>
						</xsl:attribute>
					</state>
					<postalcode>
						<xsl:attribute name="value">
							<xsl:value-of select="coco:addresses/coco:address/coco:zip_code"/>
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
				<xsl:if test="coco:period">
					<xsl:element name="period">
						<xsl:if test="coco:period/coco:start">
							<xsl:element name="start">
								<xsl:attribute name="value">
									<xsl:value-of select="coco:period/coco:start"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<xsl:if test="coco:period/coco:end">
							<xsl:element name="end">
								<xsl:attribute name="value">
									<xsl:value-of select="coco:period/coco:end"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:if>
			</contact>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="patient_communication">
		<xsl:for-each select="/coco:roster/coco:member/coco:communications/coco:communication">
			<communication>
				<language>
					<xsl:choose>
						<xsl:when test="./coco:language_code != 'NO_MATCHING_language_code'">
							<coding>
								<system value="urn:ietf:bcp:47"/>
								<!--     IETF language tag     -->
								<code>
									<xsl:attribute name="value">
										<xsl:value-of select="./coco:language_code"/>
									</xsl:attribute>
								</code>
								<display>
									<xsl:attribute name="value" select="./coco:display"/>
								</display>
							</coding>
						</xsl:when>
						<xsl:otherwise>
							<text>
								<xsl:attribute name="value">
									<xsl:value-of select="./coco:display"/><!-- Change made for SHSI-342 but not tested -->
								</xsl:attribute>
							</text>
						</xsl:otherwise>
					</xsl:choose>
				</language>
				<preferred>
					<xsl:attribute name="value">
						<xsl:value-of select="./coco:is_preferred"/>
					</xsl:attribute>
				</preferred>
			</communication>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
