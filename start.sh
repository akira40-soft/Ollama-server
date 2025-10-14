#!/bin/bash
# Verifica se o modelo existe, se não, puxa
if ! ollama list | grep -q mistral:7b; then
    ollama pull mistral:7b
fi
# Inicia o servidor Ollama
ollama serve
