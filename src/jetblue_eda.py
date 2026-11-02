import pandas as pd
from pathlib import Path

file_path = Path(r"C:\Users\treyp\JetBlue-Operations-Analytics\data\raw\jetblue_b6.csv")
clean_path = Path(r"C:\Users\treyp\JetBlue-Operations-Analytics\data\raw\jetblue_b6_clean.csv")

df = pd.read_csv(file_path, low_memory=False)
print("Loaded:", df.shape)

# Keep the columns this project uses. Drop the rest.
keep = [
    "Year", "Month", "DayofMonth", "DayOfWeek", "FlightDate",
    "Reporting_Airline", "DOT_ID_Reporting_Airline",
    "IATA_CODE_Reporting_Airline", "Flight_Number_Reporting_Airline",
    "OriginAirportID", "Origin", "OriginCityName", "OriginState",
    "DestAirportID", "Dest", "DestCityName", "DestState",
    "CRSDepTime", "DepTime", "DepDelay", "DepDelayMinutes", "DepDel15",
    "CRSArrTime", "ArrTime", "ArrDelay", "ArrDelayMinutes", "ArrDel15",
    "Cancelled", "CancellationCode", "Diverted",
    "Flights", "Distance",
    "CarrierDelay", "WeatherDelay", "NASDelay",
    "SecurityDelay", "LateAircraftDelay",
]
df = df[keep]
print("After choosing columns:", df.shape)

