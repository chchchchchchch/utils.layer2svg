#!/bin/bash

SVG=$1

SVGHEADER=` tac $SVG | sed -n '/<\/metadata>/,$p' | tac`

sed 's/ / \n/g' $SVG | \
sed '/^.$/d' | \
sed -n '/<\/metadata>/,/<\/svg>/p' | sed '1d;$d' | \
sed ':a;N;$!ba;s/\n/ /g' | \
sed 's/<\/g>/\n<\/g>/g' | \
sed 's/\(<g.*inkscape:groupmode="layer"[^>]*>\)/QWERTZUIOP\1/g' | \
sed ':a;N;$!ba;s/\n/ /g' | \
sed 's/QWERTZUIOP/\n\n\n\n/g' | \
sed 's/display:none/display:inline/g' > ${SVG%%.*}.tmp 


CNT=1
for LAYER in `cat ${SVG%%.*}.tmp | sed 's/ /ASDFGHJKL/g' | sed '/^.$/d'`
 do
     NAME=`echo $LAYER | \
           sed 's/ASDFGHJKL/ /g' | \
           sed 's/\" /\"\n/g' | \
           grep inkscape:label | \
           cut -d "\"" -f 2 | sed 's/[[:space:]]\+//g'`

     CNT=`echo 000$CNT | rev | cut -c 1-2 | rev`
     echo "$SVGHEADER"                        >  ${SVG%%.*}_${CNT}_$NAME.svg 
     echo $LAYER | sed 's/ASDFGHJKL/ /g'      >> ${SVG%%.*}_${CNT}_$NAME.svg
     echo "</svg>"                            >> ${SVG%%.*}_${CNT}_$NAME.svg
     CNT=`expr $CNT + 1`

done

rm ${SVG%%.*}.tmp


exit 0;