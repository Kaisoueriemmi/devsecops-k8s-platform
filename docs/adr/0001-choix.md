# ADR 0001 – Choix de départ (2026-11-13)
- Machine : 16 Go de RAM ou plus ; hôte Windows (WSL2, VirtualBox présent).
- Dépôt : dépôt public d'infra séparé ; consomme l'image GHCR de PrintBox (privé).
- VM : à trancher (VirtualBox + Ansible depuis WSL2, ou Hyper-V/Multipass).
- Notifications : ntfy. SAST : Semgrep CE.
