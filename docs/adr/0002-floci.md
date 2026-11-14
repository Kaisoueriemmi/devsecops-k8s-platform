# ADR 0002 – Floci comme cloud AWS émulé

## Statut
Accepté (2026-11-13), à compléter après les tests Loki, Tempo, Velero et External Secrets.

## Contexte
Le projet doit rester gratuit et local (NF-01, NF-03). Floci émule les services AWS sur le port 4566. Sa couverture varie selon les opérations (RK-02).

## Spike n°1 – services de base (`make floci-check`, 2026-11-13)
Floci `floci/floci:latest`, test lancé depuis un conteneur `amazon/aws-cli` vers `host.docker.internal:4566`.

| Service | Test | Résultat |
|---|---|---|
| S3 | création de bucket, put, get, versioning | OK |
| SQS | création de file | OK |
| Secrets Manager | création de secret | OK |
| KMS | création de clé | OK |
| DynamoDB | table de verrou (LockID) | OK |

Résultat : 8 OK, 0 FAIL. Le backend OpenTofu (S3 + verrou DynamoDB) est donc jouable.

## À valider ensuite (avant de construire dessus)
- Loki et Tempo sur un bucket S3 Floci
- Velero (sauvegarde et restauration) vers S3 Floci
- External Secrets Operator vers Secrets Manager Floci (endpoint personnalisé)

## Plan B
MinIO local pour le stockage d'objets si l'un de ces outils échoue sur Floci.
