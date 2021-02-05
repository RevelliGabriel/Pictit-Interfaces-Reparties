

const createBoard = (socket, name) => {
    const obj = {
        name: name,
        state: null,
        game: null,

        notifyPlayersList(players) {
            socket.emit('update-players', players)
        }
    }

    return obj;
}

module.exports = createBoard;