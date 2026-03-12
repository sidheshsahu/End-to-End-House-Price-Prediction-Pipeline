pipeline {
    agent any 
    stages {
        stage('Pull') { 
            steps {
                git 'https://github.com/sidheshsahu/End-to-End-House-Price-Prediction-Pipeline'
            }
        }
        stage('terraform init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('terraform plan') {
            steps {
                sh 'terraform plan'
            }
        }
        stage('terraform validate') {
            steps {
                sh 'terraform validate'
            }
        }
        stage('terraform apply') {
            steps {
                sh 'terraform ${Action} --auto-approve'
            }
        }
    }
}