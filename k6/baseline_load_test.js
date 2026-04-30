import http from 'k6/http';
import { check, sleep } from 'k6';

// El API Gateway se expone en el puerto 30080
const BASE_URL = 'http://localhost:30080';

export const options = {
  vus: 5,
  duration: '10m', 
};

export default function () {
  // 1. Carga de la página principal
  let res = http.get(`${BASE_URL}/`);
  check(res, { 'Home OK': (r) => r.status === 200 });
  sleep(1);

  // 2. Consulta de la lista completa de veterinarios
  res = http.get(`${BASE_URL}/api/vet/vets`);
  check(res, { 'Vets OK': (r) => r.status === 200 });
  sleep(1);

  // 3. Consulta de la lista general de dueños
  res = http.get(`${BASE_URL}/api/customer/owners`);
  check(res, { 'Owners List OK': (r) => r.status === 200 });
  sleep(1);

  // 4. Consulta de dueños específicos
  let randomOwnerId = Math.floor(Math.random() * 10) + 1;
  res = http.get(`${BASE_URL}/api/customer/owners/${randomOwnerId}`);
  check(res, { 'Owner Details OK': (r) => r.status === 200 });
  sleep(2); // Simulamos que el usuario se queda leyendo un tiempo

  // 5. (Opcional pero recomendable) Consulta de tipos de mascotas 
  // Para enriquecer aún más las peticiones de base de datos
  res = http.get(`${BASE_URL}/api/customer/petTypes`);
  check(res, { 'Pet Types OK': (r) => r.status === 200 });
  sleep(1);
}