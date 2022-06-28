#!/bin/bash
minikube start
minikube addons enable ingress
CURRENT_PATH=$PWD
eval $(minikube docker-env)
kubectl create secret generic pgpassword --from-literal PGPASSWORD=postgres
echo $CURRENT_PATH
echo $CURRENT_PATH | rev | cut -d "/" -f1  | rev
FILES=(client-deployment.yml server-deployment.yml worker-deployment.yml)
PATH_OF_DOCKERFILES=$(echo $CURRENT_PATH | rev | cut -d "/" -f1  | rev)
docker build -t "$PATH_OF_DOCKERFILES"/docker-infra-client:latest -t "$PATH_OF_DOCKERFILES"/docker-infra-client:latest -f ./client/Dockerfile ./client
docker build -t "$PATH_OF_DOCKERFILES"/docker-infra-server:latest -t "$PATH_OF_DOCKERFILES"/docker-infra-server:latest -f ./server/Dockerfile ./server
docker build -t "$PATH_OF_DOCKERFILES"/docker-infra-worker:latest -t "$PATH_OF_DOCKERFILES"/docker-infra-worker:latest -f ./worker/Dockerfile ./worker
cd $CURRENT_PATH/kubernetes/deployments

# Use local images in minikube - this probably won't work on ubuntu
for key in ${!FILES[@]}; do
    sed -i "" "/^\([[:space:]]*imagePullPolicy: \).*/s//\1Never/" ${FILES[${key}]}
done

cd $CURRENT_PATH

./scripts/apply-resources.sh

# Resetting values changed.
for key in ${!FILES[@]}; do
    sed -i "" "/^\([[:space:]]*imagePullPolicy: \).*/s//\1Always/" ${FILES[${key}]}
done

cd $CURRENT_PATH
# create tunnel at the end
minikube tunnel
