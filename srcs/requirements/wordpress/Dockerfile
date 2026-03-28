FROM		debian:bookworm

# Installe les services utiles
RUN 		apt-get update -y && apt-get upgrade -y && \
			apt-get install -y \
			php8.2-fpm \
			php8.2-mysql \
			php8.2-curl \
			php8.2-gd \
			php8.2-intl \
			php8.2-mbstring \
			php8.2-soap \
			php8.2-xml \
			php8.2-zip \
			curl \
			mariadb-client \
			&& rm -rf /var/lib/apt/lists/*

# Automatise l’installation et l’administration de WordPress
RUN			curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
			chmod +x wp-cli.phar && \
			mv wp-cli.phar /usr/local/bin/wp

# configure PHP-FPM pour le port 9000
RUN			sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|g' /etc/php/8.2/fpm/pool.d/www.conf && \
			sed -i 's|;clear_env = no|clear_env = no|g' /etc/php/8.2/fpm/pool.d/www.conf

# Créer le dossier pour WordPress
RUN			mkdir -p /var/www/html && \
			chown -R www-data:www-data /var/www/html

# Copie le script
COPY		tools/setup_wordpress.sh /usr/local/bin/setup_wordpress.sh
RUN			chmod +x /usr/local/bin/setup_wordpress.sh

# Créer un répertoire WordPress
WORKDIR		/var/www/html

# PHP-FPM écoutera sur 9000 dans le conteneur
EXPOSE		9000

# lance wordpress via le script
ENTRYPOINT	["/usr/local/bin/setup_wordpress.sh"]