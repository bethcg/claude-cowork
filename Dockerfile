# Base image with VSCodium (accessible via browser on port 3000)
FROM lscr.io/linuxserver/vscodium:latest

# 1. Install System Dependencies
# CRITICAL: We removed 'npm' from the list because 'nodejs' from NodeSource includes it.
RUN apt-get update && apt-get install -y \
    python3-full \
    python3-pip \
    python3-venv \
    curl \
    git \
    build-essential \
    nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Install Claude Code (CLI version)
# We pipe the script into 'bash' (not 'sh') to handle advanced shell syntax.
RUN curl -fsSL https://claude.ai/install.sh | bash

# 3. Pre-install VSCodium Extensions
# Using the codium binary to install the Python and Claude extensions
RUN \
  /usr/bin/codium --install-extension anthropic.claude-code && \
  /usr/bin/codium --install-extension ms-python.python

# Workspace setup
WORKDIR /config/workspace

# Port for the Web UI
EXPOSE 3000
