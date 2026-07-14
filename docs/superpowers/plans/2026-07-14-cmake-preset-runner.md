# CMake Preset Runner Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build `cmake-configure`, `cmake-build`, and `cmake-test` — three fzf-driven commands that find a repo's `CMakePresets.json`, let the user pick the right preset, and run the matching `cmake`/`ctest` invocation from the preset file's own directory.

**Architecture:** A new `cmake_tools` package under `pyscripts/src/`, split into four focused modules (`_discovery.py`, `_parse.py`, `_pick.py`, `_run.py`) plus three thin entry-point scripts (`configure.py`, `build.py`, `test.py`) that each call `_run.run(mode)`. Pure logic (repo/file discovery, JSON merging, inheritance resolution, line formatting) is unit-tested; the fzf/tmux picking and the final `os.execvp` are exercised via monkeypatched unit tests for orchestration and manual verification for the real IO.

**Tech Stack:** Python 3.13, uv (package/dependency management), pytest (tests), `fzf` (picker UI), `tmux_tools._util` (existing fzf/tmux-popup helper), stdlib `json`/`os`/`pathlib`.

## Global Constraints

- Python `>=3.13` (matches `pyscripts/pyproject.toml` `requires-python`).
- Every new module starts with `from __future__ import annotations` (matches existing `pyscripts` style).
- New code lives under `pyscripts/src/cmake_tools/`; tests live under `pyscripts/tests/`.
- Reuse `tmux_tools._util.popup_pick` / `tmux_tools._util.pick_inline` for the fzf picker (tmux popup when `$TMUX` is set, inline otherwise) — do not duplicate fzf-invocation logic, matching how `meta_tools.run_script` already depends on `tmux_tools._util`.
- Entry points are registered in `pyscripts/pyproject.toml` under `[project.scripts]` and mirrored in `pyscripts/scripts.json` (the existing `run-script` picker manifest).
- `condition` fields in presets are **not** evaluated (out of scope per spec) — presets a real `cmake` might disable on this platform are still listed.
- No caching/remembering of the last-used preset per mode (out of scope per spec).
- Only `configurePresets`, `buildPresets`, `testPresets` are supported — not `packagePresets`/`workflowPresets`.
- Each command takes no flags of its own; all of `sys.argv[1:]` is forwarded verbatim to the underlying `cmake`/`ctest` invocation.
- Commit using `jj describe -m "..."` on the current change (already holding the edits) followed by `jj new -m "..."` to start the next task — this repo is jj-colocated, not a plain git checkout.

---

### Task 1: Repo root & CMakePresets.json discovery (`_discovery.py`)

**Files:**
- Create: `scripts/pyscripts/src/cmake_tools/__init__.py`
- Create: `scripts/pyscripts/src/cmake_tools/_discovery.py`
- Test: `scripts/pyscripts/tests/test_discovery.py`
- Modify: `scripts/pyscripts/pyproject.toml` (adds `pytest` dev dependency via `uv add --dev`)

**Interfaces:**
- Produces: `find_repo_root(start: Path) -> Path` — raises `FileNotFoundError("not inside a git or jj repository")` if no `.git`/`.jj` entry is found before the filesystem root.
- Produces: `find_presets_files(root: Path) -> list[Path]` — sorted list of every `CMakePresets.json` under `root`, skipping `.git`, `.jj`, `.venv`, `venv`, `node_modules`, `__pycache__`, and any dir name starting with `build` (case-insensitive).

- [ ] **Step 1: Add pytest as a dev dependency**

Run: `cd /home/spraneis/dotfiles/scripts/pyscripts && uv add --dev pytest`

Expected: `pyproject.toml` gains a `[dependency-groups]` `dev = ["pytest>=..."]` (or equivalent) entry, `uv.lock` is updated, command exits 0.

- [ ] **Step 2: Create the package skeleton**

Create `scripts/pyscripts/src/cmake_tools/__init__.py`:

```python
"""fzf-driven pickers for CMake preset configure/build/test commands."""
```

- [ ] **Step 3: Write failing tests for discovery**

Create `scripts/pyscripts/tests/test_discovery.py`:

