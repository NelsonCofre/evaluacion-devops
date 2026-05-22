#!/bin/bash
set -euo pipefail
DEPLOY_DIR="${DEPLOY_DIR:-/home/ubuntu/app}"
cd "$DEPLOY_DIR"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker pull "$DOCKER_USERNAME/ventas-service:latest"
if docker pull "$DOCKER_USERNAME/despacho-service:latest" 2>/dev/null; then
  HAS_DESPACHO=true
else
  HAS_DESPACHO=false
fi
export DOCKER_USERNAME DB_ENDPOINT DB_PORT DB_NAME DB_USERNAME DB_PASSWORD
docker compose -f deploy/docker-compose.ec2-backend.yml down || true
if [ "$HAS_DESPACHO" = true ]; then
  docker compose -f deploy/docker-compose.ec2-backend.yml up -d
else
  docker compose -f deploy/docker-compose.ec2-backend.yml up -d ventas
fi

wait_for_api() {
  local url=$1
  local label=$2
  for i in $(seq 1 24); do
    if curl -sf "$url" > /dev/null; then
      echo "${label} OK"
      return 0
    fi
    sleep 5
  done
  echo "${label} FAILED: $url"
  docker compose -f deploy/docker-compose.ec2-backend.yml logs --tail=50
  return 1
}

wait_for_api "http://localhost:8081/api/v1/ventas" "ventas"
if [ "$HAS_DESPACHO" = true ]; then
  wait_for_api "http://localhost:8082/api/v1/despachos" "despacho"
fi
