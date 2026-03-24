# Final Deliverables Pack

Este documento define exactamente qué debes entregar para cumplir el taller.

## 1) Repositorio GitHub

Incluye como mínimo:
- Código de cliente (`HTML + JS asíncrono`) servido por Apache.
- Código backend (`Spring Boot REST + seguridad`).
- Configuración de despliegue/documentación.
- README principal con pasos reproducibles.

Estructura recomendada:

```text
.
├── server1-apache/
├── server2-spring/
├── docs/
│   ├── ARCHITECTURE.md
│   ├── AWS-DEPLOYMENT.md
│   ├── RUBRIC-CHECKLIST.md
│   └── DELIVERABLES.md
└── README.md
```

---

## 2) README requerido

Debe contener:
1. Objetivo del proyecto.
2. Arquitectura de 2 servidores y flujo de comunicación.
3. Prerrequisitos.
4. Pasos de despliegue en AWS.
5. Endpoints y prueba de login.
6. Medidas de seguridad implementadas.
7. Evidencias (capturas o links).
8. Enlace al video final.

---

## 3) Evidencias (capturas)

Sube en `docs/evidence/` (o incluye en informe):
- `01-apache-https.png` — Apache con candado.
- `02-spring-https-curl.png` — llamada TLS a Spring.
- `03-login-success.png` — login exitoso.
- `04-protected-endpoint.png` — endpoint protegido con token.
- `05-password-hash.png` — hash de contraseña almacenado.
- `06-security-groups.png` — reglas SG en AWS.
- `07-certbot-certificates.png` — certificados vigentes.

---

## 4) Video demostrativo

Duración recomendada: 5 a 10 minutos.

Guion mínimo:
1. Introducción rápida de arquitectura (Apache + Spring).
2. Mostrar AWS (instancias, SG, dominios).
3. Demostrar HTTPS en Apache.
4. Ejecutar flujo registro/login y endpoint protegido en Spring.
5. Mostrar que las contraseñas están hasheadas.
6. Mostrar certificados Let’s Encrypt y renovación.
7. Cierre con conclusiones de seguridad.

---

## 5) Criterios de aceptación final

Se considera completo cuando:
- [ ] El despliegue funciona en AWS con dos servidores separados.
- [ ] Hay TLS funcional en ambos servicios.
- [ ] Login y hash de contraseñas están implementados correctamente.
- [ ] El repositorio y README permiten reproducir la solución.
- [ ] El video explica y demuestra todos los requisitos de la rúbrica.
