#!/bin/sh
set -e

JDBC_DEST="/usr/local/tomcat/webapps/TiendaRepuestos/WEB-INF/classes/jdbc.properties"

sed \
  -e "s|\${DB_USER}|${DB_USER}|g" \
  -e "s|\${DB_PASSWORD}|${DB_PASSWORD}|g" \
  -e "s|\${DB_HOST}|${DB_HOST}|g" \
  -e "s|\${DB_PORT}|${DB_PORT}|g" \
  -e "s|\${DB_NAME}|${DB_NAME}|g" \
  /usr/local/tomcat/jdbc.properties.template > "$JDBC_DEST"

exec catalina.sh run
