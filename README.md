# 🛡️ Project Guardian

> Building a secure, containerized home infrastructure platform inspired by enterprise infrastructure engineering.

---

Project Guardian is a long-term infrastructure project built on a Raspberry Pi 5.

Instead of focusing on installing individual services, the goal is to design, deploy, document and maintain a production-inspired home infrastructure following Infrastructure Engineering and DevOps best practices.

Every technology introduced into the platform must answer one simple question:

**Why are we deploying this?**

Understanding the architecture is considered more important than simply making it work.

---

## Blocklist Expansion

Project Guardian initially used the default StevenBlack blocklist.

A second curated blocklist (HaGeZi Multi PRO) was later added.

| Stage | Lists | Gravity Domains |
|--------|------:|----------------:|
| Initial deployment | 1 | 78,451 |
| After HaGeZi | 2 | 312,177 |

Gravity was rebuilt using:

```bash
docker exec guardian-pihole pihole -g
```

---

## Current milestone:

✔ Logging Engine architecture designed.

---
## Roadmap

- [x] Prepare Raspberry Pi host
- [x] Configure static networking
- [x] Configure remote SSH access
- [x] Configure Git and GitHub authentication
- [x] Install Docker Engine
- [x] Install Docker Compose
- [x] Deploy Pi-hole
- [x] Validate Pi-hole web interface
- [ ] Validate DNS filtering from a test client
- [ ] Configure network-wide DNS
- [ ] Deploy encrypted upstream DNS
- [ ] Add container management
- [ ] Add monitoring
- [ ] Implement backup and recovery procedures
- [ ] Apply security hardening
- [ ] Complete architecture documentation
