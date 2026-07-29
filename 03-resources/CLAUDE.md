# CLAUDE.md — 03. リソース

TaskJuggler 学習用プレイグラウンドの **第 03 段階 (リソースと割当制御)**。

## 前提

- 対象は TaskJuggler 3.8.4 (Ruby 4.0 上で bundler 管理)
- `tj3` は bundler 経由でのみ使える。必ず `bundle exec tj3` で呼ぶ
- **コマンドはすべてリポジトリルート (このディレクトリの1つ上) から実行する**

## ファイル

| ファイル | 内容 |
|---|---|
| `resources.tjp` | 教材本体。解説はコメントとして書いてある |
| `README.md` | 学習内容の説明 |
| `out/` | 生成物。再生成できるので消してよい |

## 実行

```sh
bundle exec tj3 -o 03-resources/out 03-resources/resources.tjp
```

## 結果の確認方法

```sh
ruby tools/dump-report.rb 03-resources/out/tasks.html
```

## この段階で扱うキーワード

`resource` (入れ子) `allocate` `alternative` `select` `persistent` `mandatory`
`efficiency` `limits` `dailymax` `weeklymax` `monthlymax` `managers` `purge`

構文は推測せず `bundle exec tj3man <キーワード>` で確認する。
特に `limits.resource` / `limits.task` / `limits.allocate` は別項目なので注意。

## 教材の構成意図

タスク①〜⑥はすべて 08-03 から並列に走り、**割当条件の違いだけ**が期間に出るよう
設計してある (タスクごとに専用の担当を割り当てて競合を排除)。
条件を変えて実験するときも、この性質を壊さないよう注意する
(同じ人を複数タスクに割り当てると競合で日付がずれ、比較にならなくなる)。

## 既知の落とし穴

- **`limits` は書く場所で意味が変わる**
  - `resource` の中 → そのリソースの全タスク合計
  - `task` の中 → そのタスクの消費量
  - `allocate` の中 → その割当だけ
- `efficiency 0.0` は「工数を提供しない」= 会議室など設備のモデル化用
- `managers` はスケジューリングに影響しない。葉リソースしか指定できない
- 親リソースの属性は子に継承される。断ち切るには `purge`

## 作業方針

- tjp を変更したら必ず実行し、結果を確認してから回答する
- 「人を増やすとどうなるか」等の質問には、実際に `allocate` を書き換えて
  実行し、期間の変化を数値で示す
- リソース競合が絡む話題が出たら、この段階では扱っていないことを伝えつつ
  05 (`priority`) を案内する
