# 1. Pull base image
docker pull mcr.microsoft.com/dotnet/aspnet:7.0

# 2. Build API image
docker build -t my-api -f Dockerfile ./api

# 3. Create container and copy files
docker create --name api-temp my-api
docker cp api/app/ api-temp:/app/
docker commit api-temp my-api-final
docker rm api-temp

# 4. Run API container
docker run -d --name api-server \
  --link sql-server \
  -p 5000:80 \
  my-api-final


# Run in local docker in 80 and expose 5000 to external. 
# Make sure /api_app include all the source file just like in source code
docker run -d --name api -p 5000:80 -v /mnt/nvme_raid0/Galileo/api_app:/app -w /app --link sqldb mcr.microsoft.com/dotnet/sdk:7.0 dotnet run --urls "http://*:80"
