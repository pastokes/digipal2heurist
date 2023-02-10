<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"  xmlns="http://heuristnetwork.org" exclude-result-prefixes="xs" version="2.0">

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
        <!-- We need one UniProd-UniCirc for each link, so if an ItemPart is linked to multiple Historical Items
        then we need to create multiple UP-UCs. This also means that we can't simply use the ItemPart ID. -->
        <xsl:for-each select="historical_items/item">
        <record visibility="viewable" visnote="logged in users">
            <id>5000<xsl:value-of select="../../id"/>.<xsl:value-of select="."/></id>
            <type conceptID="0-112">UniProd-UniCirc</type>
            <detail conceptID="0-1356" name="UniProd" isRecordPointer="true">4000<xsl:value-of select="."/></detail>
            <detail conceptID="0-1360" name="UniCirc" isRecordPointer="true">3000<xsl:value-of select="../../current_item_id"/></detail>
            <xsl:if test="../../locus != ''">
                <detail conceptID="0-1361" name="UniCirc Extent"><xsl:value-of select="../../locus"/></detail>
            </xsl:if>
        </record>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
