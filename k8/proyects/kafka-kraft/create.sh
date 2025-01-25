#!/bin/bash

echo "Deplegando mi aplicacion en Kafka"

kubectl apply -f kafka/volumes/kafka-volumen.yml
kubectl apply -f kafka/services/kafka-services.yml
kubectl apply -f api-json/json-rest.yml
kubectl apply -f kafka/deployments/kafka.yml
kubectl apply -f kafka/deployments/kafka-connect.yml
kubectl apply -f kafka/deployments/kafka-control-center.yml



