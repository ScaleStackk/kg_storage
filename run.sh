#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

IMAGE_NAME="${NEO4J_IMAGE:-questacase-neo4j:2026.10.1}"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required but was not found." >&2
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "Docker is installed but its daemon is not available." >&2
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "The Docker Compose plugin is required." >&2
  exit 1
fi

if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
  echo "Image $IMAGE_NAME does not exist. Run ./build.sh first." >&2
  exit 1
fi

if [[ ! -f .env ]]; then
  secret="$(od -An -N24 -tx1 /dev/urandom | tr -d ' \n')"
  umask 077
  {
    echo "DOCKER_PLATFORM=${DOCKER_PLATFORM:-linux/amd64}"
    echo "NEO4J_IMAGE=$IMAGE_NAME"
    echo "NEO4J_PASSWORD=$secret"
    echo "NEO4J_BIND_ADDRESS=${NEO4J_BIND_ADDRESS:-127.0.0.1}"
    echo "NEO4J_ADVERTISED_ADDRESS=${NEO4J_ADVERTISED_ADDRESS:-localhost}"
    echo "NEO4J_HTTP_PORT=7474"
    echo "NEO4J_BOLT_PORT=7687"
    echo "NEO4J_HEAP_INITIAL=512m"
    echo "NEO4J_HEAP_MAX=1g"
    echo "NEO4J_PAGECACHE=512m"
    echo "NEO4J_MEMORY_LIMIT=2g"
    echo "NEO4J_CPU_LIMIT=2.0"
  } > .env
  echo "Created private credentials in $SCRIPT_DIR/.env"
fi

docker compose --env-file .env up --detach --no-build
docker compose --env-file .env ps
echo "Neo4j is starting. Browser: http://127.0.0.1:7474"
