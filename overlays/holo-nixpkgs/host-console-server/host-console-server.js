const express = require('express')
const app = express()
const { AdminWebsocket, AppWebsocket } = require('@holochain/conductor-api')

const ADMIN_PORT = '4444'
const APP_PORT = '42233'
const HHA_INSTANCE_ALIAS = 'hha'
const UNIX_SOCKET = '/run/host-console-server.sock'

app.get('/hosted_happs', async (_, res) => {
  const adminWebsocket = await AdminWebsocket.connect(`ws://localhost:${ADMIN_PORT}`)

  const result = await adminWebsocket.listDnas({})

  const hhaInstanceId = result.find(dna => dna.instanceId.indexOf(HHA_INSTANCE_ALIAS) >= 0).instanceId

  const appWebsocket = await AppWebsocket.connect(`ws://localhost:${APP_PORT}`)

  const agentKey = adminWebsocket.generateAgentPubKey()

  const cellId = hhaInstanceId + agentKey

  const happs = await appWebsocket.callZome({
    cellId,
    zome_name: 'hha',
    fn_name: 'get_happs',
    provenance: agentKey,
    payload: {}
  })

  const presentedHapps = happs.map(happ => ({
    id: happ.id,
    name: happ.name
  }))

  res.send(presentedHapps)
})

app.listen(UNIX_SOCKET, () => {
  console.log(`Host console server running`)
})
