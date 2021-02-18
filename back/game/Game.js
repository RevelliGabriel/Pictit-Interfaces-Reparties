const Card = require('./Card');
const Deck = require('./Deck');

const createGame = (name) => {
    const obj = {
        name: name,
        // players: {},
        deck: new Deck(),
        // board: new Board(),
        board: null,
        state: 0,
        trades: [],
        words: [],
        word: "",
        players: [],
        playersCards: [],
        playerNameOut: "",
        oldPlayers: [],
        playersOut: [],
        currentPosPlayer: 0,
        intrusPosPlayer: 0,
        intrusName: "",

        addBoard(board) {
            this.board = board
            //this.board.setGame(this)
        },
        addPlayer(player) {
            if (!this.hasPlayer(player)) {
                this.players.push(player);
                player.setPosition(this.players.length - 1);
                //player.setGame(this);
                //this.board.notifyPlayersList(this.players);
                if(this.board){
                    this.board.notifyGameChange(this);
                }
                //console.log("\t--new player join the game : ", player.name)
                return true;
            }
            // //console.log("\t...player trying to join game but already in game : ", player.name)
            return false;
        },
        getCurrentPlayer() {
            return this.players[this.currentPosPlayer];
        },
        getNextPlayer() {
            return this.players[this.incrementPos(this.currentPosPlayer)];
        },
        getIntrusPlayer() {
            // //console.log("get intrus player : ", this.players[this.intrusPosPlayer].name)
            return this.players[this.intrusPosPlayer];
        },
        generateIntrus() {
            min = Math.ceil(0);
            max = Math.floor(this.players.length);
            this.intrusPosPlayer = Math.floor(Math.random() * (max - min)) + min;
            console.log("intrus pos : ", this.intrusPosPlayer);
            this.intrusName = this.getIntrusPlayer().name;
        },
        notifyGameBoard() {
            this.board.notify(this.players);
        },
        delatePlayers(name) {
            const pl = this.players.find(elem => elem.name == name); 
            if (this.intrusPosPlayer > pl.position) {
                this.intrusPosPlayer--;
            }
            this.playersOut.push(pl);
            this.players = this.players.filter(elem => elem.name != name);     
        },
        hasPlayer(player) {
            // //console.log("hasPlayer check, player :", player)
            // //console.log("hasPlayer check, players :", this.players)
            // //console.log("hasPlayer check, waiting players :", this.waitingPlayers)
            var found = false;
            for (var i = 0; i < this.players.length; i++) {
                if (this.players[i].name == player.name) {
                    found = true;
                    break;
                }
            }
            // return Object.values(this.players).find(ply => player === ply) !== -1;
            return found;
        },
        incrementPos(pos) {
            if (pos === this.players.length - 1)
                pos = 0;
            else
                pos++;
            return pos
        },
        getPlayerNameMaxVote(votes) {
            var max = 0;
            var playerName = "";
            for (var name of votes) {
                const countOccurrences = (arr, val) => arr.reduce((a, v) => (v === val ? a + 1 : a), 0);
                var n = countOccurrences(votes, name);
                if (max < n) {
                    max = n;
                    playerName = name;
                }
            }
            return playerName;
        },
        notifyAllPlayers(topic) {
            if (topic == 'game-started') {
                this.board.notifyGameChange(this);
                for (let i = 0; i < this.players.length; ++i) {
                    this.players[i].notifyGameLaunched();
                }
            } else if (topic == 'game-ended') {
                this.board.notifyGameChange(this);
                //console.log(this.oldPlayers);
                for (let i = 0; i < this.oldPlayers.length; ++i) {
                    this.oldPlayers[i].notifyGameStopped();
                }
            } else if (topic == 'new-hands') {
                for (let i = 0; i < this.players.length; ++i) {
                    this.players[i].notifyHand();
                }
            } else if (topic == 'new-word') {
                this.board.notifyGameChange(this);
                return Promise.all(this.players.map(player => player.notifyWord(this.word)));
                // for (let i = 0; i < this.players.length; ++i) {
                //     this.players[i].notifyWord(this.word);
                // }
            } else if (topic == 'player-out') {
                this.board.notifyGameChange(this);
                for (let i = 0; i < this.players.length; ++i) {
                    this.players[i].notifyPlayerOut(this.playerNameOut);
                }
                this.delatePlayers(this.playerNameOut);
            }
            return true;
        },
        askTrades() {
            return this.getCurrentPlayer().askTrade(this.getNextPlayer()).then(cardId => {
                var trade = {
                    player: this.getCurrentPlayer(),
                    playerToSteal: this.getNextPlayer(),
                    cardToSteal: cardId,
                }
                this.trades.push(trade);
            });
        },
        // askWord(player) {
        //     return player.askWord().then(word => {
        //         this.words.push(word);
        //     });
        // },
        async tradeCardsOneByOne() {
            // await this.forwardBeginTrade();
            while (true) {
                await this.askTrades();
                this.currentPosPlayer = this.incrementPos(this.currentPosPlayer);
                if (this.currentPosPlayer === 0)
                    break;
            }
            this.setNewCardsToPlayers();
            return this.notifyAllPlayers('new-hands');
        },
        async chooseWord() {
            // await this.forwardBeginCall();
            // while(true) {
            //     await this.askWord();
            //     this.currentPosPlayer = this.incrementPos(this.currentPosPlayer);
            //     if (this.currentPosPlayer === 0)
            //         break;
            // }
            return Promise.all(this.players.map(player => player.askWord())).then((values) => {
                this.words = values;
                //console.log("Players words : ", this.words)
                this.setNewWordToGame();
                return this.notifyAllPlayers('new-word');
            });
        },
        async playUntilSomeoneWin() {
            while (true) {
                // playturn
                this.state = 4;
                this.board.notifyGameChange(this);
                await this.playOneTrun();
                console.log("Voici le player OUT", this.playerNameOut);
                //if (this.playerNameOut.isIntrus) {
                if (this.playerNameOut == this.intrusName){
                    // this.players[this.intrusPosPlayer].askLastWord();
                    // fin du jeu
                    console.log("fin du jeu, l'intrus a été éliminé : ", this.playerNameOut);
                    break;
                } else if (this.players.length == 2) {
                    // un joueur a gagné
                    // fin du jeu
                    console.log("fin du jeu, l'intrus a gagné");
                    break;
                }
                console.log("nouveau tour");
            }
            console.log("fin partie");
            return true;
        },
        async playOneTrun() {
            console.log('\n position du premier joeur a jouer le tour : ', this.currentPosPlayer)
            for (let player of this.players) {
                //console.log("\ndebut du tour de", player.name)
                this.board.notifyGameChange(this);
                let cardId = await player.askCard();
                let card = player.hand.find(elem => elem.id == cardId)
                player.hand = player.hand.filter(card => card.id != cardId)
                this.playersCards[this.currentPosPlayer] = card;
                player.notifyHand();
                this.currentPosPlayer = this.incrementPos(this.currentPosPlayer);
                console.log("fin du tour de", player.name)
                console.log('\n etat des cartes joueés : ', this.playersCards)
            }
            console.log('\n position du current player avant vote : ', this.currentPosPlayer)
            this.state = 5;
            this.board.notifyGameChange(this);
            return this.askVotes();
        },
        askVotes() {
            return Promise.all(this.players.map(player => player.askVote(this.players))).then((votes) => {
                console.log("Players votes : ", votes);
                // compute votes and determine player
                // this.setNewWordToGame();
                // this.getIndexPlayerMaxVote();
                this.playerNameOut = this.getPlayerNameMaxVote(votes);
                return this.notifyAllPlayers('player-out');
            });
        },
        setNewCardsToPlayers() {
            for (let trade of this.trades) {
                _player = trade.player;
                _otherPlayer = trade.playerToSteal;
                cardId = trade.cardToSteal
                //console.log('Old cards for players : ')
                //console.log(_player.name, " : ", _player.hand)
                //console.log(_otherPlayer.name, " : ", _otherPlayer.hand)
                _player.hand.push(new Card(trade.cardToSteal))
                _otherPlayer.hand = _otherPlayer.hand.filter(card => { return card.id != cardId })
                //console.log('New cards for players : ')
                //console.log(_player.name, " : ", _player.hand)
                //console.log(_otherPlayer.name, " : ", _otherPlayer.hand)
            }
        },
        setNewWordToGame() {
            min = Math.ceil(0);
            max = Math.floor(this.words.length - 1);
            this.word = this.words[Math.floor(Math.random() * (max - min)) + min];
        },
        distribute() {
            const hands = this.deck.cutIn4();
            const promises = [];
            //console.log('Melange ok, envoie des cartes aux joueurs')
            for (let i = 0; i < this.players.length; ++i) {
                promises.push(this.players[i].setHand(hands[i]));
            }
            return Promise.all(promises);
        },
        canStart() {
            return this.players.length === 4 && this.board != null;
        },
        launch() {
            //console.log('\nAll players are ready, the game is launched !!');
            //console.log('\t\t', this.name, " started..!");
            this.oldPlayers = [...this.players];
            this.generateIntrus();
            this.players[this.intrusPosPlayer].isIntrus = true;
            console.log("L'intrus est : ", this.players[this.intrusPosPlayer]);
            //console.log("\nDebut de la distribution");
            return this.distribute().then(resp => {
                this.state = 1;
                this.notifyAllPlayers('game-started');
                //console.log("Fin de la distribution");
                //console.log("\nDebut des trades");
                this.state = 2;
                this.board.notifyGameChange(this);
                return this.tradeCardsOneByOne();
            }).then(resp => {
                //console.log("Fin des trades");
                //console.log("\nDebut des choix de mots");
                this.state = 3;
                this.board.notifyGameChange(this);
                return this.chooseWord();
            }).then(resp => {
                //console.log("Fin des mots");
                //console.log("\nDebut du jeu");
                this.state = 4;
                return this.playUntilSomeoneWin();
            }).then(resp => {
                this.state = 6;
                this.notifyAllPlayers('game-ended');
                this.board.notifyGameChange(this);
                //console.log("FIN DU JEU");
            })
            //distribuer les cartes
            //chaque joueur peut choisir une carte au voisin de droite (en voyant on jeu)
        }
    }
    return obj;
};

module.exports = createGame;