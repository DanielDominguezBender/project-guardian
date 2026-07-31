# Backup-Validation.md

# Backup Validation

## Purpose

Validate that the generated backup archive is structurally correct before it is considered a valid backup.

This procedure verifies the integrity of the generated archive without extracting its contents or modifying the running Pi-hole service.

---

## Scope

This validation confirms that:

- The backup archive was successfully created.
- The archive is readable.
- Required files are present.
- The embedded manifest identifies the backup correctly.

It does **not** validate that the backup can restore a working Pi-hole instance.

---

## Preconditions

The following conditions must be satisfied:

- Docker is installed.
- The Pi-hole container is running.
- The backup process completed successfully.
- A backup archive has been generated.

---

## Validation Process

The validation performs the following checks:

1. Verify that the backup archive exists.
2. Verify that the archive is a regular file.
3. Verify that the archive is not empty.
4. Verify that the archive is readable.
5. Verify archive integrity using `tar`.
6. Verify the presence of required files:
   - configuration/docker-compose.yml
   - configuration/.env
   - data/etc-pihole/gravity.db
   - metadata/manifest.txt
7. Read the embedded manifest.
8. Verify:
   - Project: Project Guardian
   - Backup-Type: Pi-hole

---

## Expected Result

The script reports:

- Backup archive verification completed
- Exit Code: 0

The backup archive remains available under:

```
backups/YYYY-MM-DD/
```

---

## Failure Scenarios

Validation fails if:

- The archive does not exist.
- The archive is empty.
- The archive is corrupted.
- Required files are missing.
- The manifest is missing.
- The manifest identifies another project.
- The manifest contains an unexpected backup type.

---

## Recovery

Investigate the reported validation error.

Do **not** use the generated archive until the validation succeeds.

---

## Evidence

Recommended evidence:

- Console output
- Archive listing
- Manifest contents
- Successful Exit Code (0)

---

## Engineering Principles

- Never trust a backup until it has been validated.
- Structural validation must happen before cleanup.
- Validation failures must preserve troubleshooting evidence.
