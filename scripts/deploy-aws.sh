#!/usr/bin/env bash
set -euo pipefail

ROLE=${1:-}

if [[ -z "$ROLE" ]]; then
  echo "Uso: ./scripts/deploy-aws.sh <server1|server2>"
  exit 1
fi

if [[ "$ROLE" == "server1" ]]; then
  sudo dnf update -y
  sudo dnf install -y httpd mod_ssl git
  sudo systemctl enable --now httpd

  sudo mkdir -p /var/www/html
  sudo cp -r server1-apache/public_html/* /var/www/html/

  echo "Instala certificado para Apache manualmente con certbot:"
  echo "sudo dnf install -y certbot python3-certbot-apache"
  echo "sudo certbot --apache -d app.tudominio.com"
  echo "Server1 listo."
  exit 0
fi

if [[ "$ROLE" == "server2" ]]; then
  sudo dnf update -y
  sudo dnf install -y java-17-amazon-corretto maven git

  pushd server2-spring > /dev/null
  mvn clean package -DskipTests

  echo "Configura variables antes de ejecutar el jar:"
  echo "export SERVER_SSL_ENABLED=true"
  echo "export SSL_KEY_STORE=/home/ec2-user/keystore.p12"
  echo "export SSL_KEY_STORE_PASSWORD=CAMBIA_ESTA_CLAVE"
  echo "export JWT_SECRET=CAMBIA_ESTE_SECRETO"
  echo "export APP_ORIGIN=https://app.tudominio.com"
  echo "java -jar target/*.jar"
  popd > /dev/null

  echo "Server2 listo."
  exit 0
fi

echo "Rol inválido: $ROLE"
exit 1
