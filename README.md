# Dockerfile for an OpenRA dedicated server

### Build FAQ

  - Images are built with Github Actions for various architectures (see [`docker-publish.yaml`](.github/workflows/docker-publish.yaml))
  - Build is triggered by git a push to https://github.com/iandees/openra-dockerfile and by a new tag with the prefix `release-` (e.g. `release-20231010`).

## Usage Example

```sh

$ docker run -d -p 1234:1234 \
             -e Name="DOCKER SERVER" \
             -e Mod=ra \
             -e ListenPort="1234" \
             --name openra \
             ghcr.io/iandees/openra
```

see https://github.com/OpenRA/OpenRA/blob/bleed/launch-dedicated.sh for all options.

## Multi-arch Image

The latest release is available for `amd64` and `x86_64`. Usually docker should automatically download the right image.

`docker pull ghcr.io/iandees/openra:<TAG>` should just work (tm)

## FYI

Seems like an example server with RA-mod needs at least 500MB of memory, maybe even more.

## Copyright & License

Copyright © 2024 [Ian Dees](https://github.com/iandees), 2019 [Roland Moriz](https://roland.io), see LICENSE.txt
