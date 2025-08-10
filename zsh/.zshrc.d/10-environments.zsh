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

#------#
# mise #
#------#
if [[ -s "${HOME}/.local/bin/mise" ]]; then
  eval "$("${HOME}"/.local/bin/mise activate zsh)"
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
