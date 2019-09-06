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
            <titlePage>
                <xsl:apply-templates select="@*|node()[not(self::pb) and not(self::castList)]"/>
            </titlePage>
            <xsl:apply-templates select="pb|castList"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="editionStmt">
        <editionStmt>
            <xsl:apply-templates/>
            <xsl:call-template name="participants"/>
        </editionStmt>
    </xsl:template>
    
    <xsl:template name="participants">
        <respStmt>
            <name>Jeanne Bineau</name>
            <resp>édition XML-TEI</resp>
        </respStmt>
        <respStmt>
            <name>Nolwenn Chevalier</name>
            <resp>édition XML-TEI</resp>
        </respStmt>
        <respStmt>
            <name>Anne-Laure Huet</name>
            <resp>édition XML-TEI</resp>
        </respStmt>
        <respStmt>
            <name>Arthur Provenier</name>
            <resp>édition XML-TEI</resp>
        </respStmt>
    </xsl:template>
</xsl:stylesheet>