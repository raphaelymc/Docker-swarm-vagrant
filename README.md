# Meu primeiro cluster Docker Swarm com Vagrant

Este projeto nasceu de um desafio do bootcamp **DevOps da DIO**: criar quatro máquinas virtuais, instalar o Docker e conectá-las em um cluster Swarm.

Na descrição parecia uma sequência simples de tarefas. Na prática, foi um dos projetos mais trabalhosos que fiz durante meus estudos. Eu já tinha usado Ubuntu e Docker, mas ainda não havia criado um ambiente com várias máquinas, cada uma com seu papel, e feito tudo funcionar de maneira automática.

Não queria apenas seguir comandos e chegar ao resultado. Queria entender por que cada configuração era necessária e conseguir explicar o que estava construindo.

## O que construí

Um cluster local com **quatro máquinas Ubuntu 22.04**, criadas pelo **Vagrant** no **VirtualBox**:

```text
                    master
             192.168.56.10
              Manager / Leader
                     |
        +------------+------------+
        |            |            |
      node01       node02       node03
  192.168.56.11 192.168.56.12 192.168.56.13
      Worker       Worker       Worker
```

| Máquina | Papel | CPU | RAM |
|---|---|---:|---:|
| `master` | Manager | 1 vCPU | 1024 MB |
| `node01` | Worker | 1 vCPU | 768 MB |
| `node02` | Worker | 1 vCPU | 768 MB |
| `node03` | Worker | 1 vCPU | 768 MB |

Escolhi configurações enxutas porque estava executando tudo no meu MacBook, sem deixar minhas outras máquinas virtuais ligadas ao mesmo tempo.

## O que deu trabalho de verdade

Primeiro precisei entender a diferença entre **VirtualBox**, que executa as máquinas, e **Vagrant**, que descreve e automatiza a criação delas. Depois vieram os IPs fixos, a instalação do Docker por script e a configuração do Swarm.

Na primeira montagem, entrei em cada Worker e fiz a conexão com a Master manualmente, usando o token gerado pelo Docker. Isso fez o cluster funcionar, mas ainda não resolvia a parte mais interessante do desafio: **como reconstruir tudo sem repetir aquelas etapas?**

Criei então scripts Bash para iniciar o Manager, preparar o token e conectar os Workers. Também encontrei um erro no `Vagrantfile`: uma instrução usava a variável `node` fora do bloco da máquina. Precisei conferir os `end`, entender o escopo do bloco e corrigir o arquivo.

O teste decisivo foi apagar as quatro máquinas do laboratório e tentar novamente com **um único `vagrant up`**. Dessa vez, a Master e os três Workers foram criados e se conectaram automaticamente. Quando rodei `docker node ls`, os quatro apareceram como **Ready**.

## Arquivos do projeto

```text
docker-swarm-vagrant/
├── Vagrantfile         # Define máquinas, redes e provisionamento
├── install-docker.sh   # Instala o Docker em todas as máquinas
├── init-swarm.sh       # Inicializa a Master e prepara o token
├── join-swarm.sh       # Conecta cada Worker ao cluster
├── .gitignore          # Ignora dados locais e tokens
├── evidencias/
│   └── Cluster-swarm-validado.png
└── README.md
```

Usei **Vagrant 2.4.9**, **VirtualBox 7.0.16**, **Ubuntu 22.04** e **Docker 29.1.3**, além de Bash para automatizar o provisionamento.

## Como executar

Com Vagrant e VirtualBox instalados e compatíveis, abra o terminal na pasta do projeto:

```bash
vagrant up
```

Quando terminar, entre na Master e confira o cluster:

```bash
vagrant ssh master
sudo docker node ls
```

O esperado é encontrar `master` como **Leader** e `node01`, `node02` e `node03` como **Ready**.

Para sair do Ubuntu, use `exit`. Para desligar as máquinas sem excluí-las, use `vagrant halt`. Para remover as máquinas criadas pelo projeto, use `vagrant destroy`.

## Como testei

Antes de automatizar tudo, criei um serviço Nginx com três réplicas, limitado a uma por Worker:

```bash
sudo docker service create \
  --name teste-swarm \
  --replicas 3 \
  --replicas-max-per-node 1 \
  --constraint 'node.role==worker' \
  nginx:alpine

sudo docker service ps teste-swarm
```

O Swarm distribuiu uma tarefa em execução para cada Worker (`node01`, `node02` e `node03`).

Depois, removi as quatro máquinas com `vagrant destroy -f`, recriei o ambiente com `vagrant up` e confirmei os quatro nós em estado **Ready** usando `sudo docker node ls`. **Esse segundo teste validou a automação do cluster**; o serviço Nginx foi um teste separado e não é recriado automaticamente.

## Evidência da recriação automática

Esta captura é do teste final, após remover as máquinas e executar apenas `vagrant up`. Ela registra a conexão automática do `node03` e a confirmação dos quatro nós em estado **Ready** pelo comando `sudo docker node ls`.

![Cluster Docker Swarm recriado com os quatro nós Ready](<evidencias/Cluster-swarm-validado.png>)

*Captura de tela original do terminal, sem edições.*

## O que levo desse projeto

Terminei entendendo melhor a diferença entre **ter uma infraestrutura funcionando** e **conseguir reproduzi-la a partir de código**. Também pratiquei Linux, redes, Bash, SSH, Docker Swarm e investigação de erros reais de configuração.

Ainda é um laboratório de aprendizado, não uma infraestrutura pronta para produção. Os tokens ficam em uma pasta local `.secrets/` ignorada pelo Git, e o projeto usa uma rede privada e recursos reduzidos. Não é adequado publicar tokens ou arquivos das máquinas virtuais.

Foi trabalhoso, sim. Mas agora consigo olhar para o cluster e entender melhor o que cada parte faz — e, principalmente, como reconstruí-lo.

---

**Desafio:** Definição de um Cluster Swarm Local com o Vagrant — Bootcamp DevOps da DIO.
