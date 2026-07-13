# Developer Workstation

---

# Overview

This document describes the engineering workstation used to develop Project Guardian.

The objective is to make the environment reproducible and easy to rebuild in the future.

---

# Hardware

| Component | Value |
|----------|-------|
| Hostname | infra01 |
| Device | Raspberry Pi 5 |
| RAM | 8 GB |
| Storage | 64 GB microSD |

---

# Operating System

| Item | Value |
|------|-------|
| Distribution | Debian 12 (Bookworm) |
| Kernel | Linux 6.12 |
| Architecture | ARM64 |

---

# Installed Software

- Git
- Docker
- OpenSSH
- NetworkManager

---

# Git

Repository

project-guardian

Location

/home/dani/Projects/project-guardian

Authentication

SSH Keys

---

# Networking

IP Address

192.168.68.50

Gateway

192.168.68.1

DNS

1.1.1.1

1.0.0.1

---

# SSH

Remote access enabled

GitHub authentication configured

---

# Last Updated

July 2026


---

# Updated - July 12th @ 16:33 CET

---

# Developer Workstation

## Purpose

This document describes the host and development environment used to build and operate Project Guardian.

The objective is to keep the environment reproducible, maintainable and easy to rebuild.

---

## Host Information

| Component | Value |
|---|---|
| Hostname | `infra01` |
| Hardware | Raspberry Pi 5 |
| Memory | 8 GB |
| Storage | 64 GB microSD |
| Operating System | Debian GNU/Linux 12 Bookworm |
| Architecture | ARM64 |
| Network interface | `wlan0` |
| Static IPv4 address | `192.168.68.50/22` |
| Default gateway | `192.168.68.1` |
| DNS resolvers | `1.1.1.1`, `1.0.0.1` |

---

## Core Software

| Component | Purpose |
|---|---|
| OpenSSH | Remote administration from macOS |
| Git | Version control |
| Docker Engine | Container runtime |
| Docker Compose | Declarative multi-container deployment |
| NetworkManager | Host network configuration |

---

## Remote Administration

The host is administered remotely from macOS using SSH.

The macOS SSH client uses a host alias:

```sshconfig
Host infra01
    HostName 192.168.68.50
    User dani
