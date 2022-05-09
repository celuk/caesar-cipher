#!/bin/bash

while getopts ":i:o:s:" opt
do
  case $opt in
    i)
	inputFile="$OPTARG"
      ;;
    o)
	outputFile="$OPTARG"   
      ;;
    s)
	shiftAmount="$OPTARG"
      ;;
    \? ) 
	echo "Unknown option: -$OPTARG" >&2; 
	exit 1
	;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

if [[ "$inputFile" == "" || "$outputFile" == "" || "$shiftAmount" == "" ]]
then
      echo "3 arguments should be provided: [-i inputFile] [-o outputFile] [-s shiftAmount]" >&2
      exit 1
fi


chr() {
  printf \\$(printf '%03o' $1)
}

ord() {
  printf '%d' "'$1"
}


if [[ -f "$inputFile" ]]
then
	touch "$outputFile"	

	asciiNumA="$(ord A)"
	asciiNuma="$(ord a)"

	asciiNumZ="$(ord Z)"
	asciiNumz="$(ord z)"

	shiftAmountUpper=$(( $shiftAmount % ($asciiNumZ - $asciiNumA) ))
	shiftAmountLower=$(( $shiftAmount % ($asciiNumz - $asciiNuma) ))

	if [[ "$shiftAmountUpper" -eq 0 && "$shiftAmountLower" -eq 0 ]]
	then
		cat $inputFile > $outputFile
	else
		sAU="$(chr $(($shiftAmountUpper + $asciiNumA)))"
		sAUp="$(chr $(($shiftAmountUpper + $asciiNumA - 1)))"

		sAL="$(chr $(($shiftAmountLower + $asciiNuma)))"
		sALp="$(chr $(($shiftAmountLower + $asciiNuma - 1)))"

		cat "$inputFile" | tr "[a-z]" "[$sAL-za-$sALp]" | tr "[A-Z]" "[$sAU-ZA-$sAUp]" > "$outputFile"
	fi

	exit 0;
else
	echo "Input file does not exist!" >&2
	exit 1;
fi
