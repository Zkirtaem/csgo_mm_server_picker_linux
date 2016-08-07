#!/bin/bash
if [ -d "tmp" ]; then
   rm -rf tmp
fi

git clone https://github.com/denniskupec/csgo-matchmaking-ip-ranges.git tmp

if [ -d "serverdata" ]; then
   rm -rf serverdata
fi

mkdir serverdata
filename="nothing"
for line in `cat tmp/README.md | sed 's/(.*)//' | sed  -n -E '/(^[0-9, \*])/p' | sed '/\*\*\*/d' | sed -e 's/\ //g'` ; do
    if [[ $line == *"**" ]]; then
       filename=$line
    else
       echo $line >> serverdata/$filename
    fi
done

if [ -d "tmp" ]; then
   rm -rf tmp
fi
