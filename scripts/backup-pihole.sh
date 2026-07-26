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

#CONTAINER_NAME="guardian-pihole"
CONTAINER_NAME="${CONTAINER_NAME:-guardian-pihole}"
PIHOLE_STOPPED=false

#COMPOSE_FILE="$PROJECT_ROOT/compose/pihole/docker-compose.yml"
##COMPOSE_FILE="$PROJECT_ROOT/compose/pihole/docker-compose-does-not-exist.yml"
#ENV_FILE="$PROJECT_ROOT/compose/pihole/.env"
#PIHOLE_DATA_DIR="$PROJECT_ROOT/compose/pihole/etc-pihole"

#BACKUP_ROOT="$PROJECT_ROOT/backups"

COMPOSE_FILE="${COMPOSE_FILE:-$PROJECT_ROOT/compose/pihole/docker-compose.yml}"
ENV_FILE="${ENV_FILE:-$PROJECT_ROOT/compose/pihole/.env}"
PIHOLE_DATA_DIR="${PIHOLE_DATA_DIR:-$PROJECT_ROOT/compose/pihole/etc-pihole}"
BACKUP_ROOT="${BACKUP_ROOT:-$PROJECT_ROOT/backups}"

BACKUP_DATE=""
TIMESTAMP=""
BACKUP_DIR=""
BACKUP_FILE=""

# 3. Functions

validate_environment() {
    log_message INFO "Validating backup environment"

    if ! command -v docker >/dev/null 2>&1; then
        log_message ERROR "Required command not found: docker" >&2
        return 1
    fi

    if ! command -v tar >/dev/null 2>&1; then
        log_message ERROR "Required command not found: tar" >&2
        return 1
    fi

    log_message INFO "Required commands are available"

    if [[ ! -r "$COMPOSE_FILE" ]]; then
        log_message ERROR "Compose file is not readable: $COMPOSE_FILE" >&2
        return 1
    fi

    if [[ ! -r "$ENV_FILE" ]]; then
        log_message ERROR "Environment file is not readable: $ENV_FILE" >&2
        return 1
    fi

    if [[ ! -d "$PIHOLE_DATA_DIR" ]]; then
        log_message ERROR "Pi-hole data directory does not exist: $PIHOLE_DATA_DIR" >&2
        return 1
    fi

    if [[ ! -r "$PIHOLE_DATA_DIR" ]]; then
        log_message ERROR "Pi-hole data directory is not readable: $PIHOLE_DATA_DIR" >&2
        return 1
    fi

    if [[ ! -d "$BACKUP_ROOT" ]]; then
        log_message ERROR "Backup root directory does not exist: $BACKUP_ROOT" >&2
        return 1
    fi

    if [[ ! -w "$BACKUP_ROOT" ]]; then
        log_message ERROR "Backup root directory is not writable: $BACKUP_ROOT" >&2
        return 1
    fi

    log_message INFO "Required files and directories are available"

    if ! docker inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
   	 log_message ERROR "Pi-hole container does not exist: $CONTAINER_NAME" >&2
    	return 1
    fi

    local container_running

    if ! container_running="$(
    	docker inspect \
        	--format '{{.State.Running}}' \
       		 "$CONTAINER_NAME"
    )"; then
    	log_message ERROR "Unable to inspect Pi-hole container state: $CONTAINER_NAME" >&2
    	return 1
    fi

    if [[ "$container_running" != "true" ]]; then
    	log_message ERROR "Pi-hole container is not running: $CONTAINER_NAME" >&2
   	 return 1
    fi

    log_message INFO "Pi-hole container is available and running"

    return 0
}

create_backup_directory() {
    :
}

stop_pihole() {
    :
}

create_backup() {
    :
}

start_pihole() {
    :
}

validate_backup() {
    :
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
}

# 4. Main execution flow

trap cleanup EXIT

main "$@"
