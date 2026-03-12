pipeline {
    agent any

    environment {
        // Host path for Docker volume mount
        HOST_WORKSPACE = "/var/jenkins_home/workspace/Devops"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/sidheshsahu/End-to-End-House-Price-Prediction-Pipeline'
            }
        }

        stage('Debug Workspace') {
            steps {
                sh '''
                echo "Workspace path:"
                pwd
                echo "Files:"
                ls -R
                echo "Terraform file check:"
                ls -la terraform/
                cat terraform/main.tf
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                sh """
                docker run --rm \
                -v ${HOST_WORKSPACE}:/project \
                -w /project/terraform \
                hashicorp/terraform:latest init
                """
            }
        }

        stage('Terraform Validate') {
            steps {
                sh """
                docker run --rm \
                -v ${HOST_WORKSPACE}:/project \
                -w /project/terraform \
                hashicorp/terraform:latest validate
                """
            }
        }

        stage('Terraform Security Scan') {
            steps {
                sh """
                docker run --rm \
                -v ${HOST_WORKSPACE}:/project \
                aquasec/trivy:latest config \
                --severity HIGH,CRITICAL \
                --exit-code 1 \
                /project/terraform
                """
            }
        }

    }
}