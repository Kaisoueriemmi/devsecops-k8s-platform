#!/usr/bin/env bash
# v1 : crée le Secret « printbox-secrets » directement dans le cluster, avec des valeurs aléatoires.
# Rien n'est écrit dans Git. Remplacé en v2 par SOPS + age et External Secrets (SEC-01, SEC-02).
set -euo pipefail
NS=printbox
rand() { head -c 48 /dev/urandom | base64 | tr -d '\n/+=' | head -c "${1:-48}"; }
PG="$(rand 32)"
kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f -
kubectl -n "$NS" create secret generic printbox-secrets \
  --from-literal=POSTGRES_PASSWORD="$PG" \
  --from-literal=DATABASE_URL="postgresql://printbox:${PG}@postgres:5432/printbox" \
  --from-literal=QR_TOKEN_SECRET="$(rand 48)" \
  --from-literal=SESSION_TOKEN_SECRET="$(rand 48)" \
  --from-literal=S3_ACCESS_KEY_ID="printbox" \
  --from-literal=S3_SECRET_ACCESS_KEY="$(rand 32)" \
  --dry-run=client -o yaml | kubectl apply -f -
echo "Secret printbox-secrets créé dans le namespace $NS."
