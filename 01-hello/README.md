# 01. 基礎

TaskJuggler の最小構成。プロジェクトを宣言し、人を定義し、タスクを並べ、HTML レポートを出すまでの一往復を通す。

## 学ぶ内容

- [`project`][project] の宣言 — ID / 名前 / 開始日 / 期間 (`+2m` のような相対指定)
- [`timezone`][timezone] / [`timeformat`][timeformat] / [`now`][now] の設定
- [`resource`][resource] と [`task`][task] の宣言
- 期間の3つの指定方法の違い
  - **[effort][effort]** — 人的工数。担当者が割り当たって初めて期間が決まる
  - **[duration][duration]** — 暦時間ベース。担当者に依存しない
  - **[length][length]** — 稼働日ベース。休日は数えないが担当者の負荷には依存しない
- [`allocate`][allocate] による担当割当
- [`depends`][depends] による直列化 (`!` は兄弟タスクを指す)
- [`taskreport`][taskreport] による HTML 出力

## 実行結果

| タスク | 開始 | 終了 | 指定 |
|---|---|---|---|
| 設計 | 2026-08-03 | 2026-08-07 | `effort 5d` + Alice |
| 実装 | 2026-08-10 | 2026-08-21 | `effort 10d` + Bob |
| レビュー | 2026-08-21 | 2026-08-24 | `duration 3d` (担当なし) |

実装が 08-10 始まりなのは、設計の完了 (08-07 金) を待って翌営業日から始まるため。
レビューは `duration` 指定なので担当者が不要で、暦の3日で終わる。

## 気をつけるポイント

- `effort` を指定したタスクは `allocate` がないとスケジュールされない。
  担当を付けずに期間を確保したいなら `duration` か `length` を使う

## 得られるもの

tjp を書いて `tj3` に通し、結果を確認するというサイクルが回せるようになる。
`effort` と `duration` の使い分けは以降すべての段階で前提になるので、
ここで数字の差を見て納得しておくと後が楽。

---

← [README (全体)](../README.md) | 次 → [02. 構造](../02-structure/README.md)

<!-- 公式リファレンス (https://taskjuggler.org/tj3/manual/) -->

[project]: https://taskjuggler.org/tj3/manual/project.html
[timezone]: https://taskjuggler.org/tj3/manual/timezone.html
[timeformat]: https://taskjuggler.org/tj3/manual/timeformat.html
[now]: https://taskjuggler.org/tj3/manual/now.html
[resource]: https://taskjuggler.org/tj3/manual/resource.html
[task]: https://taskjuggler.org/tj3/manual/task.html
[effort]: https://taskjuggler.org/tj3/manual/effort.html
[duration]: https://taskjuggler.org/tj3/manual/duration.html
[length]: https://taskjuggler.org/tj3/manual/length.html
[allocate]: https://taskjuggler.org/tj3/manual/allocate.html
[depends]: https://taskjuggler.org/tj3/manual/depends.html
[taskreport]: https://taskjuggler.org/tj3/manual/taskreport.html
