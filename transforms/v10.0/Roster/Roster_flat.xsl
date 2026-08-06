<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="ROSTER_MEMBER" select="Member"/>
    <!--CONVERT $ROSTER_MEMBER/MemberRelationshipCodeDesc to all lowercase -->
    <xsl:variable name="RELATION_TO_SUBSCRIBER" select="translate(Member/MemberRelationshipCodeDesc, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
    

    <xsl:template match="*">
        <member>
            <is_subscriber>

                <xsl:choose>
                    <xsl:when test="$RELATION_TO_SUBSCRIBER = 'subscriber'">
                        <xsl:value-of select="'true'"/>
                    </xsl:when>
                    <xsl:when test="$RELATION_TO_SUBSCRIBER = 'self'">
                        <xsl:value-of select="'true'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'false'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </is_subscriber>
            <relationship>
                <!--Verify MemberRelationshipCodeDesc input values are supported by HLX and map input values not found in the FHIR SubscriberRelationshipCodes value set to their closest match in that value set.-->
                <!--FHIR SubscriberRelationshipCodes value set:  https://hl7.org/fhir/R4/valueset-subscriber-relationship.html#expansion-->
                <xsl:choose>
                    <xsl:when test="$RELATION_TO_SUBSCRIBER = 'self'"><xsl:value-of select="'self'"/></xsl:when>
                    <xsl:when test="$RELATION_TO_SUBSCRIBER = 'subscriber'"><xsl:value-of select="'self'"/></xsl:when>
                    <xsl:when test="$RELATION_TO_SUBSCRIBER = 'child'"><xsl:value-of select="'child'"/></xsl:when>
                    <xsl:when test="$RELATION_TO_SUBSCRIBER = 'natural child'"><xsl:value-of select="'child'"/></xsl:when>
                    <xsl:when test="$RELATION_TO_SUBSCRIBER = 'adopted child'"><xsl:value-of select="'child'"/></xsl:when>
                    <xsl:when test="$RELATION_TO_SUBSCRIBER = 'step child'"><xsl:value-of select="'child'"/></xsl:when>
                    <xsl:when test="$RELATION_TO_SUBSCRIBER = 'dependent'"><xsl:value-of select="'child'"/></xsl:when>
                    <!--Dependent mapped to child as per CGHC request-->
                    <xsl:when test="$RELATION_TO_SUBSCRIBER = 'spouse'"><xsl:value-of select="'spouse'"/></xsl:when>
                    <xsl:when test="$RELATION_TO_SUBSCRIBER = 'domestic partner - same gender'"><xsl:value-of select="'spouse'"/></xsl:when>
                    <xsl:when test="$RELATION_TO_SUBSCRIBER = 'other'"><xsl:value-of select="'other'"/></xsl:when>
                    <xsl:when test="$RELATION_TO_SUBSCRIBER = 'unrelated dependent'"><xsl:value-of select="'other'"/></xsl:when>
                    <xsl:when test="$RELATION_TO_SUBSCRIBER = 'grand child'"><xsl:value-of select="'other'"/></xsl:when>
                    <xsl:when test="$RELATION_TO_SUBSCRIBER = 'common'"><xsl:value-of select="'common'"/></xsl:when>
                    <xsl:when test="$RELATION_TO_SUBSCRIBER = 'parent'"><xsl:value-of select="'parent'"/></xsl:when>
                    <xsl:when test="$RELATION_TO_SUBSCRIBER = 'injured'"><xsl:value-of select="'injured'"/></xsl:when>
                    
                    <xsl:otherwise><!--Leave the <relationship> element EMPTY??? i.e. Let downstream CANNONICAL Schema/XSD Validation detect the <relationship> element (minOccurs="1") is missing.--></xsl:otherwise>
                </xsl:choose>

            </relationship>
            <birth_date>
                <xsl:value-of select="$ROSTER_MEMBER/MemberDOB"/>
            </birth_date>
            <gender>
                <xsl:choose>
                    <xsl:when test="starts-with($ROSTER_MEMBER/MemberGender, 'M')">male</xsl:when>
                    <xsl:when test="starts-with($ROSTER_MEMBER/MemberGender, 'F')">female</xsl:when>
                    <xsl:otherwise>unknown</xsl:otherwise>
                </xsl:choose>
            </gender>
            <unique_person_ids>
                <unique_person_id>
                    <xsl:value-of select="$ROSTER_MEMBER/UniquePersonID"/>
                </unique_person_id>

                <unique_person_id_assigner>
                    <xsl:value-of select="$ROSTER_MEMBER/UniquePersonIdAssigner"/>
                </unique_person_id_assigner>
                <unique_person_id_assigner_type>
                    <xsl:value-of select="$ROSTER_MEMBER/UniquePersonID"/>
                </unique_person_id_assigner_type>
            </unique_person_ids>

            <member_identity>
                <secret_display_name>
                    <xsl:value-of select="$ROSTER_MEMBER/SecretDisplayName"/>
                </secret_display_name>
                <secret_value>
                    <xsl:value-of select="$ROSTER_MEMBER/SecretValue"/>
                </secret_value>
                <secret_length>
                    <xsl:value-of select="string-length($ROSTER_MEMBER/SecretValue)"/>
                </secret_length>
            </member_identity>
            <member_id>
                <xsl:value-of select="$ROSTER_MEMBER/MemberID"/>
            </member_id>
            <member_id_system>
                <xsl:value-of select="$ROSTER_MEMBER/UniquePersonIdAssigner"/>
            </member_id_system>
            <subscriber_id>
                <xsl:value-of select="$ROSTER_MEMBER/SubscriberID"/>
            </subscriber_id>

            <names>

                <name>
                    <use>official</use>
                    <text> </text>
                    <family>
                        <xsl:value-of select="$ROSTER_MEMBER/MemberLastName"/>
                    </family>

                    <given>
                        <xsl:value-of select="$ROSTER_MEMBER/MemberFirstName"/>
                    </given>

                </name>

            </names>
            <telecoms>
                <telecom>
                    <system>phone</system>
                    <value>
                        <xsl:value-of select="$ROSTER_MEMBER/MemberPhoneNumber"/>
                    </value>
                    <use>home</use>

                </telecom>
                <telecom>
                    <system>email</system>
                    <value>
                        <xsl:value-of select="$ROSTER_MEMBER/MemberEmailAddress"/>
                    </value>

                </telecom>
            </telecoms>
            <addresses>

                <address>
                    <use>home</use>
                    <type>physical</type>
                    <text> </text>

                    <line>
                        <xsl:choose>
                            <xsl:when test="$ROSTER_MEMBER/MemberAddress2 != ''">
                                <xsl:value-of
                                    select="concat($ROSTER_MEMBER/MemberAddress, ' ', $ROSTER_MEMBER/MemberAddress2)"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="($ROSTER_MEMBER/MemberAddress)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </line>
                    <city>
                        <xsl:value-of select="$ROSTER_MEMBER/MemberCity"/>
                    </city>
                    <state>
                        <xsl:value-of select="$ROSTER_MEMBER/MemberState"/>
                    </state>
                    <postal_code>
                        <xsl:value-of select="$ROSTER_MEMBER/MemberZipCode"/>
                    </postal_code>
                    <country>
                        <xsl:value-of select="$ROSTER_MEMBER/MemberCountry"/>
                    </country>
                </address>
                <address>
                    <use>home</use>
                    <type>postal</type>
                    <text> </text>

                    <line>
                        <xsl:choose>
                            <xsl:when test="$ROSTER_MEMBER/MemberMailingAddress2 != ''">
                                <xsl:value-of
                                    select="concat($ROSTER_MEMBER/MemberMailingAddress, ' ', $ROSTER_MEMBER/MemberMailingAddress2)"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="($ROSTER_MEMBER/MemberMailingAddress)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </line>
                    <city>
                        <xsl:value-of select="$ROSTER_MEMBER/MemberMailingCity"/>
                    </city>
                    <state>
                        <xsl:value-of select="$ROSTER_MEMBER/MemberMailingState"/>
                    </state>
                    <postal_code>
                        <xsl:value-of select="$ROSTER_MEMBER/MemberMailingZipCode"/>
                    </postal_code>
                    <country>
                        <xsl:value-of select="$ROSTER_MEMBER/MemberMailingCountry"/>
                    </country>
                </address>
            </addresses>
            <health_coverage>
                <group_number>
                    <xsl:value-of select="$ROSTER_MEMBER/SubscriberGroupName"/>
                </group_number>

                <policy_number>
                    <xsl:value-of select="$ROSTER_MEMBER/MemberPolicyNumber"/>
                </policy_number>
                <plan_id>
                    <xsl:value-of select="$ROSTER_MEMBER/PlanID"/>
                </plan_id>
                <plan_name>
                    <xsl:value-of select="$ROSTER_MEMBER/PlanDesc"/>
                </plan_name>
                <coverage_period>
                    <start>
                        <xsl:value-of select="$ROSTER_MEMBER/EffectiveStartDate"/>
                    </start>
                    <end>
                        <xsl:value-of select="$ROSTER_MEMBER/EffectiveEndDate"/>
                    </end>
                </coverage_period>
            </health_coverage>
            <communications>
                <communication>


                    <xsl:choose>
                        <xsl:when test="$ROSTER_MEMBER/MemberLanguage = 'English'">
                            <language_code>en</language_code>
                            <display>ENGLISH</display>
                        </xsl:when>
                        <xsl:otherwise>
                            <language_code/>
                            <display>
                                <xsl:value-of select="$ROSTER_MEMBER/MemberLanguage"/>
                            </display>
                        </xsl:otherwise>
                    </xsl:choose>
                    <is_preferred>true</is_preferred>
                </communication>
            </communications>

            <xsl:choose>
                <xsl:when test="$ROSTER_MEMBER/MemberSmokingStatus = 'N'">
                    <smoking_status/>
                </xsl:when>
                <xsl:otherwise>
                    <smoking_status>266927001</smoking_status>
                </xsl:otherwise>
            </xsl:choose>



            <RecordType>Add</RecordType>
            <xsl:variable name="EOB_EFFECTIVE_START_DATE"
                select="translate($ROSTER_MEMBER/EffectiveStartDate, '-', '')"/>

            <unique_record_identifier>
                <xsl:value-of select="concat($ROSTER_MEMBER/MemberID, '-' , $ROSTER_MEMBER/PlanID,'-',$EOB_EFFECTIVE_START_DATE)"/>
            </unique_record_identifier>
        </member>
    </xsl:template>
</xsl:stylesheet>
