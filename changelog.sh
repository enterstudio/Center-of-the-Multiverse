#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR
[ ! -e tome ] && mkdir tome

echo "pulling past versions from git tags"

mkdir -p ".history"

files=()

for crt_tag in $(git tag) 
do
    # if you want to suppress @... part
    # git tag ${crt_tag%@*} $crt_tag

    echo $crt_tag

    filename=".history/${crt_tag}.lock.json"
    files+=("$filename")

    git show ${crt_tag}:cotm.lock.json > $filename
done

mkdir -p tome

echo "generating changelog from ${files[@]}"

java -jar "$DIR/bootstrap-voodoo.jar" tome changelog "${files[@]}" "$DIR/cotm.lock.json" 
if [ ! $? -eq 0 ]; then
    echo "Error in step: tome changelog"
    exit 1
fi
