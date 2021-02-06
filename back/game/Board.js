

const createBoard = (socket, name) => {
    const obj = {
        name: name,
        state: null,
        //game: null,

        // setGame(game){
        //     this.game = game;
        // },

        notifyGameChange(game) {
            socket.emit('update-game', {game : game})
        }
    }

    return obj;
}

module.exports = createBoard;