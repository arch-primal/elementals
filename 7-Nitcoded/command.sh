#!/bin/bash

# Si se pasa un comando como argumento, ejecútalo
if [[ ! -z "$SSH_ORIGINAL_COMMAND" ]]; then
    $SSH_ORIGINAL_COMMAND
else
    echo "No se permiten sesiones interactivas."
fi
exit
