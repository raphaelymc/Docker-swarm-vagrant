#!/bin/bash

# Interrompe a execução se ocorrer algum erro
set -e

# Endereço da Master
MASTER_IP="192.168.56.10"

# Caminho do arquivo que contém o token
TOKEN_FILE="/vagrant/.secrets/worker-token"

# Verifica o estado atual do Swarm
ESTADO=$(docker info --format '{{.Swarm.LocalNodeState}}')

if [ "$ESTADO" = "inactive" ]; then

    # Verifica se o arquivo do token existe e não está vazio
    if [ ! -s "$TOKEN_FILE" ]; then
        echo "Erro: token do Swarm nao encontrado."
        exit 1
    fi

    # Lê o token salvo pela Master
    TOKEN=$(cat "$TOKEN_FILE")

    # Conecta a máquina ao cluster como Worker
    docker swarm join --token "$TOKEN" "$MASTER_IP:2377"

    echo "Worker conectado ao Swarm com sucesso."

elif [ "$ESTADO" = "active" ]; then

    # Confirma que a máquina não é um Manager
    if [ "$(docker info --format '{{.Swarm.ControlAvailable}}')" = "false" ]; then
        echo "Esta maquina ja participa de um Swarm como Worker."
    else
        echo "Erro: esta maquina esta configurada como Manager."
        exit 1
    fi

else
    echo "Erro: estado inesperado do Docker Swarm."
    exit 1
fi
