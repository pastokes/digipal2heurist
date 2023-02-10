<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns="http://heuristnetwork.org"
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
            <!-- First add list of Works -->
            <!-- TODO: DP also has texts in TextInfo associated with Item part (for charters) -->
            <xsl:comment>    Works    </xsl:comment>
            <xsl:for-each-group select="item/categories/item" group-by="id">
                <xsl:sort select="name"/>
                <record  visibility="viewable" visnote="logged in users">
                    <!-- Specify the entity identifier in the source database (numeric or alphanumeric) if entity may be the target of a record pointer field, including the target record pointer of a  relationship record.-->
                    <id>4099<xsl:value-of select="id"/></id>
                    <type conceptID="1410-65">Work</type>
                    
                    <!-- TODO: Add language -->
                    <!--<detail conceptID="1410-1057" name="textLang" termID="VALUE"/>-->
                    <detail conceptID="1410-1013" name="Title"><xsl:value-of select="name"/></detail>
                </record>
            </xsl:for-each-group>
            
            <!-- Now deal with UniProds (and Manifestations) -->
            <xsl:comment>    UniProds and Manifestations    </xsl:comment>
            <xsl:apply-templates/>
        </records>
    </xsl:template>

    <xsl:template match="item">
        <!-- Need to create UniProd and Manifestation together -->
        
        <!-- Manifestation -->
        <record visibility="viewable" visnote="logged in users">
            <id>4001<xsl:value-of select="id"/></id>
            <type conceptID="0-111">Manifestation</type>
            <!--<detail conceptID="2-4" name="Extended description">MEMO_TEXT</detail>-->
            <detail conceptID="1410-1102" name="Material of Support" termID="H-ID-7026">Parchement</detail>
            <xsl:for-each select="categories/item">
            <detail conceptID="0-1365" name="Work" isRecordPointer="true">4099<xsl:value-of select="id"/></detail>
            </xsl:for-each>
        </record>
            
        <record visibility="viewable" visnote="logged in users">
            <id>4000<xsl:value-of select="id"/></id>
            <type conceptID="0-109">UniProd</type>

            <!-- Need to extract number, incl. for multiple numbers -->
            <!-- Heurist model only allows one ID, so take (in order of priority) G, then S, K, P, CLA -->
            <xsl:choose>
                <xsl:when test="contains(catalogue_number, 'G. ')">
                    <detail conceptID="0-1354" name="Identifier source">G. </detail>
                    <xsl:analyze-string select="catalogue_number" regex="G. ([\w\.\-\*]+)">
                        <xsl:matching-substring>
                            <detail conceptID="0-1353" name="Identifier"><xsl:value-of select="regex-group(1)"/></detail>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:when test="contains(catalogue_number, 'S. ')">
                    <detail conceptID="0-1354" name="Identifier source">S. </detail>                    
                    <xsl:analyze-string select="catalogue_number" regex="S. ([\w\.\-\*]+)">
                        <xsl:matching-substring>
                            <detail conceptID="0-1353" name="Identifier"><xsl:value-of select="regex-group(1)"/></detail>
                        </xsl:matching-substring>
                    </xsl:analyze-string>                    
                </xsl:when>
                <xsl:when test="contains(catalogue_number, 'K. ')">
                    <detail conceptID="0-1354" name="Identifier source">K. </detail>                    
                    <xsl:analyze-string select="catalogue_number" regex="K. ([\w\.\-\*]+)">
                        <xsl:matching-substring>
                            <detail conceptID="0-1353" name="Identifier"><xsl:value-of select="regex-group(1)"/></detail>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:when test="contains(catalogue_number, 'P. ')">
                    <detail conceptID="0-1354" name="Identifier source">P. </detail>                    
                    <xsl:analyze-string select="catalogue_number" regex="P. ([\w\.\-\*]+)">
                        <xsl:matching-substring>
                            <detail conceptID="0-1353" name="Identifier"><xsl:value-of select="regex-group(1)"/></detail>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:when test="contains(catalogue_number, 'CLA ')">
                    <detail conceptID="0-1354" name="Identifier source">CLA </detail>                    
                    <xsl:analyze-string select="catalogue_number" regex="CLA ([\w\.\-\*]+)">
                        <xsl:matching-substring>
                            <detail conceptID="0-1353" name="Identifier"><xsl:value-of select="regex-group(1)"/></detail>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:otherwise>
                    <detail conceptID="0-1354" name="Identifier source">UNKNOWN SOURCE</detail>                    
                    <detail conceptID="0-1353" name="Identifier"><xsl:value-of select="catalogue_number"/></detail>                    
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- TODO: Figure out how to get descriptions out of DigiPal -->
            <!--<detail conceptID="2-4" name="Extended description">MEMO_TEXT</detail>-->
            
            <xsl:choose>
                <xsl:when test="historical_item_type='manuscript'">
                    <detail conceptID="0-1378" name="Format" termID="H-ID-7251">Codex (Western)</detail>                    
                </xsl:when>
                <xsl:when test="historical_item_format='single sheet'">
                    <detail conceptID="0-1378" name="Format" termID="H-ID-7250">Single-sheet charter</detail>
                </xsl:when>
            </xsl:choose>
            
            <!-- Add any and all bibliographical references, based on the format of the catalogue number -->
            <xsl:if test="contains(catalogue_number, 'G.')">
                <detail conceptID="2-1016" name="Bibliographic reference" isRecordPointer="true">H-ID-2620</detail>
            </xsl:if>
            <xsl:if test="contains(catalogue_number, 'S.')">
                <detail conceptID="2-1016" name="Bibliographic reference" isRecordPointer="true">H-ID-2629</detail>
            </xsl:if>
            <xsl:if test="contains(catalogue_number, 'K.')">
                <detail conceptID="2-1016" name="Bibliographic reference" isRecordPointer="true">H-ID-2625</detail>
            </xsl:if>
            <xsl:if test="contains(catalogue_number, 'P.')">
                <detail conceptID="2-1016" name="Bibliographic reference" isRecordPointer="true">H-ID-10441</detail>
            </xsl:if>
            <xsl:if test="contains(catalogue_number, 'CLA')">
                <detail conceptID="2-1016" name="Bibliographic reference" isRecordPointer="true">H-ID-2734</detail>
            </xsl:if>2734
            
            <detail conceptID="1410-1102" name="Material" termID="H-ID-7026">Parchment</detail>
            
            <!-- <detail conceptID="0-1349" name="Date of creation">DATE</detail> -->
            <xsl:if test="item_parts/item/hands/item/assigned_place__id">
                <detail conceptID="0-1379" name="Place of Creation" isRecordPointer="true">2000<xsl:value-of select="item_parts/item/hands/item/assigned_place__id"/></detail>
            </xsl:if>
            
            <detail conceptID="0-1357" name="Manifestation" isRecordPointer="true">4001<xsl:value-of select="id"/></detail>

        </record>

        <!--<record visibility="viewable" visnote="logged in users" selected="no" depth="0.5">
            <id>4001<xsl:value-of select="id"/></id>
            <type id="1" conceptID="2-1">Record relationship</type>
            
            <detail conceptID="2-5" name="Target record" id="5" basename="Target record pointer"
                isRecordPointer="true"><xsl:value-of select="concat('1000',repository_id)"/></detail>
            <detail conceptID="2-6" name="Relationship type" id="6" basename="Relationship type"
                termID="7235" termConceptID="0-7235" ParentTerm="Current-former conservation vocab"
                >Current</detail>
            <detail conceptID="2-7" name="Source record" id="7" basename="Source record pointer"
                isRecordPointer="true">3000<xsl:value-of select="id"/></detail>
        </record>-->
    </xsl:template>
</xsl:stylesheet>
