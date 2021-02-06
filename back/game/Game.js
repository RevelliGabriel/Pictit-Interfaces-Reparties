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
        currentPosPlayer: 0,
        intrusPosPlayer: 0,

        addBoard(board){
            this.board = board
            //this.board.setGame(this)
        },
        addPlayer(player) {
            if (!this.hasPlayer(player)) {
                this.players.push(player);
                player.setPosition(this.players.length-1);
                //player.setGame(this);
                //this.board.notifyPlayersList(this.players);
                this.board.notifyGameChange(this)
                console.log("\t--new player join the game : ", player.name)
                return true;
            }
            // console.log("\t...player trying to join game but already in game : ", player.name)
            return false;
        },
        notifyGameBoard(){
            this.board.notify(this.players)
        },
        deletePlayer(player) {
            delete this.players[player.position];
        },
        hasPlayer(player) {
            // console.log("hasPlayer check, player :", player)
            // console.log("hasPlayer check, players :", this.players)
            // console.log("hasPlayer check, waiting players :", this.waitingPlayers)
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
        notifyAllPlayers(topic){
            if (topic == 'game-started'){
                this.board.notifyGameChange(this);
                for (let i = 0; i < this.players.length; ++i) {
                    this.players[i].notifyGameLaunched();
                }
            } else if (topic == 'new-hands'){
                for (let i = 0; i < this.players.length; ++i) {
                    this.players[i].notifyHand();
                }
            } else if (topic == 'new-word'){
                this.board.notifyGameChange(this);
                for (let i = 0; i < this.players.length; ++i) {
                    this.players[i].notifyWord(this.word);
                }
            }
            return true;
        },
        askCards() {
            return this.getCurrentPlayer().askTrade(this.getNextPlayer()).then(cardId => {
                var trade = {
                    player : this.getCurrentPlayer(),
                    playerToSteal: this.getNextPlayer(),
                    cardToSteal : cardId,
                }
                this.trades.push(trade);
            });
        },
        // askWord(player) {
        //     return player.askWord().then(word => {
        //         this.words.push(word);
        //     });
        // },
        async tradeCardsOneByOne(){
            // await this.forwardBeginTrade();
            while(true) {
                await this.askCards();
                this.currentPosPlayer = this.incrementPos(this.currentPosPlayer);
                if (this.currentPosPlayer === 0)
                    break;
            }
            this.setNewCardsToPlayers();
            return this.notifyAllPlayers('new-hands');
        },
        async chooseWord(){
            // await this.forwardBeginCall();
            // while(true) {
            //     await this.askWord();
            //     this.currentPosPlayer = this.incrementPos(this.currentPosPlayer);
            //     if (this.currentPosPlayer === 0)
            //         break;
            // }
            Promise.all(this.players.map(player => player.askWord())).then((values) => {
                this.words = values;
                console.log("Players words : ", this.words)
                this.setNewWordToGame();
                return this.notifyAllPlayers('new-word');
            });
        },
        setNewCardsToPlayers(){
            for(let trade of this.trades){
                _player = trade.player;
                _otherPlayer = trade.playerToSteal;
                cardId = trade.cardToSteal
                console.log('Old cards for players : ')
                console.log(_player.name, " : ", _player.hand)
                console.log(_otherPlayer.name, " : ", _otherPlayer.hand)
                _player.hand.push(new Card(trade.cardToSteal))
                _otherPlayer.hand = _otherPlayer.hand.filter(card => {return card.id != cardId})
                console.log('New cards for players : ')
                console.log(_player.name, " : ", _player.hand)
                console.log(_otherPlayer.name, " : ", _otherPlayer.hand)
            }
        },
        setNewWordToGame(){
            min = Math.ceil(0);
            max = Math.floor(this.words.length-1);
            this.word = this.words[Math.floor(Math.random() * (max - min)) + min];
        },
        distribute() {
            const hands = this.deck.cutIn4();
            const promises = [];
            console.log('Melange ok, envoie des cartes aux joueurs')
            for (let i = 0; i < this.players.length; ++i) {
                promises.push(this.players[i].setHand(hands[i]));
            }
            return Promise.all(promises);
        },
        canStart() {
            return this.players.length === 2 && this.board != null;
        },
        getCurrentPlayer() {
            return this.players[this.currentPosPlayer];
        },
        getNextPlayer() {
            return this.players[this.incrementPos(this.currentPosPlayer)];
        },
        getIntrusPlayer() {
            // console.log("get intrus player : ", this.players[this.intrusPosPlayer].name)
            return this.players[this.intrusPosPlayer];
        },
        generateIntrus() {
            min = Math.ceil(0);
            max = Math.floor(this.players.length-1);
            this.intrusPosPlayer = Math.floor(Math.random() * (max - min)) + min;
            console.log("intrus pos : ", this.intrusPosPlayer)
        },
        launch() {
            console.log('\nAll players are ready, the game is launched !!');
            console.log('\t\t', this.name, " started..!");
            this.generateIntrus();
            this.getIntrusPlayer().setIntrus();
            console.log("L'intrus est : ", this.getIntrusPlayer().name);
            this.state = 1;
            this.notifyAllPlayers('game-started');
            console.log("\nDebut de la distribution");
            return this.distribute().then(resp => {
                console.log("Fin de la distribution");
                console.log("\nDebut des trades");
                this.state = 2;
                return this.tradeCardsOneByOne();
            }).then(resp => {
                console.log("Fin des trades");
                console.log("\nDebut des choix de mots");
                this.state = 3;
                return this.chooseWord();
            }).then(resp => {
                console.log("Fin des mots");
                console.log("\nDebut du jeu");
                this.state = 4;
                
            })
            //distribuer les cartes
            //chaque joueur peut choisir une carte au voisin de droite (en voyant on jeu)
        }
    }
    return obj;
};

module.exports = createGame;