# Use the VSCodium base image (Ubuntu-based)
FROM lscr.io/linuxserver/vscodium:latest

# Set environment variables
ENV PUID=1000
ENV PGID=1000
ENV TZ=UTC

# Install Python and essential build tools
RUN \
  echo "**** install python and build tools ****" && \
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

# Install Claude Code CLI 
RUN \
  echo "**** install claude code cli ****" && \
  curl -fsSL https://claude.ai/install.sh | bash

# Install the Claude Code extension for VSCodium
# Note: We use the codium command to install extensions from the Open VSX registry
RUN \
  sudo -u abc codium --install-extension anthropic.claude-code

# Working directory
WORKDIR /config/workspace

# Expose the web UI port
EXPOSE 3000
