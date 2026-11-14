# DevSecOps sur Kubernetes (local, 100 % open source)

> **Le cloud AWS est émulé par [Floci](https://github.com/floci-io/floci) : ce projet n'utilise pas un vrai AWS.**
> La couverture de Floci varie selon les opérations ; voir `docs/adr/0002-floci.md`.

Pipeline DevSecOps de bout en bout sur un cluster kubeadm local : scans en CI, SBOM, signature Cosign, vérification Kyverno, GitOps ArgoCD, observabilité SRE, canary et tests de fiabilité. Application de démonstration : PrintBox.

## Phases
- v1 : répliquer (CI de scans, GHCR, ArgoCD, Prometheus, ZAP)
- v2 : durcir (supply chain, politiques, secrets, Falco, automatisation)
- v3 : différencier côté SRE (SLO, Loki/Tempo, canary, chaos, Velero)

## Démarrage
```
make help
make floci-check   # vérifie que Floci répond sur :4566
```

## Arborescence
`infra/` (Ansible, OpenTofu) · `k8s/` (apps, platform, policies) · `.github/workflows` · `docs/` (adr, runbooks, postmortem, preuves)
