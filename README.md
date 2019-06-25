
# README.md

# Projet facétie - documentation

## <span style="color: #000080">Sommaire</span>

	 I. Présentation du projet
	 II. Le dossier "faceties" (Github)
	 III. Stylage du document
	 IV. Les transformations XSL
	 V. Le corpus *Facéties* - Bibliographie

## <span style="color: #000080">I. Présentation du projet</span>

« Facéties » est un projet coordonné par Louise Amazan et Marie-Claire Thomine, soutenu par le labex Obvil (Sorbonne Universités) visant à la numérisation, la transcription et l’encodage d’un échantillon représentatif de la littérature facétieuse telle qu’elle se développe en France entre le XVe et le XVIIe siècle. 

- **Equipe**

   - Louise Amazan-Comberousse (Université Paris-Sorbonne et BNF)
   - Marie-Claire Thomine (Université Charles-de-Gaulle, Lille )
   - Tiphaine Rolland (Université Paris-Sorbonne)
   - Dominique Bertrand (Université Clermont Auvergne)
   - Nora Viet (Université Clermont Auvergne)
   - Vincent Dupuis (Montréal) (†)
   - Marine Gaulin et Julie Monsterlet (Université de Lille)
   - Nicolas Kiès (Classes préparatoires, Fontainebleau)
   - Katell Lavéant (Université d’Utrecht)
   - Romain Weber (Bibliothèque historique de la ville de Paris)
   - Anne Réach-Ngô (Université de Haute Alsace)
   - Florence Bistagne (Université d’Avignon)
   - Elsa Kammerer (Université de Lille)
   - Anne Boutet (CESR, Tours)
   
- **Partenaires**

   - Paris-Sorbonne (Paris IV)
   - CELLF et Centre Saulnier
   - Domaine de Chantilly
   - Université de Lille (ALITHILA).


- **Voir aussi** : 
   - http://obvil.sorbonne-universite.site/projets/faceties
   - http://obvil.sorbonne-universite.site/actualite/facetie-et-humanites-numeriques/mar-19022019-0000

## <span style="color: #000080">II. Le dossier "faceties" (Github)</span>

**Documents par ordre d'apparition :**

