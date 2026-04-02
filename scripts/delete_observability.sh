#!/bin/bash

echo "🧹 Iniciando el borrado de las herramientas de Observabilidad en Kubernetes..."

echo "1. Borrando configuración de auto-instrumentación..."
kubectl delete -f k8s/1-observability/instrumentation.yaml --ignore-not-found=true

echo "2. Borrando Otel Collector..."
kubectl delete -f k8s/1-observability/otel-collector.yaml --ignore-not-found=true

echo "3. Borrando Jaeger..."
kubectl delete -f k8s/1-observability/jaeger.yaml --ignore-not-found=true

echo "4. Borrando el Namespace..."
kubectl delete -f k8s/1-observability/namespace.yaml --ignore-not-found=true

echo "5. Desinstalando el Operator de OpenTelemetry..."
kubectl delete -f https://github.com/open-telemetry/opentelemetry-operator/releases/download/v0.148.0/opentelemetry-operator.yaml --ignore-not-found=true

echo "6. Desinstalando cert-manager..."
kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.1/cert-manager.yaml --ignore-not-found=true

echo "✅ Borrado completado con éxito."