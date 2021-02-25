

const createPlayer = (socket, name) => {
    const obj = {
        name: name,
        hand: [],
        position: null,
        //game: null,
        players: null,
        isIntrus: null,

        setPosition(pos) {
            this.position = pos;
            this.isIntrus = false;
        },
        // disconnect() {
        //     if (this.game !== null)
        //         this.game.deletePlayer(this);
        // },
        setGame(game) {
            this.game = game;
        },
        setPlayers(players) {
            this.players = players;
        },
        getPosition() {
            return this.position
        },
        getHand() {
            return this.hand;
        },
        setHand(cards) {
            this.hand.push(...cards);
            //console.log("emit hand to client")
            return new Promise((resolve, reject) => {
                socket.emit('hand', { cards: cards });
                socket.on('hand-ok', (req) => {
                    //console.log("hand emited sucess : ", req)
                    resolve(req);
                });
            });
        },
        notifyPlayerOut(name) {
            if (this.name == name) {
                socket.emit('self-player-out');
            }
            socket.emit('player-out', name);
        },
        notifyWord(word) {
            return new Promise((resolve, reject) => {
                if (this.isIntrus) {
                    socket.emit('game-word', null)
                }
                else {
                    socket.emit('game-word', word);
                }
                socket.on('word-ok', (req) => {
                    //console.log("word emited sucess : ", req)
                    resolve(req);
                });
            });
        },
        notifyHand() {
            //console.log("sending new hand to player", this.name)
            return new Promise((resolve, reject) => {
                socket.emit('hand', { cards: this.hand });
                socket.on('hand-ok', (req) => {
                    //console.log("hand emited sucess : ", req)
                    resolve(req);
                });
            });
        },
        notifyGameLaunched() {
            //console.log("Sending to player", this.name, " position (", this.position, ") and isIntrus(", this.isIntrus, ")");
            socket.emit('game-started', { position: this.position, isIntrus: this.isIntrus });
        },
        notifyGameStopped() {
            socket.emit('game-ended');
        },
        notifyPlayersList(players){
            socket.emit('update-players', {players : players});
        },
        askTrade(nextPlayer) {
            cards = nextPlayer.getHand();
            return new Promise((resolve, reject) => {
                socket.emit('trade-cards', { cards: cards })
                socket.on('card-trade', (cardId) => {
                    //console.log("Player ", this.name, " trade card of next player ", nextPlayer.name, " : card ", cardId)
                    resolve(cardId);
                });
            })
        },
        askWord() {
            return new Promise((resolve, reject) => {
                socket.emit('ask-word')
                socket.on('choose-word', (word) => {
                    //console.log("Player ", this.name, " choose the word : ", word)
                    resolve(word);
                });
            })
        },
        askCard() {
            return new Promise((resolve, reject) => {
                socket.emit('ask-card')
                //console.log("\t asked card to player", this.name)
                socket.on('choose-card', (cardId) => {
                    //console.log("Player ", this.name, " choose the card : ", cardId)
                    resolve(cardId);
                });
            })
        },
        askVote(players) {
            return new Promise((resolve, reject) => {
                //var plys = players.map(elem => elem.name != this.name);
                socket.emit('ask-vote', { players: players })
                socket.on('choose-vote', (vote) => {
                    //console.log("Player ", this.name, " vote for : ", vote)
                    resolve(vote);
                });
            })
        },
        onPlayerNotify() {
            return new Promise((resolve, reject) => {
                socket.on('notify-game-hint', (message) => {
                    // let p = this.players.find(p => p.name == message.playerName);
                    // p.notifyPlayerHint(message);
                    resolve(message);
                });
            });
        },
        notifyPlayerHint(message) {
            socket.emit('notify-player-hint', { message: message });
        }
    }
    return obj;
}

module.exports = createPlayer;