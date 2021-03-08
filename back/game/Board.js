

const createBoard = (socket, name) => {
    const obj = {
        name: name,
        state: null,

        notifyGameChange(game) {
            socket.emit('update-game', {game : game});
            console.log("update game, current pos player : ", game.currentPosPlayer);
        },

        notifyPlayerPlayed(player){
            socket.emit('player-played', {player : player})
        }
    }

    return obj;
}

module.exports = createBoard;