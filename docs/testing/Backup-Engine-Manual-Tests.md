# Backup Engine — Manual Test Cases

## Test BE-001 — Bash syntax validation

**Command**

```bash
bash -n scripts/backup-pihole.sh
```

Expected result

Exit code 0.

Result

Passed.

## Test BE-002 — Manifest generation

Expected result

The following file is created inside the staging directory:

metadata/manifest.txt

The file must:

not be empty;
have permissions 600;
contain the backup timestamp;
contain the source hostname;
identify the Pi-hole container and image.

Result

Passed.


## Test BE-003 — Backup archive creation

Expected result

A file matching the following pattern is created:

backups/YYYY-MM-DD/pihole-backup-YYYYMMDD-HHMMSS.tar.gz

Result

Passed.


## Test BE-004 — Required archive contents

Required files

configuration/docker-compose.yml
configuration/.env
data/etc-pihole/gravity.db
metadata/manifest.txt

Result

Passed.


## Test BE-005 — Backup permissions

Expected result

-rw------- 600

Result

Passed.

## Test BE-006 — Temporary archive cleanup

Expected result

No files matching this pattern remain:

.pihole-backup-*

Result

Passed.


## Test BE-007 — Staging cleanup

Expected result

The staging directory from the current execution no longer exists.

Result

Pending validation.
