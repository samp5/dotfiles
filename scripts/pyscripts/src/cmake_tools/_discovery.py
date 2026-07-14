"""Locate the repo root and CMakePresets.json files within it."""

from __future__ import annotations

import os
from pathlib import Path

_ROOT_MARKERS = (".git", ".jj")
_SKIP_DIR_NAMES = {".git", ".jj", ".venv", "venv", "node_modules", "__pycache__"}


def find_repo_root(start: Path) -> Path:
    """Walk up from `start` looking for a `.git` or `.jj` entry.

    Raises FileNotFoundError if no repo root is found before the
    filesystem root.
    """
    current = start.resolve()
    while True:
        if any((current / marker).exists() for marker in _ROOT_MARKERS):
            return current
        if current.parent == current:
            raise FileNotFoundError("not inside a git or jj repository")
        current = current.parent


def _should_skip_dir(name: str) -> bool:
    return name in _SKIP_DIR_NAMES or name.lower().startswith("build")


def find_presets_files(root: Path) -> list[Path]:
    """Return every `CMakePresets.json` under `root`, skipping junk dirs."""
    matches: list[Path] = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if not _should_skip_dir(d)]
        if "CMakePresets.json" in filenames:
            matches.append(Path(dirpath) / "CMakePresets.json")
    return sorted(matches)
