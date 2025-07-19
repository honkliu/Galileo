using Microsoft.Data.SqlClient;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Get config
var config = new ConfigurationBuilder()
    .AddJsonFile("appsettings.json")
    .AddEnvironmentVariables()
    .Build();

app.MapGet("/products", async () => {
    var connStr = config.GetConnectionString("Default");
    Console.WriteLine($"Using connection string: {connStr}");
    
    using var conn = new SqlConnection(connStr);
    await conn.OpenAsync();
    
    using var cmd = new SqlCommand("SELECT ProductID AS Id, ProductName AS Name, Price FROM Products", conn);
    using var reader = await cmd.ExecuteReaderAsync();
    
    var products = new List<Product>();
    while (await reader.ReadAsync()) 
    {
        products.Add(new Product(
            reader.GetInt32(0),
            reader.GetString(1),
            reader.GetDecimal(2)
        ));
    }
    
    return products;
});

app.Run();

public record Product(int Id, string Name, decimal Price);