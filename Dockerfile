# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH


ENV OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git libbz2-1.0 libffi8 liblzma5 libncursesw6 libreadline8 \
    libsqlite3-0 libsqlite3-dev libssl-dev libssl3 libtinfo6 pkg-config procps unzip wget zlib1g gnupg2 xz-utils
RUN mkdir -p /tmp/bitnami/pkg/cache/ /opt/bitnami ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "python-3.13.2-11-linux-${OS_ARCH}-debian-12" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done

RUN apt-get update && apt-get install -y pipx npm && apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives 
    
ENV HELIX_VERSION=24.03

# Download and install Helix
RUN curl -L https://github.com/helix-editor/helix/releases/download/${HELIX_VERSION}/helix-${HELIX_VERSION}-x86_64-linux.tar.xz \
    | tar -xJ && \
    mv helix-${HELIX_VERSION}-x86_64-linux /opt/helix && \
    ln -s /opt/helix/hx /usr/local/bin/hx

RUN pipx ensurepath && pipx install "python-lsp-server" && \
    pipx inject python-lsp-server python-lsp-ruff python-lsp-black && \
    npm i -g bash-language-server && mkdir -p /root/.config

USER root
COPY .config /root/.config

RUN hx --grammar fetch && hx --grammar build

#WORKDIR /app
#CMD [ "python" ]