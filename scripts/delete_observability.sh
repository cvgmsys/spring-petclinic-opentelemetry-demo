#!/bin/bash

echo "🧹 Iniciando la eliminación de las herramientas de Observabilidad en Kubernetes..."

# ==========================================
# AUTO-INSTRUMENTACION, COLLECTOR Y JAEGER
# ==========================================
echo "1. Eliminando Instrumentación, Otel Collector y Jaeger..."
kubectl delete -f k8s/1-observability/instrumentation.yaml --ignore-not-found=true
kubectl delete -f k8s/1-observability/otel-collector.yaml --ignore-not-found=true
kubectl delete -f k8s/1-observability/jaeger.yaml --ignore-not-found=true

# ==========================================
# OPENSEARCH Y PROMETHEUS
# ==========================================
echo "2. Desinstalando Helm releases (OpenSearch y Prometheus)..."
helm uninstall opensearch --namespace observability --ignore-not-found
helm uninstall prometheus --namespace prometheus --ignore-not-found
kubectl delete pvc -l app.kubernetes.io/instance=opensearch -n observability --ignore-not-found=true
kubectl delete pvc -l release=prometheus -n prometheus --ignore-not-found=true

# ==========================================
# OTEL OPERATOR Y CERT-MANAGER
# ==========================================
echo "4. Eliminando OpenTelemetry Operator y cert-manager..."
kubectl delete -f https://github.com/open-telemetry/opentelemetry-operator/releases/download/v0.148.0/opentelemetry-operator.yaml --ignore-not-found=true
kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.1/cert-manager.yaml --ignore-not-found=true

# ==========================================
# NAMESPACES
# ==========================================
echo "5. Eliminando namespaces..."
kubectl delete namespace prometheus --ignore-not-found=true
kubectl delete namespace observability --ignore-not-found=true
kubectl delete namespace cert-manager --ignore-not-found=true
kubectl delete namespace opentelemetry-operator-system --ignore-not-found=true

echo "✅ Borrado completado con éxito."