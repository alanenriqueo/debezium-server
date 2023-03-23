FROM alpine:latest

ARG DEBEZIUM_BASE_DIR=/debezium-server

RUN apk add --no-cache bash openjdk11
ADD debezium-server-dist/target/debezium-server-dist-2.2.0-SNAPSHOT.tar.gz /

USER root

COPY entrypoint.sh /

RUN \
    chmod 777 $DEBEZIUM_BASE_DIR/ /entrypoint.sh

# USER postgres

EXPOSE 8080

WORKDIR $DEBEZIUM_BASE_DIR

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/debezium-server/run.sh"]
