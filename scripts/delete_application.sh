#!/bin/bash

echo "🧹 Eliminando Spring Petclinic en el clúster..."

echo "1. Eliminando los microservicios..."
kubectl delete -f k8s/2-application/apigateway-service/ --namespace spring-petclinic --ignore-not-found
kubectl delete -f k8s/2-application/customers-service/ --namespace spring-petclinic --ignore-not-found
kubectl delete -f k8s/2-application/vets-service/ --namespace spring-petclinic --ignore-not-found
kubectl delete -f k8s/2-application/visits-service/ --namespace spring-petclinic --ignore-not-found

echo "2. Desinstalando las bases de datos de MySQL..."
helm uninstall vets-db --namespace spring-petclinic --wait || true
helm uninstall visits-db --namespace spring-petclinic --wait || true
helm uninstall customers-db --namespace spring-petclinic --wait || true

echo "3. Eliminando el namespace..."
kubectl delete namespace spring-petclinic --ignore-not-found

echo "✅ Todos los recursos eliminados del cluster."