# 1. Copy CSV to container
docker cp latest100flightversions.csv sqldb:/tmp/latest100flights.csv
docker exec sqldb bash -c "rm -f /tmp/flight_errors1.csv /tmp/flight_errors1.csv.Error.Txt"

# 2. Create import script (import.sql)
cat << 'EOF' > import.sql
-- Disable constraint temporarily

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;


-- Import data
BULK INSERT FlightVersion
FROM '/tmp/latest100flights.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 1,             -- Skip header row
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    ERRORFILE = '/tmp/flight_errors1.csv',
    TABLOCK
);
GO

-- Re-enable constraint
EOF

# 3. Copy script to container
docker cp import.sql sqldb:/tmp/import.sql

# 4. Execute import
docker exec sqldb /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P "YourStrong@Passw0rd" \
  -d ProductDB -C \
  -i /tmp/import.sql
