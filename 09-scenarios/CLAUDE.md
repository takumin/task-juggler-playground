# CLAUDE.md — 09. シナリオ

TaskJuggler 学習用プレイグラウンドの **第 09 段階 (シナリオによる what-if 分析)**。

## 前提

- 対象は TaskJuggler 3.8.4 (Ruby 4.0 上で bundler 管理)
- `tj3` は bundler 経由でのみ使える。必ず `bundle exec tj3` で呼ぶ
- **コマンドはすべてリポジトリルート (このディレクトリの1つ上) から実行する**

## ファイル

| ファイル | 内容 |
|---|---|
| `scenarios.tjp` | 教材本体。3 シナリオ (基本計画 / 突貫案 / 遅延ケース) |
| `README.md` | 学習内容の説明 |
| `out/` | 生成物。再生成できるので消してよい |

## 実行

```sh
bundle exec tj3 -o 09-scenarios/out 09-scenarios/scenarios.tjp
```

## 結果の確認方法

```sh
ruby tools/dump-report.rb 09-scenarios/out/02-milestones.html
```

## この段階で扱うキーワード

`scenario` `scenarios` `scenariospecific.extend` `trackingscenario` `active`

構文は推測せず `bundle exec tj3man <キーワード>` で確認する。

## シナリオの書き方

```
scenario plan "基本計画" {      # トップレベルは1つだけ
  scenario crash "突貫案"       # 入れ子で派生
  scenario risk  "遅延ケース"
}
```

シナリオ固有の値は `シナリオID:属性` で書く (`crash:allocate bob, carol`)。

**どの属性がシナリオ固有かは `bundle exec tj3man task` の `[sc]` マークで確認する。**
`effort` / `duration` / `allocate` / `depends` / `start` / `priority` などが該当。

## 現在の結果 (実測)

| シナリオ | リリース日 |
|---|---|
| 基本計画 | 2026-09-16 |
| 突貫案 | 2026-08-28 |
| 遅延ケース | 2026-10-05 |

## 既知の落とし穴

- トップレベルのシナリオは1つだけ。複数案は必ず入れ子にする
- シナリオ固有でない属性は上書きできない
- `trackingscenario` を指定すると、そのシナリオと派生が projection モードになる。
  派生シナリオは tracking シナリオの booking を継承し、自分の booking を持てない
- レポートで `scenarios` を複数指定すると 1 タスクにつき複数行になる。
  `scenario` 列を入れないとどの行がどれか分からなくなる

## 作業方針

- tjp を変更したら必ず実行し、結果を確認してから回答する
- シナリオを追加・変更したら、**マイルストーンの日付比較** (`02-milestones.html`) で
  効果を数値で示す
- 属性の上書きを提案する前に、その属性がシナリオ固有かを `tj3man task` で確認する
- 実績追跡 (`trackingscenario`) が絡む話題は 06 と関連するので、
  必要なら 06 の教材を参照するよう案内する
