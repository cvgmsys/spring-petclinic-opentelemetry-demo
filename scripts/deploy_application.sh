#!/bin/bash

set -e

echo "🚀 Iniciando el despliegue de Spring Petclinic en Kubernetes..."

echo "1. Preparando el Namespace..."
# Crea el namespace si no existe
kubectl apply -f k8s/0-init/namespaces.yaml

echo "2. Preparando el repositorio de Helm..."
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# ==========================================
# DOMINIO CUSTOMERS
# ==========================================
echo "3. Desplegando dominio CUSTOMERS..."
helm upgrade --install customers-db bitnami/mysql --namespace spring-petclinic -f k8s/2-application/mysql-values.yaml --set fullnameOverride=customers-db

echo "⏳ Esperando a que customers-db arranque..."
kubectl wait --namespace spring-petclinic --for=condition=ready pod -l app.kubernetes.io/instance=customers-db --timeout=300s

echo "📦 Desplegando customers-service..."
kubectl apply -f k8s/2-application/customers-service/

# ==========================================
# DOMINIO VETS
# ==========================================
echo "4. Desplegando dominio VETS..."
helm upgrade --install vets-db bitnami/mysql --namespace spring-petclinic -f k8s/2-application/mysql-values.yaml --set fullnameOverride=vets-db

echo "⏳ Esperando a que vets-db arranque..."
kubectl wait --namespace spring-petclinic --for=condition=ready pod -l app.kubernetes.io/instance=vets-db --timeout=300s

echo "📦 Desplegando vets-service..."
kubectl apply -f k8s/2-application/vets-service/

# ==========================================
# DOMINIO VISITS
# ==========================================
echo "5. Desplegando dominio VISITS..."
helm upgrade --install visits-db bitnami/mysql --namespace spring-petclinic -f k8s/2-application/mysql-values.yaml --set fullnameOverride=visits-db

echo "⏳ Esperando a que visits-db arranque..."
kubectl wait --namespace spring-petclinic --for=condition=ready pod -l app.kubernetes.io/instance=visits-db --timeout=300s

echo "📦 Desplegando visits-service..."
kubectl apply -f k8s/2-application/visits-service/

# ==========================================
# FRONTEND / API GATEWAY
# ==========================================
echo "6. Desplegando API Gateway..."
kubectl apply -f k8s/2-application/apigateway-service/

echo "⏳ Esperando a que API Gateway esté disponible..."
kubectl wait --namespace spring-petclinic --for=condition=available deployment/api-gateway --timeout=300s

echo "✅ Despliegue completado con éxito"
echo "Spring-petclinic UI: http://localhost:30080"