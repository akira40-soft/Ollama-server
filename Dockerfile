FROM ollama/ollama:latest

# Instala Nginx e curl
RUN apt-get update && apt-get install -y nginx curl && rm -rf /var/lib/apt/lists/*

# Copia nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Copia e configura start.sh
COPY start.sh .
RUN chmod +x start.sh

# Sobrescreve o ENTRYPOINT para executar o start.sh diretamente
ENTRYPOINT ["./start.sh"]
