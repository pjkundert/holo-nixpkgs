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

// Search from the list of installed happs
const CORE_ID = "core-happs:alpha0"

app.get('/hosted_happs', async (_, res) => {
  let happs
  try {
    happs = await callZome(CORE_ID, 'hha', 'get_happs', null)
  } catch(e) {
      console.log("error:", e);
      res.sendStatus(501)
  }
  const presentedHapps = happs.map(happ => ({
    id: happ.happ_id,
    name: happ.happ_bundle.name
  }))
  res.send(presentedHapps)
})

app.post('/install_hosted_happ', async (req, res) => {
  // check if happ_id is passed else return error
  if (req.query.happ_id) {
    let happId = req.query.happ_id;
    console.log("Trying to install happ with happId: ", happId)

    // Steps:
    // - Call hha to get happ details
    let happBundleDetails;
    try {
      happBundleDetails = await callZome(CORE_ID, 'hha', 'get_happ', happId)
    } catch (e) {
      res.sendStatus(500)
    }
    console.log("Happ Bundle: ", happBundleDetails);
    let happAlias = happBundleDetails.happ_bundle.happ_alias;

    let listOfInstalledHapps;
    // Instalation Process:
    try {
      // Make sure app interface is started
      await startHappInterface();

      listOfInstalledHapps = await listInstalledApps();

      // Generate new agent
      // TODO: There should be only one hostedAgent for readonly instances
      const hostedAgentPubKey = await createAgent();

      // Install DNAs
      let dnas = happBundleDetails.happ_bundle.dnas;

      // check if the hosted_happ is already listOfInstalledHapps
      if (listOfInstalledHapps.includes(`${happBundleDetails.happ_id}`)) {
        console.log(`${happBundleDetails.happ_id}:${dnas[i].nick} already listOfInstalledHapps`)
        res.sendStatus(501);
      } else {
        await installHostedDna(happBundleDetails.happ_id, dnas, hostedAgentPubKey)
      }
      // Note: Do not need to install UI's for hosted happ
      res.sendStatus(200);
    } catch (e) {
      console.log("Falied to install hosted happ")
      res.sendStatus(501);
    }
  }
  else {
    console.log("Falied: Please pass in a happId ")
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
