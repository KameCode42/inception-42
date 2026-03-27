Ce projet a été créé dans le cadre du cursus 42 par dle-fur

# Index :
- [Inception](#inception-)
- [OS différents](#os-différents-)
- [Docker](#docker-)
- [Composants Docker](#les-différents-composants-docker-)
- [Commandes Docker](#commandes-docker-)
- [Volume docker](#les-volumes-dans-docker-)
- [Mapper un volume](#mapper-un-volume-)
- [Manager un volume](#manager-un-volume-)
- [Mapper des ports](#mapper-des-ports-)
- [Conteneurs connectés](#conteneurs-connectés-)
- [Réseau](#réseau-)
- [Dockerfile](#dockerfile-)
- [docker-compose](#docker-compose-)
- [Créer un fichier docker-compose.yml](#créer-un-fichier-docker-composeyml-)
- [Réseau dans le compose.yml](#réseau-dans-le-composeyml)
- [NGINX](#nginx-)
- [WordPress](#wordpress-)
- [MariaDB](#mariadb-)
- [Ressources](#3-ressources-)

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
- Une des forces de Docker est la possibilité de démarrer et d'arrêter des services très rapidement.

Avantage Docker :
- Compatible avec tous les environnements
- Chaque conteneur tourne séparément
- Lancement rapide des conteneurs
- Plus léger qu'une machine virtuelle
- Créer plusieurs conteneurs qui sont basés sur une image
- Créer un serveur web facilement

Différences entre VM et conteneur :

Conteneur :
- Le conteneur empaquette l'appli + les dépendances, tourne comme un processus isolé sur le même noyau que l'hôte (partage le noyau)
- Léger, rapide à démarrer

VM :
- Virtualise une machine entière et a son propre système d'exploitation avec noyau
- Plus lourd et plus lent

## Les différents composants Docker :
Conteneur :
- Un conteneur est une instance de l'image. Lorsque l'image est lancée, ça crée un conteneur qui a un processus, un état
- Un conteneur est construit grâce à une image
- Il est possible de lancer plusieurs conteneurs sur la même image

Image :
- Une image contient toutes les informations pour la création d'un conteneur. Le code, les dépendances, une configuration de démarrage, etc.
- Le conteneur va se baser sur une image pour se créer
- Une image personnalisée est toujours basée sur une image qui existe déjà

Dockerfile :
- Le Dockerfile permet de créer une image personnalisée afin d'être utilisée pour créer des conteneurs.

docker-compose.yml :
- C'est un outil qui a été développé pour aider à définir et à partager des applications multi-conteneurs.
- Créer un fichier YAML pour définir les services et, à l'aide d'une seule commande, tout mettre en route ou tout démonter.
- Compose permet de gérer des applications qui utilisent plusieurs conteneurs et de communiquer entre eux.
- Pour gérer l'ensemble des conteneurs

## Commandes Docker :
| Commande | Description |
|---|---|
| `docker build -t <mon_image> .` | Construit l'image personnalisée grâce au Dockerfile |
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
| `docker volume create <mon_volume>` | permet de créer un volume dans Docker |
| `docker volume ls` | liste les volumes |
| `docker volume rm <mon_volume>` | supprimer un volume |
| `docker volume inspect <mon_volume>` | permet de connaître des détails sur le volume |
| Port |
|---|---|
| `docker run -p <port_local>:<port_conteneur> <mon_image>` | permet de mapper des ports |
| Réseau |
|---|---|
| `docker network ls` | liste les réseaux Docker |
| `docker network create --driver=<DRIVER> <mon_nom_reseau>` | Créer un réseau personnalisé |
| `docker run --network=<NAME_reseau> <image>` | Créer un conteneur et le relie au réseau |
| `docker network disconnect <NAME_reseau> <nom_conteneur>` | Déconnecte un conteneur du réseau |
| `docker network rm <NAME_reseau>` | Supprimer un réseau |
| `docker network inspect <NAME_reseau>` | permet de connaître les informations du réseau |
| Compose |
|---|---|
| `docker compose up` | Permet d'exécuter le fichier compose.yml et créer un conteneur |
| `docker compose up -d` | Fait en sorte que le conteneur ne s'arrête pas |
| `docker compose stop` | Permet d'arrêter le conteneur (dans le dossier où se trouve le .yml) |
| `docker compose rm` | Permet de supprimer un conteneur |

## Les volumes dans Docker :
- L'utilisation des volumes permet de garder une trace d'un dossier ou fichier après la suppression d'un conteneur (exemple : home)
- Ce dossier pourra être réutilisé dans un autre conteneur
- Utile pour les bases de données afin de les garder en mémoire
- Utile pour les fichiers de configuration, exemple nginx

## Mapper un volume :
- Permet de copier du contenu qui se trouve dans la machine locale (dossier) vers le conteneur (dossier). Ils sont en relation.
- Ce contenu peut être modifié directement dans le conteneur.
- Une fois le conteneur supprimé, le contenu modifié dans celui-ci est enregistré dans le contenu de la machine locale.
- En résumé c'est le dossier de la machine locale qui prend le dessus

exemple :
- Mapper (copier) un dossier test qui se trouve dans la machine locale dans un dossier home du conteneur, tout le contenu qui se trouve dans le dossier test de la machine locale se retrouvera dans le dossier home du conteneur
- Dans le cas où le fichier qui se trouve dans le dossier home du conteneur est modifié et enregistré, le conteneur peut être supprimé. Les modifications seront enregistrées dans le dossier test de la machine locale.

| Commande | Description |
|---|---|
| `docker run -it --rm -v /home/david/docker/test:/test-docker ubuntu:24.04` | Le dossier de la machine locale /home/david/docker/test est monté dans le conteneur dans /test-docker |

## Manager un volume :
- À la différence de mapper, il faut créer un volume dans Docker
- Le volume créé récupère le contenu auquel il a été relié
- Si le conteneur est supprimé les fichiers du volume ne sont pas supprimés
- Si on le relie à un autre dossier vide, celui-ci contiendra tous les fichiers du volume
- Si on relie un volume à un dossier avec du contenu, le contenu du dossier est remplacé par celui du volume

<img width="366" height="234" alt="Image" src="https://github.com/user-attachments/assets/57209862-3d4e-4df7-bb30-41f6d953a481" />

| Commande | Description |
|---|---|
| `docker volume create <mon_volume>` | permet de créer un volume dans Docker |
| `docker volume ls` | liste les volumes |
| `docker volume rm <mon_volume>` | supprimer un volume |
| `docker run -it --rm -v <mon_volume>:/bin ubuntu:24.04` | manager un volume dans le conteneur |
| `docker volume inspect <mon_volume>` | permet de connaître des détails sur le volume |

## Mapper des ports :
- Un conteneur émet des données via un port que l'on peut récupérer
- Le port de la machine locale doit être libre
- Un conteneur émet un port par défaut
- L'option -p permet de mapper des ports
- Exemple test navigateur : <http://localhost:9000>

docker run -p 9000:80 nginx
- en premier le port de la machine locale (doit être libre) et en deuxième, le port du conteneur
- permet de mapper un port pour nginx, 9000 port de la machine locale et 80 port d'entrée de nginx

## Conteneurs connectés :
- Pour que des conteneurs puissent communiquer, il faut installer deux programmes dans chaque conteneur, ping et ip.
- Communique par adresse IP
- Les conteneurs sont reliés entre eux par défaut

ping :
- permet de communiquer et d'envoyer des paquets à un conteneur spécifique

ip :
- permet de recevoir des informations, quelle est l'IP d'une machine ou d'un conteneur

| Commande | Description |
|---|---|
| `apt update` | met à jour les paquets |
| `apt install -y iputils-ping` | installe ping |
| `apt install -y iproute2` | installe ip |
| `ping -h` | contrôle que ping soit installé |
| `ip -h` | contrôle que ping soit installé |
| `ip -c a` | récupérer l'IP de chaque conteneur |
| `ping <ip_autre_conteneur>` | communiquer avec un conteneur |

## Réseau :
- Utilisation de l'option --network qui permet de relier un conteneur à un réseau
- Sans l'option --network, le conteneur est connecté automatiquement au réseau normal de Docker

| Commande | Description |
|---|---|
| `docker network ls` | liste les réseaux Docker |

| NETWORKD ID  | NAME   | DRIVER | SCOPE |
|--------------|--------|--------|-------|
| 5a8c6fcc0e65 | bridge | bridge | local |
| d7b51185ef1e | none   | null   | local |

bridge :
- réseau par défaut de Docker

null :
- signifie qu'il n'est connecté à aucun réseau

| Commande | Description |
|---|---|
| `docker run --network=<NAME> <image>` | relie le conteneur au réseau |

## Dockerfile :
- Utile pour créer une image personnalisée
- La commande docker build -t <image> . permet de construire l'image personnalisée
- Avec le mot-clé run, il est possible de lancer des commandes comme apt update ou apt install

| Mot-clé | Description |
|---|---|
| `FROM <image>:<version>` | permet d'indiquer sur quelle image de base nous construirons notre propre image personnalisée.|
| `RUN` | lance une ou plusieurs commandes Linux pendant la phase de construction de notre image. |
| `COPY <dossier_machine_local> <dossier_conteneur>` | permet de copier un dossier et/ou des fichiers qui se trouvent dans notre machine locale vers le conteneur. |
| `EXPOSE <port>` | Permet d'indiquer dans quel port le conteneur écoute |
| `WORKDIR /bin` | Au lancement du conteneur, nous serons positionnés dans le dossier /bin. Pareillement, les instructions RUN, ENTRYPOINT, COPY, ADD et CMD seront exécutées à partir du répertoire sélectionné dans WORKDIR. |
| `VOLUME <dossier_conteneur>` | permet de créer automatiquement un répertoire dans la machine locale et le conteneur qui seront liés. Celui-ci sera automatiquement supprimé à la destruction du conteneur. |
| `ENV <CLE>="valeur"` | Permet de gérer des variables d'environnement. printenv <CLE> dans le conteneur pour afficher la valeur |
| `ENTRYPOINT ["cmd_a_lancer", "option"]` | équivaut à demander à Docker de lancer une commande avec option après la création du conteneur. Avec ce mot-clé, l'utilisateur ne peut pas modifier l'option de la cmd à lancer lors du lancement du conteneur |
| `CMD ["option"]` | Donner la possibilité à l'utilisateur de modifier l'option de la commande |

## docker-compose :
- C'est un outil qui a été développé pour aider à définir et à partager des applications multi-conteneurs.
- Créer un fichier YAML pour définir les services et, à l'aide d'une seule commande, tout mettre en route ou tout démonter.
- Compose permet de gérer des applications qui utilisent plusieurs conteneurs et de communiquer entre eux.
- Pour gérer l'ensemble des conteneurs

Conteneur dans un docker-compose :

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
		<vrai_image>:		-> image que l'on va utiliser (exemple = :nginx)
		container_name:		-> donne un nom au conteneur (exemple = :nginx)
		stdin_open: true	-> permet d'interagir avec le conteneur
		tty: true 			-> permet d'interagir avec le conteneur

## Volume mappé et managé dans le compose.yml :
- Va permettre d'enregistrer des données même si un conteneur est supprimé

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
- Les conteneurs créés dans le compose.yml sont automatiquement connectés à un réseau

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
- permet de mettre en place un serveur web.
- reçoit les requêtes HTTP/HTTPS (navigateur → serveur)
- renvoie des fichiers statiques (HTML/CSS/JS/images)
- redirige les requêtes dynamiques (ex: .php) vers un autre service (ex: PHP-FPM)
- gère SSL/TSL, redirections, cache, reverse proxy, etc.

TSL :
- C’est un protocole qui sécurise les échanges sur un réseau informatique, notamment sur Internet.
TSL permet :
- L’authentification du serveur
- La confidentialité des données échangées (session chiffrée)
- L’intégrité des données échangées
- L’authentification du client

Différence entre index.php et index.html (pour dossier config nginx) :
index.html :
- Fichier statique -> déjà prêt
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
- Gestion de base de données (embranchement de MySQL)
- c'est une copie de MySQL mais en open source
- WordPress y stocke tout ce qui doit être “persistant” : comptes utilisateurs, mots de passe, articles/pages, etc.

Exemple de fonctionnement base de données comme MySQL :
- La gestion des données est basée sur un modèle de tableaux ; toutes les données traitées sur MySQL sont stockées dans des tableaux pouvant être reliés les uns aux autres via des clés

#

# 3. Ressources :
https://tuto.grademe.fr/inception/
https://www.nicelydev.com
https://dev.to/alejiri/docker-nginx-wordpress-mariadb-tutorial-inception42-1eok
https://www.docker.com/
https://docs.docker.com/compose/
