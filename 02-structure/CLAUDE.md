# CLAUDE.md — 02. 構造

TaskJuggler 学習用プレイグラウンドの **第 02 段階 (タスク階層と依存関係)**。

## 前提

- 対象は TaskJuggler 3.8.4 (Ruby 4.0 上で bundler 管理)
- `tj3` は bundler 経由でのみ使える。必ず `bundle exec tj3` で呼ぶ
- **コマンドはすべてリポジトリルート (このディレクトリの1つ上) から実行する**

## ファイル

| ファイル | 内容 |
|---|---|
| `structure.tjp` | 教材本体。解説はコメントとして書いてある |
| `README.md` | 学習内容の説明 |
| `out/` | 生成物。再生成できるので消してよい |

## 実行

```sh
bundle exec tj3 -o 02-structure/out 02-structure/structure.tjp
```

## 結果の確認方法

```sh
ruby tools/dump-report.rb 02-structure/out/structure.html
```

## この段階で扱うキーワード

`task` (入れ子) `depends` `precedes` `milestone` `gapduration` `gaplength`
`resourcereport` `loadunit`

構文は推測せず `bundle exec tj3man <キーワード>` で確認する。

## 依存の参照記法 (この段階の核心)

| 記法 | 意味 |
|---|---|
| `!x` | `!` 1つで親を起点 = 兄弟タスク |
| `!!a.b` | `!!` で2階層上を起点にパス解決 |
| `a.b` | 起点記号なしはルートからの絶対パス |

コンテナへの `depends` は「配下が全部終わってから」。

## 既知の落とし穴

- コンテナタスク (子を持つタスク) に `effort` は書けない
- `milestone` は `task` の属性。`effort` / `duration` と併用できない
- `gapduration` は暦時間、`gaplength` は稼働時間。
  週末を跨ぐ長さだと開始日が変わる (実測: 5d 指定で 09-01 と 09-03)

## 作業方針

- tjp を変更したら必ず実行し、結果を確認してから回答する
- 依存の記法について聞かれたら、実際に書き換えて実行し、
  スケジュールがどう変わったかを数値で示す
- 「なぜこの日付になるのか」の説明では、営業日・週末・依存元の完了時刻を
  順に追って示す (TaskJugglerは終業 18:00 を基準に次の稼働開始へ送る)
