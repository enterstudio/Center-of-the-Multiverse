#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

echo "flattening"
java -jar "$DIR/bootstrap-voodoo.jar" flatten "$DIR/cotm.yaml" -o "$DIR/cotm.json"
if [ ! $? -eq 0 ]; then
    echo "Error in step: Flatten"
    exit 1
fi

echo "building"
java -jar "$DIR/bootstrap-voodoo.jar" build "$DIR/cotm.json" -o cotm.lock.json --force
if [ ! $? -eq 0 ]; then
    echo "Error in step: Build"
    exit 1
fi

./deploy_sk.sh
