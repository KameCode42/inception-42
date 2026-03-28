Ce projet a été créé dans le cadre du cursus 42 par dle-fur

# Lancer le projet :
<img width="79" height="35" alt="Image" src="https://github.com/user-attachments/assets/8ca79162-69fe-4d10-a116-020d663388ed" />
<img width="320" height="205" alt="Image" src="https://github.com/user-attachments/assets/e4245db4-76bc-4b66-9f50-c411fb1e325e" />

Controler l'acces via le port 443 :
curl -k -I https://dle-fur.42.fr

Controler l'acces via le port 80 :
curl -I http://dle-fur.42.fr

Se connecter a la page admin :
https://dle-fur.42.fr/wp-admin

Depuis le tableau de bord d’administration, modifiez une page :
- Pages
- All Pages
- Edit
- Save

Modifier la page d’accueil :
- Settings

# Se connecter a mariadb :

docker exec -it mariadb bash

ROOT_PWD="$(tr -d '\r\n' < /run/secrets/db_root_password)"

mysql --socket=/run/mysqld/mysqld.sock -uroot -p"$ROOT_PWD" wordpress_db -e "SELECT ID, user_login, user_email FROM wp_users;"

## Créer une table de test

ROOT_PWD="$(tr -d '\r\n' < /run/secrets/db_root_password)"
mysql --socket=/run/mysqld/mysqld.sock -uroot -p"$ROOT_PWD" wordpress_db -e "CREATE TABLE IF NOT EXISTS evaluation_test (id INT PRIMARY KEY, note VARCHAR(100));"

Ajouter une ligne :
mysql --socket=/run/mysqld/mysqld.sock -uroot -p"$ROOT_PWD" wordpress_db -e "INSERT INTO evaluation_test VALUES (1, 'hello evaluation');"

Lire la ligne ajoutee :
mysql --socket=/run/mysqld/mysqld.sock -uroot -p"$ROOT_PWD" wordpress_db -e "SELECT * FROM evaluation_test;"

Modifier la ligne :
mysql --socket=/run/mysqld/mysqld.sock -uroot -p"$ROOT_PWD" wordpress_db -e "UPDATE evaluation_test SET note='updated value' WHERE id=1;"
mysql --socket=/run/mysqld/mysqld.sock -uroot -p"$ROOT_PWD" wordpress_db -e "SELECT * FROM evaluation_test;"

Supprimer la ligne :
mysql --socket=/run/mysqld/mysqld.sock -uroot -p"$ROOT_PWD" wordpress_db -e "DELETE FROM evaluation_test WHERE id=1;"
mysql --socket=/run/mysqld/mysqld.sock -uroot -p"$ROOT_PWD" wordpress_db -e "SELECT * FROM evaluation_test;"
