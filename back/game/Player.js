

const createPlayer = (socket, name) => {
    const obj = {
        name: name,
        hand: [],
        position: '',
        //game: null,
        isIntrus: false,

        setIntrus() {
            this.isIntrus = true;
        },
        setPosition(pos) {
            this.position = pos;
        },
        // disconnect() {
        //     if (this.game !== null)
        //         this.game.deletePlayer(this);
        // },
        // setGame(game) {
        //     this.game = game;
        // },
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
        notifyWord(word){
            return new Promise((resolve, reject) => {
                socket.emit('game-word', word);
                socket.on('word-ok', (req) => {
                    console.log("word emited sucess : ", req)
                    resolve(req);
                });
            });
        },
        notifyHand(){
            console.log("sending new hand to player", this.name)
            return new Promise((resolve, reject) => {
                socket.emit('hand', { cards: this.hand });
                socket.on('hand-ok', (req) => {
                    console.log("hand emited sucess : ", req)
                    resolve(req);
                });
            });
        },
        notifyGameLaunched(){
            console.log("Sending to player", this.name, " position (", this.position,") and isIntrus(", this.isIntrus,")");
            socket.emit('game-started', { position: this.position, isIntrus: this.isIntrus });
        },
        askTrade(nextPlayer){
            cards = nextPlayer.getHand();
            return new Promise((resolve, reject) => {
                socket.emit('trade-cards', { cards: cards })
                socket.on('card-trade', (cardId) => {
                    console.log("Player ", this.name, " trade card of next player ", nextPlayer.name, " : card ", cardId)
                    resolve(cardId);
                });
            })
        },
        askWord(){
            return new Promise((resolve, reject) => {
                socket.emit('ask-word')
                socket.on('choose-word', (word) => {
                    console.log("Player ", this.name, " choose the word : ", word)
                    resolve(word);
                });
            })
        }
    }
    return obj;
}

module.exports = createPlayer;