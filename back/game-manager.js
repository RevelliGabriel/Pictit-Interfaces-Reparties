const createGame = require('./game/Game');

const createGameManager = () => {
    const availableGames = {};
    const obj = {
        getGameWithName(name) {
            let game;
            if (name in availableGames) {
                game = availableGames[name];
            } else {
                game = createGame(name);
                console.log("\nNew game created : ", name)
                availableGames[name] = game;
            }
            return game;
        },
        getAvailableGames() {
            return Object.keys(availableGames);
        },
        joinGame(player, req) {
            const game = this.getGameWithName(req.name);
            if (game.addPlayer(player)) {
                // game.notifyGameBoard();
                if (game.canStart()) {
                    this.deleteGameWithName(game.name);
                    game.launch();
                }
            }
        },
        deleteGameWithName(name) {
            delete availableGames[name];
        },
        playerDisconnect(player) {
            // player.disconnect();
        },
    }
    return obj;
};

module.exports = createGameManager;