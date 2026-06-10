from pathlib import Path

import pandas as pd

HERE = Path(__file__).parent.resolve()

if __name__ == '__main__':
    for path in HERE.glob("*.tsv"):
        pd.read_csv(path, sep="\t").to_csv(path, sep='\t', index=False)
