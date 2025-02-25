const createPlayer = require('./game/Player');
const createGameManager = require('./game-manager');
const ioServer = require('socket.io');
const createBoard = require('./game/Board');


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
            console.log("Identifing : ", socket.id);
            if (req.name == 'board') {
                const board = createBoard(socket, "SuperGame1")
                gameManager.addBoard(board)
                console.log("\n--new board identify : ", board.name);
            }
            else if (!(req.name in clients)) {
                const player = createPlayer(socket, req.name);

                clients[req.name] = player;

                console.log("\n--new player identify : ", player.name);

                socket.on('disconnect', () => {
                    console.log(player.name ," has left the game")
                    gameManager.playerDisconnect.apply(gameManager, [player]);
                });

                socket.on('join', (req) => {
                    console.log(player.name, " joined", req.name);
                    gameManager.joinGame.apply(gameManager, [player, req]);
                });
            } else {
                console.log("Name already taken")
            }
        },
        getPlayerByName(name) {
            return clients[name];
        }

    }
    const manageSocket = (socket) => {
        console.log("client connected : ", socket.id)
        socket.on('identify', (req) => obj.identify.apply(gameManager, [socket, req]));
    };
    io.on('connection', manageSocket);
    return obj;
};

module.exports = createServer;
