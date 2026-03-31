#!/bin/bash

set -e

echo "🚀 Iniciando el despliegue de Spring Petclinic en Kubernetes..."

echo "1. Preparando el Namespace..."
# Crea el namespace si no existe
kubectl apply -f k8s/0-init/namespace.yaml

echo "2. Desplegando las bases de datos MySQL con Helm..."
# Añadimos el repositorio de Bitnami
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
# Instalamos las 3 bases de datos usando nuestro archivo values
helm upgrade --install vets-db bitnami/mysql --namespace spring-petclinic -f k8s/0-init/mysql-values.yaml
helm upgrade --install visits-db bitnami/mysql --namespace spring-petclinic -f k8s/0-init/mysql-values.yaml
helm upgrade --install customers-db bitnami/mysql --namespace spring-petclinic -f k8s/0-init/mysql-values.yaml

echo "Esperando a que las bases de datos arranquen (esto puede tardar un par de minutos)..."
# Kubernetes esperará hasta que los pods de MySQL estén listos antes de lanzar los microservicios de Java
kubectl wait --namespace spring-petclinic --for=condition=ready pod -l app.kubernetes.io/name=mysql --timeout=300s

echo "3. Desplegando los microservicios..."
kubectl apply -f k8s/apigateway-service/
kubectl apply -f k8s/customers-service/
kubectl apply -f k8s/vets-service/
kubectl apply -f k8s/visits-service/

echo "✅ Despliegue completado con éxito"