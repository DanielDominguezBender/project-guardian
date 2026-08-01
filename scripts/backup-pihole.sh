#!/usr/bin/env bash

# 1. Shell configuration

set -Eeuo pipefail

# =============================================================================
# Project Guardian - Pi-hole Backup Tool
# =============================================================================

# 2. Constants and paths

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

LOGGER_PATH="$PROJECT_ROOT/lib/logger.sh"

if [[ ! -r "$LOGGER_PATH" ]]; then
	printf 'ERROR: required logging module is not readable: %s\n' "$LOGGER_PATH" >&2
	exit 1
fi

# shellcheck source=../lib/logger.sh
source "$LOGGER_PATH"

if ! declare -F log_message >/dev/null; then
	printf 'ERROR: logging module does not provide log_message().\n' >&2
	exit 1
fi

CONTAINER_NAME="${CONTAINER_NAME:-guardian-pihole}"
PIHOLE_STOPPED=false

COMPOSE_FILE="${COMPOSE_FILE:-$PROJECT_ROOT/compose/pihole/docker-compose.yml}"
ENV_FILE="${ENV_FILE:-$PROJECT_ROOT/compose/pihole/.env}"
PIHOLE_DATA_DIR="${PIHOLE_DATA_DIR:-$PROJECT_ROOT/compose/pihole/etc-pihole}"
BACKUP_ROOT="${BACKUP_ROOT:-$PROJECT_ROOT/backups}"

BACKUP_DATE=""
TIMESTAMP=""
BACKUP_DIR=""
BACKUP_FILE=""
STAGING_DIR=""
MANIFEST_FILE=""

RESTORE_TEST_DIR=""

# 3. Functions

validate_environment() {
    log_message INFO "Validating backup environment"

    if ! command -v docker >/dev/null 2>&1; then
        log_message ERROR \
            "Required command not found: docker" >&2
        return 1
    fi

    if ! command -v tar >/dev/null 2>&1; then
        log_message ERROR \
            "Required command not found: tar" >&2
        return 1
    fi

    log_message INFO "Required commands are available"

    if [[ ! -r "$COMPOSE_FILE" ]]; then
        log_message ERROR \
            "Compose file is not readable: $COMPOSE_FILE" >&2
        return 1
    fi

    if [[ ! -r "$ENV_FILE" ]]; then
        log_message ERROR \
            "Environment file is not readable: $ENV_FILE" >&2
        return 1
    fi

    if [[ ! -d "$PIHOLE_DATA_DIR" ]]; then
        log_message ERROR \
            "Pi-hole data directory does not exist: $PIHOLE_DATA_DIR" >&2
        return 1
    fi

    if [[ ! -r "$PIHOLE_DATA_DIR" ]]; then
        log_message ERROR \
            "Pi-hole data directory is not readable: $PIHOLE_DATA_DIR" >&2
        return 1
    fi

    if [[ ! -d "$BACKUP_ROOT" ]]; then
        log_message ERROR \
            "Backup root directory does not exist: $BACKUP_ROOT" >&2
        return 1
    fi

    if [[ ! -w "$BACKUP_ROOT" ]]; then
        log_message ERROR \
            "Backup root directory is not writable: $BACKUP_ROOT" >&2
        return 1
    fi

    log_message INFO "Required files and directories are available"

    if ! docker inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
   	    log_message ERROR \ 
            "Pi-hole container does not exist: $CONTAINER_NAME" >&2
    	return 1
    fi

    local container_running

    if ! container_running="$(
    	docker inspect \
        	--format '{{.State.Running}}' \
       		 "$CONTAINER_NAME"
    )"; then
    	log_message ERROR \
            "Unable to inspect Pi-hole container state: $CONTAINER_NAME" >&2
    	return 1
    fi

    if [[ "$container_running" != "true" ]]; then
    	log_message ERROR \
            "Pi-hole container is not running: $CONTAINER_NAME" >&2
   	 return 1
    fi

    log_message INFO \
        "Pi-hole container is available and running"

    return 0
}

