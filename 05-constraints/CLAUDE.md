# CLAUDE.md — 05. 制約とスケジューリング

TaskJuggler 学習用プレイグラウンドの **第 05 段階 (制約とスケジューリング方向)**。

## 前提

- 対象は TaskJuggler 3.8.4 (Ruby 4.0 上で bundler 管理)
- `tj3` は bundler 経由でのみ使える。必ず `bundle exec tj3` で呼ぶ
- **コマンドはすべてリポジトリルート (このディレクトリの1つ上) から実行する**

## ファイル

| ファイル | 内容 |
|---|---|
| `constraints.tjp` | 教材本体。解説はコメントとして書いてある |
| `README.md` | 学習内容の説明 |
| `out/` | 生成物。再生成できるので消してよい |

## 実行

```sh
bundle exec tj3 -o 05-constraints/out 05-constraints/constraints.tjp
```

## 結果の確認方法

```sh
ruby tools/dump-report.rb 05-constraints/out/tasks.html
```

## この段階で扱うキーワード

`scheduling` `schedulingmode` `start` `end` `minstart` `maxstart` `minend` `maxend`
`priority` `precedes` `onstart` `onend` `warn` `fail` `responsible` `flags.task`

構文は推測せず `bundle exec tj3man <キーワード>` で確認する。

## 既知の落とし穴

- `scheduling` は他の属性から暗黙に上書きされうる。**タスクの最後に書く**
- ALAP には終了側の条件 (`end` または `precedes`) が必要。
  ASAP と ALAP を混ぜるとスケジューリング時間が 2〜10 倍になりうる
- `priority` は「重要度」ではなく「リソース獲得の優先順位」(既定 500、範囲 1〜1000)。
  リソースを持たないタスクには効かない
- `flags` は使う前にトップレベルで宣言が必要
- `minstart` などは**エラー**、`warn` は**警告** (終了コードは 0 のまま)
- 論理式の中では属性を `plan.end` のようにシナリオ ID 付きで参照する

## 動作確認済みの挙動

- `warn plan.end > 2026-08-05` に変更すると
  `Warning: User defined warning triggered for task checked` が出て、
  終了コードは 0 のまま (実測)

## 作業方針

- tjp を変更したら必ず実行し、結果を確認してから回答する
- 制約を追加する提案では、それが**スケジューリングに効く**もの (`start` / `depends`) か
  **事後検査**にすぎないもの (`maxend` / `warn`) かを明確に区別して説明する
- `priority` の効果を示すときは、競合する2タスクの日付がどう入れ替わるかを実測で示す
