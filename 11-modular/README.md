# 11. モジュール化と拡張

規模が大きくなったときのファイル構成。計画と実績を別ファイルに分け、
定型部分をマクロにまとめ、独自の属性を足す。

## レポートの内容

| ファイル | 内容 |
|---|---|
| `01-plan.html` | 計画とチケット番号 (ユーザー定義属性を列にしたもの) |
| `02-progress.html` | 実績を反映した状態 (`now = 2026-08-17`) |
| `03-people.html` | リソース一覧 (Slack ID つき) |

### 実行結果

| タスク | チケット | SP | 開始 | 終了 |
|---|---|---|---|---|
| 設計 | PROJ-101 | 8 | 08-03 | 08-07 |
| 実装 | PROJ-102 | 21 | 08-10 | 08-25 |
| コードレビュー | REVIEW | 3 | 08-25 | 08-28 |
| フェーズ2 | | | 08-31 | 09-06 |
| ├ デプロイ | PROJ-201 | 2 | 08-31 | 09-01 |
| └ 経過観察 | REVIEW | 1 | 09-01 | 09-06 |

チケット番号と見積 SP の 2 列は `extend` で足した独自の属性。
デプロイと経過観察は `subtasks.tji` から `taskprefix phase2` で流し込まれている。

## 学ぶ内容

- [`include`][include] / [`taskprefix`][taskprefix] — ファイルの取り込みと配置先の指定
- [`macro`][macro] — 定型記述の再利用
- [`supplement`][supplement] — 定義済みのタスク / リソースへの後付け
- [`extend`][extend] — ユーザー定義属性

## ファイル構成

| ファイル | 役割 |
|---|---|
| `main.tjp` | プロジェクトヘッダとレポート定義 |
| `macros.tji` | マクロ定義 |
| `resources.tji` | リソース定義 |
| `tasks.tji` | タスク定義 (計画) |
| `subtasks.tji` | `taskprefix` で親タスク配下に流し込む断片 |
| `actuals.tji` | 実績データ (`supplement`) |

上のソース一覧はこの構成をそのまま並べたもの。分割の仕方自体がこの段階の主題になる。

## マクロ

```
macro DevTask [
  allocate ${1}
  effort ${2}
  Ticket "${3}"
]
```

呼び出しは `${DevTask "alice" "5d" "PROJ-101"}`。
引数は本文中で `${1}` `${2}` と番号で参照し、**必ずダブルクォートで囲む**。

ユーザー定義のマクロ ID は**大文字で始める** (小文字は組み込み用に予約されている)。

## ユーザー定義属性

`project {}` の中で `extend` する。

```
extend task {
  text   Ticket "チケット"
  number Points "見積SP"
}
```

追加した属性はレポートの列としてそのまま使える (`columns name, Ticket, Points`)。
型は `text` / `number` / `date` / `reference` / `richtext`。

## supplement — 計画と実績の分離

```
supplement task design {
  booking alice 2026-08-03 - 2026-08-08 { sloppy 2 }
}
```

計画 (`tasks.tji`) と実績 (`actuals.tji`) を分けておくと、
実績だけを別ツールで生成して差し替えられる。実務で最も効く使い方。

## ハマりどころ

1. `include` はタスク定義の中には**書けない** (`Unexpected token 'include'`)。
   入れ子タスクを別ファイルにするなら、空のコンテナを先に定義し、
   `taskprefix` 付きでトップレベルから include する
2. **読み込み順が重要**。マクロは使う前に定義され、
   `supplement` は対象が定義済みである必要がある
3. パスは「**include を書いたファイルからの相対**」で解決される。実行時の CWD ではない
4. 取り込むファイルは **`.tji` 拡張子**でなければならない (`.tjp` は独立ファイル用)
5. `macro` の閉じ括弧 `]` は**行の最後の文字**にする。
   後ろに空白やコメントがあると閉じたとみなされない
6. `supplement` に渡すのは**ルートからの絶対 ID**
7. `extend` は `project {}` の中に書く

## 得られるもの

数百タスク規模の計画を、破綻せずに保守できる構成が組めるようになる。
チケット番号や見積ポイントといった独自情報も計画データに統合でき、
実績の受け渡しを自動化する下地になる。

---

← [10. コスト](../10-cost/README.md) | [README (全体)](../README.md) | 次 → [12. 運用](../12-operations/README.md)

<!-- 公式リファレンス (https://taskjuggler.org/tj3/manual/) -->

[include]: https://taskjuggler.org/tj3/manual/include.properties.html
[taskprefix]: https://taskjuggler.org/tj3/manual/taskprefix.html
[macro]: https://taskjuggler.org/tj3/manual/macro.html
[supplement]: https://taskjuggler.org/tj3/manual/supplement.html
[extend]: https://taskjuggler.org/tj3/manual/extend.html
