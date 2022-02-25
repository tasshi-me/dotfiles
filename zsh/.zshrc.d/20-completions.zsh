#-------------#
# completions #
#-------------#
# homebrew
if type brew &>/dev/null; then
  fpath=($(brew --prefix)/share/zsh/site-functions ${fpath})
fi
# zsh-completions
if [[ -e "$(brew --prefix)/share/zsh-completions" ]]; then
  fpath=($(brew --prefix)/share/zsh-completions ${fpath})
fi
# ${HOME}/.zsh/completion
if [[ -e "${ZDOTDIR:-$HOME}/completion" ]]; then
  fpath=(${ZDOTDIR:-$HOME}/completion ${fpath})
fi
# load completions
autoload -Uz compinit && compinit
# Docker
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
