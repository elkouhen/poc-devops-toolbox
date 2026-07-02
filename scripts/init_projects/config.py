from __future__ import annotations

import os
from pathlib import Path


def _resolve_apps_dir(apps_file: Path) -> Path:
    apps_dir = os.environ.get("APPS_DIR") or _read_apps_dir(apps_file)
    path = Path(apps_dir or "apps")
    if not path.is_absolute():
        path = apps_file.parent / path
    return path.resolve()


def _read_apps_dir(apps_file: Path) -> str | None:
    if not apps_file.is_file():
        return None
    for line in apps_file.read_text().splitlines():
        stripped = line.strip()
        if stripped.startswith("appsDir:"):
            return stripped.split(":", 1)[1].strip().strip("'\"")
    return None
