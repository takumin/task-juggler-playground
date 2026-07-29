# CLAUDE.md — TaskJuggler Playground

TaskJuggler 3.8.4 を段階的に学ぶための教材リポジトリ。
`01-hello/` から `12-operations/` までの 12 段階で構成される。

**各段階のディレクトリにも `CLAUDE.md` がある。** 特定の段階の作業をするときは
そのディレクトリで起動するか、該当ディレクトリの `CLAUDE.md` と `README.md` を読む。

## 環境

- TaskJuggler 3.8.4 / Ruby 4.0 / bundler 管理 (`vendor/bundle`)
- `tj3` はシステムに入っていない。**必ず `bundle exec tj3` で呼ぶ**
- Ruby 3.4 以降で標準添付から外れた `base64` / `drb` を Gemfile で補っている
- インストール先は `.bundle/config` をリポジトリに含めて固定してある。
  gem が無い場合は `bundle install` だけでよい

## 実行

```sh
bundle exec tj3 -o <段階ディレクトリ>/out <tjpファイル>
```

**必ずリポジトリルートから実行する。** `export` / `timesheetreport` は
出力パスをファイル名側に埋め込んでいるため、実行位置が変わると出力先がずれる。

## 結果の確認

生成 HTML は CSS と JavaScript で埋まっていて直接読んでも結果が見えない。

```sh
ruby tools/dump-report.rb <生成された html>
```

または tjp のレポート定義を `formats html, csv` にして CSV を読む。

## 各段階

| # | ディレクトリ | エントリポイント | テーマ |
|---|---|---|---|
| 01 | `01-hello/` | `hello.tjp` | 基礎 |
| 02 | `02-structure/` | `structure.tjp` | タスク階層と依存 |
| 03 | `03-resources/` | `resources.tjp` | リソースと割当制御 |
| 04 | `04-calendar/` | `calendar.tjp` | 稼働時間・祝日・シフト |
| 05 | `05-constraints/` | `constraints.tjp` | 制約とスケジューリング |
| 06 | `06-progress/` | `progress.tjp` | 実績追跡 |
| 07 | `07-reports/` | `reports.tjp` | レポート |
| 08 | `08-filters/` | `filters.tjp` | 論理式フィルタ |
| 09 | `09-scenarios/` | `scenarios.tjp` | シナリオ比較 |
| 10 | `10-cost/` | `cost.tjp` | コストと収支 |
| 11 | `11-modular/` | **`main.tjp`** | ファイル分割 (`.tji` は単体で実行不可) |
| 12 | `12-operations/` | `operations.tjp` | 運用・チーム連携 |

## GitHub Pages

`main` への push で `.github/workflows/pages.yml` が全段階を並列ビルドし、
README・レポート・tjp ソースを 1 ページにまとめて公開する。
生成は `tools/build-site.rb` (`stages` / `entrypoint` / `stage` / `index` の 4 サブコマンド)。
組み立て手順は README の「サイトの生成」にある。

- 段階ディレクトリを増やしてもワークフローの変更は要らない (`stages` が拾う)
- 段階の tjp が複数あるとエントリポイントを決められない。分割するなら `main.tjp` に寄せる
- Markdown 変換は kramdown の **GFM パーサ**。素の kramdown は ``` を解釈しない
- `<details>` の中の Markdown を変換させるには `<details markdown="1">` と書く

## リファレンス

構文は推測しない。必ず引く。

```sh
bundle exec tj3man <キーワード>   # 個別
bundle exec tj3man                # 全 266 キーワードの一覧
bundle exec tj3man columnid       # レポートの列一覧
bundle exec tj3man task           # task の属性 ([sc] = シナリオ固有)
```

冒頭に **Warning** が出るキーワードは非推奨か未テスト。使う前に確認する。

## 横断的な落とし穴 (すべて実測で確認済み)

- **`project` ヘッダの日付は `timezone` より先に UTC で解釈される**。
  `2026-08-03` と書くと開始は `08-03 09:00 JST`。日付境界の `booking` / `start` が
  期間外エラーになる。対処はプロジェクト開始を週末側に広げること
- **論理式の比較は括弧必須**。`|` `&` の方が結合が強く、
  `a() | plan.id = "x"` は型エラーになる
- **関数に渡すタスク ID はルートからのフルパス**。
  短く書くとエラーも出ないまま結果が空になる
- **`export` / `timesheetreport` は `-o` が効かない**。拡張子は自動付与
- `leaves` はトップレベル、`extend` / `scenario` は `project {}` の中
- `include` はタスク定義の中に書けない (`taskprefix` を使う)

## 作業方針

- **tjp を変更したら必ず実行し、結果を確認してから回答する。** 推測で答えない
- 変化を説明するときは数値で示す (「早くなる」ではなく「08-14 → 08-07」)
- 教材の tjp は**解説コメントが本体の一部**。編集するときはコメントとの整合を保つ
- 各段階は「条件だけを変えた比較」になるよう設計されている。
  実験でこの性質を壊す変更をするときは、その旨を伝える
- 出力先は必ず `-o <段階ディレクトリ>/out`。リポジトリルートを汚さない
- 新しい事実が分かったら、該当段階の README とルート README の
  「ハマりどころ」に反映する
