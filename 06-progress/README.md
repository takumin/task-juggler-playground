# 06. 進捗と実績

計画を立てた後、実績を入れて追跡する。ここから「動いているプロジェクト」の管理になる。

`now` を 08-17 に置き、それ以前の実績を `booking` で与える。TaskJuggler は
`now` より前には新たな割当をせず、**残作業だけを `now` 以降に再配置する**
(projection モード)。

## 学ぶ内容

- [`trackingscenario`][trackingscenario] — 実績を記録するシナリオの指定
- [`booking`][booking] — 実際に作業した時間の記録
- [`sloppy`][sloppy] — booking の衝突チェックの緩さ
- [`complete`][complete] — 進捗率の手入力
- [`now`][now] の位置とスケジュール結果の関係

## 実行結果

`now = 2026-08-17` のときのスケジュール。

| タスク | 開始 | 終了 | 進捗 | ゲージ |
|---|---|---|---|---|
| ① 予定どおり完了 | 08-03 | 08-07 | 100% | on schedule |
| ② 半分だけ進んだ | 08-10 | 08-21 | 50% | on schedule |
| ③ 進捗率のみ手入力 | 08-17 | 08-21 | 60% | ahead of schedule |
| ④ 未着手 (②待ち) | 08-24 | 08-28 | 0% | on schedule |

② は 10 人日のうち 5 人日ぶんの実績があり、**残り 5 人日が `now` 以降に
再スケジュールされて** 08-21 終了になっている。
③ は booking がないので `now` から開始する扱いになり、`complete 60` との
ギャップが "ahead of schedule" として出ている。

## booking と complete の違い

| | booking | complete |
|---|---|---|
| スケジューラへの影響 | **あり** (残作業を再計算) | **なし** |
| 用途 | 正確な実績追跡 | TODO リスト的な簡易管理 |
| 表示 | 工数・日付に反映 | `complete` / `gauge` 列とガントの塗り分けのみ |

## sloppy の値

`booking` の区間が非稼働時間と衝突したときの扱い。

| 値 | 許容する内容 |
|---|---|
| `0` (既定) | 非稼働時間・休暇・他タスクの割当を一切含めない |
| `1` | 非稼働時間は含んでよい |
| `2` | 非稼働時間と休暇を含んでよい |

日付境界で書くなら `sloppy 2` が扱いやすい。
`booking alice 2026-08-03 - 2026-08-08 { sloppy 2 }` で「8/3〜8/7 の稼働時間ぶん」= 5人日。

## 気をつけるポイント

- **`project` ヘッダの日付は `timezone` を読む前に UTC で解釈される**。
  `2026-08-03` と書くと開始は `08-03 09:00 JST` になり、
  `booking` で 8/3 0:00 を指すと「プロジェクト期間外」エラーになる。
  この教材では開始を `2026-08-01` に広げて回避している
- 区間の終了日は 0 時に展開されるので**終了日当日は含まれない**
- `projection` キーワードは**非推奨**。booking があれば projection モードは自動で有効になる
- `effortdone` / `effortleft` は「未テスト」警告つきの機能。使うなら結果を検証すること
- 公式ドキュメントいわく、booking は本来**エクスポートで機械生成するもの**。
  手書き用に `sloppy` / `overtime` が用意されている

## 得られるもの

計画と実績のズレを数値で把握し、残作業がいつ終わるのかを再計算させられるようになる。
実績を別ファイルに分離する実務パターンは 11 の `supplement` で扱う。

---

← [05. 制約](../05-constraints/README.md) | [README (全体)](../README.md) | 次 → [07. レポート](../07-reports/README.md)

<!-- 公式リファレンス (https://taskjuggler.org/tj3/manual/) -->

[trackingscenario]: https://taskjuggler.org/tj3/manual/trackingscenario.html
[booking]: https://taskjuggler.org/tj3/manual/booking.task.html
[sloppy]: https://taskjuggler.org/tj3/manual/sloppy.booking.html
[complete]: https://taskjuggler.org/tj3/manual/complete.html
[now]: https://taskjuggler.org/tj3/manual/now.html
