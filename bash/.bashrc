
#  _               _
# | |__   __ _ ___| |__  _ __ ___
# | '_ \ / _` / __| '_ \| '__/ __|
# | |_) | (_| \__ \ | | | | | (__
# |_.__/ \__,_|___/_| |_|_|  \___|
#

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"

#---------#
# history #
#---------#
mkdir -p ${XDG_DATA_HOME}/bash
export HISTFILE="${XDG_DATA_HOME}/bash/history"

#----------------#
# import zshrc.d #
#----------------#
export ZSHRC_DIR="${XDG_CONFIG_HOME}/zsh/.zshrc.d"
if [[ -s "${ZSHRC_DIR}/10-environments.zsh" ]]; then
  source "${ZSHRC_DIR}/10-environments.zsh"
fi
if [[ -s "${ZSHRC_DIR}/40-proxies.zsh" ]]; then
  echo "${ZSHRC_DIR}/40-proxies.zsh"
  source "${ZSHRC_DIR}/40-proxies.zsh"
fi
