# DEVELOPMENT

このリポジトリを手元で動かす人向けのメモ。
教材そのもの (学習ロードマップ・用語・ハマりどころ) は [README.md](README.md) にある。

## セットアップ

```sh
bundle install
```

taskjuggler gem は `vendor/bundle` に入り、システムを汚さない。
インストール先は `.bundle/config` をリポジトリに含めて固定してあるので、
clone 後は `bundle install` だけでよい。

Ruby 3.4 以降で標準添付から外れた `base64` / `drb` を Gemfile で明示している。

`tj3` はシステムに入れない。**必ず `bundle exec tj3` で呼ぶ。**

## 実行

```sh
bundle exec tj3 -o <出力先ディレクトリ> <tjpファイル>

# 例
bundle exec tj3 -o 01-hello/out 01-hello/hello.tjp
```

**コマンドはリポジトリルートから実行する。**
レポートの出力先はカレントディレクトリ基準になるため `-o` で明示するのが確実
(省略すると実行した場所に `css/` `icons/` ごと散らかる)。
特に `export` と `timesheetreport` は `-o` も `outputdir` も効かず、
出力パスをレポート名側に埋め込んでいるので、実行位置が変わると出力先がずれる。

`tj3` は `-o` に渡したディレクトリを自分では作らない。無ければ先に `mkdir -p` する。

11-modular だけはエントリポイントが `main.tjp`。`.tji` は単体では実行できない。

### 全段階をまとめて実行する

```sh
for f in 01-hello/hello.tjp 02-structure/structure.tjp 03-resources/resources.tjp \
         04-calendar/calendar.tjp 05-constraints/constraints.tjp 06-progress/progress.tjp \
         07-reports/reports.tjp 08-filters/filters.tjp 09-scenarios/scenarios.tjp \
         10-cost/cost.tjp 11-modular/main.tjp 12-operations/operations.tjp; do
  mkdir -p "$(dirname "$f")/out"
  bundle exec tj3 -o "$(dirname "$f")/out" "$f"
done
```

## 結果の確認

生成された HTML はブラウザで開く。
CSS と JavaScript で埋まっているので、直接読んでも表の中身は見えない。
表の内容だけを手早く確認したいときは:

```sh
ruby tools/dump-report.rb 01-hello/out/overview.html
```

または tjp のレポート定義を `formats html, csv` にして CSV を読む。

## リファレンスの引き方

ローカルの gem にマニュアルが同梱されている。

```sh
bundle exec tj3man <キーワード>      # 個別のキーワード
bundle exec tj3man                   # 全キーワード一覧 (266 個)
bundle exec tj3man columnid          # レポートで使える列の一覧
bundle exec tj3man task              # task の属性一覧 ([sc] = シナリオ固有)
```

