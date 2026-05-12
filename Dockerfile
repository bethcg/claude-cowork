# Base image with VSCodium
FROM lscr.io/linuxserver/vscodium:latest

# 1. Install System Dependencies
RUN apt-get update && apt-get install -y \
    python3-full \
    python3-pip \
    python3-venv \
    curl \
    git \
    build-essential \
    nodejs \
    npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Install Claude Code
# The install.sh script is failing due to shell incompatibility.
# We'll use npm directly to install the global package.
RUN npm install -g @anthropic-ai/claude-code

# 3. Pre-install VSCodium Extensions
# Using the absolute path to the codium binary
RUN \
  /usr/bin/codium --install-extension anthropic.claude-code && \
  /usr/bin/codium --install-extension ms-python.python

# Set up workspace
WORKDIR /config/workspace

# Port for the Web UI
EXPOSE 3000
