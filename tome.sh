#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR
[ ! -e tome ] && mkdir tome

echo "Generating credits"
java -jar "$DIR/bootstrap-voodoo.jar" tome credits "template/credits.md" "$DIR/cotm.lock.json" --sort -o "$DIR/tome/credits.md"
if [ ! $? -eq 0 ]; then
    echo "Error in step: tome credits"
    exit 1
fi

java -jar "$DIR/bootstrap-voodoo.jar" tome credits "template/modlist.csv" "$DIR/cotm.lock.json" --sort -o "$DIR/tome/modlist.csv"
if [ ! $? -eq 0 ]; then
    echo "Error in step: tome modlist"
    exit 1
fi
