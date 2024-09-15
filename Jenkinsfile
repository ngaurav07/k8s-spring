pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'spring-boot-app:latest'
        REMOTE_HOST = '18.117.149.95'
        REMOTE_USER = 'ubuntu'
        REMOTE_PORT = '22'
        REMOTE_PATH = '/var/www/minimart'
        SSH_KEY = credentials('284afe8a-95fb-4d1b-9700-6c81b3134b1d') // Jenkins credentials ID for SSH key
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Transfer Docker Image to EC2') {
            steps {
                script {
                    // Save the Docker image to a tar file
                    sh 'docker save $DOCKER_IMAGE -o /tmp/spring-boot-app.tar'

                    // Transfer the tar file to the EC2 instance
                    sh 'scp -i $SSH_KEY -P $REMOTE_PORT /tmp/spring-boot-app.tar $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH'
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    // Load the Docker image on the EC2 instance
                    sh 'ssh -i $SSH_KEY -p $REMOTE_PORT $REMOTE_USER@$REMOTE_HOST "docker load -i $REMOTE_PATH/spring-boot-app.tar"'

                    // Run the Docker container on the EC2 instance
                    sh 'ssh -i $SSH_KEY -p $REMOTE_PORT $REMOTE_USER@$REMOTE_HOST "docker stop spring-boot-app || true && docker rm spring-boot-app || true && docker run -d -p 8080:8080 --name spring-boot-app $DOCKER_IMAGE"'
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker resources
            sh 'docker system prune -f'
        }
    }
}
