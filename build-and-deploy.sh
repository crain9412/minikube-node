#!/bin/bash
#Build the local app and deploy it to minikube

APP_NAME="hello-node"
MINIKUBE_STATUS=$(minikube status | grep "host\: Running")
SERVICE_STATUS=$(kubectl get services | grep "${APP_NAME}")
DEPLOYMENT_STATUS=$(kubectl get deployments | grep "${APP_NAME}")

if [ -z "${MINIKUBE_STATUS}" ]; then
	minikube start
fi

if [ "${SERVICE_STATUS}" ]; then
	kubectl delete service ${APP_NAME}
fi

if [ "${DEPLOYMENT_STATUS}" ]; then
	kubectl delete deployment ${APP_NAME}
fi

eval $(minikube docker-env)
docker build -t ${APP_NAME}:0.0.1 .
kubectl create deployment ${APP_NAME} --image=${APP_NAME}:0.0.1
kubectl expose deployment ${APP_NAME} --type=LoadBalancer --port=8080 
minikube service ${APP_NAME}
