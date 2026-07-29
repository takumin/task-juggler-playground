# CLAUDE.md — 01. 基礎

TaskJuggler 学習用プレイグラウンドの **第 01 段階 (基礎)**。

## 前提

- 対象は TaskJuggler 3.8.4 (Ruby 4.0 上で bundler 管理)
- `tj3` は bundler 経由でのみ使える。必ず `bundle exec tj3` で呼ぶ
- **コマンドはすべてリポジトリルート (このディレクトリの1つ上) から実行する**

## ファイル

| ファイル | 内容 |
|---|---|
| `hello.tjp` | 教材本体。解説はコメントとして書いてある |
| `README.md` | 学習内容の説明 |
| `out/` | 生成物。再生成できるので消してよい |

## 実行

```sh
bundle exec tj3 -o 01-hello/out 01-hello/hello.tjp
```

## 結果の確認方法

生成された HTML をそのまま読むと CSS と JavaScript で埋まって結果が見えない。
次のどちらかを使う。

```sh
# 表だけを抜き出す
ruby tools/dump-report.rb 01-hello/out/overview.html

# または tjp のレポート定義を formats html, csv にして CSV を読む
```

## この段階で扱うキーワード

`project` `resource` `task` `effort` `duration` `length` `allocate` `depends`
`taskreport` `columns` `timezone` `timeformat` `now`

構文は推測せず `bundle exec tj3man <キーワード>` で確認する (例: `bundle exec tj3man effort`)。

## 既知の落とし穴

- レポートの出力先は**カレントディレクトリ基準**。tjp の場所ではない。
  `-o` を省くと実行した場所に `css/` `icons/` ごと散らかる
- `taskreport` の第2引数は**拡張子なしのファイル名**。拡張子は `formats` から自動で付く
- `effort` を指定したタスクは `allocate` がないとスケジュールされない

## 作業方針

- tjp を変更したら必ず実行し、結果を確認してから回答する
- スケジュール結果の変化は数値で示す
  (「早く終わる」ではなく「08-14 → 08-07 になる」)
- この段階の範囲 (effort / duration / depends / 単純なレポート) で説明できることは、
  シナリオやコストなど後半の機能を持ち出さずに説明する
