import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE_URL = 'http://localhost:30080';

export const options = {
  stages: [
    { duration: '30s', target: 150 },  
    { duration: '3m', target: 180 }, 
    { duration: '30s', target: 80 },  
  ],
};

export default function () {
  let res = http.get(`${BASE_URL}/api/vet/vets`);
  check(res, { 'Veterinarios responde': (r) => r.status === 200 });
  sleep(0.5); 
}