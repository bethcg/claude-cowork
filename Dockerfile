# Base image with VSCodium accessible via Web UI (Port 3000)
FROM lscr.io/linuxserver/vscodium:latest

# 1. Install Python and Build Essentials
RUN \
  echo "**** install python and dependencies ****" && \
  apt-get update && \
  apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    curl \
    git \
    nodejs \
    npm && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# 2. Install Claude Code (CLI version)
# This provides the 'claude' command in the terminal
RUN curl -fsSL https://claude.ai/install.sh | bash

# 3. Pre-install VS Code Extensions
# anthropic.claude-code: The Claude Dev/Cowork extension
# ms-python.python: Standard Python support
RUN \
  /usr/bin/codium --install-extension anthropic.claude-code && \
  /usr/bin/codium --install-extension ms-python.python

# Workspace setup
WORKDIR /config/workspace

# Expose the web UI port
EXPOSE 3000
