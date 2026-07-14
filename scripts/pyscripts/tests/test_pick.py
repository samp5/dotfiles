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