create_backup_directory() {
    log_message INFO \
        "Preparing backup destination"

    if ! TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"; then
        log_message ERROR "Unable to generate backup timestamp" >&2
        return 1
    fi

    BACKUP_DATE="${TIMESTAMP:0:4}-${TIMESTAMP:4:2}-${TIMESTAMP:6:2}"
    BACKUP_DIR="$BACKUP_ROOT/$BACKUP_DATE"
    BACKUP_FILE="$BACKUP_DIR/pihole-backup-$TIMESTAMP.tar.gz"

    if ! mkdir -p "$BACKUP_DIR"; then
        log_message ERROR \
            "Unable to create backup directory: $BACKUP_DIR" >&2
        return 1
    fi

    if [[ ! -d "$BACKUP_DIR" ]]; then
        log_message ERROR \
            "Backup destination is not a directory: $BACKUP_DIR" >&2
        return 1
    fi

    if [[ ! -w "$BACKUP_DIR" ]]; then
        log_message ERROR \
            "Backup directory is not writable: $BACKUP_DIR" >&2
        return 1
    fi

    if [[ -e "$BACKUP_FILE" ]]; then
        log_message ERROR \
            "Backup file already exists: $BACKUP_FILE" >&2
        return 1
    fi

    log_message INFO "Backup directory ready: $BACKUP_DIR"
    log_message INFO "Backup file path prepared: $BACKUP_FILE"

    return 0
}

prepare_backup_contents() {
    log_message INFO "Preparing backup contents"

    if ! STAGING_DIR="$(
        mktemp -d \
            "${TMPDIR:-/tmp}/project-guardian-${TIMESTAMP}-XXXXXX"
    )"; then
        log_message ERROR \
            "Unable to create temporary staging directory" >&2
        return 1
    fi

    if ! chmod 700 "$STAGING_DIR"; then
        log_message ERROR \
            "Unable to secure staging directory: $STAGING_DIR" >&2
        return 1
    fi

    if ! mkdir -p \
        "$STAGING_DIR/data" \
        "$STAGING_DIR/configuration" \
        "$STAGING_DIR/metadata"; then
        log_message ERROR \
            "Unable to create staging directory structure" >&2
        return 1
    fi

    if ! cp -a \
        "$PIHOLE_DATA_DIR" \
        "$STAGING_DIR/data/"; then
        log_message ERROR \
            "Unable to copy Pi-hole application data" >&2
        return 1
    fi

    if ! cp \
        "$COMPOSE_FILE" \
        "$STAGING_DIR/configuration/docker-compose.yml"; then
        log_message ERROR \
            "Unable to copy Docker Compose configuration" >&2
        return 1
    fi

    if ! cp \
        "$ENV_FILE" \
        "$STAGING_DIR/configuration/.env"; then
        log_message ERROR \
            "Unable to copy environment configuration" >&2
        return 1
    fi

    log_message INFO "Backup contents prepared: $STAGING_DIR"

    return 0
}

create_backup_manifest() {
    log_message INFO "Creating backup manifest"

    if [[ -z "$STAGING_DIR" ]]; then
        log_message ERROR \
            "Staging directory has not been initialized" >&2
        return 1
    fi

    if [[ ! -d "$STAGING_DIR/metadata" ]]; then
        log_message ERROR \
            "Metadata directory does not exist: $STAGING_DIR/metadata" >&2
        return 1
    fi

    MANIFEST_FILE="$STAGING_DIR/metadata/manifest.txt"

    local created_at
    local source_host
    local container_image
    local archive_name
    local temporary_manifest

    created_at="$(date --iso-8601=seconds)"
    source_host="$(hostname)"
    archive_name="$(basename "$BACKUP_FILE")"

    if ! container_image="$(
        docker inspect \
            --format '{{.Config.Image}}' \
            "$CONTAINER_NAME"
    )"; then
        log_message ERROR \
            "Unable to determine container image: $CONTAINER_NAME" >&2
        return 1
    fi

    if ! temporary_manifest="$(
        mktemp "$STAGING_DIR/metadata/.manifest.XXXXXX"
    )"; then
        log_message ERROR \
            "Unable to create temporary manifest file" >&2
        return 1
    fi

    if ! chmod 600 "$temporary_manifest"; then
        log_message ERROR \
            "Unable to secure temporary manifest file" >&2
        rm -f "$temporary_manifest"
        return 1
    fi

    if ! cat > "$temporary_manifest" <<EOF
Manifest-Version: 1
Project: Project Guardian
Backup-Type: Pi-hole

Created-At: $created_at
Backup-Timestamp: $TIMESTAMP
Source-Host: $source_host

