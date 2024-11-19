#!/bin/bash

# Verificar si se proporcionaron los parámetros necesarios
if [ $# -ne 2 ]; then
    echo "Uso: $0 <usuario_origen> <ruta_lista_usuarios>"
    exit 1
fi

# Parámetros
USUARIO_ORIGEN="$1"
LISTA_USUARIOS="$2"

# Verificar si el archivo de lista de usuarios existe
if [ ! -f "$LISTA_USUARIOS" ]; then
    echo "El archivo $LISTA_USUARIOS no existe."
    exit 1
fi

# Obtener la contraseña del usuario original
CONTRASENA=$(getent shadow "$USUARIO_ORIGEN" | cut -d: -f2)
if [ -z "$CONTRASENA" ]; then
    echo "No se pudo obtener la contraseña del usuario $USUARIO_ORIGEN."
    exit 1
fi

# Leer el archivo Lista_Usuarios.txt línea por línea
while IFS=, read -r USUARIO GRUPO; do
    # Eliminar posibles espacios en blanco alrededor
    USUARIO=$(echo "$USUARIO" | xargs)
    GRUPO=$(echo "$GRUPO" | xargs)

    # Verificar si el grupo ya existe, si no, crearlo
    if ! getent group "$GRUPO" > /dev/null 2>&1; then
        echo "Creando grupo $GRUPO..."
        sudo groupadd "$GRUPO"
    fi

    # Verificar si el usuario ya existe
    if ! id "$USUARIO" &>/dev/null; then
        echo "Creando usuario $USUARIO y asignando grupo $GRUPO..."
        # Crear el usuario con el grupo especificado
        sudo useradd -m -g "$GRUPO" -p "$CONTRASENA" "$USUARIO"
    else
        echo "El usuario $USUARIO ya existe, saltando creación."
    fi

    # Asegurarse de que el usuario esté en el grupo adecuado
    sudo usermod -aG "$GRUPO" "$USUARIO"
done < "$LISTA_USUARIOS"

echo "Proceso completado."


