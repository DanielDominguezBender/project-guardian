# Pi-hole Operations Runbook

## Check Container Status

```bash
docker ps
docker-compose ps
```

## View Logs

```bash
cd ~/Projects/project-guardian/compose/pihole
docker-compose logs --tail=100 pihole
```

## Follow Logs

```bash
docker-compose logs -f pihole
```

Use Ctrl+C to stop following logs without stopping the container.

## Restart Pi-hole

```bash
docker-compose restart pihole
Stop the Deployment
docker-compose down
```

Persistent data remains on the host.

## Start the Deployment

```bash
docker-compose up -d
```
## Update Gravity

```bash
docker exec guardian-pihole pihole -g
```

## Query a Domain

```bash
docker exec guardian-pihole pihole -q doubleclick.net
```

## Access the Web Interface

http://192.168.68.50/admin/

## Inspect Gravity Database

```bash
cd ~/Projects/project-guardian/compose/pihole/etc-pihole

sqlite3 -readonly gravity.db '.tables'

sqlite3 -readonly -header -column gravity.db \
"SELECT id, address, enabled, number, status, comment FROM adlist;"

sqlite3 -readonly -header -column gravity.db \
"SELECT COUNT(*) AS total_entries,
        COUNT(DISTINCT domain) AS unique_domains
 FROM gravity;"
```
