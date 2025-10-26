# Daily Quotes - Jenkins & Docker Integration Guide

This guide will help you set up Jenkins and Docker for continuous integration and deployment of the Daily Quotes application.

## 🐳 Docker Setup

### Quick Start with Docker

```bash
# Build the Docker image
make app-build

# Run the application
make app-run

# View logs
make app-logs

# Stop the application
make app-stop

# Run tests in Docker
make test-docker
```

### Manual Docker Commands

```bash
# Build image
docker build -t daily-quotes:latest .

# Run container
docker run -d -p 3000:3000 --name daily-quotes daily-quotes:latest

# View logs
docker logs -f daily-quotes

# Stop container
docker stop daily-quotes

# Remove container
docker rm daily-quotes
```

### Docker Compose

```bash
# Start all services (app + Jenkins)
make up

# Stop all services
make down

# Rebuild and restart
make restart

# View running containers
make ps
```

## 🚀 Jenkins Setup

### 1. Build and Start Jenkins

```bash
# Build Jenkins with Docker support
make build-jenkins

# Start Jenkins
make jenkins-up

# View Jenkins logs
make jenkins-logs

# Get initial admin password
make jenkins-password
```

### 2. Access Jenkins

1. Open your browser and navigate to `http://localhost:8080`
2. Enter the initial admin password (use `make jenkins-password` to get it)
3. Install suggested plugins
4. Create your admin user

### 3. Configure Jenkins Job

1. Click "New Item" in Jenkins dashboard
2. Enter job name: "daily-quotes-pipeline"
3. Select "Pipeline" project type
4. Click "OK"
5. In the Pipeline section, select "Pipeline script from SCM"
6. Choose "Git" as SCM
7. Enter your repository URL
8. Set "Script Path" to `Jenkinsfile`
9. Save the configuration
10. Click "Build Now" to trigger the pipeline

### 4. Jenkins Pipeline Stages

The pipeline includes the following stages:

- ✅ **Checkout**: Gets the latest code from repository
- ✅ **Install Dependencies**: Runs `npm install`
- ✅ **Run Tests**: Executes Selenium tests
- ✅ **Build Docker Image**: Creates Docker image
- ✅ **Security Scan**: Scans for vulnerabilities
- ✅ **Run Container Tests**: Tests the Docker container
- ✅ **Push to Registry**: Pushes to Docker registry (main branch only)
- ✅ **Deploy**: Deploys the application (main branch only)
- ✅ **Cleanup**: Removes old images and containers

## 📝 Jenkinsfile Configuration

The `Jenkinsfile` defines the complete CI/CD pipeline with:

- **Multi-stage pipeline**: Checkout → Test → Build → Deploy
- **Docker integration**: Builds and pushes Docker images
- **Email notifications**: Sends build status emails
- **Environment variables**: Configurable deployment settings
- **Conditional deployment**: Only deploys from main branch
- **Auto-cleanup**: Removes old images automatically

### Environment Variables

Set these in Jenkins job configuration:

- `DOCKER_REGISTRY`: Your Docker registry URL
- `ADMIN_EMAIL`: Email for build notifications

## 🧪 Testing in Docker

### Run Selenium Tests in Docker

```bash
# Build development image with test dependencies
docker build -f Dockerfile.dev -t daily-quotes:dev .

# Run tests
docker run --rm daily-quotes:dev npm run test:selenium
```

### API Tests in Container

```bash
# Start the app container
docker run -d -p 3001:3000 --name test-app daily-quotes:latest

# Run API tests (in another terminal)
npm run test:api

# Stop container
docker stop test-app && docker rm test-app
```

## 🔧 Development Workflow

### 1. Local Development

```bash
# Install dependencies
npm install

# Run tests locally
npm run test:selenium

# Start development server
npm start
```

### 2. Build and Test Docker Image

```bash
# Build image
make app-build

# Run container
make app-run

# Test the application
make health

# View logs
make app-logs
```

### 3. CI/CD Pipeline

```bash
# Push code to repository
git add .
git commit -m "Your commit message"
git push origin main

# Jenkins will automatically:
# 1. Checkout code
# 2. Install dependencies
# 3. Run tests
# 4. Build Docker image
# 5. Scan for security issues
# 6. Deploy to production
```

## 📊 Monitoring and Debugging

### View Jenkins Logs

```bash
make jenkins-logs
```

### View Application Logs

```bash
make app-logs
```

### Check Container Status

```bash
make ps
```

### Execute Commands in Container

```bash
make exec
```

### Health Check

```bash
make health
```

## 🔒 Security Best Practices

1. **Non-root user**: Dockerfile runs as non-root user
2. **Health checks**: Container includes health monitoring
3. **Security scanning**: Pipeline scans for vulnerabilities
4. **Secret management**: Use Jenkins credentials for sensitive data
5. **Regular updates**: Keep base images updated

## 🚨 Troubleshooting

### Jenkins Won't Start

```bash
# Check if port 8080 is in use
netstat -an | findstr :8080

# Stop conflicting services
make jenkins-down
make jenkins-up
```

### Docker Build Fails

```bash
# Clean Docker cache
docker system prune -a

# Rebuild
make app-build
```

### Tests Fail in Docker

```bash
# Run with verbose output
docker run --rm daily-quotes:dev npm run test:selenium -- --verbose

# Check container logs
docker logs <container-id>
```

### Port Already in Use

```bash
# Change ports in docker-compose.yml
ports:
  - "8081:8080"  # Jenkins
  - "3001:3000"  # App
```

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Jenkins Pipeline](https://www.jenkins.io/doc/book/pipeline/)
- [Docker Compose](https://docs.docker.com/compose/)

## 🎉 Quick Reference

```bash
# Complete setup
make build-jenkins
make jenkins-up
make app-build
make app-run

# Full pipeline
make pipeline

# Clean everything
make clean
```

---

For questions or issues, check the Jenkins build logs or Docker container logs.

