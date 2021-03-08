

const createBoard = (socket, name) => {
    const obj = {
        name: name,
        state: null,

        // permet de notifier la board avec l'ensemble de l'objet Game
        notifyGameChange(game) {
            socket.emit('update-game', {game : game});
            console.log("update game, current pos player : ", game.currentPosPlayer);
        },

        // notifie qu'un joueur a joué
        notifyPlayerPlayed(player){
            socket.emit('player-played', {player : player})
        }
    }

    return obj;
}

module.exports = createBoard;