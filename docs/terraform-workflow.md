# Terraform Workflow for Divitala

## Directory Structure
terraform/
├── main.tf # Root configuration (calls modules)
├── variables.tf # Input variables
├── outputs.tf # Output values
├── modules/ # Reusable components
│ ├── networking/
│ ├── security/
│ ├── monitoring/
│ ├── storage/
│ ├── compute/
│ └── database/
└── environments/ # Environment-specific configs
├── dev/
│ ├── main.tf
│ ├── terraform.tfvars # YOUR VALUES GO HERE
│ └── backend.tfvars # Backend config
├── staging/
└── prod/


## Common Commands

### Initialize

cd terraform/environments/dev
terraform init -backend-config="backend.tfvars"

Validate Syntax
terraform validate

See What Will Happen
terraform plan -out=tfplan

Create Resources
terraform apply tfplan

View Created Resources
terraform show
terraform output

Destroy Everything
terraform destroy

Understanding Terraform Files
main.tf
- Configures providers (Azure, AzureAD, Random)
- Defines backend (where state is stored)
- Creates locals (variables used throughout)
- Calls all modules

variables.tf
- Input variables (the knobs you turn)
Each variable has:
- description - What it does
- type - String, number, list, etc.
- default - If not provided
- validation - Error checking
- outputs.tf
- Exports values (useful info)
- Example: Resource IDs, names, IP addresses

terraform.tfvars
- YOUR VALUES go here
- Example: subscription_id, environment, location
- Never commit secrets here (use .gitignore)

backend.tfvars
- Tells Terraform where to store state
- Points to Azure Storage Account created earlier

Workflow
- Write Terraform code (define what you want)
- Validate syntax (terraform validate)
- Preview changes (terraform plan)
- Apply changes (terraform apply)
- Verify creation (terraform output, check portal)

State File (.tfstate)
What: Records of what resources exist
Where: terraform/ folder (local) or Azure Storage (remote)
Why: Terraform uses it to know what to update/delete
Secret: Contains passwords, keys - never commit to Git
Backup: Automatically backed up to Azure Storage

Troubleshooting
- Error: "resource already exists"
Resource was created manually (outside Terraform)
Either delete manually or import it: terraform import

- Error: "backend already configured"
Run terraform destroy in that directory first

- Error: "invalid provider version"
Run terraform init to update providers

- Want to see what changed?
terraform plan shows additions/modifications/deletions
Green + = new resource
Yellow ~ = modified resource
Red - = deleted resource