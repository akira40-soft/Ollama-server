#!/bin/bash
# Start o Ollama em background
ollama serve &
# Aguarde um pouco para o Ollama subir (evite race condition)
sleep 5
# Inicie o nginx em foreground
nginx -g 'daemon off;'
