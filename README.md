<p align="center">
README.md
</p>

# Projet facétie - documentation

## Présentation du projet 

« Facéties » est un projet coordonné par Louise Amazan et Marie-Claire Thomine et soutenu par le labex Obvil (Sorbonne Universités) visant à la numérisation, la transcription et l’encodage d’un échantillon représentatif de la littérature facétieuse telle qu’elle se développe en France entre le XVe et le XVIIe siècle. 

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


## Le corpus Facéties

Le corpus est constitué de dix ouvrages prioritaires dans leur transcription. 

- **Auteurs représentés** :

   - ANONYME, Le recueil des hystoires des repeus franches III-F-019
   - ANONYME, Les avantures ioyeuses et faitz merveilleux de Tiel Ulespiegle.
Ensemble, les grandes fortunes à luy avenues en diverses regions, lequel par
falace ne se laissoit aucunement tromper. Le tout traduit d’Allemant en
Françoys XI-D-033
   - ANONYME, Les cent nouvelles. S’ensuyvent les cent nouvelles contenant cent
hystoires ou nouveaulx comptes plaisans a deviser en toutes bonnes
compaignies par matiere de ioyeusete IV-E-026
   - A.D.S.D., Les comptes du monde adventureux. Où sont recitees plusieurs
belles Histoires memorables; & propres pour resiouir la compagnie, & éviter
mélancholie XII-B-059
   - BOCCACE, Boccace des cent nouvelles XVIII-C-013
   - BOCCACE, Le Decameron de Messire Iehan Bocace Florentin, nouvellement
traduict d’Italien en Françoys par Maistre Anthoine le Macon conseiller du Roy
& tresorier de lextraordinaire de ses guerres, trad. Antoine Le Maçon IV-H-038
   - CHAPPUYS, Gabriel, Les facetieuses iournees, contenans cent certaines et
agreables Nouvelles la plus part advenuës de nostre temps, les autres recueillies
& choisies de tous les plus excellents autheurs estrangers qui en ont escrit. Par
G.C.D.T. Gabriel Chappuis tourangeau III-D-006
   - MOTTE ROULLANT, LA, Les Fascetieux devitz des cent nouvelles,
nouvelles, tres récréatives et fort exemplaires pour resveiller les bons espritz
Francoys, veuz et remis en leur naturel, par le seigneur de la Motte Roullant
Lyonnois, homme tresdocte & bien renommé V-C-005
   - POGGE, Le, VALLA, Lorenzo et PÉTRARQUE, Pogii florentini oratoris
clarissimi facetiarum liber incipit feliciter ; Facetie morales Laurentii vallensis
alias esopus grecus per dictum Laurentium translatus incipiunt feliciter ;
Francisci petrarche de salibus virorum illustrium ac facetiis. Tractatus incipit
feliciter VIII-F-042
   - POGGE, Le, S’ensuyvent les facecies de Poge translatees de latin en francoys
qui traitent de plusieurs nouvelles choses moralles III-F-116 

- **Voir aussi** : voir la liste des dix ouvrages

## Outils utilisés 

**dossier** : faceties

