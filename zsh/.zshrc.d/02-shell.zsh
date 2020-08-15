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

# handler
function command_not_found_handler(){
  echo -e "m9(^Д ^)"
}
