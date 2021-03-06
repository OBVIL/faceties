<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    
    <!-- Cette transformation prend en charge :
        - la séparations des différentes parties en div (première étape de la hierarchisation) -->

    <xsl:strip-space elements="*"/>
    
    <xsl:template match="meta">
        <xsl:element name="meta">
            <xsl:apply-templates mode="avant"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="frontiespiece">
        <xsl:element name="frontiespiece">
            <xsl:apply-templates mode="avant"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*" mode="avant">
        <xsl:element name="{local-name()}">
            <xsl:for-each select="attribute::*">
                <xsl:attribute name="{local-name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates mode="avant"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="term" mode="avant">
        <xsl:element name="{local-name()}">
            <xsl:for-each select="attribute::*">
                <xsl:attribute name="n">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates mode="avant"/>
        </xsl:element>
    </xsl:template>
    
    <!--
    ====================================
                REGROUPEMENT
    ====================================
    -->
    
    <xsl:key name="fils" match="*" use="generate-id(preceding-sibling::titre[1])"/>
    
    <xsl:template match="body">
        <body>
            <xsl:apply-templates/>
        </body>
    </xsl:template>
    
    <xsl:template match="text">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="*" mode="regrouper">
        <xsl:choose>
            <xsl:when test="name(.)='titre'"/>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="titre">
        <div>
            <xsl:attribute name="niv" select="./@niv"/>
            <xsl:choose>
                <xsl:when test="descendant::speaker">
                    <xsl:copy-of select="./*"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="key('fils',generate-id())" mode="regrouper"/>
        </div>
    </xsl:template>
    
    <xsl:template match="*">
    </xsl:template>
    
</xsl:stylesheet>