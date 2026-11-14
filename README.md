# QuestaCase Neo4j image

Pinned Neo4j Community graph storage for the QuestaCase demo. Credentials are
never included in the image. `run.sh` creates a private `.env` file with a random
password on its first run.

```bash
./build.sh
./run.sh
```

The default build target is `linux/amd64` for AWS EC2. Override it when needed:

```bash
DOCKER_PLATFORM=linux/arm64 ./build.sh
```

By default the ports bind only to `127.0.0.1`. On EC2, set
`NEO4J_BIND_ADDRESS` in `.env` to the instance's private VPC address and restrict
ports 7474 and 7687 with its security group. Never expose them to the public
internet.

Persistent data is stored in the `neo4j_data`, `neo4j_logs`, and
`neo4j_backups` Docker volumes. Mount the Docker data root on EBS, or replace
these named volumes with EBS bind mounts during EC2 provisioning.

## AWS CloudFormation POC

Upload `storage/neo4j-storage-stack.yaml` from the separate `infra` repository
to CloudFormation. It creates a
`c7i-flex.large` EC2 instance, a retained encrypted 50 GiB gp3 data volume mounted at
Docker's data root, and publicly reachable ports `7474` and `7687`. Supply a
Neo4j password when creating the stack. The `Neo4jBrowserUrl` stack output opens
the graph UI; log in as `neo4j` with the supplied password.

The template defaults `PublicIngressCidr` to `0.0.0.0/0` only for the short-lived
demo. Prefer your current public IP with `/32`. Neo4j HTTP and Bolt traffic are
unencrypted in this POC, so do not reuse the password or leave the instance
online unnecessarily.

Useful commands:

```bash
docker compose logs -f
docker compose stop
docker compose start
```
