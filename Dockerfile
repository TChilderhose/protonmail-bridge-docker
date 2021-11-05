FROM golang:1.15 AS build

# Install dependencies
RUN apt-get update && apt-get install -y libsecret-1-dev

# Build
WORKDIR /build/
COPY build.sh /build/
COPY patches/ /build/patches/
RUN ls /build
RUN bash build.sh

FROM alpine:3.14

EXPOSE 25/tcp
EXPOSE 143/tcp

# Install dependencies and protonmail bridge
RUN echo "**** install packages ****" && \
    apk add --no-cache --upgrade socat pass libsecret ca-certificates libc6-compat tzdata && \
    echo "**** cleanup ****" && \
    rm -rf /tmp/*

# Copy bash scripts
COPY gpgparams entrypoint.sh /protonmail/

# Copy protonmail
COPY --from=build /build/proton-bridge/proton-bridge /protonmail/

ENTRYPOINT ["bash", "/protonmail/entrypoint.sh"]
