#!/bin/bash

set -e

REGISTRY="localhost:5000"

echo "1. Compilando el código y construyendo las imágenes Docker..."

./mvnw clean install -P buildDocker -DskipTests -Ddocker.image.prefix=${REGISTRY}

echo "2. Subiendo las imágenes al registro local (${REGISTRY})..."

SERVICES=(
  "api-gateway"
  "customers-service"
  "vets-service"
  "visits-service"
)

for SERVICE in "${SERVICES[@]}"; do
  echo "Etiquetando y haciendo push de ${SERVICE}..."
  docker tag ${REGISTRY}/spring-petclinic-${SERVICE}:latest ${REGISTRY}/${SERVICE}:latest
  docker push ${REGISTRY}/${SERVICE}:latest
done

echo "✅ Build y push de todas las imágenes completado con éxito"