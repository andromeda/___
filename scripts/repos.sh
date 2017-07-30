#!/bin/bash
# Pulls repositories as needed (either everything or a single repo)
#
# This script can be called both ways:
# * If in the andromeda top level repo, just sets up submodules
# * If used standalone (or via wget), first clones top level repo
#
# Subprojects might have different dependencies -- see the docs

# GitHub allows HTTP, but would then need to check for curl/wget 
# and recursively fetch all the repositories, some of which might
# be private. Easiest way to resolve.
GIT_ERROR="You need git to get the repositories. Exiting..";

command -v "git" >/dev/null 2>&1 || { echo "$GIT_ERROR"; }

SINGLE_REPO=false
REPO_NAME=""
M31_INFO="    Apparent mass: ~1,230 billion M☉\n    Age: 9 billion years\n    Magnitude: 3.44\n    Constellation: Andromeda\n    Stars: 1 trillion"
SURL="https://raw.githubusercontent.com/andromeda/___/master/scripts/splash.sh"
# SPLASH="$(curl $SURL)"

##
# First argument (optional) is a severity:
# 1 (grey -- default), 2 (white), 3 (purple), 4 (yellow), 5 (red)
# rest of arguments are text
##
out() {
  local _severity="0"

  if [[ $1 == "2" ]]; then
    _severity="7"
    shift
  fi
  if [[ $1 == "3" ]]; then
    _severity="5"
    shift
  fi
  if [[ $1 == "4" ]]; then
    _severity="3"
    shift
  fi
  if [[ $1 == "5" ]]; then
    _severity="1"
    shift
  fi

  while (( "$#" )); do
    echo -e "$(tput bold ; tput setaf $_severity)$1$(tput sgr0)" | 
      sed "s/andromeda/$(tput sgr0)$(tput setaf 7)andromeda$(tput bold ; tput setaf 8)/" 
    shift
  done
}

##
# Output the first argument, if previous command run OK
##
try() {
  if [ $? != 0 ]; then out "$1"; fi
}

##
# Replace the beginning of the string
##
istart() {
  sed "s/^/$(tput bold ; tput setaf 8)    /" | sed s/Submodule/Subuniverse/
}

##
# Replace the end of the string
##
iend() {
  sed "s/$/$(tput sgr0)/"
}


usage() {
  echo "
  Usage: ./$(basename $0)

  Fetches Andromeda repos and sets up environment

  Options
  =======
  -r <repo>:          Fetch  a specific repository.
  -h:                 This help message

  "
}


##
# Generate submodules
##
generate-submodules() {
  out "\n  [Initializing Submodules]\n"
  git submodule init 2>&1 | istart | iend
  out "\n  [Updating Submodules]\n"
  { sleep 1 && out "    ..hang tight!" &}
  git submodule update 2>&1 | istart | iend
  for d in */ ; do 
    cd $d;
    git checkout master 2>&1 | istart | iend 
    git pull 2>&1 | istart | iend 
    cd ..;
  done
  out "\n  [Time is now $(date) +2,538,000 light years..]\n"
}

##
# A simple test
##
cell() {
  out one
}

##
# Add aliases to .*shrc's
##
patch-shell-config() {
  out "  [Patching .*rc]\n"
  echo "  You can add the following shortcuts to your shell startup file"
  # Andromeda
  out "    androdev=$(pwd)"
  out "    andromeda=$(pwd)/andromeda"
  out "    alias andromeda='node $(pwd)/andromeda/andromeda.js'"
  #for file in .*shrc; do
  #  echo "m31=$(pwd)" >> $file
  #  echo 'alias m31=$m31/m31/src/shell.js' >> $file
  #done
}

##
# Unfortunately, npm v3, v4, and v5 have a problem with the `link` command.
# As a result, we have to keep truck of local dependencies ourselves.
##
link-package() {
  # this needs to be done manually
  # DEPS=$(echo "attn./ doc/ logger/ utils/")
  out "  [Linking Packages]\n"
  cd logger/
  npm --quiet install
  npm link ../utils
  npm link ../attn.
  cd ../andromeda/
  npm --quiet install
  npm link ../utils
  npm link ../logger
}


prelude() {
  clear
  out "$SPLASH"
}

# Check which argument we have
while getopts "r:h" opt; do
  case $opt in
    r) 
      out "Repository picked: ${OPTARG}"
      SINGLE_REPO=true;
      REPO_NAME="${OPTARG}";
      ;;
    h) 
      usage;
      exit 0;
      ;;
    \?)
      out "There are no arguments -- that's OK"
      exit 1;
      ;;
    :)
      out "Need extra argument for ${OPTARG}. -h brings up help."
      exit 1;
      ;;
  esac
done

if [[ -e "./.git" ]]; then
  # we are in git, invoke locally
  generate-submodules
  link-package
else
  # clone repository
  if [[ $SINGLE_REPO == 'true' ]]; then
    out "\n  [Cloning ${REPO_NAME}]\n"
    git clone git@github.com:andromeda/${REPO_NAME}.git 2>&1 | grep -v clon
  else
    out "  [Cloning Universe]\n"
    git clone git@github.com:andromeda/universe.git > /dev/null 2>&1
    cd universe
    generate-submodules
    patch-shell-config
    link-package
  fi
fi
