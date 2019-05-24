T1
ODT vers XML
Permet un premier balayage afin de pouvoir
T2
Premier passage pour le Header
Copie du front
Hierarchisation de la partie textuelle
T3
Traitement des balises parasites
Abreviation
Dissimulation
Corr/sic
T4

Nom | De quoi à quoi | Fait quoi

| NOM DE LA TRANSFORMATION | DE QUOI A QUOI                   | TRAITE QUOI |
| :----------------------- | :------------------------------- | :---------- | 
| T1_ODT_vers_XML-ODT.xsl  | content.xml > fichier XML        | - hierarchisation `div1` / `div2` / `sp`
|                          |                                  | - `header` : premier passage
|                          |                                  | - `front` : premier passage
| T2_XML-ODT_vers_XML.xsl  | XML > XML hiérarchisé            | - `header` : mise en place du header conforme
|                          |                                  | - suppriession des balises parasites éventuelles
|                          |                                  | - `front` : mise en place d'un frontiespiece conforme (index, castList)
|                          |                                  | - `l`/`p` : gestion des alinéas (implicites et explicites)
|                          |                                  | - `l`/`p` : gestion des cul de lampe
|                          |                                  | - `<space quantity="1" unit="lignes"/>` : mise en place
|                          |                                  | - `corr`/`sic` : entouré d'un `choice`
|                          |                                  | - normalisation
|                          |                                  | 
| T3_XML_versXML-TEI.xsl   | XML > XML conforme au schéma BVH | 
| T4_XML-TEI_vers_HTML.xsl | XML BVH > HTML                   | 

