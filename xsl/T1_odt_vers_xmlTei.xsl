<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="metafile"
        select="document('zip:file:/Users/obvil/Documents/GitHub/faceties/test/faceties_005.odt!/meta.xml')"/>

    <!--Accéder aux métadonnées du fichier odt-->
    <xsl:variable name="meta" select="$metafile//office:document-meta/office:meta/meta:user-defined"/>

    <!--===========================================================
        ========== Structure Générale du fichier XML-TEI ==========
        ===========================================================-->

    <xsl:template match="office:text">
        <TEI>
            <xsl:value-of select="$meta[@meta:name = 'author']"/>
            <teiHeader>
                <fileDesc>
                    <xsl:call-template name="titleStmt"/>
                    <xsl:call-template name="editionStmt"/>
                    <xsl:call-template name="publicationStmt"/>
                    <xsl:call-template name="sourceDesc"/>
                </fileDesc>
                <profilDesc>
                    <xsl:call-template name="profileDesc"/>
                </profilDesc>
            </teiHeader>
            <text>
                <xsl:call-template name="front"/>
                <body>
                    <xsl:call-template name="texte"/>
                </body>
            </text>
        </TEI>
    </xsl:template>

    <!--=================================================
        =========== Construction du teiHeader ===========
        =================================================-->


    <!--======= fileDesc ========-->

    <!--Création du TitleStmt-->
    <xsl:template name="titleStmt">
        <xsl:element name="titleStmt">
            <xsl:element name="title">
                <xsl:value-of select="$meta[@meta:name = 'title']"/>
            </xsl:element>
            <xsl:for-each select="$meta[@meta:name = 'author']">
                <xsl:element name="author">
                    <xsl:value-of select="$meta[@meta:name = 'author']"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <!--Création de l'editionStmt-->
    <xsl:template name="editionStmt">
        <edition>OBVIL</edition>
        <xsl:for-each select="$meta[@meta:name = 'resp']">
            <xsl:element name="respStmt">
                <xsl:element name="name">
                    <xsl:value-of
                        select="replace($meta[@meta:name = 'resp'], '(\w+ \w+) \([^\)]+\)', '$1')"/>
                </xsl:element>
                <xsl:element name="resp">
                    <xsl:value-of
                        select="replace($meta[@meta:name = 'resp'], '\w+ \w+ \(([^\)]+)\)', '$1')"/>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
        <respStmt>
            <name>Nolwenn Chevalier</name>
            <resp>édition XML-TEI / XSLT</resp>
        </respStmt>
        <respStmt>
            <name>Anne-Laure Huet</name>
            <resp>édition XML-TEI / XSLT / HTML</resp>
        </respStmt>
        <respStmt>
            <name>Arthur Provenier</name>
            <resp>édition XML-TEI /XSLT / HTML</resp>
        </respStmt>
    </xsl:template>

    <!--Création du publicationStmt-->
    <xsl:template name="publicationStmt">
        <xsl:element name="publicationStmt">
            <xsl:element name="publisher">
                <xsl:value-of select="$meta[@meta:name = 'publisher']"/>
            </xsl:element>
            <xsl:element name="date">
                <xsl:attribute name="when">
                    <xsl:value-of select="$meta[@meta:name = 'dateEd']"/>
                </xsl:attribute>
            </xsl:element>
            <xsl:element name="idno">
                <xsl:value-of select="$meta[@meta:name = 'idno']"/>
            </xsl:element>
            <availability status="restricted">
                <licence target="http://creativecommons.org/licenses/by-nc-nd/3.0/fr/">
                    <p>Cette ressource électronique protégée par le code de la propriété
                        intellectuelle sur les bases de données (L341-1) est mise à disposition de
                        la communauté scientifique internationale par l’OBVIL, selon les termes de
                        la licence Creative Commons : « Attribution - Pas d’Utilisation Commerciale
                        - Pas de Modification 3.0 France (CCBY-NC-ND 3.0 FR) ».</p>
                    <p>Attribution : afin de référencer la source, toute utilisation ou publication
                        dérivée de cette ressource électroniques comportera le nom de l’OBVIL et
                        surtout l’adresse Internet de la ressource.</p>
                    <p>Pas d’Utilisation Commerciale : dans l’intérêt de la communauté scientifique,
                        toute utilisation commerciale est interdite.</p>
                    <p>Pas de Modification : l’OBVIL s’engage à améliorer et à corriger cette
                        ressource électronique, notamment en intégrant toutes les contributions
                        extérieures, la diffusion de versions modifiées de cette ressource n’est pas
                        souhaitable.</p>
                </licence>
            </availability>
        </xsl:element>
    </xsl:template>

    <!--Création du sourceDesc-->
    <xsl:template name="sourceDesc">
        <xsl:element name="sourceDesc">
            <xsl:element name="bibl">
                <xsl:element name="hi">
                    <xsl:attribute name="rend">i</xsl:attribute>
                    <xsl:value-of select="$meta[@meta:name = 'title']"/>
                </xsl:element>
                <xsl:element name="author">
                    <xsl:value-of select="$meta[@meta:name = 'author']"/>
                </xsl:element>
                <xsl:element name="pubPlace">
                    <xsl:value-of select="$meta[@meta:name = 'pubPlace']"/>
                </xsl:element>
                <xsl:element name="publisher">
                    <xsl:value-of select="$meta[@meta:name = 'publisher']"/>
                </xsl:element>
                <xsl:element name="date">
                    <xsl:value-of select="$meta[@meta:name = 'dateCreation']"/>
                </xsl:element>
                <xsl:element name="biblScope">
                    <xsl:value-of select="$meta[@meta:name = 'localisation']"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!--======= profileDesc ========-->

    <xsl:template name="profileDesc">
        <xsl:element name="creation">
            <xsl:element name="date">
                <xsl:attribute name="when">
                    <xsl:value-of select="$meta[@meta:name = 'dateCreation']"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
        <xsl:element name="langUsage">
            <xsl:element name="language">
                <xsl:attribute name="ident">
                    <xsl:value-of select="$meta[@meta:name = 'langue']"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
        <xsl:call-template name="textClass"/>
    </xsl:template>


    <!--S'il y a des mots-clés (lieu/personnage)-->
    <xsl:template name="textClass">
        <xsl:if test="$meta[@meta:name = 'personnage1'] or $meta[@meta:name = 'lieu1']">
            <xsl:element name="textClass">
                <xsl:element name="keywords">
                    <xsl:for-each select="$meta/@meta:name">
                        <xsl:if test="matches(., 'lieu|personnage')">
                            <xsl:variable name="n" select="replace(.,'\d','')"/>
                            <xsl:variable name="text" select="parent::node()/text()"/>
                                <xsl:element name="term">
                                <xsl:attribute name="n"><xsl:value-of select="$n"/></xsl:attribute>
                                    <xsl:value-of select="$text"/>
                                </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:if>

    </xsl:template>


    <!--==========TEXT============-->
    
    <!--========================================
        ========== Construction du front =======
        ========================================-->
   
   
    <!-- Si il y a un front (vérification avec style frontTitleMain)-->
    <xsl:template
        match="document-content/office:body/office:text/text:p[@text:style-name = 'frontTitleMain']"
        name="front">
        <xsl:element name="front">
            <xsl:element name="titlePage">
                <xsl:element name="docTitle">
                    <xsl:element name="titlePart">
                        <xsl:attribute name="type">main</xsl:attribute>
                        <xsl:value-of
                            select="/office:document-content/office:body/office:text/text:p[@text:style-name = 'frontTitleMain']"
                        />
                    </xsl:element>
                    <xsl:call-template name="frontSubtitle"/>
                </xsl:element>
                <xsl:call-template name="frontFigure"/>
                <xsl:call-template name="docImprint"/>
                <xsl:call-template name="frontEpigraph"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!--Si il y a un sous titre au front (frontSubtitle)-->
    <xsl:template
        match="/office:document-content/office:body/office:text/text:p[@text:style-name = 'frontSubtitle']"
        name="frontSubtitle">
        <xsl:element name="titlePart">
            <xsl:attribute name="type">subtitle</xsl:attribute>
            <xsl:value-of
                select="/office:document-content/office:body/office:text/text:p[@text:style-name = 'frontSubtitle']"
            />
        </xsl:element>
    </xsl:template>
    
    <!--Si il y une image dans le front (frontFigure)-->
    <xsl:template
        match="/office:document-content/office:body/office:text/text:p[@text:style-name = 'frontFigure']"
        name="frontFigure">
        <xsl:element name="figure">
            <xsl:element name="graphic">
                <xsl:attribute name="url">
                    <xsl:value-of
                        select="/office:document-content/office:body/office:text/text:p[@text:style-name = 'frontFigure']"
                    />
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!--Si il y a mention de l'imprimeur dans le front (docImprint)-->
    <xsl:template
        match="/office:document-content/office:body/office:text/text:p[@text:style-name = 'docImprint']"
        name="docImprint">
        <xsl:element name="docImprint">
            <xsl:value-of
                select="/office:document-content/office:body/office:text/text:p[@text:style-name = 'docImprint']"
            />
        </xsl:element>
    </xsl:template>
    
    <!--Si il y a un épigraphe (frontEpigraph)-->
    <xsl:template
        match="/office:document-content/office:body/office:text/text:p[@text:style-name = 'frontEpigraph']"
        name="frontEpigraph">
        <xsl:element name="epigraph">
            <xsl:element name="p">
                <xsl:value-of
                    select="/office:document-content/office:body/office:text/text:p[@text:style-name = 'frontEpigraph']"
                />
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!--========================================
        ========== Construction du body ========
        ========================================-->
    
    <xsl:template match="text:p" name="texte">
        <xsl:for-each select="/office:document-content/office:body/office:text/text:p">
            <xsl:if test="@text:style-name = 'Standard'">
                <xsl:if test="child::node() = text:span[@text:style-name = 'pb']">
                    <xsl:element name="pb">
                        <xsl:variable name="pb" select="replace(text:span[@text:style-name = 'pb'], '\[|\]|\s', '')"/>
                        <xsl:attribute name="n">
                            <xsl:value-of select="$pb"/>
                        </xsl:attribute>
                        <xsl:attribute name="xml:id">
                            <xsl:value-of select="$pb"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="child::node() = text:a">
                    <xsl:element name="pb">
                        <xsl:variable name="pb" select="replace(child::node()/text:span[@text:style-name = 'pb'], '\[|\]|\s', '')"/>
                        <xsl:attribute name="n">
                            <xsl:value-of select="$pb"/>
                        </xsl:attribute>
                        <xsl:attribute name="xml:id">
                            <xsl:value-of select="$pb"/>
                        </xsl:attribute>
                        <xsl:attribute name="facs">
                            <xsl:value-of select="child::node()/@xlink:href"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:if>
            </xsl:if>
            <xsl:if test="starts-with(@text:style-name, 'titre')">
                <xsl:variable name="balise" select="@text:style-name"/>
                <xsl:variable name="text" select="."/>
                <xsl:element name="{$balise}">
                    <xsl:value-of select="$text"/>
                </xsl:element>
            </xsl:if>
            
            <xsl:if test="@text:style-name = 'l'">
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
