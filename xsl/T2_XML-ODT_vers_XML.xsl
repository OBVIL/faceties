<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>
    
    <xsl:variable name="ABC">ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÈÉÊËÌÍÎÏÐÑÒÓÔÕÖŒÙÚÛÜÝ </xsl:variable>
    <xsl:variable name="abc">abcdefghijklmnopqrstuvwxyzaaaaaaeeeeeiiiidnoooooœuuuuy_</xsl:variable>
        
    <!--
    ========================================
            HIERARCHISATION DE L'XML
    ========================================
    -->

    <xsl:template match="/">
        <xsl:comment>OBVIL, CHEVALIER Nolwenn. Projet Facéties. </xsl:comment>
        <xsl:comment>(T2) Transformation XML-ODT vers XML : <xsl:value-of  select="format-date(current-date(), '[M01]/[D01]/[Y0001]')"/> à <xsl:value-of select="format-dateTime(current-dateTime(), '[H01]:[m01]')"/>. </xsl:comment>
        <body>
            <teiHeader>
                <xsl:apply-templates select="descendant::_3c_term_3e_"/>
            </teiHeader>
            <xsl:apply-templates select="descendant::front"/>
            <xsl:apply-templates select="descendant::_3c_Pagedetitre_5f_sous-titre_3e_"/>
        </body> 
    </xsl:template>

    <xsl:template match="_3c_Pagedetitre_5f_sous-titre_3e_">
        <div1>
            <xsl:element name="head">
                <xsl:apply-templates/>
            </xsl:element>
            <xsl:variable name="gid" select="generate-id()" />
            <xsl:apply-templates select="following-sibling::*[1][name()!='h' 
                and generate-id(preceding-sibling::_3c_Pagedetitre_5f_sous-titre_3e_[1])=$gid]"
                mode="pas"
            />
            <xsl:apply-templates select="following-sibling::h[generate-id(preceding-sibling::_3c_Pagedetitre_5f_sous-titre_3e_[1])=$gid]" mode="pas">
                <xsl:with-param name="gid" select="$gid" />
            </xsl:apply-templates>
        </div1>
    </xsl:template>
    
    <xsl:template match="*[name()!='h']" mode="pas">
        <xsl:copy-of select="." />
        <xsl:if test="name(following-sibling::*[1])!='h' and name(following-sibling::*[1])!='_3c_Pagedetitre_5f_sous-titre_3e_'">
            <xsl:apply-templates select="following-sibling::*[1]" mode="pas"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="h" mode="pas">
        <div2>
            <xsl:element name="head">
                <xsl:apply-templates/>
            </xsl:element>
            <xsl:apply-templates select="following-sibling::*[1][name()!='h'
                and name()!='_3c_Pagedetitre_5f_sous-titre_3e_']"
                mode="pas"
            />
        </div2>
    </xsl:template>
    
    <xsl:template match="_3c_speaker_3e_" mode="pas">
        <xsl:element name="sp">
            <xsl:attribute name="who">
                <xsl:value-of select="translate(., $ABC, $abc)"/>
            </xsl:attribute>
            <xsl:element name="speaker">
                <xsl:apply-templates/>
            </xsl:element>
            <xsl:apply-templates select="following-sibling::*[1][name()!='_3c_speaker_3e_'
                and name()!='_3c_Pagedetitre_5f_sous-titre_3e_']"
                mode="pas"
            />
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*" mode="pas">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!--
    ===================================
            NETTOYAGE DU HEADER
    ===================================
    -->
    
    <xsl:template match="_3c_term_3e_">
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
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="_3c_Pagedetitre_5f_sous-titre_3e_" mode="front">
        <xsl:element name="head">
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
    ==============================
                CONTENU
    =============================
    -->
    
    <!-- Le contenu sera traité ailleurs (T1, T3) pour des questions de facilité. -->
        
</xsl:stylesheet>