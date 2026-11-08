# syntax=docker/dockerfile:1.7
ARG NEO4J_VERSION=2026.10.1
FROM neo4j:${NEO4J_VERSION}

LABEL org.opencontainers.image.title="QuestaCase Neo4j"
LABEL org.opencontainers.image.description="Neo4j Community graph storage for QuestaCase"
LABEL org.opencontainers.image.source="https://github.com/neo4j/docker-neo4j"

EXPOSE 7474 7687
VOLUME ["/data", "/logs", "/backups"]
