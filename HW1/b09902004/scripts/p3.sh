#!/bin/bash

function hasElement {
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

# get all files
files=()
if [[ "${target_provided}" == 'True' ]]; then
    t=`echo "${prev_result[0]}" | cut -d ' ' -f 1`
    for r in "${prev_result[@]}"; do
        f=`echo "$r" | cut -d ' ' -f 3`
        if [[ $(hasElement "$f" "${files[@]}") == 'False' ]]; then
            files+=("$f")
        fi
    done
    LC_ALL=C IFS=$'\n' files=($(sort <<<"${files[*]}"))
    unset IFS LC_ALL
    files=("$t" "${files[@]}")
else
    for r in "${prev_result[@]}"; do
        f1=`echo "$r" | cut -d ' ' -f 1`
        f2=`echo "$r" | cut -d ' ' -f 3`
        if [[ $(hasElement "$f1" "${files[@]}") == 'False' ]]; then
            files+=("$f1")
        fi
        if [[ $(hasElement "$f2" "${files[@]}") == 'False' ]]; then
            files+=("$f2")
        fi
    done
    LC_ALL=C IFS=$'\n' files=($(sort <<<"${files[*]}"))
    unset IFS LC_ALL
fi

if [[ $comp -eq 0 ]]; then
    # case comp = 0
    echo "${files[@]}"
else
    # case comp = 1
    if [[ "${target_provided}" == 'True' ]]; then
        echo "${files[@]}"
    else
        # build forward star
        edges=()
        for r in "${prev_result[@]}"; do
            f1=`echo "$r" | cut -d ' ' -f 1`
            f2=`echo "$r" | cut -d ' ' -f 3`
            edges+=("${f1} ${f2}")
            edges+=("${f2} ${f1}")
        done
        
        LC_ALL=C IFS=$'\n' edges=($(sort -k1,1 -k2,2 <<<"${edges[*]}"))
        unset IFS LC_ALL

        declare -A right=()
        declare -A left=()
        edges_len=${#edges[@]}
        for((i=0;i<edges_len;)); do
            j=$(( $i + 1 ))
            cur=$(echo "${edges[$i]}" | cut -d ' ' -f 1)
            while [[ $j -lt ${edges_len} 
                  && $(echo "${edges[$j]}" | cut -d ' ' -f 1) == "$cur" ]]; do
                j=$(( $j + 1 ))
            done
            left["$cur"]=$i
            right["$cur"]=$j
            i=$j
        done
        for((i=0;i<edges_len;i++)); do
            edges[$i]=$(echo "${edges[$i]}" | cut -d ' ' -f 2)
        done
        # done forward star
        # checkpoint
        for file in "${files[@]}"; do
            l="${left[$file]}"
            r="${right[$file]}"
            echo -n "$file:" >&2
            for((i=l;i<r;i++)); do
                echo -n " ${edges[$i]}" >&2
            done
            echo '' >&2
        done
        # done checkpoint
        # DFS
        declare -A visit=()
        component=() # array of strings
        size=()
        function DFS {
            local cur="$1"
            local id="$2"
            component["$id"]+="${cur} "
            visit["$cur"]="$id"
            local l="${left[$cur]}"
            local r="${right[$cur]}"
            local sz=1
            local i=0
            for((i=l;i<r;i++)); do
                local nxt="${edges[$i]}"
                if [[ $(hasElement "$nxt" "${!visit[@]}") == 'False' ]]; then
                    DFS "$nxt" "$id"
                    sz=$(( ${sz} + $? ))
                fi
            done
            return "$sz"
        }
        id=0
        for file in "${files[@]}"; do
            if [[ $(hasElement "$file" "${!visit[@]}") == 'False' ]]; then
                component+=("")
                DFS "$file" "$id"
                size+=($?)
                component[$id]=$(echo ${component[$id]} | sed 's/ *$//g') # get rid of trailing spaces
                component[$id]=$(echo ${component[$id]} | sed 's/ /\n/g') # prepare for sorting
                sorted_comp=($(sort <<<"${component[$id]}"))
                component[$id]="${sorted_comp[@]}"
                id=$(( $id + 1 ))
            fi
        done
        # exit 69
        # done DFS
        # output
        for((i=0;i<id;i++)); do
            echo "${size[$i]}: ${component[$i]}"
        done
    fi
fi