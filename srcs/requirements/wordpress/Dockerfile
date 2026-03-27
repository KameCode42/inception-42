FROM		debian:bookworm

# Installe les services utiles
RUN 		apt-get update -y && apt-get upgrade -y && \
			apt-get install -y \
			php-fpm \
			php-cli \
			php-mysql \
			curl \
			mariadb-client \
			ca-certificates \
			tar \
			&& rm -rf /var/lib/apt/lists/*

# Automatise l’installation et l’administration de WordPress
RUN			curl -L -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
			chmod +x /usr/local/bin/wp

# Point de montage du volume WordPress
RUN			mkdir -p /run/php /var/www/html && chmod 755 /var/www/html

# Copie le fichier de conf
COPY		conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Copie le script
COPY		tools/setup_wordpress.sh /usr/local/bin/setup_wordpress.sh
RUN			chmod +x /usr/local/bin/setup_wordpress.sh

# PHP-FPM écoutera sur 9000 dans le conteneur
EXPOSE		9000

# lance wordpress via le script
ENTRYPOINT	["/usr/local/bin/setup_wordpress.sh"]
