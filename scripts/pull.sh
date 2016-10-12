#!/bin/bash

cd ..
for d in andromeda doc jesc ndr.md; do 
    echo "pulling in $d"
    cd $d;
    git pull 
    cd ..;
done
