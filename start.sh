#!/bin/bash

# Define o diretório persistente para os modelos (compatível com volume do Railway)
export OLLAMA_MODELS=/data/ollama/models
mkdir -p "$OLLAMA_MODELS"

# Inicia o servidor Ollama em background
echo "Iniciando servidor Ollama..."
ollama serve &

# Aguarda o servidor Ollama estar pronto
i=0
until curl -s http://127.0.0.1:11434/api/tags > /dev/null 2>&1; do
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

# Verifica se o modelo está disponível via API e puxa apenas se necessário
if ! curl -s http://127.0.0.1:11434/api/tags | grep -q "$MODEL"; then
    echo "Modelo $MODEL não encontrado via API, puxando com retries..."
    for attempt in {1..5}; do
        ollama pull "$MODEL" && sleep 5 && curl -s http://127.0.0.1:11434/api/tags | grep -q "$MODEL" && break
        echo "Pull falhou na tentativa $attempt. Retentando em 10s..."
        sleep 10
    done
    echo "Modelos disponíveis após pull: $(curl -s http://127.0.0.1:11434/api/tags)"
else
    echo "✅ Modelo $MODEL já disponível via API."
    echo "Modelos disponíveis: $(curl -s http://127.0.0.1:11434/api/tags)"
fi

# Aguarda o Ollama carregar o modelo completamente
j=0
until curl -s -X POST http://127.0.0.1:11434/api/generate -H "Content-Type: application/json" -d "{\"model\":\"$MODEL\",\"prompt\":\"teste\"}" 2>/dev/null | grep -q "response"; do
    echo "Aguardando Ollama carregar o modelo... (tentativa $((j+1))/60)"
    sleep 10
    ((j++))
    if [ $j -gt 60 ]; then
        echo "❌ Timeout: Modelo não carregado."
        exit 1
    fi
done
echo "✅ Modelo carregado com sucesso."

# Inicia o Nginx em foreground
echo "Iniciando Nginx..."
nginx -g 'daemon off;'
