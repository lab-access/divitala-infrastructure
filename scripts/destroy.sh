#!/bin/bash
# Destroy all resources (WARNING: deletes everything)

set -e

read -p "⚠️  Are you sure you want to destroy all resources? Type 'yes' to confirm: " confirm

if [ "$confirm" != "yes" ]; then
  echo "Cancelled."
  exit 1
fi

cd terraform/environments/dev

echo "🗑️  Destroying all resources..."
terraform destroy -auto-approve

echo ""
echo "✅ Resources destroyed!"