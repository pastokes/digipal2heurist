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
        <!-- Need to create UniCirc *and* Record relationships to link to Current Organisation and former Place -->
        <record visibility="viewable" visnote="logged in users">
            <id>3000<xsl:value-of select="id"/></id>
            <type conceptID="0-110">UniCirc</type>

            <detail conceptID="0-1352" name="Place(s) of conservation">SEE NOTES AT START</detail>
            <detail conceptID="0-1353" name="Identifier">
                <xsl:value-of select="shelfmark"/>
            </detail>
            <detail conceptID="0-1354" name="Identifier source">
                <xsl:value-of select="repository"/>
            </detail>
        </record>

        <record visibility="viewable" visnote="logged in users" selected="no" depth="0.5">
            <id>3001<xsl:value-of select="id"/></id>
            <type id="1" conceptID="2-1">Record relationship</type>

            <detail conceptID="2-5" name="Target record" id="5" basename="Target record pointer"
                isRecordPointer="true">
                <xsl:value-of select="concat('1000', repository_id)"/>
            </detail>
            <detail conceptID="2-6" name="Relationship type" id="6" basename="Relationship type"
                termID="7235" termConceptID="0-7235" ParentTerm="Current-former conservation vocab"
                >Current</detail>
            <detail conceptID="2-7" name="Source record" id="7" basename="Source record pointer"
                isRecordPointer="true">3000<xsl:value-of select="id"/></detail>
        </record>

        <xsl:variable name="currItemId" select="id"/>
        
        <xsl:if test="hands/item/assigned_place__id">
            <xsl:for-each select="historical_items/item">
                <xsl:for-each-group select="../../hands/item/assigned_place__id" group-by=".">
                    <record  visibility="viewable" visnote="logged in users" selected="no" depth="0.5">
                        <id>3002<xsl:value-of select="."/></id>
                        <type id="1" conceptID="2-1">Record relationship</type>

                        <detail conceptID="2-5" name="Target record" id="5"
                            basename="Target record pointer" isRecordPointer="true">
                            <xsl:value-of
                                select="concat('2000', ../../hands/item/assigned_place__id)"/>
                        </detail>
                        <detail conceptID="2-6" name="Relationship type" id="6"
                            basename="Relationship type" termID="7236" termConceptID="0-7236"
                            ParentTerm="Current-former conservation vocab">Former</detail>
                        <detail conceptID="2-7" name="Source record" id="7"
                            basename="Source record pointer" isRecordPointer="true"
                                >3000<xsl:value-of select="$currItemId"/></detail>
                    </record>
                </xsl:for-each-group>
            </xsl:for-each>
        </xsl:if>

    </xsl:template>
</xsl:stylesheet>
