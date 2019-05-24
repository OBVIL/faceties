<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/rng" href="BVH_Epistemon.rng"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Agis de telle sorte que ta transformation XSLT puisse être érigée en loi universelle.-->
    
    <xsl:strip-space elements="*"/>
    
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
        <xsl:comment>Transformation : <xsl:value-of  select="format-date(current-date(), '[D01]/[M01]/[Y0001]')"/> à <xsl:value-of select="format-dateTime(current-dateTime(), '[H01]:[m01]')"/>. </xsl:comment>
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
                        <xsl:value-of select="descendant::author"/>, <xsl:element name="hi"><xsl:attribute name="rend">i</xsl:attribute><xsl:value-of select="descendant::title"/></xsl:element>, <pubPlace><xsl:value-of select="$pubPlace"/></pubPlace>, <publisher><xsl:value-of select="$publisher"/></publisher>, <xsl:value-of select="descendant::creation/date/@when"/>, <biblScope><xsl:value-of select="$biblScope"/></biblScope>.
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
    
    
    <xsl:template match="*">
        <xsl:choose>
            <!--On s'occupe des éventuels parasites-->
            <xsl:when test="matches(local-name(), '^T[0-9]+$')">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="matches(local-name(), '^T$')">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="contains(local-name(), 'Police')">
                <xsl:apply-templates/>
            </xsl:when>
            <!-- Le reste des éléments et leurs attributs sont matchés à l'identique -->
            <xsl:otherwise>
                <xsl:element name="{local-name()}">
                    <xsl:for-each select="attribute::*">
                        <xsl:attribute name="{local-name()}">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
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
    
    <xsl:template match="div1">
        <xsl:element name="div1">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="div2">
        <xsl:element name="div2">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="head">
        <xsl:choose>
            <xsl:when test="contains(.,'(C)')"> <!-- Gestion des alinéas explicites -->
                <xsl:choose>
                    <xsl:when test="contains(.,'(C) ')">
                        <xsl:element name="head">
                            <xsl:attribute name="rend">indent</xsl:attribute>
                            <orig>⸿ </orig>
                            <xsl:value-of select="substring-after(., '(C) ')"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="head">
                            <xsl:attribute name="rend">indent</xsl:attribute>
                            <xsl:value-of select="substring-after(., '(C)')"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains(.,'(D)')"> <!-- Gestion des alinéas implicites -->
                <xsl:choose>
                    <xsl:when test="contains(.,'(D) ')">
                        <xsl:element name="head">
                            <xsl:attribute name="rend">indent</xsl:attribute>
                            <xsl:value-of select="substring-after(., '(D) ')"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="head">
                            <xsl:attribute name="rend">indent</xsl:attribute>
                            <xsl:value-of select="substring-after(., '(D)')"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="head">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="_3c_l_3e_">
        <xsl:choose>
            <xsl:when test="contains(.,'(C)')"> <!-- Gestion des alinéas -->
                <xsl:choose>
                    <xsl:when test="contains(.,'(C) ')">
                        <xsl:element name="l">
                            <xsl:attribute name="rend">indent</xsl:attribute>
                            <orig>⸿</orig>
                            <xsl:value-of select="substring-after(., '(C) ')"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="l">
                            <xsl:attribute name="rend">indent</xsl:attribute>
                            <xsl:value-of select="substring-after(., '(C)')"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains(.,'(D)')"> <!-- Gestion des alinéas -->
                <xsl:choose>
                    <xsl:when test="contains(.,'(D) ')">
                        <xsl:element name="l">
                            <xsl:attribute name="rend">indent</xsl:attribute>
                            <xsl:value-of select="substring-after(., '(D) ')"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="l">
                            <xsl:attribute name="rend">indent</xsl:attribute>
                            <xsl:value-of select="substring-after(., '(D)')"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test=".[@rend='center']"> <!-- Gestion des cul de lampe -->
                <xsl:element name="l">
                    <xsl:attribute name="style">cul_de_lampe</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="./descendant::_3c_pb_3e_">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="contains(., '£')">
                <space quantity="1" unit="lignes"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="l">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="contains(.,'(C)')"> <!-- Gestion des alinéas -->
                <xsl:choose>
                    <xsl:when test="contains(.,'(C) ')">
                        <xsl:element name="p">
                            <xsl:attribute name="rend">indent</xsl:attribute>
                            <orig>⸿</orig>
                            <xsl:value-of select="substring-after(., '(C) ')"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="p">
                            <xsl:attribute name="rend">indent</xsl:attribute>
                            <xsl:value-of select="substring-after(., '(C)')"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains(.,'(D)')"> <!-- Gestion des alinéas -->
                <xsl:choose>
                    <xsl:when test="contains(.,'(D) ')">
                        <xsl:element name="p">
                            <xsl:attribute name="rend">indent</xsl:attribute>
                            <xsl:value-of select="substring-after(., '(D) ')"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="p">
                            <xsl:attribute name="rend">indent</xsl:attribute>
                            <xsl:value-of select="substring-after(., '(D)')"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test=".[@rend='center']"> <!-- Gestion des cul de lampe -->
                <xsl:element name="p">
                    <xsl:attribute name="rend">cul_de_lampe</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="p">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="_3c_pb_3e_">
        <xsl:element name="pb">
            <xsl:attribute name="n">
                <xsl:value-of select="substring-before(substring-after(., '['), ']')"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <!-- CORR / SIC -->
    
    <xsl:template match="erreurTypo">
        <xsl:choose>
            <xsl:when test="following-sibling::node()[1][local-name()='correctionTypo']">
                <xsl:element name="choice">
                    <xsl:element name="sic">
                        <xsl:apply-templates/>
                    </xsl:element>
                    <xsl:if test="following-sibling::node()[1][local-name()='correctionTypo']">
                        <xsl:element name="corr">
                            <xsl:value-of select="translate(normalize-space(following-sibling::correctionTypo[1]), '[]', '')"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="choice">
                    <xsl:element name="sic">
                        <xsl:apply-templates/>
                    </xsl:element>
                    <xsl:element name="corr"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="correctionTypo">
        <xsl:choose>
            <xsl:when test="preceding-sibling::node()[1][local-name()='erreurTypo']"/>
            <xsl:otherwise>
                <xsl:element name="choice">
                    <xsl:element name="sic"/>
                    <xsl:element name="corr">
                        <xsl:value-of select="translate(., '[]', '')"/>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
