#!/bin/bash

kubectl apply -f kubernetes/deployments
kubectl apply -f kubernetes/services
kubectl apply -f kubernetes/persistent-volumes

# Ingress nginx
kubectl apply -f kubernetes/ingress
