"""Append windows from a tmuxp workspace to the current session.

Lists tmuxp workspaces, lets the user pick one, and passes it to
``tmuxp load -a`` to append its windows into the current session.
"""

from __future__ import annotations

import os

from tmux_tools import _util


def main() -> None:
    server = _util.get_server()
    client = _util.current_client(server)
    pane = client.attached_pane
    if pane is None:
        _util.notify(server, "workspace-window: no attached pane")
        return

    if client.attached_session is None:
        _util.notify(server, "workspace-window: no attached session")
        return

    ws_path = _util.pick_tmuxp_workspace(pane)
    if ws_path is None:
        return

    os.execvp("tmuxp", ["tmuxp", "load", "-a", str(ws_path)])
