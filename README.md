# DevSecOps Pipeline — Startup API on Azure

Production-style CI/CD pipeline with security gates at every stage.

## Pipeline

PR → Unit Tests → SAST (SonarQube) → SCA (Trivy) → IaC Scan (Trivy)
→ Docker Build → Container Scan (Trivy) → Push (ACR)
→ Deploy Staging (AKS) → DAST (OWASP ZAP) → Approval → Production


## Architecture

Developer
│
▼
GitHub (PR opened)
│
▼
┌─────────────────────────────────────────────────────────┐
│ CI (GitHub Actions) │
│ Unit Tests → SAST → SCA → IaC Scan → Build → Scan │
└─────────────────────────────────────────────────────────┘
│ (all gates pass)
▼
┌─────────────────────────────────────────────────────────┐
│ CD (GitHub Actions, on tag v*..) │
│ Push ACR → Deploy Staging → DAST → Approval → Prod │
└─────────────────────────────────────────────────────────┘
│
▼
Production (AKS)


## Prerequisites

- Azure free-tier subscription
- GitHub repository with Actions enabled
- SonarQube instance (cloud or self-hosted)
- Azure CLI (`az`) installed locally
- Terraform ≥ 1.5
- Docker
- Helm ≥ 3

## Quick Start

### 1. Azure Setup

```bash
# Install Azure CLI (if not already)
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/azure-cli.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/azure-cli.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update && sudo apt-get install -y azure-cli

# Run the setup script (edit GITHUB_USER first)
nano azure-startup.sh   # change GITHUB_USER="techgirli"
chmod +x azure-startup.sh
./azure-startup.sh

This creates:

Resource groups (rg-startup-staging, rg-startup-prod)
Storage accounts for Terraform state
User-assigned managed identity with federated credentials for GitHub Actions
Role assignments
2. GitHub Repo Variables
Go to Settings → Secrets and variables → Actions → Variables and add:

Variable	Value
AZURE_CLIENT_ID	(from script output)
AZURE_TENANT_ID	(from script output)
AZURE_SUBSCRIPTION_ID	(from script output)
AZURE_ACR_NAME	startupacrstg
AZURE_STAGING_RG	rg-startup-staging
AZURE_PROD_RG	rg-startup-prod

3. GitHub Environments
Go to Settings → Environments and create:

staging — no required reviewers
production — add yourself as a required reviewer
4. Terraform
cd terraform/environments/staging
terraform init
terraform plan
terraform apply

This provisions:

VNet + subnets
Log Analytics workspace
ACR (Basic)
AKS cluster (Free SKU, B1s nodes)
Repeat for terraform/environments/production/.

5. Push & Deploy
# Tag a release to trigger CD
git tag v1.0.0
git push origin v1.0.0

Repository Structure
Azure-startup-api/
├── .github/
│   └── workflows/
│       ├── ci.yml              # SAST, SCA, IaC scan, build, container scan
│       ├── cd.yml              # Deploy staging → DAST → approval → production
│       └── rollback.yml        # Manual rollback trigger
├── app/
│   ├── server.js
│   ├── tests/
│   │   └── server.test.js
│   ├── package.json
│   └── Dockerfile
├── terraform/
│   ├── modules/
│   │   ├── aks-cluster/
│   │   ├── acr/
│   │   ├── vnet/
│   │   └── log-analytics/
│   └── environments/
│       ├── staging/
│       └── production/
├── k8s/
│   └── helm/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── values-staging.yaml
│       ├── values-prod.yaml
│       └── templates/
├── .gitleaks.toml
├── .gitignore
├── sonar-project.properties
├── azure-startup.sh
└── README.md

Security Gates
Stage	Tool	Blocks on
Secrets	Gitleaks	Any secret in git history
SAST	SonarQube	Quality Gate failure
SCA	Trivy (fs)	HIGH/CRITICAL (fixable)
IaC	Trivy (config)	HIGH/CRITICAL misconfig
Container	Trivy (image)	HIGH/CRITICAL CVE
DAST	OWASP ZAP	Any alert (baseline)

Environments
Staging	Production
AKS SKU	Free	Free
Node size	B1s	B1s
Nodes	1 (max 2)	1 (max 3)
ACR SKU	Basic	Basic
Private cluster	Off	Off
Approval	None	Required (GitHub)
HPA	Off	On (1–3)

Local Development
cd app
npm install
npm test
npm start

Rollback
Trigger the Rollback workflow manually from GitHub Actions:

Go to Actions → Rollback
Click Run workflow
Select environment (staging or production)
Optionally specify a Helm revision (blank = previous)
Cost (Free Tier)
Item	Cost
AKS control plane × 2	$0
B1s nodes (750 hrs free/mo)	$0
ACR Basic × 2 (12 mo)	$0
VNet, subnets, NSGs	$0
Storage (state)	$0
Log Analytics (< 5 GB/mo)	$0
Load Balancer (Standard)	~$18/mo (covered by $200 credit)

Scale nodes to 0 when not in use: az aks scale --resource-group rg-startup-staging --name staging-aks --nodepool-name workloadpool --node-count 0

Tech Stack
IaC: Terraform (azurerm provider)
CI/CD: GitHub Actions
Container: Docker (multi-stage, distroless, non-root)
Orchestration: AKS + Helm
Registry: Azure Container Registry
SAST: SonarQube
SCA / Container / IaC: Trivy
DAST: OWASP ZAP
Secrets: Gitleaks
Auth: Azure Workload Identity Federation (OIDC, no secrets in CI)


