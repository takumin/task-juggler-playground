# CLAUDE.md — 12. 運用・チーム連携

TaskJuggler 学習用プレイグラウンドの **第 12 段階 (状況記録・報告書・タイムシート)**。

## 前提

- 対象は TaskJuggler 3.8.4 (Ruby 4.0 上で bundler 管理)
- `tj3` は bundler 経由でのみ使える。必ず `bundle exec tj3` で呼ぶ
- **コマンドはすべてリポジトリルート (このディレクトリの1つ上) から実行する**

## ファイル

| ファイル | 内容 |
|---|---|
| `operations.tjp` | 教材本体。解説はコメントとして書いてある |
| `README.md` | 学習内容の説明 |
| `out/` | 生成物。再生成できるので消してよい |

## 実行

```sh
bundle exec tj3 -o 12-operations/out 12-operations/operations.tjp
```

## 結果の確認方法

```sh
ruby tools/dump-report.rb 12-operations/out/01-status.html

# タイムシートのひな形はテキストなので直接読める
cat 12-operations/out/04-timesheet-draft.tji
```

信号色のアイコンや組版を確認したい場合は `out/03-weekly-report.html` をブラウザで開く。

## この段階で扱うキーワード

`journalentry` `alert` `alertlevels` `journalmode` `author` `summary` `details`
`timesheet` `statussheet` `timesheetreport` `statussheetreport` `textreport`
`hidejournalentry` `flags.journalentry` `trackingscenario`

構文は推測せず `bundle exec tj3man <キーワード>` で確認する。

## journalmode の選択肢

| 値 | 集める記録 |
|---|---|
| `journal` | 期間内の全エントリ |
| `journal_sub` | そのタスクと配下の全エントリ |
| `status_up` | 各プロパティの最新 (親に新しい記録があれば親を優先) |
| `status_down` | 各プロパティと配下の最新 |
| `status_dep` | 依存関係もたどる |
| `alerts_dep` / `alerts_down` | 警告のみ |

## 既知の落とし穴 (実測で確認済み)

- **タイムシート/ステータスシートには `trackingscenario` の指定が必須**
- **`timesheetreport` は `-o` が効かない**。カレントディレクトリ基準。
  出力先はファイル名側にパスを書く。**拡張子 `.tji` は自動付与**
  (書き足すと `.tji.tji` になる)
- `journalentry` の見出しは必須
- `alertlevels` は「未テスト」警告つき。独自レベルを使うには
  `flag-<ID>.png` (15x15) を出力先の `icons/` に用意する必要がある
- 既存タスクに記録を後から足すなら `supplement task <ID>` を使う

## 運用コマンド (このリポジトリでは未使用)

`tj3d` (サーバ) / `tj3client` / `tj3ts` (タイムシート受付) / `tj3ss` (ステータスシート受付)。
いずれも `bundle exec` 経由で起動できる。デーモンを起動する提案をする場合は、
**バックグラウンド実行とポート占有について事前に確認を取ること**。

## 作業方針

- tjp を変更したら必ず実行し、結果を確認してから回答する
- 報告書のレイアウトを変える提案では、Rich Text の記法
  (`-8<- ... ->8-`、`== 見出し ==`、`<[report id="x"]>`) を守る
- タイムシートの取り込みを試す場合、実績が `booking` に変換されて
  スケジュールが変わることを事前に説明する
- サーバ機能 (`tj3d` など) は環境に常駐するため、勝手に起動しない