同じ内容が [オンラインマニュアル](https://taskjuggler.org/tj3/manual/index.html)
にもある (3.8.4 で生成されたもの)。

## ディレクトリ構成

```
.
├── Gemfile / Gemfile.lock   taskjuggler 3.8.4 + base64 / drb / kramdown
├── tools/
│   ├── dump-report.rb       生成 HTML から表だけを抜き出す確認用スクリプト
│   ├── build-site.rb        GitHub Pages 用サイトの生成
│   └── site.css             同上のスタイル
├── .github/workflows/
│   └── pages.yml            12 段階を並列ビルドして Pages に配置する
├── NN-<name>/
│   ├── *.tjp                教材本体 (解説はコメントとして記述)
│   ├── README.md            その段階の解説
│   ├── CLAUDE.md            Claude Code 用のコンテキスト
│   └── out/                 tj3 の生成物
├── README.md                教材のトップ (Pages のトップページを兼ねる)
└── DEVELOPMENT.md           このファイル
```

各段階のディレクトリで Claude Code を起動すると、
その段階に特化した `CLAUDE.md` が読み込まれる。

## 生成物の扱い

追跡していない。どちらもいつでも再生成できるので消してよい。

| パス | 生成するもの | 再生成 |
|---|---|---|
| `NN-<name>/out/` | `tj3` のレポート | `bundle exec tj3 -o <段階>/out <tjp>` |
| `site/` | Pages 用に組み立てたサイト | `tools/build-site.rb` (下記) |

`vendor/bundle/` も追跡していない (`bundle install` で復元)。
`.bundle/config` だけは共有したいので追跡している。

## サイトの生成

`main` に push すると `.github/workflows/pages.yml` が全段階を並列に `tj3` にかけ、
解説・レポート・tjp ソースを 1 ページにまとめたサイトを Pages に配置する。

組み立ては `tools/build-site.rb` の 4 サブコマンド。

| サブコマンド | 役割 |
|---|---|
| `stages` | 段階ディレクトリの一覧を JSON 配列で出力 (Actions の matrix 用) |
| `entrypoint <段階>` | その段階を `tj3` に渡すときのファイルパスを出力 |
| `stage <段階> [--output DIR]` | 段階ページを生成 (`tj3` 実行済みであること) |
| `index [--output DIR]` | トップページ (ルート README から) と共通 CSS を生成 |

手元で同じものを組み立てて確認するには:

```sh
bundle exec ruby tools/build-site.rb index --output site

for s in $(bundle exec ruby tools/build-site.rb stages | tr -d '[]"' | tr ',' ' '); do
  mkdir -p "$s/out"   # tj3 は -o のディレクトリを自分では作らない
  bundle exec tj3 -o "$s/out" "$(bundle exec ruby tools/build-site.rb entrypoint "$s")"
  bundle exec ruby tools/build-site.rb stage "$s" --output site
done

python3 -m http.server 8000 --directory site
```

### 段階ページの構成

段階 README はそのまま流し込まれるのではなく、次の順に組み替えられる。

| 位置 | 中身 |
|---|---|
| 1 | README の `# ` 見出しと、最初の `## ` の手前までの導入文 |
| 2 | 生成されたレポート (`out/` のファイルへのリンク) |
| 3 | ソース (tjp / tji。すべて折りたたみ、エントリポイントが先頭) |
| 4 | README の最初の `## ` 以降 |
| 5 | 前後の段階へのナビゲーション (README 末尾の `<hr>` 以降) |

結果を先に見せてから解説に入る形にしてある。
ソースは 200 行になる段階があるので開いた状態にはしない。

### 段階を追加するとき

ワークフローの変更は要らない。`stages` が `NN-` で始まるディレクトリを拾う。

- 段階ディレクトリは `\d\d-` で始める。並び順はそのまま学習ロードマップの順序になる
- `README.md` は必須。`# ` 見出しがページタイトルになる
- README は `# ` 見出しの後に**導入文を置いてから** `## ` を始める。
  ここがレポートより前に出る唯一の本文になる
- README に実行コマンドは書かない。読者はサイトで完成品を見るだけで、
  手元で動かす手順はこのファイルにまとまっている
- tjp が複数あるとエントリポイントを決められずビルドが止まる。
  分割するなら `main.tjp` に寄せる (あれば優先される)
- 段階 README の末尾は `---` + 前後リンクで締める。
  最後の `<hr>` 以降がページ最下部のナビゲーションに回される
- ルート README の学習ロードマップの表にも行を足す

### Markdown 変換の注意

- 変換は kramdown の **GFM パーサ**。素の kramdown は ``` を解釈しない
- `<details>` の中の Markdown を変換させるには `<details markdown="1">` と書く
  (GitHub 側の表示には影響しない)
- README 同士の `.md` リンクはサイトのパスに読み替えられる
  (`../02-structure/README.md` → `../02-structure/`)。
  サイトに載らないファイル (この DEVELOPMENT.md など) へは絶対 URL で張る

### Pages の有効化

ワークフローからはできない
(`GITHUB_TOKEN` に権限が無く `configure-pages` の `enablement` は失敗する)。
リポジトリごとに 1 度だけ、Settings → Pages → Source を **GitHub Actions** にするか、
以下を実行しておく。

```sh
gh api -X POST repos/<owner>/<repo>/pages -f build_type=workflow
```

公開先は <https://takumi.tmfam.com/task-juggler-playground/>
(アカウントのカスタムドメイン設定により `github.io` ではない)。
