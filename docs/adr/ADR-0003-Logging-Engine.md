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
