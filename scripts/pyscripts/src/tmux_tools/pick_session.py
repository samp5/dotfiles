"""Attach to a tmux session.
"""

from __future__ import annotations

from tmux_tools import _util


def main() -> None:
    server = _util.get_server()

    if not server.is_alive():
        _util.notify(server, "tmux server is not running")
        return

    origin_session = None
    origin_pane = None

    client = _util.current_client(server) if _util.in_tmux() else None
    if client:
        origin_session = client.attached_session
        origin_pane = client.attached_pane



    if server.sessions:
        sessions = server.sessions.filter(lambda s: (not origin_session) or s.id != origin_session.id)
        sessions.sort(key = lambda s: s.session_name or "<no-session-name>")

        pad = max(len(s.session_name or "<no-session-name>") for s in sessions) if sessions else 0
        lines = [
            (
                f"{s.session_name}\t"
                f"{(s.session_name or "<no-session-name>").ljust(pad)}  "
                f"{s.session_windows} windows"
            )
            for s in sessions
        ]
    else:
        lines = []

    if _util.in_tmux():
        if not origin_pane:
            _util.notify(server, "no other sessions to pick")
            return

        target = _util.popup_pick(
            pane=origin_pane,
            title="pick-session",
            lines=lines,
            print_query=True,
        )

    else:
        target = _util.pick_inline(
            lines,
            print_query=True,
        )

    if target is None:
        return

    if not server.sessions.filter(lambda s: s.session_name == target):
        server.new_session(session_name=target)

    if _util.in_tmux():
        server.switch_client(target)
    else:
        server.attach_session(target)
