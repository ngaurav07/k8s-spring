pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "spring-boot-app:v1.0"
        REMOTE_HOST = '18.117.149.95'
        REMOTE_USER = 'ubuntu'
        REMOTE_PATH = '/var/www/minimart'
        SSH_KEY = '284afe8a-95fb-4d1b-9700-6c81b3134b1d'
    }

    stages {

        stage('Checkout') {
            steps {
                git url: 'https://github.com/ngaurav07/k8s-spring.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $DOCKER_IMAGE ."
                }
            }
        }

        stage('Transfer Docker Image to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: SSH_KEY, keyFileVariable: 'SSH_KEY')]) {
                    script {
                        sh "docker save $DOCKER_IMAGE -o /tmp/spring-boot-app.tar"
                        sh "scp -i $SSH_KEY /tmp/spring-boot-app.tar $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: SSH_KEY, keyFileVariable: 'SSH_KEY')]) {
                    script {
                        sh "ssh -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST 'docker load -i $REMOTE_PATH/spring-boot-app.tar'"
                        sh "ssh -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST 'docker stop spring-boot-app || true && docker rm spring-boot-app || true && docker run -d -p 8080:8080 --name spring-boot-app $DOCKER_IMAGE'"
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                sh "docker system prune -f"
                sh "rm -f /tmp/spring-boot-app.tar"
            }
        }
    }
}
