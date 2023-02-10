<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://heuristnetwork.org"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <!-- ************************************************************* -->
    <!-- BE SURE TO SET PARAMETER WITH VALID USERNAME FOR GEONAMES API -->
    <!-- ************************************************************* -->
    <xsl:param name="geo_uname">CHANGEME</xsl:param>

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
            <id>2000<xsl:value-of select="id"/></id>
            <type conceptID="3-1009">Place</type>
            <detail conceptID="2-1" name="Primary place name">
                <xsl:value-of select="name"/>
            </detail>

            <!-- Some 'places' in DigiPal are in fact institutions, so we need to collapse these to just the place.
            Use Alt Place Name to hold the full names for now -->
            <!-- In fact doesn't really work...
            <xsl:choose>
                <xsl:when test="name='CaCC' or name='CaA' or name='CaCC (CaA?)'">
                    <detail conceptID="2-1" name="Primary place name">Canterbury</detail>            
                    <detail conceptID="3-1009" name="Additional (equivalent) names"><xsl:value-of select="name"/></detail>
                </xsl:when>
                <xsl:when test="name='WiOM' or name='WiNM' or name =></xsl:when>
                <otherwise>
                    <detail conceptID="2-1" name="Primary place name"><xsl:value-of select="name"/></detail>            
                </otherwise>
            </xsl:choose>
             -->

            <!-- Try to get the corresponding record from GeoNames and fill in data from there -->
            <xsl:variable name="geo_rec"
                select="doc(concat('http://api.geonames.org/search?name_equals=', name, '&amp;maxRows=1&amp;username=', $geo_uname, '&amp;countryBias=uk'))/geonames/geoname[1]"/>
            <xsl:if test="$geo_rec/geonameId">
                <detail conceptID="2-581" name="GeoNames ID"><xsl:value-of select="$geo_rec/geonameId"/></detail>
                <detail conceptID="2-26" name="Country" termID="{$geo_rec/countryName}"/>
                
                <detail conceptID="2-28" name="Location (mappable)" basename="Mappable location (geospatial)">
                    <geo>
                        <type>point</type>
                        <wkt>POINT(<xsl:value-of select="$geo_rec/lng"/><xsl:text> </xsl:text><xsl:value-of
                                select="$geo_rec/lat"/>)</wkt>
                    </geo>
                </detail>
                
                <detail conceptID="3-1068" name="Place type">
                    <xsl:attribute name="termID">
                        <xsl:choose>
                            <!-- See full list of codes at https://www.geonames.org/export/codes.html -->
                            <xsl:when test="starts-with($geo_rec/fcode, 'PPL')">5322</xsl:when>
                            <xsl:when test="starts-with($geo_rec/fcode, 'ADM')">6283</xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                </detail>
            </xsl:if>
        </record>
    </xsl:template>
</xsl:stylesheet>
