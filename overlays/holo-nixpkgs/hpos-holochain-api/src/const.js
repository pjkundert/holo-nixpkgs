const UNIX_SOCKET = process.env.NODE_ENV === 'test' ? 3001 : '/run/hpos-holochain-api/hpos-holochain-api.sock';

const ADMIN_PORT = 4444;

const HAPP_PORT = 42233;

module.exports = {
  UNIX_SOCKET,
  ADMIN_PORT,
  HAPP_PORT,
}
