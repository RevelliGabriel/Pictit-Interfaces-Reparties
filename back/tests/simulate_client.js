const
    io = require("socket.io-client"),
    socket = io.connect("http://localhost:3000");

socket.on('connect', function () { //console.log("socket connected"); });
socket.emit(
    "identify",
    {
        "id": socket.id,
        "name": "Jean",
    },
);
socket.emit(
    "join",
    {"name": "SuperGame1"},
);
socket.on('hand', (data) => {
    print("get hand from server:", data);
    socket.emit('hand-ok', "ok");
});