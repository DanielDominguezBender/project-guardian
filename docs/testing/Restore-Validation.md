# Restore-Validation.md

# Restore Validation

## Purpose

Validate that a generated backup can be extracted and inspected successfully without modifying the production environment.

This procedure verifies the logical recoverability of the backup.

---

## Scope

This validation confirms that:

- The archive can be extracted.
- Required files survive compression.
- Required files remain readable.
- Required files are not empty.
- The manifest remains valid after extraction.

It does **not** perform a complete disaster recovery.

---

## Preconditions

- Backup archive successfully validated.
- Sufficient disk space available.
- Temporary directory can be created.

---

## Validation Process

1. Create a temporary restore directory.
2. Secure the directory permissions.
3. Extract the archive.
4. Verify required files:
   - configuration/docker-compose.yml
   - configuration/.env
   - data/etc-pihole/gravity.db
   - data/etc-pihole/pihole.toml
   - metadata/manifest.txt
5. Verify every required file:
   - exists
   - is a regular file
   - is readable
   - is not empty
6. Verify manifest contents.
7. Remove the temporary restore directory.

---

## Expected Result

The script reports:

- Restore validation completed
- Restore validation directory removed
- Exit Code: 0

No temporary restore directories remain after successful execution.

---

## Failure Scenarios

Validation fails if:

- Extraction fails.
- Required files are missing.
- Files are unreadable.
- Files are empty.
- Manifest validation fails.
- Temporary directory cannot be created.

---

## Recovery

Review the backup archive.

Investigate the validation logs.

Generate a new backup if required.

---

## Evidence

Recommended evidence:

- Restore directory tree
- Manifest contents
- Console output
- Successful cleanup

---

## Engineering Principles

- A valid archive is not necessarily a recoverable backup.
- Restore validation should never affect production.
- Recovery procedures must always be tested in isolation.
