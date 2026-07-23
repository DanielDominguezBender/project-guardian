# Project Guardian 

## Architecture Overview

Project Guardian currently uses a Raspberry Pi 5 as a dedicated infrastructure host named `infra01`.

Pi-hole runs as a Docker container and provides DNS-based filtering for selected devices on the home network.

---

## Logical Architecture

```text
Client device
     |
     | DNS query
     v
infra01 - 192.168.68.50
     |
     | Published TCP/UDP port 53
     v
guardian-pihole container
     |
     | Blocklist lookup in Gravity
     |
     +-- Blocked domain --> Blocking response
     |
     +-- Allowed domain --> Upstream DNS resolver

## Software Architecture

Project Guardian
|
+-- scripts/
|     |
|     +-- backup.sh
|     +-- restore.sh
|     +-- healthcheck.sh
|
+-- lib/
|     |
|     +-- logger.sh
|
+-- docs/
|
+-- compose/

## Startup Flow

backup.sh

↓

Locate PROJECT_ROOT

↓

Locate logger.sh

↓

Validate dependency

↓

Load logger.sh

↓

Execute backup logic

## Container Architecture

infra01
|
+-- Docker Engine
    |
    +-- pihole_default bridge network
        |
        +-- guardian-pihole


## Persistent Storage

The following bind mount is used:

volumes:
  - ./etc-pihole:/etc/pihole

This maps:

Host:
compose/pihole/etc-pihole/

Container:
/etc/pihole/

Both paths expose the same underlying files.

Important persistent data includes:

gravity.db
pihole-FTL.db
Pi-hole configuration
blocklist definitions
allowlist and denylist rules

The container can be recreated independently from its persistent data.

## Design principles

### Modularity

Shared functionality must live inside reusable modules.

### Single Responsibility

Each component has a single responsibility.

Example:

backup.sh

Responsible for backups.

logger.sh

Responsible for logging.

### Dependency validation

Critical dependencies are validated before use.
