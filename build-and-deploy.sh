#!/bin/bash
#Build the local app and deploy it to minikube
kubectl delete service hello-node
kubectl delete deployment hello-node
eval $(minikube docker-env)
docker build -t hello-node:0.0.1 .
kubectl create deployment hello-node --image=hello-node:0.0.1
kubectl expose deployment hello-node --type=LoadBalancer --port=8080 
minikube service hello-node
