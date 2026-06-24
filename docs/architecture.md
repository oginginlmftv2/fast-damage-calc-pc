# Architecture

Version: 1.0.0

## 基本方針

UIから直接データや計算ロジックを扱わない。

以下の構造を維持する。

UI

↓

Provider

↓

Service

↓

Data

将来的な機能追加やレギュレーション更新に対応しやすい構造を優先する。

---

# ディレクトリ構成

lib/

main.dart

pages/

home_page.dart

calc_page.dart

party_page.dart

settings_page.dart

models/

pokemon.dart

move.dart

ability.dart

item.dart

party.dart

services/

damage_service.dart

party_service.dart

providers/

calc_provider.dart

party_provider.dart

widgets/

pokemon_card.dart

move_card.dart

damage_result_card.dart

theme/

app_theme.dart

utils/

damage_calculator.dart

stat_calculator.dart

type_chart.dart

nature_table.dart

---

# Data

data/

reg1/

pokemon.json

moves.json

abilities.json

items.json

reg2/

pokemon.json

moves.json

abilities.json

items.json

natures.json

typeChart.json

データ追加のみで新レギュレーションに対応できる構造とする。

---

# Pages

## HomePage

役割

トップ画面

内容

* 現在のレギュレーション
* 保存済みパーティ一覧
* 新規作成ボタン

---

## CalcPage

役割

ダメージ計算

攻撃側

* ポケモン
* 特性
* 持ち物
* 性格
* 努力値
* テラスタイプ
* 技1～4

防御側

* ポケモン
* 特性
* 持ち物
* 性格
* 努力値
* テラスタイプ

結果

* ダメージ範囲
* ダメージ割合
* 確定数

状態変更時に自動再計算する。

---

## PartyPage

役割

パーティ管理

保存上限

10個

内容

* パーティ名
* レギュレーション
* 6匹

---

## SettingsPage

役割

設定

v1.0では最低限のみ。

---

# Theme

Material3

ダークモード基準

優先順位

1. 操作速度

2. 見やすさ

3. シンプルさ

余計なアニメーションは実装しない。

---

# Service

damage_service.dart

ダメージ計算を担当する。

party_service.dart

パーティ保存を担当する。

---

# Utils

damage_calculator.dart

ダメージ計算ロジック

stat_calculator.dart

実数値計算

type_chart.dart

タイプ相性

nature_table.dart

性格補正

---

# 原則

既存機能を壊さない。

v1.0では全部入りを目指さない。

レギュレーション更新当日に使えることを最優先とする。
