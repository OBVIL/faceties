<p align="center">
README.md
</p>

# Projet facétie - documentation

## Le corpus Facéties

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
## Transformation XSL

## Particularités d'encodage

#### `xsl`

###### Résolution d'abréviations - Ajout de conditions 
[mode="pass2"]

- exception comportant plusieurs exceptions (à oompléter selon les cas)

   - exemple : 

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

- 
   - "r rotunda" (orig) = "et" (reg)
   
 - selon le contexte, repérable par des "#" : 
   - "ↄ" (orig) = "con/com" (reg) 



manipulation 
- ``xml`

les césures 

- faire un `rechercher/remplacer`
`Ñ(\s*]<lb/>` => `Ñ$1`