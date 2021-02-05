

const createPlayer = (socket, name) => {
    const obj = {
        name: name,
        hand: [],
        position: '',
        game: null,
        isIntrus: false,

        setIntrus() {
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
                socket.emit('hand', { cards: cards });
                socket.on('hand-ok', (req) => {
                    console.log("hand emited sucess : ", req)
                    resolve(req);
                });
            });
        },
        notifyHand(){
            return new Promise((resolve, reject) => {
                socket.emit('hand', { cards: this.hand });
                socket.on('hand-ok', (req) => {
                    console.log("hand emited sucess : ", req)
                    resolve(req);
                });
            });
        },
        notifyGameLaunched(){
            console.log("Sending to player", this.name, " position (", this.isIntrus,") and isIntrus(", this.isIntrus,")");
            socket.emit('game-started', { position: this.position, isIntrus: this.isIntrus });
        },
        askTrade(nextPlayer){
            cards = nextPlayer.getHand();
            return new Promise((resolve, reject) => {
                socket.emit('trade-cards', { cards: cards })
                socket.on('card-trade', (cardId) => {
                    console.log("Player ", this.name, " trade card of next player ", this.nextPlayer.name, " : card ", cardId)
                    resolve(cardId);
                });
            })
        }
    }
    return obj;
}

module.exports = createPlayer;