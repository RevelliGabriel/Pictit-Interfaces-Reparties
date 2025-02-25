const Card = require('./Card');
const Deck = require('./Deck');

const createGame = (name) => {
    const obj = {
        name: name, // nom de la partie
        deck: new Deck(), // ensemble des cartes
        board: null, // l'objet board
        state: 0, // etat courant de la phase du jeu
        trades: [], // ensemble des echanges de cartes
        words: [], // ensemble des mots proposés
        word: "", // le mot choisi
        players: [], // les joueurs en jeu
        playersCards: [], // les crates deposé à chaque tours
        playerNameOut: "", // nom du dernier joueur elimine
        oldPlayers: [], // liste de joueurs de base, avant que le jeu commence
        playersOut: [], // liste de joueurs éliminé
        playersPlay: [], // liste des joeurs ayant joué à chaque tour
        currentPosPlayer: 0, // position du joeur courant
        intrusPosPlayer: 0, // position de l'intru 
        intrusName: "", // nom de l'intrus

        addBoard(board) {
            this.board = board
        },
        addPlayer(player) {
            if (!this.hasPlayer(player)) {
                this.players.push(player);
                player.setPosition(this.players.length - 1);
                if (this.board) {
                    this.board.notifyGameChange(this);
                }
                return true;
            }
            return false;
        },
        getCurrentPlayer() {
            return this.players[this.currentPosPlayer];
        },
        getNextPlayer() {
            return this.players[this.incrementPos(this.currentPosPlayer)];
        },
        getIntrusPlayer() {
            return this.players[this.intrusPosPlayer];
        },
        generateIntrus() {
            min = Math.ceil(0);
            max = Math.floor(this.players.length);
            this.intrusPosPlayer = Math.floor(Math.random() * (max - min)) + min;
            console.log("intrus pos : ", this.intrusPosPlayer);
            this.intrusName = this.getIntrusPlayer().name;
        },
        // associe la board au joueur
        associatePlayers() {
            for (let i = 0; i < this.players.length; ++i) {
                this.associatePlayer(this.players[i]);
                this.players[i].setBoard(this.board);
            }
        },
        // fonction recusursive d'ecoute d'un canal socketIO
        // utilisé pour la communication type alliance
        associatePlayer(player) {
            player.onPlayerNotify().then((message) => {
                let index = this.players.findIndex((pl) => pl.name === message.playerName)
                this.players[index].notifyPlayerHint(message)
                this.associatePlayer(player);
            });
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
            var found = false;
            for (var i = 0; i < this.players.length; i++) {
                if (this.players[i].name == player.name) {
                    found = true;
                    break;
                }
            }
            return found;
        },
        incrementPos(pos) {
            if (pos === this.players.length - 1)
                pos = 0;
            else
                pos++;
            return pos
        },
        // retourne le nom du joueur quia  recu le plus de vote
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
        // permet de notifier tous les joeurs sur un topic donné
        notifyAllPlayers(topic) {
            if (topic == 'game-started') {
                this.board.notifyGameChange(this);
                for (let i = 0; i < this.players.length; ++i) {
                    this.players[i].notifyGameLaunched();
                }
            } else if (topic == 'game-ended') {
                this.board.notifyGameChange(this);
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
            } else if (topic == 'player-out') {
                this.board.notifyGameChange(this);
                for (let i = 0; i < this.players.length; ++i) {
                    this.players[i].notifyPlayerOut(this.playerNameOut);
                    this.players[i].notifyPlayersList(this.players);
                }
                this.delatePlayers(this.playerNameOut);
            } else if (topic == 'notify-players-list') {
                for (let i = 0; i < this.players.length; ++i) {
                    this.players[i].notifyPlayersList(this.players)
                }
            } else if (topic == 'new-trades') {
                for (let i = 0; i < this.players.length; ++i) {
                    this.players[i].notifyPlayersTrades(this.trades)
                }
            }
            return true;
        },
        // demande a chaque joueur de choisir une carte
        // dans la main d'un adversaire et stocke le resultat
        askTrades() {
            return this.getCurrentPlayer().askTrade(this.getNextPlayer()).then(cardId => {
                var trade = {
                    player: this.getCurrentPlayer(),
                    playerToSteal: this.getNextPlayer(),
                    cardToSteal: cardId,
                }
                this.trades.push(trade);
                this.playersPlay.push(this.getCurrentPlayer().name);
                this.board.notifyGameChange(this);
            });
        },
        // fonction de lancement des echnages de cartes
        async tradeCardsOneByOne() {
            while (true) {
                await this.askTrades();
                this.currentPosPlayer = this.incrementPos(this.currentPosPlayer);
                if (this.currentPosPlayer === 0)
                    break;
            }
            this.playersPlay = [];
            this.setNewCardsToPlayers();
            this.notifyAllPlayers('new-trades')
            return this.notifyAllPlayers('new-hands');
        },
        // fonction de choix d'un mot pour tous les joueurs
        async chooseWord() {
            return Promise.all(this.players.map(player => player.askWord().then((value) => {
                this.playersPlay.push(player.name);
                this.board.notifyGameChange(this);
                return value;
            }))).then((values) => {
                this.words = values;
                this.playersPlay = [];
                this.setNewWordToGame();
                return this.notifyAllPlayers('new-word');
            });
        },
        // Fonction de jeu principale, qui lance un tour de jeu tant que cela est possible
        async playUntilSomeoneWin() {
            while (true) {
                this.state = 4;
                this.board.notifyGameChange(this);
                await this.playOneTrun();
                console.log("Voici le player OUT", this.playerNameOut);
                if (this.playerNameOut == this.intrusName) {
                    // fin du jeu
                    console.log("fin du jeu, l'intrus a été éliminé : ", this.playerNameOut);
                    break;
                } else if (this.players.length == 2) {
                    // l'intrus a gagné
                    // fin du jeu
                    console.log("fin du jeu, l'intrus a gagné");
                    break;
                }
                console.log("nouveau tour");
            }
            console.log("fin partie");
            return true;
        },
        // joue un tour, demande une carte a chaque joueur
        async playOneTrun() {
            console.log('\n position du premier joueur a jouer le tour : ', this.currentPosPlayer)
            for (let player of this.players) {
                console.log("\ndebut du tour de", player.name)
                this.board.notifyGameChange(this);
                let cardId = await player.askCard();
                let card = player.hand.find(elem => elem.id == cardId)
                player.hand = player.hand.filter(card => card.id != cardId)
                this.playersCards[this.currentPosPlayer] = card;
                player.notifyHand();
                this.currentPosPlayer = this.incrementPos(this.currentPosPlayer);
                console.log("fin du tour de", player.name)
                console.log('\n etat des cartes joueés : ', this.playersCards)
                this.playersPlay.push(player.name);
            }
            console.log('\n position du current player avant vote : ', this.currentPosPlayer)
            this.playersPlay = [];
            this.state = 5;
            this.board.notifyGameChange(this);
            return this.askVotes();
        },
        // demande les votes à chaque joueurs
        askVotes() {
            return Promise.all(this.players.map(player => player.askVote(this.players))).then((votes) => {
                console.log("Players votes : ", votes);
                this.playerNameOut = this.getPlayerNameMaxVote(votes);
                return this.notifyAllPlayers('player-out');
            });
        },
        // associe les nouvelles cartes aux joueurs apres les echanges
        setNewCardsToPlayers() {
            for (let trade of this.trades) {
                _player = trade.player;
                _otherPlayer = trade.playerToSteal;
                cardId = trade.cardToSteal
                _player.hand.push(new Card(trade.cardToSteal))
                _otherPlayer.hand = _otherPlayer.hand.filter(card => { return card.id != cardId })
            }
        },
        // selection aleatoire du mot
        setNewWordToGame() {
            min = Math.ceil(0);
            max = Math.floor(this.words.length - 1);
            this.word = this.words[Math.floor(Math.random() * (max - min)) + min];
        },
        // distribution des cartes a chaque joueurs
        distribute() {
            const hands = this.deck.cutIn4();
            const promises = [];
            for (let i = 0; i < this.players.length; ++i) {
                promises.push(this.players[i].setHand(hands[i]));
            }
            return Promise.all(promises);
        },
        canStart() {
            return this.players.length === 4 && this.board != null;
        },
        // equivalent du main de la partie
        // permet de gerer la logique d'enchainement des phases du jeu
        // met à jour le state à chaque phase
        launch() {
            this.oldPlayers = [...this.players];
            this.associatePlayers();
            this.generateIntrus();
            this.notifyAllPlayers('notify-players-list')
            this.players[this.intrusPosPlayer].isIntrus = true;
            console.log("L'intrus est : ", this.players[this.intrusPosPlayer]);
            console.log("\nDebut de la distribution");
            return this.distribute().then(resp => {
                this.state = 1;
                this.notifyAllPlayers('game-started');
                console.log("Fin de la distribution");
                console.log("\nDebut des trades");
                this.state = 2;
                this.board.notifyGameChange(this);
                return this.tradeCardsOneByOne();
            }).then(resp => {
                console.log("Fin des trades");
                console.log("\nDebut des choix de mots");
                this.state = 3;
                this.board.notifyGameChange(this);
                return this.chooseWord();
            }).then(resp => {
                console.log("Fin des mots");
                console.log("\nDebut du jeu");
                this.state = 4;
                return this.playUntilSomeoneWin();
            }).then(resp => {
                this.state = 6;
                this.notifyAllPlayers('game-ended');
                this.board.notifyGameChange(this);
                console.log("FIN DU JEU");
            })
        }
    }
    return obj;
};

module.exports = createGame;