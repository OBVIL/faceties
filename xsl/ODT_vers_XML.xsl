<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	exclude-result-prefixes="xs xd" version="2.0">
	<xd:doc scope="stylesheet">
		<xd:desc>
			<xd:p><xd:b>Created on:</xd:b> Mar 5, 2017</xd:p>
			<xd:p><xd:b>Author:</xd:b> Gasiglia</xd:p>
			<xd:p/>
		</xd:desc>
	</xd:doc>
	<!--<xsl:output indent="yes"></xsl:output>-->

	<!--
Traitement des éléments du fichier XML généré par la transformation "ODTversXML=Audrain+Gasiglia_ODT2016.xslt" à partir du fichier "content.xml"
-->

	<!-- repérage des éléments non traités -->
	<xsl:template match="*">
		<xsl:text> ######## </xsl:text>
		<xsl:value-of select="local-name()"/>
		<xsl:text> ######## </xsl:text>
	</xsl:template>

	<!-- Traitement effectif -->
	<xsl:template match="/">
		<xsl:text>
</xsl:text>
		<TEI>
			<teiHeader>
				<fileDesc>
					<titleStmt>
						<title>Othovyen</title>
						<author>Anonyme</author>
					</titleStmt>
					<publicationStmt>
						<p>
							<date>1454</date>
						</p>
					</publicationStmt>
					<sourceDesc>
						<bibl>
							<title>Document numérique natif d'"Othovyen"</title>
							<respStmt>
								<resp>Transcription normalisée du texte</resp>
								<name type="person" xml:id="MM">Matthieu Marchal</name>
							</respStmt>
							<textLang>moyen français</textLang>
						</bibl>
						<listWit>
							<witness xml:id="B">Bruxelles, KBR, 10387</witness>
							<witness xml:id="O">Orléans, BM, 466</witness>
							<witness xml:id="P">Paris, BnF, n.a.fr. 21069</witness>
							<witness xml:id="T">Torino, BNU, L-I-14</witness>
							<witness xml:id="C">Chantilly, Musée Condé, 652 <bibl>
									<funder>Jean V de Créquy</funder>
								</bibl>
								<msDesc>
									<msIdentifier>
										<country>France</country>
										<settlement>Chantilly</settlement>
										<repository>Musée Condé</repository>
										<idno>652</idno>
										<msName>Le livre des haulx fais et vaillances de l’empereur
											Othovyen</msName>
									</msIdentifier>
									<physDesc>
										<p>manuscrit contemporain de la rédaction et réalisé dans
											les Pays-Bas bourguignons</p>
										<p>manuscrit illustré qui comprend des miniature dues à un
											peintre lillois, "Le Maître de Wavrin"</p>
									</physDesc>
								</msDesc>
							</witness>
						</listWit>
					</sourceDesc>
				</fileDesc>
			</teiHeader>
			<text>
				<xsl:apply-templates select="//body" mode="parent_text"/>
				<back>
					<div>
						<msDesc>
							<msIdentifier>
								<bloc>Othovyen</bloc>
							</msIdentifier>
							<physDesc>
								<decoDesc>
									<xsl:apply-templates select="//TEIdecoNote" mode="pour_back"/>
								</decoDesc>
							</physDesc>
						</msDesc>
					</div>
				</back>
			</text>
		</TEI>
	</xsl:template>

	<xsl:template match="body" mode="parent_text">
		<xsl:element name="body">
			<xsl:apply-templates mode="parent_body"/>
		</xsl:element>
	</xsl:template>


	<xsl:template
		match="TEIcb[not(preceding-sibling::TEIdiv_40_type_3d__22_chapitre_22_)] | TEIpb[not(preceding-sibling::TEIdiv_40_type_3d__22_chapitre_22_)]"
		mode="parent_body">
		<xsl:element name="{substring-after(local-name(), 'TEI')}">
			<xsl:attribute name="n">
				<xsl:value-of select="normalize-space()"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template match="TEIcb | TEIpb" name="sauts">
		<xsl:element name="{substring-after(local-name(), 'TEI')}">
			<xsl:attribute name="n">
				<xsl:value-of select="normalize-space()"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template match="TEIhead" mode="parent_div">
		<xsl:element name="head">
			<xsl:attribute name="xml:id" select="generate-id()"/>
			<!--<xsl:attribute name="resp"><xsl:text>#editor</xsl:text></xsl:attribute>-->
			<!-- #voir pourquoi il n'est pas accepté par les parseur TEI-->
			<xsl:value-of select="normalize-space()"/>
		</xsl:element>
	</xsl:template>

	<!-- <TEIdiv_40_type_3d__22_chapitre_22_> : le <div> généré doit enchâsser un <p> afin de pouvoir contenir des sous-éléments ou du texte -->
	<xsl:template match="TEIdiv_40_type_3d__22_chapitre_22_" mode="parent_body">
		<xsl:element name="div">
			<xsl:attribute name="type">
				<xsl:text>chapitre</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="xml:id" select="generate-id()"/>
			<xsl:apply-templates mode="parent_div_chapitre"/>
			<!-- appel du traitement du fils <TEIhead> -->
			<xsl:apply-templates select="following-sibling::TEIrubric[1]"
				mode="inclusion_dans_div_chapitre"/>
			<!-- appel du traitement du frère postposé <TEIrubric> à inclure dans le chapitre -->
			<!--node()[1][local-name()='TEIrubric']-->
			<xsl:element name="div">
				<!-- Le <div>/<p> créé doit inclure les frères postposés jusqu'à la miniature suivante -->
				<xsl:attribute name="type">
					<xsl:text>contenu</xsl:text>
				</xsl:attribute>
				<!--<xsl:element name="p">-->
				<!-- appel du traitement des frères postposés à inclure dans le chapitre cad les frères (i) qui ont un <TEIdiv_40_type_3d__22_chapitre_22_> précédent dont l'@ID généré automatiquement a une valeur égale à celui du noeud en cours de traitement et (ii) qui ont un nom différent de "TEIdiv_40_type_3d__22_miniature_22_" -->
				<xsl:variable name="ID_el_courant" select="generate-id()"/>
				<xsl:variable name="N_el_courant" select="local-name()"/>
				<xsl:variable name="N_el_exclus">
					<xsl:text>TEIdiv_40_type_3d__22_miniature_22_</xsl:text>
				</xsl:variable>
				<xsl:apply-templates
					select="following-sibling::node()[preceding-sibling::TEIdiv_40_type_3d__22_chapitre_22_[1][generate-id() = $ID_el_courant]][local-name() != $N_el_exclus][local-name() != $N_el_courant][local-name() != $N_el_exclus][local-name() != 'TEIrubric']"
					mode="inclusion_dans_div_chapitre"/>
				<!--</xsl:element>-->
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- <TEIhead> du <div> avec @type chapitre -->
	<xsl:template match="TEIhead" mode="parent_div_chapitre">
		<xsl:element name="head">
			<!--<xsl:attribute name="resp"><xsl:text>#editor</xsl:text></xsl:attribute>-->
			<!-- #voir pourquoi il n'est pas accepté par les parseur TEI-->
			<xsl:attribute name="xml:id" select="generate-id()"/>
			<xsl:value-of select="normalize-space()"/>
		</xsl:element>
	</xsl:template>
	<!-- <TEIrubric> qui doit être inclus dans le <div> avec @type chapitre -->
	<xsl:template match="TEIrubric" mode="inclusion_dans_div_chapitre">
		<xsl:element name="div">
			<xsl:attribute name="type">
				<xsl:text>rubric</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="xml:id" select="generate-id()"/>
			<xsl:attribute name="ana"
				select="generate-id(preceding-sibling::TEIdiv_40_type_3d__22_chapitre_22_[1])"/>
			<xsl:element name="p">
				<xsl:apply-templates/>
				<!-- Appel du traitement des fils de <rubric> [cad (#PCDATA | TEIchoice.abbr_40_type_3d__22_contraction_22_ | TEIchoice.abbr_40_type_3d__22_signe-spécial_22_ | TEIchoice.expan | TEIex | TEIname | TEIname_40_key | TEIpc_40_type_3d__22_desagglutination_22_.choice.reg | TEIpc_40_type_3d__22_Maj-Min_22_.choice.orig | TEIpc_40_type_3d__22_Maj-Min_22_.choice.reg | TEIpc_40_type_3d__22_PONfbl_22_.choice.orig | TEIpc_40_type_3d__22_PONfrt_22_.choice.orig | TEIpc_40_type_3d__22_PONfrt_22_.choice.reg)*] sans mode spécial puisque leur traitement n'a rien de particulier -->
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- <TEIcb> et <TEIpb> qui doivent être inclus dans le <div> avec @type chapitre -->
	<xsl:template match="TEIcb | TEIpb" mode="inclusion_dans_div_chapitre">
		<xsl:call-template name="sauts"/>
	</xsl:template>
	
	<!-- <TEIp> qui doit être inclus dans le <div> avec @type chapitre -->
	<xsl:template match="TEIp" mode="inclusion_dans_div_chapitre">
		<xsl:element name="p">
			<xsl:attribute name="xml:id" select="generate-id()"/>
			<xsl:attribute name="ana"
				select="generate-id(preceding-sibling::TEIdiv_40_type_3d__22_chapitre_22_[1])"/>
			<xsl:apply-templates/>
			<!-- Appel du traitement des fils de <rubric> [cad (#PCDATA | TEIchoice.abbr_40_type_3d__22_contraction_22_ | TEIchoice.expan | TEIcorr_40_resp_3d__22__23_editor_22_ | TEIdecoNote | TEIex | TEIname | TEIname_40_key | TEIpc_40_type_3d__22_desagglutination_22_.choice.reg | TEIpc_40_type_3d__22_idd_22_.choice.orig | TEIpc_40_type_3d__22_idd_22_.choice.reg | TEIpc_40_type_3d__22_Maj-Min_22_.choice.orig | TEIpc_40_type_3d__22_Maj-Min_22_.choice.reg | TEIpc_40_type_3d__22_marque-césure_22_.choice.orig | TEIpc_40_type_3d__22_PONfbl_22_.choice.orig | TEIpc_40_type_3d__22_PONfbl_22_.choice.reg | TEIpc_40_type_3d__22_PONfrt_22_.choice.orig | TEIpc_40_type_3d__22_PONfrt_22_.choice.reg | TEIpc_40_type_3d__22_signes-diacritiques_22_.choice.orig | TEIpc_40_type_3d__22_signes-diacritiques_22_.choice.reg | TEIplaceName | TEIseg_40_type_3d__22_initial_22_ | TEIsic)*] sans mode spécial puisque leur traitement n'a rien de particulier -->
		</xsl:element>
	</xsl:template>
		
	<!-- <TEIcb> et <TEIpb> qui doivent être inclus dans le <q> -->
	<xsl:template match="TEIcb | TEIpb" mode="inclusion_dans_q">
		<xsl:call-template name="sauts"/>
	</xsl:template>
	
	<xsl:template
		match="TEIchoice.expan[preceding-sibling::node()[1][not(substring-before(local-name(), '40') = 'TEIchoice.abbr_')]]">
		<xsl:element name="choice">
			<xsl:element name="expan">
				<xsl:value-of select="normalize-space()"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<!-- <TEIPagedetitre_titre> -->
	<xsl:template match="Pagedetitre_titre">
		<xsl:element name="ex">
			<xsl:value-of select="normalize-space()"/>
		</xsl:element>
	</xsl:template>
	
	
	
	


	<!-- <TEIex> -->
	<xsl:template match="TEIex">
		<xsl:element name="ex">
			<xsl:value-of select="normalize-space()"/>
		</xsl:element>
	</xsl:template>


	<!-- <TEIsic> -->
	<xsl:template match="TEIsic">
		<xsl:element name="sic">
			<xsl:value-of select="normalize-space()"/>
		</xsl:element>
	</xsl:template>
	
	<!-- <TEIsic> -->
	<xsl:template match="TEIcorr">
		<xsl:element name="corr">
			<xsl:value-of select="normalize-space()"/>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
