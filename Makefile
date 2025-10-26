# Jenkins CI/CD Configuration
jenkins_home=/var/jenkins_home

# Build the Jenkins image with Docker support
build-jenkins:
	docker build -t jenkins-docker -f Dockerfile.jenkins .

# Start Jenkins
jenkins-up:
	docker-compose up -d jenkins

# Stop Jenkins
jenkins-down:
	docker-compose stop jenkins

# View Jenkins logs
jenkins-logs:
	docker-compose logs -f jenkins

# Get Jenkins initial admin password
jenkins-password:
	docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

# Build the application Docker image
app-build:
	docker build -t daily-quotes:latest .

# Build for development
app-build-dev:
	docker build -t daily-quotes:dev -f Dockerfile.dev .

# Run the application
app-run:
	docker-compose up -d daily-quotes

# Stop the application
app-stop:
	docker-compose stop daily-quotes

# View application logs
app-logs:
	docker-compose logs -f daily-quotes

# Run tests in Docker
test-docker:
	docker run --rm daily-quotes:dev npm run test:selenium

# Run all services
up:
	docker-compose up -d

# Stop all services
down:
	docker-compose down

# Rebuild and restart
restart:
	docker-compose down
	docker-compose up -d --build

# Clean up Docker resources
clean:
	docker-compose down -v
	docker system prune -f

# View all running containers
ps:
	docker-compose ps

# Execute command in container
exec:
	docker-compose exec daily-quotes sh

# Health check
health:
	curl http://localhost:3000

# Full CI/CD pipeline
pipeline: jenkins-up
	@echo "Waiting for Jenkins to start..."
	@sleep 30
	@echo "Jenkins is running at http://localhost:8080"
	@docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

.PHONY: build-jenkins jenkins-up jenkins-down jenkins-logs jenkins-password app-build app-run app-stop app-logs test-docker up down restart clean ps exec health pipeline

