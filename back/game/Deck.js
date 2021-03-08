const Card = require('./Card');

module.exports = class Deck {
    constructor() {
        this.deck = [];
        for (let i = 0; i < 16; ++i) {
            this.deck.push(new Card(i));
        }
    }

    shuffle() {
        for (let i = this.deck.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [this.deck[i], this.deck[j]] = [this.deck[j], this.deck[i]];
        }
    }

    cutIn4() {
        this.shuffle();
        let posCards = 0;
        const hands = []
        for (let i = 0; i < 4; ++i) {
            const hand = this.deck.slice(posCards, posCards + 4)
            hands.push(hand);
            posCards += 4;
        }
        return hands;
    }
}