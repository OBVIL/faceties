<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs "
    version="2.0">

    <xsl:template match="/">
        <xsl:element name="TEI">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
   
    <xsl:template match="teiHeader">
        <xsl:copy-of select='.'/>
    </xsl:template>
    
    <!--========================================
        ========== Construction du front =======
        ========================================-->
    
<!--    <xsl:template match="front">
        <xsl:element name="front">
            <xsl:element name="titlePage">
                <xsl:element name="docTitle">
                    <xsl:element name="titlePart">
                        <xsl:attribute name="type">main</xsl:attribute>
                        <xsl:value-of
                            select="@text:style-name = 'frontTitleMain'"
                        />
                    </xsl:element>
                    <!-\-<xsl:call-template name="frontSubtitle"/>-\->
                </xsl:element>
<!-\-                <xsl:call-template name="frontFigure"/>
                <xsl:call-template name="docImprint"/>
                <xsl:call-template name="frontEpigraph"/>-\->
            </xsl:element>
        </xsl:element>
    </xsl:template>-->
    
<!--        <xsl:template
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
    </xsl:template>-->
    
    <!--Si il y a un sous titre au front (frontSubtitle)-->
<!--    <xsl:template
        match="/office:document-content/office:body/office:text/text:p[@text:style-name = 'frontSubtitle']"
        name="frontSubtitle">
        <xsl:element name="titlePart">
            <xsl:attribute name="type">subtitle</xsl:attribute>
            <xsl:value-of
                select="/office:document-content/office:body/office:text/text:p[@text:style-name = 'frontSubtitle']"
            />
        </xsl:element>
    </xsl:template>
    
    <!-\-Si il y une image dans le front (frontFigure)-\->
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
    
    <!-\-Si il y a mention de l'imprimeur dans le front (docImprint)-\->
    <xsl:template
        match="/office:document-content/office:body/office:text/text:p[@text:style-name = 'docImprint']"
        name="docImprint">
        <xsl:element name="docImprint">
            <xsl:value-of
                select="/office:document-content/office:body/office:text/text:p[@text:style-name = 'docImprint']"
            />
        </xsl:element>
    </xsl:template>
    
    <!-\-Si il y a un épigraphe (frontEpigraph)-\->
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
    </xsl:template>-->
    
    
    


    <!--    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>-->

    <!--    <xsl:template match="@*">
        <xsl:attribute name="{local-name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>-->
    


    <!--<xsl:if test="@text:style-name = 'Standard'">
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
            </xsl:if>-->

</xsl:stylesheet>
