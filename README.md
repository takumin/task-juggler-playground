# TaskJuggler Playground

TaskJuggler 3.8.4 を段階的に学ぶためのサンプル集。

各段階に**実際に動く `.tjp`** と、その段階の解説 README を置いてある。
条件だけを変えた比較になるよう作ってあるので、読むだけでなく数値の差で確認できる。

**解説・生成されたレポート・tjp のソースをまとめたサイトを公開している。**
手元に環境を作らずブラウザだけで読み進めたいならこちら:
<https://takumi.tmfam.com/task-juggler-playground/>

## セットアップ

```sh
bundle install
```

taskjuggler gem は `vendor/bundle` に入り、システムを汚さない。
インストール先は `.bundle/config` をリポジトリに含めて固定してあるので、
clone 後は `bundle install` だけでよい。

Ruby 3.4 以降で標準添付から外れた `base64` / `drb` を Gemfile で明示している。

## 実行方法

```sh
bundle exec tj3 -o <出力先ディレクトリ> <tjpファイル>

# 例
bundle exec tj3 -o 01-hello/out 01-hello/hello.tjp
```

**コマンドはこのディレクトリ (リポジトリルート) から実行する。**
レポートの出力先はカレントディレクトリ基準になるため `-o` で明示するのが確実。

生成された HTML はブラウザで開く。表の内容だけを手早く確認したいときは:

```sh
ruby tools/dump-report.rb 01-hello/out/overview.html
```

<details markdown="1">
<summary>全段階をまとめて実行する</summary>

```sh
for f in 01-hello/hello.tjp 02-structure/structure.tjp 03-resources/resources.tjp \
         04-calendar/calendar.tjp 05-constraints/constraints.tjp 06-progress/progress.tjp \
         07-reports/reports.tjp 08-filters/filters.tjp 09-scenarios/scenarios.tjp \
         10-cost/cost.tjp 11-modular/main.tjp 12-operations/operations.tjp; do
  mkdir -p "$(dirname "$f")/out"
  bundle exec tj3 -o "$(dirname "$f")/out" "$f"
done
```

</details>

## 学習ロードマップ

各段階のディレクトリに詳しい README がある。番号順に進めるのが前提。

| # | 段階 | 概要 |
|---|---|---|
| [01](01-hello/README.md) | **基礎** | プロジェクト宣言からレポート出力までの最小の一往復。`effort` / `duration` / `length` の違いを押さえる |
| [02](02-structure/README.md) | **構造** | タスクをツリーに組み、依存を張る。`!` `!!` 絶対パスの参照記法とマイルストーン |
| [03](03-resources/README.md) | **リソース** | 「誰が」を精密に表現する。複数割当・`efficiency`・`limits`・代替リソース |
| [04](04-calendar/README.md) | **カレンダー** | 「いつ働けるか」の定義。稼働時間・祝日・休暇・シフト。日本の営業日を扱う |
| [05](05-constraints/README.md) | **制約** | スケジューラへの指示。ASAP/ALAP・日付固定・`priority` による競合解決・事後検査 |
| [06](06-progress/README.md) | **進捗と実績** | 実績を入れて残作業を再計算させる。`booking` と `complete` の使い分け |
| [07](07-reports/README.md) | **レポート** | 出力の作り分け。列のカスタマイズ・CSV・時系列集計・ページ合成 |
| [08](08-filters/README.md) | **フィルタ** | 論理式で「何を出すか」を絞る。組み込み関数とスコープ評価 |
| [09](09-scenarios/README.md) | **シナリオ** | 同じ計画を条件違いで同時にスケジュールし、横並びで比較する |
| [10](10-cost/README.md) | **コスト** | 工数計画から原価と収支を出す。勘定科目・単価・按分 |
| [11](11-modular/README.md) | **モジュール化** | 規模が大きくなったときのファイル分割。マクロ・`supplement`・独自属性 |
| [12](12-operations/README.md) | **運用** | 状況記録・報告書の自動生成・タイムシート。継続運用に乗せる |

### 段階のつながり

- **01〜02** が文法の骨格
- **03〜06** で計画を現実に近づける
- **07〜09** が出力と分析の層 (07 でレポートの器、08 でその中身を絞る、という対の関係)
- **10〜12** が規模と運用の層

