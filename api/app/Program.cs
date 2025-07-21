using Microsoft.Data.SqlClient;
using Dapper;
using System.Collections.Generic;

var builder = WebApplication.CreateBuilder(args);

// Add CORS policy
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", builder =>
    {
        builder
            .AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader();
    });
});

var app = builder.Build();

// Use CORS
app.UseCors("AllowAll");

// Get config
var config = new ConfigurationBuilder()
    .AddJsonFile("appsettings.json")
    .AddEnvironmentVariables()
    .Build();

app.MapGet("/products", async () => {
    try
    {
        var connStr = config.GetConnectionString("Default");
        Console.WriteLine($"Using connection string: {connStr}");
        
        using var conn = new SqlConnection(connStr);
        await conn.OpenAsync();
        
        var products = await conn.QueryAsync<Product>(
            "SELECT ProductID AS Id, ProductName AS Name, Price FROM Products");
        
        return Results.Ok(products);
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Error in /products: {ex.Message}");
        return Results.Problem($"Error retrieving products: {ex.Message}");
    }
});

app.MapGet("/flights", async () =>
{
    try
    {
        var connStr = config.GetConnectionString("Default");
        Console.WriteLine($"Using connection string: {connStr}");

        using var conn = new SqlConnection(connStr);
        await conn.OpenAsync();

        var flights = await conn.QueryAsync("SELECT * FROM Flight");
        return Results.Ok(flights);
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Error in /flights: {ex.Message}");
        return Results.Problem($"Error retrieving flights: {ex.Message}");
    }
});

app.Run();

public record Product(int Id, string Name, decimal Price);