<!--======================================================
                       NORMALISATION
======================================================-->
    
     <!-- Documentation : 
         1. Le troisième argument, 'i' (flags, signifie que l'expression n'est pas sensible à la case (https://www.w3.org/TR/xpath-functions-31/#flags)
         Exemple : <xsl:when test="matches(., '(\w*)ãm(\w*)', 'i')">
         2. Les caractères spéciaux : sont à ajouter dans le <xsl:analyze-string> (afin de les matcher par la suite). 
     -->
     
    <xsl:template match="div1//*/text()">
        <xsl:analyze-string select="." regex="[A-Za-zàáâãäåçẽèéêëĩìíîïðõòóôõöùúũûüýÿp̃ꝛꝑq̃9()]+">
            <xsl:matching-substring>
                <xsl:choose>
                    
<!-- Résolution des abréviations : LES VOYELLES -->
                    
                    <xsl:when test="matches(., '(\w*)ãm(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ãm')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ãm</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>amm</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ãm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ãb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ãb')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ãb</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>amb</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ãb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ãp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ãp')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ãp</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>amp</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ãp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ãn(\w*)', 'i')">
                        <xsl:choose>
                            <xsl:when test="matches(., '(\w*)dãn(\w*)', 'i')">
                                <xsl:value-of select="substring-before(., 'dãn')"/>
                                <choice change="abréviation">
                                    <orig>
                                        <xsl:text>dãn</xsl:text>
                                    </orig>
                                    <reg>
                                        <xsl:text>damn</xsl:text>
                                    </reg>
                                </choice>
                                <xsl:value-of select="substring-after(., 'dãn')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-before(., 'ãn')"/>
                                <choice change="abréviation">
                                    <orig>
                                        <xsl:text>ãn</xsl:text>
                                    </orig>
                                    <reg>
                                        <xsl:text>amn</xsl:text>
                                    </reg>
                                </choice>
                                <xsl:value-of select="substring-after(., 'ãn')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ã[^(a|e|i|o|u|é|è|y)](\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ã')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>an</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ã')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ã$', 'i')">
                        <xsl:value-of select="substring-before(., 'ã')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>an</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ã')"/>
                    </xsl:when>

                    <xsl:when test="matches(., '(\w*)ẽm(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽm')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ẽm</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>emm</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ẽm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ẽb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽb')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ẽb</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>emb</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ẽb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ẽp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽp')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ẽp</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>emp</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ẽp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ẽn(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽn')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ẽn</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>emn</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ẽn')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ẽ[^(a|e|i|o|u|é|è|y)](\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽ')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>en</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ẽ')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ẽ$', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽ')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>en</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ẽ')"/>
                    </xsl:when>
                    
                    <xsl:when test="matches(., '(\w*)ĩm(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩm')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ĩm</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>imm</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ĩm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ĩb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩb')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ĩb</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>imb</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ĩb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ĩp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩp')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ĩp</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>imp</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ĩp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ĩn(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩn')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ĩn</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>imn</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ĩn')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ĩ[^(a|e|i|o|u|é|è|y)](\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩ')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ĩ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>in</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ĩ')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ĩ$', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩ')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ĩ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>in</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ĩ')"/>
                    </xsl:when>
                    
                    <xsl:when test="matches(., '(\w*)õm(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'õm')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>õm</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>omm</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'õm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)õb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'õb')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>õb</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>omb</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'õb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)õp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'õp')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>õp</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>omp</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'õp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)õn(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'õn')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>õn</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>omn</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'õn')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)õ[^(a|e|i|o|u|é|è|y)](\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'õ')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>on</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'õ')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)õ$', 'i')">
                        <xsl:value-of select="substring-before(., 'õ')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>on</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'õ')"/>
                    </xsl:when>
                    
                    <xsl:when test="matches(., '(\w*)ũm(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ũm')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ũm</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>umm</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ũm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ũb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ũb')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ũb</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>umb</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ũb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ũp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ũp')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ũp</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>ump</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ũp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ũn(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ũn')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ũn</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>umn</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ũn')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ũ[^(a|e|i|o|u|é|è|y)](\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ũ')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ũ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>un</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ũ')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ũ$', 'i')">
                        <xsl:value-of select="substring-before(., 'ũ')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ũ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>un</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ũ')"/>
                    </xsl:when>
                    
<!-- Résolution des abréviations : CAS PARTICULIERS -->
                    
                    <xsl:when test="matches(., '^(\w*)cõmãderẽt(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'õmãderẽ')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>omm</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>m</xsl:text>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>an</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>der</xsl:text>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>en</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'õmãderẽ')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)cõmẽcemẽt(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'õmẽcemẽ')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>omm</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>m</xsl:text>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>en</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>cem</xsl:text>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>en</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'õmẽcemẽ')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)cõseruatiõ(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'õseruatiõ')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>on</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>ser</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>ati</xsl:text>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>on</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'õseruatiõ')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ↄtinuellemẽt(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'õseruatiõ')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ↄ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>con</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>ser</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>ati</xsl:text>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>on</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'õseruatiõ')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ↄmãda(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ↄmãda')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ↄ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>con</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>m</xsl:text>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>an</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>da</xsl:text>
                        <xsl:value-of select="substring-after(., 'ↄmãda')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)cõdãnerẽt(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'õdãnerẽt')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>on</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>d</xsl:text>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>ãm</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>ner</xsl:text>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>en</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>t</xsl:text>
                        <xsl:value-of select="substring-after(., 'õdãnerẽt')"/>
                    </xsl:when>
                    
                    
<!-- Résolution des abréviations : LES CONSONNES -->
                    
                    <xsl:when test="matches(., '^(\w*)q̃$', 'i')">
                        <xsl:value-of select="substring-before(., 'q̃')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>q̃</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>que</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'q̃')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)p̃$', 'i')">
                        <xsl:value-of select="substring-before(., 'p̃')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>p̃</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>par</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'p̃')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ꝑ$', 'i')">
                        <xsl:value-of select="substring-before(., 'ꝑ')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ꝑ</xsl:text>
                            </orig>
                            <reg>
                                <!-- "par" ou "pre" : la résolution du p tildé dépend de son contexte (nous ne pouvons que le signaler) -->
                                <xsl:text>###</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ꝑ')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)\(et\)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ꝛ')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ꝛ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>et</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ꝛ')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)9(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., '9')"/>
                        <choice change="abréviation">
                            <orig>
                                <hi rend="sup"><xsl:text>9</xsl:text></hi>
                            </orig>
                            <reg>
                                <xsl:text>us</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., '9')"/>
                    </xsl:when>
                    
<!-- Résolution des abréviations : LES CONSONNES > ↄ (com/con) -->                    
                    
                    <xsl:when test="matches(., '^(\w*)ↄ$', 'i')">
                        <xsl:value-of select="substring-before(., 'ↄ')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ↄ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>com</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ↄ')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ↄp(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ↄp')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ↄ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>com</xsl:text>
                            </reg>
                            <xsl:text>p</xsl:text>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ↄp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ↄm(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ↄm')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ↄ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>com</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>m</xsl:text>
                        <xsl:value-of select="substring-after(., 'ↄm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ↄd(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ↄd')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ↄ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>con</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>d</xsl:text>
                        <xsl:value-of select="substring-after(., 'ↄd')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ↄt(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ↄt')"/>
                        <choice change="abréviation">
                            <orig>
                                <xsl:text>ↄ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>con</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>t</xsl:text>
                        <xsl:value-of select="substring-after(., 'ↄt')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > A > u/v -->

                    <xsl:when test="matches(., '^(\w*[^e])aue(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*[^e])aue(\w*)$')">
                            <xsl:value-of select="substring-before(., 'aue')"/>
                            <xsl:text>a</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>e</xsl:text>
                            <xsl:value-of select="substring-after(., 'aue')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*[^e])Aue(\w*)$')">
                            <xsl:value-of select="substring-before(., 'Aue')"/>
                            <xsl:text>A</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>e</xsl:text>
                            <xsl:value-of select="substring-after(., 'Aue')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)au(a|é|i|o|e)(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)au(a|é|i|o|e)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'au')"/>
                            <xsl:text>a</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'au')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Au(a|é|i|o|e)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'Au')"/>
                            <xsl:text>A</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'Au')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^adu(a|e|i|o)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^av$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)avme(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'avme')"/>
                        <xsl:text>a</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>me</xsl:text>
                        <xsl:value-of select="substring-after(., 'avme')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^avt(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > A > i/j -->                       
                    
                    <xsl:when test="matches(., '^i$', 'i')">
                        <xsl:value-of select="substring-before(., 'i')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <xsl:if test="matches(., '^i$')">
                                <reg>
                                    <xsl:text>j</xsl:text>
                                </reg>
                            </xsl:if>
                            <xsl:if test="matches(., '^I$')">
                                <reg>
                                    <xsl:text>J</xsl:text>
                                </reg>
                            </xsl:if>
                        </choice>
                        <xsl:value-of select="substring-after(., 'i')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^aiax$', 'i')">
                        <xsl:value-of select="substring-before(., 'i')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'i')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)aio(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)aio(\w*)$')">
                            <xsl:value-of select="substring-before(., 'aio')"/>
                            <xsl:text>a</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>i</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>j</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>o</xsl:text>
                            <xsl:value-of select="substring-after(., 'aio')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Aio(\w*)$')">
                            <xsl:value-of select="substring-before(., 'Aio')"/>
                            <xsl:text>A</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>i</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>j</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>o</xsl:text>
                            <xsl:value-of select="substring-after(., 'Aio')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^ajan(ts?|s)$', 'i')">
                        <xsl:value-of select="substring-before(., 'j')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>j</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>i</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'j')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^auiour(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'i')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'i')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^abi(e|u)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'i')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'i')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(co)?adio?(u|i?n|a)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'i')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'i')"/>
                    </xsl:when>
                              
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > u/v > B -->
                     
                    <xsl:when test="matches(., '^bouvrevil(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ev')"/>
                        <xsl:text>e</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ev')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(brauerie|brieue)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^bienuu?eu?il(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > u/v > C -->    
                    
                    <xsl:when test="matches(., '^(chevrevil|cerfevil)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)conve?s?$', 'i')">
                        <xsl:value-of select="substring-before(., 'onve')"/>
                        <xsl:text>on</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>e</xsl:text>
                        <xsl:value-of select="substring-after(., 'onve')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^cevl?x$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)ceve$', 'i')">
                        <xsl:value-of select="substring-before(., 'ceve')"/>
                        <xsl:text>ce</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>e</xsl:text>
                        <xsl:value-of select="substring-after(., 'ceve')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)continv(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'tinv')"/>
                        <xsl:text>tin</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'tinv')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)covrs(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ovrs')"/>
                        <xsl:text>o</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>rs</xsl:text>
                        <xsl:value-of select="substring-after(., 'ovrs')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ctevr(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'tevr')"/>
                        <xsl:text>te</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>r</xsl:text>
                        <xsl:value-of select="substring-after(., 'tevr')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)cvlev(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'vlev')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>le</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'vlev')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)ceur(a|o)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ceur')"/>
                        <choice change="lettre_ramiste">
                            <xsl:text>ce</xsl:text>
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>r</xsl:text>
                        <xsl:value-of select="substring-after(., 'ceur')"/>
                    </xsl:when> 
                    <xsl:when test="matches(., '^cheur(e|o)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(conui|conceuro)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)calui(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'alui')"/>
                        <xsl:text>al</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>alui</xsl:text>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)conu(e|é|o)(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'onu')"/>
                        <xsl:text>on</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'onu')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)cerue(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'erue')"/>
                        <xsl:text>er</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>e</xsl:text>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^cuiur(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ur')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>r</xsl:text>
                        <xsl:value-of select="substring-after(., 'ur')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^creué(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > C/D > i/j -->
                    
                    <xsl:when test="matches(., '^coni(oi|ur)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'i')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'i')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^desi(a|à)$', 'i')">
                        <xsl:value-of select="substring-before(., 'i')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'i')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > D > u/v -->                     
                    
                    <xsl:when test="matches(., '^(deur|déur)(a|o|i)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^des?liur(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^desu(i|o)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)douic(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'douic')"/>
                        <xsl:text>do</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>ic</xsl:text>
                        <xsl:value-of select="substring-after(., 'douic')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(d|v|s)evil(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ev')"/>
                        <xsl:text>e</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ev')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^diev(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^dv$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)(d|l)vc(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'vc')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>c</xsl:text>
                        <xsl:value-of select="substring-after(., 'vc')"/>
                    </xsl:when>
                       
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > E > u/v -->                    
                    
                    <xsl:when test="matches(., '^(\w+)edvi(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'edv')"/>
                        <xsl:text>ed</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'edv')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^evnv(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'evnv')"/>
                        <xsl:text>e</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>n</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'evnv')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)ebu(o|r)(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ebu')"/>
                        <xsl:text>eb</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ebu')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)es?ua(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)es?ua(\w*)$')">
                            <xsl:value-of select="substring-before(., 'ua')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>a</xsl:text>
                            <xsl:value-of select="substring-after(., 'ua')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Es?ua(\w*)$')">
                            <xsl:value-of select="substring-before(., 'ua')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>a</xsl:text>
                            <xsl:value-of select="substring-after(., 'ua')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)eru(a|e|é|o|i|y)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'eru')"/>
                        <xsl:text>eru</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'eru')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(eue|enuers)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)epu(o|e|a)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'epu')"/>
                        <xsl:text>epu</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'epu')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)ipu(o|e|a)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ipu')"/>
                        <xsl:text>ip</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ipu')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)eui[^l](\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)eui[^l](\w*)$')">
                            <xsl:value-of select="substring-before(., 'eui')"/>
                            <xsl:text>e</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>i</xsl:text>
                            <xsl:value-of select="substring-after(., 'eui')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Eui[^l](\w*)$')">
                            <xsl:value-of select="substring-before(., 'Eui')"/>
                            <xsl:text>E</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>i</xsl:text>
                            <xsl:value-of select="substring-after(., 'Eui')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(preuil|eue|enuelo)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)(e|l)ueu(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ueu')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>eu</xsl:text>
                        <xsl:value-of select="substring-after(., 'ueu')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)[^d]euem(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'uem')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>em</xsl:text>
                        <xsl:value-of select="substring-after(., 'uem')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)(ach|bl)eu(e|é)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)(ach|bl)eu(e|é)$')">
                            <xsl:value-of select="substring-before(., 'eu')"/>
                            <xsl:text>e</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'eu')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)(Ach|Bl)eu(e|é)$')">
                            <xsl:value-of select="substring-before(., 'eu')"/>
                            <xsl:text>e</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'eu')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)(e|é)s?uo(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'uo')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>o</xsl:text>
                        <xsl:value-of select="substring-after(., 'uo')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)(e|r)uiur(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'uiur')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>i</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>r</xsl:text>
                        <xsl:value-of select="substring-after(., 'uiur')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(r|al|bi)?enu(ie|ir|y|o|e)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)euei(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'uei')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>ei</xsl:text>
                        <xsl:value-of select="substring-after(., 'uei')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)eue(e|l|n|r|z|st|t)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ue')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>e</xsl:text>
                        <xsl:value-of select="substring-after(., 'ue')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)esue(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'sue')"/>
                        <xsl:text>s</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>e</xsl:text>
                        <xsl:value-of select="substring-after(., 'sue')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)euesq(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'uesq')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>esq</xsl:text>
                        <xsl:value-of select="substring-after(., 'uesq')"/>
                    </xsl:when>

