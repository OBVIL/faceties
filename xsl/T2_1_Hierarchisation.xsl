<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Cette transformation prend en charge :
        - le nettoyage des balises parasites
        - le nettoyage du balisage du frontiespiece et header
        - la préparation des titres pour la hierarchisation
        - nettoyage des <l>, <p> et des <pb>
        - les désagglutinations
        - les <hi>
        - les images -->
    
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <xsl:comment>OBVIL, CHEVALIER Nolwenn. Projet Facéties. </xsl:comment>
        <xsl:comment>(T2.A) Transformation XML-ODT vers XML : <xsl:value-of  select="format-date(current-date(), '[M01]/[D01]/[Y0001]')"/> à <xsl:value-of select="format-dateTime(current-dateTime(), '[H01]:[m01]')"/>. </xsl:comment>
        <body>
            <!-- Regroupement des meta pour faciliter leur appel plus tard. -->
            <meta>
                <xsl:apply-templates select="descendant::term" mode="meta"/>
            </meta>
            <xsl:apply-templates/>
        </body>
    </xsl:template>
    
    <xsl:template match="term"/>
    
    <xsl:template match="body">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="text">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- Nettoyage des balises parasites -->
    <xsl:template match="*">
        <xsl:choose>
            <xsl:when test="matches(local-name(), '^T[0-9]+$')">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="matches(local-name(), '^T$')">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="matches(local-name(), '^Normal$')">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="contains(local-name(), 'Police')">
                <xsl:apply-templates/>
            </xsl:when>
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
    
    <!--
    ===================================
            NETTOYAGE DU HEADER
    ===================================
    -->

    <xsl:template match="term" mode="meta">
        <xsl:if test="starts-with(., 'titre')">
            <xsl:element name="title">
                <xsl:value-of select="substring-after(., ': ')"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="starts-with(., 'author')">
            <xsl:element name="author">
                <xsl:value-of select="substring-after(., ': ')"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="starts-with(., 'publisher')">
            <xsl:element name="publisher">
                <xsl:value-of select="substring-after(., ': ')"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="starts-with(., 'idno')">
            <xsl:element name="idno">
                <xsl:value-of select="replace(replace(substring-after(., ': '),'.site/','.fr/'), 'http://http://', 'http://')"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="starts-with(., 'issued')">
            <xsl:element name="date">
                <xsl:attribute name="when">
                    <xsl:value-of select="substring-after(., ': ')"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="starts-with(., 'source')">
            <xsl:element name="sourceDesc">
                <xsl:element name="bibl">
                    <xsl:value-of select="substring-after(., ': ')"/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:if test="starts-with(., 'created')">
            <xsl:element name="creation">
                <xsl:element name="date">
                    <xsl:attribute name="when">
                        <xsl:value-of select="substring-after(., ': ')"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:if test="starts-with(., 'langue')">
            <xsl:element name="langUsage">
                <xsl:element name="language">
                    <xsl:attribute name="ident">
                        <xsl:value-of select="substring-after(., ': ')"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:if test="starts-with(., 'lieu')">
            <xsl:element name="term">
                <xsl:attribute name="type">lieu</xsl:attribute>
                <xsl:value-of select="substring-after(., ': ')"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="starts-with(., 'personnage')">
            <xsl:element name="term">
                <xsl:attribute name="type">personnage</xsl:attribute>
                <xsl:value-of select="substring-after(., ': ')"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <!--
    =============================
                FRONT
    =============================
    -->
    
    <xsl:template match="front">
        <xsl:element name="frontiespiece">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="node()[starts-with(name(), 'front_')]">
        <xsl:for-each select=".">
            <xsl:element name="titre">
                <xsl:attribute name="niv">
                    <xsl:value-of select="substring-after(name(),'front_5f_')"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="figure_">
        <xsl:element name="figure">
            <xsl:element name="graphic">
                <xsl:attribute name="url">
                    <xsl:value-of select="./text()"/>
                    <!--<xsl:text>.jpg</xsl:text>-->
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="node()[starts-with(name(), 'epigraph_')]">
        <xsl:for-each select=".">
            <xsl:element name="titre">
                <xsl:attribute name="type">
                    <xsl:value-of select="substring-after(name(),'epigraph_5f_')"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="node()[starts-with(name(), 'docImprint_')]">
        <xsl:for-each select=".">
            <xsl:element name="titre">
                <xsl:attribute name="niv">
                    <xsl:value-of select="substring-after(name(),'docImprint_5f_')"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    
    <!--
    =======================================
                CONTENU : TITRES
    =======================================
    -->
    
    <xsl:variable name="ABC">ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÈÉÊËÌÍÎÏÐÑÒÓÔÕÖŒÙÚÛÜÝ </xsl:variable>
    <xsl:variable name="abc">abcdefghijklmnopqrstuvwxyzaaaaaaeeeeeiiiidnoooooœuuuuy_</xsl:variable>
    
    <xsl:template match="node()[starts-with(name(), 'titre')]">
        <xsl:for-each select=".">
            <xsl:element name="titre">
                <xsl:attribute name="niv">
                    <xsl:value-of select="substring-after(name(),'titre')"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <!--  Niveau ? : les speaker sont un peu différent, on ne peut pas leur attribuer un niveau fixe puisqu'on pourrait tout aussi bien les retrouver dans une div1 ou div2, etc. C'est pourquoi le template suivant permet de leur attribuer un niveau en fonction du titre qui les précède (ex. : derrière un titre 2, on aura un speaker de niveau 3) -->
    <xsl:template match="speaker">
        <xsl:element name="titre">
            <xsl:attribute name="niv">
                <xsl:variable name="pere">
                    <xsl:variable name="element" select="preceding::node()[starts-with(name(), 'titre')][1]/name()"/>
                    <xsl:value-of select="number(substring-after($element,'titre'))"/>
                </xsl:variable>
                <xsl:value-of select="$pere + 1"/>
            </xsl:attribute>
            <xsl:element name="speaker">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="back">
            <xsl:element name="titre">
                <xsl:attribute name="niv">1</xsl:attribute>
                <xsl:text>back</xsl:text>
            </xsl:element>
            <xsl:apply-templates/>
    </xsl:template>
    
    <!--
    =======================================
                CONTENU : CONTENU
    =======================================
    -->
    
    <!-- Structure du texte -->
    
    <xsl:template match="l">
        <xsl:choose>
            <xsl:when test="contains(., '(C)')">
                <!-- l > Gestion des alinéas -->
                <xsl:choose>
                    <xsl:when test="contains(., '(C)')">
                        <xsl:element name="l">
                           <xsl:attribute name="rend">indent</xsl:attribute>
                            <g type="pied_de_mouche">⸿</g>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="substring-after(., '(C)')"/>
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
            <xsl:when test="contains(., '(D)')">
                <!-- l > Gestion des alinéas -->
                <xsl:choose>
                    <xsl:when test="contains(., '(D)')">
                        <xsl:element name="l">
                            <xsl:attribute name="rend">indent</xsl:attribute>
                            <xsl:value-of select="substring-after(., '(D)')"/>
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
            <xsl:when test=".[@rend = 'center']">
                <!-- l > Gestion des cul de lampe -->
                <xsl:element name="l">
                    <xsl:attribute name="style">cul_de_lampe</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="./descendant::pb">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="contains(., '£')">
                <space quantity="1" unit="line"/>
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
            <xsl:when test="contains(., '(C)')">
                <!-- p > Gestion des alinéas -->
                <xsl:choose>
                    <xsl:when test="contains(., '(C)')">
                        <xsl:element name="p">
                            <xsl:attribute name="rend">indent</xsl:attribute>
                            <g type="pied_de_mouche">⸿</g>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="substring-after(., '(C)')"/>
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
            <xsl:when test="contains(., '(D)')">
                <!-- p > Gestion des alinéas -->
                <xsl:choose>
                    <xsl:when test="contains(., '(D)')">
                        <xsl:element name="p">
                            <xsl:attribute name="rend">indent</xsl:attribute>
                            <xsl:value-of select="substring-after(., '(D)')"/>
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
            <xsl:when test=".[@rend = 'center']">
                <!-- p > Gestion des cul de lampe -->
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
    
    <xsl:template match="pc">
        <xsl:element name="pc">
            <xsl:element name="choice">
                <xsl:attribute name="style">ponctuation</xsl:attribute>
                <xsl:element name="orig"/>
                <xsl:element name="reg">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ab">
        <xsl:element name="ab">
            <xsl:attribute name="type">ornament</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*/pb[1]">
            <xsl:choose>
                <xsl:when test="following-sibling::pb">
                    <xsl:element name="pb">
                           <xsl:apply-templates/>
                        <xsl:if test="following-sibling::pb">
                           <xsl:value-of select="following-sibling::pb"/>
                        </xsl:if>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="preceding-sibling::pb"/>
            </xsl:choose>
    </xsl:template>
    
    <xsl:template match="pb"/>

    <!-- STYLE DE CARACTERES -->
    
    <!-- Désagglutination -->
    
    <xsl:template match="orig">
        <xsl:choose>
            <!-- Désagglutination -->
            <xsl:when test="matches(., ' ')">
                <xsl:choose>
                    <xsl:when test="following-sibling::node()[1][local-name() = 'reg']">
                        <xsl:element name="choice">
                            <xsl:attribute name="style">désagglutination</xsl:attribute>
                            <xsl:element name="orig">
                                <xsl:apply-templates/>
                            </xsl:element>
                            <xsl:if test="following-sibling::node()[1][local-name() = 'reg']">
                                <xsl:element name="reg">
                                    <xsl:value-of
                                        select="following-sibling::reg[1]"
                                    />
                                </xsl:element>
                            </xsl:if>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="choice">
                            <xsl:attribute name="style">désagglutination</xsl:attribute>
                            <xsl:element name="orig">
                                <xsl:apply-templates/>
                            </xsl:element>
                            <xsl:element name="reg"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- Autre -->
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="following-sibling::node()[1][local-name() = 'reg']">
                        <xsl:element name="choice">
                            <xsl:element name="orig">
                                <xsl:apply-templates/>
                            </xsl:element>
                            <xsl:if test="following-sibling::node()[1][local-name() = 'reg']">
                                <xsl:element name="reg">
                                    <xsl:value-of
                                        select="following-sibling::reg[1]"
                                    />
                                </xsl:element>
                            </xsl:if>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="choice">
                            <xsl:attribute name="style">désagglutination</xsl:attribute>
                            <xsl:element name="orig">
                                <xsl:apply-templates/>
                            </xsl:element>
                            <xsl:element name="reg"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="reg">
        <xsl:choose>
            <!-- Désagglutination -->
            <xsl:when test="matches(., ' ')">
                <xsl:choose>
                    <xsl:when test="preceding-sibling::node()[1][local-name() = 'orig']"/>
                    <xsl:otherwise>
                        <xsl:element name="choice">
                            <xsl:attribute name="style">désagglutination</xsl:attribute>
                            <xsl:element name="orig"/>
                            <xsl:element name="reg">
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- Autre -->
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="preceding-sibling::node()[1][local-name() = 'orig']"/>
                    <xsl:otherwise>
                        <xsl:element name="choice">
                            <xsl:element name="orig"/>
                            <xsl:element name="reg">
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Majuscules, petites majuscules, italique, etc -->
    
    <xsl:template match="node()[starts-with(name(), 'style_')]">
        <xsl:for-each select=".">
            <xsl:element name="hi">
                <xsl:attribute name="rend">
                    <xsl:value-of select="substring-after(name(),'style_')"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="mevital">
        <xsl:element name="hi">
            <xsl:attribute name="rend">i</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="mevgras">
        <xsl:element name="hi">
            <xsl:attribute name="rend">b</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- Lettrines -->
    
    <xsl:template match="node()[starts-with(name(), 'lettrine')]">
        <xsl:for-each select=".">
            <xsl:element name="c">
                <xsl:attribute name="rend">lettrine</xsl:attribute>
                <xsl:attribute name="style">
                    <xsl:text>font-size:</xsl:text>
                    <xsl:value-of select="substring-after(name(),'lettrine')"/>
                    <xsl:text>em</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Ornement -->
    
    <xsl:template match="node()[starts-with(name(), 'orn_')]">
        <xsl:for-each select=".">
            <xsl:element name="g">
                <xsl:attribute name="type">
                    <xsl:value-of select="substring-after(name(),'orn_')"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Restitution (pour les lettres un peu effacées) -->
    
    <xsl:template match="damage">
        <xsl:element name="damage">
            <xsl:attribute name="type">efface</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- Citation étrangère -->
    
    <xsl:template match="node()[starts-with(name(), 'foreign')]">
        <xsl:for-each select=".">
            <xsl:element name="foreign">
                <xsl:attribute name="xml:lang">
                    <xsl:value-of select="substring-after(name(),'foreign_')"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
        
    <!-- IMAGES -->
    
    <xsl:template match="figure">
        <xsl:element name="figure">
            <xsl:element name="graphic">
                <xsl:attribute name="url">
                    <xsl:value-of select="./text()"/>
                    <!--<xsl:text>.jpg</xsl:text>-->
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>