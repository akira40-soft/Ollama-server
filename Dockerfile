# Usa a imagem oficial do Ollama como base
FROM ollama/ollama:latest

# Instala dependências necessárias (Nginx e curl)
RUN apt-get update && apt-get install -y nginx curl && rm -rf /var/lib/apt/lists/*

# Define o diretório de trabalho
WORKDIR /app

# Copia os arquivos de configuração e script
COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /app/start.sh

# Garante permissões de execução
RUN chmod +x /app/start.sh

# Define o volume persistente para salvar o modelo (ajustável no Railway)
VOLUME /data/ollama

# Sobrescreve o ENTRYPOINT para executar o script diretamente
ENTRYPOINT ["/app/start.sh"]
