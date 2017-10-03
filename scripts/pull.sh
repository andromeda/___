#!/bin/bash

# Pull from all remote branches
# (for these four projects)
for d in andromeda doc utils logger; do 
    echo "pulling in $d"
    cd $d;
    #git pull 
    git remote -v update
    cd ..;
done
