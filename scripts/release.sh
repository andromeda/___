#!/bin/bash

echo $(pwd)
cp -r andromeda/ releases/
cd releases/andromeda
git pull
rev=$(git rev-parse --short HEAD)
sed "s/.*srev.*/    \"srev\": \"$rev\",/" ./package.json > tmp && mv tmp package.json
# should be almost the same as v=$(git describe --abbrev=0)
v=$(grep version ./package.json | sed "s/^.*\"version\":[ ]*\"\(.*\)\".*$/\1/")
rm -rf .git .gitignore circle.yml 
cd ..
tar -cvzf andromeda-$v.tar.gz andromeda/
rm -rf andromeda/
rm latest 
ln -s andromeda-$v.tar.gz latest
