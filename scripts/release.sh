#!/bin/bash

echo $(pwd)
cd releases
git clone git@github.com:andromeda/andromeda.git
cd andromeda
rev=$(git rev-parse --short HEAD)
echo "rev: $rev"
sed "s/.*srev.*/    \"srev\": \"$rev\",/" ./package.json > tmp && mv tmp package.json
# should be almost the same as v=$(git describe --abbrev=0)
v=$(grep version ./package.json | sed "s/^.*\"version\":[ ]*\"\(.*\)\".*$/\1/")
rm -rf .git .gitignore circle.yml .jshintrc
cd ..
tar -cvzf andromeda-$v.tar.gz andromeda/
rm -rf andromeda/
rm latest 
ln -s andromeda-$v.tar.gz latest
