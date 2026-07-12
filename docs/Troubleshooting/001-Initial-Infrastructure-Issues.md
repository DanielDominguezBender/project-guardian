# Initial Infrastructure Issues

This document records the first operational issues encountered while preparing `infra01` and deploying Pi-hole.

---

## Issue 1 — SSH Connection Refused from macOS

### Symptoms

The Mac could ping `192.168.68.50`, but SSH and TCP port tests returned:

```text
ssh: connect to host 192.168.68.50 port 22: Connection refused

### Validation Performed

sudo systemctl status ssh
sudo sshd -t
sudo ss -tlnp | grep ':22'
sudo lsof -i :22
sudo journalctl -u ssh -n 30 --no-pager
sudo tcpdump -i wlan0 port 22

The SSH service was active and listening on port 22.

### Resolution

The Wi-Fi interface on macOS was disconnected and reconnected. SSH connectivity was then restored.

### Root Cause Status

The exact root cause was not conclusively proven.

The most likely cause was stale or inconsistent network state on the macOS Wi-Fi interface.

### Lesson Learned

Differentiate between a confirmed root cause and a probable cause. Validate the server, port and network path before changing service configuration.

---

## Issue 2 — GitHub SSH Authentication Failed

Symptoms
git@github.com: Permission denied (publickey)

### Cause

The dedicated SSH key used a non-default filename:

~/.ssh/id_ed25519_infra01

SSH did not automatically select it.

### Resolution

Created ~/.ssh/config:

Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_infra01
    IdentitiesOnly yes
Validation
ssh -T git@github.com

Successful response:

Hi DanielDominguezBender! You've successfully authenticated...
Issue 3 — Temporary DNS Resolution Failure
Symptoms
ssh: Could not resolve hostname github.com:
Temporary failure in name resolution
Validation
ping -c 4 1.1.1.1
getent hosts github.com
cat /etc/resolv.conf
nmcli device show wlan0

Internet connectivity worked, but name resolution temporarily failed.

### Resolution

Restarted NetworkManager:

sudo systemctl restart NetworkManager

The SSH session was interrupted, as expected, and DNS resolution worked after reconnecting.

### Lesson Learned

A successful IP ping does not prove DNS is working. Test connectivity and name resolution independently.

---

## Issue 4 — Port 53 Already in Use

Symptoms

Port inspection showed:

dnsmasq

listening on TCP and UDP port 53.

### Cause

The host-level dnsmasq service was enabled and conflicted with the DNS ports required by Pi-hole.

Resolution
sudo systemctl stop dnsmasq
sudo systemctl disable dnsmasq

The service was not uninstalled, allowing rollback if needed.

### Validation
sudo ss -tulpn | grep -E ':(53|80|443)\b'

Port 5353 remained in use by Avahi, which is mDNS and does not conflict with DNS port 53.

---

## Issue 5 — Docker Compose Permission Denied

### Symptoms

PermissionError: [Errno 13] Permission denied

Docker Compose could parse the YAML but could not access the Docker daemon.

### Cause

User dani was not a member of the docker group and therefore could not access:

/var/run/docker.sock
Resolution
sudo usermod -aG docker dani

The SSH session was closed and reopened so the new group membership could take effect.

Validation
groups
id
docker ps

### Security Note

Membership in the docker group grants privileges comparable to administrative access and must be limited to trusted users.
