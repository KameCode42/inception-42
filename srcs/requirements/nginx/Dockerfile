FROM		debian:bookworm

# Installe nginx et openssl pour TLS
RUN			apt-get update -y && apt-get upgrade -y && \
			apt-get install -y nginx openssl && \
			rm -rf /var/lib/apt/lists/*

# Stocke le certificat et la clef pour une connexion sécurisée
RUN			mkdir -p /etc/nginx/ssl /var/www/html

# Copie le fichier de conf
COPY		./conf/nginx.conf /etc/nginx/nginx.conf

# Copie le script pour la clef
COPY		./tools/generate_ssl.sh /usr/local/bin/generate_ssl.sh
RUN			chmod +x /usr/local/bin/generate_ssl.sh

# Port d'entree nginx
EXPOSE		443

# Génére la clef via le script
ENTRYPOINT	["/usr/local/bin/generate_ssl.sh"]