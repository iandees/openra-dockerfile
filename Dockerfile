FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

ARG OPENRA_RELEASE_VERSION=20260222
ARG OPENRA_RELEASE_TYPE=playtest

ENV OPENRA_RELEASE_VERSION=${OPENRA_RELEASE_VERSION}
ENV OPENRA_RELEASE_TYPE=${OPENRA_RELEASE_TYPE}
ENV OPENRA_RELEASE=https://github.com/OpenRA/OpenRA/releases/download/${OPENRA_RELEASE_TYPE}-${OPENRA_RELEASE_VERSION}/OpenRA-${OPENRA_RELEASE_TYPE}-${OPENRA_RELEASE_VERSION}-source.tar.bz2

RUN set -xe; \
        echo "=================================================================="; \
        echo "Building OpenRA:"; \
        echo "  version:\t${OPENRA_RELEASE_VERSION}"; \
        echo "  type:   \t${OPENRA_RELEASE_TYPE}"; \
        echo "  source: \t${OPENRA_RELEASE}"; \
        echo "=================================================================="; \
        \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                    bzip2 \
                    ca-certificates \
                    curl \
                    libfreetype-dev \
                    liblua5.1-0-dev \
                    libopenal-dev \
                    libsdl2-dev \
                    make \
                  ; \
        mkdir /build; \
        cd /build; \
        curl -L $OPENRA_RELEASE | tar xj; \
        make all TARGETPLATFORM=unix-generic

FROM mcr.microsoft.com/dotnet/runtime:8.0

ARG OPENRA_RELEASE_VERSION=20260222
ARG OPENRA_RELEASE_TYPE=playtest

RUN set -xe; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                    libfreetype6 \
                    liblua5.1-0 \
                    libopenal1 \
                    libsdl2-2.0-0 \
                    xdg-utils \
                    zenity \
                  ; \
        rm -rf /var/lib/apt/lists/* \
               /var/cache/apt/archives/*; \
        useradd -d /home/openra -m -s /sbin/nologin openra; \
        mkdir -p /home/openra/.openra \
                 /home/openra/.openra/Logs \
                 /home/openra/.openra/maps; \
        chown -R openra:openra /home/openra/.openra

COPY --from=build /build /home/openra/lib/openra

EXPOSE 1234

USER openra

WORKDIR /home/openra/lib/openra
VOLUME ["/home/openra/.openra"]

CMD [ "/home/openra/lib/openra/launch-dedicated.sh" ]

# annotation labels according to
# https://github.com/opencontainers/image-spec/blob/v1.0.1/annotations.md#pre-defined-annotation-keys
LABEL org.opencontainers.image.title="OpenRA dedicated server"
LABEL org.opencontainers.image.description="Image to run a server instance for OpenRA"
LABEL org.opencontainers.image.url="https://github.com/iandees/openra-dockerfile"
LABEL org.opencontainers.image.documentation="https://github.com/iandees/openra-dockerfile#readme"
LABEL org.opencontainers.image.version=${OPENRA_RELEASE_TYPE}-${OPENRA_RELEASE_VERSION}
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.authors="Ian Dees"
