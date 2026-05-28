#!/bin/bash
set -e

echo "🚀 Iniciando el despliegue de las herramientas de Observabilidad en Kubernetes..."

echo "1. (Requisito) Instalando cert-manager..."
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.1/cert-manager.yaml
kubectl wait --for=condition=Available deployment/cert-manager-webhook -n cert-manager --timeout=120s
sleep 30

echo "2. Creando namespaces..."
kubectl apply -f k8s/0-init/namespaces.yaml

echo "3. Preparando repositorios de Helm..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add opensearch https://opensearch-project.github.io/helm-charts/
helm repo update

# ==========================================
# OPERATOR OPENTELEMETRY
# ==========================================
echo "4. Instalando el Operator de OpenTelemetry..."
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/download/v0.148.0/opentelemetry-operator.yaml
kubectl wait --for=condition=Available deployment/opentelemetry-operator-controller-manager -n opentelemetry-operator-system --timeout=120s

# ==========================================
# PROMETHEUS
# ==========================================
echo "5. Desplegando Prometheus..."
helm upgrade --install prometheus prometheus-community/prometheus --namespace prometheus --create-namespace -f k8s/1-observability/prometheus-values.yaml

# ==========================================
# OPENSEARCH
# ==========================================
echo "6. Desplegando OpenSearch..."
# sudo sysctl -w vm.max_map_count=262144
helm upgrade --install opensearch opensearch/opensearch -f k8s/1-observability/opensearch-values.yaml --namespace observability
kubectl wait --for=condition=Ready pod -l app.kubernetes.io/component=opensearch-cluster-master -n observability --timeout=300s
# kubectl exec -it opensearch-cluster-master-0 -n observability -- /bin/bash
# curl -XGET https://localhost:9200 -u 'admin:DemoPass123!' --insecure

# ==========================================
# JAEGER
# ==========================================
echo "7. Desplegando Jaeger..."
kubectl apply -f k8s/1-observability/jaeger.yaml
sleep 10
kubectl wait --for=condition=Ready pod -l app.kubernetes.io/name=jaeger-backend-collector -n observability --timeout=300s

# ==========================================
# OPENTELEMETRY COLLECTOR
# ==========================================
echo "8. Desplegando Otel Collector..."
kubectl apply -f k8s/1-observability/otel-collector.yaml

# ==========================================
# AUTO-INSTRUMENTATION
# ==========================================
echo "9. Configurando auto-instrumentación..."
kubectl apply -f k8s/1-observability/instrumentation.yaml


echo "✅ Despliegue completado con éxito"
echo "Jaeger UI: http://localhost:30686"
echo "Prometheus UI: http://localhost:30090"