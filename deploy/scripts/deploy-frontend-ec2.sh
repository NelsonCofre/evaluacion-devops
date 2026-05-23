#!/bin/bash
set -euo pipefail
DEPLOY_DIR="${DEPLOY_DIR:-/home/ubuntu/app}"
cd "$DEPLOY_DIR"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker pull "$DOCKER_USERNAME/frontend-despacho:latest"
export DOCKER_USERNAME BACKEND_VENTAS_HOST BACKEND_DESPACHO_HOST
docker compose -f deploy/docker-compose.ec2-frontend.yml down || true
docker compose -f deploy/docker-compose.ec2-frontend.yml up -d

for i in $(seq 1 12); do
  if curl -sf http://localhost:3000 > /dev/null; then
    echo "frontend OK"
    exit 0
  fi
  sleep 5
done

echo "frontend FAILED: http://localhost:3000"
docker compose -f deploy/docker-compose.ec2-frontend.yml logs --tail=50
exit 1
