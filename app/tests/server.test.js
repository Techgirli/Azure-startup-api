const request = require('supertest');
const app = require('../server');

describe('GET /health', () => {
  test('returns 200 and status ok', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ status: 'ok' });
  });
});

describe('GET /ready', () => {
  test('returns 200 and ready true', async () => {
    const res = await request(app).get('/ready');
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ ready: true });
  });
});   