<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
   <!--  Prépare les titres pour la hierarchisation -->
    
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <body>
            <!-- Regroupement des meta pour faciliter leur appel plus tard. -->
            <meta>
                <xsl:apply-templates select="descendant::_3c_term_3e_" mode="meta"/>
            </meta>
            <xsl:apply-templates/>
        </body>
    </xsl:template>
    
    <xsl:template match="_3c_term_3e_"/>
    
    <xsl:template match="body">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="text">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:choose>
            <!-- (Note) On s'occupe des éventuels parasites-->
            <xsl:when test="matches(local-name(), '^T[0-9]+$')">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="matches(local-name(), '^T$')">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="contains(local-name(), 'Police')">
                <xsl:apply-templates/>
            </xsl:when>
            <!-- (Note) Le reste des éléments et leurs attributs sont matchés à l'identique -->
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

    <xsl:template match="_3c_term_3e_" mode="meta">
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
        <xsl:if test="starts-with(., 'language')">
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
            <xsl:apply-templates mode="front"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="_3c_Pagedetitre_5f_titre_3e_" mode="front">
        <xsl:element name="head">
            <xsl:attribute name="type">main</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="_3c_Pagedetitre_5f_sous-titre_3e_" mode="front">
        <xsl:element name="head">
            <xsl:attribute name="type">sub</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="_3c_figure_3e_" mode="front">
        <xsl:element name="div">
            <xsl:element name="p">
                <xsl:attribute name="rend">center</xsl:attribute>
                <xsl:value-of select=".//text()"></xsl:value-of>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!--
    =======================================
                CONTENU : TITRES
    =======================================
    -->
    
    <xsl:template match="_3c_Pagedetitre_5f_sous-titre_3e_">
        <xsl:element name="titre">
            <xsl:attribute name="niv">1</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="h">
        <xsl:element name="titre">
            <xsl:attribute name="niv">2</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="_3c_speaker_3e_">
        <xsl:element name="titre">
            <xsl:attribute name="niv">3</xsl:attribute>
            <xsl:element name="speaker">
                <xsl:attribute name="who">
                    <xsl:value-of select="translate(., $ABC, $abc)"/>
                </xsl:attribute>
                <xsl:element name="speaker">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:variable name="ABC">ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÈÉÊËÌÍÎÏÐÑÒÓÔÕÖŒÙÚÛÜÝ </xsl:variable>
    <xsl:variable name="abc">abcdefghijklmnopqrstuvwxyzaaaaaaeeeeeiiiidnoooooœuuuuy_</xsl:variable>

    <!--
    =======================================
                CONTENU : CONTENU
    =======================================
    -->
    
    <!-- Structure du texte -->
    
    <xsl:template match="_3c_l_3e_">
        <xsl:choose>
            <xsl:when test="contains(., '(C)')">
                <!-- l > Gestion des alinéas -->
                <xsl:choose>
                    <xsl:when test="contains(., '(C) ')">
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
            <xsl:when test="contains(., '(D)')">
                <!-- l > Gestion des alinéas -->
                <xsl:choose>
                    <xsl:when test="contains(., '(D) ')">
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
            <xsl:when test=".[@rend = 'center']">
                <!-- l > Gestion des cul de lampe -->
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
            <xsl:when test="contains(., '(C)')">
                <!-- p > Gestion des alinéas -->
                <xsl:choose>
                    <xsl:when test="contains(., '(C) ')">
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
            <xsl:when test="contains(., '(D)')">
                <!-- p > Gestion des alinéas -->
                <xsl:choose>
                    <xsl:when test="contains(., '(D) ')">
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
    
    <xsl:template match="quote">
        <xsl:element name="quote">
            <xsl:element name="choice">
                <xsl:attribute name="style">ponctuation</xsl:attribute>
                <xsl:element name="orig"/>
                <xsl:element name="reg">
                    <xsl:text>« </xsl:text>
                </xsl:element>
            </xsl:element>
            <xsl:value-of select="substring-before(substring-after(., '« '), ' »')"/>
            <xsl:element name="choice">
                <xsl:attribute name="style">ponctuation</xsl:attribute>
                <xsl:element name="orig"/>
                <xsl:element name="reg">
                    <xsl:text> »</xsl:text>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="_3c_pb_3e_">
        <xsl:element name="pb">
            <xsl:attribute name="n">
                <xsl:value-of select="substring-before(substring-after(., '['), ']')"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    
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
    
    <!-- <corr> / <sic> -->
    
    <xsl:template match="erreurTypo">
        <xsl:choose>
            <xsl:when test="following-sibling::node()[1][local-name() = 'correctionTypo']">
                <xsl:element name="choice">
                    <xsl:element name="sic">
                        <xsl:apply-templates/>
                    </xsl:element>
                    <xsl:if test="following-sibling::node()[1][local-name() = 'correctionTypo']">
                        <xsl:element name="corr">
                            <xsl:value-of
                                select="translate(normalize-space(following-sibling::correctionTypo[1]), '[]', '')"
                            />
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
            <xsl:when test="preceding-sibling::node()[1][local-name() = 'erreurTypo']"/>
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
    
    <!-- Majuscules et petites majuscules -->
    
    <xsl:template match="Majuscule">
        <xsl:element name="hi">
            <xsl:attribute name="rend">uc</xsl:attribute>
            <!-- (Note) (uppercase : majuscule) -->
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="PetiteMajuscule">
        <xsl:element name="hi">
            <xsl:attribute name="rend">sc</xsl:attribute>
            <!-- (Note) (small-caps : petites majuscules) -->
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- Italique -->
    
    <xsl:template match="italique">
        <xsl:element name="hi">
            <xsl:attribute name="rend">i</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- IMAGES -->
    
    <xsl:template match="figure">
        <xsl:element name="figure">
            <xsl:element name="graphic">
                <xsl:attribute name="target">
                    <xsl:value-of select="./text()"/>
                    <!--<xsl:text>.jpg</xsl:text>-->
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>