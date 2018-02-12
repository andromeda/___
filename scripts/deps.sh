#!/bin/bash
# Set up dependencies on your local machine, *after* you have forked 
# repositories to your GitHub account; you *need* to provide your username!

# REQUIRED: replace nvasilakis with your GitHub username!
GH_USERNAME="nvasilakis"
# Optional: Replace http with git, if you have 
#           already added your SSH public key to GitHub.
CONN_TYPE=http


get_repos_http() {
  git clone https://github.com/"${GH_USERNAME}"/andromeda.git
  git clone https://github.com/"${GH_USERNAME}"/utils.git
  git clone https://github.com/"${GH_USERNAME}"/attn..git
  git clone https://github.com/"${GH_USERNAME}"/logger.git
  git clone https://github.com/"${GH_USERNAME}"/docs.git
}

get_repos_ssh() {
  git clone git@github.com:"${GH_USERNAME}"/andromeda.git
  git clone git@github.com:"${GH_USERNAME}"/utils.git
  git clone git@github.com:"${GH_USERNAME}"/attn..git
  git clone git@github.com:"${GH_USERNAME}"/logger.git
  git clone git@github.com:"${GH_USERNAME}"/docs.git
}

npm_global_setup() {
  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
  echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
  source ~/.profile
}

link_package() {
  # this needs to be done manually
  # DEPS=$(echo "attn./ doc/ logger/ utils/")
  echo "  [Fetching Development Packages]"
  cd logger/
  npm install --loglevel error > /dev/null
  cd ../andromeda/
  npm install --loglevel error > /dev/null
  echo "  [Linking Homegrown Packages]"
  cd ../logger/
  npm link --loglevel error ../utils > /dev/null
  npm link --loglevel error ../attn. > /dev/null
  cd ../andromeda/
  npm link --loglevel error ../utils > /dev/null
  npm link --loglevel error ../logger > /dev/null
  cd ..
}

# 1. Download repositories in the current directory
if [[ $CONN_TYPE == "http" ]]; then
  get_repos_http
else
  get_repos_ssh
fi
# 2. Fix NPM's global packages to play without sudo
npm_global_setup
source ~/.profile
# 3. Link all Andromeda-related packages
link_package

echo 'run `source ~/.profile` or restart your computer'

