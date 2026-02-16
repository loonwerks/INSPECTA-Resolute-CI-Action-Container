FROM ubuntu:24.04
LABEL org.opencontainers.image.source="https://github.com/loonwerks/INSPECTA-Resolute-CI-Action-Container"

# Fetch some basics
RUN apt-get update -q \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        git \
        unzip \
        libssl-dev \
        libgmp-dev \
        libzmq3-dev \
        pkg-config \
        bubblewrap \
        tar \
        jq \
        xvfb \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV AM_REPOS_ROOT=/usr/local/attestation_manager

RUN mkdir -p ${AM_REPOS_ROOT}

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

# Install Attestation Manager (AM)
COPY install-attestation-manager.sh /install-attestation-manager.sh
RUN chmod +x /install-attestation-manager.sh && ./install-attestation-manager.sh
ENV ASP_BIN=${AM_REPOS_ROOT}/asp-libs/target/release/
ENV PATH=${AM_REPOS_ROOT}/rust-am-clients/target/release:${PATH}

# Install Resolute
COPY install-resolute.sh /install-resolute.sh
RUN chmod +x /install-resolute.sh && ./install-resolute.sh
ENV PATH=/osate2-2.14.0:${PATH}