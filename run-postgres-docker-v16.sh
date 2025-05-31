#!/bin/bash

# ------------------------------------------------------------------------------
#
# This command runs a PostgreSQL 16 database instance in a Docker container.
# It sets the username and password, exposes port 5432 to the host, and
# runs the container in detached mode.
#
# Notes:
#   - The container is named "postgres".
#   - Port 5432 is mapped from the container to the host.
#   - You can connect to this PostgreSQL server with:
#       psql -h localhost -U postgres
#   - Default database will be "postgres".
#   - To stop and remove the container later:
#       docker stop postgres && docker rm postgres
#
# ------------------------------------------------------------------------------

docker run --name postgres \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=password \
  -p 5432:5432 \
  -d --name postgres16 postgres:16
