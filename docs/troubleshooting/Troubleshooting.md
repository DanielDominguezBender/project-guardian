# Troubleshooting

## SSH Connection Refused from macOS

### Symptom

```text
ssh: connect to host 192.168.68.50 port 22: Connection refused
```

## Investigation

SSH service was active.
Port 22 was listening.
Local SSH tests succeeded.
The Raspberry Pi responded to ping.

## Resolution

The macOS Wi-Fi interface was disconnected and reconnected.

## Root Cause

Not conclusively proven. The most likely cause was stale network state on the macOS Wi-Fi interface.

---

## GitHub SSH Permission Denied

### Symptom

git@github.com: Permission denied (publickey)

### Cause

The SSH key used a non-default filename and was not automatically selected.

### Resolution

Configured ~/.ssh/config:

````sshconfig
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_infra01
    IdentitiesOnly yes
```

---

## Port 53 Already in Use

### Cause

The host-level dnsmasq service occupied DNS port 53.

### Resolution

```bash
sudo systemctl stop dnsmasq
sudo systemctl disable dnsmasq
```
---

## Docker Permission Denied

### Symptom

PermissionError: [Errno 13] Permission denied

### Cause

User dani was not a member of the docker group.

### Resolution

```bash
sudo usermod -aG docker dani
```

The SSH session was closed and reopened.

---

## Diagnostic Commands Missing Inside Container

### Symptoms

```text
bash: file: command not found
bash: sqlite3: command not found
```

### Explanation

The Pi-hole image is intentionally minimal.

### Resolution

Installed diagnostic tools on infra01 and inspected the bind-mounted databases from the host:

```bash
sudo apt install file sqlite3 -y
```
