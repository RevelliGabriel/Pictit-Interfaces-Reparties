// const createPlayer = require('./contree/Player');
// const createGame = require('./contree/Game');
const createGameManager = require('./game-manager');
const ioServer = require('socket.io');


const createServer = (http) => {
    const io = ioServer(http);
    const clients = {};
    const gameManager = createGameManager();
    const obj = {
        gameManager: gameManager,
        launchServer(port) {
            http.listen(port)
            console.log('Listening on port %d', port);
        },
        identify(socket, req) {
            if (!(req.name in clients)) {
                // const player = createPlayer(socket, req.name);
                const player = req;

                clients[req.name] = player;

                console.log("\n--new player identify : ", player.name);

                // socket.on('message', function name(data) {
                //     console.log(data);
                //     io.emit('message', data)
                // })

                // socket.on('choose pos', (req, cb) => {
                //     gameManager.choosePos.apply(gameManager, [player, req, cb]);  
                // });

                socket.on('disconnect', () => {
                   gameManager.playerDisconnect.apply(gameManager, [player]); 
                });

                socket.on('join', (req) => {
                    gameManager.joinGame.apply(gameManager, [player, req]);
                });
            } else {
            }
        },
        getPlayerByName(name) {
            return clients[name];
        }

    }
    const manageSocket = (socket) => {
        console.log("client connected")
        socket.on('identify', (req) => obj.identify.apply(gameManager, [socket, req]));
    };
    io.on('connection', manageSocket);
    return obj;
};

module.exports = createServer;
