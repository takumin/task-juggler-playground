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

- [`taskreport`][taskreport] / [`resourcereport`][resourcereport] — タスク視点とリソース視点の表・ガント
- [`textreport`][textreport] / [`navigator`][navigator] — 他のレポートを埋め込んだページの合成
- [`export`][export] — スケジュール結果を tjp として書き出す。他ツール向けには
  [`tracereport`][tracereport] / [`icalreport`][icalreport] / [`nikureport`][nikureport] もある (この教材では未使用)
- [`columns`][columns] — レポートに出す列の選択
- [`title`][title] / [`cellcolor`][cellcolor] / [`celltext`][celltext] — 列のカスタマイズ
- [`formats`][formats] — html / csv の同時出力
- [`period`][period] / [`loadunit`][loadunit] — 表示範囲と単位
- [`rolluptask`][rolluptask] — 階層の折りたたみ
- [`sorttasks`][sorttasks] — 並び替え

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

## ハマりどころ

1. `celltext` / `cellcolor` は「条件に合うセルだけ」を書き換える。
   全セルに適用したいなら `@all` を使う
2. 埋め込み元のレポートも `formats` を指定していれば単体ファイルとしても生成される。
   埋め込み専用にしたいなら `formats` を書かない
3. `export` に指定する `formats` (`formats.export`) は「未テスト」警告つきの機能

## 得られるもの

計画データは同じでも、報告先に応じて見せ方を変えられるようになる。
経営向けのサマリー、担当者向けの詳細、他ツール連携用の CSV を
1 つの tjp から同時に出力できる。

条件で「何を出すか」を絞る方法は 08 で扱う。

---

← [06. 進捗と実績](../06-progress/README.md) | [README (全体)](../README.md) | 次 → [08. フィルタ](../08-filters/README.md)

<!-- 公式リファレンス (https://taskjuggler.org/tj3/manual/) -->

[taskreport]: https://taskjuggler.org/tj3/manual/taskreport.html
[resourcereport]: https://taskjuggler.org/tj3/manual/resourcereport.html
[textreport]: https://taskjuggler.org/tj3/manual/textreport.html
[tracereport]: https://taskjuggler.org/tj3/manual/tracereport.html
[export]: https://taskjuggler.org/tj3/manual/export.html
[icalreport]: https://taskjuggler.org/tj3/manual/icalreport.html
[nikureport]: https://taskjuggler.org/tj3/manual/nikureport.html
[columns]: https://taskjuggler.org/tj3/manual/columns.html
[title]: https://taskjuggler.org/tj3/manual/title.column.html
[cellcolor]: https://taskjuggler.org/tj3/manual/cellcolor.column.html
[celltext]: https://taskjuggler.org/tj3/manual/celltext.column.html
[formats]: https://taskjuggler.org/tj3/manual/formats.html
[period]: https://taskjuggler.org/tj3/manual/period.report.html
[loadunit]: https://taskjuggler.org/tj3/manual/loadunit.html
[rolluptask]: https://taskjuggler.org/tj3/manual/rolluptask.html
[sorttasks]: https://taskjuggler.org/tj3/manual/sorttasks.html
[navigator]: https://taskjuggler.org/tj3/manual/navigator.html
