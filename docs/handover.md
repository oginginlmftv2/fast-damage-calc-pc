# AI間申し送り

## 2026/06/24

### 完了
- 環境構築（Flutter 3.44.3, Android toolchain, VS Code）
- GitHubリポジトリ作成・初回push
- docsフォルダ作成（decisions.md, todo.md, handover.md, spec_v1.md, architecture.md）
- pubspec.yaml に provider・shared_preferences 追加
- lib構造作成（main.dart, theme, models, utils, providers, pages）
- HomePage・CalcPage のUI骨格完成
- ダメージ計算エンジン骨格完成（damage_calculator.dart, stat_calculator.dart, type_chart.dart, nature_table.dart）
- Chromeで起動確認済み（ダークモード・日本語表示・画面遷移OK）

### 未着手
- ポケモン選択UI（Geminiのpokemon.json待ち）
- 技選択UI（Geminiのmoves.json待ち）
- 努力値・性格・テラスタイプ入力UI
- パーティ保存機能
- レギュレーション切替

### 待ち状態
- Geminiからの pokemon.json, moves.json, abilities.json, items.json
- チャッピーからの damage_engine 最終版

### 次にClaudeがやること
pokemon.jsonとmoves.jsonがGitHubに追加されたら、
ポケモン検索・技選択UIを実装する。
