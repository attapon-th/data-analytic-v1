#!/bin/bash

NAME_PROJECT="data_analytic"


NETWORK_NAME="data_analytic"

init(){
    mkdir -p ./storage
    chmod 777 ./storage
    update-compose;
    if ! docker network inspect $NETWORK_NAME &> /dev/null; then
        echo "Create Network..."
        create_network;
        echo "Success!!! Create network."
    else
        echo "Network $NETWORK_NAME is exist."
    fi
}
create_network(){
    docker network create --attachable --driver=overlay
}


up(){
    name=$1
    echo "docker compose up -d  [$name]"
    docker-compose  -p $NAME_PROJECT -f docker-compose-$name.yaml up -d
}

logs(){
    name=$1
    echo "docker compose down  [$name]"
    docker-compose  -p $NAME_PROJECT -f docker-compose-$name.yaml logs -f
}
down(){
    vprint;
    docker-compose  -p $NAME_PROJECT down da-$1
}

vprint(){
    echo "Start Project $NAME_PROJECT"
}

up-all(){
    vprint;
    up traefik || exit 1;
    up minio  || exit 1;
    up n8n  || exit 1;
    up vertica  || exit 1;
}

update-compose(){
    #             https://github.com/docker/compose/releases/download/v2.10.1/docker-compose-linux-x86_64
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.10.1/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
}






$@