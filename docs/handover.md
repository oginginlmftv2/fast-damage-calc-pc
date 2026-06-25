# AI間申し送り

## 担当体制（2026/06/26更新）
- **Claude**：UI実装・データ整備・Git管理・ダメージ計算エンジン
- **Gemini**：JSONデータ作成
- ~~ChatGPT~~：離脱済み

---

## 2026/06/26 現在の状態（最新）

### 完了済み機能
- ポケモン検索UI（PokemonSearchField → PokemonRepository → pokemon.json）
- 技検索UI（MoveSearchField → MoveRepository → moves.json）
- 性格ドロップダウン（+A/-B形式）
- 努力値入力（0-252クランプ）
- テラスタイプ選択チップ（18タイプ、選択解除対応）
- 実数値表示（ポケモン選択後にH/A/B/C/D/Sをリアルタイム表示）
- ダメージ計算エンジン（SV準拠、16段階乱数、STAB/テラスタル/タイプ相性）
- 計算実行ボタン（攻撃側・防御側・技が揃ったとき活性）
- DamageResult表示カード（min〜max、%、KO発数）
- エラーハンドリング（へんか技ガード、タイプ無効0倍表示、try-catch）
- 防御側テラスタイプ時のタイプ相性計算

### データ状況
- `assets/data/moves.json`：130技（ぶつり/とくしゅ/へんか）
- `assets/data/pokemon.json`：152体
- `assets/data/type_chart.json`：18×18タイプ相性表
- `assets/data/natures.json`：25性格
- `assets/data/abilities.json`：15特性（未使用）
- `assets/data/items.json`：15持ち物（未使用）

### ファイル構成（主要）
```
lib/
  main.dart                    # App, ChangeNotifierProvider
  pages/
    home_page.dart             # ホーム（カリキュレーターへのナビ）
    calc_page.dart             # メイン計算画面（全UI）
  providers/
    calc_provider.dart         # CalcState, CalcProvider（計算ロジック呼び出し）
  models/
    pokemon.dart               # Pokemon（id, name, types, baseStats, abilities）
    move.dart                  # Move（id, name, type, category, power, accuracy）
  repositories/
    pokemon_repository.dart    # pokemon.json読み込み・キャッシュ
    move_repository.dart       # moves.json読み込み・キャッシュ
  widgets/
    pokemon_search_field.dart  # インクリメンタル検索（候補8件）
    move_search_field.dart     # インクリメンタル検索（候補6件）
  utils/
    damage_calculator.dart     # calcDamage() / DamageResult
    stat_calculator.dart       # calcStat()（IV=31, Lv50固定）
    type_chart.dart            # getTypeEffectiveness()（日本語タイプ名）
    nature_table.dart          # natureTable（25性格の補正値）
```

### データフォーマット（Gemini向け）
```json
// moves.json
{"id":"earthquake","name_ja":"じしん","type":"じめん","category":"ぶつり","power":100,"accuracy":100,"pp":10,"effects":{}}

// pokemon.json
{"id":"garchomp","name_ja":"ガブリアス","types":["ドラゴン","じめん"],"base_stats":{"hp":108,"attack":130,"defense":95,"sp_attack":80,"sp_defense":85,"speed":102},"abilities":["さめはだ"],"learnset":["earthquake","outrage"]}
```

---

## 次にやるべきこと（優先順）

### 1. heavy_slam など威力可変技の対応（データ品質）
- `heavy_slam`（ヘビーボンバー）の power が 0 → 重さ依存で計算不可
- 同様の技：`gyro_ball`、`electro_ball`、`eruption` / `water_spout`（残りHP依存）など
- **対応方針**：power=0 でへんか技でないものを検索UIで除外するか、固定威力で近似表示

### 2. アプリ実機動作確認
- `flutter run` でAndroid/iOS実機またはエミュレータで確認
- 検索→計算→結果表示の一連フローをテスト

### 3. パーティ保存機能
- SharedPreferencesにJSON保存
- 保存・呼び出しUI（最大6体）

### 4. レギュレーション切替
- レギュレーションごとに使用可能ポケモンをフィルタ

### 5. v2要素（持ち物・特性・天候）
- abilities.json / items.json は用意済み、ロジック未実装

---

## 新セッションでClaudeに伝えること

```
C:\src\fast_damage_calc_pc のプロジェクトを開発中です。
https://github.com/oginginlmftv2/fast-damage-calc-pc
docs/handover.md を読んで続きをお願いします。
```
