Ce projet a été créé dans le cadre du cursus 42 par dle-fur

# Index :
- [Mise en place des conteneurs](#mise-en-place-des-conteneurs)
- [Construire .env](#construire-env-)
- [Construire dossier secret](#construire-dossier-secret-)
- [Construire docker-compose](#construire-docker-compose-)
- [Construire mariadb](#construire-mariadb-)
- [Construire nginx](#construire-nginx-)
- [Construire wordpress](#construire-wordpress-)

# Mise en place des conteneurs

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
| `db_root_password` | MDP root MariaDB, utilisé uniquement pour l’initialisation/administration de la base |
| `db_password` | MDP de l’utilisateur SQL WordPress (MYSQL_USER), c’est celui que WordPress utilisera pour parler à MariaDB |
| `wp_admin_password` | Mot de passe du compte administrateur WordPress |
| `wp_user_password` | Mot de passe du second utilisateur WordPress |

## Construire docker-compose :
| Variable | Description |
|---|---|
| `services` | permet de déclarer les services obligatoires |
| `mariadb` | nom du service |
| `image` | nom de notre image (même que service) |
| `build` | construire l’image à partir du dossier srcs/requirements/mariadb,
en utilisant le fichier Dockerfile |
| `restart` | permet au conteneur de redémarrer en cas de crash |
| `env_file` | charge les variables d'environnement |
| `environment` | transmet les différentes informations du service |
| `secrets` | monte les secrets à l’intérieur du conteneur |
| `volumes` | stockage persistant de la base |
| `networks` | permet de rejoindre un réseau privé |
| `depends_on` | permet de gérer l'ordre de démarrage |
|---|---|
| `volumes` | volumes déclarés et gérés par Docker Compose |
| `driver: local` | Le driver local est le driver de volume standard de Docker |
| `driver_opts` | ancre leur stockage dans /home/login/data |
| `type` | type de montage / support à déclarer (NFS, exfat), none = pas de type spécial |
| `o` | options de montage, bind = lier le chemin du host |
| `device` | indique la source réelle, donc le chemin hôte que Docker doit utiliser |

## Construire mariadb :
Dockerfile :
RUN chmod +x /usr/local/bin/setup_mariadb.sh :
- Rend le script exécutable

mkdir -p /run/mysqld /var/lib/mysql :
- Prépare les dossiers utiles à MariaDB
- /run/mysqld : utile pour le socket et le PID runtime
- /var/lib/mysql : répertoire de données MariaDB

chown -R mysql:mysql /run/mysqld /var/lib/mysql :
- Donne la propriété au compte système mysql

EXPOSE :
3306 = port MariaDB standard

=================================

conf/50-server.cnf :
- C’est la configuration MariaDB qu’on va fournir à l’image
- écoute correctement
- utilise le bon socket
- utilise le bon répertoire de données
- accepte les connexions sur le réseau Docker

| Variable | Description |
|---|---|
| `[mysqld]` | s'applique au serveur MariaDB |
| `bind_adress = 0.0.0.0` | tous les IP du réseau peuvent se connecter |
| `port = 3306` | port standard MariaDB/MySQL |
| `socket  = /run/mysqld/mysqld.sock` | utilisé pour les connexions locales internes au conteneur |
| `pid-file = /run/mysqld/mysqld.pid` | Créer un fichier PID au démarrage |
| `datadir = /var/lib/mysql` | répertoire de données MariaDB |

=================================

tools/setup_mariadb.sh :
- script du service
- lire les secrets
- vérifier si la base est déjà initialisée
- initialiser MariaDB si besoin
- créer la base WordPress et l’utilisateur SQL au premier lancement
- lancer mariadbd au premier plan

## Construire nginx :
Dockerfile :
- installer nginx et openssl pour TSL
- créer un dossier pour stocker la clé et le certificat
- copie le script de lancement
- EXPOSE 443 = port d'entrée nginx

=================================

generate_ssh.sh :
- script qui permet de générer un certificat auto-signé s'il n'existe pas
- la commande req crée et traite principalement des demandes de certificats et peut créer des certificats auto-signés

| Mot-clé | Description |
|---|---|
| `-x509` | précise le type du certificat (ici format standard) |
| `-nodes` | permet de créer une clé sans mot de passe |
| `-keyout` | stocke la clé |
| `-out` | stocke le certificat |
| `-subj` | remplit automatiquement le certificat |
| `-subj` | remplit automatiquement le certificat |
| `-daemon off` | garde Nginx actif au premier plan |

=================================

nginx.conf :
- permet de paramétrer nginx pour le ssl
- ajouter un nombre de connexions max
- inclure mime.type pour gérer les extensions (HTML, CSS, etc...)
- configurer SSL/TLS
- gérer les requêtes inconnues
- gérer le code php et renvoyer sur le port de wordpress
- fastcgi : canal utilisé pour que nginx envoie les requêtes PHP à php-fpm sur le port 9000

## Construire wordpress :
Dockerfile :
- installation des différents services php
- php-fpm : programme qui exécute le PHP côté serveur

| Service | Description |
|---|---|
| `php-fpm` | cœur du service, exécute le PHP pour nginx |
| `php-cli` | utile pour les scripts d’installation et pour l’automatisation autour de WordPress |
| `php-mysql` | indispensable pour que WordPress parle à MariaDB |
| `curl` | utile pour récupérer WordPress ou d’autres outils dans le script d’installation |
| `mariadb-client` | utile pour tester la disponibilité de MariaDB depuis le conteneur WordPress |
| `ca-certificates` | pratique dès qu’on télécharge quelque chose en HTTPS |
| `tar` | utile si le script télécharge l’archive WordPress et la décompresse |

=================================

www.conf :
- servira à configurer PHP-FPM pour écouter sur le bon port et au bon endroit
- fixe un nombre maximal de requêtes et de réserve
- garde toutes les variables d'environnement disponibles

=================================

setup_wordpress.sh :
- Script de lancement pour wordpress
- Lecture des secrets
- Dossier d'installation
- Attente du vrai lancement de mariadb
- Télécharge les fichiers WordPress
- Configure WordPress

wp config create :
- le nom de la base
- l’utilisateur SQL
- le mot de passe SQL
- l’hôte de la base

wp core install :
- URL du site
- titre du site
- utilisateur admin
- mot de passe admin
- email admin

wp user create :
- Création du second utilisateur WordPress
