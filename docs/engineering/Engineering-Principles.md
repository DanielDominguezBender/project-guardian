# Engineering Rules

Project Guardian is more than a backup script.

It is an engineering exercise focused on building production-quality infrastructure tools by following a consistent set of design principles.

These rules were introduced progressively during the development of the project and document the engineering decisions taken throughout the implementation.

---

# Rule #01

Design for maintainability before adding new features.

# Rule #02

Write documentation before implementing complex functionality.

# Rule #03

Every function must have a single, well-defined responsibility.

# Rule #04

Separate validation from execution.

# Rule #05

Validate every external input before using it.

# Rule #06

Never assume that a file, directory or command exists.

# Rule #07

Fail early and fail with meaningful error messages.

# Rule #08

Every failure must produce a useful diagnostic message.

# Rule #09

Always return meaningful exit codes.

# Rule #10

Avoid hidden side effects.

# Rule #11

Temporary resources must always be cleaned up.

# Rule #12

Design functions based on responsibilities, not on specific use cases.

# Rule #13

Prefer explicit code over clever code.

# Rule #14

Use descriptive variable names.

# Rule #15

Keep functions small and focused.

# Rule #16

Local variables should remain local whenever possible.

# Rule #17

The caller decides the severity of an event.

The logger only communicates it.

# Rule #18

Logging is a reusable service.

Business logic must never depend on logging implementation.

# Rule #19

Never duplicate business logic.

# Rule #20

Every reusable component deserves its own module.

# Rule #21

Validate configuration before using it.

# Rule #22

Never trust the execution environment.

# Rule #23

Always verify required dependencies.

# Rule #24

Every operation should be deterministic whenever possible.

# Rule #25

Infrastructure code should be readable before being clever.

# Rule #26

Every important decision deserves documentation.

# Rule #27

Prefer predictable directory structures.

# Rule #28

Keep temporary data isolated from persistent data.

# Rule #29

Protect destructive operations using explicit safety checks.

# Rule #30

Never delete resources outside explicitly approved locations.

# Rule #31

Backups should never overwrite previous backups.

# Rule #32

Timestamp every generated artifact.

# Rule #33

Preserve metadata whenever possible.

# Rule #34

Generate machine-readable manifests.

# Rule #35

Treat metadata as part of the backup.

# Rule #36

Keep production configuration together with production data.

# Rule #37

Build backups in isolated staging directories.

# Rule #38

Secure temporary working directories.

# Rule #39

A backup is not complete until every required component has been copied.

# Rule #40

Every archive must contain enough information to identify itself.

# Rule #41

Never assume archive creation succeeded.

Always verify it.

# Rule #42

Validate generated artifacts before considering the operation successful.

# Rule #43

Verification must run before cleanup so that failed intermediate state remains available for troubleshooting.

# Rule #44

A valid archive must satisfy both structural integrity and application-specific content requirements.

# Rule #45

A successful pipeline must validate its output before removing the evidence needed to diagnose a failure.

# Rule #46

A backup can be structurally valid without being operationally restorable.

# Rule #47

Define the minimum recoverable dataset before declaring a backup successful.

# Rule #48

Validating an extracted backup provides more confidence than inspecting only the compressed archive.

---

# Continuous Improvement

This document evolves together with the project.

New engineering rules are added whenever the project introduces a new architectural decision, operational lesson, or engineering best practice.

The objective is not to accumulate rules, but to document the reasoning behind the implementation so that future contributors — including the original author — understand *why* each decision was made.
