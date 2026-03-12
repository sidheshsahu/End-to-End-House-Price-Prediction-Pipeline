pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                url: 'https://github.com/sidheshsahu/End-to-End-House-Price-Prediction-Pipeline'
            }
        }

        stage('Debug Workspace') {
            steps {
                sh '''
                pwd
                ls -R
                '''
            }
        }

        stage('Terraform Init') {
            agent {
                docker { image 'hashicorp/terraform:latest' }
            }
            steps {
                sh '''
                cd terraform
                terraform init
                '''
            }
        }

        stage('Terraform Validate') {
            agent {
                docker { image 'hashicorp/terraform:latest' }
            }
            steps {
                sh '''
                cd terraform
                terraform validate
                '''
            }
        }

        stage('Trivy Security Scan') {
            agent {
                docker { image 'aquasec/trivy:latest' }
            }
            steps {
                sh '''
                trivy config --severity HIGH,CRITICAL terraform/
                '''
            }
        }

    }
}