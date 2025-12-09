#
# Datalevin
#
# Version     0.5
#

FROM eclipse-temurin:21-jre-jammy

MAINTAINER Huahai Yang <hyang@juji-inc.com>

RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

RUN \
  echo "===> install Datalevin ..."  && \
  apt-get update && \
  apt-get install -y supervisor unzip wget libgomp1 && \
  wget https://github.com/juji-io/datalevin/releases/download/0.9.27/dtlv-0.9.27-ubuntu-22.04-amd64.zip && \
  unzip dtlv-0.9.27-ubuntu-22.04-amd64.zip -d /usr/bin/ && \
  rm dtlv*.zip &&  \
  wget -O /opt/datalevin.jar https://github.com/juji-io/datalevin/releases/download/0.9.27/datalevin-0.9.27-standalone.jar && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./docker-entrypoint.sh /

ENV DATALEVIN_ROOT=/data DATALEVIN_PORT=8898

VOLUME ["/data"]

EXPOSE 8898

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["supervisord"]
