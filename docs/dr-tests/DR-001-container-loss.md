# DR-001 — Container Loss Recovery

**Status:** ✅ PASS

**Date:** 2026-07-15

---

# Objective

Validate that Project Guardian can recover from the complete loss of the Pi-hole Docker container without losing configuration or persistent data.

---

# Scenario

A complete loss of the `guardian-pihole` Docker container was simulated.

The Raspberry Pi host remained operational.

Docker Engine remained operational.

Persistent bind-mounted storage remained intact.

---

# Success Criteria

| Check | Result |
|--------|--------|
| Pi-hole dashboard restored | ✅ |
| DNS resolution restored | ✅ |
| Gravity database preserved | ✅ |
| Custom blocklists preserved | ✅ |
| Container recreated successfully | ✅ |
| Manual reconfiguration required | ❌ No |

---

# Scope

Included

- Docker container
- Pi-hole service
- Bind-mounted persistent data

Excluded

- Raspberry Pi host
- Docker Engine
- SD card failure
- Network infrastructure

---

# Test Procedure

1. Verify container is healthy.
2. Validate DNS resolution.
3. Stop the container.
4. Verify service interruption.
5. Remove the container.
6. Verify persistent data still exists.
7. Recreate the container using Docker Compose.
8. Validate dashboard accessibility.
9. Validate DNS resolution.
10. Validate Gravity database integrity.

---

# Test Results

The original container was successfully removed.

A new container was created with a different Container ID.

The new container automatically mounted the existing persistent storage.

Pi-hole started successfully without requiring manual configuration.

All Gravity blocklists and configuration remained available.

---

# Recovery Evidence

Original Container ID:

```
b755ba75946f
```

Recovered Container ID:

```
36db14a2d976
```

Result:

- Container recreated successfully.
- New PID assigned.
- New Container ID assigned.
- Persistent data preserved.

---

# Recovery Time

Approximately 2–3 minutes.

---

# Lessons Learned

- Containers are ephemeral.
- Persistent data stored through bind mounts survives container deletion.
- Docker Compose enables reproducible deployments.
- Configuration should never rely on the container filesystem.
- Disaster Recovery procedures should always be validated, not assumed.
