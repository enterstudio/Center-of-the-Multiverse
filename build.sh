#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

echo "flattening"
java -jar "$DIR/voodoo-2.0.0.jar" flatten "$DIR/cotm.yaml" && \
echo "building" && \
java -jar "$DIR/voodoo-2.0.0.jar" build "$DIR/cotm.json" --save -o cotm.lock.json --force && \
echo "packing" && \
java -jar "$DIR/voodoo-2.0.0.jar" pack "$DIR/cotm.lock.json" sk
