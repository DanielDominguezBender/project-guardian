# Project Status

## Current Status

**Project:** Project Guardian  
**Host:** `infra01`  
**Status:** In progress  
**Current phase:** Pi-hole deployment and DNS filtering validation  
**Last updated:** 13 July 2026

---

## Completed

- Raspberry Pi 5 prepared as infrastructure host.
- Raspberry Pi OS updated.
- Hostname configured as `infra01`.
- Static IPv4 address configured.
- Remote SSH administration configured from macOS.
- Git and GitHub SSH authentication configured.
- Docker Engine installed and validated.
- Docker Compose installed.
- Pi-hole deployed as a Docker container.
- Persistent Pi-hole storage configured with a bind mount.
- Pi-hole web interface validated.
- DNS resolution tested from macOS.
- StevenBlack blocklist inspected through `gravity.db`.
- HaGeZi Multi PRO added as an additional blocklist.
- Gravity database rebuilt and validated.

---

## Current Architecture

```text
Internet
   |
Upstream DNS
   |
Pi-hole container
   |
Docker bridge network
   |
infra01 - 192.168.68.50
   |
Home network clients


## Pi-hole Baseline

Before adding HaGeZi Multi PRO:

Blocklist sources: 1
Primary list: StevenBlack
Gravity domains: 78,451

After adding HaGeZi Multi PRO:

Blocklist sources: 2
Gravity domains: approximately 200,000
Exact value: pending final database validation
Issues Resolved
SSH connection refused from macOS.
GitHub SSH public-key authentication failure.
Temporary DNS name-resolution failure.
Port 53 conflict caused by host-level dnsmasq.
Docker socket permission denied.
Missing diagnostic tools inside the Pi-hole container.


## Key Lessons
A Docker container and its persistent data have different lifecycles.
Bind mounts expose the same host files inside the container; they do not copy them.
Containers should remain reproducible and should not be manually modified for routine diagnostics.
Gravity stores blocklist data in SQLite.
Pi-hole blocks at DNS level and does not replace browser-level content filtering.


## Next Steps
Validate the exact domain count after the HaGeZi update.
Test normal browsing and identify false positives.
Document allowlist and denylist procedures.
Define the Pi-hole backup and recovery strategy.
Improve the README and architecture diagram.
