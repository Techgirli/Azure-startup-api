# DevSecOps Pipeline — Startup API on GCP

Production-style CI/CD pipeline with security gates at every stage.

## Pipeline

PR → Unit Tests → SAST (SonarQube) → SCA (Trivy) → IaC Scan (Trivy)
→ Docker Build → Container Scan (Trivy) → Push (Artifact Registry)
→ Deploy Staging (GKE) → DAST (OWASP ZAP) → Approval → Production


## Prerequisites

- GCP project with Container, Artifact Registry, Compute APIs enabled
- GitHub repository with Actions enabled
- SonarQube instance (cloud or self-hosted)
- Workload Identity Federation configured (see `docs/setup.md`)

## Terraform

```bash
cd terraform/environments/staging
terraform init
terraform plan
terraform apply


Local Development
cd app
npm install
npm test
npm start

Security Gates
Stage	Tool	Blocks on
SAST	SonarQube	Quality Gate failure
SCA	Trivy FS	HIGH/CRITICAL (fixable)
IaC	Trivy Config	HIGH/CRITICAL misconfig
Container	Trivy Image	HIGH/CRITICAL CVE
DAST	OWASP ZAP	Any alert (baseline)
Secrets	Gitleaks	Any secret in history

Environments
Staging	Production
Nodes	1–3 e2-medium	2–10 e2-standard-4
Replicas	1	3 (HPA to 10)
Binary Auth	Off	On
Deletion Protection	Off	On
Approval	None	Required (GitHub)


---

## Final Directory Tree (complete)

my-startup-api/
├── .github/
│ └── workflows/
│ ├── ci.yml
│ ├── cd.yml
│ └── rollback.yml
├── app/
│ ├── src/
│ ├── tests/
│ │ └── server.test.js
│ ├── server.js
│ ├── package.json
│ └── Dockerfile
├── terraform/
│ ├── modules/
│ │ ├── gke-cluster/
│ │ │ ├── main.tf
│ │ │ ├── variables.tf
│ │ │ ├── outputs.tf
│ │ │ └── versions.tf
│ │ ├── artifact-registry/
│ │ │ ├── main.tf
│ │ │ ├── variables.tf
│ │ │ └── outputs.tf
│ │ └── network/
│ │ ├── main.tf
│ │ ├── variables.tf
│ │ └── outputs.tf
│ └── environments/
│ ├── staging/
│ │ ├── main.tf
│ │ ├── variables.tf
│ │ ├── outputs.tf
│ │ └── terraform.tfvars
│ └── production/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ └── terraform.tfvars
├── k8s/
│ └── helm/
│ ├── Chart.yaml
│ ├── values.yaml
│ ├── values-staging.yaml
│ ├── values-prod.yaml
│ └── templates/
│ ├── _helpers.tpl
│ ├── deployment.yaml
│ ├── service.yaml
│ ├── ingress.yaml
│ ├── hpa.yaml
│ ├── pdb.yaml
│ ├── serviceaccount.yaml
│ ├── networkpolicy.yaml
│ └── NOTES.txt
├── .gitleaks.toml
├── sonar-project.properties
└── README.md


This is now a fully reproducible project — clone it, run the GCP setup script, push to GitHub, and the pipeline runs end-to-end.

