#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

IMAGE_NAME="${NEO4J_IMAGE:-questacase-neo4j:2026.10.1}"
NEO4J_VERSION="${NEO4J_VERSION:-2026.10.1}"
TARGET_PLATFORM="${DOCKER_PLATFORM:-linux/amd64}"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required but was not found." >&2
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "Docker is installed but its daemon is not available." >&2
  exit 1
fi

echo "Building $IMAGE_NAME for $TARGET_PLATFORM"
docker build \
  --platform "$TARGET_PLATFORM" \
  --build-arg "NEO4J_VERSION=$NEO4J_VERSION" \
  --tag "$IMAGE_NAME" \
  .

docker image inspect "$IMAGE_NAME" --format 'Built {{.RepoTags}} ({{.Os}}/{{.Architecture}})'
