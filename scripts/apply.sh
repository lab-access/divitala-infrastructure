#!/bin/bash
# Apply Terraform configuration (create resources)

set -e

cd terraform/environments/dev

if [ ! -f tfplan ]; then
  echo "❌ No plan file found. Run: scripts/plan.sh"
  exit 1
fi

echo "🚀 Applying Terraform configuration..."
terraform apply tfplan

echo ""
echo "✅ Resources created!"
echo ""
terraform output