```python
from __future__ import annotations

import pytest

from cmake_tools import _discovery


def test_find_repo_root_finds_git_root(tmp_path):
    (tmp_path / ".git").mkdir()
    nested = tmp_path / "a" / "b"
    nested.mkdir(parents=True)

    root = _discovery.find_repo_root(nested)

    assert root == tmp_path.resolve()


def test_find_repo_root_finds_jj_root(tmp_path):
    (tmp_path / ".jj").mkdir()
    nested = tmp_path / "a"
    nested.mkdir()

    root = _discovery.find_repo_root(nested)

    assert root == tmp_path.resolve()


def test_find_repo_root_raises_when_not_in_repo(tmp_path):
    with pytest.raises(FileNotFoundError):
        _discovery.find_repo_root(tmp_path)


def test_find_presets_files_finds_single_file(tmp_path):
    (tmp_path / ".git").mkdir()
    (tmp_path / "CMakePresets.json").write_text("{}")

    found = _discovery.find_presets_files(tmp_path)

    assert found == [tmp_path / "CMakePresets.json"]


def test_find_presets_files_skips_build_and_junk_dirs(tmp_path):
    (tmp_path / ".git").mkdir()
    src_dir = tmp_path / "src"
    src_dir.mkdir()
    (src_dir / "CMakePresets.json").write_text("{}")

    build_dir = tmp_path / "build"
    build_dir.mkdir()
    (build_dir / "CMakePresets.json").write_text("{}")

    node_modules = tmp_path / "node_modules"
    node_modules.mkdir()
    (node_modules / "CMakePresets.json").write_text("{}")

    found = _discovery.find_presets_files(tmp_path)

    assert found == [src_dir / "CMakePresets.json"]


def test_find_presets_files_finds_multiple_sorted(tmp_path):
    (tmp_path / ".git").mkdir()
    (tmp_path / "a").mkdir()
    (tmp_path / "b").mkdir()
    (tmp_path / "a" / "CMakePresets.json").write_text("{}")
    (tmp_path / "b" / "CMakePresets.json").write_text("{}")

    found = _discovery.find_presets_files(tmp_path)

    assert found == sorted([
        tmp_path / "a" / "CMakePresets.json",
        tmp_path / "b" / "CMakePresets.json",
    ])
```

- [ ] **Step 4: Run tests to verify they fail**

Run: `cd /home/spraneis/dotfiles/scripts/pyscripts && uv run pytest tests/test_discovery.py -v`
Expected: FAIL — `ModuleNotFoundError: No module named 'cmake_tools'` or `AttributeError` (module has no `_discovery`).

- [ ] **Step 5: Implement `_discovery.py`**

Create `scripts/pyscripts/src/cmake_tools/_discovery.py`:

```python
"""Locate the repo root and CMakePresets.json files within it."""

from __future__ import annotations

import os
from pathlib import Path

_ROOT_MARKERS = (".git", ".jj")
_SKIP_DIR_NAMES = {".git", ".jj", ".venv", "venv", "node_modules", "__pycache__"}


def find_repo_root(start: Path) -> Path:
    """Walk up from `start` looking for a `.git` or `.jj` entry.

    Raises FileNotFoundError if no repo root is found before the
    filesystem root.
    """
    current = start.resolve()
    while True:
        if any((current / marker).exists() for marker in _ROOT_MARKERS):
            return current
        if current.parent == current:
            raise FileNotFoundError("not inside a git or jj repository")
        current = current.parent


def _should_skip_dir(name: str) -> bool:
    return name in _SKIP_DIR_NAMES or name.lower().startswith("build")


def find_presets_files(root: Path) -> list[Path]:
    """Return every `CMakePresets.json` under `root`, skipping junk dirs."""
    matches: list[Path] = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if not _should_skip_dir(d)]
        if "CMakePresets.json" in filenames:
            matches.append(Path(dirpath) / "CMakePresets.json")
    return sorted(matches)
```

- [ ] **Step 6: Run tests to verify they pass**

Run: `cd /home/spraneis/dotfiles/scripts/pyscripts && uv run pytest tests/test_discovery.py -v`
Expected: PASS (6 passed).

- [ ] **Step 7: Commit**

```bash
cd /home/spraneis/dotfiles
jj describe -m "feat: add cmake preset repo/file discovery"
jj new -m "wip: cmake preset parsing and merging"
```

---

### Task 2: Parsing, merging, and inheritance resolution (`_parse.py`)

**Files:**
- Create: `scripts/pyscripts/src/cmake_tools/_parse.py`
- Test: `scripts/pyscripts/tests/test_parse.py`

**Interfaces:**
- Consumes: nothing from Task 1 directly (operates on a `Path` to a presets file, produced by discovery/picking in later tasks).
- Produces: `load_merged_presets(presets_path: Path) -> dict[str, list[dict]]` — merges `presets_path`'s own `configurePresets`/`buildPresets`/`testPresets` with everything pulled in via its `include` list (recursive, depth-first) and, if present, a sibling `CMakeUserPresets.json` (and *its* `include`s). Within each array, later-loaded entries with the same `name` replace earlier ones. Hidden presets are **not** filtered here.
- Produces: `visible_presets(merged: dict[str, list[dict]], key: str) -> list[dict]` — for `merged[key]`, drops `hidden: true` entries and returns `[{"name": ..., "displayName": ..., "description": ...}, ...]`, resolving `displayName`/`description` through the `inherits` chain (same-type only, depth-first, first non-empty match wins) when not set directly on the preset.

