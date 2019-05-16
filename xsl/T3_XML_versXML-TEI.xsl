<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/rng" href="BVH_Epistemon.rng"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template name="substring-before-last">
        <xsl:param name="string1" select="''" />
        <xsl:param name="string2" select="''" />        
        <xsl:if test="$string1 != '' and $string2 != ''">
            <xsl:variable name="head" select="substring-before($string1, $string2)" />
            <xsl:variable name="tail" select="substring-after($string1, $string2)" />
            <xsl:value-of select="$head" />
            <xsl:if test="contains($tail, $string2)">
                <xsl:value-of select="$string2" />
                <xsl:call-template name="substring-before-last">
                    <xsl:with-param name="string1" select="$tail" />
                    <xsl:with-param name="string2" select="$string2" />
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
<!--======================================================
                       STRUCTURE / HEADER
======================================================-->
    
    <!-- Élément racine matché : création du <teiHeader> et de la structure appelant le texte -->
    <xsl:template match="/">
        <xsl:comment>OBVIL, CHEVALIER Nolwenn. Projet Facéties. </xsl:comment>
        <xsl:comment>Transformation : <xsl:value-of  select="format-date(current-date(), '[M01]/[D01]/[Y0001]')"/> à <xsl:value-of select="format-dateTime(current-dateTime(), '[H01]:[m01]')"/>. </xsl:comment>
        <TEI>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <xsl:copy-of select="descendant::title"/>
                        <xsl:copy-of select="descendant::author"/>
                    </titleStmt>
                    <editionStmt>
                        <edition>OBVIL</edition>
                    </editionStmt>
                    <publicationStmt>
                        <xsl:copy-of select="descendant::publisher"/>
                        <xsl:copy-of select="descendant::publisher/following-sibling::date"/>
                        <xsl:copy-of select="descendant::idno"/>
                        <availability status="restricted">
                            <licence target="http://creativecommons.org/licenses/by-nc-nd/3.0/fr/">
                                <p>Cette ressource électronique protégée par le code de la propriété intellectuelle sur
                                    les bases de données (L341-1) est mise à disposition de la communauté scientifique
                                    internationale par l’OBVIL, selon les termes de la licence Creative Commons :
                                    « Attribution - Pas d’Utilisation Commerciale - Pas de Modification 3.0 France
                                    (CCBY-NC-ND 3.0 FR) ».</p>
                                <p>Attribution : afin de référencer la source, toute utilisation ou publication dérivée
                                    de cette ressource électroniques comportera le nom de l’OBVIL et surtout l’adresse
                                    Internet de la ressource.</p>
                                <p>Pas d’Utilisation Commerciale : dans l’intérêt de la communauté scientifique, toute
                                    utilisation commerciale est interdite.</p>
                                <p>Pas de Modification : l’OBVIL s’engage à améliorer et à corriger cette ressource
                                    électronique, notamment en intégrant toutes les contributions extérieures, la
                                    diffusion de versions modifiées de cette ressource n’est pas souhaitable.</p>
                            </licence>
                        </availability>
                    </publicationStmt>
                    <sourceDesc>
                        <xsl:variable name="bibl-new">
                            <xsl:variable name="bibl-orig" select="descendant::bibl"/>
                            <xsl:variable name="cut" select="descendant::title"/>
                            <xsl:value-of select="substring-after($bibl-orig, $cut)"/>
                        </xsl:variable>
                        <xsl:variable name="pubPlace">
                            <xsl:value-of select="substring-before(substring-after($bibl-new, ', '), ',')"/>
                        </xsl:variable>
                        <xsl:variable name="publisher">
                            <xsl:variable name="publisher_01" select="substring-after(substring-before(substring-after($bibl-new, $pubPlace), descendant::creation/date/@when), ',')"/>
                            <xsl:call-template name="substring-before-last">
                                <xsl:with-param name="string1" select="$publisher_01" />
                                <xsl:with-param name="string2" select="', '" />
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="biblScope">
                            <xsl:value-of select="substring-before(substring-after(substring-after($bibl-new, descendant::creation/date/@when), ', '), '.')"/>
                        </xsl:variable>
                        <xsl:value-of select="descendant::author"/>, <xsl:element name="hi"><xsl:attribute name="rend">i</xsl:attribute><xsl:value-of select="descendant::title"/></xsl:element>, <pubPlace><xsl:value-of select="$pubPlace"/></pubPlace>,  <publisher><xsl:value-of select="$publisher"/></publisher>, <xsl:value-of select="descendant::creation/date/@when"/>, <biblScope><xsl:value-of select="$biblScope"/></biblScope>.
                    </sourceDesc>
                </fileDesc>
                <profileDesc>
                    <xsl:copy-of select="descendant::creation"/>
                    <xsl:copy-of select="descendant::langUsage"/>
                </profileDesc>
            </teiHeader>
            <text>
                <body>
                    <xsl:copy-of select="descendant::frontiespiece/head"/>
                    <xsl:apply-templates/>
                </body>
            </text>
        </TEI>
    </xsl:template>

    <!-- Élément teiHeader matché sans être appelé car déjà appelé dans <xsl:template match="/"> -->
    <xsl:template match="teiHeader"/>
    
    <!-- Éléments matchés mais pas leur balise car elles sont déjà introduites dans <xsl:template match="/"> -->
    <xsl:template match="body|TEI">
        <xsl:apply-templates/>
    </xsl:template>
    
<!--======================================================
                       CONTENU
======================================================-->
    
    <!-- Tous les éléments et leurs attributs matchés à l'identique -->
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
    
    <!-- FRONTISPIECE -->
    
    <xsl:template match="frontiespiece/head"/>
    
    <xsl:template match="frontiespiece">
        <xsl:element name="castList">
            <xsl:apply-templates select=".//ancestor::body//descendant::speaker" mode="index"/>
        </xsl:element>
        <xsl:element name="index">
            <xsl:apply-templates select=".//ancestor::body//descendant::term"/>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="speaker" mode="index">
        <xsl:variable name="item" select="."/>
        <xsl:variable name="item_preced" select="preceding::speaker"/>
        <xsl:variable name="unique">
            <xsl:if test="count($item_preced[. = $item])=1">
                <xsl:value-of select="$item"/>
            </xsl:if>
        </xsl:variable>
        <xsl:if test="not($unique='')">
            <xsl:for-each select="$unique">
                <xsl:element name="castItem">
                    <xsl:attribute name="xml:id">
                        <xsl:value-of select="$unique"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- TEXTE -->
    
    <xsl:template match="body//*/text()">
        <xsl:analyze-string select="." regex="ãm">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
                <choice><sic>ãm</sic><corr>amm</corr></choice>
                <xsl:value-of select="regex-group(2)"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
</xsl:stylesheet>