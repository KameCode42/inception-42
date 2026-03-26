FROM		debian:bookworm

# Installe nginx et openssl pour TLS
RUN			apt-get update -y \
			&& apt-get install nginx -y \
			&& apt-get install openssl -y \
			&& rm -rf /var/lib/apt/lists/*

# stocker le certificat et la clef pour une connexion sécurisée
RUN			mkdir -p /etc/nginx/ssl /var/www/html
RUN			chmod 755 /var/www/html

# Copie le fichier de conf
COPY		conf/nginx.conf /etc/nginx/nginx.conf

# Copie le script pour la clef
COPY		tools/generate_ssl.sh /usr/local/bin/
RUN			chmod +x /usr/local/bin/generate_ssl.sh

# port d'entree nginx
EXPOSE		443

ENTRYPOINT	["/usr/local/bin/generate_ssl.sh"]
