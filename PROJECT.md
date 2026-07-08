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
- Pi-hole
- Cloudflared
- Portainer
- Uptime Kuma
- Watchtower
- Documentation
- Architecture Diagrams
- Backup Strategy

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
|--------|------------|
| Hardware | Raspberry Pi 5 |
| Operating System | Raspberry Pi OS Bookworm |
| Container Platform | Docker |
| Container Orchestration | Docker Compose |
| DNS Filtering | Pi-hole |
| Secure DNS | Cloudflared |
| Container Management | Portainer |
| Monitoring | Uptime Kuma |
| Version Control | Git & GitHub |

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

Phase 0 — Project Design

Phase 1 — Infrastructure Foundation

Phase 2 — Container Platform

Phase 3 — DNS Platform

Phase 4 — Observability

Phase 5 — Operations

Phase 6 — Security Enhancements

Phase 7 — Portfolio & Documentation

---

## 9. Success Criteria

Project Guardian will be considered successful when:

- Every service runs inside Docker.
- DNS traffic is securely filtered.
- Documentation covers every architectural decision.
- The entire platform can be restored from backups.
- Monitoring is available for all critical services.
- The repository can be used by others to reproduce the deployment.

---

## 10. Long-Term Vision

Project Guardian is intended to become the foundation of a personal home lab where new infrastructure services can be integrated following enterprise engineering practices.

The project will continuously evolve while maintaining simplicity, documentation quality and operational reliability.
