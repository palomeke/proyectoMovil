# ci/docker/Dockerfile
FROM ghcr.io/cirruslabs/flutter:stable
# ↑ Trae Flutter + Android SDK listos para CI

# Java 17 + Node/npm + firebase-tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      openjdk-17-jdk \
      nodejs npm \
      unzip \
    && npm i -g firebase-tools \
    && rm -rf /var/lib/apt/lists/*

# Aceptar licencias de Android (evita prompts)
RUN yes | sdkmanager --licenses || true

# Caches (no obligatorias pero útiles)
RUN mkdir -p /root/.pub-cache /root/.gradle