"""Break the current pane out into its own window.

Promotes the focused pane to a new window in the same session.
"""

from __future__ import annotations

from tmux_tools import _util


def main() -> None:
    server = _util.get_server()
    client = _util.current_client(server)
    pane = client.attached_pane
    if pane is None:
        _util.notify(server, "break-pane: no attached pane")
        return

    pane.break_pane(detach=False)
