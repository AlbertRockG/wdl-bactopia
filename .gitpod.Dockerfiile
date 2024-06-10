FROM condaforge/mambaforge:latest

LABEL image.author.name "AlbertRockG"
LABEL image.author.email "rafgangbadja@gmail.com"

USER root

ENV TZ=UTC

ENV DEBIAN_FRONTEND=noninteractive

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -y update \
    && apt-get -y install \
    ca-certificates \
    tzdata \
    git \
    curl \
    tmux \
    htop \
    xz-utils \
    sudo \
    gnupg \
    lsb-release

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt update \
    && apt-get -y install docker-ce docker-ce-cli containerd.io

RUN curl -o /usr/bin/slirp4netns -fsSL https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.12/slirp4netns-$(uname -m) \
    && chmod +x /usr/bin/slirp4netns

RUN curl -o /usr/local/bin/docker-compose -fsSL https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-$(uname -m) \
    && chmod +x /usr/local/bin/docker-compose && mkdir -p /usr/local/lib/docker/cli-plugins && \
    ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose



# Install Rustup
ENV RUSTUP_HOME /opt/rustup
ENV CARGO_HOME /opt/cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly -y
ENV PATH="${PATH}:/opt/cargo/bin:/opt/cargo/env"
RUN echo "source /opt/cargo/env" >> ~/.bashrc && \
    . /opt/cargo/env && \
    cargo install sprocket


RUN mamba install -y -c conda-forge \
    cromwell \
    miniwdl \
    shellcheck