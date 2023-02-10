<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://heuristnetwork.org"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/">
        <hml xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://heuristnetwork.org/documentation_and_templates/scheme_hml.xsd">

            <database id="0">pstok_sem</database>
            <xsl:apply-templates select="response/results"/>
        </hml>
    </xsl:template>

    <xsl:template match="results">
        <records>
            <xsl:apply-templates/>
        </records>
    </xsl:template>

    <xsl:template match="item">
        <record visibility="viewable" visnote="logged in users">
            <id>1000<xsl:value-of select="id"/></id>
            <type conceptID="2-4">Organisation</type>
            <detail conceptID="2-1" name="Full name of organisation"><xsl:value-of select="name"/></detail>
            <detail conceptID="2-2" name="Short name / acronym"><xsl:value-of select="short_name"/></detail>
            <detail conceptID="2-22" name="Organisation type" termID="6849"/>
            <detail conceptID="2-134" name="Location (places)" isRecordPointer="true"
                >2000<xsl:value-of select="place_id"/></detail>
        </record>
    </xsl:template>
</xsl:stylesheet>
