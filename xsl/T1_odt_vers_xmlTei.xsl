<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


    <!--===========================================================
        ========== Structure Générale du fichier XML-TEI ==========
        ===========================================================-->


    <xsl:template match="office:text">
        <TEI>
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
            <xsl:for-each
                select="/office:document-content/office:body/office:text/text:p[@text:style-name = 'term']">
                <xsl:if test="contains(child::text(), 'Titre')">
                    <xsl:element name="title">
                        <xsl:value-of select="substring-after(child::text(), ': ')"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="contains(child::text(), 'author')">
                    <xsl:element name="author">
                        <xsl:value-of select="substring-after(child::text(), ': ')"/>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <!--Création de l'editionStmt-->
    <xsl:template name="editionStmt">
        <edition>OBVIL</edition>
        <xsl:for-each
            select="/office:document-content/office:body/office:text/text:p[@text:style-name = 'term']">
            <xsl:if test="contains(child::text(), 'resp')">
                <xsl:element name="respStmt">
                    <xsl:element name="name">
                        <xsl:variable name="resp" select="substring-before(child::text(), ' | ')"/>

                        <xsl:variable name="name" select="substring-after($resp, ': ')"/>

                        <xsl:value-of select="$name"/>
                    </xsl:element>
                    <xsl:element name="resp">
                        <xsl:value-of select="substring-after(child::text(), ' | ')"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
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
            <xsl:for-each
                select="/office:document-content/office:body/office:text/text:p[@text:style-name = 'term']">
                <xsl:if test="contains(child::text(), 'publisher')">
                    <xsl:element name="publisher">
                        <xsl:value-of select="substring-after(child::text(), ': ')"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="contains(child::text(), 'issued')">
                    <xsl:element name="date">
                        <xsl:attribute name="when">
                            <xsl:value-of select="substring-after(child::text(), ': ')"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="contains(child::text(), 'idno')">
                    <xsl:element name="idno">
                        <xsl:value-of select="substring-after(child::text(), ': ')"/>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
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
                <xsl:for-each
                    select="/office:document-content/office:body/office:text/text:p[@text:style-name = 'term']">
                    <xsl:if test="contains(child::text(), 'Titre')">
                        <xsl:element name="hi">
                            <xsl:attribute name="rend">i</xsl:attribute>
                            <xsl:value-of select="substring-after(child::text(), ': ')"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="contains(child::text(), 'author')">
                        <xsl:element name="author">
                            <xsl:value-of select="substring-after(child::text(), ': ')"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="contains(child::text(), 'pubPlace')">
                        <xsl:element name="pubPlace">
                            <xsl:value-of select="substring-after(child::text(), ': ')"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="contains(child::text(), 'publisher')">
                        <xsl:element name="publisher">
                            <xsl:value-of select="substring-after(child::text(), ': ')"/>
                        </xsl:element>
                    </xsl:if>

                    <xsl:if test="contains(child::text(), 'created')">
                        <xsl:element name="date">
                            <xsl:value-of select="substring-after(child::text(), ': ')"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="contains(child::text(), 'biblScope')">
                        <xsl:element name="biblScope">
                            <xsl:value-of select="substring-after(child::text(), ': ')"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!--======= profileDesc ========-->

    <xsl:template name="profileDesc">
        <xsl:for-each
            select="/office:document-content/office:body/office:text/text:p[@text:style-name = 'term']">
            <xsl:if test="contains(child::text(), 'created')">
                <xsl:element name="creation">
                    <xsl:element name="date">
                        <xsl:attribute name="when">
                            <xsl:value-of select="substring-after(child::text(), ': ')"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:if test="contains(child::text(), 'langue')">
                <xsl:element name="langUsage">
                    <xsl:element name="language">
                        <xsl:attribute name="ident">
                            <xsl:value-of select="substring-after(child::text(), ': ')"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
        <xsl:call-template name="textClass"/>
    </xsl:template>

    <!--S'il y a des mots clés (<keywords/>, stylés en "term")-->

    <xsl:template name="textClass">
        <xsl:element name="textClass">
            <xsl:element name="keywords">
                <xsl:for-each
                    select="/office:document-content/office:body/office:text/text:p[@text:style-name = 'term']">
                    <xsl:if test="contains(child::text(), 'lieu')">
                        <xsl:element name="term">
                            <xsl:attribute name="n">lieu</xsl:attribute>
                            <xsl:value-of select="substring-after(child::text(), ': ')"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="contains(child::text(), 'personnage')">
                        <xsl:element name="term">
                            <xsl:attribute name="n">personnage</xsl:attribute>
                            <xsl:value-of select="substring-after(child::text(), ': ')"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
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
            <xsl:if test="@text:style-name = 'term'"/>
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
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!--    <xsl:template match="text:p" name="body">
        <xsl:element name="{local-name()}">
            <xsl:for-each select="./@*">
                <xsl:attribute name="{local-name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>-->


</xsl:stylesheet>
