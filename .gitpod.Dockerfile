FROM condaforge/mambaforge:latest

LABEL image.author.name "AlbertRockG"
LABEL image.author.email "rafgangbadja@gmail.com"

USER root

ENV TZ=UTC
ENV DEBIAN_FRONTEND=noninteractive

# Set the timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    tzdata \
    git \
    curl \
    tmux \
    htop \
    xz-utils \
    sudo \
    gnupg \
    lsb-release \
    gcc \
    g++ \
    make \
    libc6-dev \
    pkg-config \
    libssl-dev \
    libpq-dev \
    mono-mcs \
    && rm -rf /var/lib/apt/lists/*

# Install Docker and Docker Compose
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io

RUN curl -o /usr/bin/slirp4netns -fsSL https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.12/slirp4netns-$(uname -m) \
    && chmod +x /usr/bin/slirp4netns

RUN curl -o /usr/local/bin/docker-compose -fsSL https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-$(uname -m) \
    && chmod +x /usr/local/bin/docker-compose \
    && mkdir -p /usr/local/lib/docker/cli-plugins \
    && ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose

# Install Rustup
ENV RUSTUP_HOME=/opt/rustup
ENV CARGO_HOME=/opt/cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly -y

# Set environment variables for Rust
ENV PATH="${PATH}:${CARGO_HOME}/bin"

# Install sprocket
RUN . ${CARGO_HOME}/env && cargo install sprocket

# Install conda packages
RUN mamba install -y -c conda-forge \
    cromwell \
    miniwdl \
    shellcheck