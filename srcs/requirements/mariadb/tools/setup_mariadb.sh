#!/bin/bash

# -e : le script s’arrête si une commande échoue
# -u : le script s’arrête si une variable non définie est utilisée
set -eu

# centralise les chemins importants
MYSQL_DATA_DIR="/var/lib/mysql"
MYSQL_SOCKET="/run/mysqld/mysqld.sock"
MYSQL_PID_FILE="/run/mysqld/mysqld.pid"

# lit un secret depuis un fichier et supprime les retours ligne
read_secret() {
	tr -d '\r\n' < "$1"
}

escape_sql() {
	printf "%s" "$1" | sed "s/'/''/g"
}

# si la variable existe, continue, sinon arrete le script avec un message clair
: "${MYSQL_DATABASE:?MYSQL_DATABASE is not set}"
: "${MYSQL_USER:?MYSQL_USER is not set}"
: "${MYSQL_ROOT_PASSWORD_FILE:?MYSQL_ROOT_PASSWORD_FILE is not set}"
: "${MYSQL_PASSWORD_FILE:?MYSQL_PASSWORD_FILE is not set}"

# lit la vraie valeur du mot de passe
MYSQL_ROOT_PASSWORD="$(read_secret "$MYSQL_ROOT_PASSWORD_FILE")"
MYSQL_PASSWORD="$(read_secret "$MYSQL_PASSWORD_FILE")"

MYSQL_ROOT_PASSWORD_SQL="$(escape_sql "$MYSQL_ROOT_PASSWORD")"
MYSQL_PASSWORD_SQL="$(escape_sql "$MYSQL_PASSWORD")"
MYSQL_DATABASE_SQL="$(printf "%s" "$MYSQL_DATABASE" | sed 's/`/``/g')"

# preparation des dossiers
mkdir -p /run/mysqld "$MYSQL_DATA_DIR"
chown -R mysql:mysql /run/mysqld "$MYSQL_DATA_DIR"

# initialisation seulement si la base système n'existe pas encore
if [ ! -d "$MYSQL_DATA_DIR/mysql" ]; then
	echo "Initialisation de MariaDB..."

	# initialise le répertoire de donnees MariaDB
	mariadb-install-db \
		--user=mysql \
		--datadir="$MYSQL_DATA_DIR" \
		--auth-root-authentication-method=socket \
		--skip-test-db

	# demarrage temporaire
	mariadbd \
		--user=mysql \
		--datadir="$MYSQL_DATA_DIR" \
		--socket="$MYSQL_SOCKET" \
		--pid-file="$MYSQL_PID_FILE" \
		--skip-networking &
	temp_pid="$!"

	# met en attente le serveur pour eviter un echec
	i=0
	while ! mariadb-admin --socket="$MYSQL_SOCKET" ping >/dev/null 2>&1; do
		i=$((i + 1))
		if [ "$i" -ge 30 ]; then
			echo "Temporary MariaDB server failed to start."
			kill "$temp_pid" 2>/dev/null || true
			exit 1
		fi
		sleep 1
	done

	echo "Configuration de mariadb"

	mariadb --socket="$MYSQL_SOCKET" <<EOF
-- Definie le mot de passe root
ALTER USER 'root'@'localhost'
	IDENTIFIED VIA mysql_native_password
	USING PASSWORD('${MYSQL_ROOT_PASSWORD_SQL}');

-- Creer la base applicative utilisée par WordPress
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE_SQL}\`;

-- Cree l'utilisateur WordPress
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%'
	IDENTIFIED BY '${MYSQL_PASSWORD_SQL}';

-- Donne tous les privileges sur la base WordPress
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE_SQL}\`.* TO '${MYSQL_USER}'@'%';

-- Applique les changements
FLUSH PRIVILEGES;
EOF

	echo "Stopping temporary MariaDB server..."
	mariadb-admin --socket="$MYSQL_SOCKET" -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
fi

echo "Demarrage de mariadb"
exec mariadbd \
	--user=mysql \
	--datadir="$MYSQL_DATA_DIR" \
	--socket="$MYSQL_SOCKET" \
	--pid-file="$MYSQL_PID_FILE"
