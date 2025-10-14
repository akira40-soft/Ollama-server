FROM ollama/ollama:latest

# Instale nginx
RUN apt-get update && apt-get install -y nginx

# Copie a configuração customizada do nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copie seu start.sh
COPY start.sh .
RUN chmod +x start.sh

EXPOSE 80

CMD ./start.sh
