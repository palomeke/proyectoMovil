# Base con Flutter + SDK tools
FROM ghcr.io/cirruslabs/flutter:stable

# Acelera apt y evita preguntas
ENV DEBIAN_FRONTEND=noninteractive
# Asegura variables del SDK (la base ya las usa, pero dejamos claro)
ENV ANDROID_SDK_ROOT=/opt/android-sdk-linux \
    ANDROID_HOME=/opt/android-sdk-linux

# Instala lo necesario del SDK/NDK/CMake y Firebase CLI binario
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl ca-certificates \
 && yes | sdkmanager --licenses || true \
 && sdkmanager "platform-tools" "platforms;android-35" "build-tools;35.0.0" "cmake;3.22.1" "ndk;27.0.12077973" \
 && curl -sL https://firebase.tools | bash \
 && rm -rf /var/lib/apt/lists/*
 # Node.js 20 + firebase-tools
RUN apt-get update && apt-get install -y ca-certificates curl gnupg apt-transport-https && \
    install -d -m 0755 /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" \
      > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install -y nodejs && \
    npm install -g firebase-tools@latest && \
    npm cache clean --force && rm -rf /var/lib/apt/lists/*
docker build -t encomex/flutter-ci:android35-node20 -f .\ci\docker\Dockerfile .
# (Opcional, si quieres evitar que Gradle pida esto en runtime)
# RUN yes | sdkmanager --licenses && \
#     sdkmanager "platform-tools" "platforms;android-35" "build-tools;35.0.0" \
#                "cmake;3.22.1" "ndk;27.0.12077973"