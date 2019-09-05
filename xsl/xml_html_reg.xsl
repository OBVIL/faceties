<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="html" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">

        <html>
            <xsl:call-template name="head"/>
            <body>
                <xsl:call-template name="nav"/>
                <xsl:call-template name="info"/>
                
                <div class="container-fluid">
                    <div class="row">
                        <div class="container-fluid">
                            <div class="row">
                                <xsl:call-template name="options"/>
                                <xsl:call-template name="text"/>
                                <xsl:call-template name="pdf"/>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Footer -->
                <div class="card-footer menu-texte">
                    <div>
                        <p class="text-center">Sorbonne Université, <a
                            href="https://obvil.sorbonne-universite.fr/">LABEX
                            OBVIL</a>, <xsl:value-of select="/TEI/teiHeader/fileDesc/publicationStmt/date/@when"/>, <a
                                href="https://creativecommons.org/licenses/by-nc-nd/3.0/fr/"
                                >license cc</a>.</p>
                    </div>
                </div>
            </body>
        </html>

    </xsl:template>

<!-- head : css et js -->
    <xsl:template name="head">
        <head>
            <meta charset="UTF-8"/>
            <title>Facéties</title>
            <!--Bootstrap CSS-->
            <link rel="stylesheet"
                href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
                integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
                crossorigin="anonymous"/>
            <!--Bootstrap JS-->
            <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"/>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"/>
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"/>
            <!-- CSS & JS-->
            <link rel="stylesheet" href="style.css" type="text/css"/>
            <script src="./javaScript/extraction.js" defer="defer" />
        </head>
    </xsl:template>

<!-- Navigation Bar -->
    <xsl:template name="nav">
        <nav class="navbar navbar-expand-lg navbar-light bg-light menu-texte">
            <a class="navbar-brand">Facéties</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse"
                data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false"
                aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"/>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item active">
                        <a class="nav-link badge badge-light" href="#">Version normalisée<span
                                class="sr-only">(current)</span></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link badge badge-light" href="#">Version fac-similaire<span
                                class="sr-only">(current)</span></a>
                    </li>
                </ul>
            </div>
            <div>
                <a class="nav-link badge badge-info" href="#">Textes disponibles<span
                        class="sr-only">(current)</span></a>
                <a class="nav-link badge badge-info"
                    href="http://obvil.sorbonne-universite.fr/projets/faceties">Informations</a>
                <a class="nav-link badge badge-light" href="https://github.com/OBVIL/faceties"
                    >Github</a>
            </div>
        </nav>

    </xsl:template>
<!-- Options -->
    <xsl:template name="options">
        <div class="col-lg-2 col-md-2 col-sm-none col-xs-none">
            <div class="sticky-top">
                <div class="card menu-texte">
                    <a class="badge badge-light" href="#options" data-toggle="collapse"
                        data-target="#options" aria-expanded="false" aria-controls="options">Options
                        de consultation</a>
                    <div id="options">
                        <div class="custom-control custom-switch">
                            <input type="checkbox" class="custom-control-input" id="customSwitch1"/>
                            <label class="custom-control-label" for="customSwitch1">Tout
                                afficher</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value=""
                                id="check-cesures"/>
                            <label class="form-check-label" for="check-cesures"> Césures Implicites
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value=""
                                id="check-coquilles"/>
                            <label class="form-check-label" for="check-coquilles"> Coquilles
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value=""
                                id="check-abreviations"/>
                            <label class="form-check-label" for="check-abreviations"> Abréviations
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value=""
                                id="check-lettresRamistes"/>
                            <label class="form-check-label" for="check-lettresRamistes"> Lettres
                                ramistes </label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    
<!-- Informations -->
    <xsl:template name="info">
        
        <div class="container-fluid">
            <div class="container">
                <div class="card bibl menu-texte">
                    <a class="badge badge-light" href="#bibliographie" data-toggle="collapse"
                        data-target="#bibliographie" aria-expanded="false"
                        aria-controls="bibliographie">Informations bibliographiques</a>
                    <div class="card-body collapse" id="bibliographie">
                        <div>
                            <hr/>
                            <!-- Informations biblio -->
                            <xsl:call-template name="infoBibContent"/>
                        </div>
                        <hr/>
                        <div class="card menu-texte">
                            <a class="badge badge-light" href="#info-ed" data-toggle="collapse"
                                data-target="#info-ed" aria-expanded="false" aria-controls="info-ed"
                                >Édition électronique</a>
                            <div class="card-body collapse" id="info-ed">
                                <!-- Informations édition électronique -->
                                <xsl:call-template name="infoEdContent"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <hr class="hr-out"/>
        </div>
        
    </xsl:template>

    <xsl:template name="infoBibContent">
        <p class="card-text text-left"><B>Auteur</B> : <xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/author"/></p>
        <p class="card-text text-left"><B>Titre</B> : <xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/title"/></p>
        <p class="card-text text-left"><B>Libraire</B> : <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/publisher"/></p>
        <p class="card-text text-left"><B>Date</B> : <xsl:value-of select="/TEI/teiHeader/profileDesc/creation/date/@when"/></p>
        <p class="card-text text-left"><B>Lieu de publication</B> : <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/pubPlace"/></p>
        <p class="card-text text-left"><B>Localisation</B> : <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/biblScope"/></p>
    </xsl:template>
    
    <xsl:template name="infoEdContent">
        <p class="card-text text-left"><B>Date de publication</B> : <xsl:value-of
            select="/TEI/teiHeader/fileDesc/publicationStmt/date/@when"/></p>
        <p class="card-text text-left"><B>Édition</B> : <xsl:value-of select="/TEI/teiHeader/fileDesc/publicationStmt/publisher"/></p>
        <p class="card-text text-left">Ont participé à cette édition : <xsl:for-each
            select="/TEI/teiHeader/fileDesc/editionStmt/respStmt">
            <xsl:if test="position() = last()">
                <xsl:value-of select="name"/> (<xsl:value-of select="resp"/>). </xsl:if>
            <xsl:if test="not(position() = last())">
                <xsl:value-of select="name"/> (<xsl:value-of select="resp"/>), </xsl:if>
        </xsl:for-each>
        </p>
    </xsl:template>

<!-- Texte -->
    <xsl:template name="text"> 
        <div class="col-lg-5 col-md-6 col-sm-7 col-xs-7">
            <div>
                <xsl:apply-templates/>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="castList | term"/>
    <xsl:template match="teiHeader"/>
    
    <xsl:template match="fileDesc">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:value-of select="local-name()"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="titlePart">
        <xsl:element name="h1">
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
    
    <xsl:template match="corr"/>
    
    
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
                [<xsl:value-of select="@n"/>]
            </xsl:element>
        </xsl:element><br/>
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

<!-- PDF -->
    <xsl:template name="pdf">
        <div class="col-lg-5 col-md-4 col-sm-none col-xs-none">
            <div class="sticky-top">
                <object data="Cote XXVI-D-033.pdf" width="100%"
                    height="600px">
                    <embed src="Cote XXVI-D-033.pdf#8" width="100%"
                        height="600px"/>
                </object>
            </div>
        </div>
    </xsl:template>
    


</xsl:stylesheet>