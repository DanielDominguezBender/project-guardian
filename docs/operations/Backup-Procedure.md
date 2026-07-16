# Pi-hole Backup Procedure

## Purpose

This runbook describes how to create and validate a consistent backup of the persistent Pi-hole configuration used by Project Guardian.

The initial implementation uses a cold-backup approach: the Pi-hole container is stopped briefly while the persistent data is archived.

---

## Backup Scope

The backup includes:

- `compose/pihole/etc-pihole/`
- `compose/pihole/.env`

The backup does not include:

- Docker images
- Docker Engine
- Raspberry Pi OS
- Git-controlled documentation and source files
- Screenshots
- Installed host packages

---

## Expected Output

Each execution creates one compressed archive:

```text
backups/YYYY-MM-DD/
└── project-guardian-pihole-backup-YYYY-MM-DD_HH-MM-SS.tar.gz
```

Example:

```text
backups/2026-07-16/
└── project-guardian-pihole-backup-2026-07-16_19-45-30.tar.gz
```

---

## Preconditions

Before starting:

- `infra01` must be accessible.
- Docker Engine must be running.
- The `guardian-pihole` container should be healthy.
- The persistent Pi-hole directory must exist.
- The `.env` file must exist.
- Sufficient storage space must be available.

Validation commands:

```bash
docker ps
test -d compose/pihole/etc-pihole
test -f compose/pihole/.env
df -h
```

---

## Backup Procedure

### 1. Navigate to the repository

```bash
cd ~/Projects/project-guardian
```

### 2. Confirm Pi-hole status

```bash
docker ps --filter name=guardian-pihole
```

### 3. Stop Pi-hole cleanly

```bash
docker stop guardian-pihole
```

### 4. Create the backup archive

This operation will be performed by:

```bash
./scripts/backup-pihole.sh
```

The script must archive the persistent Pi-hole data and the private `.env` file.

### 5. Restart Pi-hole

```bash
docker-compose \
  -f compose/pihole/docker-compose.yml \
  --env-file compose/pihole/.env \
  up -d
```

### 6. Wait for a healthy state

```bash
docker ps --filter name=guardian-pihole
```

### 7. Validate DNS resolution

From a client:

```bash
dig google.com @192.168.68.50
```

### 8. Validate domain blocking

```bash
docker exec guardian-pihole pihole -q doubleclick.net
```

### 9. Validate the dashboard

Open:

```text
http://192.168.68.50/admin/
```

---

## Backup Validation

A backup is not considered successful only because the archive exists.

Verify that it:

- exists;
- is not empty;
- is recognized as a valid gzip archive;
- can be listed without extraction;
- contains `etc-pihole/`;
- contains `.env`.

Example checks:

```bash
ls -lh backups/YYYY-MM-DD/

file backups/YYYY-MM-DD/project-guardian-pihole-backup-*.tar.gz

tar -tzf backups/YYYY-MM-DD/project-guardian-pihole-backup-*.tar.gz
```

---

## Failure Handling

If archive creation fails:

1. Record the error.
2. Do not delete any existing backup.
3. Restart Pi-hole immediately.
4. Confirm DNS resolution.
5. Investigate the cause before retrying.

The backup script must attempt to restart Pi-hole even if archive creation fails.

---

## Security Considerations

The archive contains `.env` and may therefore contain secrets.

Backup archives must:

- never be committed to Git;
- have restrictive filesystem permissions;
- be stored only in trusted locations;
- be encrypted before being copied to external or remote storage.

---

## Current Limitations

- Execution is manual.
- Pi-hole is temporarily unavailable during backup.
- Backups currently remain on the same Raspberry Pi.
- Retention and rotation are not yet automated.
- Restore validation will be covered by DR-003.
