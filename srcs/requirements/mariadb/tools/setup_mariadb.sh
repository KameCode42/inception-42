#!/bin/bash
set -eu

# Lecture des secrets
MYSQL_ROOT_PASSWORD="$(tr -d '\r\n' < /run/secrets/db_root_password)"
MYSQL_PASSWORD="$(tr -d '\r\n' < /run/secrets/db_password)"

# vérifie que le dossier de données appartient à l'utilisateur mysql
mkdir -p /run/mysqld /var/lib/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# si MariaDB n'est pas encore initialisée
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
	echo "Initialisation de MariaDB..."

	# initialise la base système si le dossier mysql n'existe pas
	if [ ! -d "/var/lib/mysql/mysql" ]; then
		mysql_install_db --user=mysql --datadir=/var/lib/mysql
	fi

	# démarre MariaDB pour la configuration
	mysqld \
		--user=mysql \
		--datadir=/var/lib/mysql \
		--skip-networking &
	MYSQL_PID=$!

	echo "Attente du démarrage de MariaDB..."
	for i in {1..30}; do
		if mysqladmin ping --silent; then
			echo "MariaDB est prêt !"
			break
		fi
		sleep 1
	done

	# configure MariaDB
	echo "Configuration de MariaDB..."
	mysql -u root << EOF
-- Définit le mot de passe root
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- Crée la base de données WordPress
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

-- Crée l'utilisateur WordPress
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

-- Donne tous les privilèges sur la base WordPress
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

-- Supprime les utilisateurs anonymes
DELETE FROM mysql.user WHERE User='';

-- Applique les changements
FLUSH PRIVILEGES;
EOF

	echo "Configuration terminée."

	mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
	wait $MYSQL_PID
fi

# lance MariaDB en foreground (PID 1)
echo "Démarrage MariaDB..."
exec mysqld \
	--user=mysql \
	--datadir=/var/lib/mysql