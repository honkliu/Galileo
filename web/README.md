# 1. Pull Python image
docker pull python:3.11-slim

# 2. Create container
docker create --name web-temp python:3.11-slim

# 3. Copy files
docker cp web/index.html web-temp:/app/index.html
docker cp web/start-server.sh web-temp:/app/start-server.sh
docker commit web-temp my-web
docker rm web-temp

# 4. Run web server
docker run -d --name web-server \
  --link api-server \
  -p 6000:6000 \
  -w /app \
  my-web \
  sh start-server.sh