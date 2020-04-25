#!/bin/bash


WEBSITE="$1"
counter=0


###########################################

#
#
# PREMIERE PARTIE
#
#

###########################################

echo "##########################"
echo "Obtention des liens pdf.."
echo " "
echo "##########################"
lynx -cache=0 -dump -listonly "$WEBSITE" | grep ".*\.pdf$" | awk '{print $2}' | tee lienspdf.txt

echo "##########################"
echo " "
echo " Le nombre de fichiers pdf obtenu est: " 
wc -l < lienspdf.txt
echo " "
echo "##########################"

echo "##########################"
echo " "
echo "Obtention de liens vers les autres sites"
echo " "
lynx -cache=0 -dump -listonly "$WEBSITE" |grep "http.*\members.loria.*./$"| awk '{print $2}' | tee adhoc.txt

echo " Le nombre de liens parcourus est: " 
wc -l < adhoc.txt
echo " "
echo "##########################"
echo "Parcours des autres sites hébergés par le LORIA.."
echo " "
echo "##########################"
echo " "


while IFS= read -r line; do
    lynx -cache=0 -dump -listonly "$line" |grep "http.*\members.loria.*./$" | awk '{print $2}' | tee adhocbis.txt
    let "counter+=1"
    lynx -cache=0 -dump -listonly "$line" | grep ".*\.pdf$" | awk '{print $2}' | tee lienspdfbis.txt
done < adhoc.txt


###########################################

#
#
# DEUXIEME PARTIE
#
#

###########################################
mkdir "pdfs"
mv "lienspdf.txt" "pdfs"
cd "pdfs"
wget -i lienspdf.txt
rm lienspdf.txt
cd ..

rm adhoc.txt
rm lienspdfbis.txt
rm adhocbis.txt







