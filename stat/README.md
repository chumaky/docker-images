# Docker Hub Stats Collector

This directory contains scripts for collecting Docker Hub image statistics for the `chumaky` namespace and storing them in PostgreSQL.

## Files

- `run.sh`: Existing read-only script that prints current stats table to stdout.
- `fetch_docker_stats.py`: Python collector that fetches API data and writes a snapshot to PostgreSQL.
- `run_daily_stats.sh`: Shell wrapper intended to be called by an external scheduler.

## Requirements

- Host Python 3.10+ (or compatible)
- Python package: `psycopg` (psycopg3)
- PostgreSQL database (local or remote)

Install dependency:

```bash
pip install psycopg[binary]
```

## Configuration

Required environment variables:

- `DB_HOST`: PostgreSQL host (default: `localhost`)
- `DB_PORT`: PostgreSQL port (default: `5432`)
- `DB_NAME`: PostgreSQL database name (default: `stats`)
- `DB_USER`: PostgreSQL user (default: `postgres`)
- `DB_PASSWORD`: PostgreSQL password (optional)

Optional environment variables:

- `DOCKER_STATS_URL` (default: `https://hub.docker.com/v2/repositories/chumaky`)
- `DOCKER_STATS_PAGE_SIZE` (default: `25`)
- `DOCKER_STATS_ORDERING` (default: `last_updated`)
- `DOCKER_STATS_TIMEOUT` (default: `30` seconds)
- `PYTHON_BIN` for wrapper (default: `python3`)

## Usage

Run through wrapper:

```bash
DB_HOST=localhost \
DB_PORT=15432 \
DB_NAME=stats \
DB_USER=postgres \
DB_PASSWORD=yourpassword \
./stat/run_daily_stats.sh
```

Optional overrides:

```bash
DB_HOST=db.example.com \
DB_PORT=15432 \
DB_NAME=stats \
DB_USER=postgres \
DB_PASSWORD=yourpassword \
./stat/run_daily_stats.sh --page-size 25 --ordering last_updated
```

## Stored Data

Table: `docker_image_stats_snapshot`

One snapshot run inserts one row per image with:

- `run_id`
- `ingested_at`
- `namespace`
- `image_name`
- `pull_count`
- `star_count`
- `status`
- `last_updated_at`

## Scheduling

Scheduling is external by design. Example cron entry:

```cron
10 2 * * * /home/toleg/chumaky/github/docker-images/stat/run_daily_stats.sh >> /var/log/chumaky/docker_stats.log 2>&1
```
