#!/bin/bash
set -e

SUB_ID="87e758c3-983a-4492-9b03-d80271d28421"
TENANT_ID="b517df4b-dc6d-4190-8381-4bd989bd0d6a"
LOCATION="eastus"

echo "=== 1. Login ==="
az login

echo "=== 2. Resource Groups ==="
az group create -n rg-startup-staging -l $LOCATION
az group create -n rg-startup-prod -l $LOCATION

echo "=== 3. Storage Accounts (state backends) ==="
az storage account create -n startupstatestg -g rg-startup-staging -l $LOCATION --sku Standard_LRS
az storage account create -n startupstateprd -g rg-startup-prod -l $LOCATION --sku Standard_LRS

az storage container create -n tfstate -g rg-startup-staging --account-name startupstatestg --auth-mode login
az storage container create -n tfstate -g rg-startup-prod --account-name startupstateprd --auth-mode login

echo "=== 4. Managed Identity ==="
az identity create -n id-github-actions -g rg-startup-staging -l $LOCATION
IDENTITY_PRINCIPAL=$(az identity show -n id-github-actions -g rg-startup-staging --query principalId -o tsv)
CLIENT_ID=$(az identity show -n id-github-actions -g rg-startup-staging --query clientId -o tsv)
echo "Client ID: $CLIENT_ID"
echo "Principal ID: $IDENTITY_PRINCIPAL"

echo "=== 5. Federated Credentials ==="
GITHUB_USER="techgirli"

az identity federated-credential create \
  --name github-staging \
  --identity-name id-github-actions \
  --resource-group rg-startup-staging \
  --issuer "https://token.actions.githubusercontent.com" \
  --subject "repo:${GITHUB_USER}/my-startup-api:environment:staging" \
  --audiences "api://AzureADTokenExchange"

az identity federated-credential create \
  --name github-prod \
  --identity-name id-github-actions \
  --resource-group rg-startup-staging \
  --issuer "https://token.actions.githubusercontent.com" \
  --subject "repo:${GITHUB_USER}/my-startup-api:environment:production" \
  --audiences "api://AzureADTokenExchange"

echo "=== 6. Role Assignments ==="
az role assignment create \
  --assignee "$IDENTITY_PRINCIPAL" \
  --role "Contributor" \
  --scope "/subscriptions/$SUB_ID/resourceGroups/rg-startup-staging"

az role assignment create \
  --assignee "$IDENTITY_PRINCIPAL" \
  --role "Contributor" \
  --scope "/subscriptions/$SUB_ID/resourceGroups/rg-startup-prod"

echo ""
echo "=== DONE ==="
echo "Set these in your GitHub repo Settings → Secrets and variables → Actions:"
echo "  AZURE_CLIENT_ID       = $CLIENT_ID"
echo "  AZURE_TENANT_ID       = $TENANT_ID"
echo "  AZURE_SUBSCRIPTION_ID = $SUB_ID"
echo "  AZURE_ACR_NAME        = startupacrstg"
echo "  AZURE_STAGING_RG      = rg-startup-staging"
echo "  AZURE_PROD_RG         = rg-startup-prod"   
