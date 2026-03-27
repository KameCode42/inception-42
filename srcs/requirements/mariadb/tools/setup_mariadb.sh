#!/bin/bash
set -eu

# Variable interne MariaDB
MYSQL_SOCKET="/run/mysqld/mysqld.sock"
MYSQL_PID_FILE="/run/mysqld/mysqld.pid"

# Enlève les retours ligne
read_secret() {
	tr -d '\r\n' < "$1"
}

# Lecture des secrets
MYSQL_ROOT_PASSWORD="$(read_secret "/run/secrets/db_root_password")"
MYSQL_PASSWORD="$(read_secret "/run/secrets/db_password")"

# verif que le dossier de donnees appartient à l'utilisateur mysql
mkdir -p /run/mysqld /var/lib/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# si MariaDB n'est pas encore initialisée
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initialisation de MariaDB..."

	# init la base systeme si le dossier mysql n'existe pas
	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	# demarre MariaDB pour la configuration, sans reseau
	mysqld \
		--user=mysql \
		--datadir=/var/lib/mysql \
		--socket="$MYSQL_SOCKET" \
		--pid-file="$MYSQL_PID_FILE" \
		--skip-networking &
	MYSQL_PID=$!

	echo "Attente du demarrage de MariaDB..."
	READY=0
	for i in {1..30}; do
		if mysqladmin --socket="$MYSQL_SOCKET" ping --silent >/dev/null 2>&1; then
			echo "MariaDB est pret !"
			READY=1
			break
		fi
		sleep 1
	done

	# si apres 30 essais ca ne repond pas, on echoue proprement
	if [ "$READY" -ne 1 ]; then
		echo "Erreur : MariaDB n'a pas demarre correctement."
		kill "$MYSQL_PID" 2>/dev/null || true
		exit 1
	fi

	# configure MariaDB
	echo "Configuration de MariaDB..."
	mysql --socket="$MYSQL_SOCKET" -u root << EOF
-- Definit le mot de passe root
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- Cree la base de donnees WordPress
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

-- Cree l'utilisateur WordPress
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

-- Donne tous les privileges sur la base WordPress
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

-- Supprime les utilisateurs anonymes
DELETE FROM mysql.user WHERE User='';

-- Applique les changements
FLUSH PRIVILEGES;
EOF

	echo "Configuration terminee."

	mysqladmin --socket="$MYSQL_SOCKET" -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
	wait "$MYSQL_PID"
fi

# lance MariaDB en foreground (PID 1)
echo "Demarrage MariaDB..."
exec mysqld \
	--user=mysql \
	--datadir=/var/lib/mysql \
	--socket="$MYSQL_SOCKET" \
	--pid-file="$MYSQL_PID_FILE"
