#!/bin/bash
# Initialize dev environment with Terraform

set -e

echo "🔧 Initializing Terraform for development environment..."

cd terraform/environments/dev

echo ""
echo "Step 1: Initializing Terraform (downloading providers)..."
terraform init \
  -backend-config="backend.tfvars" \
  -input=false

echo ""
echo "Step 2: Validating configuration..."
terraform validate

echo ""
echo "✅ Initialization complete!"
echo ""
echo "Next steps:"
echo "  terraform plan    - See what will be created"
echo "  terraform apply   - Actually create resources"
echo "  terraform destroy - Delete all resources"