<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > E > i/j -->                
               
                    <xsl:when test="matches(., '^(\w+)ei(et|o)(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ei')"/>
                        <xsl:text>e</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ei')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)eniam(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'niam')"/>
                        <xsl:text>n</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>am</xsl:text>
                        <xsl:value-of select="substring-after(., 'niam')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(e|E|co|Co)nioi(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'i')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'i')"/>
                    </xsl:when>

<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > F > u/v -->                    
                    
                    <xsl:when test="matches(., '^(fautevil|flevr|feville)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(fev|fvt)$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(f|F)i(e|é)ure(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^foruo(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > G > u/v -->  
                    
                    <xsl:when test="matches(., '^(\w*)gnevr(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'nevr')"/>
                        <xsl:text>ne</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>r</xsl:text>
                        <xsl:value-of select="substring-after(., 'nevr')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)gv(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)gv(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)gv(\w*)$')">
                            <xsl:value-of select="substring-before(., 'gv')"/>
                            <xsl:text>g</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'gv')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Gv(\w*)$')">
                            <xsl:value-of select="substring-before(., 'Gv')"/>
                            <xsl:text>g</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'Gv')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)graue(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'raue')"/>
                        <xsl:text>ra</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>e</xsl:text>
                        <xsl:value-of select="substring-after(., 'raue')"/>
                    </xsl:when>
                                
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > H > u/v -->  
                    
                    <xsl:when test="matches(., '^hvm(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > I > u/v -->  
                    
                    <xsl:when test="matches(., '^(\w*)inv(s|t)i(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'nv')"/>
                        <xsl:text>n</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'nv')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(i|j)ouial(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'oui')"/>
                        <xsl:text>o</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>i</xsl:text>
                        <xsl:value-of select="substring-after(., 'oui')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^iurog(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^uifue(\w+)$', 'i')">
                        <xsl:if test="matches(., '^uifue(\w+)$')">
                            <xsl:value-of select="substring-before(., 'uifu')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>if</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'uifu')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^Uifue(\w+)$')">
                            <xsl:value-of select="substring-before(., 'Uifu')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>U</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>V</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>if</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'Uifu')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^uiur(\w+)$', 'i')">
                        <xsl:if test="matches(., '^uiur(\w+)$')">
                            <xsl:value-of select="substring-before(., 'uiu')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>i</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'uiu')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^Uiur(\w+)$')">
                            <xsl:value-of select="substring-before(., 'Uiu')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>U</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>V</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>i</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'Uiu')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^innoü(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ü')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>ü</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ü')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)(i|ï|e)u?fue(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'fue')"/>
                        <xsl:text>f</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>e</xsl:text>
                        <xsl:value-of select="substring-after(., 'fue')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^inconu(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(i|c|est)uue(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'uu')"/>
                        <xsl:text>u</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'uu')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(tres)?inui(s|t|n|o)(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <xsl:text>u</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > I > i/j -->
                    
                    <xsl:when test="matches(., '^ie$', 'i')">
                        <xsl:if test="matches(., '^ie$')">
                            <xsl:value-of select="substring-before(., 'i')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>i</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>j</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'i')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^Ie$')">
                            <xsl:value-of select="substring-before(., 'I')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>I</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>J</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'I')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^ia(\w*)$', 'i')">
                        <xsl:if test="matches(., '^ia(\w*)$')">
                            <xsl:value-of select="substring-before(., 'i')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>i</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>j</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'i')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^Ia(\w*)$')">
                            <xsl:value-of select="substring-before(., 'I')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>I</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>J</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'I')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^iehan(\w*)$', 'i')">
                        <xsl:if test="matches(., '^iehan(\w*)$')">
                            <xsl:value-of select="substring-before(., 'i')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>i</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>j</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'i')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^Iehan(\w*)$')">
                            <xsl:value-of select="substring-before(., 'I')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>I</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>J</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'I')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^iesu(\w*)$', 'i')">
                        <xsl:if test="matches(., '^iesu(\w*)$')">
                            <xsl:value-of select="substring-before(., 'i')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>i</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>j</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'i')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^Iesu(\w*)$')">
                            <xsl:value-of select="substring-before(., 'I')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>I</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>J</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'I')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^iett(\w*)$', 'i')">
                        <xsl:if test="matches(., '^iett(\w*)$')">
                            <xsl:value-of select="substring-before(., 'i')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>i</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>j</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'i')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^Iett(\w*)$')">
                            <xsl:value-of select="substring-before(., 'I')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>I</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>J</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'I')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ieun(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)ieun(\w*)$')">
                            <xsl:value-of select="substring-before(., 'i')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>i</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>j</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'i')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Ieun(\w*)$')">
                            <xsl:value-of select="substring-before(., 'I')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>I</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>J</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'I')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^ieux?$', 'i')">
                        <xsl:if test="matches(., '^ieux?$')">
                            <xsl:value-of select="substring-before(., 'i')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>i</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>j</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'i')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^Ieux?$')">
                            <xsl:value-of select="substring-before(., 'I')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>I</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>J</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'I')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^io[^n](\w*)$', 'i')">
                        <xsl:if test="matches(., '^io[^n](\w*)$')">
                            <xsl:value-of select="substring-before(., 'i')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>i</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>j</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'i')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^Io[^n](\w*)$')">
                            <xsl:value-of select="substring-before(., 'I')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>I</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>J</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'I')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^ion(c|g)(\w*)$', 'i')">
                        <xsl:if test="matches(., '^ion(c|g)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'i')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>i</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>j</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'i')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^Ion(c|g)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'I')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>I</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>J</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'I')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^iu(\w*)$', 'i')">
                        <xsl:if test="matches(., '^iu(\w*)$')">
                            <xsl:value-of select="substring-before(., 'i')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>i</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>j</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'i')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^Iu(\w*)$')">
                            <xsl:value-of select="substring-before(., 'I')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>I</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>J</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'I')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^iniu(r|s)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'niu')"/>
                        <xsl:text>n</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>u</xsl:text>
                        <xsl:value-of select="substring-after(., 'niu')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^iniv(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'niv')"/>
                        <xsl:text>n</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'niv')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^iu(r|s)(\w*)$', 'i')">
                        <xsl:if test="matches(., '^iu(r|s)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'i')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>i</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>j</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'i')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^Iu(r|s)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'I')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>I</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>J</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'I')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)iect(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)iect(\w*)$')">
                            <xsl:value-of select="substring-before(., 'i')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>i</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>j</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'i')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Iect(\w*)$')">
                            <xsl:value-of select="substring-before(., 'I')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>I</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>J</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'I')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(ieusn|inue)(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(ieusn|inue)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'i')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>i</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>j</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'i')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(Ieusn|Inue)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'I')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>I</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>J</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'I')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^ivnon?$', 'i')">
                        <xsl:if test="matches(., '^ivnon?$')">
                            <xsl:value-of select="substring-before(., 'iv')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>i</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>j</xsl:text>
                                </reg> 
                            </choice>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'iv')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^Ivnon?$')">
                            <xsl:value-of select="substring-before(., 'Iv')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>I</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>J</xsl:text>
                                </reg> 
                            </choice>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'Iv')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)iu(e|i|o|a|é|y|ÿ)(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w+)iu(e|i|o|a|é|y|ÿ)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'iu')"/>
                            <choice change="lettre_ramiste">
                                <xsl:text>i</xsl:text>
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg>
                            </choice>
                            <xsl:text>u</xsl:text>
                            <xsl:value-of select="substring-after(., 'iu')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w+)Iu(e|i|o|a|é|y|ÿ)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'I')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>I</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>J</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>u</xsl:text>
                            <xsl:value-of select="substring-after(., 'Iu')"/>
                        </xsl:if>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > J > u/v -->  
                    
                    <xsl:when test="matches(., '^janui(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                                        
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > L > u/v -->
                    
                    <xsl:when test="matches(., '^levrs?$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(l|pr)ova(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)lvs(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'lvs')"/>
                        <xsl:text>l</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>s</xsl:text>
                        <xsl:value-of select="substring-after(., 'lvs')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)[^b]leu(e|è|é|rau)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'leu')"/>
                        <xsl:text>le</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'leu')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(leu|liéu|lieu)(e|è|é|rau)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^l(e|è)ure(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)liur(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'iur')"/>
                        <xsl:text>i</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>r</xsl:text>
                        <xsl:value-of select="substring-after(., 'iur')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(oliu|oual)(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>

