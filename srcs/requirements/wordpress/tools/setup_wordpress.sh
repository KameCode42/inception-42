#!/bin/sh
set -eu

WP_PATH="${WP_PATH:-/var/www/html}"

# Enlève les retours ligne
read_secret() {
	tr -d '\r\n' < "$1"
}

# Lecture des secrets
MYSQL_PASSWORD="$(read_secret "/run/secrets/db_password")"
WP_ADMIN_PASSWORD="$(read_secret "/run/secrets/wp_admin_password")"
WP_USER_PASSWORD="$(read_secret "/run/secrets/wp_user_password")"

# Dossier d'installation wordpress
mkdir -p /run/php "$WP_PATH"
chown -R www-data:www-data /run/php "$WP_PATH"

# Attente active
echo "Attente de MariaDB..."
i=0
until mariadb -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; do
	i=$((i + 1))
	if [ "$i" -ge 60 ]; then
		echo "MariaDB n'est pas pret."
		exit 1
	fi
	sleep 2
done

# Telecharge les fichiers wordpress
# Premier lancement : téléchargement
# Lancements suivants : ne retélécharge pas
if [ ! -f "$WP_PATH/wp-load.php" ]; then
	echo "Telechargement de WordPress..."
	wp core download \
		--path="$WP_PATH" \
		--allow-root
fi

# Crée wp-config.php
if [ ! -f "$WP_PATH/wp-config.php" ]; then
	echo "Creation de wp-config.php..."
	wp config create \
		--path="$WP_PATH" \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost="$MYSQL_HOST:3306" \
		--allow-root \
		--skip-check
fi

# Teste si le site WordPress a déjà été installé
# Installion de wordpress
if ! wp core is-installed --path="$WP_PATH" --allow-root >/dev/null 2>&1; then
	echo "Installation de WordPress..."
	wp core install \
		--path="$WP_PATH" \
		--url="https://$DOMAIN_NAME" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--allow-root
fi

# Création du second utilisateur
if ! wp user get "$WP_USER" --path="$WP_PATH" --allow-root >/dev/null 2>&1; then
	echo "Création du second utilisateur WordPress..."
	wp user create "$WP_USER" "$WP_USER_EMAIL" \
		--path="$WP_PATH" \
		--user_pass="$WP_USER_PASSWORD" \
		--role=author \
		--allow-root
fi

echo "WordPress prêt."

chown -R www-data:www-data "$WP_PATH"

# Lance php-fpm au premier plan
echo "Demarrage PHP-FPM..."
exec php-fpm8.2 -F