- [ ] **Step 1: Write failing tests for parsing/merging**

Create `scripts/pyscripts/tests/test_parse.py`:

```python
from __future__ import annotations

import json
from pathlib import Path

from cmake_tools import _parse


def _write(path: Path, data: dict) -> None:
    path.write_text(json.dumps(data))


def test_load_merged_presets_reads_base_file(tmp_path):
    presets_path = tmp_path / "CMakePresets.json"
    _write(presets_path, {"configurePresets": [{"name": "default", "displayName": "Default"}]})

    merged = _parse.load_merged_presets(presets_path)

    assert merged["configurePresets"] == [{"name": "default", "displayName": "Default"}]


def test_load_merged_presets_resolves_include(tmp_path):
    _write(tmp_path / "base.json", {"configurePresets": [{"name": "base-preset"}]})
    presets_path = tmp_path / "CMakePresets.json"
    _write(presets_path, {
        "include": ["base.json"],
        "configurePresets": [{"name": "default"}],
    })

    merged = _parse.load_merged_presets(presets_path)

    names = [p["name"] for p in merged["configurePresets"]]
    assert names == ["base-preset", "default"]


def test_load_merged_presets_merges_sibling_user_presets(tmp_path):
    presets_path = tmp_path / "CMakePresets.json"
    _write(presets_path, {"configurePresets": [{"name": "default"}]})
    _write(tmp_path / "CMakeUserPresets.json", {"configurePresets": [{"name": "my-local"}]})

    merged = _parse.load_merged_presets(presets_path)

    names = [p["name"] for p in merged["configurePresets"]]
    assert names == ["default", "my-local"]


def test_load_merged_presets_last_definition_wins_by_name(tmp_path):
    presets_path = tmp_path / "CMakePresets.json"
    _write(presets_path, {"configurePresets": [{"name": "default", "displayName": "First"}]})
    _write(tmp_path / "CMakeUserPresets.json", {"configurePresets": [{"name": "default", "displayName": "Second"}]})

    merged = _parse.load_merged_presets(presets_path)

    assert merged["configurePresets"] == [{"name": "default", "displayName": "Second"}]


def test_visible_presets_filters_hidden():
    merged = {
        "configurePresets": [
            {"name": "base", "hidden": True},
            {"name": "default", "displayName": "Default", "description": "The default"},
        ],
    }

    visible = _parse.visible_presets(merged, "configurePresets")

    assert visible == [{"name": "default", "displayName": "Default", "description": "The default"}]


def test_visible_presets_resolves_display_fields_via_inherits():
    merged = {
        "configurePresets": [
            {
                "name": "base",
                "hidden": True,
                "displayName": "Base Display",
                "description": "Base description",
            },
            {"name": "default", "inherits": "base"},
        ],
    }

    visible = _parse.visible_presets(merged, "configurePresets")

    assert visible == [{
        "name": "default",
        "displayName": "Base Display",
        "description": "Base description",
    }]


def test_visible_presets_first_inherits_parent_wins():
    merged = {
        "configurePresets": [
            {"name": "base-a", "hidden": True, "displayName": "A"},
            {"name": "base-b", "hidden": True, "displayName": "B"},
            {"name": "default", "inherits": ["base-a", "base-b"]},
        ],
    }

    visible = _parse.visible_presets(merged, "configurePresets")

    assert visible[0]["displayName"] == "A"
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd /home/spraneis/dotfiles/scripts/pyscripts && uv run pytest tests/test_parse.py -v`
Expected: FAIL — `AttributeError: module 'cmake_tools' has no attribute '_parse'` / `ModuleNotFoundError`.

- [ ] **Step 3: Implement `_parse.py`**

Create `scripts/pyscripts/src/cmake_tools/_parse.py`:

