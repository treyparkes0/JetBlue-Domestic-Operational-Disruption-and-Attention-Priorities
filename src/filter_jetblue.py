"""Read each monthly BTS zip, keep JetBlue, and save one file.

The zip files belong in data/raw. Then run:

    python src/filter_jetblue.py

The new file is data/raw/jetblue_b6.csv. It stays on this computer.
"""

from pathlib import Path
import zipfile

import pandas as pd

RAW_FOLDER = Path(__file__).resolve().parent.parent / "data" / "raw"
OUTPUT_FILE = RAW_FOLDER / "jetblue_b6.csv"


def main() -> None:
    zip_files = sorted(
        RAW_FOLDER.glob("On_Time_Reporting_Carrier_On_Time_Performance_1987_present_*.zip")
    )
    if not zip_files:
        raise SystemExit(f"No monthly zip files found in {RAW_FOLDER}")

    if OUTPUT_FILE.exists():
        OUTPUT_FILE.unlink()

    total_rows = 0
    wrote_header = False

    for zip_path in zip_files:
        with zipfile.ZipFile(zip_path) as archive:
            csv_names = [name for name in archive.namelist() if name.lower().endswith(".csv")]
            flights = pd.read_csv(archive.open(csv_names[0]), dtype=str, low_memory=False)

        # B6 is JetBlue. strip() removes extra spaces around the code.
        jetblue = flights[flights["Reporting_Airline"].str.strip() == "B6"].copy()
        total_rows += len(jetblue)
        print(f"{zip_path.name}: {len(jetblue):,} JetBlue rows")

        jetblue.to_csv(OUTPUT_FILE, mode="a", header=not wrote_header, index=False)
        wrote_header = True

    saved = pd.read_csv(OUTPUT_FILE, usecols=["FlightDate", "Reporting_Airline"])
    print(f"Saved {total_rows:,} rows to {OUTPUT_FILE}")
    print("Carriers:", sorted(saved["Reporting_Airline"].dropna().unique()))
    print("Dates:", saved["FlightDate"].min(), "through", saved["FlightDate"].max())


if __name__ == "__main__":
    main()
