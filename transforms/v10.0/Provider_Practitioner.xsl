<xsl:stylesheet version="3.0"
	xmlns="http://hl7.org/fhir"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:coco="http://cocodata.org"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xpath-default-namespace="http://cocodata.org"
	exclude-result-prefixes="coco">
	<xsl:preserve-space elements="*"/>
	<xsl:output indent="yes" method="xml"/>
	<xsl:variable name="POG_PROVIDER" select="provider"/>
	<xsl:variable name="POG_CUSTOMER_PREFIX" select="$POG_PROVIDER/customername"/>
	<xsl:variable name="POG_CLIA" select="$POG_PROVIDER/practitioner/clia"/>
	<xsl:variable name="POG_NPI" select="$POG_PROVIDER/practitioner/npi"/>
	<xsl:variable name="POG_UNIQUE_ID" select="$POG_PROVIDER/practitioner/unique_identifier"/>

	<!-- Main resource template structure -->
	<xsl:template match="*">
		<!-- https://www.hl7.org/fhir/practitioner.html -->
		<Practitioner>
			<xsl:call-template name="resource_id"/>


			<xsl:call-template name="resource_meta"/>

			<!-- 0..* Identifier An identifier for the person as this agent -->
			<xsl:call-template name="resource_identifier"/>



			<!-- 0..1 Whether this practitioner's record is in active use -->
			<active>
				<xsl:attribute name="value">
					<xsl:value-of select="$POG_PROVIDER/practitioner/is_active"/>
				</xsl:attribute>
			</active>

			<!-- 0..* HumanName The name(s) associated with the practitioner -->
			<xsl:call-template name="Practitioner_name"/>




			<!-- 0..* ContactPoint A contact detail for the practitioner (that apply to all roles) -->
			<xsl:call-template name="practitioner_telecom"/>

			<!-- 0..1 male | female | other | unknown -->
			<gender>
				<xsl:attribute name="value">
					<xsl:value-of select="$POG_PROVIDER/practitioner/gender"/>
				</xsl:attribute>
			</gender>

			<!-- 0..* Address Address(es) of the practitioner that are not role specific (typically home address) -->

			<xsl:call-template name="Practitioner_address"/>


			<!-- ********* MAPPINGS NOT IMPLEMENTED below this comment ********* -->

			<!-- 0..1 The date  on which the practitioner was born -->
			<!-- <birthDate>
				<xsl:attribute name="value">
					<xsl:value-of select="/practitioner/birthDate"/>
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

			<xsl:call-template name="Practitioner_Communication"/>
		</Practitioner>
	</xsl:template>

	<!-- Subtemplates -->
	<xsl:template name="resource_meta">
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
							<xsl:value-of select="$POG_NPI"/>
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
							<xsl:value-of select="concat($POG_CUSTOMER_PREFIX, '-', $POG_UNIQUE_ID)"/>
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
						<xsl:value-of select="$POG_CLIA"/>
					</xsl:attribute>
				</value>
			</identifier>
		</xsl:if>
	
	</xsl:template>

	<xsl:template name="resource_id">
		<xsl:variable name="CODE">
			<xsl:choose>
				<xsl:when test="$POG_UNIQUE_ID">
					<xsl:value-of select="$POG_UNIQUE_ID"/>
				</xsl:when>
				<xsl:when test="$POG_NPI">
					<xsl:value-of select="$POG_NPI"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$POG_CLIA"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<id>
			<xsl:attribute name="value">
				<xsl:value-of select="concat($POG_CUSTOMER_PREFIX, '-', $CODE)"	/>
			</xsl:attribute>
		</id>



	</xsl:template>

	<xsl:template name="Practitioner_name">
		<xsl:for-each select="$POG_PROVIDER/practitioner/names/name">
			<!-- 0..* HumanName The name(s) associated with the practitioner -->
			<name>
				<!-- 0..1 usual | official | temp | nickname | anonymous | old | maiden -->
				<use>
					<xsl:attribute name="value">
						<xsl:value-of select="./use"/>
					</xsl:attribute>
				</use>

				<!-- 0..1 Text representation of the full name -->
				<text>
					<xsl:attribute name="value">
						<xsl:value-of select="./text"/>
					</xsl:attribute>
				</text>

				<!-- 0..1 Family name (often called 'Surname') -->
				<family>
					<xsl:attribute name="value">
						<xsl:value-of select="./family"/>
					</xsl:attribute>
				</family>

				<!-- 0..* Given names (not always 'first'). Includes middle names -->
				<xsl:for-each select="./given">
					<given>
						<xsl:attribute name="value">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</given>
				</xsl:for-each>

				<!-- 0..* Parts that come before the name -->
				<xsl:for-each select="./prefix">
					<prefix>
						<xsl:attribute name="value">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</prefix>
				</xsl:for-each>

				<!-- 0..* Parts that come after the name -->
				<xsl:for-each select="./suffix">
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
		<xsl:for-each select="$POG_PROVIDER/practitioner/telecoms/telecom">
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
				<xsl:if test="use">
					<!-- 0..1 home | work | temp | old | mobile - purpose of this contact point -->
					<use>
						<xsl:attribute name="value">
							<xsl:value-of select="use"/>
						</xsl:attribute>
					</use>
				</xsl:if>
				<xsl:if test="rank">
					<!-- 0..1 Specify preferred order of use (1 = highest) -->
					<rank>
						<xsl:attribute name="value">
							<xsl:value-of select="rank"/>
						</xsl:attribute>
					</rank>
				</xsl:if>
				<xsl:if test="period/start or period/end">
					<!-- 0..1 Period Time period when the contact point was/is in use -->
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
		<xsl:for-each select="$POG_PROVIDER/practitioner/addresses/address">
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

	<xsl:template name="Practitioner_Communication">
		<!-- 0..* Address Address(es) of the practitioner that are not role specific (typically home address) -->
		<xsl:for-each select="$POG_PROVIDER/practitioner/addresses">

			<xsl:if test="./communications/communication">
				<xsl:for-each select="./communications/communication">
					<communication>
						<xsl:if test="not(contains($POG_CUSTOMER_PREFIX, 'NASCENTIA'))">
						<extension
							url="http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/communication-proficiency">
							<valueCodeableConcept>
								<coding>
									<system
										value="http://hl7.org/fhir/us/davinci-pdex-plan-net/CodeSystem/LanguageProficiencyCS"/>
									<code value="30"/>
								</coding>
							</valueCodeableConcept>
						</extension>
							</xsl:if>
						<coding>
							<xsl:choose>
								<xsl:when test="./language = 'English'">
									<system value="http://tools.ietf.org/html/bcp47"/>
									<code value="en"/>
									<display>
										<xsl:attribute name="value">
											<xsl:value-of select="./language"/>
										</xsl:attribute>

									</display>
								</xsl:when>
								<xsl:when test="./language = 'Spanish'">
									<system value="http://tools.ietf.org/html/bcp47"/>
									<code value="es"/>
									<display>
										<xsl:attribute name="value">
											<xsl:value-of select="./language"/>
										</xsl:attribute>

									</display>
								</xsl:when>
								<xsl:when test="./language = 'Chinese'">
									<system value="http://tools.ietf.org/html/bcp47"/>
									<code value="zh"/>
									<display>
										<xsl:attribute name="value">
											<xsl:value-of select="./language"/>
										</xsl:attribute>

									</display>
								</xsl:when>
								<xsl:when test="./language = 'Japanese'">
									<system value="http://tools.ietf.org/html/bcp47"/>
									<code value="ja"/>
									<display>
										<xsl:attribute name="value">
											<xsl:value-of select="./language"/>
										</xsl:attribute>

									</display>
								</xsl:when>
								<xsl:when test="./language = 'Korean'">
									<system value="http://tools.ietf.org/html/bcp47"/>
									<code value="ko"/>
									<display>
										<xsl:attribute name="value">
											<xsl:value-of select="./language"/>
										</xsl:attribute>

									</display>
								</xsl:when>
								<xsl:otherwise>
									<system>
										<xsl:attribute name="value">
											<!--
											<xsl:value-of select="'Not_Found'"/>-->
											<xsl:value-of
												select="concat('https://data.healthlx.com/', $POG_CUSTOMER_PREFIX, '-language')"
											/>
										</xsl:attribute>
									</system>
									<code value="unknown"/>
									<display>
										<xsl:attribute name="value">
											<xsl:value-of select="'Not_Found'"/>
										</xsl:attribute>

									</display>
								</xsl:otherwise>
							</xsl:choose>


						</coding>

					</communication>
				</xsl:for-each>

			</xsl:if>


		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
