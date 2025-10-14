FROM ollama/ollama:latest

RUN apt-get update && apt-get install -y nginx curl

COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh .
RUN chmod +x start.sh

EXPOSE 80

CMD ["./start.sh"]