```python
"""Load and merge CMakePresets.json (+ include + CMakeUserPresets.json)."""

from __future__ import annotations

import json
from pathlib import Path

PRESET_ARRAY_KEYS = ("configurePresets", "buildPresets", "testPresets")


def _load_json(path: Path) -> dict:
    return json.loads(path.read_text())


def _accumulate(path: Path, into: dict[str, list[dict]], seen: set[Path]) -> None:
    """Recursively load `path` and its `include`s into `into`, depth-first."""
    resolved = path.resolve()
    if resolved in seen:
        return
    seen.add(resolved)

    data = _load_json(path)

    for include in data.get("include", []):
        include_path = (path.parent / include).resolve()
        _accumulate(include_path, into, seen)

    for key in PRESET_ARRAY_KEYS:
        into.setdefault(key, []).extend(data.get(key, []))


def _dedup_last_wins(items: list[dict]) -> list[dict]:
    by_name: dict[str, dict] = {}
    order: list[str] = []
    for item in items:
        name = item["name"]
        if name not in by_name:
            order.append(name)
        by_name[name] = item
    return [by_name[name] for name in order]


def load_merged_presets(presets_path: Path) -> dict[str, list[dict]]:
    """Load `presets_path`, its `include`s, and a sibling CMakeUserPresets.json
    (if present), merging preset arrays additively. Later-loaded presets with
    the same `name` win over earlier ones. Hidden presets are NOT filtered
    here; use `visible_presets` for that.
    """
    merged: dict[str, list[dict]] = {}
    seen: set[Path] = set()
    _accumulate(presets_path, merged, seen)

    user_presets_path = presets_path.parent / "CMakeUserPresets.json"
    if user_presets_path.exists():
        _accumulate(user_presets_path, merged, seen)

    return {key: _dedup_last_wins(items) for key, items in merged.items()}


def _inherits_list(preset: dict) -> list[str]:
    inherits = preset.get("inherits", [])
    if isinstance(inherits, str):
        return [inherits]
    return list(inherits)


def _resolve_display_fields(preset: dict, by_name: dict[str, dict]) -> tuple[str, str]:
    """Resolve displayName/description, walking the `inherits` chain
    (depth-first, first non-empty match wins) when not set directly on
    `preset`.
    """
    display_name = preset.get("displayName", "")
    description = preset.get("description", "")
    if display_name and description:
        return display_name, description

    def walk(name: str, visited: set[str]) -> tuple[str, str]:
        if name in visited or name not in by_name:
            return "", ""
        visited.add(name)
        base = by_name[name]
        base_name = base.get("displayName", "")
        base_desc = base.get("description", "")
        for parent in _inherits_list(base):
            if base_name and base_desc:
                break
            parent_name, parent_desc = walk(parent, visited)
            base_name = base_name or parent_name
            base_desc = base_desc or parent_desc
        return base_name, base_desc

    for parent in _inherits_list(preset):
        if display_name and description:
            break
        parent_name, parent_desc = walk(parent, set())
        display_name = display_name or parent_name
        description = description or parent_desc

    return display_name, description


def visible_presets(merged: dict[str, list[dict]], key: str) -> list[dict]:
    """Return non-hidden presets for `key` (e.g. "configurePresets"), each
    with `displayName`/`description` resolved via inheritance.
    """
    same_type = merged.get(key, [])
    by_name = {p["name"]: p for p in same_type}

    result: list[dict] = []
    for preset in same_type:
        if preset.get("hidden", False):
            continue
        display_name, description = _resolve_display_fields(preset, by_name)
        result.append({
            "name": preset["name"],
            "displayName": display_name,
            "description": description,
        })
    return result
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd /home/spraneis/dotfiles/scripts/pyscripts && uv run pytest tests/test_parse.py -v`
Expected: PASS (7 passed).

- [ ] **Step 5: Commit**

```bash
cd /home/spraneis/dotfiles
jj describe -m "feat: add cmake preset parsing and inheritance resolution"
jj new -m "wip: cmake preset fzf pickers"
```

---

### Task 3: fzf/tmux pickers (`_pick.py`)

**Files:**
- Create: `scripts/pyscripts/src/cmake_tools/_pick.py`
- Test: `scripts/pyscripts/tests/test_pick.py`

**Interfaces:**
- Consumes: `Path` list from `_discovery.find_presets_files`; `list[dict]` (with `name`/`displayName`/`description` keys) from `_parse.visible_presets`.
- Produces: `pick_presets_file(root: Path, candidates: list[Path]) -> Path | None` — returns the sole candidate without prompting if there's only one; otherwise shows an fzf dialog of paths relative to `root` and returns the chosen `Path`, or `None` if cancelled.
- Produces: `pick_preset(presets: list[dict], title: str) -> str | None` — shows an fzf dialog of `name  —  displayName  —  description` lines and returns the chosen preset `name`, or `None` if cancelled.
- Internal (still exported for test monkeypatching): `_pick(lines: list[str], title: str) -> str | None` — tmux popup if `$TMUX` is set, else inline fzf.

- [ ] **Step 1: Write failing tests for `_pick.py`**

Create `scripts/pyscripts/tests/test_pick.py`:

