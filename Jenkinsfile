pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'daily-quotes'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        DOCKER_REGISTRY = 'localhost:5000' // Change to your registry
    }
    
    stages {
        stage('Checkout') {
            steps {
                script {
                    echo '📦 Checking out code...'
                    checkout scm
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                script {
                    echo '📥 Installing dependencies...'
                    sh 'npm install'
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    echo '🧪 Running tests...'
                    sh 'npm run test:selenium'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo '🐳 Building Docker image...'
                    sh """
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }
        
        stage('Security Scan') {
            steps {
                script {
                    echo '🔒 Scanning Docker image for vulnerabilities...'
                    sh "docker scan ${DOCKER_IMAGE}:${DOCKER_TAG} || true"
                }
            }
        }
        
        stage('Run Container Tests') {
            steps {
                script {
                    echo '🧪 Running tests in Docker container...'
                    sh """
                        docker run --rm -d --name test-container -p 3001:3000 ${DOCKER_IMAGE}:${DOCKER_TAG}
                        sleep 5
                        # Run API tests against container
                        npm run test:api || true
                        docker stop test-container
                    """
                }
            }
        }
        
        stage('Push to Registry') {
            when {
                branch 'main'
            }
            steps {
                script {
                    echo '📤 Pushing to Docker registry...'
                    sh """
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}
                        docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}
                        docker tag ${DOCKER_IMAGE}:latest ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest
                        docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest
                    """
                }
            }
        }
        
        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                script {
                    echo '🚀 Deploying application...'
                    sh """
                        docker-compose down
                        docker-compose up -d
                    """
                }
            }
        }
        
        stage('Cleanup') {
            steps {
                script {
                    echo '🧹 Cleaning up...'
                    sh """
                        docker system prune -f
                        # Keep only last 5 images
                        docker images ${DOCKER_IMAGE} --format '{{.ID}}' | tail -n +6 | xargs -r docker rmi || true
                    """
                }
            }
        }
    }
    
    post {
        always {
            script {
                echo '📊 Pipeline completed!'
                // Clean up test containers
                sh 'docker stop test-container || true'
            }
        }
        success {
            echo '✅ Pipeline succeeded!'
            // Send notification
            emailext (
                subject: "✅ Build #${BUILD_NUMBER} - SUCCESS",
                body: "Build #${BUILD_NUMBER} succeeded for ${JOB_NAME}",
                to: "${env.ADMIN_EMAIL}"
            )
        }
        failure {
            echo '❌ Pipeline failed!'
            // Send notification
            emailext (
                subject: "❌ Build #${BUILD_NUMBER} - FAILED",
                body: "Build #${BUILD_NUMBER} failed for ${JOB_NAME}. Check logs for details.",
                to: "${env.ADMIN_EMAIL}"
            )
        }
    }
}

