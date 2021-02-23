const { app } = require('../src/index')
const request = require('supertest')

const HAPP_NAME = 'Elemental Chat'
const USAGE_DURATION_INTERVAL = 'WEEK'
const usageTimeInterval = {
  duration_unit: USAGE_DURATION_INTERVAL,
  amount: 1
}

function delay(t, val) {
  return new Promise(function(resolve) {
    setTimeout(function() {
      resolve(val)
    }, t)
  })
}

test('Test holochain-api endpoint ', async () => {
  const listOfHappsResponse = await request(app).get('/hosted_happs').send(usageTimeInterval)
  expect(listOfHappsResponse.status).toBe(200)
  expect(listOfHappsResponse.body[0].name).toBe(HAPP_NAME)
  expect(listOfHappsResponse.body[0].enabled).toBe(false)
  expect(listOfHappsResponse.body[0].error.message).toBeTruthy()
  expect(listOfHappsResponse.body[0].error.source).toBeTruthy()
  expect(listOfHappsResponse.body[0].sourceChains).toBeFalsy()
  expect(listOfHappsResponse.body[0].usage).toBeFalsy()


  const preferences = {
    "max_fuel_before_invoice": 1,
    "max_time_before_invoice": [80000, 0],
    "price_compute": 1,
    "price_storage": 2,
    "price_bandwidth": 1
  }

  const res = await request(app)
    .post('/install_hosted_happ')
    .send({ happ_id: listOfHappsResponse.body[0].id, preferences })
  expect(res.status).toBe(200)

  await delay(10000)

  const listOfHappsReload = await request(app).get('/hosted_happs').send(usageTimeInterval)
  const usage = {
    bandwidth: { size: 0, unit: 'Bytes' },
    cpu: 0
  }

  expect(listOfHappsReload.status).toBe(200)
  expect(listOfHappsReload.body[0].enabled).toBe(true)
  expect(listOfHappsReload.body[0].name).toBe(HAPP_NAME)
  expect(listOfHappsReload.body[0].sourceChains).toBe(0)
  expect(listOfHappsReload.body[0].usage).toStrictEqual(usage)
}, 50000)
