# Lessons Learned

## Docker Bind Mounts

### Initial Assumption

I initially believed that Docker copied persistent files between the host and the container.

### What I Learned

A bind mount does not copy or synchronize files.

The host and the container access the same underlying files through different paths:

```text
Host:
compose/pihole/etc-pihole/gravity.db

Container:
/etc/pihole/gravity.db
```

Deleting or modifying the file from either side affects the same file.

---

## Why It Matters

The service and its data have independent lifecycles.

The container can be removed and recreated while the persistent data remains available on the host.

---

## Analogy

The container is comparable to a computer using an external disk.

If the computer is replaced, the external disk can be connected to a new system and reused.

---

## Minimal Containers

The absence of commands such as file or sqlite3 inside a container does not indicate a failure.

Containers commonly contain only the tools required to run their intended service.

Manual package installation inside a running container should be avoided because it:

-is not reproducible;
-disappears after container recreation;
-is not represented in the Compose configuration;
-increases the container attack surface.

---

## Gravity as a Data Pipeline

Gravity downloads subscribed lists, validates their content, removes or manages duplicates and stores the processed domains in SQLite.

It works before DNS queries are made; it does not consult remote blocklists for every request.

---

## Pi-hole and Browser Blockers

Pi-hole blocks domains at DNS level.

Browser extensions such as uBlock Origin can additionally remove page elements, scripts and first-party advertising content.

The two technologies complement each other.
