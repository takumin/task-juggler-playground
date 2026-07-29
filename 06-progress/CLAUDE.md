# CLAUDE.md — 06. 進捗と実績

TaskJuggler 学習用プレイグラウンドの **第 06 段階 (実績追跡と projection モード)**。

## 前提

- 対象は TaskJuggler 3.8.4 (Ruby 4.0 上で bundler 管理)
- `tj3` は bundler 経由でのみ使える。必ず `bundle exec tj3` で呼ぶ
- **コマンドはすべてリポジトリルート (このディレクトリの1つ上) から実行する**

## ファイル

| ファイル | 内容 |
|---|---|
| `progress.tjp` | 教材本体。解説はコメントとして書いてある |
| `README.md` | 学習内容の説明 |
| `out/` | 生成物。再生成できるので消してよい |

## 実行

```sh
bundle exec tj3 -o 06-progress/out 06-progress/progress.tjp
```

## 結果の確認方法

```sh
ruby tools/dump-report.rb 06-progress/out/progress.html
```

## この段階で扱うキーワード

`trackingscenario` `booking.task` `booking.resource` `sloppy.booking`
`overtime.booking` `complete` `now` `scheduled` `interval4`

構文は推測せず `bundle exec tj3man <キーワード>` で確認する。

## 教材の設定

- `now 2026-08-17` — ここが計画と実績の境界
- `trackingscenario plan` — plan シナリオを projection モードにする
- projection モードでは `now` より前に新規割当をせず、
  実績は `booking` で与えられたものだけになる

## 既知の落とし穴

- **`project` ヘッダの日付は `timezone` を読む前に UTC で解釈される**。
  `2026-08-03` と書くと開始は `08-03 09:00 JST` になり、`booking` で 8/3 0:00 を
  指すと「must be within the project time frame」エラーになる。
  この教材は開始を `2026-08-01` に広げて回避している
- 区間の終了日は 0 時に展開されるので終了日当日は含まれない
  (`2026-08-03 - 2026-08-08` は 8/3〜8/7 の5日間)
- `projection` キーワードは非推奨。booking があれば自動で projection モードになる
- `effortdone` / `effortleft` は「未テスト」警告つき
- `complete` はスケジューラに一切影響しない (表示専用)。
  実績を反映させたいなら `booking` を使う

## 作業方針

- tjp を変更したら必ず実行し、結果を確認してから回答する
- `booking` を追加・変更したら、残作業の再配置がどう変わったかを日付で示す
- 「進捗を入れたい」という要望には、**スケジュールに反映したいのか
  表示だけでよいのか**を確認してから `booking` / `complete` を使い分ける
- 日付でエラーが出たら、まずプロジェクト期間の実際の開始時刻を
  エラーメッセージで確認する (UTC 解釈による 09:00 ずれの可能性が高い)
