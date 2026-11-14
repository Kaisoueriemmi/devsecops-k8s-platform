#!/usr/bin/env bash
# Vérifie les services AWS émulés dont le projet dépend (RK-02).
set -u
EP="${1:-http://localhost:4566}"
export AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_DEFAULT_REGION=us-east-1
aws() { command aws --endpoint-url "$EP" "$@"; }
ok=0; ko=0
t() { local n="$1"; shift; if "$@" >/dev/null 2>&1; then echo "OK   $n"; ok=$((ok+1)); else echo "FAIL $n"; ko=$((ko+1)); fi; }
B="floci-check-$$"
t s3-create-bucket   aws s3 mb "s3://$B"
echo hello > /tmp/fc.txt
t s3-put             aws s3 cp /tmp/fc.txt "s3://$B/fc.txt"
t s3-get             aws s3 cp "s3://$B/fc.txt" /tmp/fc.out
t s3-versioning      aws s3api put-bucket-versioning --bucket "$B" --versioning-configuration Status=Enabled
t sqs-create         aws sqs create-queue --queue-name "$B"
t secretsmanager     aws secretsmanager create-secret --name "$B" --secret-string x
t kms-create-key     aws kms create-key
t dynamodb-lock      aws dynamodb create-table --table-name "$B" --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST
aws s3 rb "s3://$B" --force >/dev/null 2>&1
echo "Résultat : $ok OK, $ko FAIL"; [ "$ko" -eq 0 ]
