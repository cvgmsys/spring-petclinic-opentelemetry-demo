import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE_URL = 'http://localhost:30080';

// Configuramos fases para simular un tráfico realista
export const options = {
  stages: [
    { duration: '1m', target: 5 }, // Minuto 0-1: Entran los usuarios poco a poco
    { duration: '8m', target: 5 }, // Minuto 1-9: Se mantienen navegando
    { duration: '1m', target: 0 }, // Minuto 9-10: Se van yendo de la web
  ],
};

// Función para simular pausas humanas impredecibles
function randomSleep(min, max) {
  sleep(Math.random() * (max - min) + min);
}

export default function () {
  // 1. Carga de la página principal
  let res = http.get(`${BASE_URL}/`);
  check(res, { 'Home OK': (r) => r.status === 200 });
  randomSleep(1, 2);

  // 2. Consulta de la lista completa de veterinarios
  res = http.get(`${BASE_URL}/api/vet/vets`);
  check(res, { 'Vets OK': (r) => r.status === 200 });
  randomSleep(1, 3);

  // 3. Consulta de la lista general de dueños
  res = http.get(`${BASE_URL}/api/customer/owners`);
  check(res, { 'Owners List OK': (r) => r.status === 200 });
  randomSleep(1, 2);

  // 4. Consulta de dueños específicos
  let randomOwnerId = Math.floor(Math.random() * 10) + 1;
  res = http.get(`${BASE_URL}/api/customer/owners/${randomOwnerId}`);
  check(res, { 'Owner Details OK': (r) => r.status === 200 });
  randomSleep(2, 4);

  // 5. Consulta de tipos de mascotas 
  res = http.get(`${BASE_URL}/api/customer/petTypes`);
  check(res, { 'Pet Types OK': (r) => r.status === 200 });
  randomSleep(1, 2);
}