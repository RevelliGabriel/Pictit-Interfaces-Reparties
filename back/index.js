const app = require('express')();
const http = require('http').createServer(app);
const createServer = require('./server');

var server_port = process.env.PORT || 3000;

const server = createServer(http)
server.launchServer(server_port);