Container-Name: $CONTAINER_NAME
Container-Image: $container_image
Consistency-Mode: live-copy

Archive-Filename: $archive_name

Data-Path: data/etc-pihole
Compose-File: configuration/docker-compose.yml
Environment-File: configuration/.env
EOF
    then
        log_message ERROR \
            "Unable to write backup manifest" >&2
        rm -f "$temporary_manifest"
        return 1
    fi

    if [[ ! -s "$temporary_manifest" ]]; then
        log_message ERROR \
            "Generated backup manifest is empty" >&2
        rm -f "$temporary_manifest"
        return 1
    fi

    if ! mv "$temporary_manifest" "$MANIFEST_FILE"; then
        log_message ERROR \
            "Unable to publish backup manifest" >&2
        rm -f "$temporary_manifest"
        return 1
    fi

    log_message INFO \
        "Backup manifest created: $MANIFEST_FILE"

    return 0
}

create_backup_archive() {
    log_message INFO "Creating backup archive"

    if [[ -z "$STAGING_DIR" ]]; then
        log_message ERROR \
            "Staging directory has not been initialized" >&2
        return 1
    fi

    if [[ ! -d "$STAGING_DIR" ]]; then
        log_message ERROR \
            "Staging directory does not exist: $STAGING_DIR" >&2
        return 1
    fi

    if [[ -z "$BACKUP_FILE" ]]; then
        log_message ERROR \
            "Backup file path has not been initialized" >&2
        return 1
    fi

    if [[ -e "$BACKUP_FILE" ]]; then
        log_message ERROR \
            "Backup file already exists: $BACKUP_FILE" >&2
        return 1
    fi

    local temporary_archive

    if ! temporary_archive="$(
        mktemp \
            "$BACKUP_DIR/.pihole-backup-${TIMESTAMP}.XXXXXX.tar.gz"
    )"; then
        log_message ERROR \
            "Unable to create temporary backup archive" >&2
        return 1
    fi

    if ! tar \
        -C "$STAGING_DIR" \
        -czf "$temporary_archive" \
        configuration \
        data \
        metadata; then
        log_message ERROR \
            "Unable to create compressed backup archive" >&2
        rm -f "$temporary_archive"
        return 1
    fi

    if [[ ! -s "$temporary_archive" ]]; then
        log_message ERROR \
            "Generated backup archive is empty" >&2
        rm -f "$temporary_archive"
        return 1
    fi

    if ! tar -tzf "$temporary_archive" >/dev/null 2>&1; then
        log_message ERROR \
            "Generated backup archive failed integrity validation" >&2
        rm -f "$temporary_archive"
        return 1
    fi

    if ! chmod 600 "$temporary_archive"; then
        log_message ERROR \
            "Unable to secure temporary backup archive" >&2
        rm -f "$temporary_archive"
        return 1
    fi

    if ! mv "$temporary_archive" "$BACKUP_FILE"; then
        log_message ERROR \
            "Unable to publish backup archive: $BACKUP_FILE" >&2
        rm -f "$temporary_archive"
        return 1
    fi

    log_message INFO \
        "Backup archive created: $BACKUP_FILE"

    return 0
}

