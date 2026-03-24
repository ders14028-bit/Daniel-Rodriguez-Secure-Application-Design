# Enterprise Architecture Workshop — Secure Application Design

Repositorio guía para el taller de **diseño y despliegue seguro** con AWS, Apache y Spring.

## Objetivo del workshop

Diseñar e implementar una aplicación con dos servidores:

- **Server 1 (Apache):** entrega cliente HTML + JavaScript asíncrono por HTTPS.
- **Server 2 (Spring Boot):** expone API REST protegida por HTTPS.

Requisitos de seguridad clave:

- TLS en ambos servidores con certificados de Let’s Encrypt.
- Login seguro con contraseñas hasheadas (BCrypt).
- Comunicación cliente↔backend por canales cifrados.
- Despliegue en AWS con segmentación de red y puertos mínimos.

---

## Documentación del taller

- Arquitectura detallada: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- Guía de despliegue AWS + TLS: [docs/AWS-DEPLOYMENT.md](docs/AWS-DEPLOYMENT.md)
- Checklist según rúbrica: [docs/RUBRIC-CHECKLIST.md](docs/RUBRIC-CHECKLIST.md)
- Paquete de entregables: [docs/DELIVERABLES.md](docs/DELIVERABLES.md)
- Comandos demo (register/login/hello): [docs/DEMO-COMMANDS.md](docs/DEMO-COMMANDS.md)
- Validación paso a paso completa: [docs/STEP-BY-STEP-VALIDATION.md](docs/STEP-BY-STEP-VALIDATION.md)

---

## Estructura actual del proyecto

```text
.
├── server1-apache/
│   ├── public_html/
│   │   ├── index.html
│   │   ├── css/style.css
│   │   └── js/app.js
│   └── secureapp.conf
├── server2-spring/
│   ├── pom.xml
│   └── src/main/java/com/eci/secureapp/
│       ├── config/SecurityConfig.java
│       ├── controller/{AuthController,HelloController}.java
│       ├── dto/{AuthRequest,AuthResponse}.java
│       ├── model/AppUser.java
│       ├── repository/UserRepository.java
│       ├── security/{JwtUtil,JwtAuthFilter}.java
│       ├── service/{AuthService,UserDetailsServiceImpl}.java
│       └── SecureAppApplication.java
├── scripts/
│   ├── generate-keystore.sh
│   └── deploy-aws.sh
└── docs/
```

---

## Arquitectura (resumen)

```text
Browser ──HTTPS:443──► Apache (EC2 #1) ──HTTPS:8443──► Spring Boot (EC2 #2)
```

Flujo:
1. Apache sirve cliente estático por TLS.
2. Cliente asíncrono consume API Spring por TLS.
3. Spring valida credenciales y contraseñas hasheadas.
4. API protegida responde solo con autenticación válida.

---

## Rubric Mapping (resumen)

- **Class Work (50%)**
  - Participación y colaboración (20%).
  - Despliegue funcional con Apache + Spring + TLS + login hash (30%).
- **Homework (50%)**
  - Documento de arquitectura (25%).
  - Implementación de seguridad completa (15%).
  - Entregables finales en GitHub + video (10%).

Usa [docs/RUBRIC-CHECKLIST.md](docs/RUBRIC-CHECKLIST.md) para validar cada criterio.

---

## Ejecución local rápida

Antes de iniciar, copia `.env.example` a `.env` y ajusta valores.

### 1) Backend Spring (HTTP o HTTPS local)

En `server2-spring/`:

```bash
mvn clean package
```

Para HTTP local (rápido):

```bash
set SERVER_SSL_ENABLED=false
set JWT_SECRET=CAMBIA_ESTE_SECRETO_LARGO
java -jar target\secureapp-0.0.1-SNAPSHOT.jar
```

Para HTTPS local:

```bash
set SSL_KEY_STORE_PASSWORD=changeit
bash scripts/generate-keystore.sh
set SERVER_SSL_ENABLED=true
set SSL_KEY_STORE=keystore.p12
set SSL_KEY_STORE_PASSWORD=changeit
set JWT_SECRET=CAMBIA_ESTE_SECRETO_LARGO
set APP_ORIGINS=http://localhost:8080,https://localhost:8080
java -jar target\secureapp-0.0.1-SNAPSHOT.jar
```

### 2) Cliente Apache (prueba local rápida)

Sirve `server1-apache/public_html/` con cualquier servidor estático.

Ejemplo:

```bash
cd server1-apache/public_html
python -m http.server 8080
```

Luego abre `http://localhost:8080` y verifica login + `/api/hello`.

---

## Referencias

- AWS Amazon Linux 2023 LAMP: https://docs.aws.amazon.com/linux/al2023/ug/ec2-lamp-amazon-linux-2023.html
- Tutorial de clase: TallerAllSecureAppSpring

---

## Autor

Nombre del estudiante / equipo — ECI
