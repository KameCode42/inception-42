COMPOSE_FILE = srcs/docker-compose.yml
ENV_FILE = srcs/.env
COMPOSE = docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE)

DATA_DIR = $(HOME)/data
DOMAIN_NAME = $(shell grep '^DOMAIN_NAME=' $(ENV_FILE) | cut -d '=' -f2)

all: setup build up

setup:
	@mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	@grep -q "$(DOMAIN_NAME)" /etc/hosts || echo "127.0.0.1 $(DOMAIN_NAME)" | sudo tee -a /etc/hosts

build:
	@$(COMPOSE) build

up:
	@$(COMPOSE) up -d

down:
	@$(COMPOSE) down

clean: down
	@docker system prune -af

fclean: down
	@docker system prune -af --volumes
	@sudo find $(DATA_DIR)/mariadb -mindepth 1 -delete 2>/dev/null || true
	@sudo find $(DATA_DIR)/wordpress -mindepth 1 -delete 2>/dev/null || true

re: fclean all

.PHONY: all setup build up down clean fclean re
