Ce projet a été créé dans le cadre du cursus 42 par dle-fur

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
| `db_root_password` | MDP root MariaDB, Utilisé uniquement pour l’initialisation/administration de la base |
| `db_password` | MDP de l’utilisateur SQL WordPress (MYSQL_USER), C’est celui que WordPress utilisera pour parler à MariaDB |
| `wp_admin_password` | Mot de passe du compte administrateur WordPress |
| `wp_user_password` | Mot de passe du second utilisateur WordPress |

## Construire docker-compose :
| Variable | Description |
|---|---|
| `services` | permet de declarer les service obligatoire |
| `mariadb` | nom du service |
| `image` | nom de notre image (meme que service) |
| `build` | construire l’image à partir du dossier srcs/requirements/mariadb,
en utilisant le fichier Dockerfile |
| `restart` | permet au conteneur de redemarrer en cas de crash |
| `env_file` | charge les variables d'environnement |
| `environment` | transmets les differents informations du service |
| `secrets` | monte les secrets à l’intérieur du conteneur |
| `volumes` | stockage persistant de la base |
| `networks` | permet de rejoindre un reseau prive |
| `depends_on` | permet de gerer l'ordre de demarrage |
|---|---|
| `volumes` | volumes déclarés et gérés par Docker Compose |
| `driver: local` | Le driver local est le driver de volume standard de Docker |
| `driver_opts` | ancre leur stockage dans /home/login/data |
| `type` | type de montage / support a declarer (NFS, exfat), none=pas de type spécial|
| `o` | options de montage, bind=lier le chemin du host |
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
3306 =  port MariaDB standard

=================================

conf/50-server.cnf :
- C’est la configuration MariaDB qu’on va fournir à l’image
- écoute correctement
- utilise le bon socket
- utilise le bon répertoire de données
- accepte les connexions sur le réseau Docker

| Variable | Description |
|---|---|
| `[mysqld]` | s'applique au server mariadb |
| `bind_adress = 0.0.0.0` |  tous les IP du réseau peuvent se connecter |
| `port = 3306` | port standard MariaDB/MySQL |
| `socket  = /run/mysqld/mysqld.sock` | utilisé pour les connexions locales internes au conteneur |
| `pid-file = /run/mysqld/mysqld.pid` | Creer un fichier PID au demarrage |
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
- creer un dossier pour stocker la clef et le certificat
- copie le script de lancement
- EXPOSE 443 = port d'entree nginx

=================================

generate_ssh.sh :
- script qui permet de generer un certificat auto-signe si il n'existe pas
- commande req crée et traite principalement des demandes de certificats et peut créer des certificats auto-signés

| Mot-cle | Description |
|---|---|
| `-x509` | précise le type du certificat (ici format standard) |
| `-nodes` | permet de creer une clef sans mot de passe |
| `-keyout` | stocke la clef |
| `-out` | stocke le certificat |
| `-subj` | rempli automatiquement le certificat |
| `-subj` | rempli automatiquement le certificat |
| `-daemon off` | garde Nginx actif au premier plan |

=================================

nginx.conf :
- permet de parametrer nginx pour le ssl
- ajouter un nombre de connections max
- inclure mime.type pour gerer les extensions (HTML, CSS, etc...)
- configurer SSL/TLS
- gerer les requetes inconnus
- gerer le code php et renvoyer sur le port de wordpress

## Construire wordpress :
Dockerfile :













