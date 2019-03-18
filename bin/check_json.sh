#!/usr/bin/env bash

if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed' >&2
  exit 1
fi

usage(){
	echo "Usage: $0 --json_file=<news.json>"
	exit 1
}

if [[ $# -eq 0 ]] ; then
    usage
fi

jsonFilePath=""
case "$1" in
   --json_file=*)  jsonFilePath=(${1//--json_file=/}) ;;
   *) usage
esac

json=$(cat $jsonFilePath)
if jq -e . >/dev/null 2>&1 <<<"$json"; then
    echo "Parsed JSON successfully and got something other than false/null"
    exit 0
else
    echo "Failed to parse JSON, or got false/null"
    exit 1
fi
