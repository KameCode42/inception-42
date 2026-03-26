COMPOSE_FILE = srcs/docker-compose.yml
DATA_DIR = $(HOME)/data

all: setup build up

# prépare les dossiers, configure le nom de domaine local
setup:
	@mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	@grep -q "astoll.42.fr" /etc/hosts || echo "127.0.0.1 astoll.42.fr" | sudo tee -a /etc/hosts

# construit les images
build:
	@docker-compose -f $(COMPOSE_FILE) build

# démarre les conteneurs
up:
	@docker-compose -f $(COMPOSE_FILE) up -d

# arrête les conteneurs
down:
	@docker-compose -f $(COMPOSE_FILE) down

# nettoie Docker sans supprimer tes dossiers de données locaux
clean: down
	@docker system prune -af

# nettoie Docker avec volumes, vide les données MariaDB et WordPress
fclean: down
	@docker system prune -af --volumes
	@sudo rm -rf $(DATA_DIR)/mariadb/* $(DATA_DIR)/wordpress/*

# supprime tout, recrée tout
re: fclean all

.PHONY: all build up down clean fclean re
