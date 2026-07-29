# CLAUDE.md — 11. モジュール化と拡張

TaskJuggler 学習用プレイグラウンドの **第 11 段階 (ファイル分割・マクロ・独自属性)**。

## 前提

- 対象は TaskJuggler 3.8.4 (Ruby 4.0 上で bundler 管理)
- `tj3` は bundler 経由でのみ使える。必ず `bundle exec tj3` で呼ぶ
- **コマンドはすべてリポジトリルート (このディレクトリの1つ上) から実行する**

## ファイル構成 (この分割自体が教材)

| ファイル | 役割 |
|---|---|
| `main.tjp` | プロジェクトヘッダ (`extend` を含む) とレポート定義 |
| `macros.tji` | マクロ定義 |
| `resources.tji` | リソース定義 |
| `tasks.tji` | タスク定義 (計画) |
| `subtasks.tji` | `taskprefix phase2` で流し込まれる断片 |
| `actuals.tji` | 実績データ (`supplement`) |
| `out/` | 生成物。再生成できるので消してよい |

**エントリポイントは `main.tjp`。** `.tji` を単体で tj3 に渡しても動かない。

## 実行

```sh
bundle exec tj3 -o 11-modular/out 11-modular/main.tjp
```

## 結果の確認方法

```sh
ruby tools/dump-report.rb 11-modular/out/01-plan.html
```

## この段階で扱うキーワード

`include.properties` `include.project` `include.macro` `macro` `supplement.task`
`supplement.resource` `extend` `text.extend` `number.extend` `date.extend`
`reference.extend` `richtext.extend` `taskprefix` `resourceprefix` `accountprefix`
`projectid` `projectids` `auxdir` `tagfile`

構文は推測せず `bundle exec tj3man <キーワード>` で確認する。

## 既知の落とし穴 (すべて実測で確認済み)

- **`include` はタスク定義の中には書けない** (`Unexpected token 'include'`)。
  入れ子タスクを別ファイルにするなら、空のコンテナを先に定義し、
  `taskprefix` 付きでトップレベルから include する
- 取り込むファイルは **`.tji` 拡張子必須**
- パスは**include を書いたファイルからの相対**。実行時の CWD ではない
- **`macro` の閉じ括弧 `]` は行の最後の文字**。後ろに空白やコメントがあると閉じない
- マクロ引数は必ずダブルクォートで囲む。ユーザー定義マクロ ID は大文字始まり
- 読み込み順が重要 (マクロ定義 → 使用、タスク定義 → `supplement`)
- `supplement` に渡すのはルートからの絶対 ID
- `extend` は `project {}` の中に書く

## 作業方針

- tjp/tji を変更したら必ず `main.tjp` を実行し、結果を確認してから回答する
- ファイルを追加する提案では、**どこに include を書くか**と
  **読み込み順**を明示する
- マクロを書いたら必ず実行して展開を確認する
  (閉じ括弧の位置のミスは分かりにくいエラーになる)
- 実績データを扱う話題では、`supplement` で分離する方針を優先して提案する
  (計画ファイルを直接書き換えない)
