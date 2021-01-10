import { ADMIN_PORT, HOSTED_HAPP_PORT, HAPP_PORT } from "./const";
import { AdminWebsocket, AppWebsocket } from "@holochain/conductor-api";
import { downloadFile } from './utils';

// NOTE: this code assumes a single DNA per hApp.  This will need to be updated when the hApp bundle
// spec is completed, and the hosted-happ config Yaml file will also need to be likewise updated
export const installHostedDna = async (happ_id, dna, agentPubKey) => {
    console.log("Installing DNA...");
    // TODO: How to install a DNA
      // We need to download the DNA to a perticular location.
      // Use that location and install
    // NOTE: we also have to install a servicelogger instance
      // We need to know the path to the servicelogger
      // Use that servicelogger and install a new DNA with the properties set as
      // { properties: Array.from(msgpack.encode({"bound_dna_id":"uhC0kmrkoAHPVf_eufG7eC5fm6QKrW5pPMoktvG5LOC0SnJ4vV1Uv"})) }

    try {
        const dnaPath = await downloadFile(dna.path);
        // Install via admin interface
        const installed_app_id = `${happ_id}:${dna.nick}`;
        const adminWebsocket = await AdminWebsocket.connect(
            `ws://localhost:${ADMIN_PORT}`
        );
        const installed_app = await adminWebsocket.installApp({
            agent_key: agentPubKey,
            installed_app_id,
            dnas: [
                {
                    nick: dna.nick,
                    path: dnaPath
                }
            ],
        });
        await adminWebsocket.activateApp({ installed_app_id: installed_app.installed_app_id });

    } catch(e) {
        console.error(`Failed to install dna ${dna.nick} with error: `, e);
        throw new Error(`Failed to install dna ${dna.nick} with error: `, e);
    }

    console.log(`Successfully installed dna ${installed_app_id} for key ${agentPubKey.toString('base64')}`);
}

export const createAgent = async () => {
    try {
        const adminWebsocket = await AdminWebsocket.connect(
            `ws://localhost:${ADMIN_PORT}`
        );

        let agentPubKey = await adminWebsocket.generateAgentPubKey();
        console.log(agentPubKey);
        console.log(`Generated new agent ${agentPubKey.toString('base64')}`);
        return agentPubKey;
    } catch(e) {
        console.log(`Error while generating new agent: ${e.message}.`);
    }
}

export const listInstalledApps = async () => {
    try {
        const adminWebsocket = await AdminWebsocket.connect(
            `ws://localhost:${ADMIN_PORT}`
        );
        const apps = await adminWebsocket.listActiveApps();
        console.log("listActiveApps app result: ", apps)
        return apps
    } catch(e) {
        console.error(`Failed to get list of active happs with error: `, e);
        return;
    }
}

export const startHappInterface = async () => {
    try {
        const adminWebsocket = await AdminWebsocket.connect(
            `ws://localhost:${ADMIN_PORT}`
        );

        console.log(`Starting app interface on port ${HOSTED_HAPP_PORT}`);
        await adminWebsocket.attachAppInterface({ port: HOSTED_HAPP_PORT });
    } catch(e) {
        console.log(`Error: ${e.message}, probably interface already started.`);
    }
}

export const callZome = async (app_id, zome_name, fn_name, payload ) => {
  // const appWebsocket = await AppWebsocket.connect(`ws://localhost:${HAPP_PORT}`)
  //
  // const appInfo = appWebsocket.appInfo({ installed_app_id: app_id })
  //
  // if (!appInfo) {
  //   throw new Error(`Couldn't find Holo Hosting App with id ${app_id}`)
  // }
  //
  // const cellId = appInfo.cell_data[0][0]
  //
  // const agentKey = cellId[1]
  //
  // return await appWebsocket.callZome({
  //   cell_id: cellId,
  //   zome_name,
  //   fn_name,
  //   provenance: agentKey,
  //   payload
  // })
  return {
    happ_bundle : {
      happ_alias: "alias",
      dnas: [
        {
          hash: "",
          path: "",
          nick: ""
        }
      ],
      ui_path: "UI_PATH"
    }
  }
}
