#!/bin/zsh
set -eo pipefail

echo "Install dotfiles..."

# XDG Base Directory
echo "--- Set XDG Base Directory ---"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
mkdir -p ${XDG_CONFIG_HOME} ${XDG_CACHE_HOME} ${XDG_DATA_HOME}
echo "XDG_CONFIG_HOME: ${XDG_CONFIG_HOME}"
echo "XDG_CACHE_HOME: ${XDG_CACHE_HOME}"
echo "XDG_DATA_HOME: ${XDG_DATA_HOME}"

# clone dotfiles repo
echo "--- Clone dotfiles repository ---"
export DOTFILES_DIR=${HOME}/dotfiles
if [[ ! -d "${DOTFILES_DIR}/.git" ]]; then
  mkdir -p ${DOTFILES_DIR}
  git clone https://github.com/tasshi-me/dotfiles.git ${DOTFILES_DIR}
fi
cd ${DOTFILES_DIR}
git pull
git submodule update --init --recursive

# bash
echo "--- Create symbolic link of bash configuration ---"
rm -f ${HOME}/.bashrc ${HOME}/.profile
ln -sn ${DOTFILES_DIR}/bash/.bashrc ${HOME}
ln -sn ${DOTFILES_DIR}/bash/.profile ${HOME}

# zsh
echo "--- Create symbolic link of zsh configuration ---"
rm -f ${XDG_CONFIG_HOME}/zsh ${HOME}/.zshenv
ln -sn ${DOTFILES_DIR}/zsh ${XDG_CONFIG_HOME}/zsh
ln -sn ${DOTFILES_DIR}/zsh/.zshenv ${HOME}/.zshenv

# change default shell to zsh
# NOTE: The default interactive shell is now zsh
# echo "Change default shell to zsh"
# chsh -s /bin/zsh

# git
echo "--- Create symbolic link of git configuration ---"
rm -f ${XDG_CONFIG_HOME}/git
ln -sn ${DOTFILES_DIR}/git ${XDG_CONFIG_HOME}/git

# Karabiner-Elements
echo "--- Create symbolic link of Karabiner-Elements configuration ---"
rm -f ${XDG_CONFIG_HOME}/karabiner
ln -sn ${DOTFILES_DIR}/karabiner ${XDG_CONFIG_HOME}/karabiner

# macOS　only
if type "defaults" > /dev/null 2>&1; then
  # set screen capture filename
  echo "--- Set screen capture filename ---"
  defaults write com.apple.screencapture name "Screen Shot"

  # show all files
  echo "--- Set show all files on Finder ---"
  defaults write com.apple.finder AppleShowAllFiles -bool true
  echo "--- Restart Finder ---"
  killall Finder

  # homebrew
  echo "--- Install Homebrew ---"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  echo "--- Install Apps with Homebrew ---"
  brew bundle
fi

# nodenv
# https://github.com/nodenv/nodenv
echo "--- Install nodenv ---"
rm -rf ${HOME}/.nodenv
git clone https://github.com/nodenv/nodenv.git ${HOME}/.nodenv
cd ${HOME}/.nodenv && src/configure && make -C src
export PATH="${HOME}/.nodenv/bin:${PATH}"
eval "$(nodenv init -)"

mkdir -p "$(nodenv root)"/plugins
# https://github.com/nodenv/nodenv-update
git clone https://github.com/nodenv/nodenv-update.git "$(nodenv root)"/plugins/nodenv-update
nodenv update

# https://github.com/nodenv/node-build
git clone https://github.com/nodenv/node-build.git "$(nodenv root)"/plugins/node-build

NODE_VERSION=16.14.0
nodenv install ${NODE_VERSION}
nodenv rehash
nodenv global ${NODE_VERSION}

# https://github.com/nodenv/node-build-update-defs
git clone https://github.com/nodenv/node-build-update-defs.git "$(nodenv root)"/plugins/node-build-update-defs
# node-build-update-defs depends on node
nodenv update-version-defs

# rust
# https://www.rust-lang.org/ja/learn/get-started
echo "--- Install Rust ---"
export CARGO_HOME="${XDG_DATA_HOME}"/cargo
export CARGO="${CARGO_HOME}"/bin/cargo
export RUSTUP_HOME="${XDG_DATA_HOME}"/rustup
export PATH="${CARGO_HOME}/bin:${PATH}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# If you get some trouble with rust-analyzer, enable these links
# rm -f ${HOME}/.cargo ${HOME}/.rustup
# ln -sn ${CARGO_HOME} ${HOME}/.cargo
# ln -sn ${RUSTUP_HOME} ${HOME}/.rustup

# macOS　only
if type "defaults" > /dev/null 2>&1; then
  # zsh-completions
  echo "--- Initialize zsh-completions ---"
  chmod 755 $(brew --prefix)/share
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit

  # Docker Desktop for Mac
  # shell completion
  # https://docs.docker.com/docker-for-mac/#zsh
  echo "--- Create symbolic link of Docker shell completion ---"
  DOCKER_APP_ETC=/Applications/Docker.app/Contents/Resources/etc
  ZSH_SITE_FUNCTIONS=$(brew --prefix)/share/zsh/site-functions
  rm -f ${ZSH_SITE_FUNCTIONS}/_docker ${ZSH_SITE_FUNCTIONS}/_docker-compose
  ln -sn ${DOCKER_APP_ETC}/docker.zsh-completion ${ZSH_SITE_FUNCTIONS}/_docker
  ln -sn ${DOCKER_APP_ETC}/docker-compose.zsh-completion ${ZSH_SITE_FUNCTIONS}/_docker-compose
fi

echo "Done!!"
