input=$(wget -qO- https://www.boursorama.com/bourse/forum/1rPALKAL/)

printf %s "$input" |
    while IFS= read -r line; do
	if echo "$line" | grep -q "Cours KALRAY"; then
	    sign=`echo "$line" | sed -r 's/.*variation&quot;:(.).*/\1/'`
	    if [ "$sign" == "-" ]
	    then
		color="f00"
	    else
		color="0f0"
	    fi
	    value=`echo "$line" | sed -r 's/.*last&quot;:([0-9\.]+).*/\1/'`
	    echo "%{F#$color}ALKAL $value%{F-}"
	fi
    done
