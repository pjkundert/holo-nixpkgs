const { app } = require('../src/index')
const request = require('supertest')

const USAGE_DURATION_INTERVAL = 'WEEK'
const usageTimeInterval = {
  duration_interval: USAGE_DURATION_INTERVAL,
  interval_count: 1
}

test('Test holochain-api endpoint ', async () => {
  const listOfHappsResponse = await request(app).get('/hosted_happs').send(usageTimeInterval)
  expect(listOfHappsResponse.status).toBe(500)
  expect(listOfHappsResponse.ok).toBe(false)
  expect(listOfHappsResponse.error.path).toBe('/hosted_happs')
  expect(listOfHappsResponse.error.method).toBe('GET')

  const { text } = listOfHappsResponse.error
  const { source } = JSON.parse(text)
  const happId = source.split('::')[0]

  const preferences = {
    "max_fuel_before_invoice": 1,
    "max_time_before_invoice": [80000, 0],
    "price_compute": 1,
    "price_storage": 2,
    "price_bandwidth": 1
  }

  const res = await request(app)
    .post('/install_hosted_happ')
    .send({ happ_id: happId, preferences })
  expect(res.status).toBe(200)

  const listOfHappsReload = await request(app).get('/hosted_happs').send(usageTimeInterval)

  expect(listOfHappsReload.status).toBe(200)
  expect(listOfHappsReload.body[0].enabled).toBe(true)
  expect(listOfHappsReload.body[0].source_chain).toBe(0)
  expect(listOfHappsReload.body[0].usage).toBe({})
}, 300000)
