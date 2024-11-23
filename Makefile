PROFILE = $(shell grep PROFILE .env | cut -d '=' -f 2)

ifeq ($(strip $(PROFILE)),)
	DOCKER_COMPOSE_FILE := docker-compose.yml
	ENV_FILE := .env
else
	DOCKER_COMPOSE_FILE := docker-compose.$(PROFILE).yml
	ENV_FILE := .env.$(PROFILE)
endif

env:
	@echo "Profile: $(PROFILE)"
	@echo "Docker-compose File: $(DOCKER_COMPOSE_FILE)"
	@echo "Environment File: $(ENV_FILE)"

# Command to start the docker-compose services
up:
	@echo "Enabling profile $(PROFILE)"
	@echo "Starting services..."
	docker-compose --env-file $(ENV_FILE) -f $(DOCKER_COMPOSE_FILE) up -d
	@echo "Services started successfully!"

# Command to pause (stop) the containers without removing them
down:
	@echo "Stopping Docker Compose services..."
	docker-compose --env-file $(ENV_FILE) -f $(DOCKER_COMPOSE_FILE) stop
	@echo "Services stopped!"

# Command to refresh the containers without removing their images/volumes
refresh:
	@echo "Refreshing Docker Compose services..."
	docker-compose --env-file $(ENV_FILE) -f $(DOCKER_COMPOSE_FILE) down
	docker-compose --env-file $(ENV_FILE) -f $(DOCKER_COMPOSE_FILE) up --build --force-recreate -d
	@echo "Services refreshed!"

# Command to completely remove containers, volumes, and images
clear:
	@echo "Removing containers, volumes, and images..."
	docker-compose --env-file $(ENV_FILE) -f $(DOCKER_COMPOSE_FILE) down --v --rmi all
	@echo "All containers, volumes, and images removed!"

# Command to show logs of services in real time
logs:
	@echo "Displaying services' logs..."
	docker-compose --env-file $(ENV_FILE) -f $(DOCKER_COMPOSE_FILE) logs -f
