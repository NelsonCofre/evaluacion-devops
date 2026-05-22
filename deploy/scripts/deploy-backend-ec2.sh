#!/bin/bash
set -euo pipefail
DEPLOY_DIR="${DEPLOY_DIR:-/home/ubuntu/app}"
cd "$DEPLOY_DIR"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker pull "$DOCKER_USERNAME/ventas-service:latest"
docker pull "$DOCKER_USERNAME/despacho-service:latest"
export DOCKER_USERNAME DB_ENDPOINT DB_PORT DB_NAME DB_USERNAME DB_PASSWORD
docker compose -f deploy/docker-compose.ec2-backend.yml down || true
docker compose -f deploy/docker-compose.ec2-backend.yml up -d
sleep 15
curl -sf http://localhost:8081/api/v1/ventas && echo " ventas OK"
curl -sf http://localhost:8082/api/v1/despachos && echo " despacho OK"
