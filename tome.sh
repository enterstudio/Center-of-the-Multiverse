#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR
[ ! -e tome ] && mkdir tome

echo "generating credits"
java -jar "$DIR/bootstrap-voodoo.jar" tome credits "$DIR/cotm.lock.json" "template/credits.md" --sort -o "$DIR/tome/credits.md"
if [ ! $? -eq 0 ]; then
    echo "Error in step: tome credits"
    exit 1
fi

java -jar "$DIR/bootstrap-voodoo.jar" tome credits "$DIR/cotm.lock.json" "template/modlist.csv" --sort -o "$DIR/tome/modlist.csv"
if [ ! $? -eq 0 ]; then
    echo "Error in step: tome modlist"
    exit 1
fi
