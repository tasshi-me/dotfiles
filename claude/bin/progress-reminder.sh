#!/bin/bash
# UserPromptSubmit / PostToolUse hook: 一定時間ユーザーへ報告せずに作業し続けるのを防ぐ。
# UserPromptSubmit でタイマーを起点に戻し、PostToolUse のたびに経過時間を見て、
# INTERVAL 秒を超えていたら「進捗を報告してから続けろ」という指示を Claude の文脈に差し込む。
# 指示を出した時点でタイマーを戻すので、報告は INTERVAL ごとに強制される。
set -eu

INTERVAL="${CLAUDE_PROGRESS_REMINDER_INTERVAL:-180}"
STATE_DIR="${HOME}/.cache/claude-progress-reminder"

input="$(cat)"
session_id="$(printf '%s' "$input" | jq -r '.session_id // empty')"
event="$(printf '%s' "$input" | jq -r '.hook_event_name // empty')"
[ -n "$session_id" ] || exit 0

mkdir -p "$STATE_DIR"
state="${STATE_DIR}/${session_id}"
now="$(date +%s)"

if [ "$event" = "UserPromptSubmit" ]; then
  printf '%s' "$now" > "$state"
  exit 0
fi

if [ ! -f "$state" ]; then
  printf '%s' "$now" > "$state"
  exit 0
fi

last="$(cat "$state")"
elapsed=$(( now - last ))
[ "$elapsed" -ge "$INTERVAL" ] || exit 0

printf '%s' "$now" > "$state"
minutes=$(( elapsed / 60 ))
jq -nc --arg ctx "ユーザーへの最後の報告から ${minutes} 分以上経過しています。次のツール呼び出しの前に、今どの工程にいて、次に何をするかを 1〜2 文でユーザーに書いてください。数分かかるコマンド（テスト・docker・lint）を実行する前は、必ずその旨を先に書いてください。" \
  '{hookSpecificOutput: {hookEventName: "PostToolUse", additionalContext: $ctx}}'
