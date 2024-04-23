#!/bin/bash

apt update

apt install docker.io -y

docker swarm init

docker stack deploy -c docker-compose.yml monitoring

GRAFANA_USER="admin"
GRAFANA_PASSWORD="admin"
GRAFANA_API_URL="http://localhost:3000/api/dashboards/db"

import_dashboard() {
  local dashboard_id=$1
  local dashboard_file="$dashboard_id.json"
  
  curl -X POST \
       -u "$GRAFANA_USER:$GRAFANA_PASSWORD" \
       -H "Content-Type: application/json" \
       --data-binary "@$dashboard_file" \
       "$GRAFANA_API_URL"
}

import_dashboard 14857
import_dashboard 18699
import_dashboard 6593

echo "Dashboards imported."
