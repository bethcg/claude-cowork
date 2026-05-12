#!/bin/bash
set -ex

HOME="${HOME:-/home/ubuntu}"
RENKU_MOUNT_DIR="${RENKU_MOUNT_DIR:-${HOME}/work}"

mkdir -p "${RENKU_MOUNT_DIR}/.vscode/extensions"

# 1. Added anthropic.claude-code to the list
DEFAULT_VSCODIUM_EXTENSIONS="\
  ms-python.python \
  ms-toolsai.jupyter \
  anthropic.claude-code \
"
VSCODIUM_EXTENSIONS="${VSCODIUM_EXTENSIONS:-${DEFAULT_VSCODIUM_EXTENSIONS}}"
VSCODIUM_EXTENSIONS=($VSCODIUM_EXTENSIONS)

for ext in "${VSCODIUM_EXTENSIONS[@]}"; do
  /codium-server/bin/codium-server \
    --extensions-dir "${RENKU_MOUNT_DIR}/.vscode/extensions" \
    --server-data-dir "${RENKU_MOUNT_DIR}/.vscode" \
    --install-extension "${ext}" || true
done

# ... (keep the rest of your base path logic) ...

# 2. Python Venv setup
# Using python3 specifically since ubuntu 24.04 defaults to it
if hash "python3" 2> /dev/null; then
  set +e
  python3 -m venv "${RENKU_MOUNT_DIR}/.venv" --system-site-packages
  source "${RENKU_MOUNT_DIR}/.venv/bin/activate"
  set -e
fi

# 3. Start Server
/codium-server/bin/codium-server \
  --server-base-path "${RENKU_BASE_URL_PATH}" \
  --host "${RENKU_SESSION_IP}" \
  --port "${RENKU_SESSION_PORT}" \
  --extensions-dir "${RENKU_MOUNT_DIR}/.vscode/extensions" \
  --server-data-dir "${RENKU_MOUNT_DIR}/.vscode" \
  --without-connection-token \
  --accept-server-license-terms \
  --telemetry-level off \
  --default-folder "${RENKU_WORKING_DIR}"