```python
from __future__ import annotations

from cmake_tools import _pick


def test_format_preset_lines_includes_name_display_and_description():
    presets = [
        {"name": "default", "displayName": "Default", "description": "The default"},
        {"name": "release", "displayName": "Release", "description": "Optimized"},
    ]

    lines = _pick._format_preset_lines(presets)

    assert lines[0].startswith("default\t")
    assert "Default" in lines[0]
    assert "The default" in lines[0]
    assert lines[1].startswith("release\t")


def test_pick_presets_file_returns_single_candidate_without_prompting(tmp_path, monkeypatch):
    candidate = tmp_path / "CMakePresets.json"

    def fail_if_called(lines, title):
        raise AssertionError("_pick should not be called for a single candidate")

    monkeypatch.setattr(_pick, "_pick", fail_if_called)

    result = _pick.pick_presets_file(tmp_path, [candidate])

    assert result == candidate


def test_pick_presets_file_prompts_when_multiple_candidates(tmp_path, monkeypatch):
    a = tmp_path / "a" / "CMakePresets.json"
    b = tmp_path / "b" / "CMakePresets.json"
    a.parent.mkdir()
    b.parent.mkdir()
    a.write_text("{}")
    b.write_text("{}")

    monkeypatch.setattr(_pick, "_pick", lambda lines, title: str(b))

    result = _pick.pick_presets_file(tmp_path, [a, b])

    assert result == b


def test_pick_presets_file_returns_none_when_cancelled(tmp_path, monkeypatch):
    a = tmp_path / "a" / "CMakePresets.json"
    b = tmp_path / "b" / "CMakePresets.json"
    a.parent.mkdir()
    b.parent.mkdir()
    a.write_text("{}")
    b.write_text("{}")

    monkeypatch.setattr(_pick, "_pick", lambda lines, title: None)

    result = _pick.pick_presets_file(tmp_path, [a, b])

    assert result is None


def test_pick_preset_passes_formatted_lines_and_returns_selection(monkeypatch):
    presets = [{"name": "default", "displayName": "Default", "description": "desc"}]
    captured = {}

    def fake_pick(lines, title):
        captured["lines"] = lines
        captured["title"] = title
        return "default"

    monkeypatch.setattr(_pick, "_pick", fake_pick)

    result = _pick.pick_preset(presets, "pick configure preset")

    assert result == "default"
    assert captured["title"] == "pick configure preset"
    assert captured["lines"][0].startswith("default\t")


def test_pick_preset_returns_none_when_cancelled(monkeypatch):
    presets = [{"name": "default", "displayName": "Default", "description": "desc"}]
    monkeypatch.setattr(_pick, "_pick", lambda lines, title: None)

    result = _pick.pick_preset(presets, "pick configure preset")

    assert result is None
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd /home/spraneis/dotfiles/scripts/pyscripts && uv run pytest tests/test_pick.py -v`
Expected: FAIL — `ModuleNotFoundError` / `AttributeError`.

- [ ] **Step 3: Implement `_pick.py`**

Create `scripts/pyscripts/src/cmake_tools/_pick.py`:

```python
"""fzf/tmux-popup pickers for CMakePresets.json files and their presets."""

from __future__ import annotations

import os
from pathlib import Path

from tmux_tools import _util


def _pick(lines: list[str], title: str) -> str | None:
    if os.environ.get("TMUX"):
        server = _util.get_server()
        client = _util.current_client(server)
        if client is not None and client.attached_pane is not None:
            return _util.popup_pick(client.attached_pane, title, lines)
    return _util.pick_inline(lines)


def _format_file_lines(root: Path, candidates: list[Path]) -> list[str]:
    relative = [str(p.relative_to(root)) for p in candidates]
    pad = max(len(r) for r in relative)
    return [
        f"{p}\t{r.ljust(pad)}"
        for p, r in zip(candidates, relative)
    ]


def _format_preset_lines(presets: list[dict]) -> list[str]:
    pad = max(len(p["name"]) for p in presets)
    return [
        f"{p['name']}\t{p['name'].ljust(pad)}  —  {p['displayName']}  —  {p['description']}"
        for p in presets
    ]


def pick_presets_file(root: Path, candidates: list[Path]) -> Path | None:
    if len(candidates) == 1:
        return candidates[0]
    selection = _pick(_format_file_lines(root, candidates), "pick CMakePresets.json")
    return Path(selection) if selection else None


def pick_preset(presets: list[dict], title: str) -> str | None:
    return _pick(_format_preset_lines(presets), title)
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd /home/spraneis/dotfiles/scripts/pyscripts && uv run pytest tests/test_pick.py -v`
Expected: PASS (6 passed).

