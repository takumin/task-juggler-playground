# CLAUDE.md — 07. レポート

TaskJuggler 学習用プレイグラウンドの **第 07 段階 (レポートの種類とカスタマイズ)**。

## 前提

- 対象は TaskJuggler 3.8.4 (Ruby 4.0 上で bundler 管理)
- `tj3` は bundler 経由でのみ使える。必ず `bundle exec tj3` で呼ぶ
- **コマンドはすべてリポジトリルート (このディレクトリの1つ上) から実行する**

## ファイル

| ファイル | 内容 |
|---|---|
| `reports.tjp` | 教材本体。8 種類のレポート定義が入っている |
| `README.md` | 学習内容の説明 |
| `out/` | 生成物。再生成できるので消してよい |

## 実行

```sh
bundle exec tj3 -o 07-reports/out 07-reports/reports.tjp
```

## 結果の確認方法

```sh
# 表だけ抜き出す
ruby tools/dump-report.rb 07-reports/out/02-styled.html

# CSV は直接読める
cat 07-reports/out/01-basic.csv
```

装飾 (背景色・ゲージ・ガントチャート) を確認したい場合はブラウザで開く。

## この段階で扱うキーワード

`taskreport` `resourcereport` `textreport` `accountreport` `tracereport` `export`
`columns` `celltext.column` `cellcolor.column` `title.column` `formats`
`loadunit` `period.report` `rolluptask` `rollupresource` `sorttasks` `sortresources`
`navigator` `opennodes` `selfcontained` `outputdir` `columnid`

利用可能な列の一覧は `bundle exec tj3man columnid` で引ける。
構文は推測せず `bundle exec tj3man <キーワード>` で確認する。

## 既知の落とし穴

- **`export` は `-o` / `outputdir` が効かない**。常にカレントディレクトリ基準。
  出力先を揃えるならファイル名側にパスを書く。拡張子は自動付与
  (`.tjp` と書き足すと `.tjp.tjp` になる)
- レポート名 (第2引数) は拡張子なしで書く。`formats` から拡張子が決まる
- 論理式では属性を `plan.effort` のようにシナリオ ID 付きで参照する
- `celltext` / `cellcolor` は条件付き。全セルに適用するなら `@all`
- 存在しない列名を指定するとエラーになる。有効な列名は `tj3man columnid` を参照
- `accountreport` と `formats.export` は「未テスト」警告つき

## Rich Text の記法 (textreport 内)

```
-8<- ... ->8-           ブロックの囲み
== 見出し ==             見出し (= の数で階層)
<[report id="xxx"]>     他レポートの埋め込み
<[navigator id="xxx"]>  ナビゲーションバーの埋め込み
```

## 作業方針

- tjp を変更したら必ず実行し、結果を確認してから回答する
- 「こういう表を出したい」という要望には、まず `tj3man columnid` で
  使える列があるかを確認してから提案する
- 出力形式を増やす提案では、`export` / `timesheetreport` の
  出力先の癖 (上記) を必ず伝える
- レポートを追加したら、既存レポートのファイル名と衝突しないか確認する
  (同じ enclosing report 内で ID とファイル名は一意である必要がある)
