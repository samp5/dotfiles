"""Pick any window across all sessions and jump to it.

Opens a floating fzf popup listing every window in every session (excluding
the current one); picking one switches the client to that session and selects
the window.
"""

from __future__ import annotations

from tmux_tools import _util


def main() -> None:
    server = _util.get_server()
    client = _util.current_client(server)
    origin_window = client.attached_window
    if origin_window is None:
        _util.notify(server, "pick-window: no attached window")
        return

    windows = sorted(
        (w for w in server.windows if w.window_id != origin_window.window_id),
        key=lambda w: (w.session.name, int(w.index)),
    )
    if not windows:
        _util.notify(server, "pick-window: no other windows")
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
        client.attached_pane,
        "pick window",
        lines,
    )
    if target is None:
        return

    for window in windows:
        if f"{window.session.name}:{window.index}" == target:
            window.session.switch_client()
            window.select()
            return
