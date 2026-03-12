pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/sidheshsahu/End-to-End-House-Price-Prediction-Pipeline'
            }
        }

        stage('Debug Workspace') {
            steps {
                sh '''
                echo "Current workspace:"
                pwd
                echo "Workspace files:"
                ls -R
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                docker run --rm \
                -v $WORKSPACE/terraform:/workspace \
                -w /workspace \
                hashicorp/terraform:latest init
                '''
            }
        }

        stage('Terraform Validate') {
            steps {
                sh '''
                docker run --rm \
                -v $WORKSPACE/terraform:/workspace \
                -w /workspace \
                hashicorp/terraform:latest validate
                '''
            }
        }

        stage('Terraform Security Scan') {
            steps {
                sh '''
                docker run --rm \
                -v $WORKSPACE/terraform:/project \
                aquasec/trivy config --severity HIGH,CRITICAL /project
                '''
            }
        }

    }
}