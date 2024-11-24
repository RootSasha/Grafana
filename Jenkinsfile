pipeline {
    agent any

    environment {
        DOCKER_COMPOSE = '/usr/local/bin/docker-compose' // шлях до docker-compose, змінюйте залежно від вашого середовища
        DOCKER_IMAGE_TAG = 'monitoring'  // Можна змінити на версію, яку ви хочете використовувати
    }

    stages {
        stage('Checkout') {
            steps {
                // Клонування репозиторію
                git 'git@github.com:RootSasha/Grafana.git'
            }
        }

        stage('Prepare Environment') {
            steps {
                script {
                    // Перевірка чи встановлений Docker та Docker Compose
                    sh 'docker --version'
                    sh 'docker-compose --version'
                }
            }
        }

        stage('Start Containers') {
            steps {
                script {
                    // Запуск контейнерів за допомогою Docker Compose
                    sh """
                    docker-compose -f docker-compose.yml up -d
                    """
                }
            }
        }

        stage('Wait for Services') {
            steps {
                script {
                    // Зачекаємо, поки сервіси запустяться
                    sleep(time: 30, unit: 'SECONDS')
                }
            }
        }

        stage('Test Containers') {
            steps {
                script {
                    // Перевірка чи працюють контейнери (наприклад, через доступність портів)
                    sh 'curl -s http://localhost:3000' // перевірка Grafana
                    sh 'curl -s http://localhost:9090' // перевірка Prometheus
                    sh 'curl -s http://localhost:9093' // перевірка Alertmanager
                    sh 'curl -s http://localhost:9100' // перевірка Node Exporter
                    sh 'curl -s http://localhost:8080' // перевірка cAdvisor
                }
            }
        }

        stage('Stop Containers') {
            steps {
                script {
                    // Зупинка та видалення контейнерів після завершення
                    sh """
                    docker-compose -f docker-compose.yml down
                    """
                }
            }
        }

    }

    post {
        always {
            // Очищення робочого простору після виконання
            cleanWs()
        }
        success {
            echo 'Контейнери успішно запущені, протестовані та зупинені.'
        }
        failure {
            echo 'Сталася помилка під час виконання.'
        }
    }
}
