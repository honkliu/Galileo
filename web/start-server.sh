#!/bin/sh
echo "Starting web server at http://localhost:6000"
python3 -m http.server 6000

docker run -d -p 8088:80   --name web   -v "/home/azureuser/shuguanl/gitroot/Galileo/web/build:/usr/share/nginx/html"  -v "/home/azureuser/shuguanl/gitroot/Galileo/web/nginx.conf:/etc/nginx/nginx.conf"  nginx:alpine