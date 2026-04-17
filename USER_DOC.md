Ce projet a été créé dans le cadre du cursus 42 par dle-fur

# Preparer avant de lancer :
- Creer le dossier secret depuis la racine avec les fichiers utiles
mkdir -p secrets && touch secrets/db_root_password.txt secrets/db_password.txt secrets/wp_admin_password.txt secrets/wp_user_password.txt

- Dans le dossier srcs, modifier le fichier .env.example en le transformant en .env et en modifiant les valeurs

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
