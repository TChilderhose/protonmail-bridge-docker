FROM golang:alpine AS build

# Install dependencies
RUN apk add --no-cache --upgrade libsecret-dev git

# Build
RUN CGO_ENABLED=0
COPY patches/ /patches/
RUN git clone https://github.com/ProtonMail/proton-bridge.git /proton-bridge
WORKDIR /proton-bridge/
RUN git checkout v1.8.10
RUN git apply /patches/*.patch
RUN make build-nogui


FROM alpine:3.14

EXPOSE 25/tcp
EXPOSE 143/tcp

# Install dependencies and protonmail bridge
RUN echo "**** install packages ****" && \
    apk add --no-cache --upgrade socat pass libsecret ca-certificates tzdata && \
    echo "**** cleanup ****" && \
    rm -rf /tmp/*

# Copy bash scripts
COPY gpgparams entrypoint.sh /protonmail/

# Copy protonmail
COPY --from=build /build/proton-bridge/proton-bridge /protonmail/

ENTRYPOINT ["bash", "/protonmail/entrypoint.sh"]
