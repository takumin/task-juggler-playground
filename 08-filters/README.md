# 08. 論理式とフィルタ

レポートに「何を出すか」を条件で書く。07 と対になる段階。

同じタスクツリーに対して `hidetask` / `hideresource` の条件だけを変えた
レポートを 10 種類並べてある。

## レポートの内容

| ファイル | フィルタ条件 |
|---|---|
| `01-leaves.html` | `~isleaf()` — 葉タスクのみ |
| `02-milestones.html` | `~ismilestone(plan)` — マイルストーンのみ |
| `03-subtree.html` | `~(ischildof(phase1) \| (plan.id = "phase1"))` — 特定サブツリー |
| `04-critical.html` | `~critical` — フラグで絞る |
| `05-heavy.html` | `~(plan.effort > 5.0)` — 属性値の比較 |
| `06-combo.html` | `~(isleaf() & ~critical)` — 条件の組み合わせ |
| `07-toplevel.html` | `treelevel() > 1` — 階層の深さ |
| `08-bob.html` | `~isdutyof(bob, plan)` — 担当者で絞る |
| `09-predecessors.html` | `~isdependencyof(phase2.gate2, plan, 0)` — 依存の連鎖 |
| `10-nested.html` | `~(isleaf() & isleaf_())` — スコープ側で評価 |

## 論理式の基本

```
~   否定        &   かつ        |   または
```

- 属性は**シナリオ ID 付き**で参照する (`plan.effort`、`plan.id`)。
  非シナリオ属性 (`id`、`name`) でもシナリオ ID が必要
- 宣言済みのフラグ名はそのまま条件として書ける
- `hide〜` は「**隠す**条件」。「〜だけ表示」は `~` で反転させる

## 関数の引数

関数によって必要な引数が違う。

| 引数 | 関数 |
|---|---|
| なし | `isleaf()` `treelevel()` `istask()` `isresource()` |
| シナリオ ID | `ismilestone(plan)` `isactive(plan)` `isongoing(plan)` |
| その他 | `ischildof(ID)` `isdutyof(ID, シナリオ)` `isdependencyof(ID, シナリオ, 距離)` |

## `_` サフィックス (スコープ側で評価)

タスクレポートの中にリソース行をネストさせると、リソース行にとっての
「スコープ」は囲んでいるタスクになる。関数名の末尾に `_` を付けると、
その関数は**スコープ側**を対象に評価される。

```
hideresource ~(isleaf() & isleaf_())
```

- `isleaf()` — リソースが葉かどうか
- `isleaf_()` — 囲んでいるタスクが葉かどうか

結果として「葉リソースを、葉タスクの下にだけ表示する」という意味になる。

## 気をつけるポイント

- **比較演算子は `&` `|` より結合が弱い**。
  `a() | plan.id = "x"` は `(a() | plan.id) = "x"` と解釈されて
  `First operand ... must be a date, a number or a string` エラーになる。
  **比較は必ず括弧で囲む**
- **関数に渡すタスク ID はルートからのフルパス**。
  ネストしたタスクを短く書いても一致せず、**エラーも出ないまま結果が空になる**
- **`isdependencyof(X, ...)` は名前と逆**で、「X が依存している**先行**タスク」と
  X 自身を返す。後続タスクではない
- ツリーモード (既定) では、条件に合わなくても**親は表示される**。
  ツリー構造を保つための仕様

## isdependencyof の距離 (実測)

起点を `phase2.gate2` (最後のマイルストーン) にした場合。

| 距離 | 抽出されるタスク |
|---|---|
| `1` | フェーズ2, リリース (直前まで) |
| `2` | さらにフェーズ1配下と不具合対応まで |
| `0` | 距離を問わず全ての先行タスク |

## 得られるもの

「担当者ごとの作業一覧」「遅れているタスクだけ」「このフェーズの配下だけ」といった
切り口のレポートを、データを複製せずに条件だけで作り分けられるようになる。

---

← [07. レポート](../07-reports/README.md) | [README (全体)](../README.md) | 次 → [09. シナリオ](../09-scenarios/README.md)
