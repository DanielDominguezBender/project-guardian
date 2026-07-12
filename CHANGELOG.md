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

### Changed

- Disabled host-level `dnsmasq` to release TCP and UDP port 53.

### Fixed

- Resolved temporary SSH connectivity from macOS.
- Resolved GitHub SSH key selection.
- Resolved temporary DNS resolution failure.
- Resolved Docker socket permission issue.
