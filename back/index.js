const app = require('express')();
const http = require('http').createServer(app);
const createServer = require('./server');

var server_port = process.env.PORT || 3000;

const server = createServer(http)
server.launchServer(server_port);
// io.on('connection', function (client) {

//   console.log('client connect...', client.id);

//   client.on('typing', function name(data) {
//     console.log(data);
//     io.emit('typing', data)
//   })

//   client.on('message', function name(data) {
//     console.log(data);
//     io.emit('message', data)
//   })

//   client.on('location', function name(data) {
//     console.log(data);
//     io.emit('location', data);
//   })

//   client.on('connect', function () {
//   })

//   client.on('disconnect', function () {
//     console.log('client disconnect...', client.id)
//     // handleDisconnect()
//   })

//   client.on('error', function (err) {
//     console.log('received error from client:', client.id)
//     console.log(err)
//   })
// })
