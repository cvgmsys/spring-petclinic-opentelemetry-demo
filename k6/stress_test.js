import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE_URL = 'http://localhost:30080';

export const options = {
  // 100 usuarios concurrentes (10 veces más que la línea base)
  vus: 100,
  // Solo 5 minutos. Es un pico agresivo, suficiente para saturar la CPU
  duration: '5m',
};

export default function () {
  // Los usuarios atacan directamente la consulta de la base de datos de veterinarios
  // a través del API Gateway
  let res = http.get(`${BASE_URL}/api/vet/vets`);
  
  check(res, { 'Veterinarios responde': (r) => r.status === 200 });
  
  // Apenas hay tiempo de espera (0.1s), forzando peticiones casi continuas
  // para agotar los milicores del contenedor lo antes posible.
  sleep(0.1); 
}