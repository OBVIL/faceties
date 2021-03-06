<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <!-- Cette transformation prend en charge :
        - l'emboitement des différentes div (deuxième étape de la hierarchisation) -->

    <xsl:template match="/body">
        <xsl:comment>OBVIL, CHEVALIER Nolwenn. Projet Facéties. </xsl:comment>
        <xsl:comment>(T2) Transformation XML-ODT vers XML : <xsl:value-of select="format-date(current-date(), '[M01]/[D01]/[Y0001]')"/> à <xsl:value-of select="format-dateTime(current-dateTime(), '[H01]:[m01]')"/>. </xsl:comment>
        <TEI>
            <teiHeader>
                <xsl:apply-templates select="descendant::meta"/>
            </teiHeader>
            <text>
                <xsl:apply-templates select="descendant::frontiespiece"/>
                <xsl:copy>
                    <xsl:apply-templates select="div[@niv = 1]"/>
                </xsl:copy>
            </text>
        </TEI>
    </xsl:template>

    <xsl:template match="meta">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="frontiespiece">
        <xsl:element name="frontiespiece">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:for-each select="attribute::*">
                <xsl:attribute name="{local-name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- 
    =======================================
                HIERARCHISATION
    =======================================
    -->

    <xsl:template match="div">
        <xsl:variable name="id_noeud" select="generate-id(.)"/>
        <xsl:copy>
            <xsl:copy-of select="@niv"/>
            <xsl:copy-of select="./*[name() != 'div']"/>
            <xsl:apply-templates
                select="following-sibling::div[(@niv = current()/@niv +1) and (generate-id(preceding-sibling::div[@niv = current()/@niv][1]) = $id_noeud)]"
            />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
