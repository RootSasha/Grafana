pipeline {
    agent any

    environment {
        DOCKER_COMPOSE_FILE = "docker-compose.yml"
        STACK_NAME = "monitoring"
    }

    stages {
        stage('Setup Environment') {
            steps {
                script {
                    echo 'Updating system packages...'
                    sh '''
                    sudo apt-get update && sudo apt-get install -y docker.io
                    '''
                }
            }
        }

        stage('Initialize Docker Swarm') {
            steps {
                script {
                    echo 'Initializing Docker Swarm...'
                    sh '''
                    if ! docker info | grep -q "Swarm: active"; then
                        docker swarm init || true
                    fi
                    '''
                }
            }
        }

        stage('Deploy Docker Stack') {
            steps {
                script {
                    echo "Deploying stack: ${STACK_NAME}..."
                    sh "docker stack deploy -c ${DOCKER_COMPOSE_FILE} ${STACK_NAME}"
                }
            }
        }

        stage('Verify Services') {
            steps {
                script {
                    echo 'Checking services status...'
                    sh '''
                    sleep 20
                    docker service ls
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Monitoring stack successfully deployed!"
        }
        failure {
            echo "Deployment failed. Please check logs."
        }
    }
}
