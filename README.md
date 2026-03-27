Ce projet a été créé dans le cadre du cursus 42 par dle-fur

# Index :
- [Descriptions](#Inception)

# 1. Descriptions :
# Inception :
- Inception est un projet d’administration système dont l’objectif est de mettre en place, dans une machine virtuelle, une petite infrastructure web gérée avec Docker Compose
- Il consiste à relier plusieurs images Docker et à pouvoir les lancer ensemble, sans pour autant qu’elles perdent leur indépendance (grâce à Docker Compose)

Le projet repose sur plusieurs conteneurs séparés :
- NGINX sert de point d’entrée unique en HTTPS (TSL 1.2/1.3) sur le port 443

- WordPress fonctionne avec PHP-FPM (sans NGINX)

- MariaDB gère la base de données.
Les services communiquent via un réseau Docker dédié, et les données persistantes (base de données et fichiers WordPress) sont stockées dans des volumes nommés, sauvegardés sur l’hôte dans /home/<login>/data

Le tag latest est interdit :
- Il faut préciser quelle version est installée
- Aucun mot de passe ne doit être présent dans vos Dockerfiles.
- L’utilisation des variables d’environnement est obligatoire.
- La mise en place d’un fichier .env afin de stocker vos variables d’environnement est fortement conseillée.
- Le conteneur NGINX doit être le seul point d’entrée de votre infrastructure, via le port 443 uniquement, en utilisant le protocole TSLv1.2 ou TSLv1.3.
(Le port 443 permet l’accès via https://, et le port 80 via http://.)

## OS différents :
Alpine Linux :
- C’est une distribution Linux légère, orientée sécurité. Elle contient le moins de fichiers et d’outils possible afin de laisser au développeur la possibilité de les installer lui-même si besoin.

Debian :
- C’est un système d’exploitation universel. Les systèmes Debian utilisent actuellement le noyau Linux (et, dans certains cas, le noyau FreeBSD).

#

# 2. Instructions :
# Docker :
- Docker permet d'utiliser plusieurs services grâce à des conteneurs. Ces conteneurs sont indépendants les uns des autres, mais pourront communiquer ensemble si nécessaire.
- Une des forces de Docker, est la possibilité de démarrer et d'arrêter des services très rapidement.

Avantage docker :
- Compatible avec tous les environnements
- Chaque conteneur tourne séparément
- Lancement rapide des conteneurs
- Plus leger qu'une machine virtuelle
- Creer plusieurs conteneurs qui sont baser sur une image
- Creer un server web facilement

Différences entre VM et conteneur :

Conteneur :
- Le conteneur empaqute l'appli + les dependances, tourne comme un process isoler sur le meme noyau que l'hote (partage le noyau)
- Leger, rapide a demarrer

VM :
- Virutalise une machine entiere et a son propre systeme d'exploitation avec noyau
- Plus lourd et plus lent

## Les differents composants Docker :
Conteneur :
- Un conteneur est une instance de l'image. Lorsque l'image est lancee, ca creer un conteneur qui a un process, un etat
- Un conteneur est construit grace a une image
- Il est possible de lancer plusieurs conteneur sur la meme image

Image :
- Une image contient toutes les informations pour la creation d'un conteneur. Le code, les dependances, une configuration de demarrage etc.
- Le conteneur va se baser sur une image pour se creer
- Une image personnaliser est toujours baser sur une image qui existe deja

Dockerfile :
- Le dockerfile permet de creer une image personnaliser afin d etre utiliser pour creer des conteneur.

docker-compose.yml :
- C'est un outil qui a été développé pour aider à définir et à partager des applications multi-conteneurs.
- Créer un fichier YAML pour définir les services et, à l'aide d'une seule commande, tout mettre en route ou tout démonter.
- Compose permet de gérer des applications qui utilisent plusieurs containers et de communiquer entre eux.
- Pour gerer l'ensemble des containers

## Commandes Docker :
| Commande | Description |
|---|---|
| `docker build -t <mon_image> .` | Construit l'image personnalise grace au Dockerfile |
| `docker run <mon_image>` | Crée un conteneur à partir de cette image. |
| `docker run <mon_image> --name=<nom_conteneur>` | Donne un nom au conteneur |
| `docker run -it <mon_image>` | Lance le conteneur en mode interactif pour pouvoir utiliser la console. |
| `docker run -it --rm <mon_image>` | Lance le conteneur en mode interactif et le supprime automatiquement à la sortie. |
| `docker ps` | Liste les conteneurs en cours d’exécution. |
| `docker ps -a` | Liste tous les conteneurs présents sur la machine. |
| `docker image ls` | Liste toutes les images disponibles sur le système. |
| `docker rm <id_conteneur>` | Supprime un conteneur. |
| `docker image rm <id_image>` | Supprime une image. |
| `docker start <id_conteneur>` | Démarre un conteneur arrêté. |
| `docker start -ai <id_conteneur>` | Démarre un conteneur et permet d’interagir avec lui en une seule commande. |
| `docker stop <id_conteneur>` | Arrête un conteneur en cours d’exécution. |
| `docker exec -it <id_conteneur> bash` | Ouvre un terminal dans un conteneur déjà en cours d’exécution. `exit` ne stoppe pas le conteneur. |
| `docker exec <id_conteneur> touch index.js` | Exécute une commande dans un conteneur sans y entrer. |
| Volume |
|---|---|
| `docker volume create <mon_volume>` | permet de creer un volume dans docker |
| `docker volume ls` | liste les volumes |
| `docker volume rm <mon_volume>` | supprimer un volume |
| `docker volume inspect <mon_volume>` | permet de connaitre des details sur le volume |
| Port |
|---|---|
| `docker run -p <port_local>:<port_conteneur> <mon_image>` | permet de mapper des ports |
| Reseau |
|---|---|
| `docker network ls` | liste les reseaux docker|
| `docker network create --driver=<DRIVER> <mon_nom_reseau>` | Creer un reseau personnalise |
| `docker run --network=<NAME_reseau> <image>` | Creer un conteneur et le relie au reseau |
| `docker network disconnect <NAME_reseau> <nom_conteneur>` | Deconnecte un conteneur du reseau |
| `docker network rm <NAME_reseau>` | Supprimer un reseau |
| `docker network inspect <NAME_reseau>` | permet de connaitre les informations du reseau |
| Compose |
|---|---|
| `docker compose up` | Permet d'executer le fichier compose.yml et creer un conteneur |
| `docker compose up -d` | Fait en sorte que le conteneur ne s'arrete pas |
| `docker compose stop` | Permet d'arreter le conteneur (dans le dossier ou se trouve le .yml) |
| `docker compose rm` | Permet de supprimer un conteneur |

## Les volume dans docker :
- L'utilisation des volumes permet de garder une trace d'un dossier ou fichier apres la suppression d'un conteneur (exemple : home)
- Ce dossier pourra etre reutiliser dans un autre conteneur
- Utile pour les bases de donnees afin de les garder en memoire
- Utile pour les fichiers de configuration, exemple nginx

## Mapper un volume :
- Permet de copier du contenu qui se trouve dans la machine local(dossier) vers le conteneur(dossier). Ils sont en relation.
- Ce contenu peut etre modifier directement dans le conteneur.
- Une fois le conteneur supprimer, le contenu modifier dans celui ci est enregistrer dans le contenu de la machine local.
- En resume c est le dossier de la machine local qui prend le dessus

exemple :
- Mapper(copier) un dossier test qui se trouve dans la machine local dans un dossier home du conteneur, tous le contenu qui se trouve dans le dossier test de la machine local se retrouvera dans le dossier home du conteneur
- Dans le cas ou le fichier qui se trouve dans le dossier home du conteneur est modifier et enregistrer, le conteneur peut etre supprimer. Les modifications seront enregistrer dans le dossier test de la machine local.

| Commande | Description |
|---|---|
| `docker run -it --rm -v /home/david/docker/test:/test-docker ubuntu:24.04` | Le dossier de la machine local /home/david/docker/test est monté dans le conteneur dans /test-docker |

## Manager un volume :
- A la difference de mapper, il faut creer un volume dans docker
- Le volume creer recupere le contenu auquel il a ete relier
- Si le conteneur est supprimer les fichier du volume ne sont pas supprimer
- Si on relie a un autre dossier vide, celui ci contiendra tous les fichiers du volumes
- Si on relie un volume a un dossier avec du contenu, le contenu du dossier est remplacer par celui du volume

<img width="366" height="234" alt="Image" src="https://github.com/user-attachments/assets/57209862-3d4e-4df7-bb30-41f6d953a481" />

| Commande | Description |
|---|---|
| `docker volume create <mon_volume>` | permet de creer un volume dans docker |
| `docker volume ls` | liste les volumes |
| `docker volume rm <mon_volume>` | supprimer un volume |
| `docker run -it --rm -v <mon_volume>:/bin ubuntu:24.04` | manager un volume dans le conteneur |
| `docker volume inspect <mon_volume>` | permet de connaitre des details sur le volume |

## Mapper des ports :
- Un conteneur emet des donnee via un port que l'on peut recuperer
- Le port de la machine locale doit etre libre
- Un conteneur emet un port par defaut
- L'option -p permet de mapper des ports
- Exemple test navigateur : <http://localhost:9000>

docker run -p 9000:80 nginx
- en premier le port de la machine local(doit etre libre) et en deuxieme, le port du conteneur
- permet de mapper un port pour nginx, 9000 port de la machine local et 80 port d'entree de nginx

## Conteneurs connectes :
- Pour que des conteneurs puissent communiquer, il faut installer deux programmes dans chaque conteneur, ping et ip.
- Communique par adresse ip
- Les conteneurs sont relie entre eux par defaut

ping :
- permet de communiquer et d'envoyer des paquets a un conteneur specifique

ip :
- permet de recevoir des informations qui est l'ip d'une machine ou d'un conteneur

| Commande | Description |
|---|---|
| `apt update` | met a jour les paquets |
| `apt install -y iputils-ping` | installe ping |
| `apt install -y iproute2` | installe ip |
| `ping -h` | controle que ping soit installer |
| `ip -h` | controle que ping soit installer |
| `ip -c a` |  recuperer l ip de chaque conteneur |
| `ping <ip_autre_conteneur>` | communiquer avec un conteneur |

## Réseau :
- Utilisation de l'option --network qui permet de relier un conteneur a un reseau
- Sans l'option --network, le conteneur est connecter automatiquement au reseau normal de docker

| Commande | Description |
|---|---|
| `docker network ls` | liste les reseaux docker|

| NETWORKD ID  | NAME   | DRIVER | SCOPE |
|--------------|--------|--------|-------|
| 5a8c6fcc0e65 | bridge | bridge | local |
| d7b51185ef1e | none   | null   | local |

bridge :
- reseau par defaut de docker

null :
- signifique qu il n est connecter a aucun reseau

| Commande | Description |
|---|---|
| `docker run --network=<NAME> <image>` | relie le conteneur au reseau |

## Dockerfile :
- Utile pour creer une image personnalise
- La commande docker build -t <image> . permet de construire l'image personnalise
- Avec le mot-cle run, il est possible de lancer des commandes comme apt update ou apt install

| Mot-cle | Description |
|---|---|
| `FROM <image>:<version>` | permet d'indiquer sur quelle image de base nous construirons notre propre image personnalisée.|
| `RUN` | lance une ou plusieurs commandes Linux pendant la phase de construction de notre image. |
| `COPY <dossier_machine_local> <dossier_conteneur>` | permet de copier un dossier et/ou des fichiers qui se trouvent dans notre machine locale vers le conteneur. |
| `EXPOSE <port>` | Permet d'indiquer dans quel port le conteneur écoute |
| `WORKDIR /bin` | Au lancement du conteneur, nous serons positionnés dans le dossier /bin. Pareillement les instructions RUN, ENTRYPOINT, COPY, ADD et CMD seront exécutées à partir de répertoire sélectionné dans WORKDIR. |
| `VOLUME <dossier_conteneur>` | permet de créer automatiquement un répertoire dans la machine locale et le conteneur qui seront liés. Celui-ci sera automatiquement supprimé à la destruction du conteneur. |
| `ENV <CLE>="valeur"` | Permet de gérer des variables d'environnement. printenv <CLE> dans le conteneur pour afficher la valeur |
| `ENTRYPOINT ["cmd_a_lancer", "option"]` | équivaut à demander à Docker de lancer une commande avec option après la création du conteneur. Avec ce mot cle, l'utilisateur ne peut pas modifier l'option de la cmd a lancer lors du lancement du conteneur |
| `CMD ["option"]` | Donner la possibilité à l'utilisateur de modifier l'option de la commande |

## docker-compose :
- C'est un outil qui a été développé pour aider à définir et à partager des applications multi-conteneurs.
- Créer un fichier YAML pour définir les services et, à l'aide d'une seule commande, tout mettre en route ou tout démonter.
- Compose permet de gérer des applications qui utilisent plusieurs containers et de communiquer entre eux.
- Pour gerer l'ensemble des containers


Conteneu dans un docker-compose :

services:
- Un service représente une image Docker (par exemple, une image contenant un serveur web, une base de données, etc.). Chaque service peut être configuré avec des options comme :

- Image : l’image Docker à utiliser.
- Ports : les ports à exposer.
- Environment : les variables d’environnement.
- Volumes : les volumes à monter.

Volumes:
- Les volumes sont utiles pour stocker des données de manière persistante, même si un conteneur est arrêté ou supprimé. Vous pouvez définir vos volumes dans la section volumes.

networks:
- Ces réseaux personnalisés vous aident à mieux maîtriser la communication entre vos conteneurs. Là encore, c’est facultatif. Vous pouvez vous contenter d’utiliser le réseau par défaut de Docker si vous n’avez pas de configuration réseau spécifique.


## Créer un fichier docker-compose.yml :
exemple simple :

services:
	<mon_image>:			-> nom de notre image
		<vrai_image>:		-> image que l'on va utiliser (exemple= :nginx)
		container_name:		-> donne un nom au conteneur (exemple= :nginx)
		stdin_open: true	-> permet d'interagir avec le conteneur
		tty: true 			-> permet d'interagir avec le conteneur

## Volume mappé et managé dans le compose.yml :
- Va permettre d'enregistrer des donnees meme si un conteneur est supprimer

- Mapper :
services:
  <nom du service>:
    image: <image de base>
    container_name: <nom du conteneur>
    stdin_open: true
    tty: true
    volumes:
      - <nom du dossier en local>:<nom du dossier dans le conteneur>

- Manage :
services:
  <nom du service>:
    image: <image de base>
    container_name: <nom du conteneur>
    stdin_open: true
    tty: true
    volumes:
      - <nom du volume>:<nom du dossier dans le conteneur>

volumes:
  <nom du volume>:


## Réseau dans le compose.yml
- Les conteneurs creer dans le compose.yml sont automatiquement connecter a un reseau

services:
  <nom du service 1>:
    image: <image de base>
    container_name: <nom du conteneur 1>
    stdin_open: true
    tty: true
    networks:
      - <nom du réseau>

  <nom du service 2>:
    image: <image de base>
    container_name: <nom du conteneur 2>
    stdin_open: true
    tty: true
    networks:
      - <nom du réseau>

networks:
  <nom du réseau>:
    driver: <type du réseau (pilote)>

# NGINX :
NGINX (la porte d’entrée) :
- permet de mettre en place un serveur Web.
- reçoit les requêtes HTTP/HTTPS (navigateur → serveur)
- renvoie des fichiers statiques (HTML/CSS/JS/images)
- rediriger les requêtes dynamiques (ex: .php) vers un autre service (ex: PHP-FPM)
- gére SSL/TSL, redirections, cache, reverse proxy, etc.

TSL :
- C’est un protocole qui sécurise les échanges sur un réseau informatique, notamment sur Internet.
TSL permet :
- L’authentification du serveur
- La confidentialité des données échangées (session chiffrée)
- L’intégrité des données échangées
- L’authentification du client

Difference entre index.php et index.html (pour dossier config nginx) :
index.html :
- Fichier statique -> deja pret
- Nginx le lit et l’envoie tel quel au navigateur.
- Même contenu pour tout le monde (sauf cache/CDN etc.).
- Pas besoin de PHP-FPM.
- Exemple : une page maintenance

index.php :
- Fichier dynamique -> c’est du code PHP.
- Nginx ne peut pas l’exécuter : il l’envoie à PHP-FPM
- PHP exécute le code, souvent interagit avec la base de données (WordPress/MariaDB), génère du HTML, puis renvoie le résultat
- Exemple : WordPress (articles, login, pages qui changent selon l’utilisateur, etc.)

# WordPress :
WordPress :
- C’est le site / l’application (CMS).
- Il génère les pages (accueil, articles, admin, login…).

Il gère :
- thèmes (design)
- plugins (fonctions)
- utilisateurs / permissions
- contenu (articles, pages, médias)
- Il est écrit en PHP, donc il a besoin de PHP-FPM pour s’exécuter.

# MariaDB :
- Gestion de base de donnee (embranchement de mySQL)
- c'est une copie de mySQL mais en open source
- WordPress y stocke tout ce qui doit être “persistant” : comptes utilisateurs, mots de passe, articles/pages, etc..

Exemple de fonctionnement base de donnee comme mySQL :
- La gestion des données est basée sur un modèle de tableaux; toutes les données traitées sur MySQL sont stockées dans des tableaux pouvant être reliés les uns aux autres via des clés

#

# 3. Ressources :
https://tuto.grademe.fr/inception/
https://www.nicelydev.com
https://dev.to/alejiri/docker-nginx-wordpress-mariadb-tutorial-inception42-1eok
https://www.docker.com/
https://docs.docker.com/compose/
