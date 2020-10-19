#----------------#
# basic commands #
#----------------#
# ls
alias la='ls -A'
alias lg='ls -Agh'
alias ll='ls -Ahl'
# force interactive
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# history
alias hist='history -E 10 | grep'
# enable alias in sudo
alias sudo='sudo '

#-----#
# zsh #
#-----#
# open zshrc with VISUAL editor
alias zshrc="${VISUAL} ${ZDOTDIR:-$HOME}/.zshrc"
# reload zshrc
alias sz="source ${ZDOTDIR:-$HOME}/.zshrc"

#--------#
# Prezto #
#--------#
# update Prezto
alias update-prezto=" \
pushd ${ZPREZTODIR} && \
git pull && \
git submodule update --init --recursive && \
popd"

#-----#
# git #
#-----#
DEFAULT_BRANCH=main
alias g=git
# git status
alias gs='git status -sb'
# git branch
alias gb='git branch'
alias gba='git branch -a'
# git switch
alias gsw='git switch'
# git fetch
alias gf='git fetch --prune'
# git pull
alias gp='git pull'
# git push
alias gpush='git push'
alias gforce='git push --force-with-lease'
# git diff
alias gd='git diff'
alias gdc='git diff --cached'
# git add
alias ga='git add'
alias gap='git add -p'
alias gaa='git add -A'
# git commit
alias gc='git commit'
alias gca='git commit --amend'
alias gcm='git commit -m'
alias gcn='git commit -n'
# git log
alias gl='git log --oneline'
# git reset
alias gr='git reset'
alias ghard='git reset --hard'
function gback(){
  command git reset --hard HEAD~$1
}
# git init
alias ginit=" \
git init && \
git checkout -b ${DEFAULT_BRANCH} && \
git commit --allow-empty -m 'initial commit'"

# gitui (https://github.com/extrawurst/gitui)
alias gui='gitui'

#--------#
# others #
#--------#
# xcode cli
alias xcode='open -a /Applications/Xcode.app'
# tree alias
alias tree='tree -L 5 --dirsfirst'
# medis
if [[ -e "${XDG_DATA_HOME}/medis/" ]]; then
  alias medis="pushd ${XDG_DATA_HOME}/medis;npm start;popd;"
fi
# wttr.in
alias wttr='curl wttr.in/Fukuoka'
alias wttr2='curl v2.wttr.in/Fukuoka'

# tar
alias reitou='tar -zcvf'
alias kaitou='tar -xvf'
