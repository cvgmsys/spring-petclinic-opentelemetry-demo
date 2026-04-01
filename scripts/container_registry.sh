#!/bin/bash

set -e

# Comprobamos que se ha pasado exactamente un parámetro
if [ "$#" -ne 1 ]; then
    echo "Error: Se requiere un parámetro."
    echo "Uso: $0 {up|clean}"
    exit 1
fi

ACTION=$1

case "$ACTION" in
    up)
        echo "🚀 Levantando el Container Registry local..."
        
        mkdir -p ~/data-container-reg

        docker run -d \
          -p 5000:5000 \
          --restart=always \
          --name container-registry-local \
          -v ~/data-container-reg:/var/lib/registry \
          registry:2
          
        echo "✅ Container Registry funcionando en el puerto 5000."
        ;;
        
    clean)
        echo "🧹 Limpiando el Container Registry local..."
        
        docker rm -f container-registry-local 2>/dev/null || echo "El contenedor no existía."

        sudo rm -rf ~/data-container-reg
        
        echo "✅ Registry destruido y datos persistentes eliminados."
        ;;
        
    *)
        # Si se recibe un parámetro que no es 'up' o 'clean'
        echo "Parámetro no reconocido: $ACTION"
        echo "Uso: $0 {up|clean}"
        exit 1
        ;;
esac