- [ ] **Step 5: Commit**

```bash
cd /home/spraneis/dotfiles
jj describe -m "feat: add cmake preset fzf/tmux pickers"
jj new -m "wip: cmake-configure/build/test commands"
```

---

### Task 4: Orchestration, entry points, and packaging (`_run.py` + commands)

**Files:**
- Create: `scripts/pyscripts/src/cmake_tools/_run.py`
- Create: `scripts/pyscripts/src/cmake_tools/configure.py`
- Create: `scripts/pyscripts/src/cmake_tools/build.py`
- Create: `scripts/pyscripts/src/cmake_tools/test.py`
- Test: `scripts/pyscripts/tests/test_run.py`
- Modify: `scripts/pyscripts/pyproject.toml:15-30` (`[project.scripts]` — add three entries)
- Modify: `scripts/pyscripts/scripts.json` (add three manifest entries)

**Interfaces:**
- Consumes: `_discovery.find_repo_root`, `_discovery.find_presets_files`, `_parse.load_merged_presets`, `_parse.visible_presets`, `_pick.pick_presets_file`, `_pick.pick_preset` (all as defined in Tasks 1-3).
- Produces: `run(mode: str) -> None` where `mode` is one of `"configure"`, `"build"`, `"test"` — never returns on success (replaces the process via `os.execvp`); exits with status 1 (after printing `error: ...` to stderr) if no repo root, no CMakePresets.json, or no presets for the mode are found; returns normally (exit 0) if either picker is cancelled.

- [ ] **Step 1: Write failing tests for `_run.py`**

Create `scripts/pyscripts/tests/test_run.py`:

