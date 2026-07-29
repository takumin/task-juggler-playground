# 04. カレンダー

「いつ働けるか」を定義する。日本の稼働日・祝日をここで扱う。

全員に同じ **10 人日**のタスクを割り当て、カレンダー設定の違いだけで終了日が
どれだけずれるかを比較できるようにしてある。

## レポートの内容

| ファイル | 内容 |
|---|---|
| `tasks.html` | カレンダー設定による期間の違い |
| `people.html` | 稼働状況 (ガントの網掛けが非稼働) |

同じ **10 人日**を、カレンダー条件だけ変えて比較。

| # | 条件 | 期間 |
|---|---|---|
| ① | 標準 (8h/日、山の日を挟む) | 08-03 → 08-17 |
| ② | 夏季休暇あり (8/13〜8/16) | 08-03 → 08-19 |
| ③ | 時短シフト (3h/日) | 08-03 → 09-09 |
| ④ | 週4日勤務 (金曜休み) | 08-03 → 08-19 |

祝日と休暇が実際にどこで空いているかは `people.html` の網掛けで確認できる。

## 学ぶ内容

- `workinghours` — 稼働時間帯。[project][workinghours.project] / [resource][workinghours.resource] / [shift][workinghours.shift] の3レベルで指定する
- [`dailyworkinghours`][dailyworkinghours] / [`yearlyworkingdays`][yearlyworkingdays] — 工数と日数の換算係数
- [`leaves`][leaves] — 祝日・休暇の定義
- [`shift`][shift] / [`shifts`][shifts] — 稼働時間パターンの定義とリソースへの割当

## leaves の種別と優先度

優先度の低い順に並ぶ。**高い種別は低い種別を上書きできる**。

```
project < annual < special < sick < unpaid < holiday < unemployed
```

グローバル (トップレベル) に書いた `leaves` は以降のリソース定義すべてに継承される。
リソース側でより優先度の高い種別を書けば上書きできる。

## ハマりどころ

1. 区間の終了日は 0 時に展開されるため、**終了日当日は含まれない**。
   `2026-08-13 - 2026-08-17` は「8/13〜8/16 の4日間」を意味する
2. `leaves` は `project {}` の中ではなく**トップレベル (properties スコープ)** に書く
3. 日本の祝日は自動では入らない。`leaves holiday` で明示的に定義する
   (入れたぶんプロジェクトは延びる)
4. `dailyworkinghours` は `workinghours` の実態と揃えておく。
   ずれると `length` 指定やレポートの日数表示が実態と合わなくなる
5. `shift` を割り当てる属性は `shifts`。旧 `shift` は**非推奨**

## 得られるもの

日本の営業日カレンダーを反映した、実務で使える精度のスケジュールが引けるようになる。
時短勤務・週4日勤務・長期休暇といった働き方の違いも、そのまま計画に織り込める。

---

← [03. リソース](../03-resources/README.md) | [README (全体)](../README.md) | 次 → [05. 制約](../05-constraints/README.md)

<!-- 公式リファレンス (https://taskjuggler.org/tj3/manual/) -->

[workinghours.project]: https://taskjuggler.org/tj3/manual/workinghours.project.html
[workinghours.resource]: https://taskjuggler.org/tj3/manual/workinghours.resource.html
[workinghours.shift]: https://taskjuggler.org/tj3/manual/workinghours.shift.html
[dailyworkinghours]: https://taskjuggler.org/tj3/manual/dailyworkinghours.html
[yearlyworkingdays]: https://taskjuggler.org/tj3/manual/yearlyworkingdays.html
[leaves]: https://taskjuggler.org/tj3/manual/leaves.html
[shift]: https://taskjuggler.org/tj3/manual/shift.html
[shifts]: https://taskjuggler.org/tj3/manual/shifts.resource.html