06 の実績追跡は 09 のシナリオ機能の上に乗っており、
06 で実績を扱ってから 11 の `supplement` に進むと、
計画と実績を分離する実務パターンの意味が腑に落ちる。

## 用語メモ

- **effort** — 人的工数。担当者が割り当たって初めて期間が決まる。担当が増えれば期間は縮む
- **duration** — 暦時間ベースの期間。担当者に依存しない (待ち時間、外部レビュー期間など)
- **length** — 稼働日ベースの期間。休日は数えないが、担当者の負荷には依存しない

## リファレンスの引き方

```sh
bundle exec tj3man <キーワード>      # 個別のキーワード
bundle exec tj3man                   # 全キーワード一覧 (266 個)
bundle exec tj3man columnid          # レポートで使える列の一覧
bundle exec tj3man task              # task の属性一覧 ([sc] = シナリオ固有)
```

各段階の README に「この段階で扱うキーワード」を挙げてあるので、そこから引くのが早い。
冒頭に **Warning** が出るキーワードは非推奨か未テスト。

## 横断的なハマりどころ

段階固有の注意点は各 README に書いてある。ここでは複数段階にまたがるものだけ。

### 日付とタイムゾーン

`project` ヘッダの日付は `timezone` 属性を読む**前**に解釈されるため UTC 基準になる。
`timezone "Asia/Tokyo"` を指定していても `project x "..." 2026-08-03 +2m` の開始は
**2026-08-03 09:00 JST** になり、`booking` や `start` で 8/3 0:00 を指すと
「must be within the project time frame」エラーになる。

対処: プロジェクト開始を前の週末側に広げる (06 と 10 はこの方法をとっている)。

### 書く場所

| 要素 | 書く場所 |
|---|---|
| `leaves` | トップレベル (properties スコープ)。`project {}` の中ではない |
| `extend` / `scenario` / `trackingscenario` | `project {}` の中 |
| `balance` | トップレベル、またはレポートの中 |
| `include` | タスク定義の**中には書けない**。`taskprefix` 付きでトップレベルに置く |

### 論理式 (05・07・08 で共通)

- 比較演算子は `&` `|` より結合が弱い。**比較は必ず括弧で囲む**
- 属性はシナリオ ID 付きで参照する (`plan.effort`)。非シナリオ属性でも必要
- 関数に渡すタスク ID は**ルートからのフルパス**。
  短く書くとエラーも出ないまま結果が空になる

### レポート出力

- `export` と `timesheetreport` は `-o` / `outputdir` が**効かない**。
  常にカレントディレクトリ基準なので、出力先はファイル名側にパスを書く
- 両者とも拡張子は自動付与。`.tji` まで書くと `.tji.tji` になる

### 非推奨・未テストのキーワード

- 非推奨: `shift.resource` (→ `shifts`)、`projection` (booking があれば自動)、`vacation` (→ `leaves`)
- 未テスト警告つき: `effortdone` / `effortleft`、`leaveallowance`、`accountreport`、
  `formats.export`、`alertlevels`

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
│   └── out/                 生成物 (消してよい)
└── README.md
```

各ディレクトリで Claude Code を起動すると、その段階に特化した `CLAUDE.md` が読み込まれる。

## サイトの生成

`main` に push すると GitHub Actions が全段階を並列に `tj3` にかけ、
README・レポート・tjp ソースを 1 ページにまとめたサイトを Pages に配置する。

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

`site/` は生成物なので追跡していない。段階ディレクトリを増やしても
`stages` が拾うため、ワークフローの変更は要らない。

Pages の有効化だけはワークフローからはできない
(`GITHUB_TOKEN` に権限が無く `configure-pages` の `enablement` は失敗する)。
リポジトリごとに 1 度だけ、Settings → Pages → Source を **GitHub Actions** にするか、
以下を実行しておく。

```sh
gh api -X POST repos/<owner>/<repo>/pages -f build_type=workflow
```

サイトの Markdown 変換には kramdown の GFM パーサを使っている。
`<details>` の中に書いた Markdown を変換させるには
`<details markdown="1">` と書く (GitHub 側の表示には影響しない)。
