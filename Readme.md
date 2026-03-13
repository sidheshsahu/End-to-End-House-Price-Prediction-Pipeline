# End-to-End House Price Prediction — DevSecOps Pipeline

## Project Overview

This project demonstrates a complete DevSecOps pipeline for a **Mumbai House Price Prediction** web application. The application is built with **Python Flask** (backend) and **HTML/CSS** (frontend), containerized using Docker, and deployed on **Microsoft Azure** using Terraform. A Jenkins CI/CD pipeline automates infrastructure security scanning using Trivy before deployment.

---


## Tools and Technologies

| Category | Tool |
|----------|------|
| Web Framework | Python Flask |
| Frontend | HTML, CSS |
| ML Model | Scikit-learn (joblib) |
| Containerization | Docker, Docker Compose |
| CI/CD | Jenkins |
| Security Scanner | Trivy (Aqua Security) |
| Infrastructure as Code | Terraform (Azure Provider) |
| Cloud | Microsoft Azure |
| Version Control | Git, GitHub |

---

## Project Structure

```
├── app.py                    # Flask backend
├── Dockerfile                # Docker image configuration
├── docker-compose.yml        # Docker Compose setup
├── requirements.txt          # Python dependencies
├── house_model.joblib        # Trained ML model
├── Jenkinsfile               # Jenkins CI/CD pipeline
├── static/
│   └── styles.css            # Frontend styles
├── templates/
│   └── index.html            # Frontend HTML
└── terraform/
    └── main.tf               # Azure infrastructure code
```

---

## Jenkins Pipeline Stages

```
Stage 1: Checkout Code
    └── Pull source code from GitHub

Stage 2: Terraform Validate
    └── Download Terraform
    └── Initialize providers
    └── Validate main.tf

Stage 3: Terraform Security Scan (Trivy)
    └── Install Trivy
    └── Scan terraform/ for misconfigurations
    └── Fail pipeline on HIGH/CRITICAL findings

Stage 4: Terraform Plan
    └── Preview infrastructure changes

Stage 5: Terraform Apply
    └── Provision Azure infrastructure
    └── Output public IP
```

##  AI Usage Log (GenAI Report)

### Exact Prompt Used

```
I am a DevOps engineer. My Jenkins pipeline ran a Trivy security
scan on my Terraform code and found these CRITICAL vulnerabilities:

AZU-0047: Security group rule allows unrestricted ingress from any IP address.
AZU-0050: Security group rule allows unrestricted ingress to SSH port from any IP.

My current vulnerable Terraform code is:

resource "azurerm_network_security_group" "nsg" {
  security_rule {
    name                       = "AllowSSH"
    destination_port_range     = "22"
    source_address_prefix      = "*"
  }
}

Please:
1. Explain the security risks of this code
2. Rewrite the fixed Terraform code
3. Explain what changes you made and why
```

---

### Summary of Identified Risks

| Vulnerability | ID | Severity | Risk |
|---------------|-----|----------|------|
| SSH open to entire internet | AZU-0047 | CRITICAL | Any attacker can attempt brute force on port 22 |
| Unrestricted SSH ingress | AZU-0050 | CRITICAL | No IP restriction means global exposure |

**Detailed Risk Explanation (AI Generated):**

- **AZU-0047 & AZU-0050**: Setting `source_address_prefix = "*"` means SSH port 22 is accessible from the entire internet (`0.0.0.0/0`). Any malicious actor worldwide can attempt to connect and brute-force credentials, potentially gaining full server access leading to data theft, ransomware deployment, or cryptomining.

---

### AI-Recommended Changes & How They Improved Security

| Change | Before | After | Impact |
|--------|--------|-------|--------|
| SSH source IP | `"*"` (entire internet) | `"152.59.63.182/32"` (specific IP only) | Eliminates AZU-0047 & AZU-0050 |

**Result:**
- Before: 2 CRITICAL + 1 HIGH vulnerability → Pipeline **FAILED**
- After: 0 vulnerabilities → Pipeline **PASSED**

---

##  Docker Setup

### Dockerfile
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
```

### docker-compose.yml
```yaml
services:
  flask-app:
    build: .
    container_name: house_price_app
    ports:
      - "5000:5000"
```
---

##  How to Run Locally

```bash
# Clone the repository
git clone https://github.com/sidheshsahu/End-to-End-House-Price-Prediction-Pipeline

# Run with Docker Compose
cd End-to-End-House-Price-Prediction-Pipeline
docker-compose up --build -d

# Access the app
http://localhost:5000
```
---

## Screenshots

| Screenshot | Description |
|------------|-------------|
| Jenkins Build 29| Initial FAILING pipeline — Trivy found 2 CRITICAL vulnerabilities |
| Jenkins Build 30| Final PASSING pipeline — Zero vulnerabilities after AI remediation |
| Jenkins Build 42| Terraform Deployment|
| Azure Portal | VM running with public IP |
| App on Cloud IP | http://74.225.160.111:5000 |

---

