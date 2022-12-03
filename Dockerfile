#Build
FROM golang:1.19 AS build

# Install dependencies
RUN apt-get update -y && apt-get install -y libsecret-1-dev

# Build
WORKDIR /build/
COPY build.sh /build/
#COPY patches/ /build/patches/
RUN ls /build
RUN bash build.sh


#Release
FROM ubuntu:20.04

EXPOSE 25/tcp
EXPOSE 143/tcp

# Install dependencies and protonmail bridge
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends socat pass libsecret-1-0 ca-certificates netcat iputils-ping && \
    rm -rf /var/lib/apt/lists/*

# Copy bash scripts
COPY gpgparams entrypoint.sh /protonmail/

# Copy protonmail
COPY --from=build /build/proton-bridge/bridge /protonmail/
COPY --from=build /build/proton-bridge/proton-bridge /protonmail/

HEALTHCHECK --start-period=30s CMD nc -z 127.0.0.1 25 || nc -z 127.0.0.1 143 || ping -q -c 1 9.9.9.9 >/dev/null || exit 1

ENTRYPOINT ["bash", "/protonmail/entrypoint.sh"]
