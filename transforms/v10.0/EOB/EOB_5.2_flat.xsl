<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://cocodata.org" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="EOB_DEMOGRAPHIC" select="EOB"/>
    <xsl:variable name="EOB_DATE" select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
    <xsl:template match="/">
        <xsl:for-each select="$EOB_DEMOGRAPHIC">
            <eob>
                <eob_identifier>
                    <value>
                        <xsl:value-of select="./Header/ClaimNumber"/>
                    </value>
                    <type>uc</type>
                </eob_identifier>
                <status>
                    <xsl:value-of select="'active'"/>
                </status>
                <type>
                    <xsl:value-of select="lower-case(./Header/ClaimType)"/>
                </type>
                <sub_type>
                    <xsl:value-of select="./Header/ClaimSubtype"/>
                </sub_type>
                <use>
                    <xsl:value-of select="'claim'"/>
                </use>

                <billable_period>

                    <xsl:variable name="START-DATE"
                        select="./BillingDates[position() = 1]/BillableEndDate"/>
                    <xsl:variable name="END-DATE"
                        select="./BillingDates[position() = 1]/BillableEndDate"/>

                    <start>

                        <!-- <xsl:value-of select="concat(substring($START-DATE, 5, 4), '-', substring($START-DATE, 1, 2), '/', substring($START-DATE, 1, 4))" />
                        -->
                        <xsl:value-of
                            select="substring(./BillingDates[position() = 1]/BillableStartDate, 1, 10)"
                        />
                    </start>
                    <end>
                        <xsl:value-of
                            select="substring(./BillingDates[position() = 1]/BillableEndDate, 1, 10)"
                        />
                    </end>
                </billable_period>
                <created>
                    <xsl:choose>
                        <xsl:when test="5 > string-length(./BillingDates[position() = 1]/ClaimCreatedDate)">
                            <xsl:value-of
                                select="substring(./BillingDates[position() = 1]/BillableStartDate, 1, 10)"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="./BillingDates[position() = 1]/ClaimCreatedDate"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </created>
                <outcome>complete</outcome>
                <claim>

                    <identifier>
                        <value>
                            <xsl:value-of select="./Header/ClaimNumber"/>
                        </value>
                        <type>
                            <xsl:value-of select="'DCN'"/>
                        </type>
                    </identifier>

                    <created>
                        <xsl:value-of
                            select="substring(./BillingDates[position() = 1]/BillableStartDate, 1, 10)"
                        />
                    </created>
                </claim>
                <patient>

                    <pat_acct_num>
                        <xsl:value-of select="./Header/UniquePersonID"/>
                    </pat_acct_num>
                    <unique_member_id>
                        <xsl:value-of select="./Header/UniquePersonID"/>
                    </unique_member_id>
                    <person>
                        <member_id>
                            <xsl:value-of select="./Header/ClaimMemberId"/>
                        </member_id>
                        <member_id_system>
                            <xsl:value-of select="./Header/UniquePersonIdAssigner"/>
                        </member_id_system>
                        <subscriber_id>
                            <xsl:value-of select="./Header/ClaimSubscriberId"/>
                        </subscriber_id>
                        <unique_person_id>
                            <xsl:value-of select="./Header/UniquePersonID"/>
                        </unique_person_id>
                        <unique_person_id_assigner>
                            <xsl:value-of select="./Header/UniquePersonIdAssigner"/>
                        </unique_person_id_assigner>
                        <unique_person_id_assigner_type>
                            <xsl:value-of select="./Header/UniquePersonIdAssignerType"/>
                        </unique_person_id_assigner_type>
                        <names>

                            <name>
                                <use>
                                    <xsl:value-of select="'official'"/>

                                </use>
                                <text> </text>
                                <family>

                                    <xsl:value-of select="./Header/ClaimPatientFamilyName"/>
                                </family>

                                <given>
                                    <xsl:value-of select="./Header/ClaimPatientGivenName"/>
                                </given>

                            </name>

                        </names>

                        <gender>
                            <xsl:value-of select="./Address/MemberGender"/>
                        </gender>
                        <birth_date>
                            <xsl:value-of select="./Address/PatientDOB"/>
                        </birth_date>
                        <telecoms> </telecoms>
                        <addresses>

                            <address>
                                <use>
                                    <xsl:value-of select="'home'"/>
                                </use>
                                <type>
                                    <xsl:value-of select="'physical'"/>

                                </type>

                                <line>
                                    <xsl:value-of select="./Address/MemberAddress"/>
                                </line>
                                <city>
                                    <xsl:value-of select="./Address/MemberCity"/>
                                </city>
                                <district> </district>
                                <state>
                                    <xsl:value-of select="./Address/MemberState"/>
                                </state>
                                <postal_code>
                                    <xsl:value-of select="./Address/MemberZipCode"/>
                                </postal_code>
                                <country>
                                    <xsl:value-of select="'USA'"/>
                                </country>
                                <period>
                                    <start> </start>
                                </period>
                            </address>

                        </addresses>

                    </person>
                </patient>
                <insurer>
                    <npi>
                        <!--    <xsl:value-of select="./insurer/npi"/>-->
                    </npi>
                    <clia>
                        <!--  <xsl:value-of select="./insurer/clia"/>-->
                        <xsl:value-of select="normalize-space(./Providers[1]/InsurerName)"/>

                    </clia>
                    <is_active>
                        <xsl:value-of select="./Providers[1]/IsInsurerActive"/>
                    </is_active>
                    <name>
                        <xsl:value-of select="./Providers[1]/InsurerName"/>
                    </name>
                </insurer>
                <provider>
                    <xsl:choose>
                        <xsl:when test="./Header/ClaimType = 'Institutional'">
                            <xsl:call-template name="pog_telcom_provider_organization"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="pog_telcom_provider_practitioner"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </provider>
                <facility>
                    <!--  <identifier>
                        <value>
                            <xsl:value-of select="./facility/identifier/value"/>
                        </value>
                        <type>
                            <xsl:value-of select="./facility/identifier/type"/>
                        </type>
                    </identifier>
                    <name>
                        <xsl:value-of select="./facility/name"/>
                    </name>
                    <telecoms>
                        <xsl:for-each select="./facility/telecoms/telecom">
                            <telecom>
                                <system>
                                    <xsl:value-of select="./system"/>
                                </system>
                                <value>
                                    <xsl:value-of select="./value"/>
                                </value>
                                <use>
                                    <xsl:value-of select="./use"/>
                                </use>
                                <period>
                                    <start>
                                        <xsl:value-of select="./period/start"/>
                                    </start>
                                </period>
                            </telecom>
                        </xsl:for-each>
                    </telecoms>

                    <address>
                        <use>
                            <xsl:value-of select="./facility/address/use"/>
                        </use>
                        <type>
                            <xsl:value-of select="./facility/address/type"/>

                        </type>
                        <text>
                            <xsl:value-of select="./facility/address/text"/>

                        </text>
                        <line>
                            <xsl:value-of select="./facility/address/line"/>
                        </line>
                        <line>
                            <xsl:value-of select="./facility/address/line"/>
                        </line>
                        <city>
                            <xsl:value-of select="./facility/address/city"/>
                        </city>
                        <state>
                            <xsl:value-of select="./facility/address/state"/>
                        </state>
                        <postal_code>
                            <xsl:value-of select="./facility/address/postal_code"/>
                        </postal_code>
                        <country>
                            <xsl:value-of select="./facility/address/country"/>
                        </country>
                        <period>
                            <start>
                                <xsl:value-of select="./facility/address/period/start"/>
                            </start>
                        </period>
                    </address>-->
                </facility>
                <payee>
                    <type>
                        <code>
                            <xsl:value-of select="./Payees[1]/PayeeCode"/>
                        </code>
                        <system>
                            <xsl:value-of select="./Payees[1]/PayeeType"/>
                        </system>
                    </type>
                    <party>
                        <providing_organization>
                            <npi>
                                <!--                  <xsl:value-of select="./payee/party/providing_organization/npi"/>
              -->
                            </npi>

                            <clia>
                                <xsl:value-of select="translate(./Payees[1]/Party, ' ', '')"/>
                            </clia>
                            <is_active>
                                <xsl:value-of select="'True'"/>

                            </is_active>
                            <name>
                                <xsl:value-of select="./Payees[1]/Party"/>

                            </name>

                        </providing_organization>
                    </party>
                </payee>
                <care_teams>

                    <xsl:for-each select="./care_teams/care_team">

                        <care_team>
                            <sequence>
                                <xsl:value-of select="./sequence"/>
                            </sequence>
                            <is_responsible>
                                <xsl:value-of select="./is_responsible"/>
                            </is_responsible>
                            <provider>
                                <providing_organization>
                                    <npi>
                                        <xsl:value-of select="./provider/providing_organization/npi"
                                        />
                                    </npi>
                                    <clia>
                                        <xsl:value-of
                                            select="./provider/providing_organization/clia"/>
                                    </clia>
                                    <is_active>
                                        <xsl:value-of
                                            select="./provider/providing_organization/is_active"/>

                                    </is_active>
                                    <name>
                                        <xsl:value-of
                                            select="./provider/providing_organization/name"/>

                                    </name>
                                    <telecoms>
                                        <xsl:for-each
                                            select="./provider/providing_organization/telecoms/telecom">
                                            <telecom>
                                                <system>
                                                  <xsl:value-of select="./system"/>
                                                </system>
                                                <value>
                                                  <xsl:value-of select="./value"/>
                                                </value>
                                                <use>
                                                  <xsl:value-of select="./use"/>
                                                </use>
                                                <period>
                                                  <start>
                                                  <xsl:value-of select="./period/start"/>
                                                  </start>
                                                </period>
                                            </telecom>
                                        </xsl:for-each>
                                    </telecoms>


                                    <addresses>
                                        <xsl:for-each
                                            select="./provider/providing_organization/addresses/address">
                                            <address>
                                                <use>
                                                  <xsl:value-of select="./use"/>
                                                </use>
                                                <xsl:if test="./type">
                                                  <type>
                                                  <xsl:value-of select="./type"/>

                                                  </type>
                                                </xsl:if>
                                                <text>
                                                  <xsl:value-of select="./text"/>

                                                </text>
                                                <line>
                                                  <xsl:value-of select="./line"/>
                                                </line>
                                                <city>
                                                  <xsl:value-of select="./city"/>
                                                </city>
                                                <state>
                                                  <xsl:value-of select="./state"/>
                                                </state>
                                                <postal_code>
                                                  <xsl:value-of select="./postal_code"/>
                                                </postal_code>
                                                <country>
                                                  <xsl:value-of select="./country"/>
                                                </country>
                                                <period>
                                                  <start>
                                                  <xsl:value-of select="./period/start"/>
                                                  </start>
                                                </period>

                                            </address>
                                        </xsl:for-each>
                                    </addresses>
                                </providing_organization>
                            </provider>
                            <role>
                                <code>
                                    <xsl:value-of select="./role/code"/>
                                </code>
                                <system>
                                    <xsl:value-of select="./role/system"/>
                                </system>
                            </role>
                        </care_team>
                    </xsl:for-each>
                </care_teams>


                <diagnoses>
                    <xsl:variable name="diagnosisCodes" select="0"/>
                    <xsl:for-each
                        select="./DiagnosisCodes/*[name() != 'ClaimLineNumber' and text() != '']">

                        <diagnosis>
                            <xsl:if test="name() != 'ClaimLineNumber'">
                                <xsl:if test=". != ''">
                                    <xsl:variable name="i" select="position()"/>
                                    <sequence>
                                        <xsl:value-of select="$i"/>
                                    </sequence>

                                    <diagnosis_code>
                                        <coding>
                                            <code>
                                                <xsl:value-of select="."/>
                                            </code>
                                            <version>
                                                <xsl:value-of select="'ICD-10'"/>
                                            </version>
                                            <!--<display>
                                        <xsl:value-of select="./diagnosis_code/coding/display"/>
                                    </display>-->
                                        </coding>
                                    </diagnosis_code>

                                    <type>
                                        <code>
                                            <!--    <xsl:value-of select="./type/code"/>-->
                                        </code>
                                    </type>
                                    <on_admission>
                                        <!-- <code>
                                    <xsl:value-of select="./on_admission/code"/>
                                </code>
                                <system>
                                    <xsl:value-of select="./on_admission/system"/>
                                </system>-->
                                        <xsl:choose>
                                            <xsl:when test="./Relationships/OnAdmission = ''">
                                                <code>U</code>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <code>
                                                  <xsl:value-of select="./Relationships/OnAdmission"/>

                                                </code>
                                            </xsl:otherwise>
                                        </xsl:choose>




                                        <system>https://www.nubc.org/CodeSystem/PresentOnAdmissionIndicator</system>
                                    </on_admission>
                                </xsl:if>
                            </xsl:if>
                        </diagnosis>



                    </xsl:for-each>
                </diagnoses>
                <procedures>
                    <xsl:for-each select="./Procedure[name() != 'ClaimLineNumber' and text() != '']">

                        <procedure>
                            <xsl:variable name="i" select="position()"/>
                            <sequence>
                                <xsl:value-of select="$i"/>
                            </sequence>
                            <procedure_code>
                                <coding>
                                    <code>
                                        <xsl:value-of select="./ProcedureCode"/>
                                    </code>
                                    <system>
                                        <system>urn:oid:2.16.840.1.113883.6.285</system>
                                    </system>
                                    <version>
                                        <xsl:value-of select="./ProcedureCodeType"/>
                                    </version>
                                    <display>
                                        <xsl:value-of select="./Display"/>
                                    </display>
                                </coding>
                            </procedure_code>
                            <type>
                                <!-- <xsl:value-of select="./ProcedureCodeType"/>-->
                            </type>
                            <!--  <date>
                                <xsl:value-of select="./date"/>
                            </date>-->
                        </procedure>
                    </xsl:for-each>
                </procedures>
                <insurances>
                    <insurance>
                        <is_focal>
                            <xsl:value-of select="'true'"/>
                        </is_focal>
                        <coverage>

                            <identifier>
                                <value>
                                    <xsl:value-of select="./Header/UniquePersonIdAssigner"/>
                                </value>
                                <type>
                                    <xsl:value-of select="./Header/ClaimIdentifierType"/>
                                </type>
                            </identifier>
                            <payor>
                                <is_active>
                                    <is_active>true</is_active>
                                </is_active>
                                <name>
                                    <xsl:value-of select="./Header/UniquePersonIdAssigner"/>
                                </name>
                            </payor>
                            <type>
                                <xsl:value-of select="./Header/UniquePersonIdAssignerType"/>
                            </type>
                            <relationship>
                                <xsl:value-of select="./Relationships/MemberRelationShip"/>
                            </relationship>
                            <period>
                                <start>
                                    <!-- <xsl:value-of select="./coverage/period/start"/>-->
                                </start>
                            </period>
                            <beneficiary>
                                <member_id>
                                    <xsl:value-of select="./Header/ClaimMemberId"/>
                                </member_id>
                                <subscriber_id>
                                    <xsl:value-of select="./Relationships/SubscriberMemberID"/>

                                </subscriber_id>
                                <unique_person_id>
                                    <xsl:value-of select="./Header/UniquePersonID"/>
                                </unique_person_id>
                                <unique_person_id_assigner>
                                    <xsl:value-of select="./Header/UniquePersonIdAssigner"/>
                                </unique_person_id_assigner>
                                <unique_person_id_assigner_type>
                                    <xsl:value-of select="./Header/UniquePersonIdAssignerType"/>
                                </unique_person_id_assigner_type>
                                <names>

                                    <name>
                                        <use>official</use>

                                        <family>
                                            <xsl:value-of select="./Header/ClaimPatientFamilyName"/>
                                        </family>

                                        <given>
                                            <xsl:value-of select="./Header/ClaimPatientGivenName"/>
                                        </given>

                                    </name>

                                </names>
                                <gender>
                                    <xsl:value-of select="./Address/MemberGender"/>
                                </gender>
                                <birth_date>
                                    <xsl:value-of select="./Address/PatientDOB"/>
                                </birth_date>
                                <telecoms>
                                    <!-- <xsl:for-each
                                            select="./coverage/beneficiary/telecoms/telecom">
                                            <telecom>
                                                <system>
                                                  <xsl:value-of select="./system"/>
                                                </system>
                                                <value>
                                                  <xsl:value-of select="./value"/>
                                                </value>
                                                <use>
                                                  <xsl:value-of select="./use"/>
                                                </use>
                                                <period>
                                                  <start>
                                                  <xsl:value-of select="./period/start"/>
                                                  </start>
                                                </period>
                                            </telecom>
                                        </xsl:for-each>-->
                                </telecoms>
                                <addresses>

                                    <address>
                                        <use>official</use>
                                        <!-- <xsl:if test="./type">
                                                  <type>
                                                  <xsl:value-of select="./type"/>

                                                  </type>
                                                </xsl:if>-->
                                        <!--<text>
                                                  <xsl:value-of select="./text"/>

                                                </text>-->
                                        <line>
                                            <xsl:value-of select="./Address/MemberAddress"/>
                                        </line>
                                        <city>
                                            <xsl:value-of select="./Address/MemberCity"/>
                                        </city>
                                        <state>
                                            <xsl:value-of select="./Address/MemberState"/>
                                        </state>
                                        <postal_code>
                                            <xsl:value-of select="./Address/MemberZipCode"/>
                                        </postal_code>
                                        <!--<country>
                                                  <xsl:value-of select="./country"/>
                                                </country>-->
                                        <!--<period>
                                                  <start>
                                                  <xsl:value-of select="./period/start"/>
                                                  </start>
                                                </period>-->

                                    </address>

                                </addresses>
                                <communications>
                                    <!--  <xsl:for-each
                                            select="./coverage/beneficiary/communications/communication">
                                            <communication>
                                                <language>
                                                  <language_code>
                                                  <xsl:value-of select="./language/language_code"/>
                                                  </language_code>
                                                  <display>
                                                  <xsl:value-of select="./language/display"/>
                                                  </display>
                                                </language>
                                                <is_preferred>
                                                  <xsl:value-of select="./is_preferred"/>
                                                </is_preferred>
                                            </communication>
                                        </xsl:for-each>-->
                                </communications>
                                <!--  <us_core_race>
                                        <omb_category_code>
                                            <code>
                                                <xsl:value-of
                                                  select="./coverage/beneficiary/us_core_race/omb_category_code/code"/>

                                            </code>
                                        </omb_category_code>
                                        <text>
                                            <xsl:value-of
                                                select="./coverage/beneficiary/us_core_race/text"/>


                                        </text>
                                    </us_core_race>
                                    <us_core_ethnicity>
                                        <omb_category_code>
                                            <xsl:value-of
                                                select="./coverage/beneficiary/us_core_ethnicity/omb_category_code"/>


                                        </omb_category_code>
                                        <text>
                                            <xsl:value-of
                                                select="./coverage/beneficiary/us_core_ethnicity/text"
                                            />
                                        </text>
                                    </us_core_ethnicity>-->
                            </beneficiary>
                            <subscriber_id>
                                <xsl:value-of select="./Header/ClaimSubscriberId"/>
                            </subscriber_id>
                            <status>active</status>
                            <classes>
                                <class>
                                    <plan>
                                        <value>
                                            <xsl:value-of select="./Header/UniquePersonIdAssigner"/>
                                        </value>
                                        <name>
                                            <xsl:value-of select="./Header/UniquePersonIdAssigner"/>
                                        </name>
                                    </plan>
                                    <group>
                                        <value>
                                            <xsl:value-of select="./Header/UniquePersonIdAssigner"/>
                                        </value>
                                        <name>
                                            <xsl:value-of select="./Header/UniquePersonIdAssigner"/>
                                        </name>
                                    </group>
                                </class>

                            </classes>
                        </coverage>
                    </insurance>

                </insurances>
                <items>
                    <xsl:for-each select="./Revenues">
                        <item>
                            <sequence>
                                <xsl:value-of select="./ClaimLineNumber"/>
                            </sequence>
                            <!--<care_team_sequence>
                                <xsl:value-of select="./care_team_sequence"/>
                            </care_team_sequence>-->
                            <procedure_sequence>
                                <xsl:value-of select="./ClaimLineNumber"/>
                            </procedure_sequence>

                            <revenue>
                                <code>
                                    <xsl:value-of select="./Revenue"/>
                                </code>
                                <system>http://www.ama-assn.org/go/cpt</system>
                            </revenue>

                            <product_or_Service>
                                <xsl:if test="./ProcedureCode != ''">
                                    <code>
                                        <xsl:value-of select="./ProcedureCode"/>
                                    </code>
                                    <system>http://www.cms.gov/Medicare/Coding/HCPCSReleaseCodeSets</system>
                                </xsl:if>
                            </product_or_Service>
                            <serviced>
                                <serviced_date>
                                    <xsl:value-of select="./serviced/serviced_date"/>
                                </serviced_date>
                            </serviced>
                            <quantity>
                                <!-- <value>
                                    <xsl:value-of select="./quantity/value"/>
                                </value>
                                <unit>
                                    <xsl:value-of select="./value/unit"/>
                                </unit>-->
                            </quantity>
                            <net>
                                <value>
                                    <!--   <xsl:value-of select="./net/value"/>-->
                                </value>
                                <currency>
                                    <!--   <xsl:value-of select="./net/currency"/>-->
                                </currency>
                            </net>
                            <adjudications>

                                <adjudication>

                                    <adjudication_amount_type>
                                        <category>
                                            <code>submitted</code>
                                            <system>http://terminology.hl7.org/CodeSystem/adjudication</system>
                                        </category>
                                        <amount>
                                            <value>
                                                <xsl:value-of select="./SubmittedAmount"/>
                                            </value>
                                            <currency>USD</currency>
                                        </amount>
                                    </adjudication_amount_type>
                                    <adjudication_amount_type>
                                        <category>
                                            <code>copay</code>
                                            <system>http://terminology.hl7.org/CodeSystem/adjudication</system>
                                        </category>
                                        <amount>
                                            <value>
                                                <xsl:value-of select="./CoPayAmount"/>
                                            </value>
                                            <currency>USD</currency>
                                        </amount>
                                    </adjudication_amount_type>

                                    <adjudication_amount_type>
                                        <category>
                                            <code>deductible</code>
                                            <system>http://terminology.hl7.org/CodeSystem/adjudication</system>
                                        </category>
                                        <amount>
                                            <value>
                                                <xsl:value-of select="./DeductibleAmount"/>
                                            </value>
                                            <currency>USD</currency>
                                        </amount>
                                    </adjudication_amount_type>
                                     <adjudication_amount_type>
                                        <category>
                                            <code>eligible</code>
                                            <system>http://terminology.hl7.org/CodeSystem/adjudication</system>
                                        </category>
                                        <amount>
                                            <value>
                                                <xsl:value-of select="./AllowedAmount"/>
                                            </value>
                                            <currency>USD</currency>
                                        </amount>
                                    </adjudication_amount_type>
                                    <adjudication_amount_type>
                                        <category>
                                            <code>benefit</code>
                                            <system>http://terminology.hl7.org/CodeSystem/adjudication</system>
                                        </category>
                                        <amount>
                                            <value>
                                                <xsl:value-of select="./PaymentAmount"/>
                                            </value>
                                            <currency>USD</currency>
                                        </amount>
                                    </adjudication_amount_type>
                                    <adjudication_amount_type>
                                    <category>
                                        <code>memberliability</code>
                                        <system>http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudication</system>
                                    </category>
                                    <amount>
                                        <value>
                                            <xsl:value-of select="./PatientPayAmount"/>
                                        </value>
                                        <currency>USD</currency>
                                    </amount>
                                    </adjudication_amount_type>
                                    <adjudication_amount_type>
                                        <category>
                                            <code>coinsurance</code>
                                            <system>http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudication</system>
                                        </category>
                                        <amount>
                                            <value>
                                                <xsl:value-of select="./CoInsuranceAmount"/>
                                            </value>
                                            <currency>USD</currency>
                                        </amount>
                                    </adjudication_amount_type>
                                    <adjudication_amount_type>
                                        <category>
                                            <code>noncovered</code>
                                            <system>http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudication</system>
                                        </category>
                                        <amount>
                                            <value>
                                                <xsl:value-of select="./NonCoveredAmount"/>
                                            </value>
                                            <currency>USD</currency>
                                        </amount>
                                    </adjudication_amount_type>
                                    
                                    
                                     <allowed_units>
                                        <!--   <category>
                                                <code>
                                                  <xsl:value-of select="./category/code"/>
                                                </code>
                                                <system>
                                                  <xsl:value-of select="./category/system"/>
                                                </system>
                                            </category>
                                            <value>
                                                <xsl:value-of select="./value"/>
                                            </value>-->
                                    </allowed_units>


                                    <denial_reason>
                                        <code>
                                            <xsl:value-of select="./code"/>
                                        </code>
                                        <system>
                                            <xsl:value-of select="./system"/>
                                        </system>
                                        <reason>
                                            <code>
                                                <xsl:value-of select="./system"/>
                                            </code>
                                        </reason>
                                        <amount>
                                            <value>
                                                <xsl:value-of select="./amount/value"/>
                                            </value>
                                            <currency>
                                                <xsl:value-of select="./amount/currency"/>
                                            </currency>
                                        </amount>
                                    </denial_reason>

                                </adjudication>

                            </adjudications>
                        </item>
                    </xsl:for-each>
                </items>
                <totals>
                    <total>
                        <adjudication_amount_type>
                            <category>
                                <code>submitted</code>
                                <system>http://terminology.hl7.org/CodeSystem/adjudication</system>
                            </category>
                            <amount>
                                <value>
                                    <xsl:value-of select="sum(//Revenues/SubmittedAmount)"/>
                                </value>
                                <currency>USD</currency>
                            </amount>
                        </adjudication_amount_type>
                        <adjudication_amount_type>
                            <category>
                                <code>copay</code>
                                <system>http://terminology.hl7.org/CodeSystem/adjudication</system>
                            </category>
                            <amount>
                                <value>
                                    <xsl:value-of select="sum(//Revenues/CoPayAmount)"/>
                                </value>
                                <currency>USD</currency>
                            </amount>
                        </adjudication_amount_type>
                        <adjudication_amount_type>
                             <category>
                                <code>deductible</code>
                                <system>http://terminology.hl7.org/CodeSystem/adjudication</system>
                            </category>
                            <amount>
                                <value>
                                    <xsl:value-of select="sum(//Revenues/DeductibleAmount)"/>
                                </value>
                                <currency>USD</currency>
                            </amount>
                        </adjudication_amount_type>
                        <adjudication_amount_type>
                            <category>
                                <code>noncovered</code>
                                <system>http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudication</system>
                            </category>
                            <amount>
                                <value>
                                    <xsl:value-of select="sum(//Revenues/NonCoveredAmount)"/>
                                </value>
                                <currency>USD</currency>
                            </amount>
                        </adjudication_amount_type>
                        <adjudication_amount_type>
                            <category>
                                <code>eligible</code>
                                <system>http://terminology.hl7.org/CodeSystem/adjudication</system>
                            </category>
                            <amount>
                                <value>
                                    <xsl:value-of select="sum(//Revenues/AllowedAmount)"/>
                                </value>
                                <currency>USD</currency>
                            </amount>
                        </adjudication_amount_type>
                        
                        <adjudication_amount_type>
                            <category>
                                <code>memberliability</code>
                                <system>http://terminology.hl7.org/CodeSystem/adjudication</system>
                            </category>
                            <amount>
                                <value>
                                    <xsl:value-of select="sum(//Revenues/PatientPayAmount)"/>
                                </value>
                                <currency>USD</currency>
                            </amount>
                        </adjudication_amount_type>
                        <adjudication_amount_type>
                            <category>
                                <code>benefit</code>
                                <system>http://terminology.hl7.org/CodeSystem/adjudication</system>
                            </category>
                            <amount>
                                <value>
                                    <xsl:value-of select="sum(//Revenues/PaymentAmount)"/>
                                </value>
                                <currency>USD</currency>
                            </amount>
                        </adjudication_amount_type>
                        <adjudication_amount_type>
                            <category>
                                <code>coinsurance</code>
                                <system>http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBAdjudication</system>
                            </category>
                            <amount>
                                <value>
                                    <xsl:value-of select="sum(//Revenues/CoInsuranceAmount)"/>
                                </value>
                                <currency>USD</currency>
                            </amount>
                        </adjudication_amount_type>
                   <!--      <in_out_network>
                                <category>other</category>
                                <amount>
                                    <value>
                                        <xsl:value-of select="./AllowedAmount"/>
                                    </value>
                                    <currency>USD</currency>
                                </amount>
                            </in_out_network>-->
                    </total>


                </totals>
                <payment>
                    <!--  <type>
                        <xsl:value-of select="./payment/type"/>
                    </type>
                    <date>
                        <xsl:value-of select="./payment/date"/>
                    </date>-->
                    <amount>
                        <value>
                            <xsl:value-of select="sum(//Revenues/PaymentAmount)"/>
                        </value>
                        <!--<currency>
                            <xsl:value-of select="./payment/amount/currency"/>
                        </currency>-->
                    </amount>
                </payment>
                <record_type>
                    <!--   <xsl:value-of select="./Amounts[]record_type"/>-->
                    <xsl:value-of select="./Revenues[position() = 1]/RecordType"/>
                </record_type>
            </eob>
        </xsl:for-each>

    </xsl:template>
    <xsl:template name="pog_telcom_provider_organization">

        <xsl:if test="./Providers[1]/ProviderOrganizationName != ''">

            <providing_organization>
                <npi>
                    <!--   <xsl:value-of select="./Providers/providing_organization/npi"/>-->
                </npi>
                <clia>
                    <!--  <xsl:value-of select="./insurer/clia"/>-->
                    <xsl:value-of
                        select="translate(./Providers[1]/ProviderOrganizationName, ' ', '')"/>

                </clia>

                <is_active>true</is_active>
                <name>
                    <xsl:value-of select="./Providers[1]/ProviderOrganizationName"/>
                </name>

            </providing_organization>
        </xsl:if>

    </xsl:template>
    <xsl:template name="pog_telcom_provider_practitioner">

        <xsl:if test="./Providers[1]/ProviderGivenName != ''">
            <practitioner>
                <npi>
                    <!--   <xsl:value-of select="./Providers/providing_organization/npi"/>-->
                </npi>
                <clia>
                    <!--  <xsl:value-of select="./insurer/clia"/>-->
                    <xsl:value-of
                        select="translate(concat(./Providers[1]/ProviderGivenName, ./Providers[1]/ProviderFamilyName), ' ', '')"/>

                </clia>

                <is_active>true</is_active>
                <name>
                    <xsl:value-of
                        select="concat(./Providers[1]/ProviderGivenName, ' ', ./Providers[1]/ProviderFamilyName)"
                    />
                </name>
            </practitioner>
        </xsl:if>

    </xsl:template>
</xsl:stylesheet>