#!/bin/bash
# parsing inputs
cmd=`echo "$1" | sed  's/\$$//g'`
shift
target=`echo "$1" | sed  's/\$$//g'`
shift
thres=$1
shift
url=`echo "$1" | sed  's/\$$//g'`
shift
files=()
while [[ -n "$@" ]]; do
    files+=("$1")
    shift
done

# check if target is provided
if [[ -n "$target" ]]; then
    target_provided='True'
else
    target_provided='False'
fi
# replace relative path with absolute path
if [[ "$target_provided" == 'True' ]]; then
    target="$(realpath "$target")"
fi
for((i=0;i<${#files[@]};i++)); do
    files[$i]="$(realpath "${files[$i]}")"
done
# check if all files are in the same directory
dir_name="$(dirname "${files[0]}")"
same_dir='True'
for i in ${files[@]}; do
    if [[ "$(dirname "$i")" != "$dir_name" ]]; then
        same_dir='False'
        break
    fi
done

# check if url is provided. if url isn't provided, use $cmd to get url
if [[ -z "$url" ]]; then
    output=`${cmd} ${target} ${files[@]}`
    prev_status="$?"
    if [[ "${prev_status}" != "0" ]]; then
        echo "Error when running ${cmd}."
        exit 1
    fi
    url=`echo -e "${output}" | tail -n 1`    
fi
echo "$url" >&2

# curl the page
result_page=`curl -s -L "$url"` # use -L to follow redirection
result_arr=()
while read -r line && [[ "$line" != '</TABLE>' ]]; do
    file1_re='^<TR><TD><A'
    file2_re='^ *<TD><A'
    lines_re='^<TD ALIGN=right>'
    if [[ "$line" =~ $file1_re ]]; then
        file1=`echo "$line" | sed 's/^.*<TD>.*">//g' | sed 's/ (.*$//g'`
        ratio1=`echo "$line" | sed 's/^.* (//g' | sed 's/%.*$//g'`
    elif [[ "$line" =~ $file2_re ]]; then
        file2=`echo "$line" | sed 's/^.*<TD>.*">//g' | sed 's/ (.*$//g'`
        ratio2=`echo "$line" | sed 's/^.* (//g' | sed 's/%.*$//g'`
    elif [[ "$line" =~ $lines_re ]]; then
        line_cnt=`echo "$line" | sed 's/^<TD ALIGN=right>//g'`
        # add data to array when read the line containing "lines matched"
        valid='True'
        # cheking validity - contains target
        if [[ "$target_provided" == 'True' ]]; then
            if [[ "$file1" != "$target" ]] && [[ "$file2" != "$target" ]]; then
                valid='False'
            fi
        fi
        # checking validity - pass threshold
        score=$(((7*${ratio1} + 7*${ratio2} + 3*${line_cnt})/20))
        if [[ $score -gt 100 ]]; then
            score=100
        fi
        if [[ $score -lt $thres ]]; then
            valid='False'
        fi
        # process & store data
        if [[ "$valid" == 'True' ]]; then
            # ordering data
            swapping='False'
            if [[ "$target_provided" == 'True' ]]; then
                if [[ "$file1" != "$target" ]]; then
                    swapping='True'
                fi
            else
                if [[ $ratio1 -lt $ratio2 ]]; then
                    swapping='True'
                elif [[ $ratio1 -eq $ratio2 ]]; then
                    if [[ "$file1" > "$file2" ]]; then
                        swapping='True'
                    fi
                fi
            fi
            if [[ "$swapping" == 'True' ]]; then
                tmp="$file1"; file1="$file2"; file2="$tmp"
                tmp="$ratio1"; ratio1="$ratio2"; ratio2="$tmp"
            fi
            # remove dir if all files are in the same dir
            if [[ "$same_dir" == 'True' ]]; then
                file1="$(basename "$file1")"
                file2="$(basename "$file2")"
            fi
            # remove file extension
            ext_re='\..*$'
            if [[ "$file1" =~ $ext_re ]]; then
                file1=`echo "$file1" | sed 's/\..*//g'`
            fi
            if [[ "$file2" =~ $ext_re ]]; then
                file2=`echo "$file2" | sed 's/\..*//g'`
            fi  
            # store data
            result_arr+=("$file1 $ratio1 $file2 $ratio2 $line_cnt $score")
        fi
    fi
done <<< "${result_page}"

# exit when no plagiarism
if [[ ${#result_arr[@]} -eq 0 ]]; then
    echo "No plagiarism found." >&2
    exit 255
fi

# sort data
# -score (6), -ratio1 (2), -ratio2 (4), -lines (5), file1 (1), file2 (3)
LC_ALL=C IFS=$'\n' result_arr=($(sort -k6,6nr -k2,2nr -k4,4nr -k5,5nr -k1,1 -k3,3 <<<"${result_arr[*]}"))
unset IFS LC_ALL

# print result
for((i=0; i<${#result_arr[@]}; i++)); do
    echo "${result_arr[$i]}"
done