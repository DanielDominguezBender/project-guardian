# ADR-0003

## Title

Centralized Logging Engine

## Status

Accepted

## Context

All scripts need to write logs.

## Decision

Create a reusable `logger.sh` module.

## Consequences

+ Reusability
+ Consistency
+ Maintainability

- Shared dependency

# Rationale

Multiple scripts require logging.

Duplicating logging logic increases maintenance cost.

A centralized logging module provides a single implementation reused across the project.

# Alternatives Considered

Separate log_info(), log_warning(), log_error()

Rejected because:

- duplicated code
- inconsistent formatting
- harder maintenance

# Future Evolution

Possible future enhancements:

- log rotation
- JSON logs
- syslog integration
- structured logging
