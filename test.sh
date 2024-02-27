#!/bin/bash
pwd

newline() {
    echo -e "\n"
}

declare -r path=$(dirname $(realpath "$0"))

declare -i err=0

declare -r tmp=$(mktemp)

for file in "$path"/examples/example{0..14}.txt
do
    echo "$file"
    declare expected=$(cat "${file%.*}.response.txt")

    :> "$tmp"
    ./run.sh "$file" "$tmp"
    declare output=$(cat "$tmp")

    if [[ "$output" == "$expected" ]]
    then
        echo -e "\n[OK]\n"
    else
        cat "$file"
        wdiff <(cat -A - <<<"$output") <(cat -A - <<<"$expected")
        echo -e "\n[FAIL]\n"
        ((err++))
    fi
done
rm "$tmp"

exit $err
