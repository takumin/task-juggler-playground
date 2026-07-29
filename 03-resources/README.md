# 03. リソース

「誰が」を精密に表現する。ここから実プロジェクトのモデルに近づく。

すべてのタスクを 08-03 から並列に走らせ、**割当条件の違いだけ**で期間がどう変わるかを
比較できるようにしてある (タスクごとに専用の担当を割り当ててリソース競合を排除している)。

## 学ぶ内容

- [`resource`][resource] の入れ子によるチーム階層、[`managers`][managers]
- 複数リソースの [`allocate`][allocate] — 並行投入で期間が縮む
- 割当の選択制御 — [`alternative`][alternative] / [`select`][select] / [`persistent`][persistent] / [`mandatory`][mandatory]
- [`efficiency`][efficiency] — 生産性の係数。チームや設備のモデル化にも使う
- [`limits`][limits] — 1日/1週/1月あたりの上限
- [`purge`][purge] — 継承した属性のリセット

## 実行結果

同じ **10 人日** のタスクを、割当条件だけ変えた比較。

| # | 条件 | 期間 | 結果 |
|---|---|---|---|
| ① | 単独作業 | 08-03 → 08-14 | 10 営業日 |
| ② | 2名を投入 | 08-03 → 08-07 | 5 営業日 (工数を分担) |
| ③ | `efficiency 0.5` | 08-03 → 08-28 | 20 営業日 (半人前) |
| ④ | `limits { dailymax 4h }` | 08-03 → 08-28 | 20 営業日 (1日4hまで) |
| ⑤ | `alternative` + `select` | 08-03 → 08-14 | Grace が選ばれた |
| ⑥ | 会議 (`mandatory` × 2) | 08-03 | 工数 0.3 (会議室は 0 人日) |

## select の選び方

| 値 | 意味 |
|---|---|
| `minallocated` | 割当係数が最小の人 (**既定**) |
| `minloaded` | 使用実績が最も少ない人 |
| `maxloaded` | 使用実績が最も多い人 |
| `order` | リストの先頭から |
| `random` | ランダム |

`persistent` を付けると、いったん選んだ担当を最後まで固定する。
付けないと空きに応じて途中で担当が入れ替わりうる。

## 気をつけるポイント

- **`limits` を書く場所で意味が変わる**
  - `resource` の中 → そのリソースの全タスク合計に効く
  - `task` の中 → そのタスクの消費量に効く
  - `allocate` の中 → その割当だけに効く
- `efficiency 0.0` は「工数を提供しない」。会議室やプロジェクタなど、
  予約は必要だが作業しないものをモデル化するのに使う
- `efficiency 5.0` で「5人チーム」を1リソースとして扱えるが、
  **メンバー個別の追跡はできなくなる**
- `managers` はスケジューリングに一切影響しない (ドキュメント用途のみ)。
  指定できるのは葉リソースだけ
- 親リソースに書いた属性は子に継承される。断ち切るには `purge`

## 得られるもの

「人を増やせば早く終わるのか」「兼務者をどう表現するか」「設備の予約をどう扱うか」
といった現実的な問いを、tjp の記述に落とせるようになる。
リソース競合が起きたときの挙動は 05 の `priority` で扱う。

---

← [02. 構造](../02-structure/README.md) | [README (全体)](../README.md) | 次 → [04. カレンダー](../04-calendar/README.md)

<!-- 公式リファレンス (https://taskjuggler.org/tj3/manual/) -->

[resource]: https://taskjuggler.org/tj3/manual/resource.html
[managers]: https://taskjuggler.org/tj3/manual/managers.html
[allocate]: https://taskjuggler.org/tj3/manual/allocate.html
[alternative]: https://taskjuggler.org/tj3/manual/alternative.html
[select]: https://taskjuggler.org/tj3/manual/select.html
[persistent]: https://taskjuggler.org/tj3/manual/persistent.html
[mandatory]: https://taskjuggler.org/tj3/manual/mandatory.html
[efficiency]: https://taskjuggler.org/tj3/manual/efficiency.html
[limits]: https://taskjuggler.org/tj3/manual/limits.resource.html
[purge]: https://taskjuggler.org/tj3/manual/purge.html
