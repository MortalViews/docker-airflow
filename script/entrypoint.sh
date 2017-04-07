#!/usr/bin/env bash
AIRFLOW_VERSION=1.8.0
AIRFLOW_HOME="/usr/local/airflow"
CMD="/usr/local/airflow/.local/bin/airflow"
TRY_LOOP="20"

: ${REDIS_HOST:="redis"}
: ${REDIS_PORT:="6379"}

: ${POSTGRES_HOST:="postgres"}
: ${POSTGRES_PORT:="5432"}
: ${POSTGRES_USER:="airflow"}
: ${POSTGRES_PASSWORD:="airflow"}
: ${POSTGRES_DB:="airflow"}

: ${FERNET_KEY:=$(python -c "from cryptography.fernet import Fernet; FERNET_KEY = Fernet.generate_key().decode(); print(FERNET_KEY)")}


$(which pip) install --user -e /opt/airflow[crypto,celery,postgres]
$(which pip) install --user -e /usr/local/mlpipeline/
echo "PATH=\$PATH:~/.local/bin" >> ~/.bashrc
. ~/.bashrc

# Update airflow config - Fernet key
sed -i "s|\$FERNET_KEY|$FERNET_KEY|" "$AIRFLOW_HOME"/airflow.cfg

# Wait for Postresql
if [ "$1" = "webserver" ] || [ "$1" = "worker" ] || [ "$1" = "scheduler" ] ; then
  i=0
  while ! nc -z $POSTGRES_HOST $POSTGRES_PORT >/dev/null 2>&1 < /dev/null; do
    i=$((i+1))
    if [ "$1" = "webserver" ]; then
      echo "$(date) - waiting for ${POSTGRES_HOST}:${POSTGRES_PORT}... $i/$TRY_LOOP"
      if [ $i -ge $TRY_LOOP ]; then
        echo "$(date) - ${POSTGRES_HOST}:${POSTGRES_PORT} still not reachable, giving up"
        exit 1
      fi
    fi
    sleep 10
  done
fi

#$CMD initdb
#exec $CMD webserver &
#exec $CMD scheduler
#
while true; do sleep 1000; done