- **doc** : documentations complémentaires au projet facéties (colloque, journée d'étude, chartes graphiques des différents textes, liste des 10 ouvrages, etc...)

	- _`faceties-guide_des_style.odt`_ : document `odt` qui reprend tous les styles utilisés dans la correction des textes et qui sont traités par les transformation `xml`

	- _`faceties-exemple_style.odt`_ : document "vide" comportant les styles à utilisés

	- _`faceties-cahier_des_charges_2019.odt`_ : cahier des charges mis à jour figurant les attentes du projet

- **odt-corr** : fichiers `odt` déjà relus, en attente de traitement `xml`

- **odt_orig** : les 10 fichiers `odt` à relire qui ont été transcrits par les entreprises (infoscribe, etc.)

- **schema** : schéma utilisé, auquel se conforment les documents `xml` (schéma "Epistemon", développé par les BVH et adapté à notre projet "Facéties", dont le *header* a été adapté pour se conforter aux besoins du projet Facéties) → **Voir** : https://sourceforge.net/projects/bvh/files/BVH-ODD/BVH_Epistemon.rng/download

- **xml** : fichiers `xml` finaux obtenus après les tranformations `xsl` (contient le fichier `faceties_001.xml`)

- **xsl** : transformations utilisées 

- _`README.md`_ : documentation sur le projet


# <span style="color: #000080">III. Stylage du document</span>

- pour récupérer les styles déjà utilisés : voir la fiche `faceties-guide_des_style.odt`.

Les styles du document .odt seront intégrés au document. 

- pour des questions sur le stylage des éléments textuels : voir le guide de relecture`faceties-cahier_des_charges_2019.odt`

- pour remplacer les abréviations encodés par l'entreprise de transcription (par exemple "(e1)" en "ẽ") : voir les tableaux graphiques ou `faceties-cahier_des_charges_2019.odt`

 
- /!\ faire attention à la hiérarchisation des styles : voir `faceties-cahier_des_charges_2019.odt`, section `12. hiérarchisation`

## <span style="color: #000080">IV. Les transformations XSL</span>

7 transformations à exécuter dans l'ordre pour transformer l'`.odt` en `.html`
- `T1_ODT_vers_XML-ODT`
- `T2_1_hierarchisation`
- `T2_2_hierarchisation`
- `T2_3_hierarchisation`
- `T3_XML_vers_XML-BVH`
- `T3bis_XML_versXML-BVH`
- `T4_XML-TEI_vers_HTML_orig` / `T4_XML-TEI_vers_HTML_reg`

Les trois transformations intitulées "hierarchisation" feront l'objet d'un assemblage futur. 


### <span style="color: #F81207">T1_ODT_vers_XML-ODT.xsl : content.xml > fichier XML</span>

#### Objectifs de la transformation : 

- transforme l'`odt` corrigé en fichier `xml`

- ne garde que les informations qui nous intéresse (le nom des balises obtenus par cette transformation ne sont pas définitives, ils changeront au passage de la deuxième transformation)

#### Consignes : 

- faire glisser l'`odt` du texte corrigé et stylé dans oxygen pour en extraire le `content.xml`

- débogeur xslt : XML `content.xml` vers XSL : `T1_ODT_vers_XML-ODT.xsl` en `saxon-PE 9.8.0.12`

- enregistrer le premier XML en spécifiant `NOM_DU_DOCUMENT_xml_1.xml`


### <span style="color: #F81207">T2_1_hierarchisation.xsl : XML > XML hiérarchisé</span>

#### Objectifs de la transformation : 

- hiérarchise les blocs d'informations avec des niveaux (`div1` ; `div2` ; `sp`)

- `header` : premier passage
- `front` : premier passage

#### Consignes : 

- transformer le fichier `NOM_DU_DOCUMENT_xml_1.xml` (étape précédente) avec `T2_1_hierarchisation.xsl`

- enregistrer le résultat XML en spécifiant `NOM_DU_DOCUMENT_xml_2_1.xml`


### <span style="color: #F81207">T2_2_hierarchisation.xsl : XML > XML hiérarchisé</span>

#### Objectifs de la transformation : 

??

#### Consignes : 

- transformer le fichier `NOM_DU_DOCUMENT_xml_1.xml` (étape précédente) avec `T2_2_hierarchisation.xsl`

- enregistrer le résultat XML en spécifiant `NOM_DU_DOCUMENT_xml_2_2.xml`


### <span style="color: #F81207">T2_3_hierarchisation.xsl : XML > XML hiérarchisé</span>

#### Objectifs de la transformation : 

 ??

#### Consignes : 

- transformer le fichier `NOM_DU_DOCUMENT_xml_1.xml` (étape précédente) avec `T2_3_hierarchisation.xsl`

- enregistrer le résultat XML en spécifiant `NOM_DU_DOCUMENT_xml_2_3.xml`

#### Problèmes déjà rencontrés: 

- les `&` de certaines nouvelles ne sont pas prises en compte automatiquement -> à remplacer par `&amp;`


### <span style="color: #F81207">T3_XML_versXML-BVH.xsl : XML > XML conforme au schéma BVH</span>

#### Objectifs de la transformation : 

- met en place un `header` conforme aux normes de l'OVIL et de la TEI p5

- met en place un frontiespiece conformer (index, castList) avec la balise `front` (→ **Voir** : `faceties_guide_de_relecture.odt`)

- mise en place de `<space quantity="1" unit="lignes"/>`

- gère les alinéas implicites et explicites (`(C)`,`(D)`) en `l` et `p`

- gère les cul-de-lampes avec une balise `cul_de_lampe` en `l` et `p`

- entoure d'un `choice` les balises `corr` et`sic` qui servent pour l'insertion des interventions éditoriales (coquilles)

- différencie par un `choice change` les césures implictes `Ĝ` (`<choice change="cesure_implicite">`) des césures explicites `Ñ` (`<pc change="cesure_explicite">`)

- résout les abréviations et les dissimulations
  
 - supprime les éventuelles parasites

 
#### Consignes : 

- transformer le fichier `NOM_DU_DOCUMENT_xml_2_3.xml` (étape précédente) avec `T3_XML_versXML-BVH.xsl`

- enregistrer le résultat XML en spécifiant `NOM_DU_DOCUMENT_xml_3.xml`


### <span style="color: #F81207">T3bis_XML_versXML-BVH.xsl : XML conforme au schéma BVH</span>

#### Objectifs de la transformation : 

- normalise le deuxième élément dans les mot possédant deux éléments à normaliser

#### Consignes : 

- transformer le fichier `NOM_DU_DOCUMENT_xml_3.xml` (étape précédente) avec `T3_XML_versXML-BVH.xsl`

- enregistrer le résultat XML en spécifiant `NOM_DU_DOCUMENT_xml_3_bis.xml`


### <span style="color: #F81207">T4_XML-TEI_vers_HTML.orig.xsl - T4_XML-TEI_vers_HTML.reg.xsl</span>

#### Objectifs de la transformation : 

- création de deux transformations `xsl`, une dite "orig" qui désigne la version fac-similaire, et l'autre dite ".reg" pour la version normalisée

- chaque transformation reprend les informations et les balises qui sont propres au rendu `html` que l'on souhaite obtenir (→ **Voir** : `faceties-cahier_des_charges.odt`)

- les transformations sont liées à la `css` correspondante au rendu `html` voulu

#### Consignes : 

##### version fac-similaire

- transformer le fichier `NOM_DU_DOCUMENT_xml_3_bis.xml` (étape précédente) avec `T4_XML-TEI_vers_HTML.orig.xsl`

- enregistrer le résultat XML en spécifiant `NOM_DU_DOCUMENT_xml_4_orig.xml`

##### version normalisée

- transformer le fichier `NOM_DU_DOCUMENT_xml_3_bis.xml` (étape précédente) avec `T4_XML-TEI_vers_HTML.reg.xsl`

- enregistrer le résultat XML en spécifiant `NOM_DU_DOCUMENT_xml_4_reg.xml`


## <span style="color: #000080">V. Le corpus *Facéties* - Bibliographie</span>

Le corpus est constitué de dix ouvrages prioritaires dans leur transcription. 

- **Auteurs représentés** :

   - ANONYME, *Le recueil des hystoires des repeus franches*, 1490, III-F-019 (005)
   - ANONYME, *Les avantures ioyeuses et faitz merveilleux de Tiel Ulespiegle. Ensemble, les grandes fortunes à luy avenues en diverses regions, lequel par falace ne se laissoit aucunement tromper. Le tout traduit d’Allemant en Françoys*, 1559, XI-D-033 (006)
   - ANONYME, *Les cent nouvelles. S’ensuyvent les cent nouvelles contenant cent hystoires ou nouveaulx comptes plaisans a deviser en toutes bonnes compaignies par matiere de ioyeusete*, 1530, IV-E-026 (007)
   - A.D.S.D., *Les comptes du monde adventureux. Où sont recitees plusieurs belles Histoires memorables; & propres pour resiouir la compagnie, & éviter mélancholie*, 1595, XII-B-059 (008)
   - BOCCACE, *Boccace des cent nouvelles*, ?, XVIII-C-013 (003)
   - BOCCACE, *Le Decameron de Messire Iehan Bocace Florentin, nouvellement traduict d’Italien en Françoys par Maistre Anthoine le Macon conseiller du Roy & tresorier de lextraordinaire de ses guerres, trad. Antoine Le Maçon*, 1545, IV-H-038 (004)
   - CHAPPUYS, Gabriel, *Les facetieuses iournees, contenans cent certaines et agreables Nouvelles la plus part advenuës de nostre temps, les autres recueillies & choisies de tous les plus excellents autheurs estrangers qui en ont escrit. Par G.C.D.T. Gabriel Chappuis tourangeau*, 1584, III-D-006 (009)
   - MOTTE ROULLANT, LA, *Les Fascetieux devitz des cent nouvelles, nouvelles, tres récréatives et fort exemplaires pour resveiller les bons espritz Francoys, veuz et remis en leur naturel, par le seigneur de la Motte Roullant Lyonnois, homme tresdocte & bien renommé*,  1549, V-C-005 (008)
   - POGGE, Le, VALLA, Lorenzo et PÉTRARQUE, *Pogii florentini oratoris clarissimi facetiarum liber incipit feliciter ; Facetie morales Laurentii vallensis alias esopus grecus per dictum Laurentium translatus incipiunt feliciter ; Francisci petrarche de salibus virorum illustrium ac facetiis. Tractatus incipit feliciter*, 1475, VIII-F-042 (001)
   - POGGE, Le, *S’ensuyvent les facecies de Poge translatees de latin en francoys qui traitent de plusieurs nouvelles choses moralles*,  1512, III-F-116 (002)

- **Voir aussi** : voir la liste des dix ouvrages (pdf)




