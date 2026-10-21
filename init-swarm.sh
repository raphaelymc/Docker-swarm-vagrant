#!/bin/bash

# Interrompe o script se houver erro
set -e

# Verifica o estado atual do Docker Swarm
ESTADO=$(docker info --format '{{.Swarm.LocalNodeState}}')

if [ "$ESTADO" = "inactive" ]; then

    # Inicializa a Master como Manager
    docker swarm init --advertise-addr 192.168.56.10

elif [ "$ESTADO" = "active" ] && [ "$(docker info --format '{{.Swarm.ControlAvailable}}')" = "true" ]; then

    echo "A Master ja esta configurada como Manager."

else

    echo "Erro: estado inesperado do Swarm na Master."
    exit 1

fi

# Cria uma pasta para armazenar o token
mkdir -p /vagrant/.secrets

# Obtém o token de Worker e salva no arquivo
docker swarm join-token -q worker > /vagrant/.secrets/worker-token

# Verifica se o arquivo não está vazio
test -s /vagrant/.secrets/worker-token

echo "Token dos Workers preparado com sucesso."
