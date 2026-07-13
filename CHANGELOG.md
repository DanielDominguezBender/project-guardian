# Changelog

All notable changes to Project Guardian will be documented in this file.
## [Unreleased]

### Added

- Prepared Raspberry Pi 5 host as `infra01`.
- Configured static IPv4 networking with NetworkManager.
- Configured remote SSH administration from macOS.
- Configured dedicated ED25519 authentication for GitHub.
- Installed and configured Docker Engine.
- Added Docker Compose-based Pi-hole deployment.
- Added persistent Pi-hole configuration storage.
- Added environment-based secret management.
- Added initial developer workstation documentation.
- Added initial troubleshooting knowledge base.

- Added Architecture documentation.
- Added Operations runbook.
- Added Lessons Learned documentation.
- Added Project Status document.
- Added Gravity database inspection procedures.
- Added SQLite analysis workflow for Pi-hole.
- Added screenshots documenting Pi-hole deployment and Gravity updates.
- Added HaGeZi Multi PRO blocklist evaluation and deployment.

### Changed

- Disabled host-level `dnsmasq` to release TCP and UDP port 53.
- Standardised documentation directory naming using lowercase folders.
- Expanded Pi-hole documentation with operational and architectural guidance.
- Increased DNS filtering coverage by adding a second subscribed blocklist.

### Fixed

- Resolved temporary SSH connectivity from macOS.
- Resolved GitHub SSH key selection.
- Resolved temporary DNS resolution failure.
- Resolved Docker socket permission issue.
- Documented the correct approach for inspecting SQLite databases from the host instead of modifying the running container.
