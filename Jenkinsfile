pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('ARM_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('ARM_CLIENT_SECRET')
        ARM_TENANT_ID       = credentials('ARM_TENANT_ID')
        ARM_SUBSCRIPTION_ID = credentials('ARM_SUBSCRIPTION_ID')
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/sidheshsahu/End-to-End-House-Price-Prediction-Pipeline'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh '''
                cd terraform

                echo "=== Downloading Terraform ==="
                curl -fsSL https://releases.hashicorp.com/terraform/1.7.0/terraform_1.7.0_linux_amd64.zip -o terraform.zip
                unzip -o terraform.zip
                chmod +x terraform

                echo "=== Terraform Init ==="
                ./terraform init -backend=false

                echo "=== Terraform Validate ==="
                ./terraform validate
                '''
            }
        }

        stage('Terraform Security Scan') {
            steps {
                sh '''
                echo "=== Installing Trivy ==="
                curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /tmp/trivy-bin

                echo "=== Running Trivy Scan ==="
                /tmp/trivy-bin/trivy config \
                    --severity HIGH,CRITICAL \
                    --exit-code 1 \
                    terraform/
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                cd terraform

                echo "=== Terraform Plan ==="
                ./terraform plan -input=false
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                cd terraform

                echo "=== Terraform Apply ==="
                ./terraform apply -auto-approve -input=false
                '''
            }
        }

    }
}