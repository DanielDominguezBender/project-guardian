# Project Guardian

> Production-oriented Backup & Recovery Framework for Containerized Raspberry Pi Infrastructure

---

## Overview

Project Guardian is an Infrastructure Engineering project designed to demonstrate how to build reliable backup and recovery workflows for containerized services running on Raspberry Pi.

Rather than focusing on deploying applications, the project focuses on applying engineering principles to infrastructure automation, validation, documentation and operational reliability.

Pi-hole is used as the production-like workload that drives the implementation.

---

## Why This Project Exists

Most home lab projects stop once the service is running.

Project Guardian takes a different approach.

The objective is to design infrastructure that can be:

- understood
- maintained
- validated
- recovered
- documented

using engineering practices commonly found in enterprise environments.

Every technical decision answers one simple question:

> **Why are we implementing this?**

Understanding the system is considered more important than simply making it work.

---

## Current Capabilities

The current implementation provides:

- Modular Bash architecture
- Reusable logging framework
- Environment validation
- Backup staging
- Manifest generation
- Compressed archive creation
- Archive verification
- Restore validation
- Automatic cleanup of temporary resources
- Engineering documentation
- Architectural Decision Records (ADRs)

---

## Architecture

Project Guardian is composed of several independent engineering components.

```
Infrastructure
        │
        ▼
 Raspberry Pi 5 (infra01)
        │
        ▼
 Docker Engine
        │
        ▼
 guardian-pihole
        │
        ▼
 Persistent Data
```

```
Engineering Components

Logger

↓

Environment Validation

↓

Backup Engine

↓

Archive Verification

↓

Restore Validation

↓

Cleanup
```

Detailed documentation is available under:

```
docs/architecture/
```

---

## Backup & Recovery Workflow

The backup pipeline currently performs the following stages:

```
validate_environment()

↓

create_backup_directory()

↓

prepare_backup_contents()

↓

create_backup_manifest()

↓

create_backup_archive()

↓

verify_backup_archive()

↓

validate_restored_contents()

↓

cleanup_restore_environment()

↓

cleanup_staging()
```

Each stage validates the output of the previous stage before allowing the workflow to continue.

---

## Engineering Principles

Project Guardian follows a growing collection of engineering principles that document the reasoning behind every architectural decision.

Topics include:

- modular design
- single responsibility
- reusable components
- defensive programming
- validation-first approach
- operational reliability
- deterministic workflows

See:

```
ENGINEERING_PRINCIPLES.md
```

---

## Repository Structure

```
project-guardian/

├── backups/
├── compose/
├── diagrams/
├── docs/
│   ├── ADR/
│   ├── architecture/
│   ├── installation/
│   ├── operations/
│   ├── security/
│   ├── sessions/
│   ├── testing/
│   └── troubleshooting/
├── lib/
├── scripts/
├── screenshots/
├── CHANGELOG.md
├── PROJECT.md
└── README.md
```

---

## Current Status

### Completed

- Raspberry Pi host preparation
- Docker deployment
- Pi-hole deployment
- Logging framework
- Backup engine
- Archive verification
- Restore validation
- Temporary resource cleanup
- Backup documentation
- Engineering documentation

### In Progress

- Disaster Recovery

### Planned

- Automatic restore procedure
- Backup scheduling
- Monitoring integration
- Infrastructure hardening
- Continuous validation
- Network-wide deployment
- Secure upstream DNS

---

## Documentation

The repository includes dedicated documentation covering:

- Architecture
- Engineering Principles
- Architectural Decision Records
- Installation
- Operations
- Security
- Testing
- Troubleshooting
- Session journal
- Project roadmap
- Change history

---

## Lessons Learned

Project Guardian is not intended to demonstrate how to install Pi-hole.

It demonstrates how to engineer reliable infrastructure around a production service.

The project prioritizes:

- maintainability
- validation
- recoverability
- documentation
- operational discipline

over feature count.

---

## Roadmap

The next major milestone is implementing a complete Disaster Recovery workflow capable of rebuilding the service from a validated backup.

Future work will also include infrastructure monitoring, scheduled backups, security hardening and additional engineering automation.

---

## License

This project is released under the MIT License.
