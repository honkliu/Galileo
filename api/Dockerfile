FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY ./app ./
ENTRYPOINT ["dotnet", "app.dll"]