- _doc_ : documentation complémentaire au projet facéties (colloque, journée 			d'étude, chartes graphiques)

- _odt_orig_ : fichiers `odt` à relire

- _odt-corr_ : fichiers `odt` déjà relus, en attente de traitement `xml`

- _xsl_ : transformation(s) utilisée(s) 
_[transformation `xsl` récupérées du projet Epistemon des BVH, avec quelques ajouts qui l'adapte plus aux textes traités]_

- _xml-orig_ : fichiers `xml` obtenus grâce à Odette

- _xml_ : fichiers `xml` obtenu après la tranformation xsl, dont les abréviations ont été résolues

- _schema_ : schéma utilisé, auquel se conforment les documents `xml` _[schéma récupéré du site des BVH]_

- _work_ : dossier servant d'espace test, pour les fichiers en cours de traitement (qu'il s'agisse de relecture ou d'`xml`)

## Schèma epistemon

Schéma pris du projet "Epistemon", développé par les BVH

- **Voir aussi** :https://sourceforge.net/projects/bvh/files/BVH-ODD/BVH_Epistemon.rng/download


[problème des balises "licence" et "creation"]

## Particularités d'encodage

#### `xsl`

## Transformation 

**AVANT LA TRANSFORMATION** 

- suppression des <lb/> qui seront répétés après la passage de la transformation xsl
pour chaque : 
rechercher "`Ñ(\s*]<lb/>`" => remplacer "`Ñ$1`"

###### Résolution d'abréviations - Ajout de conditions 
[mode="pass2"]

- exception comportant plusieurs exceptions (à oompléter selon les cas)

   - exemple : 
   
   Les abréviations "simples" 
   - "" par "par"
   - "

- Pour les abréviations dont la résolution varient selon le contexte

-> insertion de balises <gap> et <desc>, ainsi que de "#", pour pouvoir repérer facilement ces abréviations pour les résoudres localement selon le contexte 

```xml
<xsl:when test="matches(., '^(\w*)p̃$')">
            <choice>
               <orig>
                  <xsl:value-of select="."/>
               </orig>
               <gap>
                  <desc>
                     <reg>
                        <xsl:text>#</xsl:text>
                        <xsl:value-of select="substring-before(., 'p̃')"/>
                        <xsl:text>#</xsl:text>
                     </reg>
                  </desc>
               </gap>
            </choice>
         </xsl:when>
```
		 
```xml

 <xsl:when test="matches(., '^(\w*)ↄtinuellemẽt(\w*)$')">
            <choice>
               <orig>
                  <xsl:value-of select="."/>
               </orig>
               <reg>
			   <xsl:value-of select="substring-before(., 'ↄtinuellemẽt')"/>continuellement<xsl:value-of select="substring-after(., 'ↄtinuellemẽt')"/>
			   </reg>
            </choice>
         </xsl:when>
```

- résolution  
   - "r rotunda" (orig) = "et" (reg)
   
 - selon le contexte, repérable par des "#" : 
   - "ↄ" (orig) = "con/com" (reg) 



manipulation 
- ``xml`

les césures 

- faire un `rechercher/remplacer`
`Ñ(\s*]<lb/>` => `Ñ$1`

# Les transformations XSL

Quatre transformations à exécuter dans l'autre (T1, T2, T3, T3 bis, T4 orig/T4 reg)


### T1_ODT_vers_XML-ODT.xsl : content.xml > fichier XML

-> faire glisser l'odt du tete corrigé et stylé dans oxygen pour en extraire le content.xml
-> débogeur xslt : XML content.xml vers XSL : T1_ODT_vers_XML-ODT.xsl en 'saxon-PE 9.8.0.12"
-> enregistrer

### T2_XML-ODT_vers_XML.xsl : XML > XML hiérarchisé
- hierarchisation `div1` / `div2` / `sp`
- `header` : premier passage
- `front` : premier passage

### T3_XML_versXML-BVH.xsl : XML > XML conforme au schéma BVH
- `header` : mise en place du header conforme
- suppression des balises parasites éventuelles
- `front` : mise en place d'un frontiespiece conforme (index, castList)
- `l`/`p` : gestion des alinéas (implicites et explicites)
- `l`/`p` : gestion des cul de lampe
- `<space quantity="1" unit="lignes"/>` : mise en place
- `corr`/`sic` : entouré d'un `choice`
- normalisation (abréviations, dissimulation)
- différenciation des césures : 
  - césures implicites (Ĝ) `<choice change="cesure_implicite">`
  - césures implicites (Ñ) `<pc change="cesure_explicite">`
  
### T3bis_XML_versXML-BVH.xsl : XML conforme au schéma BVH

- normalisation du deuxième élément dans les mot possédant deux éléments à normaliser

### T4_XML-TEI_vers_HTML.xsl : XML BVH > HTML