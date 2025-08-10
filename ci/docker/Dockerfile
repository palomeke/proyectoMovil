# ci/docker/Dockerfile

# Imagen base con Flutter + Android SDK + Java ya listos
FROM ghcr.io/cirruslabs/flutter:stable

# Paquetes útiles + firebase-tools (para App Distribution)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      openjdk-17-jdk \
      nodejs npm \
      unzip \
    && npm i -g firebase-tools \
    && rm -rf /var/lib/apt/lists/*

# Aceptar licencias del SDK (evita prompts en tiempo de build)
# En la base de cirruslabs suele existir sdkmanager en el PATH
RUN yes | sdkmanager --licenses || true

# (Opcional) crear carpetas de cache (las montaremos como volúmenes al correr)
RUN mkdir -p /root/.pub-cache /root/.gradle