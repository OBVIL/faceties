<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!--Adding titleDoc in the front element-->
    <xsl:template match="front">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()[not(self::titlePart)]"/>
            <docTitle>
                <xsl:apply-templates select="titlePart"/>
            </docTitle>
        </xsl:copy>
    </xsl:template>
    
    <!--Adding <p> has a child of <epigraph>-->
    <xsl:template match="epigraph">
        <xsl:copy>
            <p>
                <xsl:apply-templates select="@*|node()" />
            </p>
        </xsl:copy>
    </xsl:template>
    
    <!--Replacing <tab/> with the character reference-->
    <xsl:template match="tab">
        <xsl:text>&#x9;</xsl:text>
    </xsl:template>

</xsl:stylesheet>