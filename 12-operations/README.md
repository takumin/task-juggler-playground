# 12. 運用・チーム連携

計画を立てて終わりではなく、状況を記録し、報告書を出し、メンバーから実績を集める。
継続運用に乗せるための機能を扱う。

## レポートの内容

| ファイル | 内容 |
|---|---|
| `01-status.html` | 週次ステータス (各タスクの最新記録のみ) |
| `02-journal.html` | 記録の全履歴 |
| `03-weekly-report.html` | 上記を組版した週次報告書 |
| `04-timesheet-draft.tji` | メンバーに配るタイムシートのひな形 |

## 学ぶ内容

- [`journalentry`][journalentry] — 状況の記録
- [`alert`][alert] — 警告レベル (green / yellow / red)
- [`journalmode`][journalmode] — どの記録をレポートに集めるか
- [`textreport`][textreport] — 報告書としての組版
- [`timesheetreport`][timesheetreport] — タイムシートのひな形生成
- [`timesheet`][timesheet] / [`statussheet`][statussheet] — メンバーからの報告フォーマット

## journalentry

```
journalentry 2026-08-17 "外部APIの仕様変更で遅延見込み" {
  author bob
  alert red
  summary -8<-
    連携先APIの仕様変更が判明。追加調査が必要。
  ->8-
  details -8<-
    (詳細)
  ->8-
}
```

- **見出しは必須**で 5〜10 語程度
- `summary` は 1〜2 文の要約、`details` に詳細
- `alert` を付けるとレポートに信号色で出る

## journalmode

| 値 | 集める記録 |
|---|---|
| `journal` | 期間内の全エントリ |
| `journal_sub` | そのタスクと配下の全エントリ |
| `status_up` | 各プロパティの最新エントリ (親に新しい記録があれば親を優先) |
| `status_down` | 各プロパティと配下の最新エントリ |
| `status_dep` | 依存関係もたどって最新エントリ |
| `alerts_dep` / `alerts_down` | 警告のみ集める |

「今の状況だけ知りたい」なら `status_*`、「経緯を追いたい」なら `journal`。

## タイムシートのひな形

`timesheetreport` は、計画データから「今週やる予定の作業」が埋まった状態の
タイムシートを生成する。メンバーは実績を書き込んで返すだけでよい。

```
timesheet alice 2026-08-17-00:00-+0900 - 2026-08-24-00:00-+0900 {
  # Task: 設計
  task design {
    work 100.0%
    remaining 0.0d
    status green "Your headline here!" {
    #  summary -8<-
    #  A summary text
    #  ->8-
    }
  }
}
```

集めたタイムシートは `include` して取り込むと **`booking` に変換される**。

## 運用コマンド

| コマンド | 役割 |
|---|---|
| `tj3d` | デーモン (サーバ) |
| `tj3client` | サーバへのクライアント |
| `tj3ts` | タイムシートの受付・検証 |
| `tj3ss` | ステータスシートの受付・検証 |

これらを組み合わせると、メンバーがメールでタイムシートを送り、
サーバが検証して計画に取り込む、という運用が自動化できる。

## 気をつけるポイント

- **タイムシート/ステータスシートを使うには `trackingscenario` の指定が必須**
- **`timesheetreport` は `-o` が効かない**。カレントディレクトリ基準になるので、
  出力先はファイル名側にパスを書く。拡張子 `.tji` は自動で付く
  (書き足すと `.tji.tji` になる)
- `alertlevels` で独自の警告段階を定義できるが、各レベルに対応する
  15x15 の `flag-<ID>.png` を出力先の `icons/` に置く必要がある。
  この機能自体も「未テスト」警告つき
- `journalentry` は `task` / `resource` / `project` のいずれにも書ける。
  既存タスクに後から足すなら `supplement` を使う

## 得られるもの

「今週どうだったか」を計画データと同じ場所に記録し、
報告書として自動生成できるようになる。
計画・実績・状況が 1 つのソースにまとまり、報告資料を別途作る必要がなくなる。

---

← [11. モジュール化](../11-modular/README.md) | [README (全体)](../README.md)

<!-- 公式リファレンス (https://taskjuggler.org/tj3/manual/) -->

[journalentry]: https://taskjuggler.org/tj3/manual/journalentry.html
[alert]: https://taskjuggler.org/tj3/manual/alert.html
[journalmode]: https://taskjuggler.org/tj3/manual/journalmode.html
[textreport]: https://taskjuggler.org/tj3/manual/textreport.html
[timesheetreport]: https://taskjuggler.org/tj3/manual/timesheetreport.html
[timesheet]: https://taskjuggler.org/tj3/manual/timesheet.html
[statussheet]: https://taskjuggler.org/tj3/manual/statussheet.html
