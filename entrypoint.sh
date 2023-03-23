#!/bin/sh

DEBEZIUM_BASE_DIR=/datadrive/debezium
CERTS_DIR=/datadrive/certs
CONFIG_DIR=${DEBEZIUM_BASE_DIR}/conf
DATA_DIR=${DEBEZIUM_BASE_DIR}/data

if [ ! -d ${CONFIG_DIR} ]; then
    mkdir -p ${CONFIG_DIR}
fi

if [ ! -d ${DATA_DIR} ]; then
    mkdir -p ${DATA_DIR}
fi

if [ ! -f ${CONFIG_DIR}/application.properties ]; then
    echo "Generating application.properties..."
    printf "\
debezium.source.connector.class=io.debezium.connector.postgresql.PostgresConnector
debezium.source.offset.storage.file.filename=${DATA_DIR}/offsets.dat
debezium.source.database.hostname=localhost
debezium.source.database.port=5432
debezium.source.database.user=azuresu
debezium.source.database.sslmode=verify-ca
debezium.source.database.sslcert=${CERTS_DIR}/superuser-cert.pem
debezium.source.database.sslkey=${CERTS_DIR}/superuser-key.der
debezium.source.database.sslrootcert=${CERTS_DIR}/ca.pem
debezium.source.plugin.name=pgoutput
debezium.sink.type=eventhubs
debezium.source.offset.flush.interval.ms=60000
debezium.source.database.dbname=postgres
debezium.source.slot.name=debezium
debezium.source.topic.prefix=postgres
debezium.source.publication.autocreate.mode=all_tables
debezium.source.slot.drop.on.stop=false
" > ${CONFIG_DIR}/application.properties
else
    echo "application.properties exists already, skipping..."
fi

echo "Starting $*..."

exec "$@"
