"""fzf picker for scripts described in scripts.json.

Reads scripts.json (an array of {name, description, path} entries) from the
scripts/ directory this project lives under, and lets you fuzzy-pick one.
Outside tmux the picker runs directly in the current terminal. Inside tmux
it runs in a floating popup - but only the picker: the popup closes before
the chosen script runs, so a script that inspects "the focused pane" (e.g.
join-pane-to-window) sees the real pane the user had focused, not the
popup's own hidden pane.

MANIFEST FORMAT (scripts.json):
    [{"name": "...", "description": "...", "path": "..."}, ...]
    "path" may be absolute or relative to the manifest's directory.
"""

from __future__ import annotations

import json
import os
import subprocess
import sys
from pathlib import Path

from tmux_tools import _util

# {path}/src/meta_tools/run_script.py -> {path}/scripts.json
MANIFEST_PATH = Path(__file__).resolve().parents[2] / "scripts.json"


def _load_entries() -> list[dict[str, str]]:
    return json.loads(MANIFEST_PATH.read_text())



def main() -> None:
    entries = _load_entries()
    if not entries:
        print("run-script: scripts.json has no entries", file=sys.stderr)
        return

    pad = max(len(e["name"]) for e in entries)
    lines = [
        f"{e['path']}\t{e['name'].ljust(pad)}  {e['description']}"
        for e in entries
    ]

    if os.environ.get("TMUX"):
        server = _util.get_server()
        client = _util.current_client(server)
        selection = _util.popup_pick(
            client.attached_pane,
            "run script",
            lines,
            search_nth="1",
            width="30%"
        )
    else:
        selection = _util.pick_inline(lines)

    if not selection:
        return

    path = Path(selection)
    if not path.is_absolute():
        path = MANIFEST_PATH.parent / path

    os.execv(str(path), [str(path)])


if __name__ == "__main__":
    main()
