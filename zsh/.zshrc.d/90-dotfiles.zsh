#----------#
# dotfiles #
#----------#
# `dot` — dotfiles operations from anywhere.
# Subcommands other than the ones below fall through to git,
# so e.g. `dot status` / `dot push` / `dot log` just work.
function dot() {
  local dir="${DOTFILES_DIR:-$HOME/dotfiles}"
  case "${1:-help}" in
    cd)
      cd "${dir}"
      ;;
    install)
      ( cd "${dir}" && ./install.sh )
      ;;
    help|-h|--help)
      print -r -- "usage: dot <subcommand>

subcommands:
  cd          cd into the dotfiles repo
  install     run install.sh (re-link configs, re-merge claude settings)
  help        show this help
  <git args>  anything else runs git against the repo
              (e.g. dot status, dot push, dot log --oneline)"
      ;;
    *)
      command git -C "${dir}" "$@"
      ;;
  esac
}

# Warn at shell startup when the dotfiles repo has drifted:
# uncommitted changes, unpushed commits, or commits behind origin.
# Local-only checks (no fetch); "behind" reflects the last fetch.
() {
  local dir="${DOTFILES_DIR:-$HOME/dotfiles}"
  [[ -d "${dir}/.git" ]] || return 0

  local -a dirty
  dirty=("${(@f)$(command git -C "${dir}" status --porcelain 2>/dev/null)}")
  dirty=(${dirty:#})
  (( ${#dirty} > 0 )) && print -P "%F{yellow}⚠ dotfiles: ${#dirty} uncommitted change(s)%f\n  check: dot status"

  local -a counts
  counts=(${=$(command git -C "${dir}" rev-list --left-right --count 'HEAD...@{upstream}' 2>/dev/null)})
  (( ${#counts} == 2 )) || return 0
  (( counts[1] > 0 )) && print -P "%F{yellow}⚠ dotfiles: ${counts[1]} commit(s) not pushed%f\n  run: dot push"
  (( counts[2] > 0 )) && print -P "%F{yellow}⚠ dotfiles: ${counts[2]} commit(s) behind origin%f\n  run: dot pull"

  # Claude settings: repair a broken ~/.claude/settings.json symlink and
  # warn when live settings are not backported to base/private.
  local guard="${dir}/claude/bin/settings-symlink-guard.sh"
  [[ -x "${guard}" ]] && "${guard}"
  return 0
}
