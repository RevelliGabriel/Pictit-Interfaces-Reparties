

const createPlayer = (socket, name) => {
    const obj = {
        name: name,
        hand: [],
        position: null,
        board: null,
        players: null,
        isIntrus: null,

        setPosition(pos) {
            this.position = pos;
            this.isIntrus = false;
        },
        setGame(game) {
            this.game = game;
        },
        setBoard(board) {
            this.board = board;
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
        // associe la main d'un joueur
        setHand(cards) {
            this.hand.push(...cards);
            return new Promise((resolve, reject) => {
                socket.emit('hand', { cards: cards });
                socket.on('hand-ok', (req) => {
                    resolve(req);
                });
            });
        },
        // notifie qu'un joueur à ete éliminé
        notifyPlayerOut(name) {
            if (this.name == name) {
                socket.emit('self-player-out');
            } else {
                socket.emit('player-out', name);
            }
        },
        // notifie le mot de la partie
        notifyWord(word) {
            return new Promise((resolve, reject) => {
                if (this.isIntrus) {
                    socket.emit('game-word', null)
                }
                else {
                    socket.emit('game-word', word);
                }
                socket.on('word-ok', (req) => {
                    resolve(req);
                });
            });
        },
        // notifie de la nouvelle main du joueur
        notifyHand() {
            return new Promise((resolve, reject) => {
                socket.emit('hand', { cards: this.hand });
                socket.on('hand-ok', (req) => {
                    resolve(req);
                });
            });
        },
        // notifie que la partie a commencé
        notifyGameLaunched() {
            socket.emit('game-started', { position: this.position, isIntrus: this.isIntrus });
        },
        // notifie que la partie est fini
        notifyGameStopped() {
            socket.emit('game-ended');
        },
        // notifie que les joeurs ont changé
        notifyPlayersList(players) {
            socket.emit('update-players', { players: players });
        },
        // notifie les echanges entre joueurs
        notifyPlayersTrades(trades) {
            socket.emit('new-trades', { trades: trades });
        },
        // notifie les echanges (alliance) entre joueurs
        notifyPlayerHint(message) {
            socket.emit('notify-player-hint', { message: message });
        },
        // demande au joueurs de chosir une crate et attend la reponse de la carte
        // pas de callback dans le "emit" car la lib front n'en possedait pas
        askTrade(nextPlayer) {
            cards = nextPlayer.getHand();
            return new Promise((resolve, reject) => {
                socket.emit('trade-cards', { cards: cards })
                socket.on('card-trade', (cardId) => {
                    resolve(cardId);
                });
            })
        },
        // demande au joueurs de chosir un mot et attend la reponse du mot
        // pas de callback dans le "emit" car la lib front n'en possedait pas
        askWord() {
            return new Promise((resolve, reject) => {
                socket.emit('ask-word')
                socket.on('choose-word', (word) => {
                    this.board.notifyPlayerPlayed(this.name);
                    resolve(word);
                });
            })
        },
        // demande au joueurs de chosir une carte et attend la reponse de la carte
        // pas de callback dans le "emit" car la lib front n'en possedait pas
        askCard() {
            return new Promise((resolve, reject) => {
                socket.emit('ask-card')
                socket.on('choose-card', (cardId) => {
                    resolve(cardId);
                });
            })
        },
        // demande au joueurs de chosir un joueur et attend la reponse du joueurs
        // pas de callback dans le "emit" car la lib front n'en possedait pas
        askVote(players) {
            return new Promise((resolve, reject) => {
                socket.emit('ask-vote', { players: players })
                socket.on('choose-vote', (vote) => {
                    resolve(vote);
                });
            })
        },
        // demande au joueurs de chosir un joueur et attend la reponse du joueurs
        // pas de callback dans le "emit" car la lib front n'en possedait pas
        onPlayerNotify() {
            return new Promise((resolve, reject) => {
                socket.on('notify-game-hint', (message) => {
                    resolve(message);
                });
            });
        },
    }
    return obj;
}

module.exports = createPlayer;