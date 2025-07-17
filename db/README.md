# Pull and run SQL Server
docker run -d --name sql-server \
  -e "ACCEPT_EULA=Y" \
  -e "SA_PASSWORD=YourStrong@Passw0rd" \
  -e "MSSQL_PID=Developer" \
  -p 1433:1433 \
  mcr.microsoft.com/mssql/server:2022-latest

# Create database and table
docker exec sql-server /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P "YourStrong@Passw0rd" \
  -Q "CREATE DATABASE ProductDB; \
      CREATE TABLE ProductDB.dbo.Products ( \
        ID INT IDENTITY(1,1) PRIMARY KEY, \
        Name NVARCHAR(50), \
        Price DECIMAL(10,2) \
      ); \
      INSERT INTO ProductDB.dbo.Products (Name, Price) \
      VALUES ('Smartphone', 599.99), ('Tablet', 399.99);"