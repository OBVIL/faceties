<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:template match="/">
        <!-- <xsl:text>
    </xsl:text>
       <TEI>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Pelerinage de Jasque Lesaige ... à vérifier</title>
                        <author>Jasques LeSaige</author>
                    </titleStmt>
                    <publicationStmt>
                        <p><date>1524</date></p>
                    </publicationStmt>
                    <sourceDesc>
                        <bibl>
                            <title>Document numérique - pages 11 à 17</title>
                            <respStmt>
                                <resp>Transcription normalisée du texte</resp>
                                <name type="person" xml:id="MM">Jeanne Bineau</name>
                            </respStmt>
                            <textLang>Moyen français</textLang>
                        </bibl>
                        <listWit>
                            <witness xml:id="B">BM Lille</witness>
                            <witness xml:id="O">BNF Paris</witness>
                            
                            <msDesc>
                                <msIdentifier>
                                    <country>France</country>
                                    <settlement>Lille</settlement>
                                    <repository>BM Lille</repository>
                                    <idno>aucune idée</idno>
                                    <msName>titre à vérifier essai 1</msName>
                                </msIdentifier>
                                <physDesc>
                                    <p>imprimé</p>
                                </physDesc>
                            </msDesc>
                        </listWit>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <!-\-<xsl:apply-templates select="//text" mode="parent_text"/>
                <back><div><msDesc><msIdentifier><bloc>Jasques Le Saige</bloc></msIdentifier><physDesc><decoDesc>
                    <xsl:apply-templates select="//TEIdecoNote" mode="pour_back"/>
                </decoDesc></physDesc></msDesc></div>
                </back>-\->
            </text>
        </TEI>-->
        <xsl:apply-templates/>
    </xsl:template>
    
    
    
    
    <xsl:template match="text|body">
        <body>
        <xsl:apply-templates/>
        </body>
    </xsl:template>
    
    <xsl:template match="*"><xsl:text> ######## </xsl:text><xsl:value-of select="local-name()"/><xsl:text> ######## </xsl:text></xsl:template>
    
       

    <xsl:template match="_3c_l_3e_">
        <xsl:element name="l"> 
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
        

  <xsl:template match="_3c_pb_3e_">
        <xsl:element name="pb"> 
            <xsl:variable name="folio"><xsl:value-of select="."/></xsl:variable>
            <xsl:attribute name="n" select="$folio"/>
        </xsl:element>
    </xsl:template>
    
       
          
       
          
    
    <xsl:template match="_3c_speaker_3e_">
        <xsl:element name="sp">
            <xsl:attribute name="who">
                
                <xsl:value-of select="."/>
            </xsl:attribute>
            <xsl:text>
</xsl:text>
        <xsl:element name="speaker"> 
            <xsl:apply-templates/>
        </xsl:element>
            <xsl:text>
</xsl:text>
        </xsl:element>
       
    </xsl:template>
    
    <xsl:template match="sp">
        <xsl:text>hghzifuheiygheq</xsl:text>

    </xsl:template>
   <!-- <xsl:when test="sp">
        <xsl:copy>
            <xsl:copy-of select="head/@xml:id"/>
            <xsl:copy-of select="@*"/>
            <xsl:if test="starts-with($head, 'scene')">
                <xsl:attribute name="type">scene</xsl:attribute>
            </xsl:if>
            <xsl:if test="starts-with($head, 'act')">
                <xsl:attribute name="type">act</xsl:attribute>
            </xsl:if>
            <xsl:if test="head/@type">
                <xsl:attribute name="type">
                    <xsl:value-of select="head/@type"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:variable name="first" select="generate-id(_3c_speaker_3e_[1])"/>
            <xsl:apply-templates select="*[following-sibling::*[generate-id()=$first]]"/>
            <xsl:for-each select="_3c_speaker_3e_">
                <sp>
                    <xsl:attribute name="who">
                        <!-\\- No note -\\->
                        <xsl:variable name="text" select="text()"/>
                        <xsl:variable name="who">
                            <xsl:choose>
                                <xsl:when test="contains($text, ',')">
                                    <xsl:value-of select="substring-before(., ',')"/>
                                </xsl:when>
                                <xsl:when test="contains($text, '.')">
                                    <xsl:value-of select="substring-before(., '.')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$text"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:value-of select="translate(normalize-space($who),$ABC ,$abc)"/>
                    </xsl:attribute>
                    <xsl:copy-of select="anchor[1]/@xml:id"/>
                    <xsl:apply-templates select="."/>
                    <xsl:for-each select="following-sibling::*[1]">
                        <xsl:call-template name="sp"/>
                    </xsl:for-each>
                </sp>
            </xsl:for-each>
        </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <!-\\- ?? section à spliter ? -\\->
            <xsl:if test="head[1]/@type">
                <xsl:attribute name="type">
                    <xsl:value-of select="head/@type"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="head[1]/anchor[1]/@xml:id"/>
            <!-\\- Non, trop de problèmes
            <xsl:if test="starts-with($head, 'chapter') or starts-with($head, 'chapitre')">
                <xsl:attribute name="type">chapter</xsl:attribute>
            </xsl:if>
            -\\->
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:otherwise>
    
<!-\-    <xsl:template name="sp">
        
                <xsl:for-each select="following-sibling::*[1]">
                    <xsl:call-template name="sp"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="local-name()='speaker'"/>
            <xsl:otherwise>
                <xsl:apply-templates select="."/>
                <xsl:for-each select="following-sibling::*[1]">
                    <xsl:call-template name="sp"/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-\->
   
 <!-\-   <xsl:template match="_3c_term_3e_">
        <xsl:variable name="contenu">
            <xsl:value-of select="."/>
        </xsl:variable>
        <xsl:if test="., '^(lieu)">
            
        </xsl:if>
            
        
    </xsl:template>-\->
    
    -->
    

   
</xsl:stylesheet>