<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > M > u/v -->  
                    
                    <xsl:when test="matches(., '^(\w*)mvn(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'vn')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>n</xsl:text>
                        <xsl:value-of select="substring-after(., 'vn')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)mvr(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'vr')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>r</xsl:text>
                        <xsl:value-of select="substring-after(., 'vr')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)meruei(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'eruei')"/>
                        <xsl:text>er</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>ei</xsl:text>
                        <xsl:value-of select="substring-after(., 'eruei')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*[^(m|M)])eurier(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'urier')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>rier</xsl:text>
                        <xsl:value-of select="substring-after(., 'urier')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > M > i/j -->
                    
                    <xsl:when test="matches(., '^maie(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'i')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'i')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)minv(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'inv')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>nv</xsl:text>
                        <xsl:value-of select="substring-after(., 'inv')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > N > u/v -->  
                    
                    <xsl:when test="matches(., '^(\w*)nevf(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'evf')"/>
                        <xsl:text>e</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>f</xsl:text>
                        <xsl:value-of select="substring-after(., 'evf')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^nvag(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)[^e]nvel(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'vel')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>el</xsl:text>
                        <xsl:value-of select="substring-after(., 'vel')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(nouic|naur|nepueu|nouembre)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)nua(sion|in)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'nua')"/>
                        <xsl:text>n</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>a</xsl:text>
                        <xsl:value-of select="substring-after(., 'nua')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > N > i/j -->
                    
                    <xsl:when test="matches(., '^(\w+)niur(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'niur')"/>
                        <xsl:text>n</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>ur</xsl:text>
                        <xsl:value-of select="substring-after(., 'niur')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > O > u/v -->  
                    
                    <xsl:when test="matches(., '^(\w+)ouveve(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ouveve')"/>
                        <xsl:text>ouve</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>e</xsl:text>
                        <xsl:value-of select="substring-after(., 'ouveve')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^covar(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ovf(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'vf')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>f</xsl:text>
                        <xsl:value-of select="substring-after(., 'vf')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ovz(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'vz')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>z</xsl:text>
                        <xsl:value-of select="substring-after(., 'vz')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^obui(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'bui')"/>
                        <xsl:text>b</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>i</xsl:text>
                        <xsl:value-of select="substring-after(., 'bui')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)oiu(e|r)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'oiu')"/>
                        <xsl:text>oi</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'oiu')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)oibue(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'oibue')"/>
                        <xsl:text>oib</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>e</xsl:text>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ouu(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'uu')"/>
                        <xsl:text>u</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'uu')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > P > u/v -->  
                    
                    <xsl:when test="matches(., '^povr$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^pvb(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)mpv(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'mpv')"/>
                        <xsl:text>mp</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'mpv')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^prevx?$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^paru(e|i)n(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)pa?oure(s|t\w*)?$', 'i')">
                        <xsl:value-of select="substring-before(., 'oure')"/>
                        <xsl:text>o</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>re</xsl:text>
                        <xsl:value-of select="substring-after(., 'oure')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(pouo|preiu)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^prou(en|i|o|eu|er)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > P > i/j -->
                    
                    <xsl:when test="matches(., '^pjece(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'j')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>j</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>i</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'j')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^p(a|e)riu(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'i')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'i')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > Q > u/v -->  

                    <xsl:when test="matches(., '^(\w*)qv(e|i|a|o)(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)qv(e|i|a|o)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'qv')"/>
                            <xsl:text>q</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'qv')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Qv(e|i|a|o)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'Qv')"/>
                            <xsl:text>Q</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>V</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>U</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'Qv')"/>
                        </xsl:if>
                    </xsl:when>
                    
                    <xsl:when test="matches(., '^queve(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > R > u/v -->  
               
                    <xsl:when test="matches(., '^(\w*)radv(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'adv')"/>
                        <xsl:text>ad</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'adv')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^recev$', 'i')">
                        <xsl:value-of select="substring-before(., 'v')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'v')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^reu(e|u)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(renuer|réue)(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^reuiu(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'uiu')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>i</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'euiu')"/>
                    </xsl:when>
               
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > R > i/j -->  
                    
                    <xsl:when test="matches(., '^(\w*)rajon(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ajon')"/>
                        <xsl:text>a</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>j</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>i</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>on</xsl:text>
                        <xsl:value-of select="substring-after(., 'ajon')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)reie(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'eie')"/>
                        <xsl:text>e</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>e</xsl:text>
                        <xsl:value-of select="substring-after(., 'eie')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^t?r?esio(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'sio')"/>
                        <xsl:text>s</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>o</xsl:text>
                        <xsl:value-of select="substring-after(., 'sio')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > S > u/v -->  
                    
                    <xsl:when test="matches(., '^svr$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <xsl:text>ui</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)(sa|p)ulu(e|o|a|é)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ulu')"/>
                        <xsl:text>ul</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ulu')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)seru(i|o)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'eru')"/>
                        <xsl:text>er</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'eru')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)solua(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'olu')"/>
                        <xsl:text>ol</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'olu')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^suru(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'uru')"/>
                        <xsl:text>ur</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'uru')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)suiu(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'uiu')"/>
                        <xsl:text>ui</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'uiu')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > S > i/j -->  
                    
                    <xsl:when test="matches(., '^sjec(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'j')"/>
                        <xsl:text>s</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>j</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>i</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>o</xsl:text>
                        <xsl:value-of select="substring-after(., 'j')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(as)?subi(e|u)(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'i')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'i')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)suiet(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'uiet')"/>
                        <xsl:text>u</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>et</xsl:text>
                        <xsl:value-of select="substring-after(., 'uiet')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > T > u/v -->  
                    
                    <xsl:when test="matches(., '^(\w*)trv(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)trv(\w*)$')">
                            <xsl:value-of select="substring-before(., 'trv')"/>
                            <xsl:text>tr</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'trv')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Trv(\w*)$')">
                            <xsl:value-of select="substring-before(., 'Trv')"/>
                            <xsl:text>Tr</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'Trv')"/>
                        </xsl:if>
                    </xsl:when>

                    <xsl:when test="matches(., '^(\w*)(pe|en|ti|c)tv(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'tv')"/>
                        <xsl:text>t</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'tv')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)tov(r|s)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ov')"/>
                        <xsl:text>o</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ov')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^tresui(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ui')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ui')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)trouer(s|e)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'rou')"/>
                        <xsl:text>ro</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'rou')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(g|t|p)reue(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'u')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'u')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > T > i/j -->
                    
                    <xsl:when test="matches(., '^(tousiours|touiours|tresiust)$', 'i')">
                        <xsl:value-of select="substring-before(., 'i')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>i</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>j</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'i')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > U > u/v -->  
                    
                    <xsl:when test="matches(., '^u(a|e|i|o|u|ra|re|ri|ro|ru|ul)(\w*)$', 'i')">
                        <xsl:if test="matches(., '^u(a|e|i|o|u|ra|re|ri|ro|ru|ul)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'u')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'u')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^U(a|e|i|o|u|ra|re|ri|ro|ru|ul)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'U')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>U</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>V</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'U')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)uru(o|u|eu)(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ru')"/>
                        <xsl:text>r</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ru')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)uul(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)uul(\w*)$')">
                            <xsl:value-of select="substring-before(., 'u')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'u')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Uul(\w*)$')">
                            <xsl:value-of select="substring-before(., 'U')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>U</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>V</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'U')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)(a|e|l)uu(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'uu')"/>
                        <xsl:text>u</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'uu')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^euu(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'uu')"/>
                        <xsl:text>u</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'uu')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)uyu(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'uyu')"/>
                        <xsl:text>uy</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'uyu')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > V > u/v -->  
                    
                    <xsl:when test="matches(., '^(\w*)vev(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ev')"/>
                        <xsl:text>e</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:value-of select="substring-after(., 'ev')"/>
                    </xsl:when>  
                    <xsl:when test="matches(., '^(\w*)vti(\w+)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)vti(\w+)$')">
                            <xsl:value-of select="substring-before(., 'vti')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>ti</xsl:text>
                            <xsl:value-of select="substring-after(., 'vti')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Vti(\w+)$')">
                            <xsl:value-of select="substring-before(., 'Vti')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>V</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>U</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>ti</xsl:text>
                            <xsl:value-of select="substring-after(., 'Vti')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^vl(\w+)$', 'i')">
                        <xsl:if test="matches(., '^vl(\w+)$')">
                            <xsl:value-of select="substring-before(., 'v')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'v')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^Vl(\w+)$')">
                            <xsl:value-of select="substring-before(., 'V')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>V</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>U</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'V')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)vle(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)vle(\w*)$')">
                            <xsl:value-of select="substring-before(., 'vle')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>le</xsl:text>
                            <xsl:value-of select="substring-after(., 'vle')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Vle(\w*)$')">
                            <xsl:value-of select="substring-before(., 'Vle')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>V</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>U</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>le</xsl:text>
                            <xsl:value-of select="substring-after(., 'Vle')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^vn(\w*)$', 'i')">
                        <xsl:if test="matches(., '^vn(\w*)$')">
                            <xsl:value-of select="substring-before(., 'v')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'v')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^Vn(\w*)$')">
                            <xsl:value-of select="substring-before(., 'V')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>V</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>U</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'V')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)vp(\w+)$', 'i')">
                        <xsl:if test="matches(., '^(\w+)vp(\w+)$')">
                            <xsl:value-of select="substring-before(., 'vp')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>p</xsl:text>
                            <xsl:value-of select="substring-after(., 'vp')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w+)Vp(\w+)$')">
                            <xsl:value-of select="substring-before(., 'Vp')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>V</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>U</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>p</xsl:text>
                            <xsl:value-of select="substring-after(., 'Vp')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^vr(b|g|l|n|r|s)(\w+)$', 'i')">
                        <xsl:if test="matches(., '^vr(b|g|l|n|r|s)(\w+)$')">
                            <xsl:value-of select="substring-before(., 'v')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'v')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^Vr(b|g|l|n|r|s)(\w+)$')">
                            <xsl:value-of select="substring-before(., 'V')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>V</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>U</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'V')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^v(b|s|t)(\w+)$', 'i')">
                        <xsl:if test="matches(., '^v(b|s|t)(\w+)$')">
                            <xsl:value-of select="substring-before(., 'v')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>v</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>u</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'v')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^V(b|s|t)(\w+)$')">
                            <xsl:value-of select="substring-before(., 'V')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>V</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>U</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'V')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)vmb(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)vmb(\w*)$')">
                            <xsl:value-of select="substring-before(., 'u')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'u')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Umb(\w*)$')">
                            <xsl:value-of select="substring-before(., 'U')"/>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>U</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>V</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'U')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w+)vlx$', 'i')">
                        <xsl:value-of select="substring-before(., 'vlx')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>lx</xsl:text>
                        <xsl:value-of select="substring-after(., 'vlx')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)viu[^s](\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)viu[^s](\w*)$')">
                            <xsl:value-of select="substring-before(., 'viu')"/>
                            <xsl:text>vi</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'viu')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Viu[^s](\w*)$')">
                            <xsl:value-of select="substring-before(., 'Viu')"/>
                            <xsl:text>vi</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'Viu')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^vingtvn(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'tvn')"/>
                        <xsl:text>t</xsl:text>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>v</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>u</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>n</xsl:text>
                        <xsl:value-of select="substring-after(., 'tvn')"/>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > V > i/j -->