```python
from __future__ import annotations

import sys

import pytest

from cmake_tools import _discovery, _parse, _pick, _run


def test_run_execs_configure_command(monkeypatch, tmp_path):
    presets_path = tmp_path / "sub" / "CMakePresets.json"
    presets_path.parent.mkdir(parents=True)
    presets_path.write_text("{}")

    monkeypatch.setattr(_discovery, "find_repo_root", lambda start: tmp_path)
    monkeypatch.setattr(_discovery, "find_presets_files", lambda root: [presets_path])
    monkeypatch.setattr(_pick, "pick_presets_file", lambda root, candidates: presets_path)
    monkeypatch.setattr(
        _parse, "load_merged_presets", lambda path: {"configurePresets": [{"name": "default"}]}
    )
    monkeypatch.setattr(
        _parse,
        "visible_presets",
        lambda merged, key: [{"name": "default", "displayName": "", "description": ""}],
    )
    monkeypatch.setattr(_pick, "pick_preset", lambda presets, title: "default")

    recorded = {}
    monkeypatch.setattr(_run.os, "execvp", lambda file, argv: recorded.update(file=file, argv=argv))
    monkeypatch.setattr(_run.os, "chdir", lambda path: recorded.setdefault("chdir", path))
    monkeypatch.setattr(sys, "argv", ["cmake-configure", "-DFOO=1"])

    _run.run("configure")

    assert recorded["file"] == "cmake"
    assert recorded["argv"] == ["cmake", "--preset", "default", "-DFOO=1"]
    assert recorded["chdir"] == presets_path.parent


def test_run_execs_build_command(monkeypatch, tmp_path):
    presets_path = tmp_path / "CMakePresets.json"
    presets_path.write_text("{}")

    monkeypatch.setattr(_discovery, "find_repo_root", lambda start: tmp_path)
    monkeypatch.setattr(_discovery, "find_presets_files", lambda root: [presets_path])
    monkeypatch.setattr(_pick, "pick_presets_file", lambda root, candidates: presets_path)
    monkeypatch.setattr(_parse, "load_merged_presets", lambda path: {"buildPresets": [{"name": "rel"}]})
    monkeypatch.setattr(
        _parse, "visible_presets", lambda merged, key: [{"name": "rel", "displayName": "", "description": ""}]
    )
    monkeypatch.setattr(_pick, "pick_preset", lambda presets, title: "rel")

    recorded = {}
    monkeypatch.setattr(_run.os, "execvp", lambda file, argv: recorded.update(file=file, argv=argv))
    monkeypatch.setattr(_run.os, "chdir", lambda path: None)
    monkeypatch.setattr(sys, "argv", ["cmake-build", "-j8"])

    _run.run("build")

    assert recorded["argv"] == ["cmake", "--build", "--preset", "rel", "-j8"]


def test_run_errors_when_no_repo_root(monkeypatch, capsys):
    def raise_not_found(start):
        raise FileNotFoundError("not inside a git or jj repository")

    monkeypatch.setattr(_discovery, "find_repo_root", raise_not_found)

    with pytest.raises(SystemExit) as exc_info:
        _run.run("configure")

    assert exc_info.value.code == 1
    assert "not inside a git or jj repository" in capsys.readouterr().err


def test_run_errors_when_no_presets_files_found(monkeypatch, tmp_path):
    monkeypatch.setattr(_discovery, "find_repo_root", lambda start: tmp_path)
    monkeypatch.setattr(_discovery, "find_presets_files", lambda root: [])

    with pytest.raises(SystemExit) as exc_info:
        _run.run("configure")

    assert exc_info.value.code == 1


def test_run_returns_quietly_when_file_picker_cancelled(monkeypatch, tmp_path):
    presets_path = tmp_path / "CMakePresets.json"
    monkeypatch.setattr(_discovery, "find_repo_root", lambda start: tmp_path)
    monkeypatch.setattr(_discovery, "find_presets_files", lambda root: [presets_path])
    monkeypatch.setattr(_pick, "pick_presets_file", lambda root, candidates: None)

    executed = []
    monkeypatch.setattr(_run.os, "execvp", lambda file, argv: executed.append((file, argv)))

    _run.run("configure")

    assert executed == []


def test_run_errors_when_no_presets_for_mode(monkeypatch, tmp_path):
    presets_path = tmp_path / "CMakePresets.json"
    monkeypatch.setattr(_discovery, "find_repo_root", lambda start: tmp_path)
    monkeypatch.setattr(_discovery, "find_presets_files", lambda root: [presets_path])
    monkeypatch.setattr(_pick, "pick_presets_file", lambda root, candidates: presets_path)
    monkeypatch.setattr(_parse, "load_merged_presets", lambda path: {})
    monkeypatch.setattr(_parse, "visible_presets", lambda merged, key: [])

    with pytest.raises(SystemExit) as exc_info:
        _run.run("build")

    assert exc_info.value.code == 1


def test_run_returns_quietly_when_preset_picker_cancelled(monkeypatch, tmp_path):
    presets_path = tmp_path / "CMakePresets.json"
    monkeypatch.setattr(_discovery, "find_repo_root", lambda start: tmp_path)
    monkeypatch.setattr(_discovery, "find_presets_files", lambda root: [presets_path])
    monkeypatch.setattr(_pick, "pick_presets_file", lambda root, candidates: presets_path)
    monkeypatch.setattr(_parse, "load_merged_presets", lambda path: {"testPresets": [{"name": "x"}]})
    monkeypatch.setattr(
        _parse, "visible_presets", lambda merged, key: [{"name": "x", "displayName": "", "description": ""}]
    )
    monkeypatch.setattr(_pick, "pick_preset", lambda presets, title: None)

    executed = []
    monkeypatch.setattr(_run.os, "execvp", lambda file, argv: executed.append((file, argv)))

    _run.run("test")

    assert executed == []
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd /home/spraneis/dotfiles/scripts/pyscripts && uv run pytest tests/test_run.py -v`
Expected: FAIL — `ModuleNotFoundError` / `AttributeError`.

- [ ] **Step 3: Implement `_run.py`**

Create `scripts/pyscripts/src/cmake_tools/_run.py`:

```python
"""Tie together discovery, parsing, and picking to run a cmake/ctest preset."""

from __future__ import annotations

import os
import sys
from pathlib import Path

from cmake_tools import _discovery, _parse, _pick

MODES: dict[str, tuple[str, list[str]]] = {
    "configure": ("configurePresets", ["cmake", "--preset"]),
    "build": ("buildPresets", ["cmake", "--build", "--preset"]),
    "test": ("testPresets", ["ctest", "--preset"]),
}


def _error(message: str) -> None:
    print(f"error: {message}", file=sys.stderr)
    sys.exit(1)


def run(mode: str) -> None:
    array_key, command_prefix = MODES[mode]

    try:
        root = _discovery.find_repo_root(Path.cwd())
    except FileNotFoundError as exc:
        _error(str(exc))

    candidates = _discovery.find_presets_files(root)
    if not candidates:
        _error(f"no CMakePresets.json found under {root}")

    presets_path = _pick.pick_presets_file(root, candidates)
    if presets_path is None:
        return

    merged = _parse.load_merged_presets(presets_path)
    presets = _parse.visible_presets(merged, array_key)
    if not presets:
        _error(f"no {mode} presets found in {presets_path}")

    name = _pick.pick_preset(presets, f"pick {mode} preset")
    if name is None:
        return

    os.chdir(presets_path.parent)
    argv = [*command_prefix, name, *sys.argv[1:]]
    os.execvp(argv[0], argv)
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd /home/spraneis/dotfiles/scripts/pyscripts && uv run pytest tests/test_run.py -v`
Expected: PASS (7 passed).

