# CLAUDE.md — 10. コスト

TaskJuggler 学習用プレイグラウンドの **第 10 段階 (コストと収支)**。

## 前提

- 対象は TaskJuggler 3.8.4 (Ruby 4.0 上で bundler 管理)
- `tj3` は bundler 経由でのみ使える。必ず `bundle exec tj3` で呼ぶ
- **コマンドはすべてリポジトリルート (このディレクトリの1つ上) から実行する**

## ファイル

| ファイル | 内容 |
|---|---|
| `cost.tjp` | 教材本体。解説はコメントとして書いてある |
| `README.md` | 学習内容の説明 |
| `out/` | 生成物。再生成できるので消してよい |

## 実行

```sh
bundle exec tj3 -o 10-cost/out 10-cost/cost.tjp
```

## 結果の確認方法

```sh
ruby tools/dump-report.rb 10-cost/out/01-balance.html
ruby tools/dump-report.rb 10-cost/out/02-task-cost.html
```

## この段階で扱うキーワード

`account` `aggregate` `accountreport` `rate.resource` `chargeset` `charge`
`balance` `credits` `startcredit` `endcredit` `currency` `currencyformat`
`flags.account` `hideaccount` `rollupaccount` `sortaccounts`

構文は推測せず `bundle exec tj3man <キーワード>` で確認する。

## 現在の結果 (実測)

- 費用 1,971,429 (人件費 1,000,000 / 外注費 500,000 / 諸経費 471,429)
- 収益 8,000,000
- 収支 6,028,571
- タスク別: 設計 250,000 / 実装 1,250,000 / 納品・検収 収益 8,000,000

## 既知の落とし穴 (すべて実測で確認済み)

- **`aggregate` の指定が要**。`account` は「何に由来する金額を集めるか」を宣言する
  - `tasks` (既定) — タスクの `chargeset` 経由
  - `resources` — リソースの `chargeset` 経由
  - リソースの `chargeset` に `aggregate tasks` の科目を指定すると
    `cannot aggregate amounts related to resources` エラー
- **タスク側に `chargeset` を付けると、リソースの `rate` 由来の人件費も
  そのタスクのコストとして計上される**。この教材はその形を採っている
- **`cost` / `revenue` 列には `balance` の定義が必須**。
  ないとセルが `No 'balance' defined!` になる
- 金額を計上できるのは末端 (leaf) の科目だけ
- `chargeset` の按分は同じトップレベル科目の配下同士のみ。合計は 100%
- 既定の数値書式はヨーロッパ式。この教材は `currencyformat "-" "" "," "." 0` で日本式にしている
- `accountreport` は「未テスト」警告つき
- `project` ヘッダの日付は UTC 基準 (開始を `2026-08-01` に広げて回避済み)

## 作業方針

- tjp を変更したら必ず実行し、結果を確認してから回答する
- 金額の話をするときは**必ず実行結果の数値**を出す (概算や暗算で答えない)
- 科目を追加する提案では `aggregate` の指定を必ずセットにする
- コストが 0 になったときは、まず `chargeset` の有無と `aggregate` の値を疑う
