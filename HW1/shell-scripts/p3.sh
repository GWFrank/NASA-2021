#!/bin/bash

function hasElement(){
    local element="$1"
    shift
    local arr=("$@")
    local found='False'
    for e in ${arr[@]}; do
        if [[ "$element" == "$e" ]]; then
            found='True'
            break
        fi
    done
    echo "$found"
}

# parse input
target=`echo "$1" | sed  's/\$$//g'`
shift
comp="$1"
# check if target is provided
if [[ -n "$target" ]]; then
    target_provided='True'
else
    target_provided='False'
fi
# read from provided file
prev_result=()
while read line; do
    # result format : $file1 $ratio1 $file2 $ratio2 $line_cnt $score
    prev_result+=("$line")
done

if [[ $comp -eq 0 ]]; then
    # case comp = 0
    files=()
    if [[ "${target_provided}" == 'True' ]]; then
        t=`echo "${prev_result[0]}" | cut -d ' ' -f 1`
        files+=("$t")
        for r in "${prev_result[@]}"; do
            f=`echo "$r" | cut -d ' ' -f 3`
            if [[ $(hasElement "$f" "${files[@]}") == 'False' ]]; then
                files+=("$f")
            fi
        done
        echo "${files[@]}"
    else
        for r in "${prev_result[@]}"; do
            f1=`echo "$r" | cut -d ' ' -f 1`
            f2=`echo "$r" | cut -d ' ' -f 3`
            echo "$f1 $f2 | ${files[@]}"
            if [[ $(hasElement "$f1" "${files[@]}") == 'False' ]]; then
                files+=("$f1")
            fi
            if [[ $(hasElement "$f2" "${files[@]}") == 'False' ]]; then
                files+=("$f2")
            fi
        done
        echo "${files[@]}"
    fi
else
    # case comp = 1
    
fi