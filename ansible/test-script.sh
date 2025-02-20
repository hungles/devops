#!/bin/bash

# Inicializamos un array para almacenar las IPs
declare -a IPS

# Procesamos los argumentos
for ARG in "$@"; do
    # Verificamos si el argumento tiene el formato --ipX=X.X.X.X
    if [[ $ARG =~ --ip[0-9]+=([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) ]]; then
        IP="${BASH_REMATCH[1]}"
        # Validamos que cada octeto de la IP esté entre 0 y 255
        if [[ $IP =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]]; then
            OCT1="${BASH_REMATCH[1]}"
            OCT2="${BASH_REMATCH[2]}"
            OCT3="${BASH_REMATCH[3]}"
            OCT4="${BASH_REMATCH[4]}"
            if (( OCT1 <= 255 && OCT2 <= 255 && OCT3 <= 255 && OCT4 <= 255 )); then
                IPS+=("$IP") # Si todos los octetos son válidos, guardamos la IP
            else
                echo "Error: Dirección IP inválida '$IP'. Los valores deben estar entre 0 y 255."
                exit 1
            fi
        fi
    else
        echo "Error: Argumento inválido '$ARG'. Debe tener la forma --ipX=X.X.X.X"
        exit 1
    fi
done

# Validamos si se ingresaron IPs
if [[ ${#IPS[@]} -eq 0 ]]; then
  echo "Error: No se proporcionaron direcciones IP. Usa el formato --ip1=X.X.X.X --ip2=Y.Y.Y.Y ..."
  exit 1
fi

# Mostramos las IPs ingresadas
for IP in "${IPS[@]}"; do
  echo "$IP"
done

# Aquí podrías usar las IPs en la lógica de tu script, por ejemplo:
# Crear un archivo Vagrantfile dinámico o configurar algo específico con las IPs.

