#!/bin/bash

echo "Eliminando mi aplicacion en Kafka"

kubectl delete -f kafka/volumes/kafka-volumen.yml
kubectl delete -f kafka/services/kafka-services.yml
kubectl delete -f api-json/json-rest.yml
kubectl delete -f kafka/deployments/kafka.yml
kubectl delete -f kafka/deployments/kafka-connect.yml
