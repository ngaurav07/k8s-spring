pipeline {
    agent any

    environment {
        // Set any environment variables you might need
        MAVEN_HOME = tool 'M3'  // Assumes Maven is installed in Jenkins with the name 'M3'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the Git repository
                git branch: 'main', url: 'https://github.com/your-repo-url.git'
            }
        }

        stage('Build') {
            steps {
                // Use Maven to clean and compile the project
                sh "${MAVEN_HOME}/bin/mvn clean install"
            }
        }

        stage('Test') {
            steps {
                // Use Maven to run tests
                sh "${MAVEN_HOME}/bin/mvn test"
            }
        }

        stage('Deploy') {
            steps {
                // Custom deployment steps, for example, SCP to a server or running on Docker
                echo 'Deploying application...'
                // Add your deployment steps here
            }
        }
    }

    post {
        always {
            // Actions that will run after the pipeline, e.g., clean up or notifications
            echo 'Pipeline finished!'
        }
    }
}
