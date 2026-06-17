"""Pick a tmux window layout from a list.

Opens a floating fzf popup listing common tmux layouts; picking one applies
it to the current window.
"""

from __future__ import annotations

from tmux_tools import _util

_LAYOUTS: list[tuple[str, str]] = [
    ("even-horizontal", "Panes spread evenly left-to-right"),
    ("even-vertical", "Panes spread evenly top-to-bottom"),
    ("main-horizontal", "Single tall pane on the left, others stacked right"),
    ("main-vertical", "Single wide pane on top, others stacked below"),
    ("tiled", "Panes arranged in a grid"),
]


def main() -> None:
    server = _util.get_server()
    client = _util.current_client(server)
    window = client.attached_window
    if window is None:
        _util.notify(server, "layout-picker: no attached window")
        return

    lines = [
        f"{name}\t{name}  —  {desc}"
        for name, desc in _LAYOUTS
    ]
    target = _util.popup_pick(client.attached_pane, "pick layout", lines)
    if target is None:
        return

    window.select_layout(target)