- [ ] **Step 5: Create the three entry-point modules**

Create `scripts/pyscripts/src/cmake_tools/configure.py`:

```python
"""Pick a configure preset from CMakePresets.json and run `cmake --preset`."""

from __future__ import annotations

from cmake_tools import _run


def main() -> None:
    _run.run("configure")


if __name__ == "__main__":
    main()
```

Create `scripts/pyscripts/src/cmake_tools/build.py`:

```python
"""Pick a build preset from CMakePresets.json and run `cmake --build --preset`."""

from __future__ import annotations

from cmake_tools import _run


def main() -> None:
    _run.run("build")


if __name__ == "__main__":
    main()
```

Create `scripts/pyscripts/src/cmake_tools/test.py`:

```python
"""Pick a test preset from CMakePresets.json and run `ctest --preset`."""

from __future__ import annotations

from cmake_tools import _run


def main() -> None:
    _run.run("test")


if __name__ == "__main__":
    main()
```

- [ ] **Step 6: Register the entry points in `pyproject.toml`**

In `scripts/pyscripts/pyproject.toml`, add three lines inside the existing `[project.scripts]` table (after `pick-session = "tmux_tools.pick_session:main"`):

```toml
cmake-configure = "cmake_tools.configure:main"
cmake-build = "cmake_tools.build:main"
cmake-test = "cmake_tools.test:main"
```

- [ ] **Step 7: Add entries to `scripts.json`**

In `scripts/pyscripts/scripts.json`, add three entries to the JSON array (before the closing `]`):

```json
  {
    "name": "cmake-configure",
    "description": "Pick a CMake configure preset and run cmake --preset",
    "path": ".venv/bin/cmake-configure"
  },
  {
    "name": "cmake-build",
    "description": "Pick a CMake build preset and run cmake --build --preset",
    "path": ".venv/bin/cmake-build"
  },
  {
    "name": "cmake-test",
    "description": "Pick a CTest test preset and run ctest --preset",
    "path": ".venv/bin/cmake-test"
  }
```

- [ ] **Step 8: Sync the environment and re-run the full test suite**

Run: `cd /home/spraneis/dotfiles/scripts/pyscripts && uv sync && uv run pytest -v`
Expected: all tests pass (discovery + parse + pick + run suites); `.venv/bin/cmake-configure`, `.venv/bin/cmake-build`, `.venv/bin/cmake-test` now exist.

- [ ] **Step 9: Manually verify end-to-end against a real CMake project**

Create a throwaway project with its own repo marker and a real preset file:

```bash
mkdir -p /tmp/cmake-preset-check/src
cd /tmp/cmake-preset-check && git init -q
cat > CMakeLists.txt <<'EOF'
cmake_minimum_required(VERSION 3.21)
project(check LANGUAGES NONE)
EOF
cat > CMakePresets.json <<'EOF'
{
  "version": 6,
  "configurePresets": [
    {
      "name": "default",
      "displayName": "Default",
      "description": "Default configure preset",
      "generator": "Unix Makefiles",
      "binaryDir": "${sourceDir}/build"
    }
  ],
  "buildPresets": [
    {
      "name": "default",
      "displayName": "Default",
      "description": "Default build preset",
      "configurePreset": "default"
    }
  ]
}
EOF
```

Ensure a working `cmake` is first on `PATH` (the system `/usr/bin/cmake` on this machine may be too old or otherwise unsuitable — prepend `~/.venv312/bin` if so):

```bash
export PATH="$HOME/.venv312/bin:$PATH"
which cmake && cmake --version
```

Run the configure command from inside the throwaway project (only one `CMakePresets.json` exists, so no file picker appears; only one configure preset exists, so no preset picker appears either — confirm both are skipped):

```bash
/home/spraneis/dotfiles/scripts/pyscripts/.venv/bin/cmake-configure
```

Expected: `cmake --preset default` runs from `/tmp/cmake-preset-check`, printing normal CMake configure output and creating `/tmp/cmake-preset-check/build`.

Then run the build command the same way:

```bash
/home/spraneis/dotfiles/scripts/pyscripts/.venv/bin/cmake-build
```

Expected: `cmake --build --preset default` runs and completes (no targets to build, but exits 0).

Clean up the throwaway project:

```bash
rm -rf /tmp/cmake-preset-check
```

- [ ] **Step 10: Commit**

```bash
cd /home/spraneis/dotfiles
jj describe -m "feat: add cmake-configure/build/test commands"
```
