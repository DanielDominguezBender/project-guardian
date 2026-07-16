# 🛡️ Project Guardian

> Building a secure, containerized home infrastructure platform inspired by enterprise infrastructure engineering.

---

## 1. Vision

Project Guardian aims to transform a Raspberry Pi 5 into a production-inspired infrastructure platform that combines security, observability, containerization and operational best practices.

Rather than focusing on installing individual applications, the project emphasizes understanding, designing and documenting every component of the infrastructure.

Every technology deployed must solve a real problem and every architectural decision must be justified.

---

## 2. Mission

Design, build and maintain a secure home infrastructure platform that follows professional engineering practices while serving as a continuous learning environment.

The project will evolve incrementally, with each phase introducing new technologies only after their purpose and design have been fully understood.

---

## 3. Project Goals

- Build a stable and reproducible infrastructure.
- Learn modern Infrastructure Engineering practices.
- Understand every deployed technology before using it.
- Follow Infrastructure as Code principles whenever possible.
- Create a professional portfolio project.
- Document every architectural decision.
- Improve Linux, Docker, Networking and Cybersecurity skills.

---

## 4. Engineering Principles

Project Guardian follows six engineering principles.

### Understand before deploying

No technology is deployed without first understanding the problem it solves, how it works internally, its limitations and available alternatives.

### Security by Design

Security is considered from the beginning of every implementation instead of being added afterwards.

### Documentation First

Documentation is treated as part of the project, not as an afterthought.

### Container First

Whenever possible, every service will run inside Docker containers to improve portability, isolation and maintainability.

### Recoverability

The platform must be easy to restore after hardware or software failures.

### Continuous Improvement

The project is designed as a long-term learning platform rather than a one-time deployment.

---

## 5. Scope

### Included

- Raspberry Pi Infrastructure
- Docker Engine
- Docker Compose
- Persistent storage using bind mounts
- Backup and restore procedures
- Disaster Recovery testing
- Operations runbooks
- Architecture Decision Records
- Cloudflared
- Portainer
- Uptime Kuma
- Watchtower
- Documentation
- Architecture diagrams

### Not Included

- Kubernetes
- High Availability
- Multi-node clustering
- Enterprise authentication
- Cloud deployment

These technologies may be considered in future versions.

---

## 6. Technical Stack

| Layer | Technology |
|---|---|
| Hardware | Raspberry Pi 5 |
| Operating System | Raspberry Pi OS Bookworm |
| Remote Administration | OpenSSH |
| Container Platform | Docker Engine |
| Service Definition | Docker Compose |
| DNS Filtering | Pi-hole |
| Secure DNS | Cloudflared — planned |
| Persistent Storage | Docker bind mounts |
| Data Storage | SQLite |
| Automation | Bash |
| Container Management | Portainer — planned |
| Monitoring | Uptime Kuma — planned |
| Version Control | Git and GitHub |
| Documentation | Markdown and Architecture Decision Records |

---

## 7. Architecture Overview

The platform follows a layered architecture.

Internet

↓

Network

↓

Host Operating System

↓

Docker Engine

↓

Infrastructure Services

Each layer has a single responsibility and can evolve independently.

---

## 8. Roadmap

### Phase 0 — Project Design ✅

- Define project vision, scope and engineering principles.
- Create the initial repository structure.
- Establish documentation and commit conventions.

### Phase 1 — Infrastructure Foundation ✅

- Prepare the Raspberry Pi host.
- Configure static networking.
- Configure SSH administration.
- Configure Git and GitHub authentication.

### Phase 2 — Container Platform ✅

- Install Docker Engine.
- Install Docker Compose.
- Define persistent storage.
- Validate the container lifecycle.

### Phase 3 — DNS Filtering Platform ✅

- Deploy Pi-hole.
- Configure DNS filtering.
- Inspect Gravity and SQLite databases.
- Add and validate subscribed blocklists.
- Document DNS-level filtering limitations.

### Phase 4 — Operations and Recoverability 🔄

- Define the backup strategy.
- Implement the Pi-hole backup script.
- Document backup and restore procedures.
- Validate container-loss recovery.
- Validate backup restoration.
- Automate scheduled backups.
- Define backup retention.

### Phase 5 — Secure DNS and Security Hardening ⏳

- Evaluate Cloudflared and Unbound.
- Select and document the upstream DNS architecture.
- Apply container and host hardening.
- Review secrets management.
- Review least-privilege configuration.

### Phase 6 — Observability ⏳

- Deploy Uptime Kuma.
- Add service health monitoring.
- Define alerting.
- Monitor resource and container availability.

### Phase 7 — Platform Management and Maintenance ⏳

- Evaluate Portainer.
- Define container update procedures.
- Evaluate automatic image updates.
- Document rollback procedures.

### Phase 8 — Portfolio and Final Documentation ⏳

- Complete architecture diagrams.
- Finalize runbooks and ADRs.
- Complete Disaster Recovery reports.
- Improve the repository README.
- Publish the project case study.

---

## 9. Success Criteria

Project Guardian will be considered successful when:

- All suitable infrastructure applications are reproducibly deployed using Docker Compose.
- DNS traffic is filtered and forwarded through a documented DNS architecture.
- Persistent application data is separated from the container lifecycle.
- Critical configuration and operational data are backed up.
- Backup restoration has been successfully validated.
- Disaster Recovery scenarios have been executed and documented.
- Monitoring is available for all critical services.
- Architectural decisions are documented using ADRs.
- Operational procedures are documented through runbooks.
- Secrets and runtime data are excluded from version control.
- The repository allows another engineer to understand and reproduce the platform.

---

## 10. Long-Term Vision

Project Guardian is intended to become the foundation of a personal home lab where new infrastructure services can be integrated following enterprise engineering practices.

The project will continuously evolve while maintaining simplicity, documentation quality and operational reliability.
