"""Lint stdin using the file's SQLFluff configuration and a Postgres fallback.

Run with Mason's SQLFluff virtual-environment interpreter, not system Python.
The JSON output is consumed by nvim-lint's built-in SQLFluff parser.
"""

import json
import sys
from pathlib import Path

from sqlfluff.cli.commands import cli
from sqlfluff.core import FluffConfig


def main():
    filename = sys.argv[1] if len(sys.argv) > 1 else ""
    filename = str(Path(filename).resolve()) if filename else str(Path.cwd() / "untitled.sql")
    try:
        config = FluffConfig.from_path(str(Path(filename).parent), require_dialect=False)
        args = ["lint", "--format=json", "--disable-progress-bar", "--stdin-filename", filename, "-"]
        if not config.get("dialect"):
            args.extend(["--dialect", "postgres"])
        return cli.main(args=args, prog_name="sqlfluff", standalone_mode=False) or 0
    except Exception as error:  # noqa: BLE001 - report tool failures as JSON diagnostics
        # Surface configuration failures as a diagnostic rather than silently
        # clearing the buffer's warnings or returning a non-JSON traceback.
        print(json.dumps([{"filepath": filename, "violations": [{
            "code": "CFG", "description": str(error), "line_no": 1, "line_pos": 1,
        }]}]))
        return 2


if __name__ == "__main__":
    sys.exit(main())
