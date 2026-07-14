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
