# 07. レポート

TaskJuggler の出力はすべてここに集約される。同じプロジェクトデータから、
見せ方の違うレポートを何種類も出す。

## レポートの内容

| ファイル | 内容 |
|---|---|
| `01-basic.html` / `.csv` | 基本形。HTML と CSV を同時出力 |
| `02-styled.html` | 列のカスタマイズ (見出し・条件付き背景色・文言差し替え) |
| `03-summary.html` | `rolluptask` で第1階層だけに畳んだサマリー |
| `04-sorted.html` | 工数の多い順にソート、葉タスクのみ |
| `05-weekly.html` | 週次の工数配分 (時系列集計) |
| `06-people.html` | リソース別の負荷 |
| `07-export.tjp` | スケジュール結果を tjp として書き出したもの |
| `index.html` | 上記を埋め込んだ合成ページ |

## 学ぶ内容

- レポート種別 — `taskreport` / `resourcereport` / `textreport` / `accountreport` /
  `tracereport` / `export` / `icalreport` / `nikureport`
- `columns` と列のカスタマイズ — `title` / `cellcolor` / `celltext` / `scale` / `width`
- `formats` — html / csv の同時出力
- 表示範囲 — `period` / `loadunit` / `scenarios`
- 折りたたみ — `rolluptask` / `rollupresource` / `opennodes`
- 並び替え — `sorttasks` / `sortresources`
- 合成 — `textreport` と `navigator`

## CSV 出力の例

```csv
"Name";"Start";"End";"Effort";"Completion";
"フェーズ1: 開発";"2026-08-03";"2026-08-25";17.0;"70%";
"  設計";"2026-08-03";"2026-08-07";5.0;"100%";
"  実装";"2026-08-10";"2026-08-25";12.0;"40%";
```

区切り文字はセミコロン。階層はインデントで表現される。
`chart` 列は CSV では無視される。

## textreport によるページ合成

`textreport` は header / center (left・right マージンつき) / footer の
5 つの Rich Text 区画からなる。区画の中に他のレポートを埋め込める。

```
-8<- ... ->8-          Rich Text ブロックの囲み
== 見出し ==            見出し
<[report id="basic"]>  他レポートの埋め込み
<[navigator id="nav"]> ナビゲーションバーの埋め込み
```

## 気をつけるポイント

- **`export` は `-o` / `outputdir` が効かない**。常にカレントディレクトリ基準になるので、
  出力先を揃えたいならファイル名側にパスを書く。拡張子は自動で付く
  (project ヘッダを含むなら `.tjp`、断片なら `.tji`)
- 論理式の中では属性を `plan.effort` のようにシナリオ ID 付きで参照する
- `celltext` / `cellcolor` は「条件に合うセルだけ」を書き換える。
  全セルに適用したいなら `@all` を使う
- 埋め込み元のレポートも `formats` を指定していれば単体ファイルとしても生成される。
  埋め込み専用にしたいなら `formats` を書かない
- `accountreport` と `formats.export` は「未テスト」警告つきの機能

## 得られるもの

計画データは同じでも、報告先に応じて見せ方を変えられるようになる。
経営向けのサマリー、担当者向けの詳細、他ツール連携用の CSV を
1 つの tjp から同時に出力できる。

条件で「何を出すか」を絞る方法は 08 で扱う。

---

← [06. 進捗と実績](../06-progress/README.md) | [README (全体)](../README.md) | 次 → [08. フィルタ](../08-filters/README.md)
