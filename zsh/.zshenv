
#          _
#  _______| |__   ___ _ ____   __
# |_  / __| '_ \ / _ \ '_ \ \ / /
#  / /\__ \ | | |  __/ | | \ V /
# /___|___/_| |_|\___|_| |_|\_/
#

# if ZDOTDIR is not set
if [ -z "$ZDOTDIR" ]; then
  export ZDOTDIR=${HOME}/.config/zsh
  source $ZDOTDIR/.zshenv
fi

#--------#
# Prezto #
#--------#
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/runcoms/zshenv" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/runcoms/zshenv"
fi
