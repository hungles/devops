#!/bin/bash

#Obtener el archivo de Strimzi
wget "https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.45.0/strimzi-0.45.0.tar.gz"

#Descomprimir el archivo y cambiarle de nombre
tar -xzvf strimzi-0.45.0.tar.gz && mv strimzi-0.45.0/ strimzi/ && cd strimzi/

#Crear un namespace para el cluster de kafka
kubectl create namespace kafka-cluster

#Modificar el Cluster Operator para que apunte al namespace
sed -i 's/namespace: .*/namespace: kafka-cluster/' install/cluster-operator/*RoleBinding*.yaml

#Desplegar el Cluster Operator
kubectl create -f install/cluster-operator -n kafka-cluster

#Mostrar el estado de la instalacion del Cluster Opearator
kubectl get deployments -n kafka-cluster

#Eliminar los archivos de instalacion
cd ../ && rm -rf strimzi-0.45.0.tar.gz* strimzi/
