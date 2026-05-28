# Fork de Spring PetClinic con auto-instrumentación de OpenTelemetry en Kubernetes

Este repositorio contiene el entorno de laboratorio desarrollado para el Trabajo Final de Grado en Ingeniería Informática de la Universidad Oberta de Catalunya: **"Trazabilidad distribuida en arquitecturas de microservicios: Implementación y análisis de impacto mediante auto-instrumentación con OpenTelemetry"**.

El proyecto toma como base la aplicación de demostración [Spring Petclinic Microservices](https://github.com/spring-petclinic/spring-petclinic-microservices) y la adapta para ser desplegada en un clúster de Kubernetes. Su objetivo principal es evaluar de forma empírica la integración de una arquitectura completa de observabilidad basada en el estándar OpenTelemetry, empleando una estrategias *Zero-Code* (auto-instrumentación).

## 🛠️ Stack Tecnológico

* **Orquestación e infraestructura:** Kubernetes (K3s), Helm, Docker, Container Registry local.
* **Aplicación de demostración:** Java 17, Spring Boot, MySQL.
* **Observabilidad:** OpenTelemetry Operator, OpenTelemetry Collector, Jaeger, OpenSearch, Prometheus.
* **Generación de tráfico sintético:** k6.

## 📂 Estructura del Repositorio

* `docs/`: Contiene la documentación oficial del proyecto, incluyendo el manual técnico completo para desplegar el entorno y ejecutar diferentes experimentos.
* `k8s/`: Manifiestos YAML de Kubernetes organizados por componentes (stack de observabilidad y microservicios de negocio).
* `scripts/`: Utilidades en Bash para la construcción de imágenes, despliegue y limpieza del laboratorio.
* `spring-petclinic-*/`: Código fuente de los distintos microservicios (*API Gateway*, *Customers*, *Vets*, *Visits*) adaptados para el proyecto.

## 🚀 Puesta en Marcha y Experimentación

Para poner en marcha el entorno y ejecutar los experimentos se ha elaborado una **[Guía Técnica de Despliegue y Ejecución](docs/GuiaTecnicaDespliegue.pdf)** ubicada en la carpeta `docs/`. En este documento aparecen:
1. Las instrucciones para aprovisionar la máquina virtual base y levantar el clúster K3s.
2. Los comandos para compilar el código y desplegar el ecosistema completo empaquetados en scripts.
3. Los pasos para ejecutar los **cuatro escenarios prácticos** evaluados en el TFG:
   * Validación de la visibilidad transaccional.
   * Detección de cuellos de botella por saturación de CPU.
   * Diagnóstico rápido de fallos en cascada por caídas de red internas.
   * Análisis crítico del impacto operativo en la infraestructura.
4. Procedimientos para la correcta destrucción y limpieza del entorno.
