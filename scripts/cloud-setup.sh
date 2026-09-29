#!/bin/bash
# Claude Code クラウド環境の「セットアップスクリプト」用。
# 環境設定の Setup script 欄にこのファイルの中身を貼り付けて使う。
# ツールチェーン本体（Python 3.12 / uv）など、重くて毎回変わらない処理だけを行う。
# バージョンは .mise.toml / .python-version と揃えること。
set -euo pipefail

PYTHON_VERSION="3.12"
UV_VERSION="0.8.17"

# 1. Python 3.12（OS パッケージ。GitHub からのダウンロードはネットワーク制限で不可のため）
if ! command -v "python${PYTHON_VERSION}" >/dev/null 2>&1; then
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y "python${PYTHON_VERSION}" "python${PYTHON_VERSION}-venv"
fi

# 2. uv（PyPI から固定バージョンを入れる）
if [ "$(uv --version 2>/dev/null | awk '{print $2}')" != "${UV_VERSION}" ]; then
  "python${PYTHON_VERSION}" -m pip install --user --break-system-packages "uv==${UV_VERSION}" \
    || python3 -m pip install --user --break-system-packages "uv==${UV_VERSION}"
fi

# 3. mise（使える場合のみ。mise.run への通信が許可されていなければスキップ）
if ! command -v mise >/dev/null 2>&1; then
  curl -fsSL https://mise.run | sh || echo "mise のインストールをスキップしました（ネットワーク制限）"
fi

python${PYTHON_VERSION} --version
uv --version
