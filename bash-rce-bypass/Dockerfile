FROM ubuntu:latest

RUN apt-get update && \
		apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
		nodejs php-cli dnsutils

COPY app/index.php /opt/

WORKDIR /opt

CMD ["php", "-S", "0.0.0.0:3000"]
