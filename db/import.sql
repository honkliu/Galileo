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
