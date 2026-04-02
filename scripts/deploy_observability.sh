#!/bin/bash
set -e

echo "🚀 Iniciando el despliegue de las herramientas de Observabilidad en Kubernetes..."

echo "1. (Requisito) Instalando cert-manager..."
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.1/cert-manager.yaml
kubectl wait --for=condition=Available deployment/cert-manager-webhook -n cert-manager --timeout=120s

echo "2. Instalando el Operator de OpenTelemetry..."
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/download/v0.148.0/opentelemetry-operator.yaml
kubectl wait --for=condition=Available deployment/opentelemetry-operator -n opentelemetry-operator-system --timeout=120s

echo "3. Creando el Namespace.."
kubectl apply -f k8s/2-observability/namespace.yaml

# ==========================================
# JAEGER
# ==========================================
echo "3. Desplegando Jaeger.."
kubectl apply -f k8s/2-observability/jaeger.yaml
kubectl wait --for=condition=Ready pod -l app.kubernetes.io/name=jaeger-backend-collector -n observability --timeout=300s

# ==========================================
# OPENTELEMETRY COLLECTOR
# ==========================================
echo "3. Desplegando Otel Collector.."
kubectl apply -f k8s/2-observability/otel-collector.yaml

# ==========================================
# AUTO-INSTRUMENTATION
# ==========================================
echo "3. Configurando auto-instrumentación.."
kubectl apply -f k8s/2-observability/instrumentation.yaml


echo "✅ Despliegue completado con éxito"
echo "Jaeger UI: http://localhost:30686"