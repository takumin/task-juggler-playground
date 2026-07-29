# 01. 基礎

TaskJuggler の最小構成。プロジェクトを宣言し、人を定義し、タスクを並べ、HTML レポートを出すまでの一往復を通す。

あわせて、期間の指定方法 (`effort` / `duration` / `length`) を**同じ 10d で並べて**
比較できるようにしてある。ここが以降すべての段階の土台になる。

## 学ぶ内容

- [`project`][project] — ID / 名前 / 開始日 / 期間 (`+2m` のような相対指定)
- [`timezone`][timezone] / [`timeformat`][timeformat] / [`now`][now] — 時刻の扱いと表示形式
- [`resource`][resource] / [`task`][task] — 人とタスクの宣言
- [`effort`][effort] — 人的工数。担当者が割り当たって初めて期間が決まる
- [`duration`][duration] — 暦時間ベースの期間。担当者に依存しない
- [`length`][length] — 稼働日ベースの期間。休日は数えないが担当者の負荷には依存しない
- [`allocate`][allocate] — タスクへの担当割当
- [`depends`][depends] — 依存による直列化 (`!` は兄弟タスクを指す)
- [`taskreport`][taskreport] — HTML レポートの出力

## 実行結果

依存でつないだ3タスク。

| タスク | 開始 | 終了 | 指定 |
|---|---|---|---|
| 設計 | 2026-08-03 | 2026-08-07 | `effort 5d` + Alice |
| 実装 | 2026-08-10 | 2026-08-21 | `effort 10d` + Bob |
| レビュー | 2026-08-21 | 2026-08-24 | `duration 3d` (担当なし) |

実装が 08-10 始まりなのは、設計の完了 (08-07 金) を待って翌営業日から始まるため。
レビューは `duration` 指定なので担当者が不要で、暦の3日で終わる。

## 期間の指定 — effort / duration / length

**この段階で唯一、絶対に取り違えてはいけないところ。**
以降の段階で出てくる日付はすべてこの3つのどれかで決まっており、
ここを誤解したまま進むと「なぜこの日付になるのか」が最後まで追えなくなる。

3つは「何を宣言しているか」が違う。期間はその結果として決まる。

| 指定 | 宣言しているもの | 担当 | 期間の決まり方 |
|---|---|---|---|
| `effort` | **仕事の量** (人日) | **必須** | 担当の空き時間から逆算される |
| `duration` | **暦の長さ** | 任意 | 宣言どおり。土日・祝日も消費する |
| `length` | **稼働日の長さ** | 任意 | 宣言どおり。土日・祝日は数えない |

### 同じ 10d を3通りで指定した結果

tjp の「比較:」で始まる3タスクがこれにあたる。
依存を張っていないので3本とも 08-03 (月) から並列に走り、違いは指定方法だけ。

| 指定 | 開始 | 終了 | 工数 |
|---|---|---|---|
| `effort 10d` + Carol | 2026-08-03 | 2026-08-14 | 10.0 |
| `duration 10d` | 2026-08-03 | **2026-08-13** | 0.0 |
| `length 10d` | 2026-08-03 | 2026-08-14 | 0.0 |

- `duration` だけ 1 日早く終わる。8/8・8/9 の土日も「経過した」と数えるため
- `effort` と `length` は**担当が1人なら同じ結果になる**。
  違いが出るのは担当を増やしたときで、`effort` だけが縮み `length` は動かない
  (増員の効果は 03 で実測する)
- 工数 0.0 は「誰の時間も使っていない」の意味。`duration` / `length` は
  期間を押さえるだけで、担当を割り当てなければ誰の負荷にもならない

### allocate が期間を変えるのは effort のときだけ

`allocate` は「誰がやるか」の指定だが、スケジュールへの効き方は指定方法で変わる。

| 組み合わせ | 結果 |
|---|---|
| `effort` + `allocate` | 担当の空きから期間が決まる |
| `effort` のみ | **エラーで停止** (`Task x has an effort but no resource allocations.`) |
| `duration` / `length` + `allocate` | 期間は変わらない。その期間ぶん担当が拘束され工数が乗る |
| `duration` / `length` のみ | 期間だけ確保。工数は 0 |

`duration 10d` に担当を付けると、終了は 08-13 のままで工数だけ 8.0 になる
(暦 10 日のうち稼働日は 8 日ぶん)。`length 10d` なら 10.0 (実測)。
どちらも**期間は動かない**。

### 使い分けの目安

| 何を表現したいか | 指定 |
|---|---|
| 人が手を動かす作業。増員や稼働率を計画に反映させたい | `effort` |
| 外部レビュー・検査・輸送などの**待ち時間** | `duration` |
| 「営業日で n 日ぶんの枠」だけ確保したい (担当の負荷は見ない) | `length` |

迷ったら `effort` を選ぶ。人の作業を `duration` で書くと、
担当を増やしても稼働時間を変えても計画がまったく反応しなくなる。

## ハマりどころ

1. 人が手を動かす作業は `effort` で書く。`duration` / `length` は期間を先に
   決めてしまうので、増員や稼働率の変更に**計画が反応しない**
2. `effort` を書いたタスクに `allocate` が無いと**エラーで止まる**。
   担当を決めずに枠だけ取りたいなら `duration` か `length` を使う
3. `duration` / `length` に `allocate` を足しても**期間は変わらない**。
   変わるのは担当の負荷 (工数) だけ
4. `depends` の `!` は「**親を起点**」、つまり兄弟タスクを指す。
   階層をまたぐパスの書き方は 02 で扱う
5. `now` はレポートの「今日」の位置。ここでは表示上の基準線だが、
   06 で実績を入れると**計画そのものに効いてくる**

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
