"""Kill another tmux session.

Opens a floating fzf popup listing every session except the current one;
picking one asks for confirmation on the status line, then kills it. If no
other sessions exist, shows a message and opens nothing.
"""

from __future__ import annotations

from tmux_tools import _util


def main() -> None:
    server = _util.get_server()
    client = _util.current_client(server)
    origin_session = client.attached_session

    if not origin_session:
        _util.notify(server, "kill-session: failed to get attached session")
        return

    if not client.attached_pane:
        _util.notify(server, "kill-session: failed to get attached pane")
        return

    sessions = sorted(
        (s for s in server.sessions if s.session_id != origin_session.session_id),
        key=lambda s: s.session_name,
    )
    if not sessions:
        _util.notify(server, "kill-session: no other sessions")
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
        "kill session",
        lines,
        preview_cmd=_util.session_preview_cmd(),
    )
    if target is None:
        return

    server.confirm_before(
        f"kill-session -t {target}",
        prompt=f"Kill session {target}? (y/n)",
        target_client=client.client_tty,
    )
