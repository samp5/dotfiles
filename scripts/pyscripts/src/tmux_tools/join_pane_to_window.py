"""Move the currently focused pane into another tmux window.

Saves the focused pane, opens a floating fzf popup listing every other
window across all sessions, and joins the saved pane into whichever one is
picked. If no other windows exist, shows a message and opens nothing.
"""

from __future__ import annotations

from tmux_tools import _util


def main() -> None:
    server = _util.get_server()
    client = _util.current_client(server)
    origin_pane = client.attached_pane
    origin_window = client.attached_window
    if not origin_window or not origin_pane:
        _util.notify(server, "join-pane-to-window: no attached_window or no attached_pane")
        return

    windows = sorted(
        (w for w in server.windows if w.window_id != origin_window.window_id),
        key=lambda w: (w.session.name, int(w.index)),
    )
    if not windows:
        _util.notify(server, "join-pane-to-window: no other windows to join")
        return

    pad_ses = max(len(w.session.name) for w in windows)
    pad_win = max(len(w.name) for w in windows)
    lines = [
        (
            f"{w.session.name}:{w.index}\t"
            f"{w.session.name.ljust(pad_ses)}  "
            f"{w.index}".rjust(3) + "  "
            f"{w.name.ljust(pad_win)}  "
            f"{len(list(w.panes))} panes"
        )
        for w in windows
    ]
    target = _util.popup_pick(
        origin_pane,
        "join pane to window",
        lines,
    )
    if target is None:
        return

    origin_pane.join(target)
