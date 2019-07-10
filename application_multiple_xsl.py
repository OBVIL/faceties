#!/usr/bin/env python

"""
    Arthur Provenier - OBVIL
    Projet Faceties
    
    Script pour styliser des fichiers `odt` qui nécessitent plusieurs
    applications de feuilles `xsl` à la suite
    Pré-requis : SAXON-HE https://www.saxonica.com/download/java.xml
    Modifier la liste `transformations` en y indiquant les feuilles `xsl`
    Par défaut, le fichier créé sera sauvegardé dans 'transformation_result'
"""

import sys, os, argparse, re, zipfile, subprocess

parser = argparse.ArgumentParser(description="Running multiple xsl sheets on an odt file")
parser.add_argument("path_to_saxon",
                    help="Path to Saxon directory")
parser.add_argument("-i", "--input", nargs="?",
                    help="Path to input directory, containing .odt files")
parser.add_argument("-o", "--output", nargs="?",
                    help="Path to output directory where the result will be store")
parser.add_argument("-x", "--xsl", nargs="?",
                    help="Path to xsl directory")
args = parser.parse_args()

if args.input:
    input_dir = args.input
else:
    input_dir = "odt_corr"
    print "Using default path to input directory : odt_corr/"

if args.output:
    output_dir = args.output
else:
    output_dir = "transformation_result"
    print "Using default path to output directory : transformation_result/"

if args.xsl:
    xsl_dir = args.xsl
else:
    xsl_dir = "xsl"
    print "Using default path to xsl directory : xsl/"

# Apply xsl transformations from top to bottom
transformations = [
        "T1_ODT_vers_XML-ODT.xsl",
        "T2_1_Hierarchisation.xsl",
        "T2_2_Hierarchisation.xsl",
        "T2_3_Hierarchisation.xsl",
        "T3_XML_versXML-BVH.xsl",
        "T3bis_XML_versXML-BVH.xsl",
        "T3bis_XML_versXML-BVH.xsl"
        ]

# Creating output directory
if not os.path.isdir(output_dir):
    print "Creating output directory : %s" %output_dir
    os.makedirs(output_dir)

re_valid_file = re.compile(r'^[^.~]\w+\.odt$')

# Iteration through each .odt file
for odt_file in os.listdir(input_dir):

    if not re_valid_file.search(odt_file):
        continue

    path_odt_file = os.path.join(input_dir, odt_file)
    with zipfile.ZipFile(path_odt_file, 'r') as odt_zip:
        content = odt_zip.extract("content.xml", input_dir)

    # Apply each xsl to the previous xml created
    tmp_file_to_delete = ["%s/content.xml" %input_dir]
    for i, transformation in enumerate(transformations):
        i += 1
        tmp_output = "%s_%s_output_tmp.xml" %(path_odt_file, i)

        transformation_path = os.path.join(xsl_dir, transformation)
        print "Processing %s with %s" %(odt_file, transformation)

        command = ["java",
                   "-cp",
                   "%s/saxon9he.jar" %args.path_to_saxon,
                   "net.sf.saxon.Transform",
                   "-t",
                   "-s:%s" %content,
                   "-xsl:%s" %transformation_path,
                   "-o:%s" %tmp_output]

        process = subprocess.Popen(command)
        process.wait()

        content = tmp_output
        tmp_file_to_delete.append(content)

    # Cleaning tmp files and renaming result file
    for tmpfile in tmp_file_to_delete[:-1]:
        try:
            os.remove(tmpfile) 
        except OSError:
            pass
    try:
        os.rename(tmp_file_to_delete[-1],
                 os.path.join(input_dir, odt_file.replace('.odt', '-result.xml')))
    except OSError:
        pass

