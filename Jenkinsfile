pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/sidheshsahu/End-to-End-House-Price-Prediction-Pipeline'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'docker run --rm -v $(pwd)/terraform:/workspace -w /workspace hashicorp/terraform:latest init'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'docker run --rm -v $(pwd)/terraform:/workspace -w /workspace hashicorp/terraform:latest validate'
            }
        }

        stage('Terraform Security Scan') {
            steps {
                sh '''
                docker run --rm \
                -v $(pwd)/terraform:/project \
                aquasec/trivy config /project
                '''
            }
        }

    }


    stage('Debug Files') {
    steps {
        sh '''
        echo "Workspace files:"
        ls -R
        '''
    }
}
}