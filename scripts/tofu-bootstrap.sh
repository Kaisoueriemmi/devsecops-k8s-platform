#!/usr/bin/env bash
# Crée une fois le bucket d'état et la table de verrou d'OpenTofu sur Floci (INF-03).
set -euo pipefail
EP="${1:-http://localhost:4566}"
export AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_DEFAULT_REGION=us-east-1
aws() { command aws --endpoint-url "$EP" "$@"; }
aws s3api head-bucket --bucket tofu-state 2>/dev/null || aws s3 mb s3://tofu-state
aws s3api put-bucket-versioning --bucket tofu-state --versioning-configuration Status=Enabled
aws dynamodb describe-table --table-name tofu-lock >/dev/null 2>&1 || aws dynamodb create-table \
  --table-name tofu-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST >/dev/null
echo "Backend prêt : bucket tofu-state, table tofu-lock sur $EP"
