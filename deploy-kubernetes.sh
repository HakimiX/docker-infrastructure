#!/bin/bash

kubectl apply -f kubernetes/deployments
kubectl apply -f kubernetes/services
kubectl apply -f kubernetes/persistent-volumes
