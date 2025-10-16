# Usa a imagem oficial do Ollama como base
FROM ollama/ollama:latest

# Expose the Ollama port
EXPOSE 11434

# Run Ollama server and pull the model on startup
CMD ["sh", "-c", "ollama serve & sleep 5 && ollama pull mistral:7b-instruct-v0.3-q4_0 && wait"]
