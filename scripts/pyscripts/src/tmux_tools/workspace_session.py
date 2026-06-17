"""Create a new session from a tmuxp workspace and attach.

Lists tmuxp workspaces, lets the user pick one, and passes it to
``tmuxp load --yes`` to create the session and switch to it.
"""

from __future__ import annotations

import os

from tmux_tools import _util


def main() -> None:
    server = _util.get_server()
    client = _util.current_client(server)
    pane = client.attached_pane
    if pane is None:
        _util.notify(server, "workspace-session: no attached pane")
        return

    ws_path = _util.pick_tmuxp_workspace(pane)
    if ws_path is None:
        return

    os.execvp("tmuxp", ["tmuxp", "load", "--yes", str(ws_path)])
