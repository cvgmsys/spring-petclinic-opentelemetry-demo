#!/bin/bash

set -e

echo "🚀 Iniciando el despliegue secuencial de Spring Petclinic en Kubernetes..."

echo "1. Preparando el Namespace..."
# Crea el namespace si no existe
kubectl apply -f k8s/0-init/namespace.yaml

echo "2. Preparando el repositorio de Helm..."
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# ==========================================
# DOMINIO CUSTOMERS
# ==========================================
echo "3. Desplegando dominio CUSTOMERS..."
helm upgrade --install customers-db bitnami/mysql --namespace spring-petclinic -f k8s/0-init/mysql-values.yaml --set fullnameOverride=customers-db

echo "⏳ Esperando a que customers-db arranque..."
kubectl wait --namespace spring-petclinic --for=condition=ready pod -l app.kubernetes.io/instance=customers-db --timeout=300s

echo "📦 Desplegando customers-service..."
kubectl apply -f k8s/customers-service/

# ==========================================
# DOMINIO VETS
# ==========================================
echo "4. Desplegando dominio VETS..."
helm upgrade --install vets-db bitnami/mysql --namespace spring-petclinic -f k8s/0-init/mysql-values.yaml --set fullnameOverride=vets-db

echo "⏳ Esperando a que vets-db arranque..."
kubectl wait --namespace spring-petclinic --for=condition=ready pod -l app.kubernetes.io/instance=vets-db --timeout=300s

echo "📦 Desplegando vets-service..."
kubectl apply -f k8s/vets-service/

# ==========================================
# DOMINIO VISITS
# ==========================================
echo "5. Desplegando dominio VISITS..."
helm upgrade --install visits-db bitnami/mysql --namespace spring-petclinic -f k8s/0-init/mysql-values.yaml --set fullnameOverride=visits-db

echo "⏳ Esperando a que visits-db arranque..."
kubectl wait --namespace spring-petclinic --for=condition=ready pod -l app.kubernetes.io/instance=visits-db --timeout=300s

echo "📦 Desplegando visits-service..."
kubectl apply -f k8s/visits-service/

# ==========================================
# FRONTEND / API GATEWAY
# ==========================================
echo "6. Desplegando API Gateway..."
kubectl apply -f k8s/apigateway-service/

echo "✅ Despliegue completado con éxito"