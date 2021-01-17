const UNIX_SOCKET = process.env.NODE_ENV === 'test' ? 3001 : '/run/hpos-holochain-api/hpos-holochain-api.sock';

const ADMIN_PORT = 4444;

const HAPP_PORT = 42233;

// TODO: Read config that has the core happ details
const CORE_ID = "core-happs:alpha0"
const SERVICELOGGER_ID = "servicelogger:alpha0";

module.exports = {
  UNIX_SOCKET,
  ADMIN_PORT,
  HAPP_PORT,
  SERVICELOGGER_ID,
  CORE_ID
}
