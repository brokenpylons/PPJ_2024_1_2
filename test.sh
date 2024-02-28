#!/bin/bash
pwd

newline() {
    echo -e "\n"
}

declare -r path=$(dirname $(realpath "$0"))

declare -i err=0

for file in "$path"/examples/example{0..16}.txt
do
    echo "$file"
    declare expected=$(cat "${file%.*}.response.txt")

    declare output=$(./run.sh "$file" >(cat -) >/dev/null)

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

exit $err
