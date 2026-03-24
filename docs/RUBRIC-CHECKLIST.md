# Rubric Checklist — Secure Application Design Workshop

Marca cada ítem cuando tengas evidencia (captura, comando, log o video).

## 1) Class Work (50%)

## 1.1 Participation & Collaboration (20%)
- [ ] Participé activamente en discusiones del diseño de arquitectura.
- [ ] Colaboré en actividades prácticas del laboratorio.
- [ ] Aporté decisiones/soluciones de seguridad justificadas.

## 1.2 Hands-on Lab Performance (30%)
- [ ] Desplegué la aplicación en AWS siguiendo guía técnica.
- [ ] Configuré Apache y Spring en **servidores separados**.
- [ ] Activé TLS para descarga cliente desde Apache.
- [ ] Activé TLS para solicitudes REST hacia Spring.
- [ ] Implementé login con almacenamiento hash de contraseñas.
- [ ] Generé/instalé certificados Let’s Encrypt en ambos servidores.
- [ ] Subí todo el código y documentación al repositorio GitHub.

---

## 2) Homework (50%)

## 2.1 Application Architecture Design (25%)
- [ ] Entregué documento de arquitectura detallado.
- [ ] Expliqué relación Apache ↔ cliente async ↔ Spring.
- [ ] Justifiqué estrategia de despliegue seguro en AWS.

## 2.2 Security Implementation (15%)
- [ ] Aplicación funcional cumpliendo requisitos de seguridad.
- [ ] TLS operativo en cliente, Apache y Spring.
- [ ] Login implementado con hash seguro de contraseñas.
- [ ] Certificados Let’s Encrypt configurados y vigentes.

## 2.3 Final Deliverables (10%)
- [ ] Repositorio GitHub completo con código fuente.
- [ ] README con instrucciones de despliegue.
- [ ] README/Docs con arquitectura y capturas de pruebas.
- [ ] Video demostrando despliegue y explicación de seguridad.

---

## 3) Evidencias sugeridas por criterio

- **TLS Apache:** captura navegador con candado + `https://app...`.
- **TLS Spring:** `curl -vk https://api...:8443/api/hello`.
- **Hash Password:** captura BD mostrando hash (no plaintext).
- **Separación de capas:** captura de estructura Controller/Service/Repository.
- **AWS seguro:** capturas de SG-Apache y SG-Spring.
- **Let’s Encrypt:** salida de `certbot certificates`.
