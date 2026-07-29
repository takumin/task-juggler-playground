# 09. シナリオ

同じタスクツリーを、条件だけ変えた複数のシナリオで**同時に**スケジュールし、
結果を横並びで比較する。what-if 分析の基礎。

## レポートの内容

| ファイル | 内容 |
|---|---|
| `01-compare.html` | 3シナリオの比較 (1タスクにつき3行) |
| `02-milestones.html` | リリース日だけを抜き出した比較 |
| `03-gantt.html` | シナリオを重ねたガントチャート |

### 実行結果

3 つのシナリオでリリース日を比較した結果。

| シナリオ | 条件 | リリース日 |
|---|---|---|
| 基本計画 | — | 2026-09-16 |
| 突貫案 | 実装を2人体制 + テスト短縮 | 2026-08-28 |
| 遅延ケース | 設計と実装の工数が膨張 | 2026-10-05 |

同じタスクツリーから、**1 回の実行で** 3 通りの結果が同時に得られる。

## 学ぶ内容

- [`scenario`][scenario] — シナリオの入れ子定義と継承
- [`allocate`][allocate] — シナリオ固有の属性上書き (`crash:allocate` のような書き方)
- [`scenarios`][scenarios] — レポートでの横並び比較

## シナリオの定義

トップレベルのシナリオは**1つだけ**。その中に入れ子で派生を作る。
派生シナリオは親のすべての値を引き継ぎ、**明示的に上書きした属性だけ**が変わる。

```
scenario plan "基本計画" {
  scenario crash "突貫案"
  scenario risk  "遅延ケース"
}
```

既定では `plan` という名前のシナリオが1つだけ存在する。

## シナリオ固有の値

「シナリオ ID : 属性」の形で書く。

```
task impl "実装" {
  effort 20d
  allocate bob

  crash:allocate bob, carol   // 突貫案では2人体制
  risk:effort 30d             // 遅延ケースでは工数が膨らむ
}
```

どの属性がシナリオ固有かは
[task のリファレンス](https://taskjuggler.org/tj3/manual/task.html) の
**`[sc]` マーク**で分かる。
`effort` / `duration` / `allocate` / `depends` / `start` / `priority` などが該当する。

## ハマりどころ

1. トップレベルのシナリオは 1 つだけ。複数案は必ず入れ子にする
2. シナリオ固有でない属性 (例: `name`) は上書きできない。
   何が上書きできるかは `task` のリファレンスの `[sc]` マークで確認する
3. レポートの `scenarios` に複数指定すると、1 タスクにつきシナリオの数だけ行が出る。
   どの行がどれか分かるように `scenario` 列を入れておくとよい
4. `trackingscenario` を指定すると、そのシナリオと派生シナリオが projection モードになる
   (06 参照)。派生シナリオは tracking シナリオの booking を継承し、
   **自分自身の booking を持てない**

## 得られるもの

「増員したら間に合うのか」「最悪ケースではいつになるのか」といった問いに、
**同じ計画データのまま**答えを出せるようになる。
計画を複製して別ファイルで管理する必要がなくなる。

---

← [08. フィルタ](../08-filters/README.md) | [README (全体)](../README.md) | 次 → [10. コスト](../10-cost/README.md)

<!-- 公式リファレンス (https://taskjuggler.org/tj3/manual/) -->

[scenario]: https://taskjuggler.org/tj3/manual/scenario.html
[allocate]: https://taskjuggler.org/tj3/manual/allocate.html
[scenarios]: https://taskjuggler.org/tj3/manual/scenarios.html
