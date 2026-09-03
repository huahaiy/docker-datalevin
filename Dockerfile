# syntax=docker/dockerfile:1.7

ARG JAVA_IMAGE=eclipse-temurin:21-jre-noble
FROM ${JAVA_IMAGE}

ARG TARGETARCH
ARG DATALEVIN_VERSION=1.1.0

LABEL maintainer="Huahai Yang <huahai.yang@gmail.com>" \
      org.opencontainers.image.title="Datalevin" \
      org.opencontainers.image.version="${DATALEVIN_VERSION}" \
      org.opencontainers.image.source="https://github.com/datalevin/datalevin"

RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

RUN set -eux; \
  case "${TARGETARCH}" in \
    amd64) \
      native_asset="dtlv-${DATALEVIN_VERSION}-ubuntu-22.04-amd64.zip" \
      ;; \
    arm64) \
      native_asset="dtlv-${DATALEVIN_VERSION}-ubuntu-24.04-arm-aarch64.zip" \
      ;; \
    *) \
      echo "Unsupported target architecture: ${TARGETARCH}" >&2; \
      exit 1 \
      ;; \
  esac; \
  release_url="https://github.com/datalevin/datalevin/releases/download/${DATALEVIN_VERSION}"; \
  apt-get update; \
  apt-get install --no-install-recommends -y ca-certificates libgomp1 supervisor unzip wget; \
  wget -O "/tmp/${native_asset}" "${release_url}/${native_asset}"; \
  unzip "/tmp/${native_asset}" -d /usr/bin/; \
  wget -O /opt/datalevin.jar "${release_url}/datalevin-${DATALEVIN_VERSION}-standalone.jar"; \
  apt-get clean; \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./docker-entrypoint.sh /

ENV DATALEVIN_ROOT=/data DATALEVIN_PORT=8898

VOLUME ["/data"]

EXPOSE 8898

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["supervisord"]
