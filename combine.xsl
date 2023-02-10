<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://heuristnetwork.org" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/">
        <hml xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://heuristnetwork.org/documentation_and_templates/scheme_hml.xsd">

            <database id="0">pstok_sem</database>

            <records>
                <xsl:comment> *** Places *** </xsl:comment>
                <!-- http://digipal.eu/digipal/api/place/?@format=xml&@select=name,county,eastings,northings,region&@limit=500 -->
                <xsl:apply-templates select="doc('heu_place_new.xml')/hml/records/record"/>

                <xsl:comment> *** Organisations *** </xsl:comment>
                <!-- http://digipal.eu/digipal/api/repository/?@format=xml&@select=id,place_id,type,short_name,name&@limit=1000 -->
                <xsl:apply-templates select="doc('heu_org_new.xml')/hml/records/record"/>

                <xsl:comment> *** UniCircs and Current Locations (record relationships) *** </xsl:comment>
                <!-- http://digipal.eu/digipal/api/currentitem/?@format=xml&@select=id,repository_id,repository,shelfmark,*item_parts,*hands,assigned_date,assigned_place&@limit=2000 -->
                <xsl:apply-templates select="doc('heu_unicirc_new.xml')/hml/records/record"/>

                <xsl:comment> *** Works, UniProds and Manifestations *** </xsl:comment>
                <!-- http://digipal.eu/digipal/api/historicalitem/?@format=xml&@select=id,historical_item_format,historical_item_type,catalogue_number,*categories,name,*item_parts&@limit=2000 -->
                <xsl:apply-templates select="doc('heu_uniprod_new.xml')/hml/records/record"/>

                <xsl:comment> *** UniProdUniCircs *** </xsl:comment>
                <!-- http://digipal.eu/digipal/api/itempart/?@format=xml&@select=id,texts,images,current_item_id,hands,historical_items&@limit=2000 -->
                <xsl:apply-templates select="doc('heu_upuc_new.xml')/hml/records/record"/>
            </records>
        </hml>
    </xsl:template>

    <xsl:template match="record">
        <xsl:copy>
            <xsl:copy-of select="@* | *"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
