FROM ollama/ollama:latest

# Expõe a porta da API Ollama
EXPOSE 11434

# Copia o script start.sh
COPY start.sh .
RUN chmod +x start.sh

# Define o script como o comando principal
CMD ["./start.sh"]
