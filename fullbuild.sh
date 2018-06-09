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
java -jar "$DIR/bootstrap-voodoo.jar" pack "$DIR/cotm.lock.json" sk
if [ ! $? -eq 0 ]; then
    echo "Error in step: Pack SK"
    exit 1
fi


echo "copying defaultioptions to serverside"
serverConfig="$DIR/src/config/_SERVER"
# do not delete the old server config for now, just overwrite all files
# rm -r $serverConfig
mkdir -p $serverConfig
cp -rf "$DIR/src/config/defaultoptions" $serverConfig
rm "$serverConfig/options.txt"
rm "$serverConfig/keybindings.txt"
rm "$serverConfig/servers.dat"

echo "Packing Server"
java -jar "$DIR/bootstrap-voodoo.jar" pack "$DIR/cotm.lock.json" server
if [ ! $? -eq 0 ]; then
    echo "Error in step: Pack Server"
    exit 1
fi

echo "Packing MMC Instance"
java -jar "$DIR/bootstrap-voodoo.jar" pack "$DIR/cotm.lock.json" mmc
if [ ! $? -eq 0 ]; then
    echo "Error in step: Pack MultiMC"
    exit 1
fi

echo "Packing Curse"
java -jar "$DIR/bootstrap-voodoo.jar" pack "$DIR/cotm.lock.json" curse
if [ ! $? -eq 0 ]; then
    echo "Error in step: Pack Curse"
    exit 1
fi