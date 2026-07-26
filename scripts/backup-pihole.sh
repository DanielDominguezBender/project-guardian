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

# shellshock source=../lib/logger.sh
source "$LOGGER_PATH"

if ! declare -F log_message >/dev/null; then
	printf 'ERROR: logging module does nto provide log_message().\n' >&2
	exit 1
fi

CONTAINER_NAME="guardian-pihole"
PIHOLE_STOPPED=false

COMPOSE_FILE=""
ENV_FILE=""
PIHOLE_DATA_DIR=""

BACKUP_ROOT=""
BACKUP_DATE=""
TIMESTAMP=""
BACKUP_DIR=""
BACKUP_FILE=""

# 3. Functions

#log_info() {
#    echo "[INFO] | $(date '+%Y-%m-%d %H:%M:%S') | $(basename "$0") | $1"
#}

#log_error() {
#    echo "[ERROR] | $(date '+%Y-%m-%d %H:%M:%S') | $(basename "$0") | $1" >&2
#}

#log_message() {

#	local level="$1"
#	local message="$2"
#	local log_line="..."

#	echo "$log_line"
#}

validate_environment() {
    :
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
}

# 4. Main execution flow

trap cleanup EXIT

main "$@"