verify_backup_archive() {
    log_message INFO "Verifying backup archive"

    if [[ -z "$BACKUP_FILE" ]]; then
        log_message ERROR \
            "Backup file path has not been initialized" >&2
        return 1
    fi

    if [[ ! -e "$BACKUP_FILE" ]]; then
        log_message ERROR \
            "Backup archive does not exist: $BACKUP_FILE" >&2
        return 1
    fi

    if [[ ! -f "$BACKUP_FILE" ]]; then
        log_message ERROR \
            "Backup archive path is not a regular file: $BACKUP_FILE" >&2
        return 1
    fi

    if [[ ! -s "$BACKUP_FILE" ]]; then
        log_message ERROR \
            "Backup archive is empty: $BACKUP_FILE" >&2
        return 1
    fi

    if [[ ! -r "$BACKUP_FILE" ]]; then
        log_message ERROR \
            "Backup archive is not readable: $BACKUP_FILE" >&2
        return 1
    fi

    if ! tar -tzf "$BACKUP_FILE" >/dev/null 2>&1; then
        log_message ERROR \
            "Backup archive failed integrity validation: $BACKUP_FILE" >&2
        return 1
    fi

    local required_entries=(
        "configuration/docker-compose.yml"
        "configuration/.env"
        "data/etc-pihole/gravity.db"
        "metadata/manifest.txt"
    )

    local entry

    for entry in "${required_entries[@]}"; do
        if ! tar -tzf "$BACKUP_FILE" "$entry" >/dev/null 2>&1; then
            log_message ERROR \
                "Required archive entry is missing: $entry" >&2
            return 1
        fi
    done

    local manifest_content

    if ! manifest_content="$(
        tar -xOzf "$BACKUP_FILE" metadata/manifest.txt
    )"; then
        log_message ERROR \
            "Unable to read manifest from backup archive" >&2
        return 1
    fi

    if [[ -z "$manifest_content" ]]; then
        log_message ERROR \
            "Backup manifest is empty" >&2
        return 1
    fi

    if ! grep -Fxq \
        "Project: Project Guardian" \
        <<< "$manifest_content"; then
        log_message ERROR \
            "Backup manifest contains an unexpected project identifier" >&2
        return 1
    fi

    if ! grep -Fxq \
        "Backup-Type: Pi-hole" \
        <<< "$manifest_content"; then
        log_message ERROR \
            "Backup manifest contains an unexpected backup type" >&2
        return 1
    fi

    log_message INFO \
        "Backup archive verification passed: $BACKUP_FILE"

    return 0
}

validate_restored_contents() {
    log_message INFO "Validating restored backup contents"

    if [[ -z "$BACKUP_FILE" ]]; then
        log_message ERROR \
            "Backup file path has not been initialized" >&2
        return 1
    fi

    if [[ ! -f "$BACKUP_FILE" ]]; then
        log_message ERROR \
            "Backup archive does not exist: $BACKUP_FILE" >&2
        return 1
    fi

    if ! RESTORE_TEST_DIR="$(
        mktemp -d \
            "${TMPDIR:-/tmp}/project-guardian-restore-${TIMESTAMP}-XXXXXX"
    )"; then
        log_message ERROR \
            "Unable to create temporary restore validation directory" >&2
        return 1
    fi

    if ! chmod 700 "$RESTORE_TEST_DIR"; then
        log_message ERROR \
            "Unable to secure restore validation directory: $RESTORE_TEST_DIR" >&2
        return 1
    fi

    if ! tar -xzf "$BACKUP_FILE" -C "$RESTORE_TEST_DIR"; then
        log_message ERROR \
            "Unable to extract backup archive for restore validation" >&2
        return 1
    fi

    local required_files=(
        "configuration/docker-compose.yml"
        "configuration/.env"
        "data/etc-pihole/gravity.db"
        "data/etc-pihole/pihole.toml"
        "metadata/manifest.txt"
    )

    local required_file
    local restored_path

    for required_file in "${required_files[@]}"; do
        restored_path="$RESTORE_TEST_DIR/$required_file"

        if [[ ! -e "$restored_path" ]]; then
            log_message ERROR \
                "Required restored file does not exist: $required_file" >&2
            return 1
        fi

        if [[ ! -f "$restored_path" ]]; then
            log_message ERROR \
                "Required restored path is not a regular file: $required_file" >&2
            return 1
        fi

        if [[ ! -r "$restored_path" ]]; then
            log_message ERROR \
                "Required restored file is not readable: $required_file" >&2
            return 1
        fi

        if [[ ! -s "$restored_path" ]]; then
            log_message ERROR \
                "Required restored file is empty: $required_file" >&2
            return 1
        fi
    done

    local restored_manifest

    restored_manifest="$RESTORE_TEST_DIR/metadata/manifest.txt"

    if ! grep -Fxq \
        "Project: Project Guardian" \
        "$restored_manifest"; then
        log_message ERROR \
            "Restored manifest has an unexpected project identifier" >&2
        return 1
    fi

    if ! grep -Fxq \
        "Backup-Type: Pi-hole" \
        "$restored_manifest"; then
        log_message ERROR \
            "Restored manifest has an unexpected backup type" >&2
        return 1
    fi

    log_message INFO \
        "Restored backup contents validation passed: $RESTORE_TEST_DIR"

    return 0
}

