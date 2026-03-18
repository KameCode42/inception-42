Ce projet a été créé dans le cadre du cursus 42 par dle-fur

# Inception :
Description :
- Inception est un projet d’administration système dont l’objectif est de mettre en place, dans une machine virtuelle, une petite infrastructure web gérée avec Docker Compose
- Il consiste à relier plusieurs images Docker et à pouvoir les lancer ensemble, sans pour autant qu’elles perdent leur indépendance (grâce à Docker Compose)

Le projet repose sur plusieurs conteneurs séparés :
- NGINX sert de point d’entrée unique en HTTPS (TLS 1.2/1.3) sur le port 443

- WordPress fonctionne avec PHP-FPM (sans NGINX)

- MariaDB gère la base de données.
Les services communiquent via un réseau Docker dédié, et les données persistantes (base de données et fichiers WordPress) sont stockées dans des volumes nommés, sauvegardés sur l’hôte dans /home/<login>/data

#

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
| `docker run <mon_image>` | Télécharge l’image si nécessaire et crée un conteneur à partir de cette image. |
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

| ID           | NAME   | DRIVER | SCOPE |
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


