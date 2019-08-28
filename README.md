
# Labex Obvil - Projet Facéties

## Présentation du projet

« Facéties » est un projet coordonné par Louise Amazan et Marie-Claire Thomine, soutenu par le [Labex Obvil](https://obvil.sorbonne-universite.fr/obvil/presentation) (Sorbonne Université) visant à la numérisation, la transcription et l’encodage d’un échantillon représentatif de la littérature facétieuse telle qu’elle se développe en France entre le XVe et le XVIIe siècle.

[Voir plus d'informations sur le projet](http://obvil.sorbonne-universite.fr/projets/faceties)

### Equipe scientifique du projet

Louise Amazan-Comberousse (Université Paris-Sorbonne et BNF)  
Marie-Claire Thomine (Université Charles-de-Gaulle, Lille )  
Tiphaine Rolland (Université Paris-Sorbonne)  
Dominique Bertrand (Université Clermont Auvergne)  
Nora Viet (Université Clermont Auvergne)  
Vincent Dupuis (Montréal) (†)  
Marine Gaulin et Julie Monsterlet (Université de Lille)  
Nicolas Kiès (Classes préparatoires, Fontainebleau)  
Katell Lavéant (Université d’Utrecht)  
Romain Weber (Bibliothèque historique de la ville de Paris)  
Anne Réach-Ngô (Université de Haute Alsace)  
Florence Bistagne (Université d’Avignon)  
Elsa Kammerer (Université de Lille)  
Anne Boutet (CESR, Tours)  

### Ingénierie

Anne-Laure Huet, ingénieure (Labex Obvil)  
Arthur Provenier, ingénieur (Labex Obvil)  
Jeanne Bineau, stage de fin d'études  
Nolwenn Chevalier, stage de fin d'études  

### Partenaires

Paris-Sorbonne (Paris IV)  
CELLF et Centre Saulnier  
Domaine de Chantilly  
Université de Lille (ALITHILA)  

## Normes de transcription   

- pour les informations concernant les normes de transcription des ouvrages voir le fichier `doc/faceties-guide_de_relecture.odt`
- pour que les transformations soient correctement effectuées les fichiers .odt doivent appliquer les styles définis dans `doc/faceties-guide_des_styles.odt`

## Informations techniques

- Le balisage des fichiers XML-TEI respecte le [schéma](https://sourceforge.net/projects/bvh/) défini par Les Bibliothèques Virtuelles Humanistes
- Les [transformations XSL](https://sourceforge.net/projects/bvh/files/Modernisation%20et%20Regularisation/) pour la modernisation et la dissimilation ont également été basées sur le travail effectué par Les Bibliothèques Virtuelles Humanistes


### Application : transformation .odt vers XML-TEI


#### Les transformations XSL

L'ensemble de ces transformations prennent en charge : la résolution des abréviations, la dissimilation, les coquilles d'auteurs.  
Ces transformations sont à appliquer à partir du fichier `content.xml` contenu dans l'`.odt`. Pour le récupérer : ouvrir le .odt dans un logiciel comme Oxygen // ou changer l'extension du fichier `.odt` en `.zip`.  
Sept transformations sont à exécuter dans l'ordre pour transformer l'`.odt` en `.html`:  

- `T1_ODT_vers_XML-ODT`
	- transforme le fichier `content.xml`
- `T2_1_hierarchisation`
	- nettoyer les balises parasites
	- nettoyer le balisage du frontiespiece et du header
	- nettoyer les `<l>`, `<p>` et les `<pb>`
	- préparer les titres pour la hierarchisation
	- instaurer les désagglutinations
	- instaurer les `<hi>`
	- instaurer les images

- `T2_2_hierarchisation`
	- repére les divisions du texte (`<div>`) et précise leur niveau (première étape de la hiérarchisation)
- `T2_3_hierarchisation`
	- assemble les différentes div (deuxième étape de la hiérarchisation)
- `T3_XML_vers_XML-BVH`
	- modification du balisage conformément au modèle des BVH
	- normalisation des mots contenant un seul élément à normaliser (première vague de normalisation)
	- mise en place du `header` conforme aux normes de l'OVBIL
	- mise en place d'un frontispiece conforme avec la balise `front` (→ **Voir** : `faceties_guide_de_relecture.odt`)
	- mise en place des `<space quantity="1" unit="lignes"/>`
	- gérer les alinéas implicites et explicites (`(C)`,`(D)`) en `l` et `p`
	- différencier par un `choice change` les césures implicites `Ĝ` (`<choice change="cesure_implicite">`) des césures explicites `Ñ` (`<pc change="cesure_explicite">`)
	- gérer les cul-de-lampes avec une balise `cul_de_lampe` en `l` et `p`
	- entourer d'un `choice` les balises `corr` et`sic` qui servent pour l'insertion des interventions éditoriales (coquilles)
	- résoudre les abréviations et les dissimilations
- `T3bis_XML_versXML-BVH` 
	- s'applique lorsque les mots contiennent déjà une abréviation
	- peut-être appliquée autant de fois que nécessaire
	- **ce dernier résultat nécessite une relecture pour résoudre les abréviations qui ne peuvent pas être automatisées : par/per et que/qui**. Lorsqu'elles sont présentes, cela doit générer une erreur. Elles sont repérées dans le texte par des '#'.
- `T4a-corrections.xsl`
	- corrections des erreurs sur le <front>
- `T4b-corrections.xsl`
	- corrections des erreurs sur le <front>
- `T4c-namespace.xsl`
	- ajout du namespace
- `T5_XML-TEI_vers_HTML_orig`
	- version fac-similaire
- `T5_XML-TEI_vers_HTML_reg`
	- version normalisée 

- Les transformations XML vers HTML sont liées à la `css` correspondante au rendu `html` voulu

- A noter : l'utilisation de saxon-PE 9.8.0.12

Le script `application_multiple_xsl.py` applique les transformations jusqu'à la `T3bis_XML_versXML-BVH`. Il nécessite l'installation au préalable de SaxonHE9-9-1-4J

## Informations sur le corpus

### Auteurs représentés

ANONYME, *Le recueil des hystoires des repeus franches*, 1490, III-F-019 (005)  
ANONYME, *Les avantures ioyeuses et faitz merveilleux de Tiel Ulespiegle. Ensemble, les grandes fortunes à luy avenues en diverses regions, lequel par falace ne se laissoit aucunement tromper. Le tout traduit d’Allemant en Françoys*, 1559, XI-D-033 (006)  
ANONYME, *Les cent nouvelles. S’ensuyvent les cent nouvelles contenant cent hystoires ou nouveaulx comptes plaisans a deviser en toutes bonnes compaignies par matiere de ioyeusete*, 1530, IV-E-026 (007)  
A.D.S.D., *Les comptes du monde adventureux. Où sont recitees plusieurs belles Histoires memorables; & propres pour resiouir la compagnie, & éviter mélancholie*, 1595, XII-B-059 (008)  
BOCCACE, *Boccace des cent nouvelles*, ?, XVIII-C-013 (003)  
BOCCACE, *Le Decameron de Messire Iehan Bocace Florentin, nouvellement traduict d’Italien en Françoys par Maistre Anthoine le Macon conseiller du Roy & tresorier de lextraordinaire de ses guerres, trad. Antoine Le Maçon*, 1545, IV-H-038 (004)    
CHAPPUYS, Gabriel, *Les facetieuses iournees, contenans cent certaines et agreables Nouvelles la plus part advenuës de nostre temps, les autres recueillies & choisies de tous les plus excellents autheurs estrangers qui en ont escrit. Par G.C.D.T. Gabriel Chappuis tourangeau*, 1584, III-D-006 (009)  
MOTTE ROULLANT, LA, *Les Fascetieux devitz des cent nouvelles, nouvelles, tres récréatives et fort exemplaires pour resveiller les bons espritz Francoys, veuz et remis en leur naturel, par le seigneur de la Motte Roullant Lyonnois, homme tresdocte & bien renommé*,  1549, V-C-005 (008)  
POGGE, Le, VALLA, Lorenzo et PÉTRARQUE, *Pogii florentini oratoris clarissimi facetiarum liber incipit feliciter ; Facetie morales Laurentii vallensis alias esopus grecus per dictum Laurentium translatus incipiunt feliciter ; Francisci petrarche de salibus virorum illustrium ac facetiis. Tractatus incipit feliciter*, 1475, VIII-F-042 (001)  
POGGE, Le, *S’ensuyvent les facecies de Poge translatees de latin en francoys qui traitent de plusieurs nouvelles choses moralles*,  1512, III-F-116 (002)  


