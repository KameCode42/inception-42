Ce projet a été créé dans le cadre du cursus 42 par dle-fur

# Lancer le projet :
<img width="79" height="35" alt="Image" src="https://github.com/user-attachments/assets/8ca79162-69fe-4d10-a116-020d663388ed" /> <img width="320" height="205" alt="Image" src="https://github.com/user-attachments/assets/e4245db4-76bc-4b66-9f50-c411fb1e325e" />

Controler l'acces via le port 443 :
- curl -k -I https://dle-fur.42.fr

Controler l'acces via le port 80 :
- curl -I http://dle-fur.42.fr

Se connecter a la page admin :
- https://dle-fur.42.fr/wp-admin

Depuis le tableau de bord d’administration, modifiez une page :
- Pages
- All Pages
- Edit
- Save

Modifier la page d’accueil :
- Settings

# Se connecter a mariadb :
- docker exec -it mariadb sh
- ROOT_PWD="$(tr -d '\r\n' < /run/secrets/db_root_password)"
- mysql --socket=/run/mysqld/mysqld.sock -uroot -p"$ROOT_PWD"

Dans MariaDB :
- SHOW DATABASES - bases de données qui existent sur le serveur
- USE wordpress_db - travaille dans la base wordpress_db
- SHOW TABLES - Voir les tables
- SELECT ID, user_login, user_email FROM wp_users - voir les utilisateurs WordPress
- SELECT ID, post_title, post_status FROM wp_posts - voir les articles

Créer une table de test :
- CREATE TABLE IF NOT EXISTS evaluation_test (
    id INT PRIMARY KEY,
    note VARCHAR(100)
);

Ajouter une ligne :
- INSERT INTO evaluation_test VALUES (1, 'hello evaluation');

Lire la table :
- SELECT * FROM evaluation_test;

Modifier la ligne :
- UPDATE evaluation_test
- SET note = 'updated value'
- WHERE id = 1;

Supprimer la ligne :
- DELETE FROM evaluation_test
- WHERE id = 1;
