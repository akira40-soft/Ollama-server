#!/bin/bash

# Inicia o servidor Ollama em background
echo "Iniciando servidor Ollama..."
ollama serve &

# Aguarda o servidor estar pronto (testa a API com curl)
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

# Verifica e puxa modelo quantizado (mais leve)
MODEL="mistral:7b-instruct-v0.3-q4_0"  # Versão leve, ~2.5 GB
if ! ollama list | grep -q $MODEL; then
    echo "Modelo $MODEL não encontrado, puxando com retries..."
    for attempt in {1..5}; do
        ollama pull $MODEL && break
        echo "Pull falhou na tentativa $attempt. Retentando em 10s..."
        sleep 10
    done
else
    echo "✅ Modelo $MODEL já disponível."
fi

# Aguarda o download terminar
j=0
until ollama list | grep -q $MODEL; do
    echo "Aguardando download do modelo $MODEL... (tentativa $((j+1))/60)"
    sleep 10
    ((j++))
    if [ $j -gt 60 ]; then
        echo "❌ Timeout: Download não completou."
        exit 1
    fi
done
echo "✅ Download concluído."

# Inicia Nginx no foreground
echo "Iniciando Nginx..."
nginx -g 'daemon off;'
