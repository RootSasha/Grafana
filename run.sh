#!/bin/bash

# Оновлення системи
echo "Updating system packages..."
apt update && apt upgrade -y

# Встановлення Docker
echo "Installing Docker..."
apt install docker.io -y

# Ініціалізація Docker Swarm
echo "Initializing Docker Swarm..."
docker swarm init

# Деплой стеку
echo "Deploying monitoring stack..."
docker stack deploy -c docker-compose.yml monitoring

# Очікування запуску
echo "Waiting for services to start..."
sleep 20

echo "Monitoring stack deployed successfully!"
