const fs = require('fs')
const express = require('express')
const app = express()
const yargs = require('yargs/yargs')
const { hideBin } = require('yargs/helpers')
const argv = yargs(hideBin(process.argv)).argv
const { UNIX_SOCKET, HHA_ID} = require('./const')
import { callZome, createAgent, startHappInterface, listInstalledApps, installHostedDna } from "./api"

if (!argv.appPort) {
  throw new Error('Host console server requires --app-port option.')
}

if (!argv.appId) {
  throw new Error('Host console server requires --app-id option.')
}

app.get('/hosted_happs', async (_, res) => {
  const happs = await callZome(argv.appId, 'hha', 'get_happs', {})

  const presentedHapps = happs.map(happ => ({
    id: happ.happ_id,
    name: happ.happ_bundle.name
  }))

  res.send(presentedHapps)
})

app.post('/install_hosted_happ', async (req, res) => {
  // check if happ_id is passed else return error
  if (req.query.happ_id) {
    let happ_id = req.query.happ_id;
    console.log("Trying to install happ with happ_id: ", happ_id)

    // Steps:
    // - Call hha to get happ details
    let happBundleDetails;
    try {
      happBundleDetails = await callZome(argv.appId, 'hha', 'get_happ', {happ_id})
    } catch (e) {
      res.sendStatus(500)
    }
    console.log("Happ Bundle: ", happBundleDetails);
    let happAlias = happBundleDetails.happ_bundle.happ_alias;

    // Instalation Process:
    try {
      // Make sure app interface is started
      await startHappInterface();

      // Generate new agent
      // TODO: There should be only one hostedAgent for readonly instances
      const hostedAgentPubKey = await createAgent();

      const installed = await listInstalledApps();

      // Install DNAs
      let dnas = happBundleDetails.happ_bundle.dnas;
      // await dnas.forEach(async (dna) => {
      for( let i=0; i< dnas.length; i++) {
        // check if the hosted_happ is already installed
        if (installed.includes(`${happBundleDetails.happ_id}:${dnas[i].nick}`)) {
          console.log(`${happBundleDetails.happ_id}:${dnas[i].nick} already installed`)
        } else {
          await installHostedDna(happBundleDetails.happ_id, dnas[i], hostedAgentPubKey)
        }
      }

      // Note: Do not need to install UI's for hosted happ

      res.sendStatus(200);
    } catch (e) {
      console.log("Falied to install hosted happ")
      res.sendStatus(501);
    }
  }
  else {
    console.log("Falied: Please pass in a happ_id ")
    res.sendStatus(501);
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
