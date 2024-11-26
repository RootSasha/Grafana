pipeline {
    agent any

    environment {
        DOCKER_COMPOSE_FILE = "docker-compose.yml" // Ім'я файлу docker-compose
    }

    stages {
        stage('Checkout') {
            steps {
                // Клонуємо репозиторій з вашим docker-compose.yml
                checkout scm
            }
        }

        stage('Build and Deploy') {
            steps {
                script {
                    // Переконуємося, що Docker Compose доступний
                    sh 'docker-compose --version'

                    // Зупиняємо та видаляємо всі існуючі контейнери, якщо вони запущені
                    sh 'docker-compose down || true'

                    // Запускаємо нові контейнери у фоновому режимі
                    sh 'docker-compose up -d'
                }
            }
        }

        stage('Verify Services') {
            steps {
                script {
                    // Перевіряємо, чи всі сервіси працюють
                    sh 'docker ps'

                    // Перевіряємо доступність портів для сервісів
                    sh 'curl -f http://localhost:9090 || echo "Prometheus не доступний!"'
                    sh 'curl -f http://localhost:3000 || echo "Grafana не доступна!"'
                    sh 'curl -f http://localhost:9100 || echo "Node Exporter не доступний!"'
                    sh 'curl -f http://localhost:8080 || echo "cAdvisor не доступний!"'
                    sh 'curl -f http://localhost:9093 || echo "Alertmanager не доступний!"'
                }
            }
        }
    }

    post {
        success {
            echo 'Сервіси успішно запущені!'
        }
        failure {
            echo 'Помилка під час запуску сервісів.'
        }
        always {
            // Друкуємо журнали для діагностики
            sh 'docker-compose logs'
        }
    }
}
