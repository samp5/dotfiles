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
