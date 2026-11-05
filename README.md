# DevSecOps Pipeline — Startup API on Azure

Production-style CI/CD pipeline with security gates at every stage.

## Pipeline

PR → Unit Tests → SAST (SonarQube) → SCA (Trivy) → IaC Scan (Trivy)
→ Docker Build → Container Scan (Trivy) → Push (ACR)
→ Deploy Staging (AKS) → DAST (OWASP ZAP) → Approval → Production


## Prerequisites

- Azure subscription with AKS, ACR, Log Analytics enabled
- GitHub repository with Actions enabled
- SonarQube instance (cloud or self-hosted)
- Azure Workload Identity Federation configured (see setup above)
- Azure CLI installed locally for Terraform

## Terraform

```bash
cd terraform/environments/staging
az login
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
Nodes	1–3 D2s_v5	2–10 D4s_v5
Replicas	1	3 (HPA to 10)
ACR SKU	Standard	Premium
Private Cluster	Off	On
Approval	None	Required (GitHub)


---

## Key Differences from GCP Version

| Aspect | GCP | Azure |
|--------|-----|-------|
| Auth in CI | `google-github-actions/auth` + WIF | `azure/login@v2` + OIDC |
| No secrets | WIF provider + SA email | `id-token: write` + client/tenant/sub IDs (public) |
| Image registry | Artifact Registry (`us-docker.pkg.dev`) | ACR (`startupacrstg.azurecr.io`) |
| K8s auth | `gcloud container clusters get-credentials` | `az aks get-credentials` |
| Ingress | GCE Ingress (`ingressClassName: google`) | Application Gateway (`azure-application-gateway`) |
| Pod identity | GCP SA annotation | Azure Workload Identity (`azure.workload.identity/client-id`) |
| State backend | GCS bucket | Azure Storage Account (Blob) |
| Provider | `hashicorp/google` | `hashicorp/azurerm` |
| Local CLI | `gcloud` | `az` |
