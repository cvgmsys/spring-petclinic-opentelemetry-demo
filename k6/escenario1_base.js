import http from 'k6/http';
import { check, sleep } from 'k6';

// Asumimos que el API Gateway está expuesto en localhost:8080
// Cámbialo si estás usando otro NodePort para tu frontend
const BASE_URL = 'http://localhost:30080';

export const options = {
  // Configuración de la Línea Base: 10 usuarios constantes durante 5 minutos
  vus: 10,
  duration: '5m',
  thresholds: {
    http_req_duration: ['p(95)<500'], // El 95% de las peticiones deben tardar menos de 500ms
  },
};

export default function () {
  // 1. Home (Petición al API Gateway)
  let res = http.get(`${BASE_URL}/`);
  check(res, { 'Home OK': (r) => r.status === 200 });
  sleep(1);

  // 2. Ver Veterinarios (Ataca al vets-service)
  res = http.get(`${BASE_URL}/api/vet/vets`);
  check(res, { 'Vets OK': (r) => r.status === 200 });
  sleep(2);

  // 3. Ver lista de dueños (Ataca al customers-service)
  res = http.get(`${BASE_URL}/api/customer/owners`);
  check(res, { 'Owners OK': (r) => r.status === 200 });
  sleep(2);
}