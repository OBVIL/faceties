### T1_ODT_vers_XML-ODT.xsl : content.xml > fichier XML

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

