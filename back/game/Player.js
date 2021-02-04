

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
            return new Promise((resolve, reject) => {
                socket.emit('hand', { cards: cards }, (resp) => {
                    console.log("hand emited to client")
                    resolve(resp);
                });
            });
        },
    }
    return obj;
}

module.exports = createPlayer;