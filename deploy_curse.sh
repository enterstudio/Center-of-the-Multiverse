#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

echo "packing curse"
java -jar "$DIR/bootstrap-voodoo.jar" pack "$DIR/cotm.lock.json" curse
if [ ! $? -eq 0 ]; then
    echo "Error in step: Pack Curse"
    exit 1
fi
