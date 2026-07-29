# CLAUDE.md — 04. カレンダー

TaskJuggler 学習用プレイグラウンドの **第 04 段階 (稼働時間・祝日・シフト)**。

## 前提

- 対象は TaskJuggler 3.8.4 (Ruby 4.0 上で bundler 管理)
- `tj3` は bundler 経由でのみ使える。必ず `bundle exec tj3` で呼ぶ
- **コマンドはすべてリポジトリルート (このディレクトリの1つ上) から実行する**

## ファイル

| ファイル | 内容 |
|---|---|
| `calendar.tjp` | 教材本体。解説はコメントとして書いてある |
| `README.md` | 学習内容の説明 |
| `out/` | 生成物。再生成できるので消してよい |

## 実行

```sh
bundle exec tj3 -o 04-calendar/out 04-calendar/calendar.tjp
```

## 結果の確認方法

```sh
ruby tools/dump-report.rb 04-calendar/out/tasks.html
```

祝日・休暇はガントチャート上で "Off-duty period" として網掛け表示される。
視覚的に確認したい場合は `out/people.html` をブラウザで開く。

## この段階で扱うキーワード

`workinghours.project` `workinghours.resource` `workinghours.shift`
`dailyworkinghours` `yearlyworkingdays` `leaves` `shift` `shifts.resource`
`timingresolution` `weekstartsmonday`

構文は推測せず `bundle exec tj3man <キーワード>` で確認する。

## 既知の落とし穴

- **`leaves` は `project {}` の中ではなくトップレベル (properties スコープ)**
- 区間の終了日は 0 時に展開されるため**終了日当日は含まれない**。
  `2026-08-13 - 2026-08-17` は 8/13〜8/16 の4日間
- リソースへのシフト割当は `shifts`。旧 `shift` は非推奨警告が出る
- `leaves` の種別には優先度がある
  (`project < annual < special < sick < unpaid < holiday < unemployed`)。
  高い種別が低い種別を上書きする
- `leaveallowance` は「未テスト」警告つきの機能。使うなら結果を検証すること

## 日本の祝日

自動では入らない。`leaves holiday "名前" <日付>` で明示的に定義する。
教材には 2026 年の山の日 / 敬老の日 / 国民の休日 / 秋分の日を入れてある。

## 作業方針

- tjp を変更したら必ず実行し、結果を確認してから回答する
- 「祝日を追加したらどうなるか」等は実際に追加して実行し、日付の変化を示す
- 稼働時間を変更する提案をするときは、`dailyworkinghours` との整合も
  同時に確認する (ずれると日数換算が実態と合わなくなる)
