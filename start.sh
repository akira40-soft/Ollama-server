#!/bin/bash
# Garante que o modelo está disponível
if ! ollama list | grep -q mistral:7b; then
    ollama pull mistral:7b
fi

# Inicia o Ollama em background
ollama serve &

# Aguarda 5 segundos para garantir startup
sleep 5

# Testa endpoint local e grava no log do Render
curl -v -X POST http://localhost:11434/api/generate -H 'Content-Type: application/json' -d '{"model":"mistral:7b", "prompt":"test"}'

# Sobe o nginx
nginx -g 'daemon off;'
