#-----------------#
# dotfiles status #
#-----------------#
# Warn at shell startup when the dotfiles repo has drifted:
# uncommitted changes, unpushed commits, or commits behind origin.
# Local-only checks (no fetch); "behind" reflects the last fetch.
() {
  local dir="${DOTFILES_DIR:-$HOME/dotfiles}"
  [[ -d "${dir}/.git" ]] || return 0
  local g="git -C ${dir/#$HOME/~}"

  local -a dirty
  dirty=("${(@f)$(command git -C "${dir}" status --porcelain 2>/dev/null)}")
  dirty=(${dirty:#})
  (( ${#dirty} > 0 )) && print -P "%F{yellow}⚠ dotfiles: ${#dirty} uncommitted change(s)%f\n  check: ${g} status"

  local -a counts
  counts=(${=$(command git -C "${dir}" rev-list --left-right --count 'HEAD...@{upstream}' 2>/dev/null)})
  (( ${#counts} == 2 )) || return 0
  (( counts[1] > 0 )) && print -P "%F{yellow}⚠ dotfiles: ${counts[1]} commit(s) not pushed%f\n  run: ${g} push"
  (( counts[2] > 0 )) && print -P "%F{yellow}⚠ dotfiles: ${counts[2]} commit(s) behind origin%f\n  run: ${g} pull"
  return 0
}
