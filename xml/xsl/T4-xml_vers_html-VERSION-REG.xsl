<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <!-- STRUCTURE GLOBALE -->
    
    <!--    <xsl:strip-space elements="*"/>-->
    
    <xsl:template match="/">
        <html lang="fr">
            <head>
                <meta charset="utf-8"></meta>
                <!--  <link href="FacetiesNORMALISEE_2.css" rel="stylesheet" type="text/css"></link>-->
                <link href="MM2_DUG.css" rel="stylesheet" type="text/css"></link>
                <script src="./javaScript/extraction.js"></script>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"></link>
                <title>Version normalisée</title>
            </head>
            <body onload="initialise_affichage()">
                
                
                
                <div class="index">
                    
                    <div class="index1">
                        <xsl:element name="a">
                            <xsl:attribute name="href"><xsl:text>F5-ORIG.html</xsl:text></xsl:attribute>
                            <button type="button"><i class="fa">&#xf02d;</i> Version fac-similaire</button> 
                        </xsl:element>
                    </div>
                    
                    <div id="definition">
                        <FORM>
                            <h2>Afficher les normalisations</h2>
                            <div><INPUT type="radio" name="norm" id="affiche_reg" value="affiche_reg" onclick="affiche_tout_reg();"/>Tout afficher</div>
                            <div><INPUT type="radio" name="norm" id="cache_reg" value="cache_reg" onclick="cache_tout_reg();"/>Tout cacher</div>
                            <hr/><div id="afficher">
                            </div>
                        </FORM>
                    </div>
                    
                    <div id="definition">
                        <FORM>
                            <h2>Locuteurs</h2>
                            <div><INPUT type="radio" name="norm"/>L'acteur</div>
                            <div><INPUT type="radio" name="norm"/>Le galant</div>
                            <div><INPUT type="radio" name="norm"/>Le clerc</div>
                            
                            
                            <div id="afficher">
                            </div>
                        </FORM>
                    </div>
                    
                </div>
                
                <div id="texte_complet">
                    <xsl:apply-templates/>
                </div>
                               
            </body>
            
        </html>
    </xsl:template>
    
    <!-- STRUCTURE COLONNE -->
    
    <xsl:template match="text">
        <xsl:apply-templates/>
    </xsl:template>
    
    
    
    <!-- <xsl:template match="title |author | edition | publisher | date | idno | avaibility | licence | bibl">
    <xsl:element name="span">
        <xsl:attribute name="class">
            <xsl:value-of select="local-name()"/>
        </xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>
        <br/>
    </xsl:template>-->
    
    <xsl:template match="teiheader"/>
    
    <xsl:template match="castList | term"/>
    <!--<xsl:element name="div">
            <xsl:attribute name="class">
                <xsl:value-of select="local-name()"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>-->
    
    <xsl:template match="fileDesc">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:value-of select="local-name()"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="div">
        <xsl:element name="div">
            <xsl:attribute name="class">
                <xsl:value-of select="local-name()"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="p">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:value-of select="local-name()"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="sic">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:value-of select="local-name()"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="corr">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:value-of select="local-name()"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="head">
        <xsl:element name="h2">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="l">
        <xsl:element name="l">
            <xsl:apply-templates/>
        </xsl:element>
        <br/>
    </xsl:template>
    
    <xsl:template match="pb">
        <xsl:element name="span">
            <xsl:attribute name="class">pb</xsl:attribute>
            <xsl:text>[p.</xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>]</xsl:text>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="orig"/>
    
    <xsl:template match="reg">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:value-of select="local-name()"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="choice">
        <xsl:element name="span">
            <xsl:attribute name="name">
                <xsl:value-of select="@*"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>