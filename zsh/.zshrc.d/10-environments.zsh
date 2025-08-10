#----------------#
# basic commands #
#----------------#
# disable less history
export LESSHISTFILE=-

#----------#
# homebrew #
#----------#
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
if [[ -s "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#-----------#
# JetBrains #
#-----------#
export PATH="${XDG_DATA_HOME}/JetBrains/bin:${PATH}"

#------#
# Rust #
#------#
export CARGO_HOME="${XDG_DATA_HOME}"/cargo
export CARGO="${CARGO_HOME}"/bin/cargo
export RUSTUP_HOME="${XDG_DATA_HOME}"/rustup
export PATH="${CARGO_HOME}/bin:${PATH}"

#----#
# Go #
#----#
export GOPATH="${HOME}/go"
export PATH="/usr/local/go/bin:${PATH}"
export GO111MODULE=auto

#------#
# Ruby #
#------#
if [[ -s "/opt/homebrew/bin/brew" ]]; then
  if [[ -s "$(brew --prefix)/opt/chruby/share/chruby/" ]]; then
    source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
    source $(brew --prefix)/opt/chruby/share/chruby/auto.sh
    chruby ruby-3.1.3
  fi
fi

#---------#
# Node.js #
#---------#
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node/node_repl_history
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

#---------#
# aws-cli #
#---------#
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config

#----------#
# OrbStack #
#----------#
if [[ -s "${HOME}/.orbstack/shell/init.zsh" ]]; then
  # Added by OrbStack: command-line tools and integration
  source ~/.orbstack/shell/init.zsh 2>/dev/null || :
fi

#----------#
#  gcloud  #
#----------#
# The next line updates PATH for the Google Cloud SDK.
if [ -f "${HOME}/google-cloud-sdk/path.zsh.inc" ]; then . "${HOME}/google-cloud-sdk/path.zsh.inc"; fi
# The next line enables shell command completion for gcloud.
if [ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]; then . "${HOME}/google-cloud-sdk/completion.zsh.inc"; fi

#--------#
# anyenv #
#--------#
# direnv
if [[ -s "/opt/homebrew/bin/direnv" ]]; then
  if [ -n "$ZSH_NAME" ]; then
    eval "$(direnv hook zsh)"
  fi
  if [ -n "$BASH" ]; then
    eval "$(direnv hook bash)"
  fi
fi
## rbenv
if [[ -s "${HOME}/.rbenv/bin/rbenv" ]]; then
  export PATH="${HOME}/.rbenv/bin:${PATH}"
  eval "$(rbenv init -)"
fi
## nodenv
if [[ -s "${HOME}/.nodenv/bin/nodenv" ]]; then
  export PATH="${HOME}/.nodenv/bin:${PATH}"
  eval "$(nodenv init -)"
fi
## pyenv
if [[ -e "${HOME}/.pyenv/bin/pyenv" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi
## tfenv
if [[ -e "${HOME}/.tfenv/bin/tfenv" ]]; then
  export TFENV_ROOT="$HOME/.tfenv"
  export PATH="$TFENV_ROOT/bin:$PATH"
fi

#---------#
# library #
#---------#
# mysql
#export PATH="/usr/local/opt/mysql@5.7/bin:${PATH}"
#export LDFLAGS="-L/usr/local/opt/mysql@5.7/lib"
#export CPPFLAGS="-I/usr/local/opt/mysql@5.7/include"
#export PKG_CONFIG_PATH="/usr/local/opt/mysql@5.7/lib/pkgconfig"
# mysql-client
#export PATH="/usr/local/opt/mysql-client/bin:${PATH}"
#export LDFLAGS="-L/usr/local/opt/mysql-client/lib"
#export CPPFLAGS="-I/usr/local/opt/mysql-client/include"
# openssl
#export PATH="/usr/local/opt/openssl@1.1/bin:${PATH}"
#export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
#export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
#export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
# sdl2
# export LIBRARY_PATH="${LIBRARY_PATH}:/usr/local/lib"
