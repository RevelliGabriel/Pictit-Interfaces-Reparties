const Deck = require('./Deck');

const createGame = (name) => {
    const obj = {
        name: name,
        // players: {},
        deck: new Deck(),
        // board: new Board(),
        board: null,
        trades: [],
        players: [],
        currentPosPlayer: 0,
        intrusPosPlayer: 0,

        addPlayer(player) {
            if (!this.hasPlayer(player)) {
                // this.players[player.name] = player;
                this.players.push(player);
                player.setPosition(this.players.length-1);
                console.log("\t--new player join the game : ", player.name)
                player.setGame(this);
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
            if (pos === player.length - 1)
                pos = 0;
            else
                pos++;
            return pos
        },
        async askCards() {
            return this.getCurrentPlayer().askTrade(this.incrementPos(this.currentPosPlayer)).then(trade => {
                this.trades.push(trade);
                return this.forwardCards(trade);
            });
        },
        tradeCardsOneByOne(){
            //await this.forwardBeginTrade();
            while(true) {
                // const res = await this.askCards();
                this.currentPosPlayer = this.incrementPos(this.currentPosPlayer);
                if (this.currentPosPlayer === 0)
                    break;
            }
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
            return this.players.length === 4;
        },
        getCurrentPlayer() {
            return this.players[this.currentPosPlayer];
        },
        getIntrusPlayer() {
            // console.log("get intrus player : ", this.players[this.intrusPosPlayer].name)
            return this.players[this.intrusPosPlayer];
        },
        generateIntrus() {
            min = Math.ceil(0);
            max = Math.floor(3);
            this.intrusPosPlayer = Math.floor(Math.random() * (max - min)) + min;
            console.log("intrus pos : ", this.intrusPosPlayer)
        },
        launch() {
            console.log('\nAll players are ready, the game is launched !!');
            console.log('\t\t', this.name, " started..!");
            this.generateIntrus();
            this.getIntrusPlayer().setIntrus();
            console.log("L'intrus est : ", this.getIntrusPlayer().name)
            console.log("\nDebut de la distribution")
            return this.distribute().then(resp => {
                console.log("Fin de la distribution")
                console.log("\nDebut des trades")
                this.tradeCardsOneByOne()
            }).then(resp => {
                // le jeu
            })
            //distribuer les cartes
            //chaque joueur peut choisir une carte au voisin de droite (en voyant on jeu)
        }
    }
    return obj;
};

module.exports = createGame;