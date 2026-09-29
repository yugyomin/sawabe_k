import pandas as pd

import sawabe_k


def test_version():
    assert sawabe_k.__version__ == "0.1.0"


def test_excel_roundtrip(tmp_path):
    path = tmp_path / "sample.xlsx"
    df = pd.DataFrame({"案件": ["A", "B"], "件数": [3, 5]})
    df.to_excel(path, index=False)
    assert pd.read_excel(path).equals(df)
