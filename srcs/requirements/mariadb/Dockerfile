FROM		debian:bookworm

# Installe le server mariadb
RUN 		apt-get update -y && apt-get upgrade -y && \
			apt-get install -y mariadb-server mariadb-client && \
			rm -rf /var/lib/apt/lists/*

# Creer les dossiers utiles à MariaDB
RUN			mkdir -p var/run/mysqld && \
			chown -R mysql:mysql var/run/mysqld && \
			chmod 777 /var/run/mysqld

# Copie le fichier de conf
COPY		conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copie le script
COPY		tools/setup_mariadb.sh /usr/local/bin/setup_mariadb.sh
RUN			chmod +x /usr/local/bin/setup_mariadb.sh

# port standard mariadb
EXPOSE		3306

# lance mariadb via le script
ENTRYPOINT	["/usr/local/bin/setup_mariadb.sh"]