cleanup_staging() {
    log_message INFO "Cleaning up temporary staging directory"

    if [[ -z "$STAGING_DIR" ]]; then
        log_message WARNING \
            "Staging directory has not been initialized"
        return 0
    fi

    if [[ ! -e "$STAGING_DIR" ]]; then
        log_message INFO \
            "Temporary staging directory is already absent: $STAGING_DIR"
        return 0
    fi

    if [[ ! -d "$STAGING_DIR" ]]; then
        log_message ERROR \
            "Staging path is not a directory: $STAGING_DIR" >&2
        return 1
    fi

    case "$STAGING_DIR" in
        "${TMPDIR:-/tmp}"/project-guardian-*)
            ;;
        *)
            log_message ERROR \
                "Refusing to remove unexpected staging path: $STAGING_DIR" >&2
            return 1
            ;;
    esac

    if ! rm -rf -- "$STAGING_DIR"; then
        log_message ERROR \
            "Unable to remove temporary staging directory: $STAGING_DIR" >&2
        return 1
    fi

    if [[ -e "$STAGING_DIR" ]]; then
        log_message ERROR \
            "Temporary staging directory still exists: $STAGING_DIR" >&2
        return 1
    fi

    log_message INFO \
        "Temporary staging directory removed: $STAGING_DIR"

    return 0
}

cleanup_restore_environment() {
    log_message INFO "Cleaning up restore validation environment"

    if [[ -z "$RESTORE_TEST_DIR" ]]; then
        log_message WARNING \
            "Restore validation directory has not been initialized"
        return 0
    fi

    if [[ ! -e "$RESTORE_TEST_DIR" ]]; then
        log_message INFO \
            "Restore validation directory is already absent: $RESTORE_TEST_DIR"
        return 0
    fi

    if [[ ! -d "$RESTORE_TEST_DIR" ]]; then
        log_message ERROR \
            "Restore validation path is not a directory: $RESTORE_TEST_DIR" >&2
        return 1
    fi

    case "$RESTORE_TEST_DIR" in
        "${TMPDIR:-/tmp}"/project-guardian-restore-*)
            ;;
        *)
            log_message ERROR \
                "Refusing to remove unexpected restore path: $RESTORE_TEST_DIR" >&2
            return 1
            ;;
    esac

    if ! rm -rf -- "$RESTORE_TEST_DIR"; then
        log_message ERROR \
            "Unable to remove restore validation directory: $RESTORE_TEST_DIR" >&2
        return 1
    fi

    if [[ -e "$RESTORE_TEST_DIR" ]]; then
        log_message ERROR \
            "Restore validation directory still exists: $RESTORE_TEST_DIR" >&2
        return 1
    fi

    log_message INFO \
        "Restore validation directory removed: $RESTORE_TEST_DIR"

    return 0
}

cleanup() {
    :
}

main() {

    log_message INFO "Pi-hole backup tool initialized"

    if ! validate_environment; then
        log_message ERROR "Backup aborted during environment validation" >&2
        return 1
    fi

    log_message INFO "Initial environment validation completed"


    if ! create_backup_directory; then
        log_message ERROR \
            "Backup aborted while preparing destination" >&2
        return 1
    fi

    log_message INFO "Backup destination preparation completed"

    if ! prepare_backup_contents; then
        log_message ERROR \
            "Backup aborted while preparing backup contents" >&2
        return 1
    fi

    log_message INFO "Backup content preparation completed"

    if ! create_backup_manifest; then
        log_message ERROR \
            "Backup aborted while creating manifest" >&2
        return 1
    fi

    log_message INFO "Backup manifest creation completed"

    if ! create_backup_archive; then
        log_message ERROR \
            "Backup aborted while creating archive" >&2
        return 1
    fi

    log_message INFO "Backup archive creation completed"

    if ! verify_backup_archive; then
        log_message ERROR \
            "Backup archive verification failed" >&2
        return 1
    fi

    log_message INFO "Backup archive verification completed"

    if ! validate_restored_contents; then
        log_message ERROR \
            "Restored backup contents validation failed" >&2
        return 1
    fi

    log_message INFO "Restored backup contents validation completed"

    if ! cleanup_restore_environment; then
        log_message ERROR \
            "Restore validation passed, but cleanup failed" >&2
        return 1
    fi

    log_message INFO "Restore validation cleanup completed"

    if ! cleanup_staging; then
        log_message ERROR \
            "Backup created, but temporary cleanup failed" >&2
        return 1
    fi

    log_message INFO "Temporary cleanup completed"

    return 0

}

# 4. Main execution flow

trap cleanup EXIT

main "$@"