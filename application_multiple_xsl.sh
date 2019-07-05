#!/usr/bin/bash

# Arthur Provenier, 2019
# Labex OBVIL

# Pour télécharger SAXON-HE : http://www.saxonica.com/download/java.xml
# ! Vérifier le numéro de la version de Saxon dans la commande
SAXON_PATH="SaxonHE9-9-1-4J"
COMMAND="java -cp $SAXON_PATH/saxon9he.jar net.sf.saxon.Transform -t"

# Array contenant les transformations à appliquer
# Ajouter des transformations dans l'ordre voulu
declare -a arr_xsl=("T1_ODT_vers_XML-ODT.xsl"
                    "T2_1_Hierarchisation.xsl"
                    "T2_2_Hierarchisation.xsl"
                    "T2_3_Hierarchisation.xsl"
                    "T3_XML_versXML-BVH.xsl"
                    "T3bis_XML_versXML-BVH.xsl"
                    "T3bis_XML_versXML-BVH.xsl"
                   )
# La taille du tableau pour une future itération
arraylength=${#arr_xsl[@]}

SRCXSL="xsl"        # Dossier contenant les fichiers xsl
SRCODT="odt_corr"   # Dossier contenant les .odt
DEST="result_xml"   # Dossier où sera stocké les résultats

for file in `ls $SRCODT`
do
    echo -e "################################################################################\n"

    if [[ $file == *.odt ]]
    then

        echo -e $file

        # Extraction du content.xml contenu dans l'archive .odt
        unzip "$SRCODT/$file" content.xml
        mv content.xml "$DEST/content-tmp.xml"
        CONTENT="$DEST/content-tmp.xml"

        for (( i=1; i<${arraylength}+1; i++ ));
        do
            echo -e "\n>>>>> Processing XSL: $SRCXSL${arr_xsl[$i-1]}\n"
            destFile="$file-$i-tmp.xml"

           $COMMAND -s:"$CONTENT" -xsl:"$SRCXSL/${arr_xsl[$i-1]}" -o:"$DEST/$destFile"

           # Re-assign new XML file created to CONTENT
           declare CONTENT="$DEST/$destFile"
        done

        # Nettoyage
        mv $CONTENT "$DEST/$file-result.xml"
        rm $DEST/*tmp.xml

    else
        :
    fi
done
