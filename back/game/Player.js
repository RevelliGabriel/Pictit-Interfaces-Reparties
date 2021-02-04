

const createPlayer = (socket, name) => {
    const obj = {
        name: name,
        hand: [],
        position: '',
        game: null,
        isIntrus : false,

        setIntrus(){
            this.isIntrus = true;
        },
        setPosition(pos) {
            this.position = pos;
        },
        disconnect() {
            if (this.game !== null)
                this.game.deletePlayer(this);
        },
        setGame(game) {
            this.game = game;
        },
        getPosition() {
            return this.position
        },
        getHand() {
            return this.hand;
        },
        setHand(cards) {
            this.hand.push(...cards);
            console.log("emit hand to client")
            return new Promise((resolve, reject) => {
                socket.emit('hand', { cards: cards }, (resp) => {
                    socket.on('hand-ok', (req) => {
                        console.log("hand emited sucess : ", req)
                        resolve(resp);
                    });
                });
            });
        },
    }
    return obj;
}

module.exports = createPlayer;