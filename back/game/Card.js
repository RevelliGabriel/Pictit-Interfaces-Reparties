const assets = {
    "0": "Card0.jpg",
    "1": "Card1.jpg",
    "2": "Card2.jpg",
    "3": "Card3.jpg",
    "4": "Card4.jpg",
    "5": "Card5.jpg",
    "6": "Card6.jpg",
    "7": "Card7.jpg",
    "8": "Card8.jpg",
    "9": "Card9.jpg",
    "10": "Card10.jpg",
    "11": "Card11.jpg",
    "12": "Card12.jpg",
    "13": "Card13.jpg",
    "14": "Card14.jpg",
    "15": "Card15.jpg",
}

module.exports = class Card {
    constructor(id) {
        this.id = id;
        this.path = assets[id];
        console.log("\t\tgenerate card : ", this.path)
    }

};