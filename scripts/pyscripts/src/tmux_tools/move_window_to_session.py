"""Move the current window into another session.

Opens a floating fzf popup listing every session except the current one;
picking one moves the current window into it, at the next free index. If
no other sessions exist, shows a message and opens nothing.
"""

from __future__ import annotations

from tmux_tools import _util


def main() -> None:
    server = _util.get_server()
    client = _util.current_client(server)
    origin_session = client.attached_session
    origin_window = client.attached_window

    if not origin_session or not origin_window:
        _util.notify(server, "move-window-to-session: no attached session or window")
        return

    sessions = sorted(
        (s for s in server.sessions if s.session_id != origin_session.session_id),
        key=lambda s: s.session_name,
    )
    if not sessions:
        _util.notify(server, "move-window-to-session: no other sessions")
        return

    pad = max(len(s.session_name) for s in sessions)
    lines = [
        (
            f"{s.session_name}\t"
            f"{s.session_name.ljust(pad)}  "
            f"{s.session_windows} windows"
        )
        for s in sessions
    ]
    target = _util.popup_pick(
        client.attached_pane,
        "move window to session",
        lines,
        preview_cmd=_util.session_preview_cmd(),
    )
    if target is None:
        return

    origin_window.move_window(session=target)
