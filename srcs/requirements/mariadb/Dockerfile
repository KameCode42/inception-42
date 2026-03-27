FROM		debian:bookworm

# Installe le server mariadb
RUN 		apt-get update && \
			apt-get install -y mariadb-server && \
			rm -rf /var/lib/apt/lists/* && \
			rm -rf /var/lib/mysql/*

# Creer les dossiers utiles à MariaDB
RUN			mkdir -p /run/mysqld /var/lib/mysql && \
			chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copie le fichier de conf
COPY		conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copie le script
COPY		tools/setup_mariadb.sh /usr/local/bin/setup_mariadb.sh
RUN			chmod +x /usr/local/bin/setup_mariadb.sh

# port standard mariadb
EXPOSE		3306

# lance mariadb via le script
ENTRYPOINT	["/usr/local/bin/setup_mariadb.sh"]
