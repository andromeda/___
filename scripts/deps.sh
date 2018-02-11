#!/bin/bash
# Set up dependencies on your local machine, *after* you have forked 
# repositories to your GitHub account; you *need* to provide your username!

# REQUIRED: replace nvasilakis with your GitHub username!
GH_USERNAME="nvasilakis"
# Optional: Replace http with git, if you have already added your key to GitHub.
CONN_TYPE=http


get_repos() {
  git clone https://github.com/"${GH_USERNAME}"/andromeda.git
  git clone https://github.com/"${GH_USERNAME}"/utils.git
  git clone https://github.com/"${GH_USERNAME}"/attn..git
  git clone https://github.com/"${GH_USERNAME}"/logger.git
  git clone https://github.com/"${GH_USERNAME}"/docs.git
}

npm_global_setup() {
  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
  echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
  source ~/.profile
  echo 'run `source ~/.profile`'
}

link_package() {
  # this needs to be done manually
  # DEPS=$(echo "attn./ doc/ logger/ utils/")
  out "  [Fetching Development Packages]\n"
  cd logger/
  npm install --loglevel error > /dev/null
  cd ../andromeda/
  npm install --loglevel error > /dev/null
  out "  [Linking Homegrown Packages]\n"
  cd ../logger/
  npm link --loglevel error ../utils > /dev/null
  npm link --loglevel error ../attn. > /dev/null
  cd ../andromeda/
  npm link --loglevel error ../utils > /dev/null
  npm link --loglevel error ../logger > /dev/null
  cd ..
}


