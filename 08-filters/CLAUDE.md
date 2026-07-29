# CLAUDE.md — 08. 論理式とフィルタ

TaskJuggler 学習用プレイグラウンドの **第 08 段階 (論理式によるフィルタリング)**。

## 前提

- 対象は TaskJuggler 3.8.4 (Ruby 4.0 上で bundler 管理)
- `tj3` は bundler 経由でのみ使える。必ず `bundle exec tj3` で呼ぶ
- **コマンドはすべてリポジトリルート (このディレクトリの1つ上) から実行する**

## ファイル

| ファイル | 内容 |
|---|---|
| `filters.tjp` | 教材本体。フィルタ条件だけ変えた 10 レポートが入っている |
| `README.md` | 学習内容の説明 |
| `out/` | 生成物。再生成できるので消してよい |

## 実行

```sh
bundle exec tj3 -o 08-filters/out 08-filters/filters.tjp
```

## 結果の確認方法

```sh
ruby tools/dump-report.rb 08-filters/out/01-leaves.html
```

## この段階で扱うキーワード

`logicalexpression` `functions` `hidetask` `hideresource` `hidereport`
`hidejournalentry` `rolluptask` `flags.task` `logicalflagexpression`
`isleaf` `ismilestone` `istask` `isresource` `ischildof` `isdutyof`
`isdependencyof` `treelevel` `isongoing` `isactive` `hasalert`

構文は推測せず `bundle exec tj3man <キーワード>` で確認する。

## 論理式の書き方

```
~   否定        &   かつ        |   または
```

- 属性はシナリオ ID 付きで参照 (`plan.effort`、`plan.id`)。
  非シナリオ属性 (`id`、`name`) でも必要
- `hide〜` は「隠す条件」。「〜だけ表示」は `~` で反転
- 宣言済みフラグ名はそのまま条件になる

### 関数の引数

| 引数 | 関数 |
|---|---|
| なし | `isleaf()` `treelevel()` `istask()` `isresource()` |
| シナリオ ID | `ismilestone(plan)` `isactive(plan)` `isongoing(plan)` |
| その他 | `ischildof(ID)` `isdutyof(ID, シナリオ)` `isdependencyof(ID, シナリオ, 距離)` |

### `_` サフィックス

関数名末尾の `_` は「スコープ側 (囲んでいるプロパティ) で評価する」の意味。
`hideresource ~(isleaf() & isleaf_())` = 葉リソースを葉タスクの下にだけ表示。

## 既知の落とし穴 (すべて実測で確認済み)

- **比較演算子は `&` `|` より結合が弱い**。
  `a() | plan.id = "x"` は `(a() | plan.id) = "x"` と解釈されてエラーになる。
  **比較は必ず括弧で囲む**
- **関数に渡すタスク ID はルートからのフルパス**。
  短く書くと一致せず、**エラーも出ないまま結果が空になる**。
  結果が空のときはまずこれを疑う
- **`isdependencyof(X, ...)` は名前と逆**。「X が依存している先行タスク」を返す。
  距離の実測値は README を参照
- 関数の引数の数が合わないと `Wrong number of arguments` エラー
- ツリーモード (既定) では条件に合わなくても親は表示される

## 作業方針

- tjp を変更したら必ず実行し、結果を確認してから回答する
- **フィルタが期待どおりか必ず出力で確認する**。
  論理式は間違っていても空の結果を返すだけでエラーにならないことが多い
- 新しい論理式を提案するときは、比較部分を括弧で囲んだ形で書く
- 「こう絞りたい」という要望には、まず既存の 10 レポートに近いものがないか探す
