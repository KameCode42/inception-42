# CREATION DE FICHIER

## Construire .env :
| Variable | Description |
|---|---|
| `LOGIN` | construire le domaine login.42.fr, construire les chemins hôtes sous /home/login/data |
| `DOMAIN_NAME` | nom que nginx servira en HTTPS |
| `DATA_PATH` | la racine de la persistance côté machine hôte |
| `MYSQL_VOLUME_PATH` | Chemin hôte du stockage persistant MariaDB |
| `WORDPRESS_VOLUME_PATH` | Chemin hôte du stockage persistant WordPress |
| `MYSQL_DATABASE` | Nom de la base utilisée par WordPress |
| `MYSQL_USER` | Nom de l’utilisateur SQL utilisé par WordPress pour se connecter à MariaDB |
| `MYSQL_HOST` | Nom du service Docker de la base |
| `WP_TITLE` | Titre du site WordPress |
| `WP_ADMIN_USER` | Nom du compte administrateur WordPress |
| `WP_ADMIN_EMAIL` | Email du compte admin WordPress |
| `WP_USER` | Nom du second utilisateur WordPress |
| `WP_USER_EMAIL` | Email du second utilisateur |
| `WP_PATH` | Chemin interne où WordPress sera installé dans les conteneurs wordpress et nginx |

## Construire dossier secret :
| Fichier | Description |
|---|---|
| `db_root_password` | MDP root MariaDB, Utilisé uniquement pour l’initialisation/administration de la base |
| `db_password` | MDP de l’utilisateur SQL WordPress (MYSQL_USER), C’est celui que WordPress utilisera pour parler à MariaDB |
| `wp_admin_password` | Mot de passe du compte administrateur WordPress |
| `wp_user_password` | Mot de passe du second utilisateur WordPress |