# Clock fields look like 0700. Store minutes after midnight in a new column.
# 2400 means midnight, so those rows become 0. Blanks stay missing.
clock_columns = ["CRSDepTime", "DepTime", "CRSArrTime", "ArrTime"]
for column in clock_columns:
    hhmm = pd.to_numeric(df[column], errors="coerce")
    df[column + "_minutes"] = (hhmm // 100) * 60 + (hhmm % 100)
    df.loc[hhmm == 2400, column + "_minutes"] = 0

# These are already minute counts. Make them numbers and leave blanks missing.
minute_columns = [
    "DepDelay", "DepDelayMinutes", "ArrDelay", "ArrDelayMinutes",
    "DepDel15", "ArrDel15", "Cancelled", "Diverted", "Flights", "Distance",
    "CarrierDelay", "WeatherDelay", "NASDelay",
    "SecurityDelay", "LateAircraftDelay",
]
for column in minute_columns:
    df[column] = pd.to_numeric(df[column], errors="coerce")

df["FlightDate"] = pd.to_datetime(df["FlightDate"], errors="coerce")

print("\n--- DATA QUALITY ---")

row_count = len(df)
print("Rows:", row_count)
if row_count == 2110783:
    print("PASS row count matches the audit")
else:
    print("FAIL row count. Expected 2110783")

carriers = df["Reporting_Airline"].dropna().unique()
print("Carriers:", sorted(carriers))
if list(carriers) == ["B6"]:
    print("PASS only JetBlue")
else:
    print("FAIL a carrier other than B6 is in the file")

print("Earliest flight:", df["FlightDate"].min())
print("Latest flight:", df["FlightDate"].max())
missing_dates = df["FlightDate"].isna().sum()
print("Missing dates:", missing_dates)
if missing_dates == 0 and str(df["FlightDate"].min().date()) == "2018-01-01" and str(df["FlightDate"].max().date()) == "2026-07-31":
    print("PASS dates run from 2018-01-01 through 2026-07-31")
else:
    print("FAIL date range")

flight_key = [
    "FlightDate",
    "Flight_Number_Reporting_Airline",
    "Origin",
    "Dest",
    "CRSDepTime",
]
duplicate_keys = df.duplicated(subset=flight_key).sum()
print("Duplicate flight keys:", duplicate_keys)
if duplicate_keys == 0:
    print("PASS no duplicate flight keys")
else:
    print("FAIL duplicate flight keys")

print("\nMissing values in kept columns:")
print(df.isnull().sum().sort_values(ascending=False).head(15))

print("\nClock sample:")
print(df[["CRSDepTime", "CRSDepTime_minutes"]].head())

bad_clocks = 0
for column in clock_columns:
    minutes = df[column + "_minutes"]
    too_small = (minutes < 0).sum()
    too_big = (minutes >= 24 * 60).sum()
    bad_clocks = bad_clocks + too_small + too_big
    print(column + "_minutes out of range:", too_small + too_big)

if bad_clocks == 0:
    print("PASS clock minutes are between 0 and 1439, or missing")
else:
    print("FAIL a clock time is outside a normal day")

cancelled_count = (df["Cancelled"] == 1).sum()
diverted_count = ((df["Diverted"] == 1) & (df["Cancelled"] == 0)).sum()
print("Cancelled flights:", cancelled_count)
print("Diverted and not cancelled:", diverted_count)
if cancelled_count == 50674 and diverted_count == 7288:
    print("PASS cancelled and diverted counts match the audit")
else:
    print("FAIL cancelled or diverted count")

df.to_csv(clean_path, index=False)
print("\nSaved cleaned file to", clean_path)

print("\n--- EXPLORATORY CHECKS ---")

df["operated"] = (df["Cancelled"] == 0) & (df["Diverted"] == 0)
df["late_arrival"] = df["operated"] & (df["ArrDel15"] == 1)
df["diverted_only"] = (df["Diverted"] == 1) & (df["Cancelled"] == 0)
df["operated_delay_minutes"] = 0.0
df.loc[df["operated"], "operated_delay_minutes"] = df.loc[df["operated"], "ArrDelayMinutes"]

monthly = df.groupby(["Year", "Month"], as_index=False).agg(
    flights=("FlightDate", "size"),
    operated=("operated", "sum"),
    late_arrivals=("late_arrival", "sum"),
    cancellations=("Cancelled", "sum"),
    diversions=("diverted_only", "sum"),
    arrival_delay_minutes=("operated_delay_minutes", "sum"),
)
monthly["late_arrival_rate"] = monthly["late_arrivals"] / monthly["operated"]
monthly["cancellation_rate"] = monthly["cancellations"] / monthly["flights"]
monthly["diversion_rate"] = monthly["diversions"] / monthly["flights"]

print("\nMonthly rates. Read 2020 on its own. 2026 is January through July.")
print(monthly.round(3).to_string(index=False))

calendar = df.groupby("Month", as_index=False).agg(
    flights=("FlightDate", "size"),
    operated=("operated", "sum"),
    late_arrivals=("late_arrival", "sum"),
    cancellations=("Cancelled", "sum"),
    arrival_delay_minutes=("operated_delay_minutes", "sum"),
)
calendar["late_arrival_rate"] = calendar["late_arrivals"] / calendar["operated"]
calendar["cancellation_rate"] = calendar["cancellations"] / calendar["flights"]
print("\nCalendar month, all years together, including 2020.")
print(calendar.round(3).to_string(index=False))

origin = df.groupby(["Origin", "OriginCityName"], as_index=False).agg(
    flights=("FlightDate", "size"),
    operated=("operated", "sum"),
    late_arrivals=("late_arrival", "sum"),
    arrival_delay_minutes=("operated_delay_minutes", "sum"),
)
origin = origin[origin["flights"] >= 1000]
origin["late_arrival_rate"] = origin["late_arrivals"] / origin["operated"]
origin = origin.sort_values("arrival_delay_minutes", ascending=False)
print("\nOrigin airports with at least 1,000 flights, ranked by arrival-delay minutes.")
print(origin.round(3).to_string(index=False))

route = df.groupby(["Origin", "Dest"], as_index=False).agg(
    flights=("FlightDate", "size"),
    operated=("operated", "sum"),
    late_arrivals=("late_arrival", "sum"),
    cancellations=("Cancelled", "sum"),
    arrival_delay_minutes=("operated_delay_minutes", "sum"),
)
route = route[route["flights"] >= 500]
route["late_arrival_rate"] = route["late_arrivals"] / route["operated"]
route["cancellation_rate"] = route["cancellations"] / route["flights"]
route = route.sort_values("arrival_delay_minutes", ascending=False)
print("\nDirected routes with at least 500 flights, ranked by arrival-delay minutes.")
print(route.head(25).round(3).to_string(index=False))

late = df[df["ArrDel15"] == 1]
cause_columns = [
    "CarrierDelay",
    "LateAircraftDelay",
    "NASDelay",
    "WeatherDelay",
    "SecurityDelay",
]
print("\nDelay-cause minutes on late arrivals only. Blanks stay out of the sum.")
print("Late arrivals:", len(late))
for column in cause_columns:
    print(column, late[column].sum())
print(
    "Controllable minutes (carrier + late aircraft):",
    late["CarrierDelay"].sum() + late["LateAircraftDelay"].sum(),
)

day_name = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday",
}
weekday = df.groupby("DayOfWeek", as_index=False).agg(
    flights=("FlightDate", "size"),
    operated=("operated", "sum"),
    late_arrivals=("late_arrival", "sum"),
    cancellations=("Cancelled", "sum"),
    arrival_delay_minutes=("operated_delay_minutes", "sum"),
)
weekday["day"] = weekday["DayOfWeek"].map(day_name)
weekday["late_arrival_rate"] = weekday["late_arrivals"] / weekday["operated"]
weekday["cancellation_rate"] = weekday["cancellations"] / weekday["flights"]
weekday["avg_arrival_delay_minutes"] = weekday["arrival_delay_minutes"] / weekday["operated"]
print("\nDay of week, Monday through Sunday. All years pooled, including 2020.")
print(weekday.round(3).to_string(index=False))

cancelled = df[df["Cancelled"] == 1].copy()
cancelled["code"] = cancelled["CancellationCode"].fillna("Unknown").replace("", "Unknown")
print("\nCancellation codes on cancelled flights only.")
print("Cancelled flights:", len(cancelled))
print(cancelled["code"].value_counts(dropna=False).to_string())
print("\nCancellation codes by year.")
print(cancelled.groupby(["Year", "code"]).size().unstack(fill_value=0).to_string())
print("\nCancellation codes by calendar month, all years pooled, including 2020.")
print(cancelled.groupby(["Month", "code"]).size().unstack(fill_value=0).to_string())

