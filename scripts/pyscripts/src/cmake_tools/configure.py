"""Pick a configure preset from CMakePresets.json and run `cmake --preset`."""

from __future__ import annotations

from cmake_tools import _run


def main() -> None:
    _run.run("configure")


if __name__ == "__main__":
    main()
