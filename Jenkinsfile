pipeline {
    agent any

    environment {
        DOCKER_COMPOSE_FILE = "docker-compose.yml"
        STACK_NAME = "monitoring"
    }

    stages {
        stage('Verify Docker Installation') {
            steps {
                script {
                    echo 'Checking Docker installation...'
                    sh '''
                    if ! command -v docker &> /dev/null
                    then
                        echo "Docker is not installed. Please install Docker."
                        exit 1
                    fi
                    '''
                }
            }
        }

        stage('Initialize Docker Swarm') {
            steps {
                script {
                    echo 'Initializing Docker Swarm (if not already active)...'
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
                    // Тут запускаються контейнери для Grafana, Prometheus, Node Exporter, cAdvisor
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
