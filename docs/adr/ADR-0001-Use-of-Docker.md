# ADR-001 — Use Docker Instead of Native Installation

**Status:** Accepted

**Date:** 2026-07-14

---

# Context

Project Guardian requires a DNS filtering service based on Pi-hole.

There are two possible deployment approaches:

1. Native installation directly on Raspberry Pi OS.
2. Deployment using Docker containers.

The project is intended to serve not only as a functional homelab but also as a learning platform focused on Infrastructure Engineering, DevOps and Cloud-native practices.

---

# Decision

Pi-hole will be deployed as a Docker container managed through Docker Compose.

Persistent application data will be stored outside the container using bind mounts.

---

# Rationale

Docker provides several advantages over a native installation.

## Isolation

Pi-hole runs independently from the host operating system.

Application dependencies do not modify the Raspberry Pi installation.

---

## Reproducibility

The complete deployment is described as code.

A new Raspberry Pi can recreate the service using:

```bash
docker-compose up -d
```

without manual installation steps.

---

## Portability

The same deployment can run on:

- Raspberry Pi
- Ubuntu Server
- Debian
- Virtual Machines
- Cloud instances

without modifications.

---

## Maintainability

Containers can be upgraded or replaced independently.

The operating system and the application have independent life cycles.

---

## Disaster Recovery

Configuration is stored using bind mounts.

The container itself is disposable.

If the container is deleted:

- configuration remains
- databases remain
- Pi-hole can be recreated

without losing persistent information.

---

## Learning Objectives

Using Docker supports several learning goals.

- Container lifecycle
- Persistent storage
- Docker Compose
- Infrastructure as Code mindset
- Operational procedures
- Backup and recovery strategies

These concepts are directly applicable to modern Infrastructure and Cloud Engineering roles.

---

# Consequences

## Positive

- Reproducible deployment.
- Easier upgrades.
- Better separation between host and application.
- Simplified recovery.
- Better documentation.
- Real-world operational experience.

---

## Negative

- Additional Docker knowledge required.
- Extra abstraction layer.
- Networking concepts become more complex.
- Container troubleshooting differs from native Linux troubleshooting.

---

# Alternatives Considered

## Native Installation

Advantages

- Simpler initial deployment.
- Slightly lower resource usage.

Disadvantages

- Harder to reproduce.
- Greater dependency on host configuration.
- Less aligned with project learning goals.
- More difficult migration to another host.

---

# Conclusion

Docker was selected because it better supports the project's educational objectives, operational model and long-term maintainability.

The additional complexity introduced by containerization is considered acceptable given the benefits in reproducibility, portability and disaster recovery.


---

## Lessons Learned

This decision was validated during the implementation phase.

Key observations:

- Bind mounts simplified disaster recovery.
- Docker made the deployment reproducible.
- Persistent data remained available after container recreation.
- Git complemented the backup strategy by protecting project configuration and documentation.
