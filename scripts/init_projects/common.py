from __future__ import annotations

import re


def slug(value: str) -> str:
    value = re.sub(r"[^a-z0-9-]+", "-", value.lower())
    return re.sub(r"(^-+|-+$)", "", value)
