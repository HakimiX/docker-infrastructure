#!/bin/bash

# deployments
kubectl delete deployment client-deployment
kubectl delete deployment server-deployment
kubectl delete deployment worker-deployment
kubectl delete deployment redis-deployment
kubectl delete deployment postgres-deployment

# services
kubectl delete service client-cluster-ip-service
kubectl delete service server-cluster-ip-service
kubectl delete service postgres-cluster-ip-service
kubectl delete service redis-cluster-ip-service

# persistent volumes
kubectl delete persistentvolumeclaim postgres-persistent-volume-claim

# secrets
kubectl delete secret pgpassword
