

const createBoard = (socket, name) => {
    const obj = {
        name: name,
        state: null,
        //game: null,

        // setGame(game){
        //     this.game = game;
        // },

        notifyGameChange(game) {
            socket.emit('update-game', {game : game});
            console.log("update game, current pos player : ", game.currentPosPlayer);
        }
    }

    return obj;
}

module.exports = createBoard;