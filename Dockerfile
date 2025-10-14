FROM ollama/ollama:latest

# Puxa o modelo Mistral:7b no build (opcional, para pré-carregar)
RUN ollama pull mistral:7b

# Expõe a porta da API
EXPOSE 11434

# Comando para rodar o servidor
CMD ["ollama", "serve"]
