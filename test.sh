#!/bin/bash
pwd

newline() {
    echo -e "\n"
}

declare -r path=$(dirname $(realpath "$0"))

declare -i err=0

for file in "$path"/examples/example{0..10}.txt
do
    echo "$file"
    declare expected=$(cat "${file%.*}.response.txt")
    declare output=$(./run.sh "$file" /dev/stdout)

    if [[ "$output" == "$expected" ]]
    then
        echo -e "\n[OK]"
    else
        cat "$file"
        wdiff <(cat - <<<"$output") <(cat - <<<"$expected")
        echo -e "\n[FAIL]"
        ((err++))
    fi
done

exit $err
