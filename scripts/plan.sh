#!/bin/bash
# Show what Terraform will do (plan)

set -e

cd terraform/environments/dev

echo "📋 Planning Terraform changes..."
terraform plan -out=tfplan

echo ""
echo "Plan saved to: tfplan"
echo "Review the changes above, then run: terraform apply tfplan"