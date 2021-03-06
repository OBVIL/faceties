<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
     
    <!-- Cette transformation complète la normalisation, elle prend en charge :
        - le deuxième élément à normaliser de certains mots
        - elle prend prendre en charge le troisième élément à normaliser au besoin : il suffit de repasser la transformation sur le texte -->


    <xsl:template match="/">
        <xsl:comment>OBVIL, CHEVALIER Nolwenn. Projet Facéties. </xsl:comment>
        <xsl:comment>(T3bis) Transformation XML vers XML-BVH : <xsl:value-of  select="format-date(current-date(), '[M01]/[D01]/[Y0001]')"/> à <xsl:value-of select="format-dateTime(current-dateTime(), '[H01]:[m01]')"/>. </xsl:comment>
        <xsl:apply-templates/>
    </xsl:template>

    <!--<xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:for-each select="attribute::*">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>-->

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>


    <!--======================================================
        ALINEAS
    ======================================================-->
    
    
    <xsl:template match="l">
        <xsl:choose>
            <xsl:when test="contains(., '(C)')">
                <xsl:element name="l">
                    <xsl:attribute name="rend">indent</xsl:attribute>
                    <g type="pied_de_mouche">&#182;</g>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="substring-after(., '(C)')"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="contains(., '(D)')">
                <xsl:element name="l">
                    <xsl:attribute name="rend">indent</xsl:attribute>
                    <xsl:value-of select="substring-after(., '(D)')"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="l">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--======================================================
        REPRISE pour les mots avec doubles normalisation
    ======================================================-->

    <xsl:template match="div1//*/text()">
        <xsl:analyze-string select="."
            regex="[A-ZÑĜÀÁÂÃÄÅÆÈÉÊËÌÍÎÏÐÒÓÔÕÖŒÙÚÛÜÝa-zàáâãäåçẽèéêëĩìíîïðõòóôõöùúũûüýÿp̃ꝛꝑq̃9()]+">
            <xsl:matching-substring>
                <xsl:choose>

                    <!-- Traitement des signes spéciaux : les CESURES -->

                    <xsl:when test="matches(., '(\w*)[^(ã|ẽ|ĩ|õ|ũ)]Ĝ(\w*)', 'i')">
                        <!-- implicite -->
                        <xsl:value-of select="substring-before(., 'Ĝ')"/>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <xsl:text>-</xsl:text>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:value-of select="substring-after(., 'Ĝ')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)[^(ã|ẽ|ĩ|õ|ũ)]Ñ(\w*)', 'i')">
                        <!-- explicite -->
                        <xsl:value-of select="substring-before(., 'Ñ')"/>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:value-of select="substring-after(., 'Ñ')"/>
                    </xsl:when>

                    <!-- Résolution des abreviations : LES VOYELLES -->

                    <xsl:when test="matches(., '(\w*)ãm(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ãm')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>am</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>m</xsl:text>
                        <xsl:value-of select="substring-after(., 'ãm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ãb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ãb')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>am</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>b</xsl:text>
                        <xsl:value-of select="substring-after(., 'ãb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ãp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ãp')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>am</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>p</xsl:text>
                        <xsl:value-of select="substring-after(., 'ãp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ãn(\w*)', 'i')">
                        <xsl:choose>
                            <xsl:when test="matches(., '(\w*)dãn(\w*)', 'i')">
                                <xsl:value-of select="substring-before(., 'dãn')"/>
                                <xsl:text>d</xsl:text>
                                <choice change="abreviation">
                                    <orig>
                                        <xsl:text>ã</xsl:text>
                                    </orig>
                                    <reg>
                                        <xsl:text>am</xsl:text>
                                    </reg>
                                </choice>
                                <xsl:text>n</xsl:text>
                                <xsl:value-of select="substring-after(., 'dãn')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-before(., 'ãn')"/>
                                <choice change="abreviation">
                                    <orig>
                                        <xsl:text>ã</xsl:text>
                                    </orig>
                                    <reg>
                                        <xsl:text>am</xsl:text>
                                    </reg>
                                </choice>
                                <xsl:text>n</xsl:text>
                                <xsl:value-of select="substring-after(., 'ãn')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ã[^(a|e|i|o|u|é|è|y|Ñ|Ĝ)](\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ã')"/>
                        <choice change="abreviation">
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
                        <choice change="abreviation">
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
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>em</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>m</xsl:text>
                        <xsl:value-of select="substring-after(., 'ẽm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ẽb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽb')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>em</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>b</xsl:text>
                        <xsl:value-of select="substring-after(., 'ẽb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ẽp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽp')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>em</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>p</xsl:text>
                        <xsl:value-of select="substring-after(., 'ẽp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ẽn(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽn')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>em</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>n</xsl:text>
                        <xsl:value-of select="substring-after(., 'ẽn')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ẽ[^(a|e|i|o|u|é|è|y|Ñ|Ĝ)](\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽ')"/>
                        <choice change="abreviation">
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
                        <choice change="abreviation">
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
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ĩ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>im</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>m</xsl:text>
                        <xsl:value-of select="substring-after(., 'ĩm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ĩb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩb')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ĩ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>im</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>b</xsl:text>
                        <xsl:value-of select="substring-after(., 'ĩb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ĩp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩp')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ĩ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>im</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>p</xsl:text>
                        <xsl:value-of select="substring-after(., 'ĩp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ĩn(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩn')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ĩ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>im</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>n</xsl:text>
                        <xsl:value-of select="substring-after(., 'ĩn')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ĩ[^(a|e|i|o|u|é|è|y|Ñ|Ĝ)](\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩ')"/>
                        <choice change="abreviation">
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
                        <choice change="abreviation">
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
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>om</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>m</xsl:text>
                        <xsl:value-of select="substring-after(., 'õm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)õb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'õb')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>om</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>b</xsl:text>
                        <xsl:value-of select="substring-after(., 'õb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)õp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'õp')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>om</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>p</xsl:text>
                        <xsl:value-of select="substring-after(., 'õp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)õn(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'õn')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>om</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>n</xsl:text>
                        <xsl:value-of select="substring-after(., 'õn')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)õ[^(a|e|i|o|u|é|è|y|Ñ|Ĝ)](\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'õ')"/>
                        <choice change="abreviation">
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
                        <choice change="abreviation">
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
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ũ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>um</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>m</xsl:text>
                        <xsl:value-of select="substring-after(., 'ũm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ũb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ũb')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ũ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>um</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>b</xsl:text>
                        <xsl:value-of select="substring-after(., 'ũb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ũp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ũp')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ũ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>um</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>p</xsl:text>
                        <xsl:value-of select="substring-after(., 'ũp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ũn(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ũn')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ũ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>um</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>n</xsl:text>
                        <xsl:value-of select="substring-after(., 'ũn')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ũ[^(a|e|i|o|u|é|è|y|Ñ|Ĝ)](\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ũ')"/>
                        <choice change="abreviation">
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
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ũ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>un</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., 'ũ')"/>
                    </xsl:when>

                    <!--  Avec les abreviations implicites : Ĝ -->

                    <xsl:when test="matches(., '(\w*)ãĜm(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ãĜm')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>am</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>m</xsl:text>
                        <xsl:value-of select="substring-after(., 'ãĜm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ãĜb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ãĜb')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>am</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>b</xsl:text>
                        <xsl:value-of select="substring-after(., 'ãĜb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ãĜp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ãĜp')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>am</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>p</xsl:text>
                        <xsl:value-of select="substring-after(., 'ãĜp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ãĜn(\w*)', 'i')">
                        <xsl:choose>
                            <xsl:when test="matches(., '(\w*)dãĜn(\w*)', 'i')">
                                <xsl:value-of select="substring-before(., 'dãĜn')"/>
                                <xsl:text>d</xsl:text>
                                <choice change="abreviation">
                                    <orig>
                                        <xsl:text>ã</xsl:text>
                                    </orig>
                                    <reg>
                                        <xsl:text>am</xsl:text>
                                    </reg>
                                </choice>
                                <choice change="cesure_implicite">
                                    <sic/>
                                    <corr>
                                        <pc>
                                            <xsl:text>-</xsl:text>
                                        </pc>
                                    </corr>
                                </choice>
                                <lb rend="hyphen"/>
                                <xsl:text>n</xsl:text>
                                <xsl:value-of select="substring-after(., 'dãĜn')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-before(., 'ãĜn')"/>
                                <choice change="abreviation">
                                    <orig>
                                        <xsl:text>ã</xsl:text>
                                    </orig>
                                    <reg>
                                        <xsl:text>am</xsl:text>
                                    </reg>
                                </choice>
                                <choice change="cesure_implicite">
                                    <sic/>
                                    <corr>
                                        <pc>
                                            <xsl:text>-</xsl:text>
                                        </pc>
                                    </corr>
                                </choice>
                                <lb rend="hyphen"/>
                                <xsl:text>n</xsl:text>
                                <xsl:value-of select="substring-after(., 'ãĜn')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ãĜ(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ãĜ')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>an</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:value-of select="substring-after(., 'ãĜ')"/>
                    </xsl:when>

                    <xsl:when test="matches(., '(\w*)ẽĜm(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽĜm')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>em</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>m</xsl:text>
                        <xsl:value-of select="substring-after(., 'ẽĜm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ẽĜb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽĜb')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>em</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>b</xsl:text>
                        <xsl:value-of select="substring-after(., 'ẽĜb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ẽĜp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽĜp')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>em</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>p</xsl:text>
                        <xsl:value-of select="substring-after(., 'ẽĜp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ẽĜn(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽĜn')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>em</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>n</xsl:text>
                        <xsl:value-of select="substring-after(., 'ẽĜn')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ẽĜ(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽĜ')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>en</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:value-of select="substring-after(., 'ẽĜ')"/>
                    </xsl:when>

                    <xsl:when test="matches(., '(\w*)ĩĜm(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩĜm')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ĩ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>im</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>m</xsl:text>
                        <xsl:value-of select="substring-after(., 'ĩĜm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ĩĜb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩĜb')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ĩ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>im</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>b</xsl:text>
                        <xsl:value-of select="substring-after(., 'ĩĜb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ĩĜp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩĜp')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ĩ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>im</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>p</xsl:text>
                        <xsl:value-of select="substring-after(., 'ĩĜp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ĩĜn(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩĜn')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ĩ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>im</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>n</xsl:text>
                        <xsl:value-of select="substring-after(., 'ĩĜn')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ĩĜ(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩĜ')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ĩ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>in</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:value-of select="substring-after(., 'ĩĜ')"/>
                    </xsl:when>

                    <xsl:when test="matches(., '(\w*)õĜm(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'õĜm')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>om</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>m</xsl:text>
                        <xsl:value-of select="substring-after(., 'õĜm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)õĜb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'õĜb')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>om</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>b</xsl:text>
                        <xsl:value-of select="substring-after(., 'õĜb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)õĜp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'õĜp')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>om</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>p</xsl:text>
                        <xsl:value-of select="substring-after(., 'õĜp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)õĜn(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'õĜn')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>om</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <xsl:text>-</xsl:text>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>n</xsl:text>
                        <xsl:value-of select="substring-after(., 'õĜn')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)õĜ(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'õĜ')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>on</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:value-of select="substring-after(., 'õĜ')"/>
                    </xsl:when>

                    <xsl:when test="matches(., '(\w*)ũĜm(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ũĜm')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ũ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>um</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>m</xsl:text>
                        <xsl:value-of select="substring-after(., 'ũĜm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ũĜb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ũĜb')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ũ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>um</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>b</xsl:text>
                        <xsl:value-of select="substring-after(., 'ũĜb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ũĜp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ũĜp')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ũ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>um</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>p</xsl:text>
                        <xsl:value-of select="substring-after(., 'ũĜp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ũĜn(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ũĜn')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ũ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>um</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:text>n</xsl:text>
                        <xsl:value-of select="substring-after(., 'ũĜn')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ũĜ(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ũĜ')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ũ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>un</xsl:text>
                            </reg>
                        </choice>
                        <choice change="cesure_implicite">
                            <sic/>
                            <corr>
                                <pc>
                                    <xsl:text>-</xsl:text>
                                </pc>
                            </corr>
                        </choice>
                        <lb rend="hyphen"/>
                        <xsl:value-of select="substring-after(., 'ũĜ')"/>
                    </xsl:when>

                    <!-- Avec les abbréviations explicites : Ñ -->

                    <xsl:when test="matches(., '(\w*)ãÑm(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ãÑm')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>am</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <lb rend="hyphen"/>
                        <xsl:text>m</xsl:text>
                        <xsl:value-of select="substring-after(., 'ãÑm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ãÑb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ãÑb')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>am</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>b</xsl:text>
                        <xsl:value-of select="substring-after(., 'ãÑb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ãÑp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ãÑp')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>am</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>p</xsl:text>
                        <xsl:value-of select="substring-after(., 'ãÑp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ãÑn(\w*)', 'i')">
                        <xsl:choose>
                            <xsl:when test="matches(., '(\w*)dãÑn(\w*)', 'i')">
                                <xsl:value-of select="substring-before(., 'dãÑn')"/>
                                <xsl:text>d</xsl:text>
                                <choice change="abreviation">
                                    <orig>
                                        <xsl:text>ã</xsl:text>
                                    </orig>
                                    <reg>
                                        <xsl:text>am</xsl:text>
                                    </reg>
                                </choice>
                                <pc change="cesure_explicite">
                                    <xsl:text>-</xsl:text>
                                </pc>
                                <lb rend="hyphen"/>
                                <xsl:text>n</xsl:text>
                                <xsl:value-of select="substring-after(., 'dãÑn')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-before(., 'ãÑn')"/>
                                <choice change="abreviation">
                                    <orig>
                                        <xsl:text>ã</xsl:text>
                                    </orig>
                                    <reg>
                                        <xsl:text>am</xsl:text>
                                    </reg>
                                </choice>
                                <pc change="cesure_explicite">
                                    <xsl:text>-</xsl:text>
                                </pc>
                                <lb rend="hyphen"/>
                                <xsl:text>n</xsl:text>
                                <xsl:value-of select="substring-after(., 'ãÑn')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ãÑ(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ãÑ')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>an</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:value-of select="substring-after(., 'ãÑ')"/>
                    </xsl:when>

                    <xsl:when test="matches(., '(\w*)ẽÑm(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽÑm')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>em</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>m</xsl:text>
                        <xsl:value-of select="substring-after(., 'ẽÑm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ẽÑb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽÑb')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>em</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>b</xsl:text>
                        <xsl:value-of select="substring-after(., 'ẽÑb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ẽÑp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽÑp')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>em</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>p</xsl:text>
                        <xsl:value-of select="substring-after(., 'ẽÑp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ẽÑn(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽÑn')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>em</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>n</xsl:text>
                        <xsl:value-of select="substring-after(., 'ẽÑn')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ẽÑ(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ẽÑ')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>en</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:value-of select="substring-after(., 'ẽÑ')"/>
                    </xsl:when>

                    <xsl:when test="matches(., '(\w*)ĩÑm(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩÑm')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ĩ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>im</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>m</xsl:text>
                        <xsl:value-of select="substring-after(., 'ĩÑm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ĩÑb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩÑb')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ĩ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>im</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>b</xsl:text>
                        <xsl:value-of select="substring-after(., 'ĩÑb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ĩÑp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩÑp')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ĩ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>im</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>p</xsl:text>
                        <xsl:value-of select="substring-after(., 'ĩÑp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ĩÑn(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩÑn')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ĩ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>im</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>n</xsl:text>
                        <xsl:value-of select="substring-after(., 'ĩÑn')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ĩÑ(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ĩÑ')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ĩ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>in</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:value-of select="substring-after(., 'ĩÑ')"/>
                    </xsl:when>

                    <xsl:when test="matches(., '(\w*)õÑm(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'õÑm')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>om</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>m</xsl:text>
                        <xsl:value-of select="substring-after(., 'õÑm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)õÑb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'õÑb')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>om</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>b</xsl:text>
                        <xsl:value-of select="substring-after(., 'õÑb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)õÑp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'õÑp')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>om</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>p</xsl:text>
                        <xsl:value-of select="substring-after(., 'õÑp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)õÑn(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'õÑn')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>om</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>n</xsl:text>
                        <xsl:value-of select="substring-after(., 'õÑn')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)õÑ(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'õÑ')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>on</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:value-of select="substring-after(., 'õÑ')"/>
                    </xsl:when>

                    <xsl:when test="matches(., '(\w*)ũÑm(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ũÑm')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ũ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>um</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>m</xsl:text>
                        <xsl:value-of select="substring-after(., 'ũÑm')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ũÑb(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ũÑb')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ũ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>um</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>b</xsl:text>
                        <xsl:value-of select="substring-after(., 'ũÑb')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ũÑp(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ũÑp')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ũ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>um</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>p</xsl:text>
                        <xsl:value-of select="substring-after(., 'ũÑp')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '(\w*)ũÑn(\w*)', 'i')">
                        <xsl:value-of select="substring-before(., 'ũÑn')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ũ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>um</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:text>n</xsl:text>
                        <xsl:value-of select="substring-after(., 'ũÑn')"/>
                    </xsl:when>
                    <xsl:when test="matches(., '^(\w*)ũÑ(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'ũÑ')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ũ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>un</xsl:text>
                            </reg>
                        </choice>
                        <pc change="cesure_explicite">
                            <xsl:text>-</xsl:text>
                        </pc>
                        <lb rend="hyphen"/>
                        <xsl:value-of select="substring-after(., 'ũÑ')"/>
                    </xsl:when>

                    <!-- Résolution des abreviations : CAS PARTICULIERS -->

                    <xsl:when test="matches(., '^(\w*)cõmãderẽt(\w*)$', 'i')">
                        <xsl:value-of select="substring-before(., 'õmãderẽ')"/>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>omm</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>m</xsl:text>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>an</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>der</xsl:text>
                        <choice change="abreviation">
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
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>omm</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>m</xsl:text>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ẽ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>en</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>cem</xsl:text>
                        <choice change="abreviation">
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
                        <choice change="abreviation">
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
                        <choice change="abreviation">
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
                        <choice change="abreviation">
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
                        <choice change="abreviation">
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
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ↄ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>con</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>m</xsl:text>
                        <choice change="abreviation">
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
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>õ</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>on</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>d</xsl:text>
                        <choice change="abreviation">
                            <orig>
                                <xsl:text>ã</xsl:text>
                            </orig>
                            <reg>
                                <xsl:text>ãm</xsl:text>
                            </reg>
                        </choice>
                        <xsl:text>ner</xsl:text>
                        <choice change="abreviation">
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


                    <!-- Résolution des abreviations : LES CONSONNES -->

                    <xsl:when test="matches(., '^(\w*)q̃$', 'i')">
                        <xsl:value-of select="substring-before(., 'q̃')"/>
                        <choice change="abreviation">
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
                        <choice change="abreviation">
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
                        <choice change="abreviation">
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
                        <choice change="abreviation">
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
                        <choice change="abreviation">
                            <orig>
                                <hi rend="sup">
                                    <xsl:text>9</xsl:text>
                                </hi>
                            </orig>
                            <reg>
                                <xsl:text>us</xsl:text>
                            </reg>
                        </choice>
                        <xsl:value-of select="substring-after(., '9')"/>
                    </xsl:when>

                    <!-- Résolution des abreviations : LES CONSONNES > ↄ (com/con) -->

                    <xsl:when test="matches(., '^(\w*)ↄ$', 'i')">
                        <xsl:value-of select="substring-before(., 'ↄ')"/>
                        <choice change="abreviation">
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
                        <choice change="abreviation">
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
                        <choice change="abreviation">
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
                        <choice change="abreviation">
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
                        <choice change="abreviation">
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
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
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
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
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
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
                                </reg>
                            </choice>
                            <xsl:value-of select="substring-after(., 'au')"/>
                        </xsl:if>
                        <xsl:if test="matches(., '^(\w*)Au(a|é|i|o|e)(\w*)$')">
                            <xsl:value-of select="substring-before(., 'Au')"/>
                            <xsl:text>A</xsl:text>
                            <choice change="lettre_ramiste">
                                <orig>
                                    <xsl:text>u</xsl:text>
                                </orig>
                                <reg>
                                    <xsl:text>v</xsl:text>
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