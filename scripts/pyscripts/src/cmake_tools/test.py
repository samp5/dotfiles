"""Pick a test preset from CMakePresets.json and run `ctest --preset`."""

from __future__ import annotations

from cmake_tools import _run


def main() -> None:
    _run.run("test")


if __name__ == "__main__":
    main()
