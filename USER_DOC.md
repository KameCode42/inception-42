Ce projet a été créé dans le cadre du cursus 42 par dle-fur

# Preparer avant de lancer :
- Dans la racine du projet, creer un dossier secrets avec les fichiers .txt utile
mkdir -p secrets
echo "secret123" > secrets/db_root_password.txt
echo "secret123" > secrets/db_password.txt
echo "secret123" > secrets/wp_admin_password.txt
echo "secret123" > secrets/wp_user_password.txt

- Dans le dossier srcs, creer un fichier .env et copier ceci :

LOGIN=dle-fur
DOMAIN_NAME=dle-fur.42.fr
DATA_PATH=/home/dle-fur/data
MYSQL_VOLUME_PATH=/home/dle-fur/data/mariadb
WORDPRESS_VOLUME_PATH=/home/dle-fur/data/wordpress
MYSQL_DATABASE=wordpress_db
MYSQL_USER=wp_user
WP_TITLE=Inception
WP_ADMIN_USER=editor
WP_ADMIN_EMAIL=editor@student.42.fr
WP_USER=wpuser
WP_USER_EMAIL=wpuser@student.42.fr
WP_PATH=/var/www/html

# Lancer le projet :
<img width="79" height="35" alt="Image" src="https://github.com/user-attachments/assets/8ca79162-69fe-4d10-a116-020d663388ed" />
</p>
<img width="320" height="205" alt="Image" src="https://github.com/user-attachments/assets/e4245db4-76bc-4b66-9f50-c411fb1e325e" />

- Controler l'acces via le port 443 :
curl -k -I https://dle-fur.42.fr

- Controler l'acces via le port 80 :
curl -I http://dle-fur.42.fr

- Se connecter a la page admin :
https://dle-fur.42.fr/wp-admin

Changer de port :
- dans dockerfile nginx, mettre EXPOSE 80
- dans nginx.conf, mettre listen 80;
- dans docker-compose dans nginx, mettre "80:80"
- make down pour arreter les container
- rebuild avec la commande suivante :
docker compose --env-file srcs/.env -f srcs/docker-compose.yml up -d --build nginx

# Se connecter a mariadb :
- Entree dans le conteneur
docker exec -it mariadb bash

- Acceder a mariadb
ROOT_PWD="$(tr -d '\r\n' < /run/secrets/db_root_password)"
mysql --socket=/run/mysqld/mysqld.sock -uroot -p"$ROOT_PWD"

- Dans MariaDB :
- Bases de données qui existent sur le serveur
SHOW DATABASES;

- Travaille dans la base wordpress_db
USE wordpress_db;

- Voir les tables
SHOW TABLES;

- Voir les utilisateurs WordPress
SELECT ID, user_login, user_email FROM wp_users;

- Voir les articles
SELECT ID, post_title, post_status FROM wp_posts;

- Quitter mariadb
quit

================

- Créer une table de test :
CREATE TABLE IF NOT EXISTS evaluation_test (
    id INT PRIMARY KEY,
    note VARCHAR(100)
);

- Ajouter une ligne :
INSERT INTO evaluation_test VALUES (1, 'hello evaluation');

- Lire la table :
SELECT * FROM evaluation_test;

- Modifier la ligne :
UPDATE evaluation_test
SET note = 'updated value'
WHERE id = 1;

- Supprimer la ligne :
DELETE FROM evaluation_test
WHERE id = 1;

# Sur la page web :
Depuis le tableau de bord d’administration, modifiez une page :
- Pages
- All Pages
- Edit
- Save

Modifier la page d’accueil :
- Settings
