<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/">
        <xsl:comment>OBVIL, CHEVALIER Nolwenn. Projet Facéties. </xsl:comment>
        <xsl:comment>Transformation : <xsl:value-of  select="format-date(current-date(), '[M01]/[D01]/[Y0001]')"/> à <xsl:value-of select="format-dateTime(current-dateTime(), '[H01]:[m01]')"/>. </xsl:comment>
        <xsl:element name="TEI">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="ABC">ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÈÉÊËÌÍÎÏÐÑÒÓÔÕÖŒÙÚÛÜÝ </xsl:variable>
    <xsl:variable name="abc">abcdefghijklmnopqrstuvwxyzaaaaaaeeeeeiiiidnoooooœuuuuy_</xsl:variable>

    <!-- HEADER -->
    
    <xsl:template match="_3c_term_3e_">
        <xsl:element name="term">
                <xsl:apply-templates/>
            <xsl:if test="following-sibling::node()[1][local-name()='_3c_term_3e_']">
                <xsl:value-of select="(following-sibling::_3c_term_3e_[1])"/>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="correctionTypo"/>

    <xsl:template match="_3c_term_3e_">
        <xsl:if test="matches(., 'titre( | ):')">
            <xsl:element name="title">
                <xsl:value-of select="substring-after(., ': ')"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="matches(., 'author( | ):')">
            <xsl:element name="author">
                <xsl:value-of select="substring-after(., ': ')"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="matches(., 'publisher( | ):')">
            <xsl:element name="publisher">
                <xsl:value-of select="substring-after(., ': ')"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="matches(., 'idno( | ):')">
            <xsl:element name="idno">
                <xsl:value-of select="replace(replace(substring-after(., ': '),'.site/','.fr/'), 'http://http://', 'http://')"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="matches(., 'issued( | ):')">
            <xsl:element name="date">
                <xsl:attribute name="when">
                    <xsl:value-of select="substring-after(., ': ')"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="matches(., 'source( | ):')">
            <xsl:element name="sourceDesc">
                <xsl:element name="bibl">
                    <xsl:value-of select="substring-after(., ': ')"/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:if test="matches(., 'created( | ):')">
            <xsl:element name="creation">
                <xsl:element name="date">
                    <xsl:attribute name="when">
                        <xsl:value-of select="substring-after(., ': ')"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:if test="matches(., 'language( | ):')">
            <xsl:element name="langUsage">
                <xsl:element name="language">
                    <xsl:attribute name="ident">
                        <xsl:value-of select="substring-after(., ': ')"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:if test="matches(., 'lieu( | ):')">
            <xsl:element name="term">
                <xsl:attribute name="type">lieu</xsl:attribute>
                <xsl:value-of select="substring-after(., ': ')"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="matches(., 'personnage( | ):')">
            <xsl:element name="term">
                <xsl:attribute name="type">personnage</xsl:attribute>
                <xsl:value-of select="substring-after(., ': ')"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <!-- STRUCTURE -->

    <xsl:template match="body">
        <xsl:element name="body">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*">
        <!-- Permet de matcher les éléments parasites et de les supprimer. -->
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="meta">
        <xsl:element name="teiHeader">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="frontiespiece|div1|div2">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- MISE EN PAGE -->
    
    <xsl:template match="_3c_figure_3e_">
        <xsl:element name="div">
            <xsl:element name="p">
                <xsl:attribute name="rend">center</xsl:attribute>
                <xsl:text>&lt;Image&gt;</xsl:text>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="_3c_l_3e_">
            <xsl:choose>
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

    <xsl:template match="_3c_pb_3e_">
        <xsl:element name="pb">
            <xsl:attribute name="n">
                <xsl:value-of select="translate(., '[]', '')"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="h">
        <xsl:element name="head">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="_3c_Pagedetitre_5f_titre_3e_">
        <xsl:element name="head">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="_3c_Pagedetitre_5f_sous-titre_3e_">
        <xsl:element name="head">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- AU CARACTERE -->

    <xsl:template match="_3c_speaker_3e_">
        <xsl:element name="sp">
            <xsl:attribute name="who">
                <xsl:value-of select="translate(., $ABC, $abc)"/>
            </xsl:attribute>
            <xsl:element name="speaker">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

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
                        <xsl:value-of select="translate(normalize-space(following-sibling::correctionTypo[1]), '[]', '')"/>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
