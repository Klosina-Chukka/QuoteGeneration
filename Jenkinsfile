pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'daily-quotes-app'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Klosina-Chukka/QuoteGeneration.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    // Stop and remove any old container
                    sh 'docker rm -f daily-quotes || true'
                    // Run new container
                    sh "docker run -d -p 3000:3000 --name daily-quotes ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Cleanup') {
            steps {
                sh "docker image prune -f"
            }
        }
    }
}
