# Damage Engine Design v1

## Purpose

ポケモンチャンピオンズ向け高速ダメージ計算エンジン。

目標：

- 1タップで結果表示
- オフライン動作
- Flutterのみで完結
- 将来的な世代変更に対応可能

---

## Architecture

```
UI
 ↓
DamageCalculator
 ↓
DamageFormula
 ↓
PokemonData
MoveData
TypeChart
```

---

## Core Classes

### DamageCalculator

責務：最終ダメージ計算を行う。

```dart
class DamageCalculator {
  DamageResult calculate(
    Pokemon attacker,
    Pokemon defender,
    Move move,
    BattleConditions conditions,
  );
}
```

### Pokemon

```dart
class Pokemon {
  int level;

  int hp;
  int attack;
  int defense;
  int spAttack;
  int spDefense;
  int speed;

  List<String> types;
}
```

### Move

```dart
class Move {
  String name;

  String type;

  int power;

  bool isPhysical;
}
```

### BattleConditions

```dart
class BattleConditions {
  bool stab;

  double typeMultiplier;

  bool critical;

  bool burn;

  double attackModifier;

  double defenseModifier;
}
```

---

## Damage Formula

初期バージョンはSV準拠。

```
Damage =
((((2 × Level / 5 + 2)
× Power
× Attack
÷ Defense)
÷ 50)
+ 2)
× Modifier
```

### Modifier

以下を乗算する。

- STAB
- タイプ相性
- 急所
- やけど
- 乱数
- その他補正

---

## Random Range

表示は16段階乱数。

```
85%
86%
87%
...
100%
```

出力例：

```
152〜180
(85.0%〜100.0%)
```

---

## Type Effectiveness

JSON管理。例：

```json
{
  "Fire": {
    "Grass": 2.0,
    "Water": 0.5
  }
}
```

---

## Future Support

対応予定：

- テラスタル
- 持ち物
- 特性
- 天候
- フィールド
- ダブルバトル
- ポケモンチャンピオンズ独自ルール

---

## Development Policy

v1では以下のみ対応。

- レベル
- 種族値反映済み実数値
- 技威力
- タイプ一致
- タイプ相性
- 急所
- やけど
- 乱数

その他要素はv2以降で実装する。
