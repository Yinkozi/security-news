#!/usr/bin/env bash

if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed' >&2
  exit 1
fi

if ! [ -x "$(command -v curl)" ]; then
  echo 'Error: curl is not installed' >&2
  exit 1
fi

if [[ -z "${X_API_KEY}" ]]; then
    echo "X_API_KEY is not set"
    exit 1
fi

cat latest.json | jq -r '.linksAuto[].link,.linksCurated[].link' | uniq > links.txt
articles=$(python ./bin/initialise_votes.py | printf %s "$(cat)" | jq -R -s -c 'split("\n")')
date=$(date +'%Y-%m-%d')
data='{"date":"'"$date"'","articles":'"$articles"'}'
echo $data
res=$(curl -s -o /dev/null -w "%{http_code}" -X PUT -H 'x-api-key: '"${X_API_KEY}"'' -H 'Content-Type: application/json' -H 'Host: protocol.yinkozi.com' -d ''"$data"'' 'https://protocol.yinkozi.com/api/vote')
if [ "$res" != "201" ]; then
    echo 'Error: cannot initialise vote: http_response '"$res" >&2
    exit 1
fi