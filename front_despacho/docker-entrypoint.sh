#!/bin/sh
set -e
export BACKEND_VENTAS_HOST="${BACKEND_VENTAS_HOST:-ventas:8081}"
export BACKEND_DESPACHO_HOST="${BACKEND_DESPACHO_HOST:-despacho:8082}"
envsubst '${BACKEND_VENTAS_HOST} ${BACKEND_DESPACHO_HOST}' \
  < /etc/nginx/templates/default.conf.template \
  > /etc/nginx/conf.d/default.conf
exec "$@"
