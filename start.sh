#!/bin/bash

# Inicia o servidor Ollama em background
echo "Iniciando servidor Ollama..."
ollama serve &

# Aguarda o servidor estar pronto
i=0
until curl -s http://127.0.0.1:11434/api/tags > /dev/null; do
    echo "Aguardando servidor Ollama... (tentativa $((i+1))/30)"
    sleep 5
    ((i++))
    if [ $i -gt 30 ]; then
        echo "❌ Timeout: Ollama não iniciou."
        exit 1
    fi
done
echo "✅ Ollama está rodando."

# Define o modelo básico
MODEL="mistral:7b-instruct-v0.3-q4_0"
echo "Usando modelo: $MODEL"

# Verifica se o modelo está disponível via API
if ! curl -s http://127.0.0.1:11434/api/tags | grep -q $MODEL; then
    echo "Modelo $MODEL não encontrado via API, puxando com retries..."
    for attempt in {1..5}; do
        ollama pull $MODEL && curl -s http://127.0.0.1:11434/api/tags | grep -q $MODEL && break
        echo "Pull falhou na tentativa $attempt. Retentando em 10s..."
        sleep 10
    done
    echo "Modelos disponíveis após pull: $(curl -s http://127.0.0.1:11434/api/tags)"
else
    echo "✅ Modelo $MODEL já disponível via API."
    echo "Modelos disponíveis: $(curl -s http://127.0.0.1:11434/api/tags)"
fi

# Aguarda o download terminar (se necessário)
j=0
until curl -s http://127.0.0.1:11434/api/tags | grep -q $MODEL; do
    echo "Aguardando download do modelo $MODEL... (tentativa $((j+1))/60)"
    sleep 10
    ((j++))
    if [ $j -gt 60 ]; then
        echo "❌ Timeout: Download não completou."
        exit 1
    fi
done
echo "✅ Download concluído."

# Inicia Nginx
echo "Iniciando Nginx..."
nginx -g 'daemon off;'
