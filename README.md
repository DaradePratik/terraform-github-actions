# Terraform GitHub Actions CI/CD

A hands-on Infrastructure as Code project demonstrating how to automate Terraform deployments to Microsoft Azure using **GitHub Actions, Terraform, and OIDC authentication**.

The project focuses on building a secure CI/CD pipeline without storing long-lived Azure client secrets in GitHub.

## Architecture

```text
Developer
    │
    ▼
Feature Branch
    │
    ▼
Pull Request
    │
    ▼
GitHub Actions
    │
    ├── Super-Linter
    ├── Terraform Init
    ├── Terraform Validate
    └── Terraform Plan
            │
            ▼
      GitHub OIDC Token
            │
            ▼
     Microsoft Entra ID
            │
      Federated Credential
            │
            ▼
      Service Principal
            │
         Azure RBAC
            │
            ▼
       Azure Resources
```

## Technologies

- **Terraform** — Infrastructure as Code
- **Microsoft Azure** — Cloud infrastructure
- **GitHub Actions** — CI/CD automation
- **Microsoft Entra ID** — Identity and authentication
- **OIDC** — Passwordless GitHub-to-Azure authentication
- **Azure RBAC** — Authorization
- **GitHub Super-Linter** — Code quality and linting

## Repository Structure

```text
terraform-github-actions/
│
├── .github/
│   └── workflows/
│       └── terraform-ci.yml
│
├── environments/
│   ├── dev/
│   │   └── terraform.tfvars
│   └── prod/
│       └── terraform.tfvars
│
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── terraform.tf
├── .gitignore
└── README.md
```

## CI Workflow

The GitHub Actions workflow runs Terraform checks when a pull request is created or updated against the `main` branch.

```text
Pull Request
     │
     ▼
Checkout Repository
     │
     ▼
Azure Login (OIDC)
     │
     ▼
Super-Linter
     │
     ▼
Terraform Init
     │
     ▼
Terraform Validate
     │
     ▼
Terraform Plan
```

## Super-Linter

GitHub Super-Linter is used as a separate code-quality check.

Terraform-specific validation is performed separately using:

```bash
terraform validate
```

Terraform then generates an execution plan using:

```bash
terraform plan -var-file="environments/dev/terraform.tfvars"
```

## Azure Authentication with OIDC

The pipeline authenticates to Azure using **GitHub Actions OIDC federation** rather than an Azure client secret.

```text
GitHub Actions
      │
      │ OIDC Token
      ▼
Microsoft Entra ID
      │
      ▼
App Registration
      │
      ▼
Federated Identity Credential
      │
      ▼
Service Principal
      │
      │ Azure RBAC
      ▼
Azure Resources
```

The Federated Identity Credential establishes trust between the GitHub repository and Microsoft Entra ID.

The Service Principal is then authorized to manage Azure resources using Azure RBAC.

### Why OIDC?

Traditional Service Principal authentication can use a client secret that must be stored and rotated.

OIDC eliminates the need for a long-lived Azure client secret.

GitHub Actions obtains a short-lived OIDC token that Microsoft Entra ID validates before granting access to Azure.

## GitHub Secrets

The workflow uses the following repository secrets:

```text
AZURE_CLIENT_ID
AZURE_TENANT_ID
AZURE_SUBSCRIPTION_ID
```

No `AZURE_CLIENT_SECRET` is required because authentication uses OIDC.

## Environment Configuration

Environment-specific Terraform variables are stored separately:

```text
environments/
├── dev/
│   └── terraform.tfvars
└── prod/
    └── terraform.tfvars
```

For example:

```bash
terraform plan -var-file="environments/dev/terraform.tfvars"
```

Production can use:

```bash
terraform plan -var-file="environments/prod/terraform.tfvars"
```

This allows the same Terraform configuration to be reused across multiple environments.

## Security

This project follows several security practices:

- Uses OIDC instead of long-lived Azure client secrets
- Uses Azure RBAC for authorization
- Excludes Terraform state files from Git
- Does not commit Terraform provider binaries
- Uses GitHub Actions permissions explicitly
- Supports branch protection for the `main` branch
- Can be extended with GitHub Environment protection for production

## Current Status

### Completed

- [x] Terraform project structure
- [x] Azure App Registration
- [x] Service Principal
- [x] Federated Identity Credential
- [x] GitHub Actions OIDC authentication
- [x] Azure RBAC configuration
- [x] GitHub Actions CI workflow
- [x] GitHub Super-Linter
- [x] Terraform Init
- [x] Terraform Validate
- [x] Terraform Plan
- [x] Successful GitHub Actions to Azure authentication

### Planned Improvements

- [ ] Dev/Prod environment selection
- [ ] GitHub Environment protection
- [ ] Terraform plan posted to pull requests
- [ ] Terraform Apply workflow
- [ ] Production approval gate
- [ ] Remote Terraform state in Azure Storage
- [ ] Least-privilege Azure RBAC
- [ ] Reusable GitHub Actions workflows

## Learning Outcomes

This project demonstrates practical experience with:

- Terraform
- Microsoft Azure
- Infrastructure as Code
- GitHub Actions
- CI/CD pipelines
- OIDC authentication
- Microsoft Entra ID
- App Registrations
- Service Principals
- Federated Identity Credentials
- Azure RBAC
- GitHub branch protection
- Environment-based infrastructure deployments
- Infrastructure security