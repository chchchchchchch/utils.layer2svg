
extract layers from an inkscape svg into separate svg files.

    sed 's/ / \n/g' $SVG |                                   # REPLACE ALL SPACES WITH A LINEBREAK
    sed '/^.$/d' |                                           # REMOVE ALL EMPTY LINES
    sed -n '/<\/metadata>/,/<\/svg>/p' | sed '1d;$d' |       # PRINT SECTION BETWEEN </metadata> AND </svg> (EXCLUSIVE)
    sed ':a;N;$!ba;s/\n/ /g' |                               # REMOVE ALL LINEBREAKS
    sed 's/<\/g>/\n<\/g>/g' |                                # ADD LINEBREAK BEFORE GROUP END </g>
    sed 's/\(<g.*inkscape:group[^>]*>\)/QWERTZUIOP\1/g' |    # ADD PLACEHOLDER BEFORE <g ... > CONTAINING GROUPMODE PATTERN
    sed ':a;N;$!ba;s/\n/ /g' |                               # REMOVE ALL LINEBREAKS
    sed 's/QWERTZUIOP/\n\n\n\n/g' | \                        # REPLACE PREVIOUSLY SUBSTITUTED PLACEHOLDER WITH NEWLINES
    sed 's/display:none/display:inline/g'                    # MAKE HIDDEN LAYERS VISIBLE