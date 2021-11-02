FROM golang:1.15 AS build

# Install dependencies
RUN apt-get update && apt-get install -y libsecret-1-dev

# Build
WORKDIR /build/
COPY build.sh /build/
COPY patches/ /build/patches/
RUN ls /build
RUN bash build.sh

FROM ubuntu:bionic

EXPOSE 25/tcp
EXPOSE 143/tcp

# Install dependencies and protonmail bridge
RUN apt-get update && \
    apt-get install -y --no-install-recommends socat pass libsecret-1-0 ca-certificates && \
    echo "**** cleanup ****" && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# Copy bash scripts
COPY gpgparams entrypoint.sh /protonmail/

# Copy protonmail
COPY --from=build /build/proton-bridge/proton-bridge /protonmail/

ENTRYPOINT ["bash", "/protonmail/entrypoint.sh"]
