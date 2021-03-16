#!/bin/bash

helpMsg="Usage: $0 [options]... files...\n\nOptions and arguments:\n  -e, --exec ex\
ecutable\t  Required argument unless --url is given. The\n\t\t\texecutable command u\
sed to run the moss upload\n\t\t\tprocess.\n  -f, --file file\t  If this argument is\
 provided, only find out the\n\t\t\tsimilarity between the target file and all the\n\
\t\t\tother files, rather than find out the similarity\n\t\t\tamong each pair of the\
 files.\n  -c, --component\t  If this argument is provided, the final output\n\t\t\t\
should be each plagiarism connected component,\n\t\t\tinstead of simply list the pla\
giarism files.\n  -t, --threshold value\t  The threshold value to determine whether \
a result\n\t\t\tfrom moss is truly plagiarism or not.\n\t\t\tThe value should be wit\
hin 0 to 100.\n  -u, --url url\t\t  If this argument is provided, the program will\n\
\t\t\ttest the plagiarism according to the result of\n\t\t\tthis url, and the --exec\
 arguments will be ignored.\n\t\t\tIf the given files do not match the result of\n\t\
\t\tthe given url, the behavior is undefined.\n  -h, --help\t\t  Display this help a\
nd exit.\n"

cmd=""
target=""
comp=0
thres=0
url=""
files=()

while [[ ${#@} -gt 0 ]]; do
    case $1 in
        "-h"|"--help")
            echo -ne "${helpMsg}"
            exit 1
        ;;
        "-e"|"--exec")
            shift
            cmd="$1"
            shift
        ;;
        "-f"|"--file")
            shift
            target="$1"
            shift
        ;;
        "-c"|"--component")
            shift
            comp=1
        ;;
        "-t"|"threshold")
            shift
            thres="$1"
            shift
        ;;
        "-u"|"--url")
            shift
            url="$1"
            shift
        ;;
        *)
            file_re1="^[a-zA-Z0-9_\/]+\.[a-zA-Z0-9_]+$|^\.{0,2}\/[a-zA-Z0-9_\/]+\.[a-z]+$"
            file_re2="^[a-zA-Z0-9_\/]+$|^\.{0,2}\/[a-zA-Z0-9_\/]+$"
            if [[ "$1" =~ $file_re1 || "$1" =~ $file_re2 ]]; then
                files+=("$1")
                shift
            else
                echo "Invalid argument ${1}. Try -h or –help for more help"
                exit 1
            fi
        ;;
    esac
done

# validity check 1
# exit if both cmd and url are empty
if [[ -z "$cmd" && -z "$url" ]]; then
    echo -ne "Require -e argument to provide an executable command, or -u argument\
 to provide a result url.\nTry -h or –help for more help.\n"
    exit 1
fi


# validity check 2
# exit if target doesn't exist or isn't a readable regular file
if [[ -n "$target" ]]; then
    if [[ ! -e "$target" ]]; then
        echo "Target file $target does not exist or is not a readable regular file."
        exit 1
    elif [[ ! -f "$target" || ! -r "$target" ]]; then
        echo "Target file $target does not exist or is not a readable regular file."
        exit 1
    fi
fi

# validity check 3
# exit if thres isn't a number or isn't within 0 to 100
num_re="^[0-9]+$"
if [[ "$thres" =~ $num_re ]]; then
    if [ ! $thres -le 100 ] || [ ! $thres -ge 0 ]; then
        echo "Threshold value should be an integer within 0 to 100."
        exit 1
    fi
else
    echo "Threshold value should be an integer within 0 to 100."
    exit 1
fi

# validity check 4
# exit if no files
if [[ ${#files[@]} -eq 0 ]]; then
    echo -ne "Require at least one file to be tested similarity.\nTry -h or –help for\
 more help.\n"
    exit 1
fi

# validity check 5
# exit if file in files is invalid
for filename in "${files[@]}"; do
    if [[ ! -e "$filename" ]]; then
        echo "File $filename does not exist or is not a readable regular file."
        exit 1
    elif [[ ! -f "$filename" || ! -r "$filename" ]]; then
        echo "File $filename does not exist or is not a readable regular file."
        exit 1
    fi
done

echo "cmd=${cmd}"
echo "target=${target}"
echo "comp=${comp}"
echo "thres=${thres}"
echo "url=${url}"
echo "files=(${files[@]})"
# echo -e ${helpMsg}