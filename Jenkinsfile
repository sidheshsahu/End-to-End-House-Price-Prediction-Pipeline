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
                echo "Workspace path:"
                pwd
                echo "Files:"
                ls -R
                '''
            }
        }

        stage('Check Terraform File') {
            steps {
                sh '''
                echo "Terraform folder:"
                ls -l terraform
                echo "Terraform file content:"
                cat terraform/main.tf
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                docker run --rm \
                -v $WORKSPACE:/project \
                -w /project/terraform \
                hashicorp/terraform:latest init
                '''
            }
        }

        stage('Terraform Validate') {
            steps {
                sh '''
                docker run --rm \
                -v $WORKSPACE:/project \
                -w /project/terraform \
                hashicorp/terraform:latest validate
                '''
            }
        }

        stage('Terraform Security Scan') {
            steps {
                sh '''
                docker run --rm \
                -v $WORKSPACE:/project \
                aquasec/trivy:latest config \
                --severity HIGH,CRITICAL \
                /project/terraform
                '''
            }
        }

    }
}