#!/usr/bin/env node

const fs = require('fs')
const express = require('express')
const app = express()
const yargs = require('yargs/yargs')
const { hideBin } = require('yargs/helpers')
yargs(hideBin(process.argv))
const { UNIX_SOCKET, HAPP_PORT, ADMIN_PORT } = require('./const')
const { callZome, createAgent, listInstalledApps, installHostedHapp } = require('./api')
const { parsePreferences, isusageTimeInterval } = require('./utils')
const { getAppIds, getReadOnlyPubKey } = require('./const')
const { AdminWebsocket, AppWebsocket } = require('@holochain/conductor-api')

// NB: `/hosted_happs` accepts `usageTimeInterval` as its only param - this value is passed to SL to calcuate the usage data for said time interval
// usageTimeInterval = {
//   durationUnit: String // accepted units: 'HOUR', 'DAY', 'WEEK', 'MONTH', 'YEAR
//   amount: Int
// }

app.get('/hosted_happs', async (req, res) => {
  let usageTimeInterval
  await req.on('data', (body) => {
    usageTimeInterval = JSON.parse(body.toString())
    if (!isusageTimeInterval(usageTimeInterval)) return res.status(501).send('error from /hosted_happs: param provided is not an object')
  })
  let happs
  const appWs = await AppWebsocket.connect(`ws://localhost:${HAPP_PORT}`)
  try {
    const APP_ID = await getAppIds()
    happs = await callZome(appWs, APP_ID.HHA, 'hha', 'get_happs', null)
  } catch (e) {
    console.log('error from /hosted_happs:', e)
    return res.status(501).send(`hpos-holochain-api error: ${e}`)
  }
  const presentedHapps = []
  for (let i = 0; i < happs.length; i++) {
    const usage = {
      bandwidth: 0,
      cpu: 0
    }
    let appStats, enabled
    try {
      // nb: servicelogger bandwidth payload is calcalated with Bytes (not bits)
      appStats = await callZome(appWs, `${happs[i].happ_id}::servicelogger`, 'service', 'get_stats', usageTimeInterval)
      enabled = true
    } catch (e) {
      const happServiceloggerError = {
        id: happs[i].happ_id,
        name: happs[i].happ_bundle.name,
        enabled: false,
        error: {
          source: `${happs[i].happ_id}::servicelogger`,
          message: e.message,
          stack: e.stack
        }
      }
      presentedHapps.push(happServiceloggerError)
      break
    }

    const { source_chain_count: sourceChains, bandwidth, cpu } = appStats
    usage.cpu = cpu
    usage.bandwidth = bandwidth

    presentedHapps.push({
      id: happs[i].happ_id,
      name: happs[i].happ_bundle.name,
      enabled,
      sourceChains,
      usage
      // TODO: add following data to match proposed api: https://hackmd.io/bgCdVjskR1iD_4DgQjkzPA
      // daysHosted,
      // storage
    })
  }
  res.status(200).send(presentedHapps)
})

app.post('/install_hosted_happ', async (req, res) => {
  let data
  // Loading body
  await req.on('data', (body) => {
    data = JSON.parse(body.toString())
  })

  // check if happ_id is passed else return error
  if (data.happ_id && data.preferences) {
    const happId = data.happ_id
    // preferences: {
    //   max_fuel_before_invoice: '5', // how much holofuel to accumulate before sending invoice
    //   price_compute: '1',
    //   price_storage: '1',
    //   price_bandwidth: '1',
    //   max_time_before_invoice: [86400, 0], // how much time to allow to pass before sending invoice even if fuel trigger not reached.
    // }
    const preferences = data.preferences
    if (!preferences.max_fuel_before_invoice ||
      !preferences.max_time_before_invoice ||
      !preferences.price_compute ||
      !preferences.price_storage ||
      !preferences.price_bandwidth) {
      console.log('wrong preferences...')
      return res.status(501).send(`hpos-holochain-api error: preferences does not include all the necessary values`)
    }
    console.log('Trying to install happ with happId: ', happId)

    // Steps:
    // - Call hha to get happ details
    let happBundleDetails
    try {
      const APP_ID = await getAppIds()
      const appWs = await AppWebsocket.connect(`ws://localhost:${HAPP_PORT}`)
      happBundleDetails = await callZome(appWs, APP_ID.HHA, 'hha', 'get_happ', happId)
    } catch (e) {
      return res.status(501).send(`hpos-holochain-api error: ${e}`)
    }
    console.log('Happ Bundle: ', happBundleDetails)
    let listOfInstalledHapps
    // Instalation Process:
    try {
      const adminWs = await AdminWebsocket.connect(`ws://localhost:${ADMIN_PORT}`)
      // Do we need to make sure app interface is started?
      // await startHappInterface(adminWs);

      listOfInstalledHapps = await listInstalledApps(adminWs)

      // Generate new agent in a test environment else read the location in hpos
      const hostPubKey = process.env.NODE_ENV === 'test' ? await createAgent(adminWs) : await getReadOnlyPubKey()

      // Install DNAs
      const dnas = happBundleDetails.happ_bundle.dnas

      // check if the hosted_happ is already listOfInstalledHapps
      if (listOfInstalledHapps.includes(`${happBundleDetails.happ_id}`)) {
        return res.status(501).send(`hpos-holochain-api error: ${happBundleDetails.happ_id} already installed on your holoport`)
      } else {
        const serviceloggerPref = parsePreferences(preferences, happBundleDetails.provider_pubkey)
        console.log('Parsed Preferences: ', serviceloggerPref)
        await installHostedHapp(happBundleDetails.happ_id, dnas, hostPubKey, serviceloggerPref)
      }

      // Note: Do not need to install UI's for hosted happ
      return res.status(200).send(`Successfully installed happ_id: ${happId}`)
    } catch (e) {
      return res.status(501).send(`hpos-holochain-api error: Failed to install hosted Happ with error - ${e}`)
    }
  } else {
    return res.status(501).send(`hpos-holochain-api error: Failed to pass happId in body`)
  }
})

try {
  if (fs.existsSync(UNIX_SOCKET)) {
    fs.unlinkSync(UNIX_SOCKET)
  }
} catch (err) {
  console.error(err)
}

app.listen(UNIX_SOCKET, () => {
  console.log(`Host console server running`)
})

module.exports = { app }
