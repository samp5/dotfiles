"""Pick a build preset from CMakePresets.json and run `cmake --build --preset`."""

from __future__ import annotations

from cmake_tools import _run


def main() -> None:
    _run.run("build")


if __name__ == "__main__":
    main()
