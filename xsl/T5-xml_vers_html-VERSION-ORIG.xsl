<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0">
    
    <!-- STRUCTURE GLOBALE -->
    
    <xsl:strip-space elements="choice"/>

    <xsl:output indent="yes"/>

    <xsl:template match="/">
        <html lang="fr">
            <head>
                <meta charset="utf-8"></meta>
                <!--  <link href="FacetiesNORMALISEE_2.css" rel="stylesheet" type="text/css"></link>-->
                <link href="MM2_DUG.css" rel="stylesheet" type="text/css"></link>
                <script src="./javaScript/extraction.js"></script>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"></link>
                <title>Version fac-similaire</title>
            </head>
            <body onload="initialise_affichage()">

                <div class="index">
                    
                    <div class="index1">
                        <xsl:element name="a">
                            <xsl:attribute name="href"><xsl:text>version_normalisee.html</xsl:text></xsl:attribute>
                            <button type="button"><i class="fa">&#xf02d;</i> Version normalisée</button> 
                        </xsl:element>
                    </div>
                    <div id="definition">
                        <form>
                            <h3>Afficher les normalisations</h3>
                            <div><input type="radio" name="norm" id="affiche_reg" value="affiche_reg" onclick="affiche_tout_reg();"/>Tout afficher</div>
                            <div><input type="radio" name="norm" id="cache_reg" value="cache_reg" onclick="cache_tout_reg();"/>Tout cacher</div>
                            <hr/><div id="afficher">
                            </div>
                        </form>
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

    <!-- Remplacement des <space quantity=""> correspondant aux £ dans le fichier `odt` pour les line breaks.
        Ajoute le même nombre de <br/> que la valeur de @quantity
    -->
    <xsl:template match="space">
        <xsl:param name="count" select="./@quantity"/>
        <xsl:for-each select="1 to $count"><br/></xsl:for-each>
    </xsl:template>
    
    <!-- Modification de l'affichage des folio -->
    <xsl:template match="pb">
        <xsl:element name="l">
            <xsl:element name="span">
                <xsl:attribute name="class">pb</xsl:attribute>
                <xsl:attribute name="n"><xsl:value-of select="replace(@n, '\[|\s|\.|\]', '')"/></xsl:attribute>
                <xsl:attribute name="xml:id"><xsl:value-of select="replace(@n, '\[|\s|\.|\]', '')"/></xsl:attribute>
                <xsl:attribute name="facs"></xsl:attribute>
                <xsl:value-of select="replace(@n, ' \]', ']')"/>
            </xsl:element>
        </xsl:element><br/>
    </xsl:template>
    
    <xsl:template match="reg"/>
    
    <xsl:template match="orig">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:value-of select="local-name()"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="pc">
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

    <!-- Line break -->
    <xsl:template match="lb">
        <br/>
        <xsl:apply-templates/>
    </xsl:template>
    
</xsl:stylesheet>