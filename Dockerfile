FROM golang:1.18 AS build

# Install dependencies
RUN apt-get update && apt-get install -y libsecret-1-dev

# Build
WORKDIR /build/
COPY build.sh /build/
#COPY patches/ /build/patches/
RUN ls /build
RUN bash build.sh


FROM ubuntu:jammy

EXPOSE 25/tcp
EXPOSE 143/tcp

# Install dependencies and protonmail bridge
RUN apt-get update \
    && apt-get install -y --no-install-recommends socat pass libsecret-1-0 ca-certificates iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Copy bash scripts
COPY gpgparams entrypoint.sh /protonmail/

# Copy protonmail
COPY --from=build /build/proton-bridge/bridge /protonmail/
COPY --from=build /build/proton-bridge/proton-bridge /protonmail/

HEALTHCHECK --start-period=30s CMD nc -z 127.0.0.1 25 || nc -z 127.0.0.1 143 || ping -q -c 1 9.9.9.9 >/dev/null || exit 1

ENTRYPOINT ["bash", "/protonmail/entrypoint.sh"]
