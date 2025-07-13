PROJECT_NAME = -p inception

COMPOSE_FILE = -f srcs/docker-compose.yml

LOGIN = tlonghin

all: build up

build:
	@docker compose $(PROJECT_NAME) $(COMPOSE_FILE) build --no-cache

up:
	@mkdir -p /home/$(LOGIN)/data/mariadb
	@mkdir -p /home/$(LOGIN)/data/wordpress
	@docker compose $(PROJECT_NAME) $(COMPOSE_FILE) up -d --remove-orphans 

down:
	@docker compose $(PROJECT_NAME) $(COMPOSE_FILE) down

clean: down
	@docker compose $(PROJECT_NAME) $(COMPOSE_FILE) down -v --rmi all
	@sudo rm -rf /home/$(LOGIN)/data/mariadb
	@sudo rm -rf /home/$(LOGIN)/data/wordpress

re: clean all

logs:
	@docker compose $(PROJECT_NAME) $(COMPOSE_FILE) logs -f

.PHONY: all build up down clean re logs
