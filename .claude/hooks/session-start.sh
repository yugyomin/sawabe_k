#!/bin/bash
# SessionStart フック: 毎セッション開始時に依存関係を uv.lock どおりに同期する（軽い処理）。
set -euo pipefail

# クラウドセッション以外（ローカル）では何もしない
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-$(dirname "$0")/../..}"

# Python 本体のダウンロードは行わず、セットアップスクリプトで用意した Python を使う
export UV_PYTHON_DOWNLOADS=never
export PATH="$HOME/.local/bin:$PATH"

# uv.lock と pyproject.toml がずれていたらエラーにする（再現性のため）
uv sync --locked

# セッション中のコマンドで .venv を使えるようにする
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  {
    echo "export UV_PYTHON_DOWNLOADS=never"
    echo "export VIRTUAL_ENV=\"$PWD/.venv\""
    echo "export PATH=\"$PWD/.venv/bin:\$HOME/.local/bin:\$PATH\""
  } >> "$CLAUDE_ENV_FILE"
fi
