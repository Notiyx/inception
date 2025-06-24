
COMPOSE_PROJECT_NAME = my_project

.PHONY: up down restart build logs

up:
	docker compose -p $(COMPOSE_PROJECT_NAME) up -d

down:
	docker compose -p $(COMPOSE_PROJECT_NAME) down

restart:
	docker compose -p $(COMPOSE_PROJECT_NAME) down && docker compose -p $(COMPOSE_PROJECT_NAME) up -d

build:
	docker compose -p $(COMPOSE_PROJECT_NAME) build

logs:
	docker compose -p $(COMPOSE_PROJECT_NAME) logs -f
