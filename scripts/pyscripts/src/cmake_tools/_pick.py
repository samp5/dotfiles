"""fzf/tmux-popup pickers for CMakePresets.json files and their presets."""

from __future__ import annotations

import os
from pathlib import Path

from tmux_tools import _util


def _pick(lines: list[str], title: str) -> str | None:
    if os.environ.get("TMUX"):
        server = _util.get_server()
        client = _util.current_client(server)
        if client is not None and client.attached_pane is not None:
            return _util.popup_pick(client.attached_pane, title, lines)
    return _util.pick_inline(lines)


def _format_file_lines(root: Path, candidates: list[Path]) -> list[str]:
    relative = [str(p.relative_to(root)) for p in candidates]
    pad = max(len(r) for r in relative)
    return [
        f"{p}\t{r.ljust(pad)}"
        for p, r in zip(candidates, relative)
    ]


def _format_preset_lines(presets: list[dict]) -> list[str]:
    pad = max(len(p["name"]) for p in presets)
    return [
        f"{p['name']}\t{p['name'].ljust(pad)}  —  {p['displayName']}  —  {p['description']}"
        for p in presets
    ]


def pick_presets_file(root: Path, candidates: list[Path]) -> Path | None:
    if len(candidates) == 1:
        return candidates[0]
    selection = _pick(_format_file_lines(root, candidates), "pick CMakePresets.json")
    return Path(selection) if selection else None


def pick_preset(presets: list[dict], title: str) -> str | None:
    return _pick(_format_preset_lines(presets), title)
