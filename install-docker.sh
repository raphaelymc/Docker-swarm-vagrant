#!/bin/bash

# Interrompe o script se ocorrer algum erro
set -e

# Atualiza a lista de pacotes do Ubuntu
apt-get update

# Instala o Docker
apt-get install -y docker.io

# Habilita e inicia o serviço Docker
systemctl enable --now docker

# Adiciona o usuário vagrant ao grupo docker
usermod -aG docker vagrant

# Verifica a versão instalada
docker --version
