#!/bin/bash

set -e

if [ "$1" = 'supervisord' ]; then

  cat <<EOF > /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true
user=root
loglevel=info

[unix_http_server]
file = /var/run/supervisord.sock
chmod = 0700
username = dummy
password = dummy

[program:datalevin]
command=java --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED -jar /opt/datalevin.jar serv -v -r $DATALEVIN_ROOT -p $DATALEVIN_PORT
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
redirect_stderr=true
user=root

EOF

fi

exec "$@"
