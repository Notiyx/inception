COMPOSE_PROJECT_NAME = inception

up:
	docker compose -p $(COMPOSE_PROJECT_NAME) up --build -d

down:
	docker compose -p $(COMPOSE_PROJECT_NAME) down -v

restart:
	docker compose -p $(COMPOSE_PROJECT_NAME) down -v && docker compose -p $(COMPOSE_PROJECT_NAME) up --build -d

build:
	docker compose -p $(COMPOSE_PROJECT_NAME) build

logs:
	docker compose -p $(COMPOSE_PROJECT_NAME) logs

ps:
	docker compose -p $(COMPOSE_PROJECT_NAME) ps

.PHONY: up down restart build logs ps check-env
