# /// script
# requires-python = ">=3.14"
# dependencies = [
#     "pandas>=3.0.3",
#     "click",
# ]
# ///

import sys
from pathlib import Path

import click
import pandas as pd

HERE = Path(__file__).parent.resolve()


@click.command()
@click.option("--fix", is_flag=True)
def main(fix: bool) -> None:
    fail = False
    for path in HERE.glob("*.tsv"):
        original = path.read_text()
        actual = pd.read_csv(path, sep="\t", dtype=str)
        for column in actual.columns:
            actual[column] = actual[column].map(str.strip, na_action="ignore")
        if fix:
            actual.to_csv(path, index=False, sep="\t")
        corrected = actual.to_csv(sep="\t", index=False)
        if original != corrected:
            print(f"TSV not formatted properly: {path}")
            fail = True
    sys.exit(1 if fail else 0)


if __name__ == "__main__":
    main()
