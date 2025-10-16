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
        echo "❌ Timeout: Ollama não iniciou em 2.5 minutos."
        exit 1
    fi
done
echo "✅ Ollama está rodando em 127.0.0.1:11434."

# Agora verifica e puxa o modelo se necessário
if ! ollama list | grep -q mistral:7b; then
    echo "Modelo mistral:7b não encontrado, puxando..."
    ollama pull mistral:7b
else
    echo "✅ Modelo mistral:7b já disponível."
fi

# Aguarda o download terminar (usa loop com timeout)
j=0
until ollama list | grep -q mistral:7b; do
    echo "Aguardando download do modelo mistral:7b terminar... (tentativa $((j+1))/60)"
    sleep 10
    ((j++))
    if [ $j -gt 60 ]; then
        echo "❌ Timeout: Download não completou em 10 minutos."
        exit 1
    fi
done
echo "✅ Download concluído."

# Inicia Nginx no foreground
echo "Iniciando Nginx..."
nginx -g 'daemon off;'
