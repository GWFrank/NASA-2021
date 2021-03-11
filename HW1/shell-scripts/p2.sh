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
files=$@

cur_dir=`pwd`
cur_par_dir="$(dirname "$cur_dir")"

# check if url is provided. if url isn't provided, use $cmd to get url
if test -z "$url"; then
    output=`${cmd} ${files[@]}`
    prev_status="$?"
    if [[ "${prev_status}" != "0" ]]; then
        echo "Error when running ${cmd}."
        exit 1
    fi
    url=`echo -e "${output}" | tail -n 1`    
fi
echo "$url" &>2

# get the redirected url
redirect_page=`curl -s "$url"`
while read line; do
    url_re='http:\/\/'
    if [[ "$line" =~ $url_re ]]; then
        real_url=`echo "$line" | sed 's/.*href="//g' | sed 's/">.*//g'`
        break
    fi
done <<< "${redirect_page}"

# parse the result page
result_page=`curl -s "$real_url"`
file1_arr=()
ratio1_arr=()
file2_arr=()
ratio2_arr=()
lines_arr=()
score_arr=()
while read line && [[ "$line" != '</TABLE>' ]]; do
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
        score=$(((7*${ratio1} + 7*${ratio1} + 3*${line_cnt})/20))
        if [[ $score -gt 100 ]]; then # min(score, 100)
            $score=100
        fi
        if [[ $score -ge $thres ]]; then
            # remove file extension
            ext_re='\.[a-z]+$'
            if [[ "$file1" =~ $ext_re ]]; then
                file1=`echo "$file1" | sed 's/\.[a-z]+$//g'`
            fi
            if [[ "$file2" =~ $ext_re ]]; then
                file2=`echo "$file2" | sed 's/\.[a-z]+$//g'`
            fi
            file1_arr+=("$file1")
            ratio1_arr+=("$ratio1")
            file2_arr+=("$file2")
            ratio2_arr+=("$ratio2")
            lines_arr+=("$line_cnt")
            score_arr+=("$score")
        fi
    fi
done <<< "${result_page}"


for((i=0;i<${#files[@]};i++)); do
    echo "${file1_arr[$i]} ${ratio1_arr[$i]} ${file2_arr[$i]}\
 ${ratio2_arr[$i]} ${lines_arr[$i]} ${score_arr[$i]}"
done