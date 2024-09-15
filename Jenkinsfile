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

        stage('Build Docker Image') {
            steps {
                script {
                    sh "sudo docker build -t $DOCKER_IMAGE ."
                }
            }
        }

        stage('Transfer Docker Image to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: SSH_KEY, keyFileVariable: 'SSH_KEY')]) {
                    script {
                        sh "sudo docker save $DOCKER_IMAGE -o /tmp/spring-boot-app.tar"

                        // Transfer the tar file to the EC2 instance
                        sh "scp -i $SSH_KEY /tmp/spring-boot-app.tar $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: SSH_KEY, keyFileVariable: 'SSH_KEY')]) {
                    script {
                        // Load the Docker image on the EC2 instance
                        sh "ssh -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST 'sudo docker load -i $REMOTE_PATH/spring-boot-app.tar'"

                        // Stop any existing container and run the new Docker container
                        sh "ssh -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST 'sudo docker stop spring-boot-app || true && sudo docker rm spring-boot-app || true && sudo docker run -d -p 8080:8080 --name spring-boot-app $DOCKER_IMAGE'"
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker resources on Jenkins server
            sh "docker system prune -f"
        }
    }
}
