FROM ubuntu:latest

RUN apt-get update && \
		apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages nodejs npm && \
		npm install express cookie-parser node-serialize

COPY app/app.js /opt/

CMD ["/usr/bin/node", "/opt/app.js"]
