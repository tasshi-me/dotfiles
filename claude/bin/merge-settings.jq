# Merge Claude Code settings: base (.[0], tracked) + private (.[1], untracked).
# Usage: jq -s -f merge-settings.jq settings.base.json [settings.private.json]
#
# - Objects merge recursively; private wins on scalar conflicts (same as `*`).
# - Exception: arrays under .hooks.<Event> are concatenated (base first, then
#   private, duplicates dropped) so private can add hooks for an event without
#   restating the hooks already defined in base.
# - Any other array is replaced by the private value, as with `*`.

def dedup: reduce .[] as $x ([]; if any(.[]; . == $x) then . else . + [$x] end);

def merge_hooks($a; $b):
  reduce (($a | keys) + ($b | keys) | unique[]) as $k ({};
    .[$k] = ((($a[$k] // []) + ($b[$k] // [])) | dedup));

.[0] as $base
| (.[1] // {}) as $priv
| ($base * $priv)
| if ($base.hooks // $priv.hooks) != null
  then .hooks = merge_hooks($base.hooks // {}; $priv.hooks // {})
  else . end
