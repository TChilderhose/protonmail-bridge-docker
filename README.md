# protonmail-bridge-docker

*Note: Currently no patches are needed for K-9 with `v3.0.x` which implments a new proton's own IMAP system. Additionally, [K-9 has joined Thunderbird](https://k9mail.app/2022/06/13/K-9-Mail-and-Thunderbird.html), which one of the main roadmap goals is to improve IMAP. Once `v3.0.x` of the bridge is offically released, this repo will most likely be archived in favour of [shenxn/protonmail-bridge-docker](https://github.com/shenxn/protonmail-bridge-docker).*

This repo is heavily based on the [shenxn/protonmail-bridge-docker](https://github.com/shenxn/protonmail-bridge-docker) repo with some patches to allow [K-9 Mail](https://github.com/k9mail/k-9) support. For now it only supports the `amd64` architecture.


## Tags

There are two tags worth mentioning.
 - `latest`: Image based on the latest stable release of [proton-bridge](https://github.com/ProtonMail/proton-bridge). Currently `v2.3.0`.
 - `beta`: Image based on the latest beta pre-release of [proton-bridge](https://github.com/ProtonMail/proton-bridge). Currently `v2.4.8`.
 - `alpha`: Image based on the latest alpha pre-release of [proton-bridge](https://github.com/ProtonMail/proton-bridge). Currently `v3.0.9`.

## Initialization

To initialize and add account to the bridge, run the following command.

```
docker run --rm -it -v /path/to/protonmail:/root ghcr.io/tchilderhose/protonmail-bridge-docker init
```

Wait for the bridge to startup, use `login` command and follow the instructions to add your account into the bridge. Then use `info` to see the configuration information (username and password). After that, use `exit` to exit the bridge. You may need `CTRL+C` to exit the docker entirely.

## Run

To run the container, use the following command.

```
docker run -d --name=protonmail-bridge -v /path/to/protonmail:/root -p 1025:25/tcp -p 1143:143/tcp --restart=unless-stopped ghcr.io/tchilderhose/protonmail-bridge-docker
```

or Docker-compose

```
  protonmail:
    image:  ghcr.io/tchilderhose/protonmail-bridge-docker
    container_name: protonmail
    restart: unless-stopped
    ports:
      - "1025:25/tcp"
      - "1143:143/tcp"
    volumes:
      - /path/to/protonmail:/root
```
