"""Tie together discovery, parsing, and picking to run a cmake/ctest preset."""

from __future__ import annotations

import os
import sys
from pathlib import Path

from cmake_tools import _discovery, _parse, _pick

MODES: dict[str, tuple[str, list[str]]] = {
    "configure": ("configurePresets", ["cmake", "--preset"]),
    "build": ("buildPresets", ["cmake", "--build", "--preset"]),
    "test": ("testPresets", ["ctest", "--preset"]),
}


def _error(message: str) -> None:
    print(f"error: {message}", file=sys.stderr)
    sys.exit(1)


def run(mode: str) -> None:
    array_key, command_prefix = MODES[mode]

    try:
        root = _discovery.find_repo_root(Path.cwd())
    except FileNotFoundError as exc:
        _error(str(exc))

    candidates = _discovery.find_presets_files(root)
    if not candidates:
        _error(f"no CMakePresets.json found under {root}")

    presets_path = _pick.pick_presets_file(root, candidates)
    if presets_path is None:
        return

    merged = _parse.load_merged_presets(presets_path)
    presets = _parse.visible_presets(merged, array_key)
    if not presets:
        _error(f"no {mode} presets found in {presets_path}")

    name = _pick.pick_preset(presets, f"pick {mode} preset")
    if name is None:
        return

    os.chdir(presets_path.parent)
    argv = [*command_prefix, name, *sys.argv[1:]]
    os.execvp(argv[0], argv)
