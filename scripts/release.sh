#!/bin/bash

cd ..
cp -r andromeda releases/
cd releases/andromeda
rev=$(git rev-parse --short HEAD)
sed "s/.*srev.*/    \"srev\": \"$rev\",/" ./package.json > tmp && mv tmp package.json
v=$(grep version ./package.json | sed "s/^.*\"version\":[ ]*\"\(.*\)\".*$/\1/")
cd ..
tar -cvzf andromeda-$v.tar.gz andromeda
rm -rf andromeda/
rm latest && ln -s andromeda-$v.tar.gz latest
# should be the same as v=$(git describe --abbrev=0)
