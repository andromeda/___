#!/bin/bash

echo $(pwd)
ANDROMEDA_DIR=${ANDROMEDA_DIR:-"../andromeda/"}
RELEASE=${RELEASE:-"release"}
cp -r $ANDROMEDA_DIR $RELEASE
cd $RELEASE
v=$(grep version ./package.json | sed "s/^.*\"version\":[ ]*\"\(.*\)\".*$/\1/")
rev=$(git rev-parse --short HEAD)
echo '{"revision": "' $rev '"}' > metadata.json
#sed "s/.*srev.*/    \"srev\": \"$rev\",/" ./package.json > tmp && mv tmp package.json
# should be almost the same as v=$(git describe --abbrev=0)
rm -rf .git .gitignore circle.yml .jshintrc
# FIXME: need to install packages
cd ..
tar -cvzf andromeda-$v.tar.gz release/
rm -rf release/
ln -s andromeda-$v.tar.gz latest
