#-------#
# shell #
#-------#
# editor
VISUAL=/usr/bin/vim
EDITOR=/usr/bin/vim

# XDG Base Directory
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"

# history
mkdir -p ${XDG_DATA_HOME}/zsh
export HISTFILE="${XDG_DATA_HOME}/zsh/history"

# handler
function command_not_found_handler(){
  echo -e "m9(^Д ^): $0" 1>&2
}