<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > Y > u/v -->
                    
                    <xsl:when test="matches(., '^(\w*)yu(e|ro|oi)(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)yu(e|ro|oi)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'yu')"/>
                            <xsl:text>y</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'yu')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Yu(e|ro|oi)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'Yu')"/>
                            <xsl:text>Y</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:value-of select="substring-after(., 'Yu')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)yur(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)yur(\w*)$')">
                            <xsl:value-of select="substring-before(., 'yur')"/>
                            <xsl:text>y</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>r</xsl:text>
                            <xsl:value-of select="substring-after(., 'yur')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Yu(e|ro|oi)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'Yur')"/>
                            <xsl:text>Y</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>r</xsl:text>
                            <xsl:value-of select="substring-after(., 'Yur')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ÿur(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)ÿur(\w*)$')">
                            <xsl:value-of select="substring-before(., 'ÿur')"/>
                            <xsl:text>y</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>r</xsl:text>
                            <xsl:value-of select="substring-after(., 'ÿur')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Ÿur(\w*)$')">
                            <xsl:value-of select="substring-before(., 'Ÿur')"/>
                            <xsl:text>Ÿ</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>r</xsl:text>
                            <xsl:value-of select="substring-after(., 'Ÿur')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ÿuer(\w*)$', 'i')">
                        <xsl:if test="matches(., '^(\w*)ÿuer(\w*)$')">
                            <xsl:value-of select="substring-before(., 'ÿuer')"/>
                            <xsl:text>y</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>er</xsl:text>
                            <xsl:value-of select="substring-after(., 'ÿuer')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Ÿuer(\w*)$')">
                            <xsl:value-of select="substring-before(., 'Ÿuer')"/>
                            <xsl:text>Ÿ</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg> 
                            </choice>
                            <xsl:text>er</xsl:text>
                            <xsl:value-of select="substring-after(., 'Ÿuer')"/>
                        </xsl:if>
                    </xsl:when>
                    
<!-- Résolution des dissiminlations : LES LETTRES RAMISTES > Z > u/v -->  
                    
                    <xsl:when test="matches(., '^(\w*)(z|x)uing(\w+)$', 'i')">
                        <xsl:value-of select="substring-before(., 'uing')"/>
                        <choice change="lettre_ramiste">
                            <orig>
                                <xsl:text>u</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>v</xsl:text>
                            </reg> 
                        </choice>
                        <xsl:text>ing</xsl:text>
                        <xsl:value-of select="substring-after(., 'uing')"/>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
        
    </xsl:template>

</xsl:stylesheet>