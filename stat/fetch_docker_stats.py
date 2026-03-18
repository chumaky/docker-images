#!/usr/bin/env python3
"""Fetch Docker Hub repository stats and store daily snapshots in DuckDB."""

from __future__ import annotations

import argparse
import json
import os
import sys
import uuid
from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Any
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode
from urllib.request import Request, urlopen

try:
    import duckdb
except ImportError:
    print(
        "ERROR: Python package 'duckdb' is required. Install with: pip install duckdb",
        file=sys.stderr,
    )
    sys.exit(2)

DEFAULT_BASE_URL = "https://hub.docker.com/v2/repositories/chumaky"
DEFAULT_PAGE_SIZE = 25
DEFAULT_TIMEOUT_SECONDS = 30


@dataclass
class ImageStat:
    namespace: str
    name: str
    pull_count: int
    star_count: int
    status: int | None
    last_updated_ts: datetime | None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Fetch Docker Hub image stats and store snapshots in DuckDB"
    )
    parser.add_argument(
        "--db-path",
        default=os.environ.get("DOCKER_STATS_DB_PATH"),
        help="DuckDB file path (or set DOCKER_STATS_DB_PATH)",
    )
    parser.add_argument(
        "--url",
        default=os.environ.get("DOCKER_STATS_URL", DEFAULT_BASE_URL),
        help="Docker Hub API base URL",
    )
    parser.add_argument(
        "--page-size",
        type=int,
        default=int(os.environ.get("DOCKER_STATS_PAGE_SIZE", DEFAULT_PAGE_SIZE)),
        help="Result page size. Default: 25",
    )
    parser.add_argument(
        "--ordering",
        default=os.environ.get("DOCKER_STATS_ORDERING", "last_updated"),
        help="API ordering value. Default: last_updated",
    )
    parser.add_argument(
        "--timeout",
        type=int,
        default=int(os.environ.get("DOCKER_STATS_TIMEOUT", DEFAULT_TIMEOUT_SECONDS)),
        help="HTTP timeout in seconds. Default: 30",
    )
    return parser.parse_args()


def parse_iso8601(value: str | None) -> datetime | None:
    if not value:
        return None
    normalized = value.replace("Z", "+00:00")
    try:
        parsed = datetime.fromisoformat(normalized)
    except ValueError:
        return None
    if parsed.tzinfo is None:
        return parsed.replace(tzinfo=timezone.utc)
    return parsed.astimezone(timezone.utc)


def fetch_stats(url: str, page_size: int, ordering: str, timeout: int) -> list[ImageStat]:
    if page_size <= 0:
        raise ValueError("page_size must be greater than zero")

    query = urlencode({"page_size": page_size, "ordering": ordering})
    full_url = f"{url}?{query}"
    request = Request(full_url, headers={"Accept": "application/json"})

    try:
        with urlopen(request, timeout=timeout) as response:
            payload = response.read().decode("utf-8")
    except HTTPError as exc:
        raise RuntimeError(f"Docker Hub request failed with status {exc.code}") from exc
    except URLError as exc:
        raise RuntimeError(f"Docker Hub request failed: {exc.reason}") from exc

    try:
        data: dict[str, Any] = json.loads(payload)
    except json.JSONDecodeError as exc:
        raise RuntimeError("Docker Hub response is not valid JSON") from exc

    results = data.get("results")
    if not isinstance(results, list):
        raise RuntimeError("Docker Hub response missing 'results' list")

    parsed: list[ImageStat] = []
    for item in results:
        if not isinstance(item, dict):
            continue

        namespace = str(item.get("namespace") or "")
        name = str(item.get("name") or "")
        if not name:
            continue

        last_updated_raw = item.get("last_updated")
        last_updated_text = str(last_updated_raw) if last_updated_raw else None
        parsed.append(
            ImageStat(
                namespace=namespace,
                name=name,
                pull_count=int(item.get("pull_count") or 0),
                star_count=int(item.get("star_count") or 0),
                status=item.get("status") if isinstance(item.get("status"), int) else None,
                last_updated_ts=parse_iso8601(last_updated_text),
            )
        )

    return parsed


def store_snapshot(db_path: str, rows: list[ImageStat]) -> tuple[str, datetime]:
    run_id = str(uuid.uuid4())
    ingested_at = datetime.now(timezone.utc)

    conn = duckdb.connect(db_path)
    try:
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS docker_image_stats_snapshot
            ( run_id          TEXT        NOT NULL
            , ingested_at     TIMESTAMPTZ NOT NULL
            , namespace       TEXT        NOT NULL
            , image_name      TEXT        NOT NULL
            , pull_count      BIGINT      NOT NULL
            , star_count      BIGINT      NOT NULL
            , status          INTEGER
            , last_updated_at TIMESTAMPTZ
            )
            """
        )

        conn.executemany(
            """
            INSERT INTO docker_image_stats_snapshot (
                run_id,
                ingested_at,
                namespace,
                image_name,
                pull_count,
                star_count,
                status,
                last_updated_at
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """,
            [
                (
                    run_id,
                    ingested_at,
                    row.namespace,
                    row.name,
                    row.pull_count,
                    row.star_count,
                    row.status,
                    row.last_updated_ts,
                )
                for row in rows
            ],
        )
    finally:
        conn.close()

    return run_id, ingested_at


def main() -> int:
    args = parse_args()

    if not args.db_path:
        print(
            "ERROR: DuckDB path is required. Set DOCKER_STATS_DB_PATH or pass --db-path.",
            file=sys.stderr,
        )
        return 2

    try:
        stats = fetch_stats(
            url=args.url,
            page_size=args.page_size,
            ordering=args.ordering,
            timeout=args.timeout,
        )
    except (RuntimeError, ValueError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1

    if not stats:
        print("WARNING: No image records returned from Docker Hub.", file=sys.stderr)

    try:
        run_id, ingested_at = store_snapshot(args.db_path, stats)
    except Exception as exc:  # noqa: BLE001
        print(f"ERROR: Failed to write DuckDB snapshot: {exc}", file=sys.stderr)
        return 1

    print(
        "Stored snapshot:",
        f"run_id={run_id}",
        f"rows={len(stats)}",
        f"db_path={args.db_path}",
        f"ingested_at={ingested_at.isoformat()}",
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
