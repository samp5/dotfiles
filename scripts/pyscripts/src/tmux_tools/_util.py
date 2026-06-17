"""Shared helpers for the fzf-popup family of tmux tools."""

from __future__ import annotations

import json
import os
import subprocess
import tempfile
from pathlib import Path


import libtmux
from libtmux.pane import Pane
from libtmux.server import Server


def get_server() -> Server:
    return Server()

def in_tmux() -> bool:
    env = os.environ.get("TMUX")
    return env is not None and len(env) > 0

def current_client(server: Server) -> libtmux.Client | None:
    """The attached client whose focus these tools act on."""
    clients = server.clients
    if not clients:
       return None
    return clients[0]

def pick_inline(lines: list[str], *, print_query: bool = False) -> str | None:
    out_path = _mktemp()
    try:
        args = ["fzf", "--with-nth=2..", "--nth=1"]
        if print_query:
            args.append("--print-query")
        with out_path.open("w") as outf:
            proc = subprocess.run(
                args,
                input="\n".join(lines) + "\n" if lines else "",
                stdout=outf,
                text=True,
            )
        if proc.returncode == 130:
            return None
        output = out_path.read_text().rstrip()
    finally:
        out_path.unlink(missing_ok=True)

    if not output:
        return None

    if print_query:
        parts = output.split("\n", 1)
        query = parts[0]
        if proc.returncode == 0 and len(parts) > 1:
            return first_field(parts[1])
        return query or None

    return first_field(output) or None

def _mktemp() -> Path:
    fd, path = tempfile.mkstemp()
    os.close(fd)
    return Path(path)


def popup_pick(
    pane: Pane,
    title: str,
    lines: list[str],
    *,
    display_nth: str = "2..",
    search_nth: str | None = None,
    preview_cmd: str | None = None,
    width="70%",
    height="60%",
    print_query: bool = False,
) -> str | None:
    """Show `lines` ("key<TAB>label" per line) in a floating fzf popup on
    `pane`'s client and return the selected key, or None if cancelled or
    `lines` is empty.

    The popup only runs the picker command and closes before this returns.
    The caller - still tied to the real pane/client that invoked this, not
    the popup's own hidden pane - is what performs any resulting tmux
    action, so pane/window/session lookups after this call stay correct.

    Parameters
    ----------
    display_nth
        Passed as ``--with-nth=`` to fzf to control which fields are shown.
    search_nth
        Passed as ``--nth=`` to fzf to restrict fuzzy matching to specific
        fields.  ``None`` (the default) means match against all fields.
    preview_cmd
        Passed as ``--preview=`` to fzf.  ``{1}``, ``{2}`` etc. refer to
        tab-delimited fields in the original (pre-transform) line.
    print_query
        If True, add ``--print-query``.  When no line is selected the query
        is returned instead of None (so the caller can create a new entry).
    """
    if not lines and not print_query:
        return None

    list_path = _mktemp()
    out_path = _mktemp()
    try:
        list_path.write_text("\n".join(lines) + "\n" if lines else "")
        # Popup command string is parsed by whatever the default shell is,
        # not necessarily this interpreter, so keep it free of Python/bash
        # specific quoting.
        nth = f"--nth={search_nth}" if search_nth else ""
        ansi = "--ansi" if preview_cmd else ""
        preview = f"--preview '{preview_cmd}'" if preview_cmd else ""
        pq = "--print-query" if print_query else ""
        pane.display_popup(
            command=(
                f"fzf --with-nth={display_nth} {nth} {ansi} {preview} {pq}"
                f" < '{list_path}' > '{out_path}'"
            ),
            close_on_exit=True,
            width=width,
            height=height,
            title=title,
        )
        selection = out_path.read_text().rstrip("\n")
    finally:
        list_path.unlink(missing_ok=True)
        out_path.unlink(missing_ok=True)

    if not selection:
        return None

    if print_query:
        parts = selection.split("\n", 1)
        query = parts[0]
        if len(parts) > 1:
            return first_field(parts[1])
        return query or None

    return first_field(selection)


def first_field(line: str) -> str:
    """The part of a "key<TAB>label" line before the tab."""
    key, _, _ = line.partition("\t")
    return key


def pick_tmuxp_workspace(pane: Pane, title: str = "pick workspace") -> Path | None:
    """List tmuxp workspaces, let the user pick one in a fzf popup.

    Returns the resolved workspace path, or ``None`` if there are no
    workspaces, the picker was cancelled, or the path no longer exists.
    """
    workspaces = list_tmuxp_workspaces()
    if not workspaces:
        return None

    lines = [f"{w['path']}\t{w['name']}" for w in workspaces]
    pick = popup_pick(pane, title, lines)
    if pick is None:
        return None

    ws_path = Path(pick).expanduser().resolve()
    if not ws_path.exists():
        return None

    return ws_path


def list_tmuxp_workspaces() -> list[dict[str, str]]:
    """Return [{name, path}, ...] from ``tmuxp ls --json``."""
    result = subprocess.run(
        ["tmuxp", "ls", "--json"],
        capture_output=True,
        text=True,
    )
    data = json.loads(result.stdout)
    return [{"name": w["name"], "path": w["path"]} for w in data["workspaces"]]


# ANSI colour numbers for the fzf preview format string.
# Change these to customise the preview colours.
# {index} = window index, {name} = window name, {count} = "N panes"
_ANSI_INDEX = "33"   # yellow
_ANSI_NAME  = "36"   # cyan
_ANSI_COUNT = "32"   # green


def session_preview_cmd() -> str:
    """Return a preview command for fzf, with ANSI color.

    Tab-delimits the tmux format output so ``awk`` can split safely and
    add ANSI codes via ``\\033`` octal escapes (generated at shell runtime
    — tmux strips raw ESC bytes from format strings).

    The entire command uses zero single quotes so ``popup_pick`` can wrap
    it in ``--preview '...'`` without quoting conflicts.

    ``{1}`` is replaced by fzf with the session name (the first tab-delimited
    field of the selected line).
    """
    fmt = "#{window_index}\t#{window_name}\t#{window_panes} panes"
    Q = '\\"'      # shell-escaped double-quote for awk printf format
    E = "\\\\033"  # shell-escaped ESC prefix for awk
    awk_action = (
        f'{{printf {Q}{E}[{_ANSI_INDEX}m%s{E}[0m: '
        f'{E}[{_ANSI_NAME}m%s{E}[0m ('
        f'{E}[{_ANSI_COUNT}m%s{E}[0m)\\n{Q}, '
        '\\$1, \\$2, \\$3}'
    )
    return (
        f"tmux list-windows -t {{1}} -F \"{fmt}\""
        f" | awk -F\"\\t\" \"{awk_action}\""
    )


def notify(server: Server, message: str) -> None:
    """Show `message` on the status line, without format expansion."""
    if server.is_alive() and in_tmux():
        server.display_message(message, no_expand=True)
    else:
        print(message)
