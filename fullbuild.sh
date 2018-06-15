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

echo "Packing for SK"
java -jar "$DIR/bootstrap-voodoo.jar" pack sk "$DIR/cotm.lock.json"
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
java -jar "$DIR/bootstrap-voodoo.jar" pack server "$DIR/cotm.lock.json"
if [ ! $? -eq 0 ]; then
    echo "Error in step: Pack Server"
    exit 1
fi

echo "Packing MMC Instance"
java -jar "$DIR/bootstrap-voodoo.jar" pack mmc "$DIR/cotm.lock.json"
if [ ! $? -eq 0 ]; then
    echo "Error in step: Pack MultiMC"
    exit 1
fi

echo "Packing Curse"
java -jar "$DIR/bootstrap-voodoo.jar" pack curse "$DIR/cotm.lock.json"
if [ ! $? -eq 0 ]; then
    echo "Error in step: Pack Curse"
    exit 1
fi

echo "Pulling past versions from git tags"

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

echo "Generating changelog from ${files[@]}"

java -jar "$DIR/bootstrap-voodoo.jar" tome changelog "${files[@]}" "$DIR/cotm.lock.json" 
if [ ! $? -eq 0 ]; then
    echo "Error in step: tome changelog"
    exit 1
fi