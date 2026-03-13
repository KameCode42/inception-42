# Ce projet a été créé dans le cadre du cursus 42 par dle-fur

# Inception :
Description :
- Inception est un projet d’administration système dont l’objectif est de mettre en place, dans une machine virtuelle, une petite infrastructure web gérée avec Docker Compose
- Il consiste à relier plusieurs images Docker et à pouvoir les lancer ensemble, sans pour autant qu’elles perdent leur indépendance (grâce à Docker Compose)

Le projet repose sur plusieurs conteneurs séparés :
- NGINX sert de point d’entrée unique en HTTPS (TLS 1.2/1.3) sur le port 443

- WordPress fonctionne avec PHP-FPM (sans NGINX)

- MariaDB gère la base de données.
Les services communiquent via un réseau Docker dédié, et les données persistantes (base de données et fichiers WordPress) sont stockées dans des volumes nommés, sauvegardés sur l’hôte dans /home/<login>/data

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

#

# Les differents composants Docker :
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

#

# Commandes Docker :


