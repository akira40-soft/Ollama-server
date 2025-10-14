#!/bin/bash

# Baixa o modelo se não existir
if ! ollama list | grep -q mistral:7b; then
    ollama pull mistral:7b
fi

# Aguarda até o modelo estar realmente listado
until ollama list | grep -q mistral:7b; do
    echo "Aguardando download do modelo mistral:7b terminar..."
    sleep 10
done

# Sobe Ollama
ollama serve &

sleep 5

# Sobe nginx
nginx -g 'daemon off;'
