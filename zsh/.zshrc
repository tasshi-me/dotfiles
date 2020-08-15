
#          _
#  _______| |__  _ __ ___
# |_  / __| '_ \| '__/ __|
#  / /\__ \ | | | | | (__
# /___|___/_| |_|_|  \___|
#

#----------#
# .zshrc.d #
#----------#
for rcfile in "${ZDOTDIR:-$HOME}"/.zshrc.d/*.zsh; do
  # echo "load ${rcfile}"
  source ${rcfile}
done
