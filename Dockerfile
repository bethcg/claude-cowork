# Base image with VSCodium
FROM lscr.io/linuxserver/vscodium:latest

# 1. Install Dependencies
# Added python3-full to ensure all python components are present in Debian Trixie
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
# We use 'sh' directly to execute the remote script. 
# We'll also use -y or equivalent if the script supports it to avoid prompts.
RUN curl -fsSL https://claude.ai/install.sh | sh

# 3. Pre-install VS Code Extensions
# Using the full path to ensure it hits the right binary
RUN \
  /usr/bin/codium --install-extension anthropic.claude-code && \
  /usr/bin/codium --install-extension ms-python.python

WORKDIR /config/workspace

EXPOSE 3000
