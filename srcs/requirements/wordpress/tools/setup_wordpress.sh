#!/bin/sh
set -eu

# Lecture des secrets
MYSQL_PASSWORD="$(tr -d '\r\n' < /run/secrets/db_password)"
WP_ADMIN_PASSWORD="$(tr -d '\r\n' < /run/secrets/wp_admin_password)"
WP_USER_PASSWORD="$(tr -d '\r\n' < /run/secrets/wp_user_password)"

# Attente active
echo "Attente de la disponibilité de MariaDB..."
until mysqladmin ping -h mariadb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
	echo "MariaDB n'est pas encore prêt - attente..."
	sleep 2
done
echo "MariaDB est prêt !"

cd "$WP_PATH"

# Télécharge les fichiers wordpress
# Premier lancement : téléchargement
# Lancements suivants : ne retélécharge pas
if [ ! -f "$WP_PATH/wp-config.php" ]; then
	echo "Telechargement de WordPress..."
	wp core download --allow-root

	# Créer wp-config.php
	echo "Configuartion de WordPress..."
	wp config create \
		--dbname="${MYSQL_DATABASE}" \
		--dbuser="${MYSQL_USER}" \
		--dbpass="${MYSQL_PASSWORD}" \
		--dbhost=mariadb \
		--allow-root

	# Installion de wordpress
	echo "Installation de WordPress..."
	wp core install \
		--url="https://$DOMAIN_NAME" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--allow-root

	# Création du second utilisateur
	echo "Création du second utilisateur WordPress..."
	wp user create "$WP_USER" "$WP_USER_EMAIL" \
		--user_pass="$WP_USER_PASSWORD" \
		--role=author \
		--allow-root

	echo "WordPress prêt."

	# Change les permissions
	chown -R www-data:www-data "$WP_PATH"
	chmod -R 755 "$WP_PATH"
fi

# Dossier d'installation PHP
mkdir -p /run/php

# Lance php-fpm au premier plan
echo "Demarrage PHP-FPM..."
exec php-fpm8.2 -F