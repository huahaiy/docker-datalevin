#!/bin/bash

set -e

if [ "$1" = 'supervisord' ]; then

  cat <<EOF > /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true
loglevel=info

[program:datalevin]
command=java -jar /opt/datalevin.jar serv -v -r $DATALEVIN_ROOT -p $DATALEVIN_PORT
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
redirect_stderr=true

EOF

fi

exec "$@"
