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
