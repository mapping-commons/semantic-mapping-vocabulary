# /// script
# requires-python = ">=3.14"
# dependencies = [
#     "pandas>=3.0.3",
# ]
# ///

import sys
from pathlib import Path

import pandas as pd

HERE = Path(__file__).parent.resolve()

if __name__ == '__main__':
    fail = False
    for path in HERE.glob("*.tsv"):
        original = path.read_text()
        corrected = pd.read_csv(path, sep="\t").to_csv(sep='\t', index=False)
        if original != corrected:
            print(f"TSV not formatted properly: {path}")
            fail = True
    sys.exit(1 if fail else 0)
