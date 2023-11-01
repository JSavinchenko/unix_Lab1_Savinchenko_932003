#!/bin/bash -e

sourceFile=$1

if [ -z "$sourceFile" ]; then
  echo "enter cpp filename"
  exit 1
fi

outputFile="$(grep -i "Output:" "$sourceFile" | cut -d ':' -f2- | tr -d '[:space:]/')"

tempDirectory=$(mktemp -d)

trap delete_dir EXIT HUP INT QUIT PIPE TERM

thisDirectory=$(pwd)

cp "$sourceFile" "$tempDirectory"
cd "$tempDirectory"

if [ -z "$outputFile" ]; then
  echo "Name for output file is empty in the .cpp file."
  exit 1
fi

g++ "$sourceFile" -o "$outputFile"
mv "$outputFile" "$thisDirectory"
cd "$thisDirectory"

delete_dir(){
echo "Temporary directory was deleted"
rm -rf $tempDirectory
}

echo "Successful compilation. Output: $outputFile"
exit 0
