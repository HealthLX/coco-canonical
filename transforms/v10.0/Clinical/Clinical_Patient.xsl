<xsl:stylesheet xpath-default-namespace="http://cocodata.org" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://hl7.org/fhir">
	<xsl:preserve-space elements="*"/>
	<xsl:variable name="PTT_MEMBER_DEMOGRAPHICS" select="/clinicals/clinical"/>
	<xsl:variable name="PTT_MEMBER_ADDRESS" select="/clinicals/clinical/patient/addresses/address"/>
	<xsl:variable name="PTT_GENDER">
		<xsl:value-of select="$PTT_MEMBER_DEMOGRAPHICS/patient/gender"/>
	</xsl:variable>
	<xsl:variable name="PTT_BIRTHDATE">
		<xsl:value-of select="$PTT_MEMBER_DEMOGRAPHICS/patient/birth_date"/>
	</xsl:variable>
	<xsl:variable name="CUSTOMER_PREFIX" select="clinicals/clinical/customername"/>
	<xsl:output method="xml" indent="yes"/>
	<xsl:template match="*">
		<Patient>
			<meta>
				<source>
					<xsl:attribute name="value">
						<xsl:value-of select="clinicals/clinical/parentfile"/>
					</xsl:attribute>
				</source>
				<profile value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"/>
			</meta>
			<id>
				<xsl:attribute name="value">
					<xsl:value-of select="concat($CUSTOMER_PREFIX, '-', $PTT_MEMBER_DEMOGRAPHICS/patient/unique_person_id)"/>
				</xsl:attribute>
			</id>
			<!-- from DomainResource: text, contained, extension, and modifierExtension -->
		
			<extension url="http://hl7.org/fhir/us/core/StructureDefinition/us-core-race">
				<extension url="ombCategory">
					<valueCoding>
						<system value="urn:oid:2.16.840.1.113883.6.238"/>
						<code>
							<xsl:attribute name="value">
								<xsl:value-of
									select="$PTT_MEMBER_DEMOGRAPHICS/patient/us_core_race/detailed_code[1]"
								/>
							</xsl:attribute>
						</code>
						<display>
							<xsl:attribute name="value">
								<xsl:value-of
									select="$PTT_MEMBER_DEMOGRAPHICS/patient/us_core_race/text"/>
							</xsl:attribute>
						</display>
					</valueCoding>
				</extension>
				
				<extension url="text">
					<valueString>
						<xsl:attribute name="value">
							<xsl:value-of
								select="$PTT_MEMBER_DEMOGRAPHICS/patient/us_core_race/omb_category_code[1]"
							/>
						</xsl:attribute>
					</valueString>
				</extension>
			</extension>
			<extension url="http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity">
				<extension url="ombCategory">
					<valueCoding>
						<system value="urn:oid:2.16.840.1.113883.6.238"/>
						<code>
							<xsl:attribute name="value">
								<xsl:value-of
									select="$PTT_MEMBER_DEMOGRAPHICS/patient/us_core_ethnicity/detailed_code[1]"
								/>
							</xsl:attribute>
						</code>
						<display>
							<xsl:attribute name="value">
								<xsl:value-of
									select="$PTT_MEMBER_DEMOGRAPHICS/patient/us_core_ethnicity/text"
								/>
							</xsl:attribute>
						</display>
					</valueCoding>
				</extension>
				<extension url="text">
					<valueString>
						<xsl:attribute name="value">
							<xsl:value-of
								select="$PTT_MEMBER_DEMOGRAPHICS/patient/us_core_ethnicity/omb_category_code[1]"
							/>
						</xsl:attribute>
					</valueString>
				</extension>
			</extension>
			<xsl:call-template name="ptt_text_identifier_patient"/>
			<active value="true"/>
			<xsl:call-template name="ptt_patient_given_name"/>
			<xsl:call-template name="ptt_telcom"/>
			<gender>
				<xsl:call-template name="ptt_gender"/>
			</gender>
			<birthDate>
				<xsl:call-template name="ptt_birthdate"/>
			</birthDate>
			<xsl:call-template name="ptt_address"/>
			<!-- <maritalstatus> <!-\-Need to move the logic into SQL to determine marital status based on FHIR code-\-> <xsl:attribute name="value"> <xsl:value-of select="upper-case($PTT_MEMBER_DEMOGRAPHICS/marital_status_id)"/> </xsl:attribute> </maritalstatus>-->
			<xsl:call-template name="ptt_contact"/>
			<xsl:for-each select="$PTT_MEMBER_DEMOGRAPHICS/communications/communication">
				<communication>
					<language>
						<coding>
							<system value="urn:ietf:bcp:47"/>
							<!-- IETF language tag -->
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
					</language>
					<preferred>
						<xsl:attribute name="value">
							<xsl:value-of select="./is_preferred"/>
						</xsl:attribute>
					</preferred>
				</communication>
			</xsl:for-each>
		</Patient>
	</xsl:template>
	<xsl:template name="ptt_patient_given_name">
		<xsl:for-each select="$PTT_MEMBER_DEMOGRAPHICS/patient/names/name">
			<name>
				<family>
					<xsl:attribute name="value">
						<xsl:value-of select="./family"/>
					</xsl:attribute>
				</family>
				<given>
					<xsl:attribute name="value">
						<xsl:value-of select="./given"/>
					</xsl:attribute>
				</given>
			</name>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="ptt_address">
		<xsl:for-each select="$PTT_MEMBER_ADDRESS">
			<address>
				<type>Phisical</type>
				<line>
					<xsl:attribute name="value">
						<xsl:value-of select="./line"/>
					</xsl:attribute>
				</line>
				<city>
					<xsl:attribute name="value">
						<xsl:value-of select="./city"/>
					</xsl:attribute>
				</city>
				<district>
					<xsl:attribute name="value">
						<xsl:value-of select="./district"/>
					</xsl:attribute>
				</district>
				<state>
					<xsl:attribute name="value">
						<xsl:value-of select="./state"/>
					</xsl:attribute>
				</state>
				<postalCode>
					<xsl:attribute name="value">
						<xsl:value-of select="./postal_code"/>
					</xsl:attribute>
				</postalCode>
				<country>
					<xsl:attribute name="value">
						<xsl:value-of select="./country"/>
					</xsl:attribute>
				</country>
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
			</address>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="ptt_gender">
		<xsl:attribute name="value">
			<xsl:choose>
				<xsl:when test="starts-with($PTT_GENDER, 'male')">male</xsl:when>
				<xsl:when test="starts-with($PTT_GENDER, 'female')">female</xsl:when>
				<xsl:otherwise>unknown</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
	<xsl:template name="ptt_birthdate">
		<xsl:attribute name="value">
			<xsl:value-of select="$PTT_BIRTHDATE"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template name="ptt_meta_security_patient">
		<profile value="http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"/>
		<security>
			<system value="http://terminology.hl7.org/CodeSystem/v3-ActReason"/>
			<code>
				<xsl:attribute name="value">
					<xsl:value-of select="/eob/type"/>
				</xsl:attribute>
			</code>
			<display>
				<xsl:attribute name="value">
					<xsl:value-of select="/eob/sub_type"/>
				</xsl:attribute>
			</display>
		</security>
	</xsl:template>
	<xsl:template name="ptt_text_identifier_patient">
		<identifier>
			<use value="usual"/>
			<type>
				<coding>
					<system value="http://terminology.hl7.org/CodeSystem/v2-0203"/>
					<code value="MR"/>
					<display value="Medical Record Number"/>
				</coding>
			</type>
			<system>
				<xsl:attribute name="value">
					<xsl:value-of select="$PTT_MEMBER_DEMOGRAPHICS/patient/unique_person_id"/>
				</xsl:attribute>
			</system>
			<value>
				<xsl:attribute name="value">
					<xsl:call-template name="ptt_text_identifier_patient_patient"/>
				</xsl:attribute>
			</value>
		</identifier>
	</xsl:template>
	<xsl:template name="ptt_text_identifier_patient_patient">
		<xsl:value-of select="$PTT_MEMBER_DEMOGRAPHICS/patient/unique_person_id"/>
	</xsl:template>
	<xsl:template name="ptt_telcom">
		<xsl:for-each select="$PTT_MEMBER_DEMOGRAPHICS/patient/telecoms/telecom">
			<telecom>
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
			</telecom>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="ptt_contact">
		<xsl:for-each select="/member/member_contacts/member_contact"><!-- Not in source -->
			<contact>
				<!-- 0..* A contact party (e.g. guardian, partner, friend) for the patient -->
				<relationship><!-- 0..* CodeableConcept The kind of relationship -->
				</relationship>
				<name>
					<text>
						<!-- 0..1 HumanName A name associated with the contact person -->
						<xsl:attribute name="value"><xsl:value-of select="first_name"
								/>&#160;<xsl:value-of select="last_name"/></xsl:attribute>
					</text>
				</name>
				<telecom>
					<!-- 0..* ContactPoint A contact detail for the person -->
					<xsl:attribute name="value">
						<xsl:value-of select="phones/phone/phone_number"/>
					</xsl:attribute>
				</telecom>
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
				<gender/>
				<organization><!-- ?? 0..1 Reference(Organization) Organization that is associated with the contact --></organization>
				<period><!-- 0..1 Period The period during which this contact person or organization is valid to be contacted relating to this patient --></period>
			</contact>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
