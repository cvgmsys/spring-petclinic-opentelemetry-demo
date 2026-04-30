#!/bin/bash

# Comprobar si K6 está instalado
if ! command -v k6 &> /dev/null; then
    echo "Instalando k6..."
    
    sudo gpg -k
    sudo gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
    echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list
    
    sudo apt-get update
    sudo apt-get install -y k6
    
    echo "✅ k6 instalado correctamente."
    echo "--------------------------------------------------------"
fi

echo "🚀 Iniciando generador de carga K6..."
echo "Selecciona el escenario a ejecutar:"
echo "1) Escenario 1: Línea Base (Tráfico estable de 10 minutos)"
echo "2) Escenario 2: Prueba de Estrés (Pico de tráfico)"
echo "0) Salir"

read -p "Elige una opción [0-2]: " opcion

case $opcion in
    1)
        echo "Ejecutando Línea Base..."
        k6 run ./k6/baseline_load_test.js
        ;;
    2)
        echo "Ejecutando Prueba de Estrés..."
        k6 run ./k6/stress_test.js
        ;;
    0)
        exit 0
        ;;
    *)
        echo "Opción no válida."
        exit 1
        ;;
esac