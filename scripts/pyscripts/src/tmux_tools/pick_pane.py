"""Pick any pane across all sessions and jump to it.

Opens a floating fzf popup listing every pane in every session; picking one
switches the client to that pane's session, selects its window, and selects
the pane.
"""

from __future__ import annotations

from tmux_tools import _util


def main() -> None:
    server = _util.get_server()
    client = _util.current_client(server)

    origin_pane_id = client.attached_pane.id if client.attached_pane else None

    panes = sorted(
        (p for p in server.panes if p.id != origin_pane_id),
        key=lambda p: (p.session.name, int(p.window.index or 0), int(p.index or 0)),
    )
    if not panes:
        _util.notify(server, "pick-pane: no panes")
        return

    pad_ses = max(len(p.session.name or "") for p in panes)
    pad_win = max(len(p.window.name or "") for p in panes)
    lines = [
        (
            f"{p.id}\t"
            f"{p.title}\t"
            f"{(p.session.name or "").ljust(pad_ses)}  "
            f"{p.window.index}.{p.index}".ljust(6) + "  "
            f"{(p.window.name or "").ljust(pad_win)}  "
        )
        for p in panes
    ]

    if not client.attached_pane:
        _util.notify(server, "pick-pane: no attached pane")
        return

    target = _util.popup_pick(
        client.attached_pane,
        "pick pane",
        lines,
        preview_cmd="tmux capture-pane -p -e -t {1}",
    )
    if target is None:
        return

    for pane in panes:
        if pane.id == target:
            pane.session.switch_client()
            pane.window.select()
            pane.select()
            return
