# Demo Commands (Register → Login → Protected Endpoint)

Esta guía te permite demostrar rápidamente el flujo del taller.

## 1) Variables base

## PowerShell

```powershell
$API_BASE = "https://localhost:8443"
```

## Bash

```bash
API_BASE="https://localhost:8443"
```

---

## 2) Registrar usuario

## PowerShell

```powershell
$registerBody = @{ username = "demo"; password = "DemoPass123!" } | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri "$API_BASE/api/auth/register" -ContentType "application/json" -Body $registerBody -SkipCertificateCheck
```

## Bash

```bash
curl -k -X POST "$API_BASE/api/auth/register" \
  -H "Content-Type: application/json" \
  -d '{"username":"demo","password":"DemoPass123!"}'
```

---

## 3) Login y extraer token

## PowerShell

```powershell
$loginBody = @{ username = "demo"; password = "DemoPass123!" } | ConvertTo-Json
$loginResponse = Invoke-RestMethod -Method Post -Uri "$API_BASE/api/auth/login" -ContentType "application/json" -Body $loginBody -SkipCertificateCheck
$token = $loginResponse.token
$token
```

## Bash

```bash
TOKEN=$(curl -sk -X POST "$API_BASE/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"demo","password":"DemoPass123!"}' | sed -n 's/.*"token":"\([^"]*\)".*/\1/p')

echo "$TOKEN"
```

---

## 4) Consumir endpoint protegido

## PowerShell

```powershell
Invoke-RestMethod -Method Get -Uri "$API_BASE/api/hello" -Headers @{ Authorization = "Bearer $token" } -SkipCertificateCheck
```

## Bash

```bash
curl -k "$API_BASE/api/hello" \
  -H "Authorization: Bearer $TOKEN"
```

---

## 5) Demo en AWS

Cuando pases a AWS, cambia `API_BASE` por tu dominio real:

- `https://api.tudominio.com:8443`

Y en cliente Apache crea `server1-apache/public_html/js/config.js` con:

```javascript
window.SECURE_API_BASE = "https://api.tudominio.com:8443";
```
