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

# homebrew
echo "--- Install Homebrew ---"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# brew bundle

# clone dotfiles repo
echo "--- Download dotfiles ---"
export DOTFILES_DIR=${HOME}/dotfiles
# git clone https://github.com/mshrtsr/dotfiles.git ${HOME}/dotfiles
cd ${DOTFILES_DIR}

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

# zprezto
echo "--- Install Prezto ---"
git submodule update --init --recursive

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

# Docker Desktop for Mac
# shell completion
# https://docs.docker.com/docker-for-mac/#zsh
echo "--- Create symbolic link of Docker shell completion ---"
DOCKER_APP_ETC=/Applications/Docker.app/Contents/Resources/etc
ZSH_SITE_FUNCTIONS=/usr/local/share/zsh/site-functions
rm -f ${ZSH_SITE_FUNCTIONS}/_docker ${ZSH_SITE_FUNCTIONS}/_docker-compose
ln -sn ${DOCKER_APP_ETC}/docker.zsh-completion ${ZSH_SITE_FUNCTIONS}/_docker
ln -sn ${DOCKER_APP_ETC}/docker-compose.zsh-completion ${ZSH_SITE_FUNCTIONS}/_docker-compose

echo "Done!!"
