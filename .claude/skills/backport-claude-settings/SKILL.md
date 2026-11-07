---
name: backport-claude-settings
description: |
  Claude Code 設定の乖離を settings.base.json / settings.private.json に振り分けて解消する。
  使用タイミング: (1) settings-symlink-guard が「live Claude settings have drifted」警告を出した時,
  (2) 「backport して」「設定の乖離を直して」と言われた時,
  (3) Claude Code 上で変更した設定 (/config, /plugin) を dotfiles 管理に取り込みたい時。
---

# Claude 設定の backport

`~/.claude/settings.json`(実際に使われている設定)と、dotfiles 管理の
`settings.base.json` + `settings.private.json` のマージ結果との差分を解消する。

## 背景

- `claude/settings.json` は生成物(gitignore 済み)。`claude/link.sh`(`dot claude-link`) が
  `settings.base.json`(追跡・公開) と `settings.private.json`(untracked・私物) を
  `claude/bin/merge-settings.jq` でマージして生成し、`~/.claude/settings.json` から symlink される
- Claude Code が実行時に設定を書くと symlink が実体ファイル化し乖離が生まれる。
  symlink の修復は `claude/bin/settings-symlink-guard.sh` が自動で行うが、
  **差分の振り分けは手動(このスキルの仕事)**

## 手順

1. **差分を確認する**

   ```sh
   diff <(jq -S -s -f claude/bin/merge-settings.jq claude/settings.base.json claude/settings.private.json) \
        <(jq -S . claude/settings.json)
   ```

   `>` 側(claude/settings.json のみにある内容)が backport 対象。

2. **差分キーを分類する** — 迷ったら private(公開リポジトリに漏れない安全側)

   | 振り分け先 | 基準 | 例 |
   |---|---|---|
   | `settings.base.json` | 汎用設定。個人情報・社内情報・マシン固有パスを一切含まない | `model`, `theme`, `tui`, `autoUpdatesChannel` |
   | `settings.private.json` | 私物・社内・マシン固有 | 絶対パスを含む hooks、`enabledPlugins`、`extraKnownMarketplaces`(特に `kintone-private/*`) |

   **このリポジトリは PUBLIC。** base に入れた内容はそのまま公開される。
   社内リポジトリ名・`$HOME` 配下の絶対パス・メールアドレス等は必ず private へ。

3. **振り分け先のファイルを編集する**

4. **再マージして検証する**

   ```sh
   ./claude/link.sh                         # 再マージ + symlink 張り直し
   ./claude/bin/settings-symlink-guard.sh   # 何も出力されなければ乖離解消
   ```

5. **base を変更した場合はコミットする**
   - コミット前に、公開されて問題ない内容だけかをユーザーに diff で示して確認する

## 注意

- `settings.private.json` は untracked。git 操作(stash 等)に巻き込まれないが、
  バックアップも無いので上書き編集は慎重に
- マージ規則は `claude/bin/merge-settings.jq` に定義。基本は `jq` の `*`(再帰マージ、
  private 優先)だが、**`hooks.<Event>` の配列だけは base → private の順に連結**される
  (重複は除去)。private に hook を足すときは base の分を書き写さず、追加分だけ書く。
  hooks 以外の配列は `*` と同じく置換される
- `extraKnownMarketplaces` の差分は、プロジェクト単位でプラグインを入れた副作用であることが多い。
  Claude Code は `claude plugin marketplace add` や `--scope project` でのインストールでも、
  マーケットプレイス自体は**常にユーザー設定** `~/.claude/settings.json` に書き込む仕様
  ([docs](https://code.claude.com/docs/en/plugins/install.md))。
  動作上はプロジェクト設定だけで足りるが、消しても次の操作で書き戻されるので、
  そのまま private に取り込むのが楽。live 側から消えたエントリ(`<` 側)も private から削除して追従する
