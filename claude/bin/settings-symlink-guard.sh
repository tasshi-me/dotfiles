#!/bin/bash
# SessionStart hook: repair ~/.claude/settings.json when Claude Code has
# replaced the symlink with a regular file (this happens whenever settings
# are written at runtime, e.g. /config or /plugin), and warn when the live
# settings have drifted from settings.base.json + settings.private.json.
set -eu

DOTFILES_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
CLAUDE_DIR="${DOTFILES_DIR}/claude"
LIVE="${HOME}/.claude/settings.json"
GENERATED="${CLAUDE_DIR}/settings.json"
BASE="${CLAUDE_DIR}/settings.base.json"
PRIVATE="${CLAUDE_DIR}/settings.private.json"

[ -e "$LIVE" ] || exit 0

if [ ! -L "$LIVE" ]; then
  # The live file is the source of truth: adopt it as the generated file,
  # then restore the symlink. Idempotent and lossless.
  mv "$LIVE" "$GENERATED"
  ln -sn "$GENERATED" "$LIVE"
  echo "--- settings-symlink-guard ---"
  echo "WARNING: ~/.claude/settings.json had been replaced by a regular file"
  echo "(Claude Code rewrites settings on /config, /plugin, etc.)."
  echo "The symlink to dotfiles has been restored; no settings were lost."
fi

command -v jq >/dev/null 2>&1 || exit 0
[ -f "$BASE" ] || exit 0

if [ -f "$PRIVATE" ]; then
  merged="$(jq -s -S '.[0] * .[1]' "$BASE" "$PRIVATE")"
else
  merged="$(jq -S . "$BASE")"
fi

if ! drift="$(diff <(printf '%s\n' "$merged") <(jq -S . "$GENERATED"))"; then
  echo "--- settings-symlink-guard ---"
  echo "WARNING: live Claude settings have drifted from settings.base.json + settings.private.json."
  echo "Backport the differences below into ${CLAUDE_DIR}/settings.base.json (generic)"
  echo "or ${CLAUDE_DIR}/settings.private.json (machine-local/private), then run install.sh."
  echo "Until then, re-running install.sh would discard the right-hand side ('>') lines."
  echo "$drift"
fi
