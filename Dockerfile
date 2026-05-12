# Base image with VSCodium
FROM lscr.io/linuxserver/vscodium:latest

# 1. Install Dependencies
# Note: Removed 'npm' from the list as 'nodejs' usually provides it or conflicts 
# We also ensure build-essential is there for Claude Code native modules
RUN \
  echo "**** install python and node dependencies ****" && \
  apt-get update && \
  apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    curl \
    git \
    build-essential \
    nodejs && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# 2. Install Claude Code (CLI version)
# We use -f to force if needed, and ensure npm is actually available
RUN \
  if ! command -v npm >/dev/null; then apt-get update && apt-get install -y npm; fi && \
  curl -fsSL https://claude.ai/install.sh | sh

# 3. Pre-install VS Code Extensions
# anthropic.claude-code: The Claude Dev/Cowork extension
# ms-python.python: Standard Python support
RUN \
  /usr/bin/codium --install-extension anthropic.claude-code && \
  /usr/bin/codium --install-extension ms-python.python

WORKDIR /config/workspace

EXPOSE 3000
