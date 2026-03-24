# Guía de Despliegue en AWS (Apache + Spring con TLS)

Esta guía sigue la práctica del workshop usando Amazon Linux 2023 y dos instancias EC2.

## 1) Prerrequisitos
- Cuenta AWS con permisos para EC2, Security Groups y Elastic IP.
- 2 dominios/subdominios DNS:
  - `app.tudominio.com` → Apache
  - `api.tudominio.com` → Spring
- Repositorio en GitHub con el código del cliente y backend.

---

## 2) Crear infraestructura EC2

## 2.1 Instancias
- **EC2-1 Apache**: Amazon Linux 2023, tipo `t2.micro` (o equivalente).
- **EC2-2 Spring**: Amazon Linux 2023, tipo `t2.micro` (o equivalente).

## 2.2 Security Groups

### SG-Apache
- Inbound:
  - `22/tcp` desde tu IP
  - `80/tcp` desde `0.0.0.0/0`
  - `443/tcp` desde `0.0.0.0/0`
- Outbound:
  - Todo permitido o al menos `8443/tcp` hacia SG-Spring

### SG-Spring
- Inbound:
  - `22/tcp` desde tu IP
  - `8443/tcp` **solo desde SG-Apache**
- Outbound:
  - Todo permitido (o restringido según necesidad)

## 2.3 DNS
- Asocia Elastic IP a cada instancia.
- Crea registros A:
  - `app.tudominio.com` → Elastic IP de Apache
  - `api.tudominio.com` → Elastic IP de Spring

---

## 3) Configurar Server 1 (Apache)

Conéctate por SSH a EC2-1.

```bash
sudo dnf update -y
sudo dnf install -y httpd mod_ssl git
sudo systemctl enable --now httpd
```

Despliega cliente estático en `/var/www/html`.

```bash
sudo rm -rf /var/www/html/*
sudo cp -r server1-apache/public_html/* /var/www/html/
```

Instala Certbot y genera certificado:

```bash
sudo dnf install -y certbot python3-certbot-apache
sudo certbot --apache -d app.tudominio.com --non-interactive --agree-tos -m tu-correo@dominio.com
```

Verifica renovación automática:

```bash
sudo systemctl status certbot-renew.timer
```

---

## 4) Configurar Server 2 (Spring Boot)

Conéctate por SSH a EC2-2.

```bash
sudo dnf update -y
sudo dnf install -y java-17-amazon-corretto git
```

Instala Maven (si no viene incluido):

```bash
sudo dnf install -y maven
```

Clona repositorio y compila:

```bash
git clone https://github.com/TU_USUARIO/TU_REPO.git
cd TU_REPO/server2-spring
mvn clean package -DskipTests
```

Obtén certificado para API con método standalone (puerto 80 temporal):

```bash
sudo dnf install -y certbot
sudo certbot certonly --standalone -d api.tudominio.com --non-interactive --agree-tos -m tu-correo@dominio.com
```

Convierte certificado a PKCS12 para Spring:

```bash
sudo openssl pkcs12 -export \
  -in /etc/letsencrypt/live/api.tudominio.com/fullchain.pem \
  -inkey /etc/letsencrypt/live/api.tudominio.com/privkey.pem \
  -out /home/ec2-user/keystore.p12 \
  -name spring \
  -passout pass:CAMBIA_ESTA_CLAVE
```

Configura variables de entorno de seguridad:

```bash
export SSL_KEY_STORE=/home/ec2-user/keystore.p12
export SSL_KEY_STORE_PASSWORD=CAMBIA_ESTA_CLAVE
export JWT_SECRET="CAMBIA_ESTE_SECRETO_LARGO"
export SERVER_PORT=8443
```

Ejecuta aplicación:

```bash
java -jar target/*.jar
```

---

## 5) Configuración mínima de Spring

`application.properties` (o variables equivalentes):

```properties
server.port=8443
server.ssl.enabled=true
server.ssl.key-store=${SSL_KEY_STORE}
server.ssl.key-store-password=${SSL_KEY_STORE_PASSWORD}
server.ssl.key-store-type=PKCS12
```

Seguridad esperada:
- PasswordEncoder BCrypt.
- Endpoints de login/registro públicos.
- Endpoints de negocio protegidos.
- CORS permitido solo para `https://app.tudominio.com`.

---

## 6) Configuración mínima del cliente asíncrono

En `app.js`, consumir API por HTTPS:

```javascript
const API_BASE = "https://api.tudominio.com:8443";

async function login(username, password) {
  const response = await fetch(`${API_BASE}/api/auth/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ username, password })
  });
  return await response.json();
}
```

---

## 7) Validación final del taller

1. Navegador abre `https://app.tudominio.com` con candado válido.
2. Cliente ejecuta login exitoso contra `https://api.tudominio.com:8443`.
3. Backend responde endpoint protegido con token válido.
4. Contraseñas almacenadas con hash BCrypt.
5. Evidencia de certificados Let’s Encrypt en ambos servidores.

---

## 8) Troubleshooting rápido

- **Certbot falla por DNS**: verifica que el dominio apunte a la Elastic IP correcta.
- **Handshake TLS falla en Spring**: revisa ruta/clave de `keystore.p12`.
- **CORS bloquea requests**: confirma origin exacto del Apache.
- **Conexión rechazada a 8443**: revisa SG-Spring y que la app esté escuchando en ese puerto.
