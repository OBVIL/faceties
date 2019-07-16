<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="form fo svg text style office" version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" ><!-- xmlns:dc="http://purl.org/dc/elements/1.1/"-->
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
    <xsl:template match="/">
        <xsl:text>
</xsl:text>
        <text>
            <body>
                <xsl:apply-templates/>
            </body>
        </text>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:for-each select="./@*">
                <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
     </xsl:template>

    
    <!-- élément supprimés -->
    <xsl:template match="text:s | office:scripts | office:forms | office:font-face-decls | office:automatic-styles | text:sequence-decls | text:bookmark-start | text:tracked-changes | text:changed-region | text:deletion | text:change | text:change-start | text:change-end | text:soft-page-break"/> <!-- |  |  |  |  |  |  |  |  |  |  |  -->
    
    <!-- balises englobantes supprimées -->
    <xsl:template match="office:document-content | office:body | office:text">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="text:h">
        <xsl:element name="h">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- élément text:p -->
    <xsl:template match="text:p">
        <xsl:choose>
            <xsl:when test="contains(., 'front>')">
                <xsl:value-of select="." disable-output-escaping="yes"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>
</xsl:text>
                <!--<xsl:variable name="StyleEnCours" select="./@text:style-name"/>-->
                <xsl:variable name="StyP" select="./@text:style-name"/>
                <xsl:variable name="StyleEnCours">
                    <xsl:choose>
                        <xsl:when test="contains($StyP, '_5f_')">
                            <xsl:value-of select="substring-before($StyP, '_5f_')"/>
                            <xsl:text>_</xsl:text>
                            <xsl:value-of select="substring-after($StyP, '_5f_')"/>
                        </xsl:when>
                        <xsl:otherwise><xsl:value-of select="$StyP"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="Balise">
                    <xsl:choose>
                        <xsl:when test="/office:document-content/office:automatic-styles/style:style/@style:name = ./@text:style-name">
                            <xsl:value-of select="/office:document-content/office:automatic-styles/style:style[@style:name = $StyleEnCours]/@style:parent-style-name"/>
                        </xsl:when>
                        <xsl:otherwise><xsl:value-of select="./@text:style-name"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:element name="{$Balise}">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    
    <!-- élément text:span -->
    <xsl:template match="text:span">
        <!--<xsl:variable name="StyCarEnCours" select="./@text:style-name"/>-->
        <xsl:variable name="StyCar" select="./@text:style-name"/>
        <xsl:variable name="StyCarEnCours">
            <xsl:choose>
                <xsl:when test="contains($StyCar, '_5f_')">
                    <xsl:value-of select="substring-before($StyCar, '_5f_')"/>
                    <xsl:text>_</xsl:text>
                    <xsl:value-of select="substring-after($StyCar, '_5f_')"/>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="$StyCar"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="Balise">
            <xsl:choose>
                <xsl:when test="/office:document-content/office:automatic-styles/style:style[@style:name = $StyCarEnCours]/@style:parent-style-name">
                    <xsl:value-of select="/office:document-content/office:automatic-styles/style:style[@style:name = $StyCarEnCours]/@style:parent-style-name"/>
                </xsl:when>
                <xsl:when test="/office:document-content/office:automatic-styles/style:style[@style:name = $StyCarEnCours]/style:text-properties/@fo:font-variant = 'small-caps'">mevpc</xsl:when>
                <xsl:when test="/office:document-content/office:automatic-styles/style:style[@style:name = $StyCarEnCours]/style:text-properties/@style:text-position = 'super 58%'">mevexp</xsl:when>
                <xsl:when test="/office:document-content/office:automatic-styles/style:style[@style:name = $StyCarEnCours]/style:text-properties/@fo:font-style = 'italic'">mevital</xsl:when>
                <xsl:when test="/office:document-content/office:automatic-styles/style:style[@style:name = $StyCarEnCours]/style:text-properties/@style:font-style-complex = 'italic'"></xsl:when>
                <xsl:when test="/office:document-content/office:automatic-styles/style:style[@style:name = $StyCarEnCours]/style:text-properties/@fo:font-weight = 'bold'">mevgras</xsl:when>
                <xsl:when test="/office:document-content/office:automatic-styles/style:style[@style:name = $StyCarEnCours]/style:text-properties/@fo:font-size"></xsl:when>
                <xsl:when test="/office:document-content/office:automatic-styles/style:style[@style:name = $StyCarEnCours]/style:text-properties/@style:font-weight-complex = 'bold'"></xsl:when>
                <xsl:when test="/office:document-content/office:automatic-styles/style:style[@style:name = $StyCarEnCours]/style:text-properties/@style:font-name = 'Arial'"></xsl:when>
                <xsl:when test="/office:document-content/office:automatic-styles/style:style[@style:name = $StyCarEnCours]/style:text-properties/@style:font-name = 'Times New Roman'"></xsl:when>
                <xsl:when test="/office:document-content/office:automatic-styles/style:style[@style:name = $StyCarEnCours]/style:text-properties/@style:font-name = 'Courier New'"></xsl:when>
                <xsl:when test="/office:document-content/office:automatic-styles/style:style[@style:name = $StyCarEnCours]/style:text-properties/@fo:language"></xsl:when>
                <xsl:when test="/office:document-content/office:automatic-styles/style:style[@style:name = $StyCarEnCours]/style:text-properties/@style:text-underline-style='none'"></xsl:when>
                <xsl:otherwise><xsl:value-of select="$StyCarEnCours"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="Balise_trans" select="translate($Balise, '5', '')"></xsl:variable>
        <xsl:choose>
            <xsl:when test="$Balise_trans = ''">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{$Balise_trans}">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="text:line-break">
        <xsl:element name="lb"></xsl:element>	
    </xsl:template>
    
    <!-- élément text:tab -->
    <xsl:template match="text:tab">
        <xsl:element name="tab"></xsl:element>	
    </xsl:template>
    
</xsl:stylesheet>
