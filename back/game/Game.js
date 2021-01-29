const createGame = (name) => {
    const obj = {
        name: name,
        // players: {},
        players: [],
        currentPosPlayer: 0,
        intrusPosPlayer: 0,

        addPlayer(player) {
            if (!this.hasPlayer(player)) {
                // this.players[player.name] = player;
                this.players.push(player);
                console.log("\t--new player join the game : ", player.name)
                //player.setGame(this);
                return true;
            }
            // console.log("\t...player trying to join game but already in game : ", player.name)
            return false;
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

        canStart() {
            return this.players.length === 2;
        },
        getCurrentPlayer() {
            return this.currentPosPlayer;
        },
        getIntrusPlayer() {
            return this.intrusPosPlayer;
        },
        generateItrus() {
            //math random in game.player.lenght
        },
        launch() {
            console.log('\nAll players are ready, the game is launched !!');
            console.log('\t\t', this.name, " started..!");
            this.generateItrus();

            //distribuer les cartes
            //chaque joueur peut choisir une carte au voisin de droite (en voyant on jeu)
        }
    }
    return obj;
};

module.exports = createGame;