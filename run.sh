#!/bin/bash

apt update

apt install docker.io -y

docker swarm init

docker stack deploy -c docker-compose.yml monitoring

GRAFANA_USER="admin"
GRAFANA_PASSWORD="admin"
GRAFANA_API_URL="http://localhost:3000/api/dashboards/db"


echo "Dashboards imported."
