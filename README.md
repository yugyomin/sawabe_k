# sawabe_k

さわべ特許事務所の調査・データ分析・集計用リポジトリ（Python / uv）。

## ツールチェーン

| 項目 | バージョン固定ファイル |
| --- | --- |
| Python 3.12 | `.python-version`, `.mise.toml`, `pyproject.toml` (`requires-python`) |
| uv 0.8.17 | `.mise.toml`, `scripts/cloud-setup.sh`, `pyproject.toml` (`required-version`) |
| 依存パッケージ | `pyproject.toml`, `uv.lock` |

## ローカル開発

```bash
mise install      # Python と uv を .mise.toml のバージョンで用意
uv sync           # 依存関係をインストール
uv run pytest     # テスト
uv run ruff check . && uv run ruff format --check .   # lint
```

依存を追加するときは `uv add <パッケージ>`（開発用は `uv add --dev`）を使い、`uv.lock` も一緒にコミットする。

## Claude Code クラウドセッション

- **セットアップスクリプト**（環境設定の Setup script 欄）: `scripts/cloud-setup.sh` の中身を貼り付ける。
  Python 3.12 と uv を用意する重い処理。
- **SessionStart フック**（`.claude/settings.json` → `.claude/hooks/session-start.sh`）:
  毎セッション `uv sync --locked` を実行し、`.venv` を PATH に通す。
