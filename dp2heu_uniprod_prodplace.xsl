<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://heuristnetwork.org"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <!-- Template to produce *only* the place of production of UniProds
        Assumes that the UniProds and all associated records are already in the database.
        ** NB ** Be sure to upload as an update, *NOT* a replacement, for existing records.
        (Necessary because the 2MB upload limit for Heurist means that the import has to be 
        broken into several pieces.)
        -->

    <xsl:template match="/">
        <hml xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://heuristnetwork.org/documentation_and_templates/scheme_hml.xsd">

            <database id="0">pstok_sem</database>
            <xsl:apply-templates select="response/results"/>
        </hml>
    </xsl:template>

    <xsl:template match="results">
        <records>
            <!-- First add list of places -->
            <xsl:apply-templates select="doc('heu_place_new.xml')/hml/records/record"/>
            <xsl:apply-templates/>
        </records>
    </xsl:template>

    <xsl:template match="record">
        <xsl:copy>
            <xsl:copy-of select="@* | *"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="item">
        <xsl:if test="hands/item/assigned_place__id">
            <xsl:for-each select="historical_items/item">
            <record visibility="viewable" visnote="logged in users">
                <id>4000<xsl:value-of select="."/></id>
                <type conceptID="0-109">UniProd</type>

                <!-- <detail conceptID="0-1349" name="Date of creation">DATE</detail> -->
                <xsl:for-each-group select="../../hands/item/assigned_place__id" group-by=".">
                    <detail conceptID="0-1379" name="Place of Creation" isRecordPointer="true"
                            >2000<xsl:value-of select="."/></detail>
                </xsl:for-each-group>
            </record>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
