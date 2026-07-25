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

This allows remote access with:

ssh infra01
Git Configuration

Git is configured globally on infra01 with:

git config --global user.name "Daniel Dominguez Bender"
git config --global user.email "<GITHUB_EMAIL>"
git config --global init.defaultBranch main
git config --global pull.rebase false

Project repository:

/home/dani/Projects/project-guardian

GitHub authentication uses a dedicated ED25519 SSH key:

~/.ssh/id_ed25519_infra01

The SSH client explicitly selects this identity for GitHub:

Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_infra01
    IdentitiesOnly yes
Docker Access

The user dani belongs to the docker group and can manage containers without using sudo.

Validation:

groups
docker ps

Membership in the docker group provides elevated privileges and should be restricted to trusted administrators.

Installed CLI Tools

The following tools were installed from the official Debian repositories:

bat
btop
fzf
ripgrep
fd-find
tldr
tree
curl
wget
unzip
jq

Additional terminal customization has been deferred until the core platform is complete.

Current Infrastructure Service

Pi-hole is deployed as a Docker container:

Container: guardian-pihole
Image: pihole/pihole
Compose path: compose/pihole/
Web interface: http://192.168.68.50/admin/
DNS endpoint: 192.168.68.50:53
Validation Commands
docker ps
docker-compose ps
docker-compose logs --tail=100 pihole
sudo ss -tulpn | grep -E ':(53|80|443)\b'
