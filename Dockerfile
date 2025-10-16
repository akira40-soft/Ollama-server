FROM ollama/ollama:latest

EXPOSE 11434

CMD ["sh", "-c", "ollama serve"]
