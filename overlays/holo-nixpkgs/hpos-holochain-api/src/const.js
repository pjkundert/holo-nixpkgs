const UNIX_SOCKET = process.env.NODE_ENV === 'test' ? 3001 : '/run/hpos-holochain-api/hpos-holochain-api.sock';

const HHA_ID = "holo-hosting-app";

const ADMIN_PORT = 4444;

const SERVICE_LOGGER_PORT = 42222;

const HAPP_PORT = 42233;

const HOSTED_HAPP_PORT = 42244;

module.exports = {
  UNIX_SOCKET,
  HHA_ID,
  ADMIN_PORT,
  SERVICE_LOGGER_PORT,
  HAPP_PORT,
  HOSTED_HAPP_PORT,
}
