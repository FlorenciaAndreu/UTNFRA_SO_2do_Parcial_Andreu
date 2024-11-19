#!/bin/bash

cd UTN-FRA_SO_Examenes/202406/docker || exit 1

cat > index.html <<EOL
<div>
  <h1> Sistemas Operativos - UTNFRA </h1></br>
  <h2> 2do Parcial - Noviembre 2024 </h2> </br>
  <h3> Florencia Belen Andreu </h3>
  <h3> División: 115 </h3>
</div>
EOL

cat > Dockerfile <<EOL
FROM nginx:latest

COPY index.html /usr/share/nginx/html/index.html
EOL

docker build -t web1-andreu .

docker tag web1-andreu florandreu/web1-andreu:latest
docker push florandreu/web1-andreu:latest

docker run -d -p 8080:80 florandreu/web1-andreu:latest

