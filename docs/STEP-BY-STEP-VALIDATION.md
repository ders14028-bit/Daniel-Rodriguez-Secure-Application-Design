# Paso por paso — Validación completa del taller

Usa esta guía para probar exactamente lo que pide la rúbrica.

## 0) Lo que ya quedó validado en este entorno

- [x] Backend compila correctamente (`mvn -DskipTests compile`).
- [x] Prueba automática de hash de contraseña (`AuthServiceSecurityTest`).
- [x] Endpoint protegido responde 403 sin token (seguridad activa).
- [x] Flujo completo: register → login → `/api/hello` con token.

---

## 1) Prueba local del backend (requisito: login + hash + endpoint protegido)

En `server2-spring`:

```bash
mvn -DskipTests package
```

Opción recomendada (evita conflictos de puerto automáticamente):

```powershell
./scripts/run-local-backend.ps1
```

Si PowerShell bloquea scripts por política de ejecución, úsalo así:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run-local-backend.ps1
```

Este script:
- mata el proceso que esté ocupando `8443`,
- compila si falta el `.jar`,
- configura variables de entorno,
- y levanta Spring con TLS local.

Levantar backend (HTTPS local):

```powershell
$env:SERVER_SSL_ENABLED='true'
$env:SSL_KEY_STORE='keystore.p12'
$env:SSL_KEY_STORE_PASSWORD='changeit'
$env:JWT_SECRET='THIS_IS_A_DEMO_SECRET_WITH_MORE_THAN_32_CHARACTERS'
$env:APP_ORIGINS='http://localhost:8080,https://localhost:8080'
java -jar target\secureapp-0.0.1-SNAPSHOT.jar
```

Si aparece `Port 8443 was already in use`, libera el puerto:

```powershell
$conn = Get-NetTCPConnection -LocalPort 8443 -State Listen -ErrorAction SilentlyContinue
if ($null -ne $conn) {
  Stop-Process -Id $conn[0].OwningProcess -Force
}
```

### 1.1 Validar que endpoint protegido bloquea sin token

```powershell
curl.exe -k -i https://localhost:8443/api/hello
```

Resultado esperado: `403 Forbidden`.

### 1.2 Registrar usuario

```powershell
$payloadPath = Join-Path $PWD 'auth-payload.json'
Set-Content -Path $payloadPath -Value '{"username":"demo_local","password":"DemoPass123!"}' -NoNewline

curl.exe -k -X POST https://localhost:8443/api/auth/register `
  -H "Content-Type: application/json" `
  --data-binary "@$payloadPath"
```

Resultado esperado: JSON con `token` y `username`.

### 1.3 Login

```powershell
$login = curl.exe -k -s -X POST https://localhost:8443/api/auth/login `
  -H "Content-Type: application/json" `
  --data-binary "@$payloadPath"
$token = ($login | ConvertFrom-Json).token
$token
```

Resultado esperado: token JWT no vacío.

### 1.4 Consumir endpoint protegido con token

```powershell
curl.exe -k https://localhost:8443/api/hello -H "Authorization: Bearer $token"
Remove-Item $payloadPath -Force
```

Resultado esperado: mensaje exitoso + `user`.

---

## 2) Evidencia de hash de contraseña (requisito explícito)

Ejecuta test de seguridad:

```bash
mvn -Dtest=AuthServiceSecurityTest test
```

Qué demuestra:
- la contraseña guardada **no** es igual al texto plano.
- el hash sí valida con BCrypt (`matches == true`).

Captura sugerida: salida `BUILD SUCCESS` + nombre del test.

---

## 3) Prueba del cliente asíncrono (requisito async HTML+JS)

Levanta cliente estático:

```powershell
cd server1-apache/public_html
python -m http.server 8080
```

Archivo `server1-apache/public_html/js/config.js` para local:

```javascript
window.SECURE_API_BASE = "https://localhost:8443";
```

Abre `http://localhost:8080` y valida:
1. Registro desde formulario.
2. Login desde formulario.
3. Botón de endpoint protegido responde correctamente.

Capturas sugeridas:
- pantalla de login exitoso.
- respuesta del endpoint en el panel de salida.

---

## 4) Prueba en AWS (requisito: Apache y Spring en servidores separados + TLS con Let’s Encrypt)

Sigue: [AWS-DEPLOYMENT.md](AWS-DEPLOYMENT.md)

Checklist mínimo en AWS:
- [ ] EC2 Apache y EC2 Spring separadas.
- [ ] SG-Spring permite `8443` solo desde SG-Apache.
- [ ] `https://app.tudominio.com` con candado válido.
- [ ] `https://api.tudominio.com:8443` con TLS válido.
- [ ] Login + endpoint protegido funcionando en entorno AWS.
- [ ] Certificados Let’s Encrypt emitidos en ambos servidores.

Comando evidencia certificados:

```bash
sudo certbot certificates
```

---

## 5) Evidencias exactas para entregar

Guárdalas en `docs/evidence/` con nombres:
- `01-apache-https.png`
- `02-spring-https-curl.png`
- `03-login-success.png`
- `04-protected-endpoint.png`
- `05-password-hash-test.png`
- `06-security-groups.png`
- `07-certbot-certificates.png`

---

## 6) Cierre de rúbrica

Antes de entregar, marca todo en:
- [RUBRIC-CHECKLIST.md](RUBRIC-CHECKLIST.md)
- [DELIVERABLES.md](DELIVERABLES.md)
