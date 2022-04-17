#!/bin/bash

echo "Building all Docker images..."
docker build -t hakimixx/docker-infra-client:latest -t hakimixx/docker-infra-client:"$GIT_SHA" -f ./client/Dockerfile ./client
docker build -t hakimixx/docker-infra-server:latest -t hakimixx/docker-infra-server:"$GIT_SHA" -f ./server/Dockerfile ./server
docker build -t hakimixx/docker-infra-worker:latest -t hakimixx/docker-infra-worker:"$GIT_SHA" -f ./worker/Dockerfile ./worker

echo "Pusing all Docker images..."
docker push hakimixx/docker-infra-client:latest
docker push hakimixx/docker-infra-server:latest
docker push hakimixx/docker-infra-worker:latest
docker push hakimixx/docker-infra-client:"$GIT_SHA"
docker push hakimixx/docker-infra-server:"$GIT_SHA"
docker push hakimixx/docker-infra-worker:"$GIT_SHA"

echo "Applying kubernetes resources..."
kubectl apply -f kubernetes/deployments
kubectl apply -f kubernetes/services
kubectl apply -f kubernetes/ingress
kubectl apply -f kubernetes/persistent-volumes

echo "Setting latest image for each deployment..."
kubectl set image deployments/client-deployment client=hakimixx/docker-infra-client:"$GIT_SHA"
kubectl set image deployments/server-deployment server=hakimixx/docker-infra-server:"$GIT_SHA"
kubectl set image deployments/worker-deployment worker=hakimixx/docker-infra-worker:"$GIT_SHA"
