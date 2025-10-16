# Use the official Ollama image as base
FROM ollama/ollama

# Set working directory
WORKDIR /app

# Pull the model during build (requires internet access during build)
RUN ollama pull mistral:7b

# Expose the default Ollama port
EXPOSE 11434

# Start Ollama server
CMD ["ollama", "serve"]
