"""Load and merge CMakePresets.json (+ include + CMakeUserPresets.json)."""

from __future__ import annotations

import json
from pathlib import Path

PRESET_ARRAY_KEYS = ("configurePresets", "buildPresets", "testPresets")


def _load_json(path: Path) -> dict:
    return json.loads(path.read_text())


def _accumulate(path: Path, into: dict[str, list[dict]], seen: set[Path]) -> None:
    """Recursively load `path` and its `include`s into `into`, depth-first."""
    resolved = path.resolve()
    if resolved in seen:
        return
    seen.add(resolved)

    data = _load_json(path)

    for include in data.get("include", []):
        include_path = (path.parent / include).resolve()
        _accumulate(include_path, into, seen)

    for key in PRESET_ARRAY_KEYS:
        into.setdefault(key, []).extend(data.get(key, []))


def _dedup_last_wins(items: list[dict]) -> list[dict]:
    by_name: dict[str, dict] = {}
    order: list[str] = []
    for item in items:
        name = item["name"]
        if name not in by_name:
            order.append(name)
        by_name[name] = item
    return [by_name[name] for name in order]


def load_merged_presets(presets_path: Path) -> dict[str, list[dict]]:
    """Load `presets_path`, its `include`s, and a sibling CMakeUserPresets.json
    (if present), merging preset arrays additively. Later-loaded presets with
    the same `name` win over earlier ones. Hidden presets are NOT filtered
    here; use `visible_presets` for that.
    """
    merged: dict[str, list[dict]] = {}
    seen: set[Path] = set()
    _accumulate(presets_path, merged, seen)

    user_presets_path = presets_path.parent / "CMakeUserPresets.json"
    if user_presets_path.exists():
        _accumulate(user_presets_path, merged, seen)

    return {key: _dedup_last_wins(items) for key, items in merged.items()}


def _inherits_list(preset: dict) -> list[str]:
    inherits = preset.get("inherits", [])
    if isinstance(inherits, str):
        return [inherits]
    return list(inherits)


def _resolve_display_fields(preset: dict, by_name: dict[str, dict]) -> tuple[str, str]:
    """Resolve displayName/description, walking the `inherits` chain
    (depth-first, first non-empty match wins) when not set directly on
    `preset`.
    """
    display_name = preset.get("displayName", "")
    description = preset.get("description", "")
    if display_name and description:
        return display_name, description

    def walk(name: str, visited: set[str]) -> tuple[str, str]:
        if name in visited or name not in by_name:
            return "", ""
        visited.add(name)
        base = by_name[name]
        base_name = base.get("displayName", "")
        base_desc = base.get("description", "")
        for parent in _inherits_list(base):
            if base_name and base_desc:
                break
            parent_name, parent_desc = walk(parent, visited)
            base_name = base_name or parent_name
            base_desc = base_desc or parent_desc
        return base_name, base_desc

    for parent in _inherits_list(preset):
        if display_name and description:
            break
        parent_name, parent_desc = walk(parent, set())
        display_name = display_name or parent_name
        description = description or parent_desc

    return display_name, description


def visible_presets(merged: dict[str, list[dict]], key: str) -> list[dict]:
    """Return non-hidden presets for `key` (e.g. "configurePresets"), each
    with `displayName`/`description` resolved via inheritance.
    """
    same_type = merged.get(key, [])
    by_name = {p["name"]: p for p in same_type}

    result: list[dict] = []
    for preset in same_type:
        if preset.get("hidden", False):
            continue
        display_name, description = _resolve_display_fields(preset, by_name)
        result.append({
            "name": preset["name"],
            "displayName": display_name,
            "description": description,
        })
    return result
