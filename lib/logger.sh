log_message() {

# What is the problem?
## We need a consistent ways to register events

# What is the responsability?
## Validate, format and write message

# What are the inputs?
## - Parameter 1: level
## - Parameter 2: message

# What is the output?
## Success: - Formatted log entry written to STDOUT 
## Failure: - Descriptive error written to STDERR - Non-zero return code

# What can go wrong?
## Level or Message variable can be empty, date can fail, ...

    local level="$1"
    local message="$2"

    if [[ $# -ne 2 ]]; then
        printf 'LOGGER_ERROR: log_message requires exactly 2 arguments.\n' >&2
        return 2
    fi

    if [[ -z "$level" || -z "$message" ]]; then
        printf 'LOGGER_ERROR: level and message must not be empty.\n' >&2
        return 2
    fi

    case "$level" in
        INFO|WARNING|ERROR)
            ;;
        *)
            printf 'LOGGER_ERROR: invalid log level: %s\n' "$level" >&2
            return 2
            ;;
    esac

    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

    if ! timestamp="$(date '+%Y-%m-%d %H:%M:%S')"; then
        printf "LOGGER_ERROR: unable to generate timestamp.\n" >&2
        return 3
    fi

    printf '[%s] [%s] %s\n' "$timestamp" "$level" "$message"

    return 0
}
