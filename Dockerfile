FROM ollama/ollama:latest

# Instala nginx para proxy reverso
RUN apt-get update && apt-get install -y nginx

# Copia configurações personalizadas
COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh .
RUN chmod +x start.sh

EXPOSE 80

CMD ["./start.sh"]

