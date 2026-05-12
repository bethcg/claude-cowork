ARG BASE_IMAGE=ubuntu:24.04
FROM $BASE_IMAGE
ARG VSCODIUM_VERSION=1.96.4.25026

SHELL [ "/bin/bash", "-c", "-o", "pipefail" ]

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        git \
        git-lfs \
        # Python dependencies
        python3-full \
        python3-pip \
        python3-venv \
        # Node.js for Claude
        nodejs \
        npm \
        # Standard build libs
        libbz2-dev libffi-dev liblzma-dev libncursesw5-dev \
        libreadline-dev libsqlite3-dev libssl-dev libxml2-dev \
        libxmlsec1-dev tk-dev xz-utils zlib1g-dev \
    && \
    mkdir -p /codium-server && \
    curl -L https://github.com/VSCodium/vscodium/releases/download/${VSCODIUM_VERSION}/vscodium-reh-web-linux-x64-${VSCODIUM_VERSION}.tar.gz | tar -xz -C /codium-server && \
    # Install Claude CLI globally
    npm install -g @anthropic-ai/claude-code && \
    rm -rf /var/lib/apt/lists/*

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

USER ubuntu
WORKDIR /home/ubuntu

COPY --chown=root:root --chmod=755 entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
