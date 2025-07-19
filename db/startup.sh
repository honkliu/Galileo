#!/bin/bash

# Configuration
DATA_DIR="/mnt/nvme_raid0/Galileo/mssql/data"
SQLCMD_PATH="/opt/mssql-tools18/bin/sqlcmd"
SA_PASSWORD="YourStrong@Passw0rd"
CONTAINER_NAME="sqldb"

# Databases to create
DATABASES=("GalileoDB" "ProductDB")

# Cleanup previous container if exists
docker rm -f $CONTAINER_NAME 2>/dev/null

# Create data directory with proper permissions
sudo mkdir -p "$DATA_DIR"
sudo chown -R 10001:0 "$DATA_DIR"
sudo chmod 750 "$DATA_DIR"

# Start SQL Server container
echo "Starting SQL Server container..."
docker run -d \
  --name $CONTAINER_NAME \
  -e "ACCEPT_EULA=Y" \
  -e "MSSQL_SA_PASSWORD=$SA_PASSWORD" \
  -e "MSSQL_PID=Developer" \
  -v "$DATA_DIR:/var/opt/mssql/data" \
  -p 1433:1433 \
  mcr.microsoft.com/mssql/server:2022-latest

# Wait for SQL Server to initialize
echo -n "Waiting for SQL Server to start"
for i in {1..30}; do
  if docker exec $CONTAINER_NAME $SQLCMD_PATH -S localhost -U sa -P "$SA_PASSWORD" -C -Q "SELECT 1" &> /dev/null; then
    echo -e "\nSQL Server ready!"
    break
  fi
  echo -n "."
  sleep 1
done

# Create databases
for DB in "${DATABASES[@]}"; do
  docker exec $CONTAINER_NAME $SQLCMD_PATH -S localhost -U sa -P "$SA_PASSWORD" -C -Q "
  IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = '$DB')
  BEGIN
      CREATE DATABASE $DB;
      PRINT 'Database $DB created';
  END
  ELSE
      PRINT 'Database $DB already exists';
  "
done

# Configure GalileoDB
docker exec $CONTAINER_NAME $SQLCMD_PATH -S localhost -U sa -P "$SA_PASSWORD" -d GalileoDB -C -Q "
IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = 'Devices' AND type = 'U')
BEGIN
    CREATE TABLE Devices (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(50) NOT NULL,
        Type NVARCHAR(20) NOT NULL,
        CreatedAt DATETIME2 DEFAULT SYSDATETIME()
    );
    PRINT 'Table Devices created';
    
    INSERT INTO Devices (Name, Type) 
    VALUES ('Mainframe', 'Server'), ('Satellite', 'Sensor'), ('Drone', 'Mobile');
    PRINT 'Inserted sample devices';
END
ELSE
    PRINT 'Table Devices already exists';
"

# Configure ProductDB (for API/UI)
docker exec $CONTAINER_NAME $SQLCMD_PATH -S localhost -U sa -P "$SA_PASSWORD" -d ProductDB -C -Q "
IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = 'Products' AND type = 'U')
BEGIN
    CREATE TABLE Products (
        ProductID INT IDENTITY(1,1) PRIMARY KEY,
        ProductName NVARCHAR(100) NOT NULL,
        Price DECIMAL(10,2) NOT NULL,
        StockQuantity INT NOT NULL,
        Category NVARCHAR(50) NOT NULL,
        CreatedDate DATETIME2 DEFAULT SYSDATETIME(),
        LastUpdated DATETIME2 DEFAULT SYSDATETIME()
    );
    PRINT 'Table Products created';
    
    CREATE INDEX IX_Products_Category ON Products(Category);
    
    INSERT INTO Products (ProductName, Price, StockQuantity, Category) 
    VALUES 
        ('Laptop Pro', 1299.99, 25, 'Electronics'),
        ('Wireless Mouse', 29.99, 100, 'Accessories'),
        ('Bluetooth Headphones', 199.50, 40, 'Audio'),
        ('Office Chair', 399.00, 15, 'Furniture'),
        ('Desk Lamp', 45.75, 60, 'Home');
    PRINT 'Inserted sample products';
END
ELSE
    PRINT 'Table Products already exists';
"

# Show summary
echo -e "\nDatabase Summary:"

# Show all databases
docker exec $CONTAINER_NAME $SQLCMD_PATH -S localhost -U sa -P "$SA_PASSWORD" -C -Q "
SELECT 
    d.name AS DatabaseName,
    FORMAT(SUM(mf.size) * 8 / 1024.0, 'N1') + ' MB' AS Size
FROM sys.databases d
JOIN sys.master_files mf ON d.database_id = mf.database_id
GROUP BY d.name;
"

# Show GalileoDB devices
echo -e "\nGalileoDB Devices:"
docker exec $CONTAINER_NAME $SQLCMD_PATH -S localhost -U sa -P "$SA_PASSWORD" -d GalileoDB -C -Q "
SELECT TOP 3 ID, Name, Type, FORMAT(CreatedAt, 'yyyy-MM-dd HH:mm:ss') AS CreatedAt 
FROM Devices
" -s "," -W

# Show ProductDB products
echo -e "\nProductDB Products:"
docker exec $CONTAINER_NAME $SQLCMD_PATH -S localhost -U sa -P "$SA_PASSWORD" -d ProductDB -C -Q "
SELECT TOP 3 ProductID, ProductName, Price, StockQuantity, Category 
FROM Products
" -s "," -W

# Create API user
docker exec $CONTAINER_NAME $SQLCMD_PATH -S localhost -U sa -P "$SA_PASSWORD" -C -Q "
IF NOT EXISTS(SELECT * FROM sys.server_principals WHERE name = 'api_user')
BEGIN
    CREATE LOGIN api_user WITH PASSWORD = 'Secure@ApiPass123';
    PRINT 'Login api_user created';
    
    USE ProductDB;
    CREATE USER api_user FOR LOGIN api_user;
    ALTER ROLE db_datareader ADD MEMBER api_user;
    ALTER ROLE db_datawriter ADD MEMBER api_user;
    PRINT 'User api_user configured for ProductDB';
END
ELSE
    PRINT 'Login api_user already exists';
"

# Success message
echo -e "\n✅ Deployment successful!"
echo "Database files: $DATA_DIR"
echo "API Connection String: Server=localhost;Database=ProductDB;User=api_user;Password=Secure@ApiPass123;Encrypt=true;TrustServerCertificate=true"