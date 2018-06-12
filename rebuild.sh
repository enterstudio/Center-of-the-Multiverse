#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

echo "Flattening .yaml"
java -jar "$DIR/bootstrap-voodoo.jar" flatten "$DIR/cotm.yaml" -o "$DIR/cotm.json"
if [ ! $? -eq 0 ]; then
    echo "Error in step: Flatten"
    exit 1
fi

echo "Building Modpack"
java -jar "$DIR/bootstrap-voodoo.jar" build "$DIR/cotm.json" -o cotm.lock.json --force
if [ ! $? -eq 0 ]; then
    echo "Error in step: Build"
    exit 1
fi

echo "Packing for SK"
java -jar "$DIR/bootstrap-voodoo.jar" pack sk "$DIR/cotm.lock.json"
if [ ! $? -eq 0 ]; then
    echo "Error in step: Pack SK"
    exit 1
fi

echo "Packing Server"
java -jar "$DIR/bootstrap-voodoo.jar" pack server "$DIR/cotm.lock.json"
if [ ! $? -eq 0 ]; then
    echo "Error in step: Pack Server"
    exit 1
fi