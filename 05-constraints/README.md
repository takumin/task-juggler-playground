# 05. 制約とスケジューリング

スケジューラに「いつ置くか」を指示する手段を一通り試す。

## レポートの内容

| ファイル | 内容 |
|---|---|
| `tasks.html` | 制約による配置の違い (`responsible` 列つき) |

### 実行結果

レポートは開始日の順に並ぶ。主なものを抜き出すと次のとおり。

| タスク | 開始 | 終了 | 効いている制約 |
|---|---|---|---|
| ① ASAP | 2026-08-03 | 08-07 | 既定 (前詰め) |
| ⑤a 優先度 900 | 2026-08-03 | 08-07 | Bob を先に確保 |
| ⑤b 優先度 100 | 2026-08-10 | 08-14 | Bob が空くまで待つ |
| ③ 開始日を固定 | 2026-08-17 | 08-21 | `start 2026-08-17` |
| ② ALAP | 2026-09-23 | 09-29 | 納品期限からの逆算 |
| 納品期限 | 2026-09-30 | — | `milestone` + `start` 固定 |

⑤a と ⑤b は同じ Bob を奪い合う。`priority` の高い ⑤a が先に確保し、
⑤b は空くまで押し出される。

## 学ぶ内容

- [`scheduling`][scheduling] — `asap` (前詰め) と `alap` (後ろ詰め)
- [`start`][start] / [`end`][end] — 日付による固定
- [`minstart`][minstart] / [`maxstart`][maxstart] / [`minend`][minend] / [`maxend`][maxend] — 日付による事後検査
- [`warn`][warn] / [`fail`][fail] — 論理式による事後検査
- [`priority`][priority] — リソース競合時にどちらが先に確保するか
- [`precedes`][precedes] — [`depends`][depends] の逆向き
- [`responsible`][responsible] / [`flags`][flags] — 分類用の属性

## ASAP と ALAP

| 方向 | 必要な条件 | 意味 |
|---|---|---|
| ASAP (既定) | 開始側の条件 (`start` / `depends`) | できるだけ早く |
| ALAP | 終了側の条件 (`end` / `precedes`) | できるだけ遅く |

`scheduling` は他の属性から暗黙に上書きされうるので、
公式ドキュメントの推奨どおり**タスクの最後に書く**。

## 事後検査の3種

いずれもスケジューリングには使われず、**配置し終えた後に検査される**。

| 手段 | 違反時 | 用途 |
|---|---|---|
| `minstart` / `maxstart` / `minend` / `maxend` | エラー (停止) | 絶対に守るべき期限 |
| `warn <論理式>` | 警告 (終了コードは 0) | 監視したい条件 |
| `fail <論理式>` | エラー | 論理式で表す厳格な条件 |

論理式の中では属性を `plan.end` のように**シナリオ ID 付き**で参照する。

## ハマりどころ

1. `priority` は「重要度」ではなく「**リソース獲得の優先順位**」。
   既定 500、範囲 1〜1000。リソースを持たないタスク (マイルストーン) には効かない
2. ASAP と ALAP を混ぜると**スケジューリングが重くなる**。
   公式マニュアルによれば数百タスク規模で 2〜10 倍の時間差が出ることがあり、
   依存チェーンが絡むと優先度が高いタスクがリソースを取れない事態も起きうる
3. `flags` は**使う前にトップレベルで宣言**しておく必要がある
4. `responsible` はドキュメント用途のみでスケジューリングに影響しない

## 得られるもの

「この日までに終わらせたい」「この日から始める」「競合したらこちらを優先」という
現実の制約を、スケジューラへの指示として表現できるようになる。
`warn` を使えば、計画が条件を外れたことを自動で検知できる。

---

← [04. カレンダー](../04-calendar/README.md) | [README (全体)](../README.md) | 次 → [06. 進捗と実績](../06-progress/README.md)

<!-- 公式リファレンス (https://taskjuggler.org/tj3/manual/) -->

[scheduling]: https://taskjuggler.org/tj3/manual/scheduling.html
[start]: https://taskjuggler.org/tj3/manual/start.html
[end]: https://taskjuggler.org/tj3/manual/end.html
[minstart]: https://taskjuggler.org/tj3/manual/minstart.html
[maxstart]: https://taskjuggler.org/tj3/manual/maxstart.html
[minend]: https://taskjuggler.org/tj3/manual/minend.html
[maxend]: https://taskjuggler.org/tj3/manual/maxend.html
[warn]: https://taskjuggler.org/tj3/manual/warn.html
[fail]: https://taskjuggler.org/tj3/manual/fail.html
[priority]: https://taskjuggler.org/tj3/manual/priority.html
[precedes]: https://taskjuggler.org/tj3/manual/precedes.html
[depends]: https://taskjuggler.org/tj3/manual/depends.html
[responsible]: https://taskjuggler.org/tj3/manual/responsible.html
[flags]: https://taskjuggler.org/tj3/manual/flags.task.html
