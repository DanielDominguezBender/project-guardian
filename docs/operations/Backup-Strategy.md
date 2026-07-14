# Backup Strategy

## Purpose

This document describes the backup strategy for Project Guardian.

The objective is not to back up the entire Raspberry Pi, but to preserve the information that cannot be easily recreated.

The guiding principle is:

> Back up knowledge and configuration, not software.

---

# Recovery Objectives

If the Raspberry Pi fails completely, the objective is to rebuild the service on a new host with minimal manual work.

A successful recovery should restore:

- Pi-hole configuration
- DNS settings
- Custom blocklists
- Local DNS records
- Docker deployment
- Project documentation

without having to recreate the service manually.

---

# Backup Classification

## Category A — Rebuild

These components do not require backups because they can be installed again.

- Raspberry Pi OS
- Docker Engine
- Docker Compose
- Git
- SQLite
- Docker images

Recovery method:

Fresh installation.

---

## Category B — Version Controlled

These files are already protected by GitHub.

- README
- PROJECT.md
- CHANGELOG.md
- docker-compose.yml
- scripts
- documentation
- diagrams

Recovery method:

git clone

---

## Category C — Persistent Service Data

These files contain the operational state of Pi-hole.

Examples:

- gravity.db
- pihole-FTL.db
- custom.list
- local DNS records
- whitelist
- blacklist
- groups
- clients
- Pi-hole configuration

Recovery method:

Restore from backup.

---

# What Must Be Backed Up

## Critical

- /etc/pihole/

Reason:

Contains all Pi-hole configuration.

---

## Recommended

- .env

Reason:

Contains secrets and deployment-specific configuration.

---

## Optional

- pihole-FTL.db

Reason:

Stores historical statistics.

Losing this database does not affect service availability.

---

## Not Required

The following components do not require backups.

- Docker images
- Linux packages
- Gravity downloads

Reason:

They can be recreated automatically.

---

# Recovery Strategy

Recovery consists of the following phases.

1. Install Raspberry Pi OS.
2. Install Docker.
3. Clone Project Guardian.
4. Restore the Pi-hole configuration.
5. Start Docker Compose.
6. Validate DNS resolution.
7. Rebuild Gravity if necessary.

---

# Backup Frequency

| Item | Frequency |
|-------|-----------|
| Pi-hole configuration | Weekly |
| .env | After every change |
| Git repository | Every commit |

---

# Validation

A backup is only considered valid if it can be restored successfully on a new host.

Periodic restore testing is recommended.

---

# Future Improvements

- Automated backups
- Scheduled backups
- Remote backup destination
- Versioned backups
- Encryption
- Restore testing
