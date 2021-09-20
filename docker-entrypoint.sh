#!/bin/bash

set -e

DATALEVIN_PORT=${DATALEVIN_PORT:-8898}

if [ "$1" = 'supervisord' ]; then

  cat <<EOF > /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true
childlogdir=/var/log/supervisor
loglevel=info

[program:datalevin]
command=dtlv serv -v -r /data -p $DATALEVIN_PORT
redirect_stderr=true

EOF

fi

exec "$@"
