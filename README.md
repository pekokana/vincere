# Vincere (ヴィンセレ)

名もなき一衛兵として戦乱の世を生き抜き、運命を切り拓く3Dアクション・サバイバル。

## Project Concept
「征服」し、「勝利」し、過酷な運命を「克服」する。
複数国家が争う戦火の中で、プレイヤーは一介の派遣衛兵（Sentinel）として、泥臭い戦場を生き抜きます。

*   **成り上がりシステム**: 現場での功績（ミッション完了）により、ステータスやスキルが分岐・成長。
*   **動的な戦況変化**: プレイヤーの選択と結果により、国家間の勢力図や物語が分岐。
*   **エンジニア・アプローチ**: 10年前のハードウェア環境（Core i7 8th Gen / 16GB RAM）で快適に動作する最適化された設計。

## Tech Stack
*   **Engine**: [Godot Engine 4.x](https://godotengine.org/)
*   **Modeling**: [Blender](https://www.blender.org/)
*   **Language**: GDScript
*   **Target OS**: Ubuntu (Linux) / Windows 10
*   **Infrastructure**: GitHub Pages (Landing Page & Docs)

## Directory Structure
```text
.
├── project/             # Godot Project files
├── assets_source/       # Blender (.blend), textures, and raw assets
├── docs/                # GitHub Pages (Landing Page & Manuals)
└── README.md            # Project Overview
```

## Development Framework (Internal)
本プロジェクトでは、拡張性と保守性を重視したコンポーネント指向を採用していきます。

*   **Signal-Driven UI**: 子部品はシグナルを発火し、親シーンがロジックを制御する疎結合設計。
*   **Autoload Manager**: `PlayerStats.gd` 等のシングルトンによるグローバルな状態管理。
*   **Debug Console**: 開発効率を最大化するための、実行時パラメータ操作コマンドの実装。

## Roadmap
- [ ] Phase 1: **The Sandbox** (テスト部屋の構築、カメラ・ライトの共通化)
- [ ] Phase 2: **Identity** (キャラクリ画面、セーブ/ロード、プロファイル管理)
- [ ] Phase 3: **Battlefield** (モブ掃討戦プロトタイプ、当たり判定の実装)
- [ ] Phase 4: **Lobby & Branch** (拠点画面、スキルツリー、ストーリー分岐)

## Development Log
開発の裏側や技術的な挑戦については、以下のプラットフォームで発信を予定しています。


---

## License
Copyright (c) 2026 [pekokana]
All rights reserved.

このプロジェクトは [MIT License](LICENSE) のもとで公開されています。

