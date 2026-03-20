FROM debian:bookworm

# met a jour les paquets et installe nginx et Openssl
RUN apt-get update && apt-get install -y \
	nginx \
	openssl \
	&& rm -rf /var/lib/apt/lists/*

# dossier pour stocker le certificat et la clef pour une connexion sécurisée
RUN mkdir -p /etc/nginx/ssl

RUN mkdir -p /var/run/nginx