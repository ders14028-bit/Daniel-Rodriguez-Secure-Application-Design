const API_BASE = window.SECURE_API_BASE || "https://localhost:8443";

let authToken = "";

const output = document.getElementById("output");
const helloBtn = document.getElementById("helloBtn");

function log(message, data) {
  const row = data ? `${message}\n${JSON.stringify(data, null, 2)}\n` : `${message}\n`;
  output.textContent = `${row}${output.textContent}`;
}

async function callApi(path, method, body, includeAuth = false) {
  const headers = { "Content-Type": "application/json" };

  if (includeAuth && authToken) {
    headers.Authorization = `Bearer ${authToken}`;
  }

  const response = await fetch(`${API_BASE}${path}`, {
    method,
    headers,
    body: body ? JSON.stringify(body) : undefined,
  });

  const payload = await response.json();

  if (!response.ok) {
    throw new Error(payload.error || payload.message || "Error en la solicitud");
  }

  return payload;
}

document.getElementById("registerForm").addEventListener("submit", async (event) => {
  event.preventDefault();
  const username = document.getElementById("registerUsername").value.trim();
  const password = document.getElementById("registerPassword").value;

  try {
    const result = await callApi("/api/auth/register", "POST", { username, password });
    log("Registro exitoso", result);
  } catch (error) {
    log(`Registro falló: ${error.message}`);
  }
});

document.getElementById("loginForm").addEventListener("submit", async (event) => {
  event.preventDefault();
  const username = document.getElementById("loginUsername").value.trim();
  const password = document.getElementById("loginPassword").value;

  try {
    const result = await callApi("/api/auth/login", "POST", { username, password });
    authToken = result.token;
    helloBtn.disabled = false;
    log("Login exitoso", result);
  } catch (error) {
    log(`Login falló: ${error.message}`);
  }
});

helloBtn.addEventListener("click", async () => {
  try {
    const result = await callApi("/api/hello", "GET", null, true);
    log("Respuesta de endpoint protegido", result);
  } catch (error) {
    log(`Llamada protegida falló: ${error.message}`);
  }
});

log("Cliente cargado. Configura SECURE_API_BASE en js/config.js para AWS.", { API_BASE });
