# CMake preset runner — design spec

Date: 2026-07-14

## Purpose

Provide three fzf-driven commands — `cmake-configure`, `cmake-build`, `cmake-test`
— that locate a repo's `CMakePresets.json`, let the user pick the right preset
for the mode at hand, and run the corresponding `cmake`/`ctest` invocation. This
replaces manually hunting for preset names and `cd`-ing into the right
directory before running `cmake --preset ...` by hand.

## Package layout

New `cmake_tools` package under `pyscripts/src/`, alongside the existing
`tmux_tools` and `meta_tools` packages:

```
pyscripts/src/cmake_tools/
  __init__.py
  _presets.py      # shared logic (see below)
  configure.py     # main() -> resolve + exec `cmake --preset <name>`
  build.py         # main() -> resolve + exec `cmake --build --preset <name>`
  test.py          # main() -> exec `ctest --preset <name>`
```

Three entry points added to `pyscripts/pyproject.toml`:

```toml
cmake-configure = "cmake_tools.configure:main"
cmake-build = "cmake_tools.build:main"
cmake-test = "cmake_tools.test:main"
```

...and matching entries added to `pyscripts/scripts.json` (name, description,
`.venv/bin/<name>` path) so they appear in the existing `run-script` picker.

Each command takes **no flags of its own** — every CLI argument passed to it is
forwarded verbatim to the underlying `cmake`/`ctest` invocation, e.g.
`cmake-build -j8` → `cmake --build --preset <name> -j8`.

`cmake_tools` reuses `tmux_tools._util` for its fzf picker (same dependency
`meta_tools.run_script` already has): if `$TMUX` is set, show the picker in a
floating tmux popup via `_util.popup_pick`; otherwise fall back to
`_util.pick_inline`. Only the picker runs in the popup — it closes before the
resolved cmake/ctest command executes, so that command's output streams into
the real pane/terminal the user invoked the command from.

## Repo root discovery

Starting at `os.getcwd()`, walk up the directory tree looking for a `.git` or
`.jj` entry (file or directory — `.git` can be a file in worktrees/submodules)
at each ancestor. If the filesystem root is reached with no match, print an
error to stderr and exit non-zero:

```
error: not inside a git or jj repository
```

## CMakePresets.json discovery

From the repo root, `os.walk` the full tree collecting every file named
exactly `CMakePresets.json`. To keep this fast and avoid stray copies inside
generated output, skip descending into any directory named `.git`, `.jj`,
`.venv`, `venv`, `node_modules`, `__pycache__`, or matching `build*`
(case-insensitive glob on the directory name).

- **Zero matches** → error to stderr, exit non-zero:
  `error: no CMakePresets.json found under <root>`.
- **One match** → use it directly, no picker shown.
- **Multiple matches** → fzf dialog listing each file's path relative to the
  repo root; picking one selects that file. Cancelling exits quietly
  (exit code 0, no output).

## Parsing & merging presets

Given the chosen `CMakePresets.json` path:

1. Load it with `json.loads`.
2. Resolve `"include"` entries (schema v4+): each listed path is relative to
   the including file's directory. Recursively load included files the same
   way, and concatenate their `configurePresets`/`buildPresets`/`testPresets`
   arrays into the accumulated set, depth-first, matching CMake's own
   resolution order.
3. If a `CMakeUserPresets.json` file exists next to the *originally chosen*
   `CMakePresets.json`, load it the same way (its own `include`s resolved
   too) and merge its preset arrays in as well — CMake requires
   `CMakeUserPresets.json` to include the base file, so its presets are
   treated as strictly additive on top.
4. Deduplicate by `name` within each preset-type array: if the same `name`
   appears more than once across the merged sources, the **last** one loaded
   wins (matches CMake's override semantics for redefinition via includes).
5. Drop any preset with `"hidden": true` from the final visible set — hidden
   presets exist only as inheritance bases and can never be selected/run.
6. For each remaining visible preset, resolve `displayName` and `description`
   if not defined directly on the preset itself: walk the `"inherits"` chain
   (which may be a string or a list of strings; walk depth-first, first
   match found wins) across the *full* merged preset set (including hidden
   ones, since bases are usually hidden) until a value is found or the chain
   is exhausted.
7. `"condition"` is **not** evaluated — presets that CMake would normally
   disable on the current platform are still listed. This is a known,
   documented limitation (noted in the module docstring), acceptable since
   parsing is done independently of the installed cmake's own condition
   evaluator.

## Mode → preset-array mapping

| Command          | Preset array       | Command executed                                  |
|------------------|---------------------|----------------------------------------------------|
| `cmake-configure` | `configurePresets` | `cmake --preset <name> <passthrough args...>`       |
| `cmake-build`     | `buildPresets`     | `cmake --build --preset <name> <passthrough args...>` |
| `cmake-test`      | `testPresets`      | `ctest --preset <name> <passthrough args...>`       |

If the mapped array is empty after hidden-filtering, print an error to stderr
and exit non-zero, e.g.: `error: no build presets found in <path>`.

## fzf dialog format

Each visible preset renders as one line:

```
<name padded>  —  <displayName>  —  <description>
```

(matching the em-dash-separated style already used in `layout_picker.py`),
with the bare `name` as the fzf search/match field (`--nth=1`,
`--with-nth=2..`, same convention as the rest of `pyscripts`). Missing
`displayName`/`description` render as empty rather than erroring.

Cancelling the picker (fzf exit code 130, or empty output) exits the command
quietly with exit code 0.

## Execution

On a successful pick, `cwd` is set to the **directory containing the chosen
`CMakePresets.json`** (not necessarily the repo root — CMake presets are
relative to that file's directory), and the process replaces itself via
`os.execvp` into the mapped command from the table above, with all of the
wrapper's own `sys.argv[1:]` appended as passthrough arguments. Using
`execvp` (rather than `subprocess.run`) means signal handling, stdio, and the
exit code all behave exactly as if the user had typed the `cmake`/`ctest`
command directly.

## Known limitations (out of scope for v1)

- `condition` fields are not evaluated; platform-inapplicable presets are
  still listed.
- No caching/remembering of the last-used preset per mode.
- `packagePresets` and `workflowPresets` (newer preset types) are not
  supported — only configure/build/test.

## Testing plan

No existing test suite exists in `pyscripts/`. Add `pytest` as a dev
dependency and a `tests/` directory covering the pure-logic pieces in
`_presets.py` (root discovery, discovery/skip-list walking, include +
CMakeUserPresets.json merging, hidden filtering, inherits resolution for
displayName/description, dedup-by-name-last-wins) against small fixture
JSON files/directory trees under `tests/fixtures/`. The fzf-picking and
`os.execvp` invocation are thin enough to verify manually (per the `verify`
skill) against a real sample CMake project rather than unit-tested.
