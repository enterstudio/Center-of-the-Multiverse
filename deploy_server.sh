#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

echo "packing server"
java -jar "$DIR/bootstrap-voodoo.jar" pack "$DIR/cotm.lock.json" server
if [ ! $? -eq 0 ]; then
    echo "Error in step: Pack Server"
    exit 1
fi

echo "please upload the server package to your minecraft server"
echo "make sure the minecraft server is stopped"
echo "run the server installer with the install location of your minecraft server"
echo "start the server"

