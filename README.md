# TaskJuggler Playground

TaskJuggler 3.8.4 を段階的に学ぶためのサンプル集。

各段階に**実際に動く `.tjp`** と、その段階の解説を置いてある。
条件だけを変えた比較になるよう作ってあるので、読むだけでなく数値の差で確認できる。

各段階のページには、解説・`tj3` が生成したレポート・tjp のソースがまとまっている。
環境を用意しなくてもブラウザだけで読み進められる。

- 公開サイト: <https://takumi.tmfam.com/task-juggler-playground/>
- リポジトリ: <https://github.com/takumin/task-juggler-playground>
- 手元で動かす手順・サイトの組み立て方:
  [DEVELOPMENT.md](https://github.com/takumin/task-juggler-playground/blob/main/DEVELOPMENT.md)

## 学習ロードマップ

各段階に詳しい解説がある。番号順に進めるのが前提。

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

構文は推測せずに必ず引く。公式マニュアルがそのまま 3.8.4 のリファレンスになっている。

- [TaskJuggler User Manual](https://taskjuggler.org/tj3/manual/index.html) — 全 266 キーワード
- [columnid](https://taskjuggler.org/tj3/manual/columnid.html) — レポートで使える列の一覧
- [task](https://taskjuggler.org/tj3/manual/task.html) — task の属性一覧 (`[sc]` = シナリオ固有)

各段階の「学ぶ内容」に挙げたキーワードは、公式マニュアルの該当ページへリンクしてある。
冒頭に **Warning** が出るキーワードは非推奨か未テスト。

## 横断的なハマりどころ

段階固有の注意点は各段階の「ハマりどころ」に書いてある。
ここには複数段階にまたがるものと、段階をまたいで引きたい索引
(「書く場所」「非推奨・未テストのキーワード」) を置く。

### 日付とタイムゾーン

`project` ヘッダの日付は `timezone` 属性を読む**前**に解釈されるため UTC 基準になる。
`timezone "Asia/Tokyo"` を指定していても `project x "..." 2026-08-03 +2m` の開始は
**2026-08-03 09:00 JST** になり、`booking` や `start` で 8/3 0:00 を指すと
「must be within the project time frame」エラーになる。

対処: プロジェクト開始を前の週末側に広げる (06 と 10 はこの方法をとっている)。

区間指定の終了日は 0 時に展開されるため、**終了日当日は含まれない**。
`2026-08-13 - 2026-08-17` は 8/13〜8/16 の 4 日間になる。
`leaves` の期間 (04) にも `booking` の期間 (06) にも同じ規則が効く。

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

- レポート名 (第2引数) は**拡張子なしで書く**。拡張子は `formats` の指定から自動で付く。
  書き足すと `overview.html.html` のように二重になる
- `export` と `timesheetreport` は `outputdir` が**効かない**。
  他のレポートが `outputdir` に従ってもこの 2 つは無視するので、
  出力先を揃えたいならレポート名側にパスを書く (07 と 12 の教材はこの形)。
  拡張子は `formats` ではなく決め打ち (`export` は中身に応じて `.tjp` / `.tji`、
  `timesheetreport` は `.tji`) だが、自動で付く点は同じ

### 非推奨・未テストのキーワード

- 非推奨: `shift.resource` (→ `shifts`)、`projection` (booking があれば自動)、`vacation` (→ `leaves`)
- 未テスト警告つき: `effortdone` / `effortleft`、`leaveallowance`、`accountreport`、
  `formats.export`、`alertlevels`
