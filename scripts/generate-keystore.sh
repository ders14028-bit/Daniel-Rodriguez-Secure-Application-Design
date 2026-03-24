#!/usr/bin/env bash
set -euo pipefail

KEYSTORE_PATH=${KEYSTORE_PATH:-"./keystore.p12"}
KEY_ALIAS=${KEY_ALIAS:-"secureapp"}
KEYSTORE_PASSWORD=${SSL_KEY_STORE_PASSWORD:-"changeit"}
VALID_DAYS=${VALID_DAYS:-365}
DNAME=${DNAME:-"CN=localhost, OU=ECI, O=BASD, L=Bogota, ST=Cundinamarca, C=CO"}

rm -f "$KEYSTORE_PATH"

keytool -genkeypair \
  -alias "$KEY_ALIAS" \
  -keyalg RSA \
  -keysize 2048 \
  -storetype PKCS12 \
  -keystore "$KEYSTORE_PATH" \
  -validity "$VALID_DAYS" \
  -storepass "$KEYSTORE_PASSWORD" \
  -keypass "$KEYSTORE_PASSWORD" \
  -dname "$DNAME"

echo "PKCS12 generado en: $KEYSTORE_PATH"
